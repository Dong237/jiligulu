---
description: Extract UI component hierarchy from wireframes for implementation planning.
handoffs:
  - label: Generate Implementation Tasks
    agent: speckit.tasks
    prompt: Generate tasks including UI component implementation
    send: true
  - label: Refine Wireframes
    agent: speckit.wireframes
    prompt: Update wireframes based on component analysis
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

Extract and organize all UI components from wireframes into a hierarchical structure with props, variants, and reusability analysis.

1. **Locate Feature Directory**:
   - Get current git branch name
   - Extract feature identifier (e.g., `001-feature-name`)
   - Set FEATURE_DIR = `specs/{branch-name}`
   - Verify FEATURE_DIR exists

2. **Load Required Documents**:
   - Read `{FEATURE_DIR}/wireframes.md` - REQUIRED (ERROR if missing, suggest `/speckit.wireframes` first)
   - Read `{FEATURE_DIR}/ia.md` - for navigation structure
   - Read `{FEATURE_DIR}/spec.md` - for functional requirements
   - Read `.specify/memory/constitution.md` if present

3. **Extract Components from Wireframes**:
   - Scan each wireframe for UI elements
   - Identify component patterns:
     - Repeated elements → Shared components
     - Screen-specific elements → Page components
     - Structural elements → Layout components

4. **Categorize Components**:

   **Layout Components**:
   - AppShell, Header, Footer, Sidebar, TabBar
   - Providers (Theme, Auth, Router)

   **Page Components**:
   - Specific to each screen
   - Contain business logic
   - Use shared components

   **Shared Components**:
   - Button, Input, Card, Modal, Dropdown
   - Icon, Avatar, Badge, Spinner, Toast
   - No business logic, highly reusable

5. **Generate Component Tree**:
   - Load `.specify/templates/components-template.md` for output structure
   - Create hierarchical tree:

   ```
   App
   ├── Providers
   │   ├── ThemeProvider
   │   ├── AuthProvider
   │   └── RouterProvider
   │
   ├── Layout
   │   └── AppShell
   │       ├── Header
   │       ├── Main → {children}
   │       ├── Sidebar (optional)
   │       └── TabBar (mobile)
   │
   ├── Pages
   │   ├── HomePage
   │   │   └── [Page-specific components]
   │   ├── ListPage
   │   │   └── [Page-specific components]
   │   └── DetailPage
   │       └── [Page-specific components]
   │
   └── Shared
       ├── Button
       ├── Input
       ├── Card
       └── [Other shared components]
   ```

6. **Define Component Details**:
   For each significant component, document:

   ```markdown
   ### ComponentName
   - **Type**: Layout | Page | Presentational | Container
   - **Location**: `components/[category]/ComponentName`
   - **Props**:
     - `propName`: type (default value)
     - `propName`: type = required
   - **Variants**: variant1, variant2, variant3
   - **Children**: ChildComponent (×N if repeated)
   ```

   Example:
   ```markdown
   ### Button
   - **Type**: Presentational
   - **Location**: `components/shared/Button`
   - **Props**:
     - `variant`: 'primary' | 'secondary' | 'ghost' | 'danger'
     - `size`: 'sm' | 'md' | 'lg' = 'md'
     - `disabled`: boolean = false
     - `loading`: boolean = false
     - `leftIcon`: IconName (optional)
     - `children`: ReactNode
   - **Variants**: primary (filled), secondary (outlined), ghost (text)
   ```

7. **Create Reusability Matrix**:

   | Component | Used In | Instance Count |
   |-----------|---------|----------------|
   | Button | All pages | 15+ |
   | Card | Home, List, Detail | 10+ |
   | Input | Forms, Search | 8 |
   | Modal | Confirmations, Create | 3 |

8. **Document State Management**:

   | Component | Local State | Global State |
   |-----------|-------------|--------------|
   | FormPage | form values, validation | - |
   | Modal | open/closed | - |
   | ItemList | - | items, loading, error |
   | Header | - | user, theme |

9. **Map to Design System** (if applicable):
   If user mentions a design system (Material, Chakra, etc.):

   | Our Component | Design System | Notes |
   |---------------|---------------|-------|
   | Button | ds/Button | All variants supported |
   | Input | ds/TextField | Extend with icons |
   | Card | ds/Card | Custom elevation |

10. **Define Implementation Priority**:

    | Priority | Components | Rationale |
    |----------|------------|-----------|
    | P1 | Button, Input, Card, Icon | Foundation for all UIs |
    | P1 | Header, TabBar, AppShell | Layout structure |
    | P2 | ItemCard, FormField, Modal | Feature components |
    | P3 | Dropdown, Avatar, Badge | Enhancement components |

11. **Write Output**:
    - Write complete components document to `{FEATURE_DIR}/components.md`
    - Include all sections from template

12. **Report Completion**:
    - Display summary: total components, shared vs page-specific ratio
    - Suggest next step: `/speckit.tasks` to generate implementation tasks

## Component Type Definitions

| Type | Description | State | Business Logic |
|------|-------------|-------|----------------|
| Presentational | Pure UI, props only | None | None |
| Container | Wraps children, manages context | Local | None |
| Page | Route-level component | Mixed | Yes |
| Layout | Structural positioning | None | None |

## Key Rules

- Shared components MUST NOT contain business logic
- All components should support dark mode via theme context
- Touch targets minimum 44x44px on mobile
- Components should be accessible (ARIA labels, keyboard nav)
- Use composition over configuration
- Prefer explicit props over implicit behavior
- Document all variants visually when possible
