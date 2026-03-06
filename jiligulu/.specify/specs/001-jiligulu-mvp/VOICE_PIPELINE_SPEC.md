# 叽里咕噜 — 语音管线技术规格 VOICE_PIPELINE_SPEC.md

> 版本: v2.0 | 关联: [TECH_SPEC.md](./TECH_SPEC.md) | 面向: 语音链路开发

---

## 一、架构模式：Streaming Cascading Pipeline

采用**流式级联架构**（非Speech-to-Speech一体模型），原因：
1. 模块化可调试：ASR听错了还是LLM回错了一目了然
2. 可替换：ASR/LLM/TTS可独立切换供应商
3. 成本可控：比OpenAI Realtime API便宜5-10倍
4. 中文教学场景需要精确控制输出格式

```
┌────────┐    ┌────────┐    ┌────────┐    ┌────────┐
│  用户    │    │  ASR   │    │  LLM   │    │  TTS   │
│  语音    │───▶│ 流式转写 │───▶│ 流式生成 │───▶│ 流式合成 │
│         │    │        │    │        │    │        │
└────────┘    └────────┘    └────────┘    └────────┘
     ▲              │             │             │
     │         实时字幕        回复文本        音频流
     │              ▼             ▼             ▼
     │         ┌──────────────────────────────────┐
     └─────────│          客户端展示层              │
               │   字幕显示 · 鹦鹉动画 · 音频播放    │
               └──────────────────────────────────┘
```

---

## 二、各环节技术方案

### 2.1 端上VAD（Voice Activity Detection）

```dart
// Flutter端VAD配置
class ElderlyVADConfig {
  // 核心参数：老年人说话慢、停顿多
  static const double speechThreshold = 0.3;     // 语音检测灵敏度(0-1)
  static const int silenceDurationMs = 2500;      // 静音判定：2.5秒（标准App: 500ms）
  static const int speechPadMs = 500;             // 语音前后padding
  static const int minSpeechDurationMs = 300;     // 最短语音时长
  
  // 噪声处理：老年人环境常有电视声
  static const bool noiseReduction = true;
  static const double noiseThreshold = 0.15;
}
```

**推荐库**：`silero-vad`（端上推理，<10ms延迟），Flutter通过Platform Channel调用。

### 2.2 ASR（语音转写）

#### 方案对比

| 方案 | 延迟(TTFT) | 中英混杂 | 老年口音 | 成本/分钟 | 推荐度 |
|------|-----------|---------|---------|----------|-------|
| Whisper large-v3 API | ~500ms | ★★★★ | ★★★ | ¥0.04 | MVP首选 |
| Deepgram Nova-2 | ~200ms | ★★★ | ★★★ | ¥0.05 | 低延迟场景 |
| Azure Speech | ~300ms | ★★★★ | ★★★★ | ¥0.06 | 企业级 |
| 阿里云语音 | ~300ms | ★★★★★ | ★★★★ | ¥0.03 | 国内最优 |

**MVP推荐**：阿里云语音识别API（国内延迟最低、中英混杂最好、成本最低），备选Whisper API。

#### ASR后处理管线

```python
class ASRPostProcessor:
    """ASR输出后处理，针对老年用户优化"""
    
    def process(self, raw_transcript: str, context: SessionContext) -> ProcessedTranscript:
        text = raw_transcript
        
        # 1. 过滤填充词
        text = self.remove_fillers(text)  # "那个""这个""嗯""啊"
        
        # 2. 中英文分离
        segments = self.segment_languages(text)  # [("zh", "我想要"), ("en", "some apples")]
        
        # 3. 英语发音宽容匹配
        for seg in segments:
            if seg.lang == "en":
                seg.text = self.fuzzy_match_english(
                    seg.text, 
                    expected_phrases=context.current_scene_phrases,
                    tolerance="high"
                )
        
        # 4. 拼音/谐音识别
        # 老年人可能用中文发音说英语："啊剖" → "apple"
        text = self.pinyin_to_english(text, context.current_scene_phrases)
        
        return ProcessedTranscript(
            original=raw_transcript,
            processed=text,
            segments=segments,
            confidence=self.calculate_confidence(segments)
        )
    
    def fuzzy_match_english(self, spoken: str, expected_phrases: list, tolerance: str) -> str:
        """模糊匹配：用编辑距离+音素相似度匹配用户可能要说的英语"""
        best_match = None
        best_score = 0
        for phrase in expected_phrases:
            score = self.phonetic_similarity(spoken, phrase)
            if score > best_score:
                best_match = phrase
                best_score = score
        
        thresholds = {"low": 0.8, "medium": 0.6, "high": 0.4}
        if best_score >= thresholds[tolerance]:
            return best_match
        return spoken
```

