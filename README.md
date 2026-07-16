# Renlyst

Renlyst is an offline-first iPhone learning companion for a community-pharmacy student. It uses SwiftUI and SwiftData, targets iOS 17+, and contains no login, analytics, cloud sync, or dispensing logic. Saved drug profiles and brand products remain fully offline; network features are explicit, user-started trusted-source imports, configurable OpenRouter vision package recognition, and an experimental DeepSeek full-profile generator.

Open `PharmaShift.xcodeproj` in Xcode, select the `PharmaShift` scheme and an iOS 17+ iPhone simulator, then Build & Run. Unit and UI tests are included in the shared scheme.

The optional starter pack is educational example content. It is deliberately marked **Needs pharmacist verification** until the user explicitly confirms that a supervising pharmacist checked the facts and local trade names.

Windows-only unsigned IPA build and free sideloading instructions are in [`WINDOWS_IPA.md`](WINDOWS_IPA.md). The included GitHub Actions workflow builds `PharmaShift.ipa` on a hosted Mac without uploading Apple credentials.

Version 2.0 centers the product around four calm sections: Today, Library, Practice, and You. Drug profiles open as a clear overview with focused topic screens instead of a dense swipeable tab strip. Each active ingredient can own many brand products and package photos. A brand can be added manually—with a required name and photo and no AI request—without changing the active-drug information, and brands or whole profiles can be deleted with explicit history handling.

The app also includes native package-photo cropping, product-scoped strengths and metadata, visual pharmacology and safety, educational dose calculations, versioned backup/restore/export, five-question adaptive practice, Focus Mode, streaks, badges, and in-app reminders. Development and release gates are documented in [`PHASE_ROADMAP.md`](PHASE_ROADMAP.md). The repository contains a persistent Graphify knowledge graph used before architecture work.
