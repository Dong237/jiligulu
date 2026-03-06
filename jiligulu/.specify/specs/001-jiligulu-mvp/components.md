# Components: 叽里咕噜 MVP

**Feature Branch**: `001-jiligulu-mvp`
**Created**: 2026-03-06
**Source**: [wireframes.md](./wireframes.md), [ia.md](./ia.md)
**Framework**: Flutter (Dart), Riverpod, GoRouter

## Component Tree

```
JiLiGuLuApp
├── Providers
│   ├── ThemeProvider (elder-first warm theme)
│   ├── AuthProvider (Riverpod, token management)
│   ├── RouterProvider (GoRouter, deep linking)
│   └── AudioProvider (recorder + player state)
│
├── Layout
│   ├── ElderShell (bottom nav + safe area)
│   │   ├── ElderBottomNav (3 tabs)
│   │   └── {child page}
│   └── ChildShell (top header + back button)
│       ├── ChildHeader ("返回老人端" + title)
│       └── {child page}
│
├── Pages (Elder Mode)
│   ├── HomePage
│   │   ├── PetAnimationWidget (sleeping/greeting)
│   │   ├── ElderButton ("开始聊天", primary)
│   │   ├── StreakBadge
│   │   ├── LearningStatsMini
│   │   └── Row: [ElderCard("复习卡片"), ElderCard("我的场景")]
│   │
│   ├── VoiceChatPage
│   │   ├── PetAnimationWidget (teaching/happy/thinking)
│   │   ├── SubtitleDisplay
│   │   │   └── PhraseHighlight (per English phrase)
│   │   ├── TalkButton
│   │   └── QuickReplyBar
│   │       └── ElderButton x3 ("再说一遍"/"太难了"/"换一个")
│   │
│   ├── SessionSummaryPage
│   │   ├── PetAnimationWidget (farewell)
│   │   ├── ElderCard (phrases learned list)
│   │   ├── PetStatusBar (XP gained)
│   │   └── ElderButton x2 ("看复习卡片"/"返回首页")
│   │
│   ├── SceneListPage
│   │   ├── ElderText (section headers)
│   │   └── SceneCard (×N, per scene)
│   │
│   ├── ReviewCardsPage
│   │   ├── ReviewCard (swipeable stack)
│   │   │   ├── PhraseHighlight
│   │   │   └── ElderButton ("点击听发音")
│   │   ├── PageIndicator ("1 / 3")
│   │   └── ElderButton ("分享到微信")
│   │
│   └── JiJiStatusPage
│       ├── PetAnimationWidget (current stage)
│       ├── PetStatusBar (XP + stage)
│       ├── PetMilestoneCard (×N, timeline)
│       └── ElderButton ("家人管理", outline/subtle)
│
├── Pages (Child Mode)
│   ├── ChildDashboardPage
│   │   ├── DashboardCard (weekly overview)
│   │   ├── Row: [ElderButton("详细报告"), ShareButton("一键分享")]
│   │   ├── SceneManagementSection
│   │   │   └── SceneGiftCard (×N, per pack)
│   │   └── SettingsSection
│   │
│   ├── SetupWizardPage
│   │   ├── StepIndicator (4 steps)
│   │   └── SetupWizardStep (×4)
│   │       ├── Step1: phone + OTP inputs
│   │       ├── Step2: name + gender + level
│   │       ├── Step3: goal selection
│   │       └── Step4: QR code display
│   │
│   ├── LearningReportPage
│   │   └── WeeklyReportCard
│   │
│   └── PaymentPage
│       ├── PlanCard (×2, annual vs gift box)
│       └── PaymentMethodSelector
│
├── Overlays
│   ├── PasswordDialog (4-digit PIN)
│   ├── OfflineOverlay (parrot sleeping + review CTA)
│   └── TrialExpiredOverlay (warm prompt)
│
└── Shared Components
    ├── Elder-First Foundation
    │   ├── ElderButton
    │   ├── ElderText
    │   ├── ElderCard
    │   └── ElderBottomNav
    ├── Parrot Components
    │   ├── PetAnimationWidget
    │   ├── PetStatusBar
    │   └── PetMilestoneCard
    ├── Voice Chat Components
    │   ├── TalkButton
    │   ├── SubtitleDisplay
    │   ├── QuickReplyBar
    │   ├── PhraseHighlight
    │   └── AudioWaveform
    ├── Learning Components
    │   ├── ReviewCard
    │   ├── SceneCard
    │   ├── LearningStatsMini
    │   └── StreakBadge
    └── Child Components
        ├── DashboardCard
        ├── WeeklyReportCard
        ├── ShareButton
        ├── SceneGiftCard
        └── SetupWizardStep
```

