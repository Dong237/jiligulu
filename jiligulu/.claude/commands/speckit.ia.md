---
description: Generate information architecture (site map and navigation structure) from user flows and specification.
handoffs:
  - label: Create Wireframes
    agent: speckit.wireframes
    prompt: Generate wireframe layouts from information architecture
    send: true
  - label: Refine User Flows
    agent: speckit.userflows
    prompt: Update user flows based on IA changes
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

Generate a comprehensive information architecture document defining navigation patterns, content hierarchy, and screen organization.

1. **Locate Feature Directory**:
   - Get current git branch name
   - Extract feature identifier (e.g., `001-feature-name`)
   - Set FEATURE_DIR = `specs/{branch-name}`
   - Verify FEATURE_DIR exists

2. **Load Required Documents**:
   - Read `{FEATURE_DIR}/spec.md` - REQUIRED (ERROR if missing)
   - Read `{FEATURE_DIR}/userflows.md` - REQUIRED (ERROR if missing, suggest `/speckit.userflows` first)
   - Read `.specify/memory/constitution.md` if present

3. **Extract Screen Inventory**:
   - Parse all screens from userflows.md
   - Identify unique screens across all flows
   - Note authentication requirements per screen
   - Identify parent-child relationships

4. **Determine Navigation Pattern**:
   Based on screen count and platform (from user input or spec):

   | Screen Count | Mobile | Desktop |
   |--------------|--------|---------|
   | 3-5 screens | Tab Bar | Top Nav |
   | 6-10 screens | Tab Bar + Nested | Sidebar |
   | 10+ screens | Hamburger + Tabs | Sidebar + Nested |

   Document rationale for chosen pattern.

5. **Generate Content Hierarchy**:
   - Load `.specify/templates/ia-template.md` for output structure
   - Organize screens into hierarchy:

     ```
     App Root
     ├── Public (No Auth)
     │   ├── Landing
     │   ├── Login
     │   └── Register
     ├── Authenticated
     │   ├── Dashboard (Home)
     │   ├── [Feature Area 1]
     │   │   ├── List View
     │   │   └── Detail View
     │   └── Settings
     └── Admin (if applicable)
     ```

6. **Define Navigation Levels**:
   - **Primary Navigation**: Main entry points (3-5 max)
   - **Secondary Navigation**: Section-specific navigation
   - **Utility Navigation**: Always-available actions (search, notifications, help)

   Follow the 3-click rule: any content reachable in 3 clicks max.

7. **Create Screen Inventory Table**:

   | Screen | Route | Auth | Parent | Content Type |
   |--------|-------|------|--------|--------------|
   | Home | `/` | No | - | Dashboard |
   | Items | `/items` | Yes | Home | List |
   | Item Detail | `/items/:id` | Yes | Items | Detail |

8. **Define State-Based Navigation**:
   Document which navigation is available based on user state:
   - Guest: Public screens only
   - Authenticated User: User screens
   - Admin: All screens

9. **Add Mobile-Specific Patterns** (if mobile app):
   - Tab Bar layout with icons
   - Hamburger menu structure
   - Bottom sheet patterns
   - Thumb-zone considerations

10. **Document Deep Linking**:
    - Shareable URL patterns
    - App link schemes (if mobile)
    - Query parameter handling

11. **Write Output**:
    - Write complete IA document to `{FEATURE_DIR}/ia.md`
    - Include all sections from template

12. **Report Completion**:
    - Display summary: screen count, nav pattern, hierarchy depth
    - Suggest next step: `/speckit.wireframes` to create screen layouts

## Navigation Depth Guidelines

| Level | Description | Max Items |
|-------|-------------|-----------|
| L1 | Primary navigation | 3-5 items |
| L2 | Section screens | 5-7 items |
| L3 | Sub-screens | As needed |

**Maximum Depth**: 3 levels (following Occam's Razor)

## Key Rules

- Every screen from userflows MUST appear in the IA
- Navigation pattern MUST match platform (mobile vs desktop)
- Primary actions limited to 1 per screen
- Consistent iconography across the app
- Consider thumb-zone for mobile touch targets
- Routes should be semantic and predictable
