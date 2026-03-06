# Implementation Plan: 叽里咕噜 MVP

**Branch**: `001-jiligulu-mvp` | **Date**: 2026-03-06 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification + 9 source design documents (PRD, TECH_SPEC, VOICE_PIPELINE, AI_PERSONA, MEMORY_SYSTEM, ELDERCARE_UX, INFO_ARCHITECTURE, CONTENT_SCENE, DATA_MODEL)

## Summary

构建叽里咕噜MVP：一款面向55-70岁退休人群的AI英语学习伴侣App。核心是Streaming Cascading语音管线（ASR→LLM→TTS），通过Flutter跨端App和Python FastAPI后端实现。鹦鹉"叽叽"作为情感陪伴角色，在场景化对话中教老年人实用英语。子女付费、父母使用。

## Technical Context

**Language/Version**: Dart 3.x (Flutter 3.x) + Python 3.12
**Primary Dependencies**:
- Frontend: Flutter, Riverpod, GoRouter, Rive (animation), web_socket_channel, record, just_audio
- Backend: FastAPI, SQLAlchemy 2.0, Alembic, Redis (aioredis), websockets, httpx
- AI: 阿里云语音API (ASR), 豆包API (LLM+TTS), Whisper API (ASR备选), GPT-4o-mini (LLM备选)
**Storage**: PostgreSQL 16, Redis 7, 阿里云OSS (audio files)
**Testing**: pytest (backend), flutter_test (frontend)
**Target Platform**: iOS 14+ / Android 8+ (Flutter cross-platform)
**Project Type**: Mobile + API
**Performance Goals**: 语音链路端到端延迟 < 2秒 (VAD < 100ms, ASR < 500ms, LLM TTFT < 500ms, TTS TTFB < 300ms)
**Constraints**: 单用户日均API成本 < ¥1, 月均 < ¥30; 首页加载 < 1秒; 全App最小字号18sp
**Scale/Scope**: MVP目标1000用户, 14个页面, 21个共享组件, 10个教学场景

## Constitution Check

*GATE: All 9 principles checked.*

| Principle | Status | Evidence |
|-----------|--------|----------|
| I. Specification as Source of Truth | PASS | 9份spec文档驱动实现，plan从spec派生 |
| II. LLM-Native Output | PASS | 所有文档为Markdown，图表用Mermaid/ASCII |
| III. UI/UX First-Class Support | PASS | userflows + ia + wireframes + components 全套UX文档 |
| IV. MVP-First & Python Razor | PASS | 全用第三方API (ASR/LLM/TTS)，Docker+ECS部署 |
| V. Emotional Companion Over Tool | PASS | AI Persona spec定义叽叽角色，7种动画状态 |
| VI. Text-Based Visual Artifacts | PASS | wireframes用ASCII，flows用Mermaid |
| VII. Elder-First Accessibility | PASS | 18sp最小字号，48dp触控，无红色，3Tab导航 |
| VIII. Modular Provider Abstraction | PASS | ASR/LLM/TTS通过ABC接口抽象 |
| IX. Cost-Conscious Architecture | PASS | 单次对话~¥0.12，月均~¥5.4/用户 |

## Project Structure

### Documentation

```text
.specify/specs/001-jiligulu-mvp/
├── PRD.md                    # 产品需求文档
├── TECH_SPEC.md              # 技术规格
├── VOICE_PIPELINE_SPEC.md    # 语音管线规格
├── AI_PERSONA_SPEC.md        # AI人设与对话策略
├── MEMORY_SYSTEM_SPEC.md     # 记忆系统设计
├── ELDERCARE_UX_SPEC.md      # 适老化UX规范
├── INFO_ARCHITECTURE.md      # 信息架构
├── CONTENT_SCENE_SPEC.md     # 场景内容引擎
├── DATA_MODEL.md             # 数据模型
├── GROWTH_SPEC.md            # 增长与运营策略
├── spec.md                   # 功能规格(spec kit)
├── userflows.md              # 用户流程图
├── ia.md                     # 信息架构(spec kit)
├── wireframes.md             # 线框图
├── components.md             # 组件层级
├── plan.md                   # 本文件
├── research.md               # 技术调研(Phase 0)
├── contracts/                # API合约(Phase 1)
│   └── openapi.yaml
└── quickstart.md             # 快速启动指南(Phase 1)
```

