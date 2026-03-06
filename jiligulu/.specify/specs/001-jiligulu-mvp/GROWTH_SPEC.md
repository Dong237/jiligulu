# 叽里咕噜 — 增长与运营策略 GROWTH_SPEC.md

> 版本: v2.0 | 关联: [PRD.md](./PRD.md) | 面向: 产品/运营/开发（埋点）

---

## 一、增长飞轮模型

```
                    ┌──────────────┐
                    │   子女获客     │ ← 小红书/抖音/节日营销
                    └──────┬───────┘
                           ▼
                    ┌──────────────┐
                    │ 子女帮父母设置  │ ← 3分钟完成
                    └──────┬───────┘
                           ▼
                    ┌──────────────┐
                    │ 父母日常使用   │ ← 情感陪伴+学习效果驱动
                    └──────┬───────┘
                           ▼
                    ┌──────────────┐
                    │ 子女收到周报   │ ← "妈妈学了23个新词"
                    └──────┬───────┘
                           ▼
                    ┌──────────────┐
                    │ 子女一键分享   │ ← 朋友圈/家族群
                    └──────┬───────┘
                           ▼
                    ┌──────────────┐
                    │ 其他子女好奇   │ ← "这是什么？我也给我妈买一个"
                    └──────┬───────┘
                           ▼
                    (回到子女获客)
```

---

## 二、获客策略

### 2.1 核心渠道：子女社交媒体

| 渠道 | 内容策略 | 预算 | 目标CPA |
|------|---------|------|---------|
| 小红书 | "我给妈妈下了个学英语的App"体验分享 | ¥5K/月起 | < ¥100 |
| 抖音 | "退休阿姨和AI鹦鹉聊英语"温馨短视频 | ¥5K/月起 | < ¥150 |
| 微信朋友圈广告 | "送爸妈一个英语小伙伴"精准投放25-40岁 | ¥3K/月起 | < ¥200 |

### 2.2 节日营销（关键爆发点）

```
母亲节（5月）：  "送妈妈的英语学习礼包" → 孝心礼盒版主推
父亲节（6月）：  "爸爸也能学英语" → 叔叔版场景推广
重阳节（10月）： "陪伴是最好的礼物" → 情感营销
春节（1-2月）：  "新年送爸妈新技能" → 年度大促
```

### 2.3 口碑裂变机制

```python
REFERRAL_SYSTEM = {
    # 子女分享学习成果到朋友圈
    "share_weekly_report": {
        "trigger": "子女收到周报推送",
        "action": "一键生成分享卡片",
        "incentive": "分享后父母获得1天额外会员",
    },
    
    # 老人分享复习卡片到家族群
    "share_review_card": {
        "trigger": "每次对话结束",
        "action": "复习卡片带产品二维码",
        "incentive": "无（自然传播）",
    },
    
    # 子女邀请其他子女
    "invite_friend": {
        "trigger": "子女端设置页",
        "action": "生成邀请链接",
        "incentive": "双方各获1个月会员延期",
    },
}
```

### 2.4 老年大学合作

```
合作模式：
  → 联系当地老年大学英语班
  → 提供"课后练习工具"免费试用
  → 老年大学学员作为种子用户
  → 学员口碑传播给身边朋友

目标：MVP阶段合作2-3所老年大学，获取200+种子用户
```

---

## 三、留存策略

### 3.1 七层留存防线

```
Layer 1: 情感陪伴（Day 1-3）
  → 叽叽的个性化问候 + "它记得我"的惊喜感
  → 首次对话引导设计：确保用户成功说出第一句英语

Layer 2: 学习成就（Day 3-7）
  → 叽叽成长可视化（"叽叽长出了小翅膀！"）
  → 首个里程碑："你已经学会10个表达了！"

Layer 3: 习惯养成（Day 7-14）
  → 每日定时推送 + 连续打卡可视化
  → Spaced Repetition让旧词汇在新场景中自然出现

Layer 4: 子女关注（Day 7+）
  → 子女收到周报 → 微信关心 → 老人有被关注的动力
  → "我儿子能看到我学习呢"

Layer 5: 社交正反馈（Day 14+）
  → 分享到家族群获得点赞/评论
  → 在老年大学/社区中的社交谈资

Layer 6: 内容新鲜度（Day 30+）
  → 新场景包定期上线
  → 节日限定场景（圣诞、感恩节等）

Layer 7: 沉没成本（Day 60+）
  → 叽叽成长到高等级 + 学习词汇量积累
  → "我已经学了200个表达了，不能放弃"
```

### 3.2 流失预警与干预

