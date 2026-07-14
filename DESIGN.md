# Design

> Maintained as PharmaShift’s UI source of truth. Read this before changing screens, components, motion, or copy.

## Aesthetic direction

Crystal learning field notebook — trustworthy enough for a pharmacy shift, playful enough to invite daily recall, bilingual, and focused on one achievable learning action at a time. Faceted cyan/violet crystal imagery represents knowledge becoming durable; it is reserved for journeys, missions, and achievements rather than ordinary data cards.

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
- Crystal cyan and violet are secondary brand highlights on near-black navy mission surfaces; they never replace semantic safety colors.
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
- Drug Card: seven horizontally swipeable book pages — Overview, Brands, Doses, Learn, Safety, Counsel, and Notes & Links — with compact page chips and generated review actions at the end of the learning loop.
- Brands page: the active ingredient is the stable profile identity; package image, trade name, company, strength, form, shelf, and leaflet remain product-specific.
- Doses page: separates standard sourced regimens from the captured package strength. Calculator results always show the equation, estimate status, maximum caps, and cautions; entered person variables are never persisted.
- Pharmacology logarithmic meter/timeline and a knowledge-completeness map. Clinical cautions use labeled cards, never a pseudo-quantitative risk radar.
- Smart Session: one recommended mixed session; individual modes live under Quick practice and Choose a mode.
- Practice questions default to MCQ, True/False, matching/sorting, and short selection interactions. Text entry is reserved for scientific/trade-name spelling.
- AI Practice Pack: one manually refreshed, locally cached five-question session with explicit loading, error, and offline-ready states.
- AI card generation: optional package photo/OCR, Altibbi-first trusted aggregation with RxNorm/DailyMed/openFDA support, leaflet override, complete structured output, field-by-field inclusion, editable review questions, and `Not found` instead of silent gaps.
- System paths: class lessons advance through Recognize, Understand, Safety, Counsel, and Apply, then a system checkpoint.
- Knowledge graph, Compare Canvas, Daily Refresh, Mistake Vault, Shelf Quest, atomic linked notes, mechanism builder, PK timeline, safety sort, counseling builder, and voice counseling simulator.
- Crystal facets reflect repeated recall/application; they do not reward raw data entry or punish decay.
- Local-brand resolution confirmation row: AI suggests an ingredient only after trusted-source lookup fails; the learner must confirm before continuing.
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

2026-07-14 — ingredient-centered profiles and product variants, seven-page swipeable Drug Card, Altibbi-first source aggregation, product leaflet updates, structured standard regimens and dose calculator, WHO pediatric median estimates through age 10, detailed prodrug/elimination, library relationship refresh, and full question refresh.

2026-07-13 — crystal learning system, Today mission, Smart Session, five-page Drug Card, field memory scheduling, AI complete-card generation/review, graph/compare, interactive lessons, atomic notes, quests, accessibility, and native generated art.

2026-07-12 — verified DeepSeek settings status, optional import classification, local-brand confirmation, and offline AI Practice Pack.

2026-07-07 — continuous Drug Card, native crop flow, PK/safety visuals, backup/import flows, five-question practice, Focus Mode, and bilingual consistency pass.
