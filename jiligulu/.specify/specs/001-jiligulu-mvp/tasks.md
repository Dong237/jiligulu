# Tasks: 叽里咕噜 MVP (JiLiGuLu MVP)

**Input**: [plan.md](./plan.md), [spec.md](./spec.md), [components.md](./components.md), [wireframes.md](./wireframes.md), [ia.md](./ia.md)
**Prerequisites**: plan.md (required), spec.md (required)

**Organization**: Tasks organized by 8 weekly phases, matching plan.md implementation phases.

## Format: `[ID] [P?] [Story?] Description`

- **[P]**: Can run in parallel (different files, no dependencies on incomplete tasks)
- **[US#]**: Maps to user story from spec.md
- **[UI]**: UI component task from components.md
- **Est**: Estimated hours

---

## Phase 1: 基础骨架 (W1) — Foundation

**Goal**: 可运行的空项目 + 本地开发环境 + 数据库schema + 适老化基础组件

**Checkpoint**: `docker compose up` 启动成功, Flutter app 可编译运行, 3 Tab 导航可切换

---

### 1.1 Flutter 项目初始化

- [ ] T001 [P] 初始化 Flutter 项目, 配置 pubspec.yaml 依赖 (riverpod, go_router, rive, web_socket_channel, record, just_audio, hive) `flutter_app/pubspec.yaml` — Est: 1h
- [ ] T002 [P] 配置 analysis_options.yaml (lint 规则) `flutter_app/analysis_options.yaml` — Est: 0.5h
- [ ] T003 适老化全局主题: 配色体系 (#1A8A7D/#F5A623/#FDFBF7/#1B2D45) + 字号层级 (18/22/28/32sp) + 按钮样式 `flutter_app/lib/app/theme.dart` — Depends: T001 — Est: 2h
- [ ] T004 GoRouter 路由配置 (14 个路由, 按 ia.md) + ElderShell/ChildShell 布局骨架 `flutter_app/lib/app/router.dart` — Depends: T001 — Est: 2h
- [ ] T005 MaterialApp + ProviderScope 入口配置 `flutter_app/lib/main.dart`, `flutter_app/lib/app/app.dart` — Depends: T003, T004 — Est: 1h

### 1.2 适老化基础组件库

- [ ] T006 [P] [UI] ElderButton: primary/secondary/outline/subtle, 48dp/64dp, haptic, debounce 300ms `flutter_app/lib/shared/widgets/elder_button.dart` — Depends: T003 — Est: 2h
- [ ] T007 [P] [UI] ElderText: title/subtitle/body/caption, 强制最小 18sp, 系统字号缩放 `flutter_app/lib/shared/widgets/elder_text.dart` — Depends: T003 — Est: 1h
- [ ] T008 [P] [UI] ElderCard: Cream White BG, 16dp radius, tappable + haptic `flutter_app/lib/shared/widgets/elder_card.dart` — Depends: T003 — Est: 1h
- [ ] T009 [P] [UI] ElderBottomNav: 3 tabs (首页/场景/叽叽), 18sp labels, 64dp height `flutter_app/lib/shared/widgets/elder_bottom_nav.dart` — Depends: T003 — Est: 1.5h
- [ ] T010 ElderShell 布局 (ElderBottomNav + SafeArea + page child) `flutter_app/lib/app/router.dart` (update) — Depends: T009 — Est: 1h

### 1.3 FastAPI 项目初始化

- [ ] T011 [P] 初始化 FastAPI 项目骨架: main.py (CORS/lifespan), config.py (env vars), requirements.txt `backend/app/main.py`, `backend/app/config.py`, `backend/requirements.txt` — Est: 2h
- [ ] T012 [P] SQLAlchemy 2.0 基础配置 + 数据库连接 `backend/app/database.py` — Est: 1h

### 1.4 数据库 Schema + 迁移

- [ ] T013 [P] SQLAlchemy 模型: users 表 + families 表 (按 DATA_MODEL.md) `backend/app/models/user.py` — Depends: T012 — Est: 2h
- [ ] T014 [P] SQLAlchemy 模型: sessions 表 + messages 表 `backend/app/models/session.py` — Depends: T012 — Est: 1.5h
- [ ] T015 [P] SQLAlchemy 模型: vocab_items 表 + review_cards 表 `backend/app/models/learning.py` — Depends: T012 — Est: 1.5h
- [ ] T016 [P] SQLAlchemy 模型: scenes 表 `backend/app/models/scene.py` — Depends: T012 — Est: 1h
- [ ] T017 [P] SQLAlchemy 模型: subscriptions 表 + push_notifications 表 `backend/app/models/subscription.py` — Depends: T012 — Est: 1h
- [ ] T018 models __init__.py 统一导出 `backend/app/models/__init__.py` — Depends: T013-T017 — Est: 0.5h
- [ ] T019 Alembic 初始化 + 初始迁移 (全部 9 张表) `backend/migrations/` — Depends: T018 — Est: 1.5h

### 1.5 Docker Compose

- [ ] T020 [P] Backend Dockerfile (Python 3.12 + FastAPI) `backend/Dockerfile` — Est: 1h
- [ ] T021 Docker Compose: PostgreSQL 16 + Redis 7 + FastAPI + Nginx `docker-compose.yml` — Depends: T020 — Est: 2h

### 1.6 API 路由骨架 + 基础设施

- [ ] T022 [P] API 路由骨架: auth, voice, scenes, learning, family, pet, share (空路由 + 健康检查) `backend/app/api/auth.py`, `backend/app/api/voice.py`, `backend/app/api/scenes.py`, `backend/app/api/learning.py`, `backend/app/api/family.py`, `backend/app/api/pet.py`, `backend/app/api/share.py` — Depends: T011 — Est: 2h
- [ ] T023 [P] Flutter API 客户端 + WebSocket 客户端骨架 `flutter_app/lib/core/network/api_client.dart`, `flutter_app/lib/core/network/ws_client.dart` — Depends: T001 — Est: 2h
- [ ] T024 [P] Riverpod providers 骨架 (auth, session, pet, audio) `flutter_app/lib/core/providers/auth_provider.dart`, `flutter_app/lib/core/providers/session_provider.dart`, `flutter_app/lib/core/providers/pet_provider.dart`, `flutter_app/lib/core/providers/audio_provider.dart` — Depends: T001 — Est: 2h

**Phase 1 Total**: ~31h (~4 days)

---

## Phase 2: 语音链路打通 (W2) — Voice Pipeline

**Goal**: 端到端语音对话可运行, 用户可用语音和 AI 对话

**Checkpoint**: 按住说话 → 听到叽叽回复, 延迟 < 3 秒 (demo 级)

**Depends**: Phase 1 完成

---

### 2.1 后端: Provider 抽象层

- [ ] T025 [P] ASR 抽象接口 (ASRProvider ABC) + 阿里云语音识别实现 `backend/app/services/asr_service.py` — Est: 3h
- [ ] T026 [P] LLM 抽象接口 (LLMProvider ABC) + 豆包 API 实现 (流式) `backend/app/services/llm_service.py` — Est: 3h
- [ ] T027 [P] TTS 抽象接口 (TTSProvider ABC) + 豆包 TTS 实现 (流式) `backend/app/services/tts_service.py` — Est: 3h

### 2.2 后端: Pipeline 编排

- [ ] T028 VoicePipeline 编排器: 串联 ASR→LLM→TTS 流式处理 `backend/app/services/voice_pipeline.py` — Depends: T025, T026, T027 — Est: 4h
- [ ] T029 基础 System Prompt (AI_PERSONA_SPEC 精简版: 角色+对话规则) `backend/app/prompts/system_prompt.py` — Est: 2h
- [ ] T030 WebSocket 语音对话端点 (协议: audio_chunk/control/transcript/response_text/response_audio) `backend/app/api/voice.py` (update) — Depends: T028, T029 — Est: 4h
- [ ] T031 错误降级链 (retry → 备用 provider → 兜底话术 "叽叽没听清") `backend/app/services/voice_pipeline.py` (update) — Depends: T028 — Est: 2h

### 2.3 Flutter: 音频 + WebSocket

- [ ] T032 [P] 音频录制模块 (record package, PCM16 16kHz) `flutter_app/lib/features/voice_chat/audio/audio_recorder.dart` — Est: 2h
- [ ] T033 [P] VAD 检测 (silero-vad via Platform Channel, 静音阈值 2.5 秒) `flutter_app/lib/features/voice_chat/audio/vad_detector.dart` — Est: 3h
- [ ] T034 [P] 音频流式播放 (just_audio) `flutter_app/lib/features/voice_chat/audio/audio_player.dart` — Est: 2h
- [ ] T035 WebSocket 客户端: 音频流发送 + 响应接收 (transcript/response_text/response_audio) `flutter_app/lib/core/network/ws_client.dart` (update) — Depends: T032, T033, T034 — Est: 3h

### 2.4 Flutter: 语音对话页骨架

- [ ] T036 [P] [UI] TalkButton 组件: 按住说话, idle/recording/processing 三态, 64dp, haptic `flutter_app/lib/features/voice_chat/widgets/talk_button.dart` — Depends: T006 — Est: 2h
- [ ] T037 [P] [UI] SubtitleDisplay 组件: 消息列表, 自动滚动, 流式 typewriter 效果 `flutter_app/lib/features/voice_chat/widgets/subtitle_display.dart` — Depends: T007 — Est: 2h
- [ ] T038 VoiceChatPage 骨架: TalkButton + SubtitleDisplay + WebSocket 集成 `flutter_app/lib/features/voice_chat/voice_chat_page.dart`, `flutter_app/lib/features/voice_chat/voice_chat_controller.dart` — Depends: T035, T036, T037 — Est: 3h
- [ ] T039 voice_chat Riverpod controller: 录音状态 + WebSocket 生命周期 + 消息流 `flutter_app/lib/features/voice_chat/voice_chat_controller.dart` (update) — Depends: T038 — Est: 2h

### 2.5 端到端联调

- [ ] T040 端到端测试: 按住说话 → ASR 转写 → LLM 回复 → TTS 播放, 验证全链路 — Depends: T030, T039 — Est: 3h

**Phase 2 Total**: ~43h (~5.5 days)

---

## Phase 3: UI 与动画 (W3) — UI + Parrot Animation

**Goal**: 首页 + 对话页完整可用, 鹦鹉动画集成, 底部导航完整

**Checkpoint**: 打开 App 看到叽叽, 导航三个 Tab, 对话页有鹦鹉 + 字幕 + 快捷回复

**Depends**: Phase 2 完成 (VoiceChatPage 骨架)

---

### 3.1 鹦鹉动画

- [ ] T041 [P] [US7] [UI] PetAnimationWidget: Rive 集成, 7 个状态 (sleeping/greeting/teaching/happy/encouraging/thinking/farewell), 3 sizes `flutter_app/lib/shared/widgets/pet_animation_widget.dart` — Est: 4h
- [ ] T042 [P] [US7] Rive 动画资源准备 (鹦鹉状态机文件, 或 placeholder 动画) `flutter_app/lib/assets/animations/jiji.riv` — Est: 2h

### 3.2 首页

- [ ] T043 [P] [UI] StreakBadge: 连续学习 N 天, 隐藏 if 0 `flutter_app/lib/shared/widgets/streak_badge.dart` — Est: 0.5h
- [ ] T044 [P] [UI] LearningStatsMini: 今日/本周对话数+短语数, compact 横排 `flutter_app/lib/shared/widgets/learning_stats_mini.dart` — Est: 1h
- [ ] T045 [US3] HomePage: PetAnimationWidget (60%) + "开始聊天" ElderButton (64dp) + StreakBadge + LearningStatsMini + 快捷入口 `flutter_app/lib/features/home/home_page.dart`, `flutter_app/lib/features/home/home_controller.dart` — Depends: T041, T043, T044, T006, T009 — Est: 3h

### 3.3 语音对话页完善

- [ ] T046 [P] [US1] [UI] PhraseHighlight: EN (28sp green) + IPA + CN + 谐音 (orange), 可点击听发音 `flutter_app/lib/shared/widgets/phrase_highlight.dart` — Est: 2h
- [ ] T047 [P] [US1] [UI] QuickReplyBar: 3 按钮 ("再说一遍"/"太难了"/"换一个"), outline, 48dp `flutter_app/lib/features/voice_chat/widgets/quick_reply_bar.dart` — Est: 1h
- [ ] T048 [US1] VoiceChatPage 完善: 顶部 PetAnimationWidget (teaching/happy/thinking 联动) + PhraseHighlight 在字幕中 + QuickReplyBar `flutter_app/lib/features/voice_chat/voice_chat_page.dart` (update) — Depends: T041, T046, T047 — Est: 3h

### 3.4 对话总结页

- [ ] T049 [P] [UI] PetStatusBar: XP 进度条 + 阶段名称, 动画 fill `flutter_app/lib/shared/widgets/pet_status_bar.dart` — Est: 1.5h
- [ ] T050 [US1] SessionSummaryPage: PetAnimationWidget (farewell) + 本次短语列表 + XP + 两个 CTA ("看复习卡片"/"返回首页") `flutter_app/lib/features/summary/session_summary_page.dart` — Depends: T041, T049, T046 — Est: 2.5h

### 3.5 场景选择页

- [ ] T051 [P] [US2] [UI] SceneCard: 80dp+ height, 难度星级, locked/completed 状态 `flutter_app/lib/features/scenes/widgets/scene_card.dart` — Est: 1.5h
- [ ] T052 [US2] SceneListPage: 按 pack 分组, SceneCard 列表, 底部导航 "场景" Tab `flutter_app/lib/features/scenes/scene_list_page.dart` — Depends: T051 — Est: 2h

### 3.6 底部导航完整集成

- [ ] T053 GoRouter shell 路由完善: Home/Scenes/JiJi 三 Tab 切换 + 嵌套路由 `flutter_app/lib/app/router.dart` (update) — Depends: T045, T052 — Est: 1.5h

### 3.7 后端 API 支撑

- [ ] T054 [P] [US2] 场景 CRUD API + 10 个 MVP 场景 seed 数据 (5 入门 + 5 日常) `backend/app/api/scenes.py` (update), `backend/app/services/scene_engine.py` — Est: 3h
- [ ] T055 [P] [US1] 学习进度 API (summary, vocabulary list) `backend/app/api/learning.py` (update) — Est: 2h
- [ ] T056 [P] [US9] 鹦鹉状态 API (status: XP/stage, milestones) `backend/app/api/pet.py` (update), `backend/app/services/pet_service.py` — Est: 2h

### 3.8 适老化全局验证

- [ ] T057 [US3] 全页面适老化检查: 最小字号 18sp, 触控 48dp, 无红色, 暖色 loading, 3-click 规则 — Depends: T045, T048, T050, T052 — Est: 2h

**Phase 3 Total**: ~34h (~4.5 days)

---

## Phase 4: AI 教学能力 (W4) — Prompt + Scenes + Memory

**Goal**: 教学对话完整可运行, 场景 Prompt 驱动, 记忆系统工作, 复习卡片可用

**Checkpoint**: 选择 "买水果" 场景 → 完成对话 → 学 3 个短语 → 看到复习卡片 → 下次对话叽叽记得

**Depends**: Phase 2 (voice pipeline), Phase 3 (scene/review UI)

---

### 4.1 Prompt 系统

- [ ] T058 [P] [US1] 完整 System Prompt: AI_PERSONA_SPEC 全文 (角色 + 对话规则 + 禁止行为 + 7 条代理原则) `backend/app/prompts/system_prompt.py` (update) — Est: 3h
- [ ] T059 [P] [US2] 5 个入门场景 Prompt 模板 (买水果/打招呼/问路/点餐/购物) `backend/app/prompts/scene_prompts/` — Est: 3h
- [ ] T060 [P] [US2] 5 个日常场景 Prompt 模板 (看医生/坐出租/酒店入住/打电话/公园聊天) `backend/app/prompts/scene_prompts/` — Est: 3h
- [ ] T061 [P] 反馈话术模板 (正面肯定+温和纠正+鼓励重试+兜底回复) `backend/app/prompts/feedback_prompts.py` — Est: 1.5h

### 4.2 记忆系统

- [ ] T062 [P] [US1] 短期记忆 SessionMemory: Redis 存储, 对话历史 + 教学进度 + 情感状态 `backend/app/services/memory_service.py` — Est: 3h
- [ ] T063 [P] [US1] 长期记忆 UserProfile: PostgreSQL, 学习偏好 + 个人背景 + 情感记忆 `backend/app/services/memory_service.py` (update) — Est: 2h
- [ ] T064 PromptContextBuilder: 三层记忆组装 (System Prompt + 用户画像 + 学习历史 + 场景 + 会话 + 用户输入) `backend/app/services/memory_service.py` (update) — Depends: T058, T062, T063 — Est: 3h
- [ ] T065 个人记忆自动提取: LLM 从对话中提取个人信息 (名字/爱好/家庭) 写入 UserProfile `backend/app/services/memory_service.py` (update) — Depends: T064 — Est: 2h

### 4.3 发音评估 + ASR 后处理

- [ ] T066 [P] 发音评估 PronunciationAssessor: 可理解度评分 (非标准度), 模糊匹配 `backend/app/utils/pronunciation.py` — Est: 3h
- [ ] T067 [P] ASR 后处理管线: 填充词过滤 + 中英分离 + 拼音映射 + 模糊匹配 `backend/app/utils/audio.py` — Est: 2.5h

### 4.4 对话结束 + 复习卡片生成

- [ ] T068 [US6] 对话结束总结: 提取本次学习短语 + XP 计算 + 生成 review_cards 数据库记录 `backend/app/services/voice_pipeline.py` (update), `backend/app/api/learning.py` (update) — Depends: T064 — Est: 3h
- [ ] T069 [US6] 复习卡片 API: GET /learning/cards (返回短语列表 + 音标 + 谐音 + 音频 URL) `backend/app/api/learning.py` (update) — Depends: T068 — Est: 1.5h

### 4.5 Flutter: 复习卡片页

- [ ] T070 [P] [US6] [UI] ReviewCard: 可滑动卡片, PhraseHighlight + "点击听发音" ElderButton `flutter_app/lib/features/review/widgets/review_card.dart` — Depends: T046 — Est: 2h
- [ ] T071 [US6] ReviewCardsPage: 卡片翻页 + PageIndicator + "分享到微信" 按钮 (placeholder) `flutter_app/lib/features/review/review_cards_page.dart` — Depends: T070 — Est: 2h

### 4.6 难度调节

- [ ] T072 DifficultyController: 根据用户表现动态调节 LLM 参数 (词汇难度/语速/中英比例) `backend/app/services/voice_pipeline.py` (update) — Depends: T064, T066 — Est: 2h

**Phase 4 Total**: ~36h (~4.5 days)

---

## Phase 5: 子女端 (W5) — Child Mode + Auth

**Goal**: 双角色完整流程: 子女注册→设置父母→扫码登录→子女查看学习报告

**Checkpoint**: 子女从零注册 → 填父母信息 → 生成 QR → 父母扫码登录 → 子女切换查看仪表盘

**Depends**: Phase 1 (DB schema), Phase 3 (ElderShell)

---

### 5.1 后端: 认证系统

- [ ] T073 [P] [US4] JWT 认证中间件 + 子女注册 API (手机号 + 验证码) `backend/app/api/auth.py` (update) — Est: 3h
- [ ] T074 [P] [US4] 创建老人账号 API (子女代创建, 无密码) `backend/app/api/auth.py` (update) — Est: 2h
- [ ] T075 [US4] 二维码生成 + 验证 API (生成含 token 的 QR, 扫码验证) `backend/app/api/auth.py` (update) — Depends: T074 — Est: 2.5h
- [ ] T076 [US4] 扫码登录 API (父母扫 QR → 自动拿到 token → 登录) `backend/app/api/auth.py` (update) — Depends: T075 — Est: 2h
- [ ] T077 [P] Token 刷新 API `backend/app/api/auth.py` (update) — Est: 1h

### 5.2 后端: 家庭 + 报告

- [ ] T078 [P] [US5] 家庭关系 API: 绑定子女-老人, 查询家庭成员 `backend/app/api/family.py` (update) — Est: 2h
- [ ] T079 [US5] 子女仪表盘数据聚合 API: 周对话次数/时长/新词/连续天数/叽叽状态 `backend/app/api/family.py` (update) — Depends: T078 — Est: 2.5h
- [ ] T080 [US5] 周报生成 API: 按周聚合学习数据, 生成 WeeklyReport `backend/app/api/learning.py` (update) — Depends: T079 — Est: 2h

### 5.3 Flutter: 设置向导

- [ ] T081 [P] [US4] [UI] SetupWizardStep: step indicator + title + content + next/back `flutter_app/lib/features/onboarding/widgets/setup_wizard_step.dart` — Est: 1.5h
- [ ] T082 [US4] SetupWizardPage: 4 步 (注册→父母信息→目标→QR), step 间表单数据保持 `flutter_app/lib/features/family/setup_wizard_page.dart` — Depends: T081 — Est: 3h
- [ ] T083 [US4] QR 码展示 + 扫码登录 Flutter 集成 `flutter_app/lib/features/family/setup_wizard_page.dart` (update) — Depends: T082, T075 — Est: 2h
- [ ] T084 [US4] 首次启动身份选择页 (Onboarding): "帮爸妈设置" / "我是爸妈(扫码)" `flutter_app/lib/features/auth/onboarding_page.dart` — Depends: T005 — Est: 1.5h

### 5.4 Flutter: 子女仪表盘

- [ ] T085 [P] [US5] [UI] DashboardCard: 周学习概览 (次数/分钟/新词/连续天数/叽叽状态) `flutter_app/lib/features/family/widgets/dashboard_card.dart` — Est: 1.5h
- [ ] T086 [P] [US5] ChildShell: 顶部 header ("返回老人端" + 标题) `flutter_app/lib/app/router.dart` (update) — Est: 1h
- [ ] T087 [US5] PasswordDialog: 4 位 PIN 输入, 错误提示 "这是家人管理的入口哦" `flutter_app/lib/shared/widgets/password_dialog.dart` — Depends: T006 — Est: 1.5h
- [ ] T088 [US5] ChildDashboardPage: DashboardCard + "详细报告" + "一键分享" (placeholder) + 设置 `flutter_app/lib/features/family/child_dashboard_page.dart` — Depends: T085, T086, T087 — Est: 2.5h
- [ ] T089 [US5] 周报展示页: WeeklyReportCard `flutter_app/lib/features/family/widgets/weekly_report_card.dart`, `flutter_app/lib/features/family/learning_report_page.dart` — Depends: T080 — Est: 2h

### 5.5 Flutter: 模式切换

- [ ] T090 [US5] JiJiStatusPage: PetAnimationWidget + PetStatusBar + PetMilestoneCard + "家人管理" 入口 (触发 PasswordDialog) `flutter_app/lib/features/pet/jiji_status_page.dart` — Depends: T041, T049, T087 — Est: 2.5h
- [ ] T091 [US5] 密码切换子女/老人模式路由逻辑 (密码验证 → 切换到 ChildShell) `flutter_app/lib/core/providers/auth_provider.dart` (update) — Depends: T087, T088 — Est: 1.5h

**Phase 5 Total**: ~37h (~5 days)

---

## Phase 6: 分享与推送 (W6) — Share + Push

**Goal**: 复习卡片+仪表盘可分享到微信, 推送可唤醒用户

**Checkpoint**: 分享卡片到微信成功 + 点推送直达对话页

**Depends**: Phase 4 (review cards), Phase 5 (child dashboard)

---

### 6.1 后端: 分享服务

- [ ] T092 [P] [US11] 分享卡片服务端渲染: Pillow 生成 750x1334 PNG (鹦鹉 IP + 学习数据 + 二维码) `backend/app/services/share_service.py` — Est: 4h
- [ ] T093 [P] [US11] 分享 API: POST /share/card (生成图片 → 上传 OSS → 返回 URL) `backend/app/api/share.py` (update) — Depends: T092 — Est: 2h

### 6.2 后端: 推送服务

- [ ] T094 [P] [US10] 推送服务 (PushService: 极光推送/Firebase 抽象) `backend/app/services/push_service.py` — Est: 3h
- [ ] T095 [US10] 每日邀约推送定时任务: 个性化内容 (含昨天学的短语), max 1/day `backend/app/services/push_service.py` (update) — Depends: T094 — Est: 2.5h
- [ ] T096 [US5] 子女周报推送 (周日 20:00) `backend/app/services/push_service.py` (update) — Depends: T094, T080 — Est: 1.5h
- [ ] T097 [US10] 回流推送: 3/7/14 天未活跃, max 3 次 `backend/app/services/push_service.py` (update) — Depends: T094 — Est: 1.5h

### 6.3 Flutter: 微信分享

- [ ] T098 [P] [US11] 微信 SDK 集成 (fluwx 插件配置) `flutter_app/pubspec.yaml` (update), `flutter_app/lib/core/wechat/wechat_service.dart` — Est: 2h
- [ ] T099 [US11] [UI] ShareButton: 请求服务端生成图片 → 预览 → 微信分享 `flutter_app/lib/features/family/widgets/share_button.dart` — Depends: T093, T098 — Est: 2.5h
- [ ] T100 [US6] 复习卡片页 "分享到微信" 功能激活 `flutter_app/lib/features/review/review_cards_page.dart` (update) — Depends: T099 — Est: 1h
- [ ] T101 [US5] 子女仪表盘 "一键分享" 功能激活 `flutter_app/lib/features/family/child_dashboard_page.dart` (update) — Depends: T099 — Est: 1h

### 6.4 Flutter: 推送接收

- [ ] T102 [US10] 推送接收 + Deep Link 处理: 点击推送 → 直达 VoiceChatPage (跳过首页) `flutter_app/lib/core/push/push_handler.dart` — Depends: T094 — Est: 2.5h

**Phase 6 Total**: ~23.5h (~3 days)

---

## Phase 7: 宠物成长 + 收尾 (W7) — Pet Growth + Polish

**Goal**: 完整 MVP, 所有功能闭环, 离线可用, 适老化验收

**Checkpoint**: 连续学 3 天 → 叽叽升级 → 看到成长动画; 断网可看复习卡片

**Depends**: Phase 4 (learning engine), Phase 5 (JiJi page)

---

### 7.1 后端: 宠物成长

- [ ] T103 [P] [US9] 宠物 XP 系统: 对话 +10XP, 新短语 +5XP, 连续打卡 +15XP, 6 阶段门槛 `backend/app/services/pet_service.py` (update) — Est: 2.5h
- [ ] T104 [US9] 成长阶段逻辑: 蛋蛋期→毛球期→雏鸟期→学飞期→彩羽期→歌唱期, 里程碑触发 `backend/app/services/pet_service.py` (update) — Depends: T103 — Est: 2h

### 7.2 后端: SRS 引擎

- [ ] T105 [US8] SRS 间隔重复引擎: 改良 SM-2 (间隔短 30-50%), 查询到期词汇 `backend/app/services/learning_engine.py` — Est: 3h
- [ ] T106 [US8] 自然复现策略 NaturalReviewStrategy: 在新场景 Prompt 中注入到期复习词汇 `backend/app/services/learning_engine.py` (update) — Depends: T105, T064 — Est: 2.5h

### 7.3 后端: 补充场景 + 安全

- [ ] T107 [P] [US2] 5 个日常场景数据 seed (看医生/坐出租/酒店入住/打电话/公园聊天) `backend/app/services/scene_engine.py` (update) — Est: 1.5h
- [ ] T108 [P] 内容安全过滤: LLM 输出审核 (敏感词检测 + 兜底替换) `backend/app/utils/content_filter.py` — Est: 2h
- [ ] T109 [P] API 成本监控: per-user daily cost tracking (Redis counter) `backend/app/utils/cost_tracker.py` — Est: 1.5h

### 7.4 Flutter: 叽叽成长页完善

- [ ] T110 [P] [US9] [UI] PetMilestoneCard: 已达成里程碑 (orange border), 未达成隐藏 `flutter_app/lib/shared/widgets/pet_milestone_card.dart` — Est: 1h
- [ ] T111 [US9] JiJiStatusPage 完善: 成长阶段信息 + XP 进度条 + 里程碑时间线 `flutter_app/lib/features/pet/jiji_status_page.dart` (update) — Depends: T110, T104 — Est: 2h

### 7.5 Flutter: 离线 + 错误处理

- [ ] T112 [P] 离线模式: 复习卡片本地缓存 (Hive), OfflineOverlay (鹦鹉睡觉 + "看复习卡片") `flutter_app/lib/core/storage/offline_cache.dart`, `flutter_app/lib/shared/widgets/offline_overlay.dart` — Est: 3h
- [ ] T113 [P] 全局错误处理: 网络异常 → 鹦鹉拟人化提示 ("叽叽休息了"), 无红色 `flutter_app/lib/core/network/error_handler.dart` — Est: 2h
- [ ] T114 [P] 加载状态: 鹦鹉思考动画替代 spinner (全局替换) `flutter_app/lib/shared/widgets/elder_loading.dart` — Est: 1h

### 7.6 Flutter: 收尾 Polish

- [ ] T115 [P] [UI] AudioWaveform: 录音波形动画 (Warm Orange 色) `flutter_app/lib/features/voice_chat/widgets/audio_waveform.dart` — Est: 1.5h
- [ ] T116 [P] 页面过渡动画: 淡入淡出 200ms `flutter_app/lib/app/router.dart` (update) — Est: 1h
- [ ] T117 所有页面适老化最终验收: 字号/触控/配色/对比度 (>= 7:1) — Depends: All UI tasks — Est: 2h

**Phase 7 Total**: ~29h (~4 days)

---

## Phase 8: 测试与上架 (W8) — Testing + Launch

**Goal**: 可发布版本, 通过测试, 部署上线

**Checkpoint**: 全链路测试通过, 3-5 位老年用户场景走查通过, App Store 审核提交

**Depends**: Phase 7 完成

---

### 8.1 后端测试

- [ ] T118 [P] 后端单元测试: services 层 (voice_pipeline, memory_service, learning_engine, pet_service) `backend/tests/unit/` — Est: 4h
- [ ] T119 [P] 后端集成测试: API 端点 (auth, scenes, learning, family) `backend/tests/integration/` — Est: 3h
- [ ] T120 语音链路端到端测试: 录音→ASR→LLM→TTS→播放, 验证延迟 < 2 秒 `backend/tests/integration/test_voice_pipeline.py` — Depends: T118 — Est: 2h

### 8.2 Flutter 测试

- [ ] T121 [P] Flutter Widget 测试: 适老化组件 (ElderButton, ElderText, ElderCard, ElderBottomNav) `flutter_app/test/` — Est: 2h
- [ ] T122 [P] Flutter Widget 测试: 核心页面 (HomePage, VoiceChatPage, ReviewCardsPage) `flutter_app/test/` — Est: 2h

### 8.3 场景走查

- [ ] T123 老年用户场景走查: 邀请 3-5 位 55-70 岁用户, 无指导完成首次对话 (目标 >= 80% 成功率) — Depends: T117 — Est: 4h
- [ ] T124 10 个场景内容 QA: 按 CONTENT_SCENE_SPEC 清单验证每个场景教学完整性 — Depends: T059, T060, T107 — Est: 3h

### 8.4 性能优化

- [ ] T125 [P] 首页加载优化: 目标 < 1 秒 (预加载 Rive, 缓存用户数据) — Est: 2h
- [ ] T126 [P] 语音延迟优化: 目标 < 2 秒 (ASR 流式优化, LLM TTFT 调优, TTS 预缓冲) — Est: 3h

### 8.5 部署 + 上架

- [ ] T127 [P] Docker 生产配置: Nginx (SSL) + Gunicorn (2 workers) + 健康检查 `docker-compose.prod.yml`, `backend/gunicorn.conf.py` — Est: 2h
- [ ] T128 阿里云 ECS 部署: 2 核 4G, Docker Compose, 域名 + SSL 配置 — Depends: T127 — Est: 3h
- [ ] T129 [P] App 图标 + 启动页 (鹦鹉 splash) `flutter_app/lib/assets/images/` — Est: 1.5h
- [ ] T130 [P] iOS App Store 准备: 截图/描述/隐私政策/审核材料 — Est: 3h
- [ ] T131 [P] Android Play Store 准备: 截图/描述/签名/上架材料 — Est: 2h
- [ ] T132 安全审查: HTTPS/WSS 全链路, Token 安全, 输入校验, 内容过滤验证 — Depends: T128 — Est: 2h

**Phase 8 Total**: ~37.5h (~5 days)

---

## Dependencies & Execution Order

### Phase Dependencies

```
Phase 1 (W1): 基础骨架 ──────────────────────────┐
  ↓                                                │
Phase 2 (W2): 语音链路 ← depends on Phase 1       │
  ↓                                                │
Phase 3 (W3): UI + 动画 ← depends on Phase 2      │
  ↓                     ↘                          │
Phase 4 (W4): AI 教学   Phase 5 (W5): 子女端 ← depends on Phase 1
  ↓                     ↓
Phase 6 (W6): 分享推送 ← depends on Phase 4 + 5
  ↓
Phase 7 (W7): 宠物成长 + 收尾 ← depends on Phase 4 + 5
  ↓
Phase 8 (W8): 测试上架 ← depends on Phase 7
```

### Key Parallel Opportunities

**Phase 1 内部**:
- T006-T009 (4 个适老化组件) 可完全并行
- T013-T017 (5 个 SQLAlchemy 模型) 可完全并行
- T011 (FastAPI) 和 T001 (Flutter) 可并行 (前后端独立)

**Phase 2 内部**:
- T025-T027 (ASR/LLM/TTS 三个 Provider) 可完全并行
- T032-T034 (recorder/VAD/player) 可完全并行
- 后端 Provider (T025-T027) 和 Flutter 音频 (T032-T034) 可并行

**Phase 3 + Phase 5 可部分并行**:
- Phase 5 的后端 auth (T073-T077) 仅依赖 Phase 1, 可与 Phase 3 并行开发

**Phase 4 内部**:
- Prompt 模板 (T058-T061) 可完全并行
- 记忆系统 (T062-T063) 可并行
- 发音评估 (T066) 和 ASR 后处理 (T067) 可并行

### Within-Phase Execution (示例: Phase 2)

```bash
# Step 1: 三个 Provider 并行开发 (T025, T026, T027)
# Step 2: Pipeline 编排 (T028) ← 等 Step 1 全部完成
# Step 3: Flutter 音频三件套并行 (T032, T033, T034) ← 可与 Step 2 并行
# Step 4: WebSocket 端点 (T030) + WS 客户端 (T035) ← 等 Step 2, Step 3
# Step 5: 语音对话页组装 (T038-T039) ← 等 Step 4
# Step 6: 端到端联调 (T040) ← 等 Step 5
```

---

## Implementation Strategy

### MVP First (Phase 1-3)

1. Complete Phase 1: 基础骨架 → Docker up, Flutter 可编译
2. Complete Phase 2: 语音链路 → **核心价值验证**: 能用语音和 AI 对话
3. Complete Phase 3: UI + 动画 → **可演示 MVP**: 完整 UI + 鹦鹉
4. **STOP and VALIDATE**: 邀请 2-3 位老年用户试用

### Full MVP (Phase 4-7)

5. Phase 4: AI 教学 → 教学质量验证
6. Phase 5: 子女端 → 双角色闭环
7. Phase 6: 分享推送 → 增长飞轮
8. Phase 7: 宠物成长 + Polish → 完整体验

### Launch (Phase 8)

9. Phase 8: 测试 + 部署 + 上架

---

## Summary

| Metric | Value |
|--------|-------|
| Total Tasks | 132 |
| Phase 1 (W1) | 24 tasks, ~31h |
| Phase 2 (W2) | 16 tasks, ~43h |
| Phase 3 (W3) | 17 tasks, ~34h |
| Phase 4 (W4) | 15 tasks, ~36h |
| Phase 5 (W5) | 19 tasks, ~37h |
| Phase 6 (W6) | 11 tasks, ~23.5h |
| Phase 7 (W7) | 15 tasks, ~29h |
| Phase 8 (W8) | 15 tasks, ~37.5h |
| **Total** | **132 tasks, ~271h (~8 weeks)** |
| Parallelizable tasks | 68 (51%) |
| User stories covered | US1-US12 (all 12) |

---

## Notes

- [P] = 可并行, 与标记同组的其他 [P] task 无依赖
- Est = 预估工时 (单人), 含调试时间
- 每个 Phase 结束有 Checkpoint, 可独立验证
- Phase 3 结束即可做早期用户测试
- 中文 commit message, 按宪法 Code Quality Standards
