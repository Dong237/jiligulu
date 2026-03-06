# Information Architecture: [FEATURE NAME]

**Feature Branch**: `[###-feature-name]`
**Created**: [DATE]
**Source**: [spec.md](./spec.md), [userflows.md](./userflows.md)

## Overview

This document defines the navigation structure, content hierarchy, and screen organization for the application.

---

## Navigation Pattern

**Type**: [Tab Bar | Sidebar | Top Nav | Hamburger Menu | Hybrid]
**Platform**: [Mobile | Desktop | Responsive]
**Rationale**: [Why this pattern fits the app]

---

## Primary Navigation

Main entry points accessible from any screen:

- **Home** `/`
  - Hero/Welcome Section
  - Quick Actions
  - Recent Activity

- **[Screen Name]** `/path` [auth required?]
  - [Content Section 1]
    - [Subsection]
    - [Subsection]
  - [Content Section 2]
  - [Action: Primary CTA]

- **[Screen Name]** `/path`
  - [Content Block: List/Grid]
    - [Item Type]
  - [Content Block: Detail View]

- **Profile** `/profile` (auth required)
  - Account Settings
  - Preferences
  - Logout

---

## Secondary Navigation

Contextual navigation within sections:

### [Section Name]
- **[Sub-screen]** `/parent/sub`
  - [Content]
- **[Sub-screen]** `/parent/sub`
  - [Content]

---

## Utility Navigation

Always-available actions (header/footer):

- **Search** - Global search functionality
- **Notifications** - User alerts (auth required)
- **Help** - Documentation/support

---

## Screen Inventory

| Screen | Route | Auth | Parent | Content Type |
|--------|-------|------|--------|--------------|
| Home | `/` | No | - | Dashboard |
| [Name] | `/path` | Yes/No | [Parent] | [List/Form/Detail] |
| [Name] | `/path/:id` | Yes/No | [Parent] | [Detail View] |

---

## Content Hierarchy

```
App Root
├── Public (No Auth)
│   ├── Landing Page
│   ├── Login
│   ├── Register
│   └── Public Content
│
├── Authenticated
│   ├── Dashboard (Home)
│   │   ├── Overview Cards
│   │   ├── Quick Actions
│   │   └── Recent Activity
│   │
│   ├── [Feature Area 1]
│   │   ├── List View
│   │   ├── Detail View
│   │   └── Create/Edit Form
│   │
│   ├── [Feature Area 2]
│   │   └── [Sub-features]
│   │
│   └── Settings
│       ├── Profile
│       ├── Preferences
│       └── Account
│
└── Admin (Role-based)
    ├── Admin Dashboard
    └── Management Tools
```

---

## Navigation Depth

| Level | Example | Max Items |
|-------|---------|-----------|
| L1 (Primary Nav) | Home, Projects, Settings | 3-5 items |
| L2 (Section) | Project List, Project Detail | 5-7 items |
| L3 (Subsection) | Task within Project | As needed |

**Max Depth**: 3 levels (per Occam's Razor principle)

---

## Mobile-Specific Patterns

### Tab Bar (Bottom Navigation)
```
┌─────────────────────────────────────┐
│                                     │
│           [Screen Content]          │
│                                     │
├─────────────────────────────────────┤
│  🏠   │  📁   │  ➕   │  🔔   │  👤  │
│ Home  │ Items │ Add  │ Alerts│ Profile│
└─────────────────────────────────────┘
```

### Hamburger Menu (Drawer)
```
┌───┬─────────────────────────────────┐
│ ≡ │  [Screen Title]          [...]  │
├───┴─────────────────────────────────┤
│                                     │
│           [Screen Content]          │
│                                     │
└─────────────────────────────────────┘
```

---

## State-Based Navigation

| State | Available Navigation | Restricted |
|-------|---------------------|------------|
| Guest | Public screens, Login, Register | All auth screens |
| User | All user screens | Admin screens |
| Admin | All screens | - |

---

## Deep Linking

| Link Pattern | Destination | Use Case |
|--------------|-------------|----------|
| `/item/:id` | Item Detail | Share specific item |
| `/search?q=term` | Search Results | Share search |
| `/invite/:code` | Invite Flow | User invitations |

---

## Notes

- Navigation should follow the 3-click rule (any content reachable in 3 clicks)
- Primary actions should be prominent and limited (1 per screen)
- Use consistent iconography across the app
- Consider thumb-zone for mobile touch targets
