# 叽里咕噜 — 场景内容引擎 CONTENT_SCENE_SPEC.md

> 版本: v2.0 | 关联: [AI_PERSONA_SPEC.md](./AI_PERSONA_SPEC.md) | 面向: 内容/Prompt开发

---

## 一、场景数据模型

```python
class Scene:
    id: str                          # "scene_fruit_shopping"
    name: str                        # "买水果"
    description: str                 # "在水果摊买苹果和香蕉"
    pack: str                        # "basic" / "daily" / "travel" / "family"
    difficulty: int                  # 1-5
    duration_minutes: int            # 预计时长 5-8
    is_free: bool                    # 是否免费
    
    # 教学内容
    target_phrases: list[Phrase]     # 本场景核心短语（3-5个）
    vocabulary: list[str]            # 涉及的词汇
    cultural_notes: list[str]        # 文化小知识（可选）
    
    # 对话脚本
    scene_prompt: str                # 注入LLM的场景Prompt
    opener: str                      # 开场白模板
    closer: str                      # 结束语模板
    
    # 复习关联
    prerequisite_scenes: list[str]   # 前置场景（可选）
    review_phrases_from: list[str]   # 可以自然复现哪些场景的词汇

class Phrase:
    english: str                     # "I'd like some apples"
    chinese: str                     # "我想要一些苹果"
    phonetic_ipa: str               # "/aɪd laɪk sʌm ˈæpəlz/"
    phonetic_chinese: str           # "爱的 来克 撒姆 阿剖斯"
    usage_context: str              # "买东西时表达你想要什么"
    difficulty: int                  # 1-5
    audio_url: str                  # 标准发音音频URL
```

---

## 二、MVP场景库（20个场景）

### 2.1 入门基础包（免费，5个场景）

| # | 场景 | 核心短语 | 难度 |
|---|------|---------|------|
| 1 | 打招呼 | Hello / Good morning / Nice to meet you | ★ |
| 2 | 自我介绍 | My name is... / I'm from China / I'm retired | ★ |
| 3 | 数字与价格 | 1-10数字 / How much? / It's X dollars | ★ |
| 4 | 买水果 | I'd like some... / How much? / Here you go | ★★ |
| 5 | 简单感谢 | Thank you / You're welcome / Have a nice day | ★ |

### 2.2 日常生活包（会员，5个场景）

| # | 场景 | 核心短语 | 难度 |
|---|------|---------|------|
| 6 | 餐厅点菜 | Can I have... / The menu please / The bill please | ★★ |
| 7 | 打车/公交 | I want to go to... / How long? / Stop here please | ★★ |
| 8 | 问路 | Where is...? / Turn left/right / How far? | ★★ |
| 9 | 聊天气 | It's sunny/rainy / What a nice day / Is it cold? | ★ |
| 10 | 夸别人 | You look great! / That's beautiful / Well done! | ★ |

### 2.3 出国旅游包（付费，6个场景）

| # | 场景 | 核心短语 | 难度 |
|---|------|---------|------|
| 11 | 机场过海关 | I'm here for vacation / For X days / This is my passport | ★★★ |
| 12 | 酒店入住 | I have a reservation / Check in please / Where's the elevator? | ★★★ |
| 13 | 景点游览 | Can I take a photo? / What time does it close? / Where's the restroom? | ★★ |
| 14 | 购物砍价 | It's too expensive / Can you give me a discount? / I'll take it | ★★★ |
| 15 | 打出租车 | Take me to... / Keep the change / Can you wait here? | ★★ |
| 16 | 紧急求助 | I need help / I'm lost / Call an ambulance please | ★★★ |

### 2.4 海外探亲包（付费，4个场景）

| # | 场景 | 核心短语 | 难度 |
|---|------|---------|------|
| 17 | 和孙子说英语 | Come here / Good job! / I love you / Let's play | ★ |
| 18 | 看医生 | I have a headache / I'm allergic to... / Where does it hurt? | ★★★ |
| 19 | 邻居聊天 | I'm visiting my daughter / The weather is nice / See you later | ★★ |
| 20 | 超市购物 | Where can I find...? / Paper or plastic? / Do you have...? | ★★ |

---

## 三、场景Prompt模板

每个场景都有一个结构化Prompt注入LLM：

