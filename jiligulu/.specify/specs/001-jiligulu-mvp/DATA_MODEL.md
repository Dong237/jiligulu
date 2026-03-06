# 叽里咕噜 — 数据模型 DATA_MODEL.md

> 版本: v2.0 | 关联: [TECH_SPEC.md](./TECH_SPEC.md) | 面向: 后端开发

---

## 一、ER关系图

```
┌──────────┐     ┌──────────┐     ┌──────────┐
│  Family   │────▶│   User   │────▶│ Session  │
│  (子女)   │ 1:N │  (老人)   │ 1:N │  (对话)   │
└──────────┘     └──────────┘     └──────────┘
                      │                 │
                      │ 1:N             │ 1:N
                      ▼                 ▼
                ┌──────────┐     ┌──────────┐
                │VocabItem │     │ Message  │
                │ (词汇SRS) │     │ (对话消息) │
                └──────────┘     └──────────┘
                      │
                ┌──────────┐     ┌──────────┐
                │PetStatus │     │  Scene   │
                │(鹦鹉状态) │     │ (场景)    │
                └──────────┘     └──────────┘
```

---

## 二、核心表结构

### 2.1 users（用户表）

```sql
CREATE TABLE users (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    role            VARCHAR(10) NOT NULL,  -- 'elder' | 'child'
    phone           VARCHAR(20) UNIQUE,
    nickname        VARCHAR(50),
    gender          VARCHAR(10),           -- 'female' | 'male'
    
    -- 老人专属字段
    english_level   VARCHAR(20) DEFAULT 'zero',  -- 'zero' | 'beginner' | 'elementary'
    dialect_region  VARCHAR(50),
    motivation      VARCHAR(50),           -- 'travel' | 'family_abroad' | 'brain_exercise'
    learning_goal   TEXT,                  -- "下月去泰国"
    preferred_time  VARCHAR(10),           -- "09:30"
    
    -- 学习统计
    total_sessions       INT DEFAULT 0,
    total_minutes        INT DEFAULT 0,
    total_phrases        INT DEFAULT 0,
    current_streak       INT DEFAULT 0,
    longest_streak       INT DEFAULT 0,
    last_active_date     DATE,
    
    -- 鹦鹉
    pet_xp          INT DEFAULT 0,
    pet_stage       INT DEFAULT 1,
    
    -- 订阅
    subscription_type    VARCHAR(20) DEFAULT 'free',  -- 'free' | 'annual' | 'gift'
    subscription_expires DATE,
    
    -- 元数据
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    updated_at      TIMESTAMPTZ DEFAULT NOW(),
    
    -- 个人记忆（JSONB灵活存储）
    personal_notes  JSONB DEFAULT '[]'
);
```

### 2.2 families（家庭关系表）

```sql
CREATE TABLE families (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    child_id    UUID NOT NULL REFERENCES users(id),   -- 子女
    elder_id    UUID NOT NULL REFERENCES users(id),    -- 老人
    relationship VARCHAR(20),  -- 'son' | 'daughter' | 'grandson' ...
    created_at  TIMESTAMPTZ DEFAULT NOW(),
    
    UNIQUE(child_id, elder_id)
);
```

### 2.3 sessions（对话会话表）

```sql
CREATE TABLE sessions (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID NOT NULL REFERENCES users(id),
    scene_id        VARCHAR(100),
    
    -- 时间
    started_at      TIMESTAMPTZ NOT NULL,
    ended_at        TIMESTAMPTZ,
    duration_seconds INT,
    
    -- 学习成果
    phrases_taught    JSONB DEFAULT '[]',     -- ["I'd like some", "How much"]
    phrases_mastered  JSONB DEFAULT '[]',
    pronunciation_scores JSONB DEFAULT '[]',  -- [{"phrase": "apple", "score": 75}]
    
    -- 难度
    avg_difficulty    FLOAT,
    success_rate      FLOAT,
    
    -- 鹦鹉
    pet_xp_gained     INT DEFAULT 0,
    
    -- 复习卡片
    review_card_id    UUID,
    
    -- 元数据
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_sessions_user_date ON sessions(user_id, started_at DESC);
```

### 2.4 messages（对话消息表）

```sql
CREATE TABLE messages (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id  UUID NOT NULL REFERENCES sessions(id),
    role        VARCHAR(10) NOT NULL,  -- 'user' | 'assistant'
    
    -- 内容
    text_content    TEXT,               -- 文本内容
    audio_url       VARCHAR(500),       -- 音频文件URL（可选）
    
    -- 用户消息专属
    asr_transcript  TEXT,               -- ASR原始转写
    pronunciation_score FLOAT,          -- 发音评分
    
    -- AI消息专属
    phrases_in_response JSONB,          -- 本条消息中教的短语
    emotion_tag     VARCHAR(20),        -- 'celebrating' | 'encouraging' | ...
    
    -- 序号
    seq_num         INT NOT NULL,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_messages_session ON messages(session_id, seq_num);
```

### 2.5 vocab_items（词汇SRS表）

