# Component Hierarchy: [FEATURE NAME]

**Feature Branch**: `[###-feature-name]`
**Created**: [DATE]
**Source**: [wireframes.md](./wireframes.md)
**Design System**: [Name or "Custom"]

## Overview

This document defines the UI component structure extracted from wireframes. Components are organized by type and reusability.

---

## Component Tree

```
App
├── Providers
│   ├── ThemeProvider
│   ├── AuthProvider
│   └── RouterProvider
│
├── Layout
│   ├── AppShell
│   │   ├── Header
│   │   │   ├── Logo
│   │   │   ├── Navigation
│   │   │   └── UserMenu
│   │   ├── Main
│   │   │   └── {children}
│   │   ├── Sidebar (optional)
│   │   │   └── NavLinks
│   │   └── TabBar (mobile)
│   │       └── TabItem (×5)
│   │
│   └── ModalContainer
│       └── {modal content}
│
├── Pages
│   ├── HomePage
│   │   ├── WelcomeSection
│   │   ├── StatsCards
│   │   │   └── StatCard (×N)
│   │   ├── ActivityFeed
│   │   │   └── ActivityItem (×N)
│   │   └── QuickActions
│   │
│   ├── ListPage
│   │   ├── FilterBar
│   │   │   ├── FilterDropdown
│   │   │   └── SortDropdown
│   │   ├── ItemList
│   │   │   └── ItemCard (×N)
│   │   └── Pagination
│   │
│   ├── DetailPage
│   │   ├── HeroImage
│   │   ├── ItemInfo
│   │   ├── ItemDescription
│   │   └── ActionButtons
│   │
│   ├── FormPage
│   │   ├── FormHeader
│   │   ├── FormFields
│   │   │   └── FormField (×N)
│   │   ├── ImageUploader
│   │   └── FormActions
│   │
│   └── ProfilePage
│       ├── ProfileHeader
│       ├── SettingsList
│       │   └── SettingItem (×N)
│       └── LogoutButton
│
└── Shared
    ├── Button
    ├── Input
    ├── Card
    ├── Modal
    ├── Dropdown
    ├── Avatar
    ├── Badge
    ├── Icon
    ├── Spinner
    └── Toast
```

---

## Component Details

### Layout Components

#### Header
- **Type**: Layout
- **Location**: `components/layout/Header`
- **Props**:
  - `title`: string (optional)
  - `showBack`: boolean = false
  - `rightActions`: ReactNode (optional)
- **Variants**: default, transparent, minimal

#### TabBar
- **Type**: Layout (Mobile only)
- **Location**: `components/layout/TabBar`
- **Props**:
  - `items`: TabItem[]
  - `activeIndex`: number
  - `onChange`: (index: number) => void
- **Children**: TabItem

#### TabItem
- **Type**: Presentational
- **Location**: `components/layout/TabItem`
- **Props**:
  - `icon`: IconName
  - `label`: string
  - `active`: boolean
  - `badge`: number (optional)

---

### Page Components

#### ItemCard
- **Type**: Presentational
- **Location**: `components/items/ItemCard`
- **Props**:
  - `item`: Item
  - `onPress`: () => void
  - `variant`: 'default' | 'compact'
- **Displays**: thumbnail, title, description, rating, price

#### FormField
- **Type**: Container
- **Location**: `components/form/FormField`
- **Props**:
  - `label`: string
  - `required`: boolean = false
  - `error`: string (optional)
  - `children`: ReactNode (input element)

---

### Shared Components

#### Button
- **Type**: Presentational
- **Location**: `components/shared/Button`
- **Props**:
  - `variant`: 'primary' | 'secondary' | 'ghost' | 'danger'
  - `size`: 'sm' | 'md' | 'lg'
  - `disabled`: boolean = false
  - `loading`: boolean = false
  - `fullWidth`: boolean = false
  - `leftIcon`: IconName (optional)
  - `rightIcon`: IconName (optional)
  - `children`: ReactNode

```
Variants:
┌─────────────┐  ┌─────────────┐  ┌─────────────┐
│   Primary   │  │  Secondary  │  │    Ghost    │
│  (filled)   │  │ (outlined)  │  │   (text)    │
└─────────────┘  └─────────────┘  └─────────────┘
```

#### Input
- **Type**: Presentational
- **Location**: `components/shared/Input`
- **Props**:
  - `type`: 'text' | 'email' | 'password' | 'number'
  - `placeholder`: string
  - `value`: string
  - `onChange`: (value: string) => void
  - `error`: boolean = false
  - `disabled`: boolean = false
  - `leftIcon`: IconName (optional)
  - `rightIcon`: IconName (optional)

#### Card
- **Type**: Presentational
- **Location**: `components/shared/Card`
- **Props**:
  - `variant`: 'elevated' | 'outlined' | 'filled'
  - `padding`: 'none' | 'sm' | 'md' | 'lg'
  - `onPress`: (() => void) (optional, makes it tappable)
  - `children`: ReactNode

#### Modal
- **Type**: Container
- **Location**: `components/shared/Modal`
- **Props**:
  - `open`: boolean
  - `onClose`: () => void
  - `title`: string
  - `size`: 'sm' | 'md' | 'lg' | 'fullscreen'
  - `children`: ReactNode
  - `actions`: ReactNode (optional, footer buttons)

#### Dropdown
- **Type**: Container
- **Location**: `components/shared/Dropdown`
- **Props**:
  - `options`: Option[]
  - `value`: string | string[]
  - `onChange`: (value) => void
  - `placeholder`: string
  - `multiple`: boolean = false

---

## Component Relationships

```
App
 └─uses→ ThemeProvider
           └─provides→ theme context to all components

Layout
 └─contains→ Header, Main, TabBar
              └─uses→ Button, Icon (shared)

Pages
 └─uses→ Layout (wrapper)
 └─contains→ Page-specific components
              └─uses→ Shared components

Shared
 └─used by→ All other component categories
 └─no dependencies→ on other categories
```

---

## Reusability Matrix

| Component | Used In | Instances |
|-----------|---------|-----------|
| Button | All pages | 15+ |
| Card | Home, List, Detail | 10+ |
| Input | Form, Search | 8 |
| Modal | Delete confirm, Create | 3 |
| Icon | Everywhere | 30+ |
| Avatar | Header, Profile, Comments | 5 |

---

## State Management

| Component | Local State | Global State |
|-----------|-------------|--------------|
| FormPage | form values, validation | - |
| Modal | open/closed | - |
| ItemList | - | items, loading, error |
| Header | - | user, theme |
| TabBar | - | activeRoute |

---

## Design System Mapping

| Our Component | Design System | Notes |
|---------------|---------------|-------|
| Button | ds/Button | All variants supported |
| Input | ds/TextField | Extend with icons |
| Card | ds/Card | Custom elevation |
| Modal | ds/Dialog | Custom animations |

---

## Implementation Priority

| Priority | Components | Rationale |
|----------|------------|-----------|
| P1 | Button, Input, Card, Icon | Foundation for all UIs |
| P1 | Header, TabBar, AppShell | Layout structure |
| P2 | ItemCard, FormField, Modal | Feature components |
| P3 | Dropdown, Avatar, Badge | Enhancement components |

---

## Notes

- All components should support dark mode via theme context
- Touch targets minimum 44x44px on mobile
- Components should be accessible (ARIA labels, keyboard nav)
- Use composition over configuration where possible
- Shared components should have no business logic
