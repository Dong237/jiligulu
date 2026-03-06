# Information Architecture: 叽里咕噜 MVP

**Feature Branch**: `001-jiligulu-mvp`
**Created**: 2026-03-06
**Source**: [spec.md](./spec.md), [userflows.md](./userflows.md), [INFO_ARCHITECTURE.md](./INFO_ARCHITECTURE.md)

## Overview

叽里咕噜采用双角色单App架构：老人端（默认）和子女端（密码切换）。老人端最多3层导航，最大限度降低认知负荷。

---

## Navigation Pattern

**Type**: Bottom Tab Bar (3 Tabs) + Password-gated Role Switch
**Platform**: Mobile (Flutter, iOS + Android)
**Rationale**: 3个Tab是老年用户可处理的最大导航复杂度。子女端通过密码切换而非独立入口，避免老人困惑。

---

## Primary Navigation (Old Person Mode - Default)

Bottom Tab Bar, 3 items:

- **Tab 1: Home** `/home`
  - Parrot Animation Area (60% screen)
  - "Start Chat" Button (primary CTA)
  - Mini Stats (streak days, today's phrases)
  - Quick Access: Review Cards, Scene List

- **Tab 2: Scenes** `/scenes`
  - Scene Pack List (basic/daily/travel/family)
    - Scene Cards (name, difficulty, progress)
    - Lock indicator for paid scenes

- **Tab 3: JiJi** `/jiji`
  - Parrot Growth Status (current stage + XP bar)
  - Growth Timeline (milestones)
  - Milestone Wall
  - Family Entry (password-gated to child mode)

---

## Secondary Navigation

### Voice Chat Flow (from Home or Scenes)
- **Voice Chat Page** `/voice-chat` (auth required)
  - Parrot Animation (40% screen)
  - Subtitle Display Area
  - "Press to Talk" Button
  - Quick Reply Buttons
- **Session Summary** `/voice-chat/summary`
  - Phrases Learned + XP Gained
  - Parrot Growth Update
- **Review Cards** `/review-cards`
  - Swipeable Phrase Cards
  - Listen Button per Card
  - Share to WeChat Button

### Child Mode (password-gated)
- **Dashboard** `/child/dashboard`
  - Weekly Learning Overview Card
  - Action Buttons: Detailed Report, Share
  - Scene Management Section
  - Settings Section
- **Learning Report** `/child/report`
  - Weekly/Monthly toggle
  - Detailed stats + charts
- **Scene Management** `/child/scenes`
  - Unlocked/Locked scene packs
  - Purchase/Gift buttons
- **Settings** `/child/settings`
  - Learning goal adjustment
  - Reminder time
  - Account management
  - Subscription management
- **Payment** `/child/payment`
  - Plan selection (Annual / Gift Box)
  - Payment method (WeChat Pay / Alipay)

---

## Utility Navigation

- **Back Button** (top-left, large touch area) - Available on all sub-pages
- **No global search** - Not needed, content is curated
- **No notifications bell** - Notifications via system push only
- **No hamburger menu** - Banned for elderly UX

---

## Screen Inventory

| Screen | Route | Auth | Parent | Content Type |
|--------|-------|------|--------|--------------|
| Home | `/home` | Elder | - | Dashboard |
| Scene List | `/scenes` | Elder | - | List |
| JiJi Status | `/jiji` | Elder | - | Detail |
| Voice Chat | `/voice-chat` | Elder | Home/Scenes | Interactive |
| Session Summary | `/voice-chat/summary` | Elder | Voice Chat | Detail |
| Review Cards | `/review-cards` | Elder | Summary/Home | Card Stack |
| Child Dashboard | `/child/dashboard` | Child (password) | JiJi Tab | Dashboard |
| Learning Report | `/child/report` | Child | Dashboard | Detail |
| Scene Management | `/child/scenes` | Child | Dashboard | List |
| Settings | `/child/settings` | Child | Dashboard | Form |
| Payment | `/child/payment` | Child | Dashboard | Form |
| Share Preview | `/child/share` | Child | Dashboard | Detail |
| Onboarding: Identity | `/onboarding` | None | - | Choice |
| Onboarding: Setup Wizard | `/onboarding/setup` | None | Identity | Multi-step Form |

---

## Content Hierarchy

```
App Root
├── Onboarding (First Launch Only)
│   ├── Identity Selection (子女 vs 父母)
│   ├── Child Setup Wizard
│   │   ├── Step 1: Phone Registration
│   │   ├── Step 2: Parent Info
│   │   ├── Step 3: Learning Goal
│   │   └── Step 4: QR Code Generation
│   └── Elder QR Scan Login
│
├── Elder Mode (Default, No Auth UI)
│   ├── Tab 1: Home
│   │   ├── Parrot Animation
│   │   ├── "Start Chat" Button
│   │   ├── Mini Stats
│   │   └── Quick Access (Review, Scenes)
│   │
│   ├── Tab 2: Scenes
│   │   ├── Scene Pack: Basic (free)
│   │   ├── Scene Pack: Daily (member)
│   │   ├── Scene Pack: Travel (paid)
│   │   └── Scene Pack: Family (paid)
│   │
│   ├── Tab 3: JiJi
│   │   ├── Growth Status
│   │   ├── Milestone Wall
│   │   └── Family Entry (-> Child Mode)
│   │
│   └── Shared Screens
│       ├── Voice Chat Page
│       ├── Session Summary
│       └── Review Cards
│
└── Child Mode (Password-Gated)
    ├── Dashboard
    │   ├── Weekly Overview Card
    │   ├── Quick Actions (Report, Share)
    │   └── Scene Management
    ├── Learning Report (Weekly/Monthly)
    ├── Scene Management (Purchase/Gift)
    ├── Settings (Goals, Reminders, Account)
    ├── Payment (Plans, Checkout)
    └── Share Preview (Card Generation)
```

---

## Navigation Depth

| Level | Elder Mode | Child Mode |
|-------|-----------|------------|
| L1 (Tab Bar) | Home, Scenes, JiJi (3 items) | Dashboard (single root) |
| L2 (Sub-screens) | Voice Chat, Review Cards, Scene Detail | Report, Scenes, Settings, Payment |
| L3 (Terminal) | Session Summary | Share Preview |

**Max Depth**: 3 levels (Home -> Voice Chat -> Summary)

---

## Mobile-Specific Patterns

### Tab Bar (Bottom Navigation - Elder Mode)
```
┌─────────────────────────────────────┐
│                                     │
│           [Screen Content]          │
│                                     │
├───────────┬───────────┬─────────────┤
│   Home    │  Scenes   │    JiJi     │
│   首页    │   场景    │    叽叽     │
└───────────┴───────────┴─────────────┘
```

### Child Mode Header
```
┌─────────────────────────────────────┐
│  <- 返回老人端        子女管理中心   │
├─────────────────────────────────────┤
│                                     │
│           [Child Content]           │
│                                     │
└─────────────────────────────────────┘
```

### Thumb Zone Consideration
- Primary CTA ("Start Chat") placed in bottom 40% of screen
- Tab bar at bottom (natural thumb reach)
- Back button enlarged (48dp+) at top-left
- Quick reply buttons placed at bottom of voice chat page

---

## State-Based Navigation

| State | Available Navigation | Restricted |
|-------|---------------------|------------|
| First Launch | Onboarding only | All app screens |
| Elder (logged in) | All elder screens + tabs | Child screens (password) |
| Child (password verified) | All child screens + return to elder | Elder screens (must exit first) |
| Offline | Home, Review Cards (cached) | Voice Chat, Scenes (need network) |
| Trial Expired | All elder screens (free scenes only) | Paid scenes locked |

---

## Deep Linking

| Link Pattern | Destination | Use Case |
|--------------|-------------|----------|
| `jiligulu://voice-chat` | Voice Chat Page | Push notification tap |
| `jiligulu://voice-chat?scene=X` | Voice Chat with scene | Scene-specific push |
| `jiligulu://child/dashboard` | Child Dashboard | Weekly report push |
| `jiligulu://scan?token=X` | Elder auto-login | QR code scan |

---

## Notes

- Elder mode has NO login screen - QR scan handles auth invisibly
- Tab bar labels use large text (18sp), no icon-only tabs
- All transitions use fade (200ms), no swipe gestures
- Loading states always show parrot thinking animation, never spinner
- Error states always use parrot persona language, never technical terms
