# Design

> Renlyst 2 visual and interaction source of truth. Read this with `PRODUCT.md` before changing product UI.

## Direction

Renlyst 2 is a warm native learning journal: Apple Journal’s editorial calm with Headspace-like approachability, translated through standard iOS structure. Its signature “knowledge orbit” uses layered coral, aqua, ink, and saffron forms to show individual facts becoming connected. The orbit appears in the app icon, Today, progress, and completion moments; it never replaces controls or semantic status.

## Dials

- DESIGN_VARIANCE: 6 / 10
- MOTION_INTENSITY: 4 / 10
- VISUAL_DENSITY: 4 / 10

## Navigation

- Four tab sections only: Today, Library, Practice, You.
- Add is an action from Today and Library, presented as a focused sheet; it is never a tab.
- Each tab owns a native `NavigationStack`. Topic detail uses push navigation; focused creation uses sheets.
- Today presents one recommended action. Advanced tools live under Library Tools or You.

## Typography

- San Francisco through semantic SwiftUI styles for UI, labels, data, and long content.
- System serif is reserved for the Today statement and active-drug name display moments.
- Counts and progress use `monospacedDigit()`.
- Arabic uses the system Arabic face, semantic styles, and right-to-left layout.
- No fixed body sizes; 11 points is the visual floor for supporting text.

## Color

- Primary action / coral: `#BF4533` in light mode, adaptively lifted in Dark Mode.
- Knowledge / aqua: `#17797E` in light mode, adaptively lifted in Dark Mode.
- Deep ink: `#142B46` for high-emphasis identity and app-icon ground.
- Saffron: achievement and learning rhythm only.
- Surfaces: `systemGroupedBackground`, `systemBackground`, `secondarySystemGroupedBackground`.
- Safety: system red; caution: system orange; success: system green.
- The accent is functional. No purple/cyan AI gradients, decorative full-screen color, or hand-rolled glass.

## Shape and spacing

- Page inset: 18 points.
- Section rhythm: 24 points; local spacing: 8–16 points.
- Main surfaces: 16-point continuous corners.
- Compact controls: 12-point continuous corners or native capsules when the control semantics call for one.
- Minimum target: 44×44 points; primary control height: 48 points.
- Use one containing surface per idea. Avoid cards nested inside cards.

## Core flows

### Today

- Editorial orbit hero with concise bilingual learning line.
- Exactly one recommended action from the focus engine.
- Seven-day rhythm and recently studied product photos.

### Library

- Native search, scopes, sorting, `List` reuse, swipe/context deletion, and calm empty state.
- Product photos lead rows; active drug, brands, system, and mastery remain scannable.
- Tools contains knowledge map, compare, shelf quest, and optional import/generation.

### Drug overview

- No horizontal topic carousel.
- Identity header, one memory summary, and pushed destinations for Brands, Uses, Forms & Dosing, Safety, Pharmacology, Counseling & Arabic, and Sources/Notes/Mastery.
- Manual brand creation requires brand name and at least one package photo. Ingredient names are inherited and read-only; component strengths and all product metadata remain editable.
- Manual brand creation never calls Gemini, DeepSeek, OpenRouter, or another network service.
- A brand can be deleted without deleting its active-drug profile.
- Whole-profile deletion asks Keep History or Erase History every time and defaults to Keep History.

### Practice

- One recommended Smart Five session.
- Quick modes use familiar rows; all modes, Daily Refresh, Mistake Vault, and AI Practice Pack are secondary tools.
- Completion uses a calm connected-knowledge illustration, not a trophy or confetti.

### You

- Learning rhythm, shift, report, backup/data, preferences/AI, and about/safety.
- Settings-shaped content uses native grouped forms and lists.

## Motion and feedback

- Press feedback: 160 ms.
- State change: 240 ms.
- Completion motion: at most 450 ms.
- Prefer system push/sheet transitions. No orchestrated page loads or perpetual movement.
- Reduce Motion replaces spatial/custom movement with immediate state or crossfade.
- Haptics are limited to save, delete confirmation, answer grading, and session completion.

## Imagery and icons

- Generated raster artwork is reserved for app identity, Today, meaningful empty states, manual-brand introduction, and session completion.
- Product photos are real user content and take priority in Library and recents.
- SF Symbols are the only control/icon family. Never use emoji as icons.
- No rasterized UI text, crystal imagery, medical crosses, caduceus, or generic AI sparkles as identity.

## Accessibility floor

- Dynamic Type, VoiceOver grouping, semantic headings, and explicit icon-only labels.
- System light/dark/high-contrast behavior and readable text contrast.
- 44-point interactive targets and no gesture-only action.
- Arabic learning blocks stay visible and correctly right-to-left.
- Deletion, source state, estimated calculations, and AI use are explained in text.

## Last updated

2026-07-16 — Renlyst 2.0 complete product-shell and workflow redesign; manual product-scoped brands; brand/profile deletion; knowledge-orbit identity; four-section navigation.