### Source Code

```text
jiligulu/
├── backend/
│   ├── app/
│   │   ├── main.py                     # FastAPI入口
│   │   ├── config.py                   # 配置管理(环境变量)
│   │   ├── models/                     # SQLAlchemy数据模型
│   │   │   ├── __init__.py
│   │   │   ├── user.py                 # users表 + families表
│   │   │   ├── session.py              # sessions表 + messages表
│   │   │   ├── learning.py             # vocab_items表 + review_cards表
│   │   │   ├── scene.py                # scenes表
│   │   │   └── subscription.py         # subscriptions表 + push_notifications表
│   │   ├── services/                   # 业务逻辑(每个service一个文件)
│   │   │   ├── voice_pipeline.py       # 语音管线编排(核心)
│   │   │   ├── asr_service.py          # ASR抽象层 + 实现
│   │   │   ├── llm_service.py          # LLM抽象层 + 实现
│   │   │   ├── tts_service.py          # TTS抽象层 + 实现
│   │   │   ├── memory_service.py       # 记忆系统(短期+长期+SRS)
│   │   │   ├── learning_engine.py      # SRS间隔重复引擎
│   │   │   ├── scene_engine.py         # 场景推荐+管理
│   │   │   ├── pet_service.py          # 鹦鹉成长系统
│   │   │   ├── share_service.py        # 分享卡片生成
│   │   │   └── push_service.py         # 推送服务
│   │   ├── api/                        # API路由
│   │   │   ├── auth.py                 # 认证(子女注册/父母扫码)
│   │   │   ├── voice.py                # WebSocket语音对话
│   │   │   ├── scenes.py               # 场景CRUD
│   │   │   ├── learning.py             # 学习进度/词汇/报告
│   │   │   ├── family.py               # 子女仪表盘
│   │   │   ├── pet.py                  # 鹦鹉状态
│   │   │   └── share.py                # 分享
│   │   ├── prompts/                    # Prompt模板
│   │   │   ├── system_prompt.py        # 主System Prompt(AI_PERSONA_SPEC)
│   │   │   ├── scene_prompts/          # 各场景Prompt
│   │   │   └── feedback_prompts.py     # 反馈话术模板
│   │   └── utils/
│   │       ├── audio.py                # 音频处理
│   │       └── pronunciation.py        # 发音评估
│   ├── migrations/                     # Alembic迁移
│   ├── tests/
│   │   ├── unit/
│   │   ├── integration/
│   │   └── contract/
│   ├── Dockerfile
│   ├── docker-compose.yml              # PostgreSQL + Redis + API
│   └── requirements.txt
│
├── flutter_app/
│   ├── lib/
│   │   ├── main.dart
│   │   ├── app/
│   │   │   ├── app.dart                # MaterialApp配置
│   │   │   ├── router.dart             # GoRouter路由
│   │   │   └── theme.dart              # 适老化主题(配色/字号)
│   │   ├── features/
│   │   │   ├── home/
│   │   │   │   ├── home_page.dart
│   │   │   │   └── home_controller.dart
│   │   │   ├── voice_chat/
│   │   │   │   ├── voice_chat_page.dart
│   │   │   │   ├── voice_chat_controller.dart
│   │   │   │   ├── widgets/
│   │   │   │   │   ├── talk_button.dart
│   │   │   │   │   ├── subtitle_display.dart
│   │   │   │   │   ├── quick_reply_bar.dart
│   │   │   │   │   └── phrase_highlight.dart
│   │   │   │   └── audio/
│   │   │   │       ├── audio_recorder.dart
│   │   │   │       ├── audio_player.dart
│   │   │   │       └── vad_detector.dart
│   │   │   ├── scenes/
│   │   │   │   ├── scene_list_page.dart
│   │   │   │   └── widgets/scene_card.dart
│   │   │   ├── review/
│   │   │   │   ├── review_cards_page.dart
│   │   │   │   └── widgets/review_card.dart
│   │   │   ├── summary/
│   │   │   │   └── session_summary_page.dart
│   │   │   ├── pet/
│   │   │   │   ├── jiji_status_page.dart
│   │   │   │   └── widgets/
│   │   │   │       ├── pet_status_bar.dart
│   │   │   │       └── pet_milestone_card.dart
│   │   │   ├── family/
│   │   │   │   ├── child_dashboard_page.dart
│   │   │   │   ├── setup_wizard_page.dart
│   │   │   │   └── widgets/
│   │   │   │       ├── dashboard_card.dart
│   │   │   │       ├── share_button.dart
│   │   │   │       └── scene_gift_card.dart
│   │   │   └── auth/
│   │   │       └── onboarding_page.dart
│   │   ├── core/
│   │   │   ├── network/
│   │   │   │   ├── api_client.dart     # HTTP客户端
│   │   │   │   └── ws_client.dart      # WebSocket客户端
│   │   │   ├── providers/              # Riverpod providers
│   │   │   │   ├── auth_provider.dart
│   │   │   │   ├── session_provider.dart
│   │   │   │   ├── pet_provider.dart
│   │   │   │   └── audio_provider.dart
│   │   │   ├── storage/                # 本地存储(Hive)
│   │   │   └── constants/
│   │   ├── shared/
│   │   │   ├── widgets/                # 适老化组件库
│   │   │   │   ├── elder_button.dart
│   │   │   │   ├── elder_text.dart
│   │   │   │   ├── elder_card.dart
│   │   │   │   ├── elder_bottom_nav.dart
│   │   │   │   ├── pet_animation_widget.dart
│   │   │   │   ├── learning_stats_mini.dart
│   │   │   │   └── streak_badge.dart
│   │   │   └── models/                 # 共享数据模型
│   │   └── assets/
│   │       ├── animations/             # Rive鹦鹉动画文件
│   │       ├── audio/                  # 音效
│   │       └── images/
│   ├── test/
│   ├── pubspec.yaml
│   └── analysis_options.yaml
│
├── docker-compose.yml                  # 全栈本地开发环境
└── README.md
```

