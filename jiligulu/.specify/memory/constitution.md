<!--
Sync Impact Report
==================
Version change: 1.0.0 → 2.0.0
Modified principles:
  - IV. Occam's Razor Design → IV. MVP-First & Python Razor
  - V. Dual Value Delivery → V. Emotional Companion Over Tool
Added principles:
  - VII. Elder-First Accessibility (最高优先级)
  - VIII. Modular Provider Abstraction
  - IX. Cost-Conscious Architecture
Added sections:
  - Project Identity
  - Locked Tech Stack
  - AI Agent Design Principles
  - Code Quality Standards
Removed sections: None
Templates requiring updates:
  - ✅ .specify/memory/constitution.md (this file)
  - ✅ plan-template.md (Constitution Check gates align with new principles)
  - ✅ spec-template.md (scope/requirements compatible)
  - ✅ tasks-template.md (task categories compatible)
Follow-up TODOs: None
-->

# 叽里咕噜（JiLiGuLu）项目宪法

## Project Identity

**叽里咕噜（JiLiGuLu）** 是中国首款"情感陪伴型"AI英语学习伴侣App，专为55-70岁退休人群设计。核心交互是一只名叫"叽叽"的AI小鹦鹉，通过语音对话教老年人学英语。子女付费、父母使用。

## Core Principles

### I. Specification as Source of Truth

Specifications MUST be the primary artifact driving all development. Code is a derived output, not the source of truth.

- Feature intent is expressed in natural language specifications
- Implementation plans derive from specifications, not the reverse
- Maintaining software means evolving specifications first
- Code regenerates from updated specifications

**Rationale**: When specs drive code, there is no gap between intent and implementation—only transformation.

### II. LLM-Native Output

All artifacts MUST be generated in formats that LLMs can both produce and consume effectively.

- Use Markdown and plain text for all documentation
- Use ASCII/text diagrams instead of binary image formats
- Structure documents with clear headings and consistent patterns
- Avoid formats requiring specialized tools to create or edit

**Rationale**: LLMs excel at text generation. Text-based formats enable fully autonomous specification-to-implementation workflows.

### III. UI/UX First-Class Support

User experience artifacts MUST be supported at the same level as technical specifications.

- User flows and journey maps are required for UI-facing features
- Information architecture defines content hierarchy and navigation
- Wireframes capture layout intent before visual design
- Component hierarchies map UI structure to implementation
- User task analysis identifies goals, steps, and pain points

**Rationale**: Complex UI apps fail when only technical specs exist. User experience artifacts bridge the gap between user intent and technical implementation.

### IV. MVP-First & Python Razor

The simplest solution that meets requirements MUST be preferred. Do not over-engineer.

- **MVP优先**：能用第三方API就不自建，能用managed service就不自运维
- Do not stack untested fixes; use defaults; simple beats clever
- Do not assume causes without evidence
- Remove unnecessary elements—every component MUST earn its place
- Prefer convention over configuration
- Question every abstraction layer

**Rationale**: A solo/small-team project MUST ruthlessly minimize complexity. Ship fast, validate assumptions, iterate. Premature abstraction kills momentum.

### V. Emotional Companion Over Tool

叽里咕噜 MUST position itself as an emotional companion, not a learning tool. Every feature MUST deliver both practical value AND emotional value.

- **Practical value**: Does it help the user learn usable English phrases?
- **Emotional value**: Does the user feel accompanied, encouraged, and delighted?
- The parrot "叽叽" is a learning buddy, NEVER an authoritative teacher
- Positive reinforcement MUST precede any correction—NEVER say "错了"
- Measure success by task completion AND user emotional satisfaction

**Rationale**: Replika's 85% emotional connection rate and Character.AI's 75-minute daily sessions prove that emotional bonds drive retention far beyond utility alone. For elderly users who fear embarrassment, emotional safety is the prerequisite for learning.

### VI. Text-Based Visual Artifacts

Visual design artifacts MUST be expressible in text formats suitable for LLM generation.

- User flows as ASCII flowcharts or Mermaid diagrams
- Wireframes as ASCII box layouts
- Component trees as indented text hierarchies
- Information architecture as nested markdown lists
- State diagrams as text-based state machines

**Rationale**: End-to-end LLM-driven design without external tools, while maintaining human readability and version control compatibility.

### VII. Elder-First Accessibility (最高优先级)

All UI/UX decisions MUST default to elder-friendly design. This is not a "mode"—it is the baseline.

- 全App最小字号18sp，正文22sp+，按钮触控区 ≥ 48x48dp
- 首页只有鹦鹉动画 + 一个大按钮，最多3层导航
- 永远不显示红色错误标记或负面分数
- 不做"老年模式"标签——默认就是适老设计
- 语音优先，文字辅助；所有AI回复同时提供语音 + 大字幕
- 暖色调配色，高对比度，圆润线条

**Rationale**: 老年人不想被标记为"需要帮助的人"。适老设计不是一个开关，而是产品的基因。当默认体验就是最好的体验时，所有用户都受益。

### VIII. Modular Provider Abstraction

