# PharmaShift

PharmaShift is an offline-first iPhone training companion for a community-pharmacy student. It uses SwiftUI and SwiftData, targets iOS 17+, and contains no network, analytics, AI, cloud sync, or dispensing logic.

Open `PharmaShift.xcodeproj` in Xcode, select the `PharmaShift` scheme and an iOS 17+ iPhone simulator, then Build & Run. Unit and UI tests are included in the shared scheme.

The optional starter pack is educational example content. It is deliberately marked **Needs pharmacist verification** until the user explicitly confirms that a supervising pharmacist checked the facts and local trade names.

Windows-only unsigned IPA build and free sideloading instructions are in [`WINDOWS_IPA.md`](WINDOWS_IPA.md). The included GitHub Actions workflow builds `PharmaShift.ipa` on a hosted Mac without uploading Apple credentials.

Development status and the implementation order for Phases 2–5 are documented in [`PHASE_ROADMAP.md`](PHASE_ROADMAP.md). The repository also contains a persistent Graphify knowledge graph used by Codex before architecture work.
