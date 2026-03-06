<!--
Sync Impact Report
==================
Version change: 0.0.0 → 1.0.0
Added principles:
  - I. Specification as Source of Truth
  - II. LLM-Native Output
  - III. UI/UX First-Class Support
  - IV. Occam's Razor Design
  - V. Dual Value Delivery
  - VI. Text-Based Visual Artifacts
Added sections:
  - Design Philosophy
  - Output Standards
Templates requiring updates:
  - ⚠️ templates/commands/ (need new UI/UX commands)
  - ⚠️ templates/ (need userflows, ia, wireframes templates)
Follow-up TODOs: None
-->

# Spec Kit Constitution

## Core Principles

### I. Specification as Source of Truth

Specifications MUST be the primary artifact driving all development. Code is a derived output, not the source of truth.

- Feature intent is expressed in natural language specifications
- Implementation plans derive from specifications, not the reverse
- Maintaining software means evolving specifications first
- Code regenerates from updated specifications

**Rationale**: This inverts the traditional power structure where code dominates. When specs drive code, there is no gap between intent and implementation—only transformation.

### II. LLM-Native Output

All artifacts MUST be generated in formats that LLMs can both produce and consume effectively.

- Use Markdown and plain text for all documentation
- Use ASCII/text diagrams instead of binary image formats
- Structure documents with clear headings and consistent patterns
- Avoid formats requiring specialized tools to create or edit

**Rationale**: LLMs excel at text generation. By constraining outputs to text-based formats, we enable fully autonomous specification-to-implementation workflows.

### III. UI/UX First-Class Support

User experience artifacts MUST be supported at the same level as technical specifications.

- User flows and journey maps are required for UI-facing features
- Information architecture defines content hierarchy and navigation
- Wireframes capture layout intent before visual design
- Component hierarchies map UI structure to implementation
- User task analysis identifies goals, steps, and pain points

**Rationale**: Complex UI apps fail when only technical specs exist. User experience artifacts bridge the gap between user intent and technical implementation.

### IV. Occam's Razor Design

The simplest solution that meets requirements MUST be preferred. Complexity requires explicit justification.

- Remove unnecessary elements—every component must earn its place
- Prefer convention over configuration
- One obvious way to do things, not multiple equivalent options
- Elegance emerges from constraint, not from feature abundance
- Question every abstraction layer

**Rationale**: Beautiful, practical design comes from relentless simplification. Complexity is the enemy of both usability and maintainability.

### V. Dual Value Delivery

Every feature MUST deliver both practical value AND experience value.

- **Practical value**: Does it solve the user's problem efficiently?
- **Experience value**: Does it feel good to use? Is it delightful?
- Neither dimension can be sacrificed for the other
- Measure success by task completion AND user satisfaction

**Rationale**: Tools that only work are forgotten. Tools that also delight are loved. Spec Kit must enable building software people love to use.

### VI. Text-Based Visual Artifacts

Visual design artifacts MUST be expressible in text formats suitable for LLM generation.

- User flows as ASCII flowcharts or Mermaid diagrams
- Wireframes as ASCII box layouts
- Component trees as indented text hierarchies
- Information architecture as nested markdown lists
- State diagrams as text-based state machines

**Rationale**: This enables end-to-end LLM-driven design without requiring external design tools, while maintaining human readability and version control compatibility.

## Design Philosophy

### Modern App Design Principles

When generating UI/UX artifacts, apply these principles:

1. **Progressive Disclosure**: Show only what's needed, reveal complexity gradually
2. **Visual Hierarchy**: Guide attention through size, color, and spacing
3. **Consistency**: Same patterns for same actions across the entire app
4. **Feedback**: Every action has a visible response
5. **Error Prevention**: Design to prevent mistakes, not just handle them
6. **Recognition over Recall**: Show options rather than requiring memory
7. **Flexibility**: Support both novice and expert users
8. **Aesthetic Integrity**: Visual design supports (never fights) functionality

### Simplicity Standards

- Maximum 3 levels of navigation depth
- Maximum 5±2 items in any menu or list
- Maximum 3 primary actions per screen
- One primary CTA (call-to-action) per view
- White space is a feature, not wasted space

## Output Standards

### Required Artifacts for UI Features

| Artifact | Format | Purpose |
|----------|--------|---------|
| spec.md | Markdown | User stories, requirements |
| userflows.md | Mermaid/ASCII | Journey maps, decision trees |
| ia.md | Nested Markdown | Site map, content hierarchy |
| wireframes.md | ASCII boxes | Screen layouts |
| components.md | Tree structure | UI component hierarchy |
| plan.md | Markdown | Technical implementation |
| tasks.md | Checklist Markdown | Actionable work items |

### Optional Artifacts

| Artifact | When Needed |
|----------|-------------|
| research.md | Complex tech decisions |
| data-model.md | Data-heavy features |
| contracts/ | API-driven features |
| states.md | Complex state management |

## Governance

This constitution governs all Spec Kit development and generated artifacts.

**Amendment Process**:
1. Propose change with rationale
2. Validate against existing principles
3. Update version following semver
4. Document in Sync Impact Report

**Compliance**:
- All new commands MUST support UI/UX artifacts when applicable
- All templates MUST follow LLM-native output principles
- Complexity MUST be justified against Occam's Razor principle

**Version**: 1.0.0 | **Ratified**: 2026-01-09 | **Last Amended**: 2026-01-09
