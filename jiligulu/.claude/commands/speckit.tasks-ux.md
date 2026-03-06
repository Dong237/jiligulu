---
description: Analyze user tasks from a UX perspective, identifying goals, steps, decision points, and pain points.
handoffs:
  - label: Create User Flows
    agent: speckit.userflows
    prompt: Generate user flow diagrams from task analysis
  - label: Build Technical Plan
    agent: speckit.plan
    prompt: Create implementation plan incorporating UX insights
    send: true
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

Analyze each user task from a UX perspective, breaking down goals, steps, decision points, and potential pain points to inform better design and implementation.

1. **Locate Feature Directory**:
   - Get current git branch name
   - Extract feature identifier (e.g., `001-feature-name`)
   - Set FEATURE_DIR = `specs/{branch-name}`
   - Verify FEATURE_DIR exists

2. **Load Required Documents**:
   - Read `{FEATURE_DIR}/spec.md` - REQUIRED (ERROR if missing)
   - Read `{FEATURE_DIR}/userflows.md` - if exists (enhances analysis)
   - Read `{FEATURE_DIR}/wireframes.md` - if exists (provides screen context)
   - Read `.specify/memory/constitution.md` if present

3. **Identify User Tasks**:
   - Extract tasks from user stories in spec.md
   - A task = a discrete goal a user wants to accomplish
   - Examples: "Create new item", "Search for item", "Update profile"

4. **Analyze Each Task**:
   - Load `.specify/templates/tasks-ux-template.md` for output structure
   - For each identified task, document:

   **Task Metadata**:
   ```markdown
   ## Task: [Task Name]

   **Actor**: [User persona or role]
   **Goal**: [What the user wants to achieve]
   **Frequency**: [Daily | Weekly | Occasionally | Once]
   **Criticality**: [High | Medium | Low]
   ```

   **Prerequisites**:
   ```markdown
   ### Prerequisites
   Before starting this task, the user must:
   - [ ] Have an account
   - [ ] Be logged in
   - [ ] Have necessary permissions
   ```

   **Steps Analysis**:
   ```markdown
   ### Steps

   | # | Action | Screen | Expected Result | Time Est. |
   |---|--------|--------|-----------------|-----------|
   | 1 | [User action] | [Screen] | [System response] | [Xs] |
   | 2 | [User action] | [Screen] | [System response] | [Xs] |
   ```

   **Decision Points**:
   ```markdown
   ### Decision Points

   | Step | Decision | Options | Factors |
   |------|----------|---------|---------|
   | [#] | [What choice user faces] | A: [option] / B: [option] | [Influences] |
   ```

   **Pain Points**:
   ```markdown
   ### Pain Points

   | Severity | Issue | Impact | Mitigation |
   |----------|-------|--------|------------|
   | 🔴 High | [Issue] | [User impact] | [How to address] |
   | 🟡 Medium | [Issue] | [User impact] | [How to address] |
   | 🟢 Low | [Issue] | [User impact] | [How to address] |
   ```

   **Success Criteria**:
   ```markdown
   ### Success Criteria
   - [ ] [Measurable outcome 1]
   - [ ] [Measurable outcome 2]
   - [ ] [Feedback confirmation]
   ```

   **Error Scenarios**:
   ```markdown
   ### Error Scenarios

   | Error | Cause | User Sees | Recovery |
   |-------|-------|-----------|----------|
   | [Type] | [Trigger] | [Message] | [How to recover] |
   ```

5. **Create Task Comparison Matrix**:

   | Task | Steps | Est. Time | Frequency | Priority |
   |------|-------|-----------|-----------|----------|
   | Task 1 | 5 | 30s | Daily | P1 |
   | Task 2 | 3 | 15s | Weekly | P2 |
   | Task 3 | 8 | 2m | Occasionally | P3 |

6. **Identify Common Pain Points**:
   Look for patterns across tasks:

   | Pain Point | Affected Tasks | Root Cause | Recommended Solution |
   |------------|----------------|------------|---------------------|
   | Too many steps | Task 1, 3 | Complex flow | Add shortcuts |
   | Unclear feedback | All tasks | Missing states | Add confirmation |

7. **Document Optimization Opportunities**:

   **Quick Wins** (Low effort, High impact):
   1. Add loading indicators
   2. Improve error messages
   3. Add keyboard shortcuts

   **Future Enhancements** (Higher effort):
   1. Auto-save drafts
   2. Bulk operations
   3. Undo functionality

8. **Create Persona Perspectives**:
   For different user types:

   ```markdown
   ### New User
   - **Familiarity**: Low
   - **Key Tasks**: [Which tasks they perform]
   - **Special Needs**: Extra guidance, simpler flows
   - **Pain Point Focus**: Confusion, too many options

   ### Power User
   - **Familiarity**: High
   - **Key Tasks**: [Which tasks they perform frequently]
   - **Special Needs**: Keyboard shortcuts, bulk actions
   - **Pain Point Focus**: Efficiency blockers
   ```

9. **Document Accessibility Considerations**:

   | Task | Accessibility Need | Implementation |
   |------|-------------------|----------------|
   | All | Keyboard navigation | Tab order, focus indicators |
   | Forms | Screen reader | ARIA labels, error announcements |
   | Lists | Screen reader | List semantics, item counts |

10. **Define Metrics to Track**:

    | Metric | Task | Target | Current |
    |--------|------|--------|---------|
    | Task completion rate | All | > 95% | TBD |
    | Time to complete | Task 1 | < 30s | TBD |
    | Error rate | Forms | < 5% | TBD |
    | Drop-off rate | Onboarding | < 10% | TBD |

11. **Write Output**:
    - Write complete task analysis to `{FEATURE_DIR}/tasks-ux.md`
    - Include all sections from template

12. **Report Completion**:
    - Display summary: tasks analyzed, pain points identified, quick wins
    - Suggest next step: `/speckit.plan` or `/speckit.userflows`

## Pain Point Severity Guidelines

| Severity | Definition | Examples |
|----------|------------|----------|
| 🔴 High | Blocks task completion | Form validation failure with no message |
| 🟡 Medium | Causes frustration | Slow loading, confusing labels |
| 🟢 Low | Minor inconvenience | Extra clicks, suboptimal defaults |

## Key Rules

- Every user story MUST have corresponding task analysis
- Pain points prioritized by: frequency × severity
- Success criteria MUST be measurable and testable
- Include edge cases and error scenarios
- Consider both new and power users
- Task analysis should be validated with real user testing