---

## Shared Components - Elder-First Foundation

### ElderButton

- **Type**: Presentational
- **Priority**: P1 (foundation for all interactions)
- **Location**: `lib/shared/widgets/elder_button.dart`
- **Reusability**: All screens (20+ instances)
- **Props**:
  - `label`: String (required)
  - `onPressed`: VoidCallback (required)
  - `variant`: `primary` | `secondary` | `outline` | `subtle` = `primary`
  - `size`: `core` | `standard` = `standard`
  - `fullWidth`: bool = true
  - `icon`: IconData? (optional leading icon)
  - `loading`: bool = false
  - `hapticFeedback`: bool = true
- **Variants**:
  - `primary`: Parrot Green (#1A8A7D) background, white text, 64dp height
  - `secondary`: Warm Orange (#F5A623) background, white text, 64dp height
  - `outline`: Transparent BG, Parrot Green border, 48dp height
  - `subtle`: Transparent BG, grey border, 48dp height
- **Behavior**:
  - Tap: color darkens + slight scale animation + haptic vibration
  - Min touch area: 48x48dp (core: 64dp height)
  - Debounce: 300ms (prevent double-tap)
  - Corner radius: 16dp

### ElderText

- **Type**: Presentational
- **Priority**: P1 (all text rendering)
- **Location**: `lib/shared/widgets/elder_text.dart`
- **Reusability**: All screens (50+ instances)
- **Props**:
  - `text`: String (required)
  - `style`: `title` | `subtitle` | `body` | `caption` = `body`
  - `color`: Color? (defaults per style)
  - `maxLines`: int? (optional)
  - `textAlign`: TextAlign = TextAlign.start
- **Variants**:
  - `title`: 32sp Bold, #1B2D45
  - `subtitle`: 28sp Bold, #1B2D45
  - `body`: 22sp Regular, #1B2D45
  - `caption`: 18sp Regular, #8E9AAF (minimum allowed size)
- **Behavior**:
  - Enforces minimum 18sp -- no style variant goes below
  - Respects system font scale (up to 200%)
  - High contrast ratio (>= 7:1 against background)

### ElderCard

- **Type**: Presentational
- **Priority**: P1 (all card surfaces)
- **Location**: `lib/shared/widgets/elder_card.dart`
- **Reusability**: All screens (15+ instances)
- **Props**:
  - `child`: Widget (required)
  - `onTap`: VoidCallback? (optional, makes card tappable)
  - `padding`: EdgeInsets = EdgeInsets.all(16)
  - `elevation`: double = 1.0
- **Behavior**:
  - Background: Cream White (#FDFBF7)
  - Corner radius: 16dp
  - Subtle shadow (elevation 1-2)
  - If tappable: press feedback (darken + haptic)
  - Min touch area 48x48dp if tappable

### ElderBottomNav

- **Type**: Layout
- **Priority**: P1 (main navigation)
- **Location**: `lib/shared/widgets/elder_bottom_nav.dart`
- **Reusability**: ElderShell (1 instance, always visible)
- **Props**:
  - `currentIndex`: int (required, 0-2)
  - `onTap`: Function(int) (required)
- **Behavior**:
  - 3 tabs only: Home (首页), Scenes (场景), JiJi (叽叽)
  - Labels: 18sp (never icon-only)
  - Active tab: Parrot Green icon + text
  - Inactive tab: Warm Grey icon + text
  - Height: ~64dp (comfortable thumb reach)
  - No badge/notification dots

---

## Shared Components - Parrot

### PetAnimationWidget

- **Type**: Presentational
- **Priority**: P1 (product soul)
- **Location**: `lib/shared/widgets/pet_animation_widget.dart`
- **Reusability**: Home, VoiceChat, Summary, JiJi, Overlays (6+ instances)
- **Props**:
  - `state`: `sleeping` | `greeting` | `teaching` | `happy` | `encouraging` | `thinking` | `farewell` (required)
  - `growthStage`: int (1-6, affects visual appearance)
  - `size`: `large` | `medium` | `small` = `large`
- **Variants**:
  - `large`: 60% screen height (Home page)
  - `medium`: 35-40% screen height (Voice Chat)
  - `small`: 48dp (Review Card mini icon)
- **Behavior**:
  - Uses Rive (preferred) or Lottie for animation
  - State transitions with smooth blending
  - Looping: sleeping, teaching, thinking
  - One-shot: greeting, happy, encouraging, farewell
  - Growth stage changes parrot visual (egg -> colorful bird)

### PetStatusBar

- **Type**: Presentational
- **Priority**: P2 (growth system)
- **Location**: `lib/shared/widgets/pet_status_bar.dart`
- **Reusability**: Summary, JiJi (2 instances)
- **Props**:
  - `currentXP`: int (required)
  - `nextLevelXP`: int (required)
  - `stageName`: String (required)
  - `xpGained`: int? (optional, for animation on summary)
- **Behavior**:
  - Progress bar: Parrot Green fill on light grey track
  - Stage name displayed below bar
  - If xpGained provided: animate fill increase
  - No numerical percentage shown

### PetMilestoneCard

- **Type**: Presentational
- **Priority**: P2 (growth system)
- **Location**: `lib/shared/widgets/pet_milestone_card.dart`
- **Reusability**: JiJi Status page (N instances)
- **Props**:
  - `day`: int (required)
  - `description`: String (required)
  - `achieved`: bool (required)
- **Behavior**:
  - Achieved: Warm Orange accent border
  - Not achieved: hidden (never show locked milestones)

---

## Shared Components - Voice Chat

### TalkButton

- **Type**: Presentational
- **Priority**: P1 (core interaction)
- **Location**: `lib/features/voice_chat/widgets/talk_button.dart`
- **Reusability**: VoiceChat page only (1 instance, but critical)
- **Props**:
  - `onPressStart`: VoidCallback (required)
  - `onPressEnd`: VoidCallback (required)
  - `state`: `idle` | `recording` | `processing` = `idle`
- **Variants**:
  - `idle`: Warm Orange (#F5A623) BG, "按住说话" label, breathing pulse
  - `recording`: Pulsing red-orange, "正在听..." label, AudioWaveform inside
  - `processing`: Grey, disabled, "处理中..." label
- **Behavior**:
  - Press & Hold to record, Release to send
  - 64dp height, full width
  - Haptic feedback on press start
  - Visual: breathing pulse animation when idle

### SubtitleDisplay

- **Type**: Container
- **Priority**: P1 (conversation readability)
- **Location**: `lib/features/voice_chat/widgets/subtitle_display.dart`
- **Reusability**: VoiceChat page (1 instance)
- **Props**:
  - `messages`: List<ChatMessage> (required)
  - `isStreaming`: bool = false
- **Behavior**:
  - Auto-scroll to latest message
  - JiJi messages: left-aligned, 22sp
  - User messages: right-aligned, 22sp, Parrot Green
  - Streaming text: typewriter effect
  - Contains PhraseHighlight widgets for English phrases

### QuickReplyBar

- **Type**: Presentational
- **Priority**: P1 (accessibility fallback)
- **Location**: `lib/features/voice_chat/widgets/quick_reply_bar.dart`
- **Reusability**: VoiceChat page (1 instance)
- **Props**:
  - `options`: List<QuickReply> (default: ["再说一遍", "太难了", "换一个"])
  - `onSelect`: Function(QuickReply) (required)
- **Behavior**:
  - 3 buttons in a row, 48dp height each, 16dp gap
  - Outline style (subtle, not distracting)
  - Eliminates need to speak for frustrated users

### PhraseHighlight

- **Type**: Presentational
- **Priority**: P1 (teaching core)
- **Location**: `lib/shared/widgets/phrase_highlight.dart`
- **Reusability**: VoiceChat, ReviewCards (5+ instances)
- **Props**:
  - `english`: String (required)
  - `phoneticIPA`: String? (optional)
  - `phoneticChinese`: String? (optional, "谐音")
  - `chinese`: String? (optional, translation)
  - `onTap`: VoidCallback? (optional, play audio)
  - `compact`: bool = false
- **Variants**:
  - Full: english (28sp green) + IPA (18sp grey) + chinese (22sp) + 谐音 (22sp orange)
  - Compact: english (22sp green) + chinese (18sp grey) inline
- **Behavior**:
  - English text in Parrot Green, bold
  - Tappable: plays standard pronunciation
  - 谐音 in Warm Orange for visual emphasis

### AudioWaveform

- **Type**: Presentational
- **Priority**: P3 (polish)
- **Location**: `lib/features/voice_chat/widgets/audio_waveform.dart`
- **Reusability**: TalkButton recording state (1 instance)
- **Props**:
  - `isActive`: bool = false
  - `amplitude`: double = 0.0
- **Behavior**:
  - Simple oscillating bars animation during recording
  - Warm Orange color
  - Fades out when recording stops

---

## Shared Components - Learning

### ReviewCard

- **Type**: Presentational
- **Priority**: P1 (review + sharing)
- **Location**: `lib/features/review/widgets/review_card.dart`
- **Reusability**: ReviewCardsPage (N per session)
- **Props**:
  - `phrase`: PhraseData (required)
  - `sceneName`: String (required)
  - `learnedDate`: DateTime (required)
  - `onPlayAudio`: VoidCallback (required)
- **Children**:
  - PetAnimationWidget (small)
  - PhraseHighlight (full variant)
  - ElderButton ("点击听发音")
- **Behavior**:
  - Cream White card, 16dp corner radius
  - Swipeable in card stack
  - Contains all phrase info (EN, CN, IPA, 谐音)

### SceneCard

- **Type**: Presentational
- **Priority**: P1 (scene selection)
- **Location**: `lib/features/scenes/widgets/scene_card.dart`
- **Reusability**: SceneListPage (10+ instances)
- **Props**:
  - `name`: String (required)
  - `previewPhrases`: List<String> (required)
  - `difficulty`: int (1-5 stars)
  - `isLocked`: bool = false
  - `isCompleted`: bool = false
  - `onTap`: VoidCallback (required)
- **Behavior**:
  - 80dp+ height for easy tapping
  - Locked: subtle overlay + "会员内容" text (NOT grey-out, NOT lock icon)
  - Difficulty: star icons (filled Warm Orange)
  - Completed: subtle Parrot Green checkmark

### LearningStatsMini

- **Type**: Presentational
- **Priority**: P2 (engagement)
- **Location**: `lib/shared/widgets/learning_stats_mini.dart`
- **Reusability**: Home page (1 instance)
- **Props**:
  - `todaySessions`: int
  - `todayPhrases`: int
  - `weekSessions`: int
  - `weekPhrases`: int
- **Behavior**:
  - Compact horizontal layout
  - 18sp caption text
  - Only shown if user has history (empty state: hidden)

### StreakBadge

- **Type**: Presentational
- **Priority**: P2 (motivation)
- **Location**: `lib/shared/widgets/streak_badge.dart`
- **Reusability**: Home page (1 instance)
- **Props**:
  - `days`: int (required)
- **Behavior**:
  - "连续学习 N 天" text, 18sp
  - Hidden if streak == 0 (no "0天" display)
  - Warm Orange fire icon if streak >= 3

---

## Shared Components - Child Mode

### DashboardCard

- **Type**: Presentational
- **Priority**: P1 (child engagement)
- **Location**: `lib/features/family/widgets/dashboard_card.dart`
- **Reusability**: ChildDashboard (1 instance)
- **Props**:
  - `weekSessions`: int
  - `weekMinutes`: int
  - `weekPhrases`: int
  - `streakDays`: int
  - `petStageName`: String
- **Behavior**:
  - Cream White card with all stats
  - Each stat on its own line, 22sp
  - Warm, friendly copy ("妈妈本周学习概览")

### WeeklyReportCard

- **Type**: Presentational
- **Priority**: P2 (detailed view)
- **Location**: `lib/features/family/widgets/weekly_report_card.dart`
- **Reusability**: LearningReportPage (1 instance)
- **Props**:
  - `reportData`: WeeklyReportData (required)
  - `period`: `weekly` | `monthly`

### ShareButton

- **Type**: Container (has side effects)
- **Priority**: P1 (growth flywheel)
- **Location**: `lib/features/family/widgets/share_button.dart`
- **Reusability**: Dashboard, ReviewCards (2 instances)
- **Props**:
  - `shareData`: ShareCardData (required)
  - `label`: String = "一键分享"
- **Behavior**:
  - Generates 750x1334 PNG image server-side
  - Calls WeChat SDK share API
  - Shows loading state during generation
  - Parrot Green primary button style

### SceneGiftCard

- **Type**: Presentational
- **Priority**: P2 (monetization)
- **Location**: `lib/features/family/widgets/scene_gift_card.dart`
- **Reusability**: SceneManagement (4 instances)
- **Props**:
  - `packName`: String
  - `sceneCount`: int
  - `isUnlocked`: bool
  - `price`: String?
  - `onPurchase`: VoidCallback?

### SetupWizardStep

- **Type**: Container
- **Priority**: P1 (onboarding)
- **Location**: `lib/features/onboarding/widgets/setup_wizard_step.dart`
- **Reusability**: SetupWizardPage (4 steps)
- **Props**:
  - `stepNumber`: int (1-4)
  - `totalSteps`: int = 4
  - `title`: String
  - `child`: Widget (step content)
  - `onNext`: VoidCallback
  - `onBack`: VoidCallback?
  - `isLastStep`: bool = false
- **Children**: StepIndicator (dots at bottom)

---

## Reusability Matrix

| Component | Used In | Instances | Priority |
|-----------|---------|-----------|----------|
| ElderButton | All screens | 20+ | P1 |
| ElderText | All screens | 50+ | P1 |
| ElderCard | Home, Summary, JiJi, Dashboard | 15+ | P1 |
| ElderBottomNav | ElderShell | 1 | P1 |
| PetAnimationWidget | Home, Chat, Summary, JiJi, Overlays | 6+ | P1 |
| TalkButton | VoiceChat | 1 | P1 |
| SubtitleDisplay | VoiceChat | 1 | P1 |
| QuickReplyBar | VoiceChat | 1 | P1 |
| PhraseHighlight | VoiceChat, ReviewCards | 5+ | P1 |
| ReviewCard | ReviewCards | N per session | P1 |
| SceneCard | SceneList | 10+ | P1 |
| ShareButton | Dashboard, ReviewCards | 2 | P1 |
| SetupWizardStep | SetupWizard | 4 | P1 |
| DashboardCard | ChildDashboard | 1 | P1 |
| PetStatusBar | Summary, JiJi | 2 | P2 |
| PetMilestoneCard | JiJi | N milestones | P2 |
| LearningStatsMini | Home | 1 | P2 |
| StreakBadge | Home | 1 | P2 |
| WeeklyReportCard | LearningReport | 1 | P2 |
| SceneGiftCard | SceneManagement | 4 | P2 |
| AudioWaveform | TalkButton | 1 | P3 |

---

## State Management (Riverpod)

| Component | Local State | Global State (Riverpod) |
|-----------|-------------|------------------------|
| VoiceChatPage | recording state, UI scroll | audioProvider, sessionProvider |
| TalkButton | press/release | audioRecorderProvider |
| SubtitleDisplay | scroll position | chatMessagesProvider |
| PetAnimationWidget | animation controller | petStateProvider |
| ReviewCardsPage | current card index | reviewCardsProvider |
| SceneListPage | - | scenesProvider |
| HomePage | - | userStatsProvider, petStateProvider |
| ChildDashboardPage | - | familyDashboardProvider |
| SetupWizardPage | current step, form values | onboardingProvider |
| PasswordDialog | pin input, attempts | authProvider |

---

## Flutter/Material Design Mapping

| Our Component | Flutter Base | Customization |
|---------------|-------------|---------------|
| ElderButton | ElevatedButton / OutlinedButton | Size, colors, haptics, debounce |
| ElderText | Text + TextStyle | Enforced min 18sp, elder theme |
| ElderCard | Card | Cream White BG, 16dp radius |
| ElderBottomNav | BottomNavigationBar | 3 items, large labels |
| TalkButton | GestureDetector + Container | Press & hold, animation |
| PetAnimationWidget | RiveAnimation / LottieBuilder | State machine control |
| ReviewCard | PageView child | Swipeable card |
| SceneCard | ListTile / Card | Custom layout |
| SubtitleDisplay | ListView | Auto-scroll, streaming |

---

## Implementation Priority

| Priority | Components | Rationale |
|----------|------------|-----------|
| P1 | ElderButton, ElderText, ElderCard, ElderBottomNav | Foundation: every screen needs these |
| P1 | PetAnimationWidget | Soul: parrot IS the product |
| P1 | TalkButton, SubtitleDisplay, QuickReplyBar, PhraseHighlight | Core: voice chat is the primary feature |
| P1 | ReviewCard, SceneCard | Content: learning flow depends on these |
| P1 | ShareButton, DashboardCard, SetupWizardStep | Growth: onboarding + child engagement |
| P2 | PetStatusBar, PetMilestoneCard | Retention: pet growth system |
| P2 | LearningStatsMini, StreakBadge | Engagement: motivation |
| P2 | WeeklyReportCard, SceneGiftCard | Monetization + retention |
| P3 | AudioWaveform | Polish: visual feedback during recording |

---

## Summary

| Category | Count |
|----------|-------|
| Elder-First Foundation | 4 components |
| Parrot Components | 3 components |
| Voice Chat Components | 5 components |
| Learning Components | 4 components |
| Child Components | 5 components |
| **Total shared components** | **21** |
| Page components | 10 |
| Overlays | 3 |
| **Grand total** | **34** |

Next step: `/speckit.plan` to generate technical implementation plan, or `/speckit.tasks` to generate task breakdown.