### 2.3 LLM（对话生成）

#### 方案对比

| 方案 | TTFT | 中文教学质量 | 成本/1K tokens | 推荐度 |
|------|------|------------|---------------|-------|
| GPT-4o-mini | ~400ms | ★★★★ | ¥0.01 | MVP首选 |
| Claude Haiku 4.5 | ~300ms | ★★★★ | ¥0.008 | 备选 |
| 豆包(Doubao) | ~200ms | ★★★★★ | ¥0.005 | 国内优选 |
| DeepSeek-V3 | ~300ms | ★★★★ | ¥0.003 | 性价比最高 |

**MVP推荐**：豆包API（字节自研，中文质量最佳、延迟最低、成本最低），备选GPT-4o-mini。

#### Prompt注入结构

```python
def build_conversation_messages(session: Session) -> list:
    return [
        {
            "role": "system",
            "content": SYSTEM_PROMPT.format(
                scene_context=session.current_scene.to_prompt(),
                user_learning_history=session.user.learning_summary(),
                user_preferences=session.user.preferences_summary(),
            )
        },
        # 场景开场白（如果是新场景）
        *session.scene_opener_messages(),
        # 历史对话（最近10轮，含用户语音转写和AI回复）
        *session.recent_messages(limit=10),
        # 当前用户输入
        {
            "role": "user",
            "content": f"[用户语音转写] {current_transcript}\n"
                       f"[发音评估] {pronunciation_assessment}\n"
                       f"[本轮已学表达] {session.phrases_taught_this_round}"
        }
    ]
```

### 2.4 TTS（语音合成）

#### 方案对比

| 方案 | 延迟(TTFB) | 中英混合 | 声音亲和力 | 成本/千字符 | 推荐度 |
|------|-----------|---------|----------|-----------|-------|
| 豆包TTS | ~200ms | ★★★★★ | ★★★★ | ¥0.02 | MVP首选 |
| Fish Audio | ~300ms | ★★★★ | ★★★★★ | ¥0.03 | 音质最佳 |
| Azure Neural TTS | ~250ms | ★★★★ | ★★★★ | ¥0.06 | 企业级 |
| MiniMax Speech | ~200ms | ★★★★ | ★★★★ | ¥0.02 | 备选 |

**MVP推荐**：豆包TTS（中英混合最好、延迟最低），备选Fish Audio（音质最佳）。

#### TTS配置

```python
class ElderlyTTSConfig:
    voice_id: str = "friendly_young_female"  # 温暖年轻女声
    
    # 语速：比默认慢20%
    speaking_rate: float = 0.8
    
    # 中英混合策略
    language_switching: str = "seamless"  # 同一句中无缝切换
    english_pronunciation: str = "standard_american"  # 标准美式
    chinese_style: str = "conversational"  # 口语化
    
    # 情感控制
    emotion_tags: bool = True  # 支持 [开心] [鼓励] [温柔] 标签
    
    # 语气词
    fillers: list = ["嗯", "对对对", "哎"]  # 自然语气词
    
    # 音量
    volume_boost_db: float = 3.0  # 老年人可能听力下降，适当提升音量
```

---

## 三、发音评估系统

### 3.1 "可理解度"评分（非"标准度"）