ASR/LLM/TTS MUST be wrapped behind interface abstraction layers, allowing provider swap without code changes.

- ASR: Whisper ↔ Deepgram ↔ Azure, switchable via config
- LLM: GPT ↔ 豆包 ↔ Claude, switchable via config
- TTS: 豆包TTS ↔ Fish Audio ↔ Azure Neural, switchable via config
- Each provider adapter MUST implement a common interface
- Provider selection MUST be configurable at runtime or deployment

**Rationale**: AI provider landscape evolves rapidly. Cost, quality, and latency benchmarks shift quarterly. The ability to swap providers without code changes is a competitive advantage and a cost-control lever.

### IX. Cost-Conscious Architecture

Single-user daily API cost MUST stay under ¥1, monthly under ¥30.

- Every API call MUST be justified by user value
- Prefer caching, batching, and shorter prompts over raw API calls
- Monitor per-user cost as a first-class metric
- Choose models by cost-effectiveness, not raw capability
- Each conversation: 5-8 minutes, 3-5 core phrases—do not over-generate

**Rationale**: ¥198/year pricing with ¥15-30/month API cost gives healthy margins. Exceeding cost targets kills unit economics and forces price increases that hurt adoption.

## AI Agent Design Principles

These principles govern how the AI parrot "叽叽" behaves in all interactions:

1. **Identity**: 叽叽 is "也在学习的小伙伴"（a learning buddy），not a teacher. It also "learns Chinese" and occasionally makes endearing mistakes.
2. **Language Mix**: 70% Chinese + 30% English, gradually adjusting as user improves.
3. **Feedback Protocol**: Every correction MUST be preceded by affirmation. Use "很好/不错/很接近了", NEVER "错了/不对".
4. **Cognitive Load**: Maximum 3 new expressions per conversation turn.
5. **Pronunciation Assessment**: Use "可理解度"（comprehensibility）, NEVER "标准度"（native-likeness）.
6. **Addressing**: Call users "阿姨/叔叔", NEVER "同学/用户".
7. **Emotional Boundaries**: No emotional manipulation ("你不来我会想你"). When user is absent, the parrot simply sleeps peacefully.

## Locked Tech Stack

These choices are final for MVP. Changes require constitution amendment.

| Layer | Technology | Notes |
|-------|-----------|-------|
| Client | Flutter (Dart) | Cross-platform iOS + Android |
| State Management | Riverpod | Declarative, testable |
| Routing | GoRouter | Declarative routing |
| Backend | Python FastAPI | Async, type-hinted |
| Database | PostgreSQL | Primary data store |
| Cache | Redis | Session, rate limiting |
| Real-time | WebSocket | Voice stream transport |
| Animation | Rive or Lottie | Parrot animations |
| Deployment | Docker + Aliyun ECS | China-optimized |

## Design Philosophy

### Elder-Optimized Design Principles

When generating UI/UX artifacts for 叽里咕噜, apply these principles:

1. **Progressive Disclosure**: Show only what's needed; complexity is the enemy
2. **Visual Hierarchy**: Guide attention through size, warmth, and spacing
3. **Consistency**: Same patterns for same actions across the entire app
4. **Positive Feedback**: Every action gets encouraging, visible response
5. **Error Prevention**: Design to prevent mistakes; NEVER punish them
6. **Recognition over Recall**: Show options rather than requiring memory
7. **Voice-First**: Voice interaction is primary; text/buttons are secondary
8. **Aesthetic Warmth**: Visual design MUST feel warm, safe, and inviting

### Simplicity Standards

- Maximum 3 levels of navigation depth
- Maximum 5 items in any menu or list
- Maximum 1 primary action per screen (the big button)
- One primary CTA per view
- White space and breathing room are features, not waste
- First interaction: open app → tap one button → start talking

## Code Quality Standards

### Backend (Python FastAPI)

- Type annotations on all functions and parameters
- Pydantic models for all data structures
- pytest for all tests
- Each service in its own file
- Functions MUST NOT exceed 50 lines
- API contracts MUST be defined before implementation

### Frontend (Flutter/Dart)

- Widget componentization with elder-accessible component library
- State (Riverpod) separated from UI
- Reusable elder-friendly widgets: large buttons, large text, warm colors
- GoRouter for declarative navigation

### General

- Commit messages in Chinese, format: `feat/fix/refactor: 描述`
- No dead code, no commented-out blocks
- Configuration via environment variables, not hardcoded values

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

This constitution governs all 叽里咕噜 development and generated artifacts.

**Amendment Process**:
1. Propose change with rationale
2. Validate against existing principles
3. Update version following semver
4. Document in Sync Impact Report

**Compliance**:
- All features MUST pass Elder-First Accessibility check (Principle VII)
- All AI interactions MUST follow AI Agent Design Principles
- All provider integrations MUST use Modular Provider Abstraction (Principle VIII)
- All API usage MUST respect Cost-Conscious Architecture targets (Principle IX)
- All templates MUST follow LLM-native output principles
- Complexity MUST be justified against MVP-First & Python Razor principle

**Version**: 2.0.0 | **Ratified**: 2026-03-06 | **Last Amended**: 2026-03-06
