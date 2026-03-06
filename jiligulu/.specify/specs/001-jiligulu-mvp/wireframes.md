# Wireframes: 叽里咕噜 MVP

**Feature Branch**: `001-jiligulu-mvp`
**Created**: 2026-03-06
**Source**: [ia.md](./ia.md), [spec.md](./spec.md), [ELDERCARE_UX_SPEC.md](./ELDERCARE_UX_SPEC.md)
**Viewport**: Mobile (40 chars / 375dp wide)

## Design Specs Reference

| Property | Value | Notes |
|----------|-------|-------|
| Primary Color | #1A8A7D (Parrot Green) | Buttons, titles, brand |
| Accent Color | #F5A623 (Warm Orange) | Emphasis, achievements |
| Background | #F0FAF8 (Light Green) | Page background |
| Card Background | #FDFBF7 (Cream White) | Card surfaces |
| Text Primary | #1B2D45 (Dark Blue Grey) | Body text |
| Text Secondary | #8E9AAF (Warm Grey) | Secondary text |
| Title | 32sp Bold | Page titles |
| Subtitle | 28sp Bold | Section headers |
| Body | 22sp Regular | Main content |
| Min Text | 18sp Regular | Secondary info |
| Core Button | >= 64dp height | Primary CTA |
| Standard Button | >= 48dp height | Secondary actions |
| Touch Target | >= 48x48dp | All interactive elements |
| Button Spacing | >= 16dp | Between buttons |
| Corner Radius | 16dp | All cards and buttons |
| BANNED | Red (#FF0000) | Never use for errors |

---

## Screen 1: Home (首页)

**The most important screen. Only parrot + one big button.**

```
┌─────────────────────────────────────┐
│             STATUS BAR              │
├─────────────────────────────────────┤
│                                     │
│                                     │
│                                     │
│        ┌─────────────────┐          │
│        │                 │          │
│        │    PARROT        │          │
│        │   ANIMATION      │          │
│        │    (Rive)        │          │
│        │                 │          │
│        │  Sleeping /      │          │
│        │  Waking up /     │          │
│        │  Greeting        │          │
│        │                 │          │
│        └─────────────────┘          │
│                                     │
│  "阿姨早上好！"          18sp grey  │
│                                     │
│   ┌─────────────────────────────┐   │
│   │                             │   │
│   │       开 始 聊 天            │   │
│   │       28sp white            │   │
│   │    [Parrot Green BG]        │   │
│   │    height: 64dp             │   │
│   │    corner: 16dp             │   │
│   │    pulse animation          │   │
│   └─────────────────────────────┘   │
│                                     │
│   连续学习 3 天              18sp   │
│                                     │
│   ┌────────────┐ ┌────────────┐     │
│   │  复习卡片   │ │  我的场景   │     │
│   │  22sp      │ │  22sp      │     │
│   │  48dp h    │ │  48dp h    │     │
│   └────────────┘ └────────────┘     │
│                16dp gap             │
├───────────┬───────────┬─────────────┤
│   首页    │   场景    │    叽叽     │
│   18sp    │   18sp    │    18sp     │
│  [active] │           │             │
└───────────┴───────────┴─────────────┘
```

### Interactions

| Element | Action | Result |
|---------|--------|--------|
| Parrot Animation | Auto | Sleeping -> Waking when app opens |
| "开始聊天" Button | Tap | Navigate to Voice Chat (recommended scene) |
| "复习卡片" Card | Tap | Navigate to Review Cards |
| "我的场景" Card | Tap | Navigate to Scene List (Tab 2) |
| Tab: 首页 | Tap | Current screen (no-op) |
| Tab: 场景 | Tap | Navigate to Scene List |
| Tab: 叽叽 | Tap | Navigate to JiJi Status |

### Eldercare Notes

- Parrot animation occupies 55-60% of screen height to be the visual focus
- "开始聊天" button has breathing pulse animation to draw attention
- "连续学习 N 天" shown only if streak > 0 (no "0 days" display)
- Quick access cards are optional secondary actions, not required
- No notification badges, no red dots anywhere
- Greeting text changes by time of day (早上好/下午好/晚上好)

---

## Screen 2: Voice Chat (语音对话页)

```
┌─────────────────────────────────────┐
│  ← 返回              买水果 场景    │
│  48dp touch          22sp grey      │
├─────────────────────────────────────┤
│                                     │
│        ┌─────────────────┐          │
│        │                 │          │
│        │    PARROT        │          │
│        │   ANIMATION      │          │
│        │  (Teaching /     │          │
│        │   Happy /        │          │
│        │   Thinking)      │          │
│        │                 │          │
│        └─────────────────┘          │
│                                     │
├─────────────────────────────────────┤
│                                     │
│  叽叽：阿姨！今天咱们去    22sp     │
│  买水果好不好？你可以说：           │
│                                     │
│  I'd like some apples   28sp bold   │
│  [Parrot Green text, tappable]      │
│                                     │
│  /aɪd laɪk sʌm ˈæpəlz/ 18sp grey │
│  "爱的 来克 撒姆 阿剖斯"  18sp     │
│                                     │
├─────────────────────────────────────┤
│                                     │
│   ┌─────────────────────────────┐   │
│   │                             │   │
│   │    按住说话                  │   │
│   │    28sp white               │   │
│   │    [Warm Orange BG]         │   │
│   │    height: 64dp             │   │
│   │    corner: 16dp             │   │
│   └─────────────────────────────┘   │
│                                     │
│  ┌────────┐ ┌────────┐ ┌────────┐  │
│  │再说一遍│ │ 太难了  │ │ 换一个  │  │
│  │ 48dp h │ │ 48dp h │ │ 48dp h │  │
│  └────────┘ └────────┘ └────────┘  │
│       16dp      16dp                │
└─────────────────────────────────────┘
```

### Voice Chat States

```
Recording State:
┌─────────────────────────────────────┐
│   ┌─────────────────────────────┐   │
│   │  ●  正在听...               │   │
│   │     [Warm Orange BG pulsing]│   │
│   │     松开发送                │   │
│   └─────────────────────────────┘   │
└─────────────────────────────────────┘

Processing State:
┌─────────────────────────────────────┐
│        ┌─────────────────┐          │
│        │   PARROT          │          │
│        │  THINKING         │          │
│        │  (head tilt)      │          │
│        └─────────────────┘          │
│                                     │
│  叽叽在想...               22sp     │
└─────────────────────────────────────┘
```

### Interactions

| Element | Action | Result |
|---------|--------|--------|
| <- 返回 | Tap | Confirm exit dialog -> Home |
| English phrase | Tap | Replay standard pronunciation |
| 按住说话 | Press & Hold | Start recording, button pulses |
| 按住说话 | Release | Send audio, show processing |
| 再说一遍 | Tap | JiJi repeats last phrase |
| 太难了 | Tap | JiJi offers simpler version |
| 换一个 | Tap | JiJi moves to next phrase |

### Eldercare Notes

- Parrot occupies top 35-40% of screen
- Subtitle area scrolls to show conversation history
- English phrases highlighted in Parrot Green, large (28sp)
- Chinese phonetic ("谐音") always shown below IPA
- "按住说话" uses Warm Orange for visual distinction from "开始聊天"
- Quick reply buttons eliminate the need to speak for frustrated users
- No timer shown (no pressure)
- No score/progress bar shown during conversation

---

## Screen 3: Session Summary (对话总结页)

```
┌─────────────────────────────────────┐
│             学习总结       32sp      │
├─────────────────────────────────────┤
│                                     │
│        ┌─────────────────┐          │
│        │   PARROT          │          │
│        │   FAREWELL        │          │
│        │  (waving wings)   │          │
│        └─────────────────┘          │
│                                     │
│  阿姨今天太厉害了！        22sp     │
│                                     │
│  ┌─────────────────────────────┐    │
│  │  今天学了 3 个新表达  28sp   │    │
│  │                             │    │
│  │  I'd like some...   22sp   │    │
│  │  How much?           22sp   │    │
│  │  Here you go         22sp   │    │
│  │                             │    │
│  │  [Cream White card BG]      │    │
│  └─────────────────────────────┘    │
│                                     │
│  ┌─────────────────────────────┐    │
│  │  +20 XP   叽叽更强壮了！    │    │
│  │  [Warm Orange accent]       │    │
│  │  ████████░░ 毛球期 80%      │    │
│  └─────────────────────────────┘    │
│                                     │
│   ┌─────────────────────────────┐   │
│   │       看看复习卡片           │   │
│   │   [Parrot Green, 64dp]     │   │
│   └─────────────────────────────┘   │
│                                     │
│   ┌─────────────────────────────┐   │
│   │       返回首页               │   │
│   │   [Outline, 48dp]          │   │
│   └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

### Interactions

| Element | Action | Result |
|---------|--------|--------|
| 看看复习卡片 | Tap | Navigate to Review Cards |
| 返回首页 | Tap | Navigate to Home |
| XP Progress Bar | Display only | Shows pet growth progress |

### Eldercare Notes

- Only positive messaging: "太厉害了！" never scores or grades
- XP bar uses warm colors (orange fill), no numerical percentage
- Pet growth milestone shown if level-up occurred
- Two clear choices only: review cards or go home

---

## Screen 4: Scene List (场景选择页)

```
┌─────────────────────────────────────┐
│             学习场景       32sp      │
├─────────────────────────────────────┤
│                                     │
│  入门基础                  28sp     │
│  ─────────────────────────          │
│                                     │
│  ┌─────────────────────────────┐    │
│  │  打招呼                      │    │
│  │  Hello / Good morning       │    │
│  │  难度 *                22sp │    │
│  │  [Cream White, corner 16dp] │    │
│  └─────────────────────────────┘    │
│           16dp gap                  │
│  ┌─────────────────────────────┐    │
│  │  自我介绍                    │    │
│  │  My name is... / I'm from   │    │
│  │  难度 *                22sp │    │
│  └─────────────────────────────┘    │
│           16dp gap                  │
│  ┌─────────────────────────────┐    │
│  │  买水果                      │    │
│  │  I'd like some... / How much│    │
│  │  难度 **               22sp │    │
│  └─────────────────────────────┘    │
│                                     │
│  日常生活 (会员)           28sp     │
│  ─────────────────────────          │
│                                     │
│  ┌─────────────────────────────┐    │
│  │  餐厅点菜                    │    │
│  │  Can I have... / The bill   │    │
│  │  难度 **     会员内容  22sp │    │
│  │  [slight opacity overlay]   │    │
│  └─────────────────────────────┘    │
│                                     │
├───────────┬───────────┬─────────────┤
│   首页    │   场景    │    叽叽     │
│           │  [active] │             │
└───────────┴───────────┴─────────────┘
```

### Interactions

| Element | Action | Result |
|---------|--------|--------|
| Free scene card | Tap | Start voice chat with this scene |
| Member scene card | Tap | "请让家人帮忙解锁" (warm prompt) |
| Difficulty stars | Display only | Visual difficulty indicator |
| Tab bar | Tap | Switch tabs |

### Eldercare Notes

- Scene cards are tall (>80dp) for easy tapping
- Difficulty shown as stars, not numbers or text
- Locked scenes NOT greyed out harshly -- subtle overlay + text label
- No lock icon (feels punitive) -- use text "会员内容" in warm grey
- Scrollable vertically, no horizontal swipe
- Scene description uses English examples as preview

---

## Screen 5: Review Cards (复习卡片页)

```
┌─────────────────────────────────────┐
│  ← 返回            今日复习卡片     │
│  48dp touch         22sp            │
├─────────────────────────────────────┤
│                                     │
│  ┌─────────────────────────────┐    │
│  │                             │    │
│  │       PARROT ICON           │    │
│  │       (mini, 48dp)          │    │
│  │                             │    │
│  │  I'd like some apples      │    │
│  │  28sp Parrot Green bold     │    │
│  │                             │    │
│  │  /aɪd laɪk sʌm ˈæpəlz/   │    │
│  │  18sp grey                  │    │
│  │                             │    │
│  │  我想要一些苹果              │    │
│  │  22sp body                  │    │
│  │                             │    │
│  │  "爱的 来克 撒姆 阿剖斯"   │    │
│  │  22sp Warm Orange           │    │
│  │                             │    │
│  │  ┌──────────────────────┐   │    │
│  │  │  点击听发音   22sp   │   │    │
│  │  │  [48dp, outline]     │   │    │
│  │  └──────────────────────┘   │    │
│  │                             │    │
│  │  场景: 买水果 · 3月6日学习  │    │
│  │  18sp grey                  │    │
│  │                             │    │
│  │  [Cream White card BG]      │    │
│  │  [corner 16dp]              │    │
│  │  [shadow: subtle]           │    │
│  └─────────────────────────────┘    │
│                                     │
│         < 1 / 3 >          22sp     │
│                                     │
│   ┌─────────────────────────────┐   │
│   │       分享到微信             │   │
│   │   [Parrot Green, 64dp]     │   │
│   └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

### Interactions

| Element | Action | Result |
|---------|--------|--------|
| <- 返回 | Tap | Back to previous screen |
| Card area | Swipe left/right | Navigate between cards |
| < > arrows | Tap | Navigate between cards |
| 点击听发音 | Tap | Play standard pronunciation audio |
| 分享到微信 | Tap | Generate share image, open WeChat |

### Eldercare Notes

- One card at a time, large and readable (no card grid)
- Swipe left/right for navigation (exception to "no swipe" rule - natural card metaphor)
- Also provide < > tap arrows for non-swipers
- Chinese phonetic ("谐音") in Warm Orange for visual emphasis
- "点击听发音" button clearly labeled (not just an icon)
- Card numbers shown as "1 / 3" not "1/3" (more readable)

---

## Screen 6: JiJi Status / Growth (叽叽状态页)

```
┌─────────────────────────────────────┐
│              叽叽         32sp      │
├─────────────────────────────────────┤
│                                     │
│        ┌─────────────────┐          │
│        │                 │          │
│        │    PARROT         │          │
│        │   CURRENT STAGE   │          │
│        │   (animated)      │          │
│        │                 │          │
│        └─────────────────┘          │
│                                     │
│     "毛球期"             28sp bold  │
│     破壳而出的小毛球      22sp grey │
│                                     │
│  ┌─────────────────────────────┐    │
│  │  ████████████░░░░░  300 XP  │    │
│  │  距离"雏鸟期"还需 100 XP    │    │
│  │  18sp                       │    │
│  └─────────────────────────────┘    │
│                                     │
│  成长历程                  28sp     │
│  ─────────────────────────          │
│                                     │
│  ┌─────────────────────────────┐    │
│  │  Day 1  叽叽学会了你的名字！│    │
│  │  22sp  [Warm Orange accent] │    │
│  └─────────────────────────────┘    │
│  ┌─────────────────────────────┐    │
│  │  Day 3  叽叽长出了小翅膀！  │    │
│  │  22sp  [Warm Orange accent] │    │
│  └─────────────────────────────┘    │
│  ┌─────────────────────────────┐    │
│  │  Day 7  叽叽学会了第一个     │    │
│  │         中文词！             │    │
│  └─────────────────────────────┘    │
│                                     │
│   ┌─────────────────────────────┐   │
│   │       家人管理               │   │
│   │   [Outline, 48dp, grey]    │   │
│   └─────────────────────────────┘   │
│                                     │
├───────────┬───────────┬─────────────┤
│   首页    │   场景    │    叽叽     │
│           │           │   [active]  │
└───────────┴───────────┴─────────────┘
```

### Interactions

| Element | Action | Result |
|---------|--------|--------|
| Parrot Animation | Display | Shows current growth stage |
| XP Progress Bar | Display | Shows progress to next stage |
| Milestone cards | Display | Scroll to view all milestones |
| 家人管理 | Tap | Password input dialog |
| Tab bar | Tap | Switch tabs |

### Eldercare Notes

- XP bar uses Parrot Green fill, no numerical percentage
- "距离X还需Y XP" is optional detail (not critical info)
- Milestones use Warm Orange accents for celebration feel
- "家人管理" button is intentionally subtle (outline, grey) to avoid elder accidentally entering
- Future milestones NOT shown (no "locked" items to confuse)

---

## Screen 7: Child Dashboard (子女仪表盘)

```
┌─────────────────────────────────────┐
│  ← 返回老人端      子女管理中心     │
│  48dp touch         28sp            │
├─────────────────────────────────────┤
│                                     │
│  ┌─────────────────────────────┐    │
│  │  妈妈本周学习概览    22sp   │    │
│  │                             │    │
│  │  学习 7 次    共 42 分钟    │    │
│  │  学会 23 个新表达           │    │
│  │  连续学习 12 天             │    │
│  │  叽叽成长到"雏鸟期"         │    │
│  │                             │    │
│  │  [Cream White card]         │    │
│  └─────────────────────────────┘    │
│                                     │
│  ┌────────────┐ ┌────────────┐      │
│  │  详细报告   │ │  一键分享   │      │
│  │  48dp h    │ │  48dp h    │      │
│  │  [outline] │ │ [Green BG] │      │
│  └────────────┘ └────────────┘      │
│       16dp gap                      │
│                                     │
│  ┌─────────────────────────────┐    │
│  │  场景管理              22sp │    │
│  │                             │    │
│  │  V 入门基础 (已解锁)       │    │
│  │  V 日常生活 (已解锁)       │    │
│  │  X 出国旅游 (解锁)         │    │
│  │  X 海外探亲 (解锁)         │    │
│  │                             │    │
│  │  [赠送场景包给妈妈]        │    │
│  └─────────────────────────────┘    │
│                                     │
│  ┌─────────────────────────────┐    │
│  │  设置                  22sp │    │
│  │  · 学习目标调整             │    │
│  │  · 提醒时间设置             │    │
│  │  · 账号管理                │    │
│  │  · 订阅管理                │    │
│  └─────────────────────────────┘    │
│                                     │
└─────────────────────────────────────┘
```

### Interactions

| Element | Action | Result |
|---------|--------|--------|
| <- 返回老人端 | Tap | Exit child mode, return to elder Home |
| 详细报告 | Tap | Navigate to Learning Report |
| 一键分享 | Tap | Generate share card preview |
| Scene pack (locked) | Tap | Navigate to purchase/gift flow |
| 赠送场景包 | Tap | Navigate to gift purchase |
| Settings items | Tap | Navigate to respective settings |
| 订阅管理 | Tap | Navigate to Payment/Plans |

### Eldercare Notes

- This screen is for children (25-40), not elders -- standard mobile UI acceptable
- But still maintain warm color scheme for brand consistency
- "一键分享" is primary CTA (Parrot Green) to encourage viral sharing
- Scene lock status uses V / X symbols, no red icons
- "返回老人端" always visible at top for easy exit

---

## Screen 8: Child Setup Wizard (子女设置引导页)

### Step 1: Registration

```
┌─────────────────────────────────────┐
│             帮爸妈设置      32sp    │
│         Step 1/4  注册             │
├─────────────────────────────────────┤
│                                     │
│        ┌─────────────────┐          │
│        │   PARROT           │          │
│        │  (excited)         │          │
│        │  "你好！我是叽叽"  │          │
│        └─────────────────┘          │
│                                     │
│  您的手机号                 22sp    │
│  ┌─────────────────────────────┐    │
│  │  请输入手机号               │    │
│  │  [large input, 48dp h]     │    │
│  └─────────────────────────────┘    │
│                                     │
│  ┌─────────────┐                    │
│  │  获取验证码   │                    │
│  │  [48dp, outline]                │
│  └─────────────┘                    │
│                                     │
│  验证码                     22sp    │
│  ┌─────────────────────────────┐    │
│  │  请输入6位验证码             │    │
│  │  [large input, 48dp h]     │    │
│  └─────────────────────────────┘    │
│                                     │
│   ┌─────────────────────────────┐   │
│   │       下一步                 │   │
│   │   [Parrot Green, 64dp]     │   │
│   └─────────────────────────────┘   │
│                                     │
│  ○───○───○───○  step indicator      │
│  [active]                           │
└─────────────────────────────────────┘
```

### Step 2: Parent Info

```
┌─────────────────────────────────────┐
│  ←          帮爸妈设置      32sp    │
│         Step 2/4  父母信息         │
├─────────────────────────────────────┤
│                                     │
│  父母称呼                   22sp    │
│  ┌─────────────────────────────┐    │
│  │  例如: 王阿姨               │    │
│  │  [48dp input]               │    │
│  └─────────────────────────────┘    │
│                                     │
│  性别                       22sp    │
│  ┌────────────┐ ┌────────────┐      │
│  │   阿姨      │ │   叔叔      │      │
│  │  [64dp h]  │ │  [64dp h]  │      │
│  │  [selected │ │  [outline] │      │
│  │   = Green] │ │            │      │
│  └────────────┘ └────────────┘      │
│                                     │
│  英语水平                   22sp    │
│  ┌─────────────────────────────┐    │
│  │  完全零基础      [selected] │    │
│  └─────────────────────────────┘    │
│  ┌─────────────────────────────┐    │
│  │  学过一些但忘了              │    │
│  └─────────────────────────────┘    │
│  ┌─────────────────────────────┐    │
│  │  能说几句简单的              │    │
│  └─────────────────────────────┘    │
│                                     │
│   ┌─────────────────────────────┐   │
│   │       下一步                 │   │
│   │   [Parrot Green, 64dp]     │   │
│   └─────────────────────────────┘   │
│                                     │
│  ○───●───○───○  step indicator      │
└─────────────────────────────────────┘
```

### Step 3: Learning Goal

```
┌─────────────────────────────────────┐
│  ←          帮爸妈设置      32sp    │
│         Step 3/4  学习目标         │
├─────────────────────────────────────┤
│                                     │
│  妈妈学英语主要是为了：    22sp    │
│                                     │
│  ┌─────────────────────────────┐    │
│  │                             │    │
│  │   出国旅游能用上几句         │    │
│  │   22sp                      │    │
│  │   [64dp h, corner 16dp]    │    │
│  │   [selected = Green border] │    │
│  └─────────────────────────────┘    │
│           16dp gap                  │
│  ┌─────────────────────────────┐    │
│  │                             │    │
│  │   海外探亲和孙子沟通         │    │
│  │   22sp                      │    │
│  │   [64dp h, outline]        │    │
│  └─────────────────────────────┘    │
│           16dp gap                  │
│  ┌─────────────────────────────┐    │
│  │                             │    │
│  │   兴趣爱好/锻炼脑子         │    │
│  │   22sp                      │    │
│  │   [64dp h, outline]        │    │
│  └─────────────────────────────┘    │
│                                     │
│   ┌─────────────────────────────┐   │
│   │       下一步                 │   │
│   │   [Parrot Green, 64dp]     │   │
│   └─────────────────────────────┘   │
│                                     │
│  ○───○───●───○  step indicator      │
└─────────────────────────────────────┘
```

### Step 4: QR Code Generation

```
┌─────────────────────────────────────┐
│             设置完成！      32sp    │
│         Step 4/4                   │
├─────────────────────────────────────┤
│                                     │
│        ┌─────────────────┐          │
│        │   PARROT           │          │
│        │  (celebrating)     │          │
│        └─────────────────┘          │
│                                     │
│  让妈妈用手机扫这个码：    22sp    │
│                                     │
│  ┌─────────────────────────────┐    │
│  │                             │    │
│  │                             │    │
│  │        [QR CODE]            │    │
│  │        200x200dp            │    │
│  │                             │    │
│  │                             │    │
│  └─────────────────────────────┘    │
│                                     │
│  妈妈扫码后就能直接使用了   18sp   │
│  叽叽会在那边等着她！              │
│                                     │
│   ┌─────────────────────────────┐   │
│   │       保存到相册             │   │
│   │   [Outline, 48dp]          │   │
│   └─────────────────────────────┘   │
│                                     │
│   ┌─────────────────────────────┐   │
│   │       进入子女管理中心       │   │
│   │   [Parrot Green, 64dp]     │   │
│   └─────────────────────────────┘   │
│                                     │
│  ○───○───○───●  step indicator      │
└─────────────────────────────────────┘
```

### Setup Wizard Interactions

| Element | Action | Result |
|---------|--------|--------|
| <- (Steps 2-4) | Tap | Go back to previous step |
| 下一步 (Steps 1-3) | Tap | Validate and advance |
| Gender buttons | Tap | Toggle selection (阿姨/叔叔) |
| Goal cards | Tap | Select one (single choice) |
| QR Code | Display | Parent scans with phone camera |
| 保存到相册 | Tap | Save QR image to phone gallery |
| 进入子女管理中心 | Tap | Navigate to Child Dashboard |

### Form Validation

| Field | Rule | Error Display |
|-------|------|---------------|
| Phone number | Required, 11 digits | Field border turns Warm Orange + hint text |
| Verification code | Required, 6 digits | "验证码不正确，请重新获取" |
| Parent nickname | Required, 2-10 chars | "请输入父母称呼" |
| Gender | Required (one selected) | Button border highlight |
| Learning goal | Required (one selected) | Card border highlight |

### Eldercare Notes (Setup Wizard)

- This wizard is FOR children (25-40), so standard mobile UX is fine
- Large input fields (48dp) and buttons (64dp) maintain brand consistency
- Step indicator at bottom shows progress (4 steps total)
- Back button available from Step 2 onwards
- QR code is large (200x200dp) for easy scanning
- Warm, encouraging copy throughout ("设置完成！" "叽叽会在那边等着她！")

---

## Overlay: Password Entry (子女端切换)

```
┌─────────────────────────────────────┐
│░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░│
│░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░│
│░░░┌─────────────────────────────┐░░│
│░░░│                             │░░│
│░░░│  家人管理入口        22sp   │░░│
│░░░│                             │░░│
│░░░│  请输入4位密码              │░░│
│░░░│                             │░░│
│░░░│  ┌──┐ ┌──┐ ┌──┐ ┌──┐      │░░│
│░░░│  │  │ │  │ │  │ │  │      │░░│
│░░░│  └──┘ └──┘ └──┘ └──┘      │░░│
│░░░│  [56dp each, 16dp gap]    │░░│
│░░░│                             │░░│
│░░░│  ┌─────────────────────┐   │░░│
│░░░│  │     确认    48dp    │   │░░│
│░░░│  └─────────────────────┘   │░░│
│░░░│                             │░░│
│░░░│  [Cream White card BG]     │░░│
│░░░│  [corner 16dp]              │░░│
│░░░└─────────────────────────────┘░░│
│░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░│
└─────────────────────────────────────┘

Wrong password state:
│░░░│  这是家人管理的入口哦  │░░│
│░░░│  18sp Warm Orange      │░░│
```

---

## Overlay: Offline State

```
┌─────────────────────────────────────┐
│░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░│
│░░░┌─────────────────────────────┐░░│
│░░░│                             │░░│
│░░░│     PARROT SLEEPING          │░░│
│░░░│     (zzz animation)         │░░│
│░░░│                             │░░│
│░░░│  叽叽休息了                 │░░│
│░░░│  先看看复习卡片吧           │░░│
│░░░│  22sp                       │░░│
│░░░│                             │░░│
│░░░│  ┌─────────────────────┐   │░░│
│░░░│  │    看复习卡片  48dp │   │░░│
│░░░│  └─────────────────────┘   │░░│
│░░░│                             │░░│
│░░░└─────────────────────────────┘░░│
│░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░│
└─────────────────────────────────────┘
```

---

## Overlay: Trial Expired (Old Person Side)

```
┌─────────────────────────────────────┐
│░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░│
│░░░┌─────────────────────────────┐░░│
│░░░│                             │░░│
│░░░│     PARROT WAVING            │░░│
│░░░│                             │░░│
│░░░│  叽叽的免费体验结束了       │░░│
│░░░│  让家人帮忙开通会员         │░░│
│░░░│  继续和叽叽学习吧！         │░░│
│░░░│  22sp                       │░░│
│░░░│                             │░░│
│░░░│  ┌─────────────────────┐   │░░│
│░░░│  │     知道了    48dp  │   │░░│
│░░░│  └─────────────────────┘   │░░│
│░░░│                             │░░│
│░░░│  不再提醒      18sp grey   │░░│
│░░░│                             │░░│
│░░░└─────────────────────────────┘░░│
│░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░│
└─────────────────────────────────────┘
```

### Eldercare Notes (Overlays)

- "知道了" is always an option -- never force payment
- Free scenes remain accessible after trial expiry
- "不再提醒" text link (not button) for those who don't want reminders
- No countdown timers, no urgency tactics
- Parrot animations make overlays feel friendly, not transactional

---

## Wireframe Legend

| Symbol | Meaning |
|--------|---------|
| `[ Button Text ]` | Tappable button |
| `[Parrot Green BG]` | Button with #1A8A7D background |
| `[Warm Orange]` | Text/accent in #F5A623 |
| `[outline]` | Button with border only, no fill |
| `[Cream White card]` | Card with #FDFBF7 background |
| `──────` | Section divider |
| `░` | Overlay dimmed background |
| `←` | Back navigation (48dp touch area) |
| `● / ○` | Active/inactive step indicator |
| `48dp h` / `64dp h` | Element height |
| `16dp` | Spacing between elements |
| `corner 16dp` | Border radius |

---

## Summary

| Category | Count |
|----------|-------|
| Elder screens | 6 (Home, Voice Chat, Summary, Scenes, Review Cards, JiJi) |
| Child screens | 2 (Dashboard, Setup Wizard 4 steps) |
| Overlays/Modals | 3 (Password, Offline, Trial Expired) |
| **Total wireframes** | **11** |

Next step: `/speckit.components` to extract component hierarchy from wireframes.
