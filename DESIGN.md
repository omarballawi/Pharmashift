# Design

> Maintained as PharmaShift’s UI source of truth. Read this before changing screens, components, motion, or copy.

## Aesthetic direction

Calm clinical field notebook — trustworthy and information-dense enough for a pharmacy shift, but warm, bilingual, and focused on one achievable learning action at a time.

## Dials

- DESIGN_VARIANCE: 5 / 10
- MOTION_INTENSITY: 3 / 10
- VISUAL_DENSITY: 5 / 10

## Type stack

- Display and body: Apple San Francisco through SwiftUI semantic styles (`largeTitle`, `title`, `headline`, `body`, `caption`).
- Data: semantic font plus `monospacedDigit()` for counts, doses, dates, and progress.
- Arabic: the system Arabic face, preserving Dynamic Type and right-to-left shaping.
- Never hard-code point sizes for body copy; SF Symbols are the only icon family.

The system typeface is intentional on iOS: it preserves Dynamic Type, Arabic shaping, legibility settings, and platform familiarity.

## Color tokens

- Accent: clinical teal, `Color(red: 0.02, green: 0.48, blue: 0.43)`.
- Background: `systemGroupedBackground`.
- Card: `secondarySystemGroupedBackground`.
- Success: system green; caution: system orange; destructive/high severity: system red.
- Chapter colors are semantic wayfinding, not competing global accents.
- Dark mode always uses semantic system surfaces; no pure hard-coded black or white page backgrounds.

## Shape and spacing

- Page horizontal inset: 16 pt.
- Major vertical rhythm: 18–22 pt; card internals: 12–16 pt.
- Primary cards: 20–26 pt continuous corners.
- Compact chips/status controls: capsules.
- Minimum interactive height: 44 pt; primary actions: 48 pt.
- Avoid cards nested inside cards; metrics inside a hero use dividers rather than miniature cards.

## Motion and haptics

- Use short SwiftUI spring/ease-out transitions only where state continuity matters.
- Completion and grading may use one subtle notification haptic.
- Crop controls may use selection/light impact haptics.
- Respect `accessibilityReduceMotion`; no perpetual, bounce, or decorative motion.

## Core component inventory

- Focus card: one primary action, current metrics, no competing CTA.
- Drug Card: one continuous scroll with optional jump chips.
- Pharmacology meter/status card and seven-axis safety radar with text equivalents.
- Five-question practice session with progress, feedback, summary, and wrong-answer review.
- Import comparison rows with explicit field toggles.
- Backup metadata preview with merge as default and destructive replace confirmation.
- Shared empty state, metric row, mastery badge, drug photo, and thumbnail.

## Brand voice

- Direct, supportive, and concrete; short sentences and specific verbs.
- English leads where necessary; Arabic companion copy is concise and natural.
- Never imply clinical authority or patient-specific advice.
- Avoid filler such as “elevate,” “seamless,” “unleash,” and “next-gen.”

## Accessibility floor

- Dynamic Type and semantic fonts throughout.
- System contrast in light and dark mode.
- 44×44 pt minimum touch targets.
- Explicit labels/hints for visual meters, crop gestures, provenance links, and icon-only controls.
- Right-to-left layout for Arabic content blocks.
- Text equivalents remain visible under every visual pharmacology shorthand.

## Last updated

2026-07-07 — continuous Drug Card, native crop flow, PK/safety visuals, backup/import flows, five-question practice, Focus Mode, and bilingual consistency pass.
