# 叽里咕噜 — 技术规格文档 TECH_SPEC.md

> 版本: v2.0 | 关联: [PRD.md](./PRD.md) | 面向: 开发者（Claude Code）

---

## 一、架构总览

### 1.1 系统架构图

```
┌─────────────────────────────────────────────────────┐
│                    客户端 (Flutter)                    │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌─────────┐ │
│  │ 老人主界面 │ │ 语音对话页 │ │ 复习卡片页 │ │ 子女仪表盘│ │
│  └──────────┘ └──────────┘ └──────────┘ └─────────┘ │
│  ┌────────────────────────────────────────────────┐  │
│  │          本地模块: VAD · 音频录制 · 动画引擎       │  │
│  └────────────────────────────────────────────────┘  │
└──────────────────────┬──────────────────────────────┘
                       │ WebSocket / HTTPS
┌──────────────────────▼──────────────────────────────┐
│                   后端服务 (Python/Node)               │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌─────────┐ │
│  │ 会话管理器 │ │ 语音管线  │ │ 学习引擎  │ │ 用户服务 │ │
│  │ Session   │ │ Voice    │ │ Learning │ │ User    │ │
│  │ Manager   │ │ Pipeline │ │ Engine   │ │ Service │ │
│  └──────────┘ └──────────┘ └──────────┘ └─────────┘ │
│  ┌────────────────────────────────────────────────┐  │
│  │       记忆系统 · 场景引擎 · 推送服务 · 分享服务     │  │
│  └────────────────────────────────────────────────┘  │
└──────────────────────┬──────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────┐
│                    外部服务                            │
│  ASR API · LLM API · TTS API · 对象存储 · 推送服务    │
└─────────────────────────────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────┐
│                    数据层                              │
│  PostgreSQL(用户/学习数据) · Redis(会话/缓存) · S3(音频) │
└─────────────────────────────────────────────────────┘
```

### 1.2 技术选型

| 层级 | 选型 | 备选 | 理由 |
|------|------|------|------|
| 客户端 | **Flutter** | React Native | 单人开发效率高，双端一致性好，Dart性能好 |
| 后端 | **Python (FastAPI)** | Node.js | AI生态最成熟，LLM/ASR库丰富 |
| 实时通信 | **WebSocket** | gRPC Streaming | 语音流传输低延迟，Flutter支持好 |
| 数据库 | **PostgreSQL** | — | 关系型，JSONB支持灵活schema |
| 缓存 | **Redis** | — | 会话状态、速率限制、实时数据 |
| 对象存储 | **阿里云OSS / S3** | — | 音频文件、用户头像、分享卡片 |
| 推送 | **极光推送 / Firebase** | — | 双端推送，子女端通知 |
| 部署 | **阿里云ECS + Docker** | AWS | 国内合规，延迟低 |

### 1.3 架构决策原则

1. **MVP优先**：能用第三方API就不自建，能用managed service就不自运维
2. **语音链路最短路径**：Streaming架构，ASR边识别边传，LLM流式输出，TTS流式合成
3. **模块可替换**：ASR/LLM/TTS通过接口抽象，可快速切换供应商
4. **成本可控**：单用户日均API成本 < ¥1，月均 < ¥30

---

## 二、语音管线架构

> 详见 [VOICE_PIPELINE_SPEC.md](./VOICE_PIPELINE_SPEC.md)

### 2.1 核心流程

```
用户按住说话
    → 端上VAD检测语音活动（静音阈值2-3秒）
    → 音频流 WebSocket 传输到后端
    → ASR实时转写（Streaming模式）
    → 转写文本 + 用户上下文 → LLM生成回复（流式）
    → LLM输出流 → TTS实时合成（流式）
    → 音频流回传客户端 → 边播放边显示字幕
```

### 2.2 延迟预算

| 环节 | 目标延迟 | 说明 |
|------|---------|------|
| VAD→ASR传输 | < 100ms | 端上检测+WebSocket |
| ASR转写 | < 500ms | 流式模式，首个token |
| LLM推理 | < 500ms | TTFT (Time to First Token) |
| TTS合成 | < 300ms | 流式合成，首个音频chunk |
| **端到端总延迟** | **< 1.5秒** | 用户说完到听到回复 |

### 2.3 ASR宽容模式（核心创新）

针对中老年用户的特殊需求：

```python
class ElderlyASRConfig:
    # VAD配置：老年人说话慢、停顿多
    vad_silence_threshold_ms: int = 2500  # 默认App: 500-1000ms
    vad_speech_pad_ms: int = 500

    # 语言配置：中英混杂
    language_hints: list = ["zh", "en"]
    code_switching: bool = True  # 支持语码转换

    # 宽容度：对非标准发音的容忍
    pronunciation_tolerance: str = "high"  # low/medium/high
    
    # 后处理：纠正常见老年人口误
    post_processing: dict = {
        "normalize_numbers": True,    # "一二三" → "123"
        "handle_fillers": True,       # 过滤"那个""这个"等填充词
        "dialect_mapping": True,      # 常见方言映射
    }
```