```python
CHURN_SIGNALS = {
    "warning": {
        "trigger": "连续2天未打开",
        "action": "发送温暖推送（不绑架）",
        "message": "阿姨，叽叽在等你呢～今天就聊5分钟？"
    },
    "at_risk": {
        "trigger": "连续5天未打开",
        "action": "子女端推送提醒",
        "message_to_child": "妈妈已经5天没和叽叽聊天了，提醒一下她？"
    },
    "churned": {
        "trigger": "连续14天未打开",
        "action": "发送回流推送（最多3次）",
        "message": "阿姨好久不见！叽叽学了一个新中文词想告诉你！"
    }
}
```

---

## 四、变现策略

### 4.1 收入模型

```
月度收入 = 活跃付费用户数 × ARPU

目标（12个月后）：
  活跃用户: 10,000
  付费率: 10%
  付费用户: 1,000
  ARPU: ¥198/年 = ¥16.5/月
  月收入: ¥16,500
  年收入: ~¥200,000

盈亏平衡：
  月固定成本: ~¥3,000（服务器+域名+推送）
  月变动成本: 1,000 × ¥5.4（API） = ¥5,400
  月总成本: ~¥8,400
  盈亏平衡点: ~510个付费用户
```

### 4.2 付费转化漏斗

```
Step 1: 子女下载App（获客成本 ¥100-200）
  ↓ 70% 完成父母设置
Step 2: 父母首次对话
  ↓ 60% 第2天再次使用
Step 3: 7天体验期结束
  ↓ 8-15% 付费转化
Step 4: 年度续费
  ↓ 40% 续费率（目标）
```

---

## 五、数据埋点规范

### 5.1 核心事件

```python
ANALYTICS_EVENTS = {
    # ── 注册/设置 ──
    "child_registered": {"props": ["channel"]},
    "elder_account_created": {"props": ["motivation", "english_level"]},
    "elder_first_login": {"props": ["method"]},  # qrcode / manual
    
    # ── 对话 ──
    "session_started": {"props": ["scene_id", "trigger"]},  # trigger: home/push/scene_list
    "session_completed": {"props": ["scene_id", "duration_s", "phrases_learned", "success_rate"]},
    "session_abandoned": {"props": ["scene_id", "duration_s", "abandon_reason"]},
    
    # ── 语音链路 ──
    "asr_result": {"props": ["latency_ms", "confidence", "language"]},
    "llm_response": {"props": ["latency_ms", "token_count"]},
    "tts_played": {"props": ["latency_ms", "duration_s"]},
    "voice_error": {"props": ["stage", "error_type"]},  # stage: asr/llm/tts
    
    # ── 学习 ──
    "phrase_learned": {"props": ["phrase", "scene_id", "attempts"]},
    "phrase_reviewed": {"props": ["phrase", "srs_level", "result"]},
    "pronunciation_scored": {"props": ["phrase", "score"]},
    
    # ── 宠物 ──
    "pet_level_up": {"props": ["new_stage", "total_xp"]},
    "milestone_reached": {"props": ["milestone_id"]},
    
    # ── 子女端 ──
    "dashboard_viewed": {"props": []},
    "report_shared": {"props": ["channel"]},  # wechat_moment / wechat_chat / other
    "scene_gifted": {"props": ["scene_pack", "price"]},
    
    # ── 付费 ──
    "paywall_shown": {"props": ["trigger"]},
    "subscription_started": {"props": ["type", "price", "purchaser"]},
    "subscription_renewed": {"props": ["type"]},
    "subscription_cancelled": {"props": ["reason"]},
    
    # ── 推送 ──
    "push_sent": {"props": ["type"]},
    "push_opened": {"props": ["type"]},
    "push_action_taken": {"props": ["type", "action"]},
}
```

### 5.2 关键看板

```
日报：
  - DAU（老人端/子女端分开）
  - 新注册数（子女/老人）
  - 日对话次数 / 平均时长
  - 语音链路成功率 / 平均延迟
  - API调用成本

周报：
  - WAU / D1/D7留存率
  - 新增付费用户 / 转化率
  - 分享次数 / 分享打开率
  - 场景完成分布
  - NPS调查（每月）

月报：
  - MAU / 月留存曲线
  - MRR / ARPU
  - LTV / CAC比值
  - 流失用户分析
  - 场景使用热力图
```

---

## 六、A/B测试计划

### MVP阶段核心测试

| 测试 | 假设 | 变量 | 成功指标 |
|------|------|------|---------|
| 免费体验天数 | 7天 vs 3天 vs 14天 | 体验期时长 | 付费转化率 |
| 推送时间 | 9:30 vs 用户活跃时间 | 推送策略 | 推送打开率 |
| 对话长度 | 5分钟 vs 8分钟 vs 不限 | 单次对话时长 | D7留存率 |
| 鹦鹉性别感 | 中性 vs 偏女性 vs 偏男性 | 声音+性格 | 用户好感度 |
| 子女周报内容 | 纯数据 vs 故事化 vs 带录音片段 | 报告格式 | 分享率 |