**Structure Decision**: Mobile + API 架构。Flutter App (`flutter_app/`) 和 Python FastAPI 后端 (`backend/`) 作为两个独立项目，通过 HTTP + WebSocket 通信。

## Phase 0: Research (技术调研)

所有技术选型已在 TECH_SPEC.md 和 VOICE_PIPELINE_SPEC.md 中完成调研。关键决策总结：

| Decision | Choice | Rationale | Alternatives |
|----------|--------|-----------|-------------|
| ASR | 阿里云语音识别 (primary), Whisper API (backup) | 国内延迟最低, 中英混杂最好, ¥0.03/分钟 | Deepgram, Azure Speech |
| LLM | 豆包API (primary), GPT-4o-mini (backup) | 中文质量最佳, TTFT~200ms, ¥0.005/1K tokens | Claude Haiku, DeepSeek-V3 |
| TTS | 豆包TTS (primary), Fish Audio (backup) | 中英混合最好, TTFB~200ms, ¥0.02/千字符 | Azure Neural, MiniMax |
| VAD | Silero VAD (on-device) | <10ms延迟, Flutter Platform Channel | WebRTC VAD |
| Animation | Rive | 支持状态机, 运行时动态切换 | Lottie |
| State Mgmt | Riverpod | 声明式, 可测试, 适合中小项目 | Bloc, Provider |
| DB | PostgreSQL + JSONB | 关系型 + 灵活schema | - |
| Cache | Redis | 会话状态, 速率限制, 在线状态 | - |

## Phase 1: Design & Contracts

### Data Model

完整数据模型定义在 [DATA_MODEL.md](./DATA_MODEL.md)。9张核心PostgreSQL表 + Redis缓存结构：

| Table | Purpose | Key Fields |
|-------|---------|------------|
| users | 用户(老人+子女) | role, english_level, pet_xp, subscription_type |
| families | 家庭关系 | child_id, elder_id, relationship |
| sessions | 对话会话 | user_id, scene_id, phrases_taught, success_rate |
| messages | 对话消息 | session_id, role, text_content, pronunciation_score |
| vocab_items | 词汇SRS | user_id, english, srs_level, next_review |
| scenes | 场景配置 | pack, target_phrases, scene_prompt |
| review_cards | 复习卡片 | user_id, phrases, share_image_url |
| subscriptions | 订阅 | user_id, purchaser_id, type, expires_at |
| push_notifications | 推送记录 | user_id, type, sent_at, opened_at |

