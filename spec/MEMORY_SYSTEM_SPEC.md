# 叽里咕噜 — 记忆系统设计 MEMORY_SYSTEM_SPEC.md

> 版本: v2.0 | 关联: [AI_PERSONA_SPEC.md](./AI_PERSONA_SPEC.md) | 面向: 后端/AI开发

---

## 一、记忆系统总览

叽叽的记忆系统是产品的核心壁垒之一。它让AI鹦鹉"记住"用户的学习历史、偏好、习惯，实现个性化教学和情感连接。

```
┌────────────────────────────────────────────────┐
│                  记忆系统 Memory System           │
│                                                  │
│  ┌──────────┐  ┌──────────┐  ┌──────────────┐  │
│  │ 短期记忆   │  │ 长期记忆   │  │ 学习记忆(SRS) │  │
│  │ Session   │  │ Profile  │  │ Vocabulary   │  │
│  │ Memory    │  │ Memory   │  │ Memory       │  │
│  └──────────┘  └──────────┘  └──────────────┘  │
│       │              │              │            │
│       ▼              ▼              ▼            │
│  ┌──────────────────────────────────────────┐   │
│  │        Prompt Context Builder             │   │
│  │    组装注入LLM的上下文信息                    │   │
│  └──────────────────────────────────────────┘   │
└────────────────────────────────────────────────┘
```

---

## 二、短期记忆（Session Memory）

**作用域**：单次对话会话内  
**存储**：Redis（会话结束后持久化到PostgreSQL）  
**生命周期**：对话开始 → 对话结束

```python
class SessionMemory:
    """单次对话的实时记忆"""
    
    session_id: str
    user_id: str
    scene_id: str
    started_at: datetime
    
    # 本轮对话历史（最近20轮）
    messages: list[Message]  # [{"role": "user/assistant", "content": "...", "timestamp": ...}]
    
    # 本轮教学进度
    phrases_taught: list[str]       # 本轮已教的表达 ["I'd like some", "How much"]
    phrases_practiced: list[str]    # 用户已练习的表达
    phrases_mastered: list[str]     # 本轮用户掌握的（正确2次以上）
    
    # 本轮发音评估
    pronunciation_scores: list[dict]  # [{"phrase": "apple", "score": 75, "attempt": 2}]
    
    # 实时难度状态
    current_difficulty: float        # 0.0-1.0
    success_rate: float              # 本轮正确率
    
    # 情感状态追踪
    user_mood: str                   # "engaged" / "struggling" / "bored" / "frustrated"
    encouragement_count: int         # 本轮鼓励次数
    
    def to_prompt_context(self) -> str:
        """转化为注入LLM的上下文"""
        return f"""
## 本轮对话状态
- 场景：{self.scene_id}
- 已教表达：{', '.join(self.phrases_taught)}
- 用户掌握情况：正确率 {self.success_rate:.0%}
- 用户状态：{self.user_mood}
- 还可以教的新表达数量：{3 - len(self.phrases_taught)}
"""
```

---

## 三、长期记忆（Profile Memory）

**作用域**：跨会话持久化  
**存储**：PostgreSQL  
**更新时机**：每次对话结束后自动更新

```python
class UserProfile:
    """用户长期画像"""
    
    user_id: str
    nickname: str                    # "王阿姨"
    gender: str                      # 确定称呼用"阿姨"还是"叔叔"
    
    # ── 学习偏好 ──
    preferred_time: str              # 通常活跃时间段 "09:00-10:00"
    preferred_session_length: int    # 偏好对话时长（分钟）
    learning_style: str              # "slow_and_steady" / "adventurous"
    motivation: str                  # "travel" / "family_abroad" / "brain_exercise"
    
    # ── 个人背景 ──
    english_level: str               # "zero" / "beginner" / "elementary"
    dialect_region: str              # 方言区域，影响ASR配置
    travel_plans: str                # "下月去泰国" → 影响场景推荐
    family_abroad: str               # "女儿在美国" → 影响场景推荐
    
    # ── 学习统计 ──
    total_sessions: int              # 总对话次数
    total_minutes: int               # 总学习分钟数
    total_phrases_learned: int       # 总学习短语数
    current_streak: int              # 连续学习天数
    longest_streak: int              # 最长连续天数
    first_session_date: date
    last_session_date: date
    
    # ── 情感记忆 ──
    favorite_scenes: list[str]       # 最喜欢的场景
    frustration_triggers: list[str]  # 容易受挫的内容类型
    humor_appreciation: float        # 对幽默的接受度 0-1
    
    # ── 叽叽的个人记忆 ──
    # 让鹦鹉记住关于用户的具体事情，增强情感连接
    personal_notes: list[dict]       # [{"note": "阿姨说下月要去泰国", "date": "2026-03-01"}]
    
    def to_prompt_context(self) -> str:
        return f"""
## 用户画像
- 称呼：{self.nickname}（{self.gender}）
- 英语水平：{self.english_level}
- 学习动机：{self.motivation}
- 已学习{self.total_sessions}次，掌握{self.total_phrases_learned}个表达
- 连续学习{self.current_streak}天
- 偏好：{self.learning_style}
- 个人备忘：{self._format_personal_notes()}
"""
```