```sql
CREATE TABLE vocab_items (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID NOT NULL REFERENCES users(id),
    
    -- 词汇信息
    english         VARCHAR(200) NOT NULL,
    chinese         VARCHAR(200) NOT NULL,
    phonetic_ipa    VARCHAR(200),
    phonetic_chinese VARCHAR(200),       -- 中文谐音
    scene_origin    VARCHAR(100),        -- 首次学习的场景
    
    -- SRS状态
    srs_level       INT DEFAULT 0,       -- 0-5
    next_review     DATE,
    last_reviewed   DATE,
    review_count    INT DEFAULT 0,
    times_correct   INT DEFAULT 0,
    times_incorrect INT DEFAULT 0,
    best_score      FLOAT DEFAULT 0,
    
    -- 复现记录
    scenes_used_in  JSONB DEFAULT '[]',
    
    -- 时间
    first_learned   TIMESTAMPTZ DEFAULT NOW(),
    updated_at      TIMESTAMPTZ DEFAULT NOW(),
    
    UNIQUE(user_id, english)
);

CREATE INDEX idx_vocab_review ON vocab_items(user_id, next_review);
```

### 2.6 scenes（场景配置表）

```sql
CREATE TABLE scenes (
    id              VARCHAR(100) PRIMARY KEY,
    name            VARCHAR(100) NOT NULL,
    description     TEXT,
    pack            VARCHAR(20) NOT NULL,  -- 'basic' | 'daily' | 'travel' | 'family'
    difficulty      INT DEFAULT 1,
    duration_minutes INT DEFAULT 6,
    is_free         BOOLEAN DEFAULT FALSE,
    sort_order      INT,
    
    -- 教学内容（JSONB）
    target_phrases  JSONB NOT NULL,        -- [{english, chinese, phonetic_ipa, phonetic_chinese}]
    scene_prompt    TEXT NOT NULL,          -- LLM场景Prompt
    opener_template TEXT,
    closer_template TEXT,
    
    -- 关联
    prerequisite_scenes JSONB DEFAULT '[]',
    review_from_scenes  JSONB DEFAULT '[]',
    
    -- 元数据
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

### 2.7 review_cards（复习卡片表）

```sql
CREATE TABLE review_cards (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     UUID NOT NULL REFERENCES users(id),
    session_id  UUID REFERENCES sessions(id),
    
    -- 卡片内容
    phrases     JSONB NOT NULL,            -- [{english, chinese, phonetic_ipa, phonetic_chinese}]
    scene_name  VARCHAR(100),
    
    -- 分享
    share_image_url VARCHAR(500),          -- 生成的分享卡片图片URL
    shared_at   TIMESTAMPTZ,               -- 是否已分享
    
    created_at  TIMESTAMPTZ DEFAULT NOW()
);
```

### 2.8 subscriptions（订阅表）

```sql
CREATE TABLE subscriptions (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     UUID NOT NULL REFERENCES users(id),    -- 老人
    purchaser_id UUID REFERENCES users(id),             -- 购买者（子女），自购则为NULL
    
    type        VARCHAR(20) NOT NULL,      -- 'annual' | 'gift_box'
    price_cents INT NOT NULL,              -- 价格（分）
    
    started_at  TIMESTAMPTZ NOT NULL,
    expires_at  TIMESTAMPTZ NOT NULL,
    
    -- 支付
    payment_channel VARCHAR(20),           -- 'wechat' | 'alipay' | 'apple'
    payment_id  VARCHAR(200),
    
    status      VARCHAR(20) DEFAULT 'active',  -- 'active' | 'expired' | 'cancelled'
    created_at  TIMESTAMPTZ DEFAULT NOW()
);
```

### 2.9 push_notifications（推送记录表）

```sql
CREATE TABLE push_notifications (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     UUID NOT NULL REFERENCES users(id),
    type        VARCHAR(30) NOT NULL,      -- 'daily_invite' | 'weekly_report' | 'milestone' | 'comeback'
    content     TEXT,
    
    sent_at     TIMESTAMPTZ DEFAULT NOW(),
    opened_at   TIMESTAMPTZ,               -- 用户是否打开
    action_taken BOOLEAN DEFAULT FALSE,    -- 用户是否执行了操作
);

CREATE INDEX idx_push_user_type ON push_notifications(user_id, type, sent_at DESC);
```

---

## 三、Redis数据结构

```
# 活跃会话状态
session:{session_id}        → Hash  (会话实时数据，TTL=1小时)
  user_id, scene_id, started_at, messages_count,
  phrases_taught, current_difficulty, user_mood

# 用户在线状态
user:online:{user_id}       → String (TTL=5分钟，心跳续期)

# 每日学习记录（防重复计算streak）
user:daily:{user_id}:{date} → String "1" (TTL=48小时)

# API速率限制
ratelimit:{user_id}:{endpoint} → Counter (TTL=对应窗口期)

# 场景缓存
scene:cache:{scene_id}      → Hash (场景数据缓存，TTL=1天)
```