Redis结构:
- `session:{id}` - 活跃会话实时数据 (TTL 1h)
- `user:online:{id}` - 在线状态 (TTL 5min, heartbeat)
- `user:daily:{id}:{date}` - 每日学习记录 (TTL 48h)
- `ratelimit:{id}:{endpoint}` - 速率限制
- `scene:cache:{id}` - 场景缓存 (TTL 1d)

### API Contracts

完整API定义在 [TECH_SPEC.md](./TECH_SPEC.md) 3.2节。核心端点：

**Auth**:
- `POST /api/v1/auth/register` - 子女注册
- `POST /api/v1/auth/create-elder` - 创建老人账号
- `POST /api/v1/auth/elder-login` - 扫码登录
- `POST /api/v1/auth/token/refresh` - Token刷新

**Voice (WebSocket)**:
- `WS /api/v1/voice/session` - 语音对话主通道
- `POST /api/v1/voice/session/start` - 开始对话
- `POST /api/v1/voice/session/end` - 结束对话

WebSocket协议消息类型 (TECH_SPEC 3.3节):
- `audio_chunk` (client→server): base64音频数据
- `control` (client→server): start/end/interrupt
- `transcript` (server→client): ASR实时转写
- `response_text` (server→client): LLM流式文本
- `response_audio` (server→client): TTS流式音频
- `session_summary` (server→client): 对话元数据

**Scenes**: `GET /api/v1/scenes`, `GET /api/v1/scenes/{id}/progress`
**Learning**: `GET /api/v1/learning/summary`, `GET /api/v1/learning/cards`, `GET /api/v1/learning/report/weekly`
**Family**: `GET /api/v1/family/dashboard`, `POST /api/v1/family/gift`
**Pet**: `GET /api/v1/pet/status`, `GET /api/v1/pet/milestones`

### Voice Pipeline Architecture

核心流式级联架构 (VOICE_PIPELINE_SPEC.md):

```
用户按住说话
  → 端上VAD (silero-vad, 静音阈值2.5秒)
  → 音频流 WebSocket 传输
  → ASR流式转写 (阿里云/Whisper)
  → ASR后处理 (填充词过滤+中英分离+模糊匹配+拼音映射)
  → 转写文本 + 用户上下文 → LLM流式生成 (豆包/GPT)
  → LLM输出流 → TTS流式合成 (豆包TTS/Fish Audio)
  → 音频流回传 → 边播放边显示字幕
```

ASR/LLM/TTS抽象层设计:

```python
# 每个服务通过ABC接口定义
class ASRProvider(ABC):
    async def transcribe_stream(self, audio_stream, config) -> AsyncIterator[TranscriptChunk]

class LLMProvider(ABC):
    async def generate_stream(self, messages, config) -> AsyncIterator[TextChunk]

class TTSProvider(ABC):
    async def synthesize_stream(self, text_stream, config) -> AsyncIterator[AudioChunk]
```

### Memory System

三层记忆架构 (MEMORY_SYSTEM_SPEC.md):

1. **短期记忆** (SessionMemory): Redis, 单次对话内, 对话历史+教学进度+情感状态
2. **长期记忆** (UserProfile): PostgreSQL, 跨会话, 学习偏好+个人背景+情感记忆
3. **学习记忆** (SRS): PostgreSQL vocab_items表, 改良SM-2算法(间隔比标准短30-50%)

### Prompt System

System Prompt完整定义在 AI_PERSONA_SPEC.md 第三节。场景Prompt模板在 CONTENT_SCENE_SPEC.md。

上下文组装顺序:
1. System Prompt (角色设定+对话规则+禁止行为)
2. 用户画像 (长期记忆)
3. 学习历史摘要
4. 当前场景信息 + 复习词汇注入
5. 本轮对话状态 (短期记忆)
6. 当前用户输入 + 发音评估

## Phase 2: Implementation Phases

### Phase 2.1: Foundation (W1, ~5 days)

**Goal**: 可运行的空项目 + 本地开发环境 + 数据库schema