### 个人记忆自动提取

每次对话结束后，用LLM从对话历史中自动提取值得记住的信息：

```python
MEMORY_EXTRACTION_PROMPT = """
从以下对话中提取值得记住的用户个人信息。只提取明确提到的事实，不要推测。

需要提取的信息类型：
- 旅行计划（去哪里、什么时候）
- 家庭情况（子女在哪里、孙子多大）
- 兴趣爱好
- 生活习惯
- 对某个话题的特别反应（喜欢或不喜欢）

对话内容：
{conversation_transcript}

请用JSON格式返回，如果没有新信息则返回空列表：
[{"category": "travel_plan", "note": "计划下月去泰国清迈", "confidence": 0.9}]
"""
```

---

## 四、学习记忆（Vocabulary Memory + SRS）

### 4.1 间隔重复算法（Spaced Repetition System）

采用改良版SM-2算法，针对老年用户特点：重复间隔比标准算法更短（老年人遗忘更快）。

```python
class SRSEngine:
    """间隔重复引擎 — 老年人专属版"""
    
    # 老年人版间隔（比标准SM-2短30-50%）
    INTERVALS = {
        0: 0,        # 新词：当天复习
        1: 1,        # 1天后
        2: 3,        # 3天后（标准SM-2: 6天）
        3: 7,        # 7天后（标准SM-2: 15天）
        4: 14,       # 14天后（标准SM-2: 30天）
        5: 30,       # 30天后
    }
    
    def calculate_next_review(self, item: VocabItem, quality: int) -> VocabItem:
        """
        quality: 0-5的评分
          5: 完全记住，发音很好
          4: 记住了，发音有小瑕疵
          3: 想了一会儿才记起来
          2: 需要提示才记起来
          1: 即使提示也只模糊记得
          0: 完全忘记
        """
        if quality >= 3:
            # 记住了，提升level
            item.level = min(item.level + 1, 5)
            item.next_review = date.today() + timedelta(days=self.INTERVALS[item.level])
        else:
            # 忘记了，重置到level 1（不重置到0，避免挫败感）
            item.level = max(1, item.level - 1)
            item.next_review = date.today() + timedelta(days=1)
        
        item.last_reviewed = date.today()
        item.review_count += 1
        return item
    
    def get_review_phrases(self, user_id: str, scene_id: str, limit: int = 3) -> list:
        """获取需要在当前场景中复习的短语"""
        due_items = VocabItem.query.filter(
            VocabItem.user_id == user_id,
            VocabItem.next_review <= date.today(),
        ).order_by(VocabItem.next_review.asc()).limit(limit).all()
        
        return due_items
```

### 4.2 词汇数据模型

```python
class VocabItem:
    id: str
    user_id: str
    
    # 词汇信息
    english: str                     # "I'd like some"
    chinese: str                     # "我想要一些"
    phonetic: str                    # "/aɪd laɪk sʌm/"
    chinese_phonetic: str            # "爱的 来克 撒姆"
    scene_origin: str                # 首次学习的场景ID
    
    # SRS状态
    level: int = 0                   # 0-5
    next_review: date
    last_reviewed: date | None
    review_count: int = 0
    
    # 学习记录
    first_learned: datetime
    times_correct: int = 0
    times_incorrect: int = 0
    best_pronunciation_score: float = 0
    
    # 复现记录
    scenes_used_in: list[str]        # 在哪些场景中使用过
```

### 4.3 自然复现策略

不让用户感觉在"做复习题"，而是在新场景中自然带出旧词汇：

