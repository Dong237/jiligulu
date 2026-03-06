---
description: Generate ASCII wireframe layouts for all screens defined in the information architecture.
handoffs:
  - label: Extract Components
    agent: speckit.components
    prompt: Extract component hierarchy from wireframes
    send: true
  - label: Update Information Architecture
    agent: speckit.ia
    prompt: Refine IA based on wireframe discoveries
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

Generate ASCII box-drawing wireframes for every screen in the information architecture, showing content structure and interaction points.

1. **Locate Feature Directory**:
   - Get current git branch name
   - Extract feature identifier (e.g., `001-feature-name`)
   - Set FEATURE_DIR = `specs/{branch-name}`
   - Verify FEATURE_DIR exists

2. **Load Required Documents**:
   - Read `{FEATURE_DIR}/ia.md` - REQUIRED (ERROR if missing, suggest `/speckit.ia` first)
   - Read `{FEATURE_DIR}/spec.md` - for functional requirements
   - Read `{FEATURE_DIR}/userflows.md` - for interaction context
   - Read `.specify/memory/constitution.md` if present

3. **Extract Screen List**:
   - Parse screen inventory from ia.md
   - Get navigation pattern (Tab Bar, Sidebar, etc.)
   - Note authentication requirements per screen
   - Identify content types (List, Detail, Form, Dashboard)

4. **Determine Viewport**:
   From user input or spec, select primary viewport:
   - Mobile: 40 characters wide
   - Tablet: 60 characters wide
   - Desktop: 80 characters wide

5. **Generate Wireframes**:
   - Load `.specify/templates/wireframes-template.md` for output structure
   - For each screen in the inventory:

     a. **Create Header**:
        ```
        ┌─────────────────────────────────────────┐
        │  ←  Screen Title              [🔍] [+]  │
        ├─────────────────────────────────────────┤
        ```

     b. **Create Content Area** based on content type:

        **List View**:
        ```
        │  ┌─────────────────────────────────┐   │
        │  │  ┌────┐                         │   │
        │  │  │ 📷 │  Item Title             │   │
        │  │  └────┘  Description...         │   │
        │  │          ⭐ 4.5  •  $29.99      │   │
        │  └─────────────────────────────────┘   │
        ```

        **Form View**:
        ```
        │  Field Label *                         │
        │  ┌─────────────────────────────────┐   │
        │  │ Placeholder text...             │   │
        │  └─────────────────────────────────┘   │
        ```

        **Detail View**:
        ```
        │  ┌─────────────────────────────────┐   │
        │  │         [Hero Image]            │   │
        │  └─────────────────────────────────┘   │
        │  Title                                 │
        │  ═══════                               │
        │  Description text here...              │
        ```

        **Dashboard**:
        ```
        │  ┌─────────────┐ ┌─────────────┐       │
        │  │  Stat Card  │ │  Stat Card  │       │
        │  │     42      │ │     18      │       │
        │  └─────────────┘ └─────────────┘       │
        ```

     c. **Create Footer/Navigation**:
        ```
        ├─────────────────────────────────────────┤
        │  🏠    │    📁    │    ➕    │    👤    │
        │ Home   │  Items   │   Add   │ Profile  │
        └─────────────────────────────────────────┘
        ```

6. **Add Interaction Tables**:
   For each screen, document interactions:

   | Element | Action | Result |
   |---------|--------|--------|
   | [Button] | Tap | Navigate to X |
   | List item | Tap | Open detail |
   | ← | Tap | Go back |

7. **Add Form Validation** (for form screens):

   | Field | Rule | Error Message |
   |-------|------|---------------|
   | Title | Required, 3-100 chars | "Title is required" |
   | Email | Valid email format | "Invalid email" |

8. **Create Modal/Dialog Templates**:
   For any modals referenced in flows:
   ```
   ┌─────────────────────────────────────────┐
   │░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░│
   │░░░┌─────────────────────────────────┐░░░│
   │░░░│  Modal Title                 ×  │░░░│
   │░░░├─────────────────────────────────┤░░░│
   │░░░│  Modal content here...          │░░░│
   │░░░│  ┌─────────┐  ┌─────────────┐  │░░░│
   │░░░│  │ Cancel  │  │   Confirm   │  │░░░│
   │░░░│  └─────────┘  └─────────────┘  │░░░│
   │░░░└─────────────────────────────────┘░░░│
   │░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░│
   └─────────────────────────────────────────┘
   ```

9. **Include Wireframe Legend**:
   | Symbol | Meaning |
   |--------|---------|
   | `[ Button ]` | Tappable button |
   | `[🔍]` | Icon button |
   | `───────` | Divider line |
   | `▼` | Dropdown indicator |
   | `←` | Back navigation |
   | `×` | Close/dismiss |
   | `░` | Overlay/dimmed background |
   | `*` | Required field |

10. **Add Responsive Notes**:
    Document layout changes across breakpoints:
    | Viewport | Width | Layout Changes |
    |----------|-------|----------------|
    | Mobile | < 640px | Single column, tab bar |
    | Tablet | 640-1024px | Two column, optional sidebar |
    | Desktop | > 1024px | Multi-column, sidebar nav |

11. **Write Output**:
    - Write complete wireframes document to `{FEATURE_DIR}/wireframes.md`
    - Include all sections from template

12. **Report Completion**:
    - Display summary: number of screens, modals, forms
    - Suggest next step: `/speckit.components` to extract component hierarchy

## ASCII Box Drawing Reference

```
Corners: ┌ ┐ └ ┘
Lines:   ─ │
T-joins: ├ ┤ ┬ ┴
Cross:   ┼
Double:  ═ ║ ╔ ╗ ╚ ╝
```

## Key Rules

- Every screen from IA MUST have a wireframe
- All interactive elements minimum 44x44px touch target (note in comments)
- Include loading states for async operations
- Include error states for form validation
- Include empty states for lists with no data
- Keep wireframes low-fidelity (structure, not visual design)
- Use consistent element placement across screens