Backend:
- [ ] 初始化FastAPI项目骨架 (main.py, config.py, requirements.txt)
- [ ] Docker Compose: PostgreSQL 16 + Redis 7 + API
- [ ] SQLAlchemy模型定义 (9张表, 按DATA_MODEL.md)
- [ ] Alembic初始迁移
- [ ] JWT认证框架 (子女注册+Token刷新)
- [ ] 基础API路由骨架 (auth, voice, scenes, learning, family, pet, share)

Flutter:
- [ ] 初始化Flutter项目 (pubspec.yaml依赖配置)
- [ ] 适老化主题 (theme.dart: 配色体系+字号层级, 按ELDERCARE_UX_SPEC)
- [ ] GoRouter路由配置 (14个路由, 按ia.md)
- [ ] 4个适老化基础组件 (ElderButton, ElderText, ElderCard, ElderBottomNav)
- [ ] ElderShell布局 (底部导航3Tab)
- [ ] API客户端 + WebSocket客户端骨架
- [ ] Riverpod providers骨架 (auth, session, pet, audio)

### Phase 2.2: Voice Pipeline Core (W2, ~5 days)

**Goal**: 端到端语音对话可运行 (Demo级别)

Backend:
- [ ] ASR抽象层 (ASRProvider ABC + 阿里云实现)
- [ ] LLM抽象层 (LLMProvider ABC + 豆包实现)
- [ ] TTS抽象层 (TTSProvider ABC + 豆包TTS实现)
- [ ] VoicePipeline编排服务 (串联ASR→LLM→TTS流式处理)
- [ ] WebSocket语音对话端点 (协议按TECH_SPEC 3.3)
- [ ] ASR后处理管线 (填充词过滤, 中英分离, 模糊匹配)
- [ ] 基础System Prompt (AI_PERSONA_SPEC精简版)
- [ ] 错误降级链 (FALLBACK_CHAIN: retry→备用provider→兜底话术)

Flutter:
- [ ] VAD集成 (silero-vad via Platform Channel, 静音阈值2.5秒)
- [ ] 音频录制 (record package, PCM16 16kHz)
- [ ] WebSocket音频流传输
- [ ] TalkButton组件 (按住说话, 松开发送)
- [ ] SubtitleDisplay组件 (流式字幕显示)
- [ ] 音频流式播放 (just_audio)
- [ ] 语音对话页基础框架 (VoiceChatPage)

### Phase 2.3: UI + Parrot Animation (W3, ~5 days)

**Goal**: 首页+对话页完整可用, 鹦鹉动画集成

Flutter:
- [ ] PetAnimationWidget (Rive集成, 7个状态)
- [ ] 首页 (HomePage: 鹦鹉动画+开始聊天按钮+迷你统计)
- [ ] 语音对话页完善 (PhraseHighlight, QuickReplyBar)
- [ ] 场景选择页 (SceneListPage + SceneCard)
- [ ] 对话总结页 (SessionSummaryPage)
- [ ] 复习卡片页 (ReviewCardsPage + ReviewCard swipeable)
- [ ] 叽叽状态页 (JiJiStatusPage + PetStatusBar + PetMilestoneCard)

Backend:
- [ ] 场景CRUD API (10个MVP场景数据, 按CONTENT_SCENE_SPEC)
- [ ] 学习进度API (summary, vocabulary, cards)
- [ ] 鹦鹉状态API (status, milestones)
- [ ] XP计算逻辑 (PetGrowthSystem, 按MEMORY_SYSTEM_SPEC)

### Phase 2.4: Prompt + Scenes + Memory (W4, ~5 days)

**Goal**: 教学对话完整可运行, 记忆系统工作

Backend:
- [ ] 完整System Prompt (AI_PERSONA_SPEC全文)
- [ ] 10个场景Prompt (5入门+5日常, 按CONTENT_SCENE_SPEC)
- [ ] 短期记忆 (SessionMemory: Redis)
- [ ] 长期记忆 (UserProfile: PostgreSQL)
- [ ] SRS引擎 (改良SM-2, 间隔短30-50%)
- [ ] 自然复现策略 (NaturalReviewStrategy: 在新场景中注入旧词汇)
- [ ] 发音评估 (PronunciationAssessor: 可理解度评分)
- [ ] 难度动态调节 (DifficultyController)
- [ ] PromptContextBuilder (三层记忆组装)
- [ ] 个人记忆自动提取 (LLM从对话中提取个人信息)