---

## 三、后端服务设计

### 3.1 服务模块

```
backend/
├── app/
│   ├── main.py                 # FastAPI入口
│   ├── config.py               # 配置管理
│   ├── models/                 # 数据模型
│   │   ├── user.py
│   │   ├── session.py
│   │   ├── learning.py
│   │   └── scene.py
│   ├── services/               # 业务逻辑
│   │   ├── voice_pipeline.py   # 语音管线编排
│   │   ├── asr_service.py      # ASR服务（可替换）
│   │   ├── llm_service.py      # LLM服务（可替换）
│   │   ├── tts_service.py      # TTS服务（可替换）
│   │   ├── memory_service.py   # 记忆系统
│   │   ├── learning_engine.py  # 学习引擎(SRS)
│   │   ├── scene_engine.py     # 场景引擎
│   │   ├── share_service.py    # 分享卡片生成
│   │   └── push_service.py     # 推送服务
│   ├── api/                    # API路由
│   │   ├── auth.py             # 认证（子女注册/父母扫码）
│   │   ├── voice.py            # WebSocket语音对话
│   │   ├── scenes.py           # 场景CRUD
│   │   ├── learning.py         # 学习进度/报告
│   │   ├── family.py           # 子女仪表盘
│   │   └── share.py            # 分享
│   ├── prompts/                # Prompt模板
│   │   ├── system_prompt.py    # 主System Prompt
│   │   ├── scene_prompts/      # 各场景Prompt
│   │   └── feedback_prompts.py # 反馈话术模板
│   └── utils/
│       ├── audio.py            # 音频处理
│       ├── pronunciation.py    # 发音评估
│       └── card_generator.py   # 复习卡片生成
├── tests/
├── docker-compose.yml
├── Dockerfile
└── requirements.txt
```

### 3.2 核心API接口

```yaml
# 认证
POST /api/v1/auth/register          # 子女注册
POST /api/v1/auth/create-elder      # 为父母创建账号
POST /api/v1/auth/elder-login       # 父母扫码登录
POST /api/v1/auth/token/refresh     # 刷新Token

# 语音对话（WebSocket）
WS   /api/v1/voice/session          # 语音对话主通道
POST /api/v1/voice/session/start    # 开始对话session
POST /api/v1/voice/session/end      # 结束对话

# 场景
GET  /api/v1/scenes                 # 场景列表
GET  /api/v1/scenes/{id}            # 场景详情
GET  /api/v1/scenes/{id}/progress   # 场景学习进度

# 学习
GET  /api/v1/learning/summary       # 学习概览
GET  /api/v1/learning/vocabulary    # 已学词汇
GET  /api/v1/learning/cards         # 复习卡片列表
GET  /api/v1/learning/report/weekly # 周报

# 子女仪表盘
GET  /api/v1/family/dashboard       # 仪表盘数据
GET  /api/v1/family/reports         # 学习报告列表
POST /api/v1/family/gift            # 赠送场景包
GET  /api/v1/family/share-card/{id} # 获取分享卡片

# 宠物
GET  /api/v1/pet/status             # 鹦鹉当前状态/等级
GET  /api/v1/pet/milestones         # 成长里程碑
```

### 3.3 WebSocket语音对话协议

```json
// 客户端 → 服务端：音频数据
{
  "type": "audio_chunk",
  "data": "<base64_encoded_audio>",
  "sample_rate": 16000,
  "format": "pcm16"
}

// 客户端 → 服务端：控制信号
{
  "type": "control",
  "action": "start_session" | "end_session" | "interrupt",
  "scene_id": "scene_001",  // 可选
  "metadata": {}
}

// 服务端 → 客户端：转写结果（实时）
{
  "type": "transcript",
  "text": "I want some apple",
  "is_final": false
}

// 服务端 → 客户端：AI回复文本（流式）
{
  "type": "response_text",
  "text": "说得很好！",  // 增量文本
  "is_final": false
}

// 服务端 → 客户端：AI回复音频（流式）
{
  "type": "response_audio",
  "data": "<base64_encoded_audio>",
  "format": "pcm16"
}

// 服务端 → 客户端：对话元数据
{
  "type": "session_summary",
  "new_phrases": ["I want some", "How much", "Thank you"],
  "duration_seconds": 320,
  "pet_xp_gained": 15,
  "review_card_id": "card_20260306_001"
}
```

---

## 四、客户端架构

### 4.1 Flutter项目结构