```python
class NaturalReviewStrategy:
    """在新场景对话中自然复现需要复习的词汇"""
    
    def inject_review_phrases(self, scene_prompt: str, review_phrases: list) -> str:
        """将需要复习的词汇注入场景Prompt"""
        if not review_phrases:
            return scene_prompt
        
        review_instruction = f"""
## 自然复习要求
请在本场景对话中，自然地使用以下用户之前学过的表达（不要刻意复习，而是在场景中自然带出）：
{chr(10).join(f'- {p.english}（{p.chinese}）' for p in review_phrases)}

例如，如果本场景是"餐厅点菜"，而复习词汇包含"How much"，可以在点完菜后自然地说：
"点好菜了！还记得怎么问价格吗？How much——上次买水果的时候学的！"
"""
        return scene_prompt + review_instruction
```

---

## 五、上下文组装器（Prompt Context Builder）

```python
class PromptContextBuilder:
    """将三种记忆组装成LLM可用的prompt上下文"""
    
    def build(self, session: Session) -> str:
        context_parts = []
        
        # 1. 用户画像（长期记忆）
        context_parts.append(session.user.profile.to_prompt_context())
        
        # 2. 学习历史摘要
        context_parts.append(self._build_learning_summary(session.user))
        
        # 3. 当前场景信息
        context_parts.append(session.current_scene.to_prompt_context())
        
        # 4. 需要复习的词汇
        review_phrases = self.srs_engine.get_review_phrases(
            session.user.id, 
            session.current_scene.id
        )
        if review_phrases:
            context_parts.append(self._format_review_phrases(review_phrases))
        
        # 5. 本轮对话状态（短期记忆）
        context_parts.append(session.memory.to_prompt_context())
        
        return "\n\n".join(context_parts)
    
    def _build_learning_summary(self, user) -> str:
        recent_vocab = user.get_recent_vocabulary(days=7)
        weak_areas = user.get_weak_areas()
        
        return f"""
## 学习历史摘要
- 最近7天学习的表达：{', '.join(v.english for v in recent_vocab[:10])}
- 薄弱领域：{', '.join(weak_areas)}
- 上次对话的场景：{user.last_scene_id}
- 上次学习的表达：{', '.join(user.last_phrases_learned)}
"""
```

---

## 六、子女端数据聚合

```python
class FamilyDashboardData:
    """子女仪表盘所需的聚合数据"""
    
    @staticmethod
    def generate_weekly_report(user_id: str) -> WeeklyReport:
        sessions = Session.query.filter(
            Session.user_id == user_id,
            Session.created_at >= week_start()
        ).all()
        
        return WeeklyReport(
            total_sessions=len(sessions),
            total_minutes=sum(s.duration_minutes for s in sessions),
            new_phrases_learned=count_new_phrases(user_id, week_start()),
            favorite_scene=most_frequent_scene(sessions),
            streak=User.get(user_id).current_streak,
            pet_growth=PetSystem.get_growth_summary(user_id),
            # 生成自然语言摘要
            summary=f"妈妈这周和叽叽聊了{len(sessions)}次，"
                    f"学了{count_new_phrases(user_id, week_start())}个新表达，"
                    f"最喜欢的场景是{most_frequent_scene(sessions).name}！"
                    f"已连续学习{User.get(user_id).current_streak}天 🎉",
            # 分享卡片数据
            shareable_card=generate_share_card(user_id),
        )
```

---

## 七、宠物成长系统

```python
class PetGrowthSystem:
    """鹦鹉成长系统 — 由学习行为驱动"""
    
    STAGES = {
        1: {"name": "蛋蛋期", "xp_required": 0, "description": "毛茸茸的小蛋"},
        2: {"name": "毛球期", "xp_required": 100, "description": "破壳而出的小毛球"},
        3: {"name": "雏鸟期", "xp_required": 300, "description": "开始长出小翅膀"},
        4: {"name": "学飞期", "xp_required": 600, "description": "翅膀变大，尝试飞翔"},
        5: {"name": "彩羽期", "xp_required": 1000, "description": "长出漂亮的彩色羽毛"},
        6: {"name": "歌唱期", "xp_required": 1500, "description": "学会了唱歌！"},
    }
    
    XP_RULES = {
        "complete_session": 10,           # 完成一次对话
        "learn_new_phrase": 5,            # 学会新表达
        "perfect_pronunciation": 3,        # 发音获90+分
        "daily_streak": 8,                # 连续打卡
        "review_success": 2,              # 成功复习旧词汇
    }
    
    MILESTONES = [
        {"day": 1, "event": "叽叽学会了你的名字！"},
        {"day": 3, "event": "叽叽长出了小翅膀！"},
        {"day": 7, "event": "叽叽学会了第一个中文词！"},
        {"day": 14, "event": "叽叽的羽毛开始变色了！"},
        {"day": 30, "event": "叽叽长出了漂亮的小羽冠！"},
    ]
```