```python
SCENE_PROMPT_TEMPLATE = """
## 当前场景：{scene_name}

### 场景描述
{scene_description}

### 背景设定
{scene_context}
例如："阿姨走进了一家水果店，店里有各种新鲜水果。一个友好的外国老板在柜台后面微笑着。"

### 本场景需要教的核心表达（按顺序教）
{target_phrases_formatted}

### 教学流程
1. 用中文描述场景，引起兴趣
2. 引入第1个表达：先说英文 → 中文意思 → 用在场景里 → 让用户跟读
3. 用户练习后给予正面反馈，温和纠正
4. 引入第2-3个表达，重复上述流程
5. 用一个小对话串联所有表达
6. 总结今天学的内容

### 需要自然复现的旧词汇
{review_phrases}

### 难度控制
当前用户英语水平：{user_level}
中英比例：{cn_en_ratio}
"""
```

### 示例：买水果场景完整Prompt

```
## 当前场景：买水果

### 场景描述
阿姨在国外旅游，走进一家水果店想买苹果和香蕉。

### 背景设定
一个阳光明媚的早上，阿姨走进街边的水果店。店里摆满了新鲜水果：红彤彤的苹果、
黄澄澄的香蕉、还有各种阿姨没见过的热带水果。老板是一个友善的外国人，正在
整理水果，看到阿姨进来笑着打了个招呼。

### 本场景核心表达（按顺序教）
1. "I'd like some apples" — 我想要一些苹果
   教学提示：先教 "I'd like some" 这个万能句型，可以接任何东西
   
2. "How much?" — 多少钱？
   教学提示：这是最短最实用的购物表达，两个词搞定
   
3. "Here you go" — 给你（付钱时说）
   教学提示：告诉用户这句话特别潇洒，像电影里的老外一样

### 需要自然复现的旧词汇
- "Hello"（打招呼场景学过）→ 进店时跟老板打招呼
- "Thank you"（简单感谢场景学过）→ 买完后道谢

### 难度控制
中英比例：70%中文 + 30%英语
```

---

## 四、场景内容生产流程

### 4.1 新场景开发SOP

```
Step 1: 需求定义
  → 确定场景名称、目标用户动机、核心短语（3-5个）
  → 确定难度等级和前置场景

Step 2: 教学设计
  → 编写场景背景故事
  → 设计教学顺序（从简到难）
  → 为每个短语编写发音提示和中文谐音
  → 设计可能的用户回答变体

Step 3: Prompt编写
  → 使用模板编写场景Prompt
  → 编写场景开场白和结束语
  → 定义复习关联（可以自然复现哪些旧词汇）

Step 4: 测试验证
  → 用LLM测试对话流程（模拟10种不同用户回答）
  → 检查是否符合6大对话原则
  → 验证难度是否适配目标水平

Step 5: 录制音频
  → TTS生成标准发音音频
  → 人工检查音频质量
```

### 4.2 内容质量检查清单

```
□ 每个场景包含3-5个核心短语（不多不少）
□ 每个短语都有：英文 + 中文 + IPA音标 + 中文谐音
□ 场景背景用中文描述，生动有画面感
□ 教学顺序从简到难
□ 没有语法术语（不说"现在进行时"）
□ 文化适配：不涉及敏感话题
□ Prompt中包含"先肯定再纠正"的明确指令
□ 结束语包含明天场景预告
□ 标注了可自然复现的旧词汇
```

---

## 五、场景推荐算法

```python
class SceneRecommender:
    """根据用户状态推荐下一个场景"""
    
    def recommend(self, user: User) -> Scene:
        # 1. 优先级：有复习需求的旧场景
        due_reviews = self.get_due_review_scenes(user)
        if due_reviews:
            return due_reviews[0]  # 返回最需要复习的场景
        
        # 2. 按学习路径推荐下一个新场景
        completed = user.completed_scene_ids
        for scene in self.get_ordered_scenes():
            if scene.id not in completed:
                # 检查前置条件
                if self.prerequisites_met(scene, user):
                    return scene
        
        # 3. 所有场景都完成了，推荐随机场景做自由练习
        return self.random_practice_scene(user)
    
    def get_ordered_scenes(self) -> list:
        """场景学习路径"""
        return [
            # 入门基础（免费）
            "scene_greeting", "scene_self_intro", "scene_numbers",
            "scene_fruit_shopping", "scene_simple_thanks",
            # 日常生活（会员）
            "scene_restaurant", "scene_taxi", "scene_directions",
            "scene_weather", "scene_compliments",
            # 旅游（付费包）
            "scene_airport", "scene_hotel", "scene_sightseeing",
            "scene_shopping", "scene_taxi_abroad", "scene_emergency",
            # 探亲（付费包）
            "scene_grandchild", "scene_doctor", "scene_neighbor",
            "scene_supermarket",
        ]
```