```python
class PronunciationAssessor:
    """
    核心理念：评估"老外能否听懂"，而非"发音是否标准"
    分数含义：
      90-100: 完全可理解，发音自然
      70-89:  可理解，有口音但不影响沟通
      50-69:  勉强可理解，需要对方猜测
      0-49:   难以理解
    """
    
    def assess(self, user_audio: bytes, target_phrase: str) -> Assessment:
        # 1. 音素级对比（宽容模式）
        phoneme_score = self.phoneme_comparison(
            user_audio, target_phrase,
            tolerance="high",  # 老年人模式
            ignore_tones=True,  # 不考虑声调对英语发音的影响
        )
        
        # 2. 整体可理解度评估
        intelligibility = self.intelligibility_check(user_audio, target_phrase)
        
        # 3. 综合评分（可理解度权重更高）
        final_score = intelligibility * 0.7 + phoneme_score * 0.3
        
        # 4. 生成反馈
        feedback = self.generate_feedback(final_score, target_phrase, user_audio)
        
        return Assessment(
            score=final_score,
            intelligibility=intelligibility,
            phoneme_score=phoneme_score,
            feedback=feedback,
            # 给AI对话引擎的提示
            llm_hint=self.generate_llm_hint(final_score, target_phrase)
        )
    
    def generate_llm_hint(self, score, target):
        if score >= 70:
            return f"用户发音不错，可以直接肯定并继续"
        elif score >= 50:
            return f"用户发音基本可理解但有改进空间，先肯定再温和提示改进点"
        else:
            return f"用户发音需要帮助，用鼓励的方式重新示范，不要让用户感到挫败"
```

---

## 四、流式传输协议

### 4.1 端到端流式流程

```
时间轴 ──────────────────────────────────────────────▶

用户说话    ████████████
ASR转写           ▓▓▓▓▓▓▓▓▓▓▓▓    (边收边转)
LLM生成                    ░░░░░░░░░░░░░░  (首token<500ms)  
TTS合成                         ▒▒▒▒▒▒▒▒▒▒▒▒  (边生成边合成)
音频播放                              ▓▓▓▓▓▓▓▓▓▓▓▓  (边合成边播)
字幕显示                    ────────────────────  (同步显示)

用户感知延迟: ◀──────── ~1.5秒 ────────▶
```

### 4.2 中断处理

```python
class InterruptionHandler:
    """处理用户打断AI说话的情况"""
    
    async def handle_interruption(self, session: Session):
        # 1. 立即停止TTS播放
        await session.tts_player.stop()
        
        # 2. 记录AI被打断时的位置
        interrupted_at = session.current_response_position
        
        # 3. 开始处理用户新输入
        # 不需要特殊处理，正常流程继续
        
        # 4. 在context中标记被打断
        session.add_context_note(f"[AI在说到'{interrupted_at}'时被用户打断]")
```

---

## 五、错误处理与降级

```python
FALLBACK_CHAIN = {
    "asr_failure": {
        "retry": 1,
        "fallback": "向用户播放：'叽叽没听清，阿姨再说一遍？'",
        "log_level": "warning"
    },
    "llm_timeout": {
        "retry": 1,
        "fallback": "使用预设话术：'嗯...让叽叽想想...'（同时重试）",
        "timeout_ms": 5000
    },
    "llm_failure": {
        "retry": 2,
        "fallback": "切换备用LLM提供商",
        "ultimate_fallback": "预设安全回复 + 建议用户稍后再试"
    },
    "tts_failure": {
        "retry": 1,
        "fallback": "显示文字回复（不播放语音）",
        "log_level": "error"
    },
    "network_error": {
        "fallback": "显示离线提示 + 提供复习卡片浏览（离线可用）"
    }
}
```

---

## 六、成本预估

### 单次对话成本（5分钟，约10轮对话）

| 环节 | 用量 | 单价 | 成本 |
|------|------|------|------|
| ASR | ~3分钟用户语音 | ¥0.03/分钟 | ¥0.09 |
| LLM | ~2000 tokens输入 + 1000输出 | ¥0.005/1K | ¥0.015 |
| TTS | ~800字符AI语音 | ¥0.02/千字符 | ¥0.016 |
| **单次对话合计** | | | **~¥0.12** |

### 月度成本（用户每天1.5次对话）

- 单用户月均：¥0.12 × 1.5 × 30 = **¥5.4/月**
- ¥198/年订阅 = ¥16.5/月
- **毛利率：~67%**（极其健康）
