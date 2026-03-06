# 叽里咕噜 JiLiGuLu

AI英语学习伴侣 — 面向55-70岁中国退休人群

小鹦鹉"叽叽"通过语音对话，在生活场景中教老年人实用英语。子女付费、父母使用。

## 技术栈

| Layer | Tech |
|-------|------|
| 前端 | Flutter 3.x + Riverpod + GoRouter + Rive |
| 后端 | Python 3.12 + FastAPI + SQLAlchemy 2.0 + Alembic |
| 数据 | PostgreSQL 16 + Redis 7 |
| AI | 阿里云ASR + 豆包LLM + 豆包TTS |
| 部署 | Docker + 阿里云ECS |

## 项目结构

```
jiligulu/
├── backend/          # FastAPI后端
│   ├── app/
│   │   ├── api/      # API路由 (auth, voice, scenes, learning, family, pet, share)
│   │   ├── models/   # SQLAlchemy数据模型 (9张表)
│   │   ├── services/ # 业务逻辑 (voice_pipeline, memory, learning_engine, pet, push, share)
│   │   ├── prompts/  # Prompt模板 (system_prompt, scene_prompts, feedback)
│   │   └── utils/    # 工具 (pronunciation, content_filter)
│   └── migrations/   # Alembic数据库迁移
├── flutter_app/      # Flutter跨端App
│   └── lib/
│       ├── app/      # 主题 + 路由 + Shell
│       ├── features/ # 功能页面 (home, voice_chat, scenes, review, summary, pet, family, auth)
│       ├── shared/   # 共享组件 (elder_button, elder_text, elder_card, pet_animation, ...)
│       └── core/     # 基础设施 (providers, network, constants)
└── docker-compose.yml
```

## 本地开发

```bash
# 启动后端
docker compose up -d db redis
cd backend && pip install -r requirements.txt
uvicorn app.main:app --reload

# 启动Flutter
cd flutter_app && flutter run
```

## 核心架构

**语音管线**: 用户按住说话 → VAD → ASR转写 → LLM生成回复 → TTS合成 → 播放+字幕

**Provider抽象**: ASR/LLM/TTS通过ABC接口封装，可运行时切换供应商

**适老化**: 最小字号18sp，按钮64dp，无红色，鹦鹉拟人化提示替代技术错误
