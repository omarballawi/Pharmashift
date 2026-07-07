# PharmaShift Delivery Roadmap

Phase 1 is complete: the bilingual systems dashboard, future-ready drug model, modern Drug Card/editor, image crop and preview flow, thumbnail library, filters, and automatic IPA packaging are implemented.

Every later phase follows the same release gate: update the Graphify knowledge graph, run tests on GitHub's macOS runner, commit and push the complete change, build an unsigned IPA, verify its archive, and commit the generated IPA.

## Phase 2 - Visual Pharmacology and Safety

Goal: turn the future-ready PK and safety fields from Phase 1 into fast, memorable visual learning tools.

- Add reusable visual cards for half-life, onset, duration, dosing frequency, prodrug status, and excretion.
- Use selectable chips and short scales in the editor; keep exact values and free-text notes available.
- Add safety cards for contraindications, toxicity, warnings, interactions, pregnancy, renal, and hepatic cautions.
- Build a safety radar from the seven stored severity categories, with accessible text equivalents.
- Add restrained animations, haptics, reduced-motion support, Dynamic Type checks, and Arabic/English layouts.
- Keep safety information inside the Drug Card; do not restore global banners or repeated warnings.

Acceptance: every stored PK/safety value can be edited and understood visually, empty/unknown states remain calm, legacy safety flags remain visible, and unit/UI tests cover value mapping and accessibility.

## Phase 3 - Backup, Restore, and Export

Goal: make training data portable and recoverable before adding online imports or more progression state.

- Define a versioned `PharmaShiftBackup` Codable snapshot covering drugs, mastery, reviews, shifts, encounter notes, and reports.
- Provide a compact JSON backup without images and a complete JSON backup with compressed images encoded as data.
- Preview backup metadata before restore: creation date, version, record counts, and image inclusion.
- Restore transactionally with validation and an explicit choice between replacing current data or merging by stable UUID.
- Export the drug library as UTF-8 CSV and the training report as UTF-8 text with Arabic preserved.
- Add Settings/Report entry points, share sheets, destructive confirmation, progress, and actionable errors.

Acceptance: round-trip tests reproduce all records and relationships, malformed/newer backups fail safely, merge is idempotent, Arabic survives exactly, and image-inclusive restoration is verified.

## Phase 4 - Drug Information Import

Goal: import selected evidence into editable cards without making the offline app dependent on a network.

- Add `DrugInfoProvider`, `DrugSearchResult`, and `ImportedDrugInfo` interfaces with async search/detail methods.
- Implement `MockDrugInfoProvider` first for deterministic previews and tests.
- Build search, loading, empty, offline, and error states plus a field-by-field preview selector.
- Merge only user-selected fields; never overwrite personal notes, mastery, images, or Arabic text implicitly.
- Persist provider name and source URL and keep every imported value editable.
- Add a DailyMed provider after validating the current public API and mapping rules; evaluate openFDA only for fields DailyMed cannot supply reliably.
- Cache the most recent successful result locally while keeping all saved cards usable offline.

Acceptance: mock import is fully tested, cancellation and retries behave correctly, selective merging is deterministic, provenance is visible, and network failure cannot damage a card.

## Phase 5 - Focus, Practice, and Motivation

Goal: make daily use ADHD-friendly and rewarding without turning learning into noisy gamification.

- Add Focus Mode with one current action: add a drug, review due drugs, practice weak drugs, or finish shift reflection.
- Convert practice into five-question visual sessions with progress, positive feedback, restart, and wrong-answer review.
- Complete the requested modes: both name directions, class/examples, drug/use, drug/warning, image quiz, counseling, weak-drug, and system quiz.
- Add a persistent learning profile for daily activity, streaks, badges, missions, and completion history.
- Derive mastery strictly from the existing six checks; motivation UI must not create a second mastery truth.
- Add subtle animations and haptics with reduced-motion support, plus in-app weak-drug reminders that do not require notification permission.

Acceptance: Focus Mode never presents competing primary actions, sessions contain exactly five questions, streak calculations tolerate missed days/time-zone changes, mastery remains consistent, and all motivational effects remain optional and accessible.

## Recommended Next Step

Implement Phase 2 as one release milestone. It is mostly a UI layer over fields already stored in `Drug`, so it has the lowest migration risk and immediately makes the app more useful without adding network or restore complexity.