### Phase 2.5: Child Mode + Auth (W5, ~5 days)

**Goal**: 双角色完整流程

Flutter:
- [ ] 首次启动/身份选择页 (Onboarding)
- [ ] 子女设置向导 (SetupWizardPage, 4步)
- [ ] 二维码生成+展示
- [ ] 父母扫码登录
- [ ] 密码切换子女端 (PasswordDialog)
- [ ] 子女仪表盘 (ChildDashboardPage + DashboardCard)
- [ ] 学习报告详情页

Backend:
- [ ] 子女注册API (手机号+验证码)
- [ ] 创建老人账号API (子女代创建)
- [ ] 二维码生成+验证
- [ ] 扫码登录API
- [ ] 子女仪表盘数据聚合API
- [ ] 周报生成API (WeeklyReport)

### Phase 2.6: Share + Push + Payment (W6, ~5 days)

**Goal**: 分享+推送+付费链路打通

Backend:
- [ ] 分享卡片服务端渲染 (ShareService: 750x1334 PNG)
- [ ] 推送服务 (PushService: 极光推送/Firebase)
- [ ] 每日邀约推送 (个性化, max 1/day)
- [ ] 子女周报推送 (周日20:00)
- [ ] 回流推送 (3/7/14天, max 3次)

Flutter:
- [ ] 微信SDK集成 (分享到朋友圈/好友)
- [ ] 分享卡片预览+分享流程
- [ ] 推送接收+处理 (Deep Link: 点击推送直达对话页)
- [ ] 付费页面 (套餐选择+支付)
- [ ] 微信支付/支付宝集成
- [ ] 试用到期提示 (TrialExpiredOverlay)

### Phase 2.7: Pet Growth + Polish (W7, ~5 days)

**Goal**: 完整MVP, 所有功能闭环

Flutter:
- [ ] 鹦鹉成长系统完善 (6阶段+里程碑)
- [ ] 成长动画 (进化动画)
- [ ] 离线模式 (复习卡片本地缓存)
- [ ] StreakBadge + LearningStatsMini
- [ ] 所有页面适老化验收 (字号/触控/配色/对比度)
- [ ] 页面过渡动画 (淡入淡出200ms)
- [ ] 加载状态 (鹦鹉思考动画替代spinner)
- [ ] 错误状态 (鹦鹉拟人化语言)

Backend:
- [ ] 场景赠送API
- [ ] 数据埋点框架 (核心事件, 按GROWTH_SPEC)
- [ ] API成本监控 (per-user daily cost tracking)
- [ ] 内容安全过滤 (LLM输出审核)

### Phase 2.8: Testing + Launch Prep (W8, ~5 days)

**Goal**: 可发布版本

- [ ] 后端单元测试 (services层, pytest)
- [ ] 后端集成测试 (API端点, 语音链路)
- [ ] Flutter Widget测试 (适老化组件)
- [ ] 语音链路端到端测试 (延迟<2秒验证)
- [ ] 适老化验收测试 (邀请3-5位老年用户)
- [ ] 性能优化 (首页加载<1秒, 语音延迟优化)
- [ ] 安全审查 (HTTPS/WSS, 数据加密, 内容过滤)
- [ ] 10个场景内容QA (按CONTENT_SCENE_SPEC清单)
- [ ] Docker生产配置 (Nginx+Gunicorn+2实例)
- [ ] 阿里云ECS部署
- [ ] App Store / Play Store准备

## Complexity Tracking

No constitution violations. All decisions follow MVP-First principle.

## Deployment Architecture (MVP)

```
阿里云ECS (2核4G x1, MVP足够)
├── Docker: Nginx (反向代理+SSL)
├── Docker: FastAPI x2 (Gunicorn workers)
├── Docker: PostgreSQL 16
└── Docker: Redis 7

阿里云OSS: 音频文件 + 分享卡片
External APIs: 阿里云ASR + 豆包LLM + 豆包TTS
```

Monthly cost estimate (MVP, <1000 users): ~¥500 (ECS) + ~¥100 (OSS) + API costs variable