```
lib/
├── main.dart
├── app/
│   ├── app.dart                    # MaterialApp配置
│   ├── router.dart                 # 路由（GoRouter）
│   └── theme.dart                  # 主题（适老化配色/字号）
├── features/
│   ├── home/                       # 首页（鹦鹉+开始聊天）
│   ├── voice_chat/                 # 语音对话页
│   │   ├── voice_chat_page.dart
│   │   ├── voice_chat_vm.dart      # ViewModel
│   │   ├── widgets/
│   │   │   ├── pet_animation.dart  # 鹦鹉动画
│   │   │   ├── subtitle_display.dart # 大字幕
│   │   │   ├── talk_button.dart    # 说话按钮
│   │   │   └── quick_replies.dart  # 快捷回复
│   │   └── audio/
│   │       ├── audio_recorder.dart # 录音
│   │       ├── audio_player.dart   # 播放
│   │       └── vad_detector.dart   # 端上VAD
│   ├── scenes/                     # 场景选择
│   ├── review/                     # 复习卡片
│   ├── pet/                        # 鹦鹉状态/成长
│   ├── family/                     # 子女仪表盘
│   │   ├── setup_wizard/           # 帮父母设置
│   │   ├── dashboard/              # 数据面板
│   │   └── share/                  # 分享
│   └── auth/                       # 认证
├── core/
│   ├── network/
│   │   ├── api_client.dart         # HTTP客户端
│   │   └── ws_client.dart          # WebSocket客户端
│   ├── storage/                    # 本地存储
│   ├── constants/                  # 常量
│   └── utils/                      # 工具类
├── shared/
│   ├── widgets/                    # 通用组件（大按钮、大字体Text等）
│   └── models/                     # 共享数据模型
└── assets/
    ├── animations/                 # Lottie/Rive鹦鹉动画
    ├── audio/                      # 音效
    └── images/                     # 图片资源
```

### 4.2 关键技术选择

| 需求 | 方案 | 说明 |
|------|------|------|
| 状态管理 | Riverpod | 简洁，适合中小项目 |
| 路由 | GoRouter | 声明式路由 |
| 动画 | Rive / Lottie | 鹦鹉动画，支持状态机 |
| 音频录制 | record + audio_session | 低延迟录音 |
| 音频播放 | just_audio | 流式播放支持 |
| WebSocket | web_socket_channel | 标准WebSocket |
| 本地存储 | Hive | 轻量级NoSQL |
| 推送 | firebase_messaging / jpush | 双端推送 |

---

## 五、安全与合规

### 5.1 数据安全

- 所有API通信HTTPS/WSS加密
- 用户语音数据加密存储，保留周期可配置（默认30天后删除原始音频）
- 敏感数据（密码、token）单独加密存储
- 老年用户个人信息最小化采集原则

### 5.2 隐私合规

- 符合《个人信息保护法》要求
- 首次使用需明确语音数据采集授权
- 提供数据导出和删除功能
- 子女查看父母学习数据需父母授权

### 5.3 内容安全

- LLM输出经过内容安全过滤（敏感词+语义审核）
- 对话范围限定在英语学习场景内
- 设置兜底话术：当AI不确定时平滑过渡而非瞎回答

---

## 六、部署与运维

### 6.1 MVP部署架构

```
阿里云ECS (2核4G × 2)
    ├── Docker: FastAPI后端 × 2 (Nginx负载均衡)
    ├── Docker: Redis
    └── Docker: PostgreSQL

阿里云OSS: 音频文件 + 分享卡片图片
阿里云CDN: 静态资源

外部API:
    ├── ASR: Whisper API / Deepgram
    ├── LLM: OpenAI / Anthropic / 字节豆包
    └── TTS: 豆包TTS / Fish Audio / Azure
```

### 6.2 监控

- 语音链路延迟监控（每个环节打点）
- API调用成本日报
- 用户行为埋点（见 [GROWTH_SPEC.md](./GROWTH_SPEC.md)）
- 异常告警（对话失败率 > 5%触发）

---

## 七、开发排期（MVP 6-8周）

| 周次 | 任务 | 产出 |
|------|------|------|
| W1 | 技术选型确认 + 项目脚手架 + CI/CD | 可运行的空项目 |
| W2 | 语音链路打通（ASR→LLM→TTS端到端） | Demo可语音对话 |
| W3 | Flutter UI骨架 + 鹦鹉动画集成 | 首页+对话页可用 |
| W4 | Prompt设计 + 5个入门场景 + 记忆系统 | 教学对话可运行 |
| W5 | 子女端（注册/设置/仪表盘） | 双角色完整流程 |
| W6 | 复习卡片 + 微信分享 + 推送 | 分享链路打通 |
| W7 | 宠物成长系统 + 场景选择 | 完整MVP |
| W8 | 内测 + Bug修复 + 性能优化 + 上架准备 | 可发布版本 |
