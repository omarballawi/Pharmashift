# Renlyst

Renlyst is an offline-first iPhone training companion for a community-pharmacy student. It uses SwiftUI and SwiftData, targets iOS 17+, and contains no login, analytics, cloud sync, or dispensing logic. Saved Drug Cards remain fully offline; network features are explicit, user-started trusted-source imports and optional DeepSeek learning assistance.

Open `PharmaShift.xcodeproj` in Xcode, select the `PharmaShift` scheme and an iOS 17+ iPhone simulator, then Build & Run. Unit and UI tests are included in the shared scheme.

The optional starter pack is educational example content. It is deliberately marked **Needs pharmacist verification** until the user explicitly confirms that a supervising pharmacist checked the facts and local trade names.

Windows-only unsigned IPA build and free sideloading instructions are in [`WINDOWS_IPA.md`](WINDOWS_IPA.md). The included GitHub Actions workflow builds `PharmaShift.ipa` on a hosted Mac without uploading Apple credentials.

Version 1.7 centers the library on active ingredients: many trade products and package photos share one evidence profile. Drug Cards are seven-page swipeable books with product leaflets, standard adult/child regimens, a transparent educational dose calculator, detailed prodrug and elimination explanations, sourced Altibbi/DailyMed/openFDA refresh, clickable in-library interactions, and full-library question regeneration. WHO median weight-for-age values may fill a missing pediatric weight only through age 10 and are always labeled as estimates.

The app also includes native package-photo cropping, visual pharmacology and safety, versioned backup/restore/export, five-question adaptive practice, Focus Mode, streaks, badges, and in-app reminders. Development and release gates are documented in [`PHASE_ROADMAP.md`](PHASE_ROADMAP.md). The repository contains a persistent Graphify knowledge graph used before architecture work.
