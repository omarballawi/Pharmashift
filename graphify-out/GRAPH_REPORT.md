# Graph Report - pharmashift  (2026-07-07)

## Corpus Check
- 31 files · ~15,510 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 403 nodes · 910 edges · 24 communities (23 shown, 1 thin omitted)
- Extraction: 94% EXTRACTED · 6% INFERRED · 0% AMBIGUOUS · INFERRED: 54 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `6b25f2fd`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- [[_COMMUNITY_ShiftLog|ShiftLog]]
- [[_COMMUNITY_SwiftUI|SwiftUI]]
- [[_COMMUNITY_Drug|Drug]]
- [[_COMMUNITY_ImageCapture.swift|ImageCapture.swift]]
- [[_COMMUNITY_String|String]]
- [[_COMMUNITY_Chapter|Chapter]]
- [[_COMMUNITY_QuestionType|QuestionType]]
- [[_COMMUNITY_LibraryView|LibraryView]]
- [[_COMMUNITY_PracticeSessionView|PracticeSessionView]]
- [[_COMMUNITY_ShiftView|ShiftView]]
- [[_COMMUNITY_Identifiable|Identifiable]]
- [[_COMMUNITY_SafetyFlag|SafetyFlag]]
- [[_COMMUNITY_DosingFrequency|DosingFrequency]]
- [[_COMMUNITY_HalfLifeBand|HalfLifeBand]]
- [[_COMMUNITY_Build and install PharmaShift using only Windows|Build and install PharmaShift using only Windows]]
- [[_COMMUNITY_CaseIterable|CaseIterable]]
- [[_COMMUNITY_Codable|Codable]]
- [[_COMMUNITY_ConfidenceLevel|ConfidenceLevel]]
- [[_COMMUNITY_DurationBand|DurationBand]]
- [[_COMMUNITY_OnsetBand|OnsetBand]]
- [[_COMMUNITY_AGENTS|AGENTS.md]]
- [[_COMMUNITY_ModelAndPersistenceTests|ModelAndPersistenceTests]]
- [[_COMMUNITY_ReportEditorView|ReportEditorView]]
- [[_COMMUNITY_Q What should PharmaShift do after Phase 1|Q: What should PharmaShift do after Phase 1?]]

## God Nodes (most connected - your core abstractions)
1. `Drug` - 73 edges
2. `String` - 72 edges
3. `Chapter` - 37 edges
4. `DrugEditorView` - 27 edges
5. `ShiftLog` - 22 edges
6. `ReviewLog` - 18 edges
7. `QuestionType` - 17 edges
8. `SafetyFlag` - 16 edges
9. `SwiftUI` - 14 edges
10. `PracticeSessionView` - 14 edges

## Surprising Connections (you probably didn't know these)
- `PharmaShiftApp` --calls--> `AppTheme`  [INFERRED]
  PharmaShift/App/PharmaShiftApp.swift → PharmaShift/App/AppTheme.swift
- `AppTab` --references--> `String`  [EXTRACTED]
  PharmaShift/App/AppShell.swift → PharmaShift/Models/Models.swift
- `CaptureView` --references--> `Chapter`  [EXTRACTED]
  PharmaShift/Features/Capture/CaptureView.swift → PharmaShift/Models/Models.swift
- `CaptureView` --references--> `Drug`  [EXTRACTED]
  PharmaShift/Features/Capture/CaptureView.swift → PharmaShift/Models/Models.swift
- `CaptureView` --references--> `String`  [EXTRACTED]
  PharmaShift/Features/Capture/CaptureView.swift → PharmaShift/Models/Models.swift

## Import Cycles
- None detected.

## Communities (24 total, 1 thin omitted)

### Community 0 - "ShiftLog"
Cohesion: 0.13
Nodes (18): ReportView, EndShiftView, Binding, ReferenceWritableKeyPath, Drug, EncounterNote, ReviewLog, ShiftLog (+10 more)

### Community 1 - "SwiftUI"
Cohesion: 0.05
Nodes (37): App, PharmaShiftApp, CaptureView, FocusField, scientific, trade, unknownLabel, SaveAction (+29 more)

### Community 2 - "Drug"
Cohesion: 0.23
Nodes (10): DrugEditorView, Binding, Bool, PhotosPickerItem, ReferenceWritableKeyPath, SafetySeverity, high, low (+2 more)

### Community 3 - "ImageCapture.swift"
Cohesion: 0.11
Nodes (23): Any, CGFloat, CGSize, Context, LocalizedError, NSObject, CameraPicker, Coordinator (+15 more)

### Community 4 - "String"
Cohesion: 0.13
Nodes (17): HomeView, Color, Double, Int, SystemDashboardCard, SystemDashboardMetrics, DrugDetailView, Color (+9 more)

### Community 5 - "Chapter"
Cohesion: 0.07
Nodes (26): Observation, AboutView, AppNavigation, AppShell, AppTab, capture, home, library (+18 more)

### Community 6 - "QuestionType"
Cohesion: 0.10
Nodes (19): PharmaShift, QuestionType, casePractice, counseling, drugClass, scientificName, tradeName, use (+11 more)

### Community 7 - "LibraryView"
Cohesion: 0.06
Nodes (21): CoreTransferable, Foundation, Hashable, ModelContainer, ModelContext, LibraryView, Int, DrugFilter (+13 more)

### Community 8 - "PracticeSessionView"
Cohesion: 0.12
Nodes (13): PracticeMode, cases, counseling, drugClass, nameFlip, use, warning, PracticeSessionView (+5 more)

### Community 9 - "ShiftView"
Cohesion: 0.21
Nodes (11): ActiveShiftCard, ActiveShiftContent, EncounterEditorView, ShiftPhase, ShiftPhaseRow, ShiftView, Bool, Date (+3 more)

### Community 10 - "Identifiable"
Cohesion: 0.25
Nodes (7): Identifiable, ExcretionRoute, hepatic, mixed, renal, unknown, ImageDraft

### Community 11 - "SafetyFlag"
Cohesion: 0.25
Nodes (8): SafetyFlag, anticoagulant, children, controlledDrug, corticosteroid, insulin, pregnancy, severeSymptoms

### Community 12 - "DosingFrequency"
Cohesion: 0.29
Nodes (7): DosingFrequency, asNeeded, fourTimesDaily, onceDaily, threeTimesDaily, twiceDaily, unknown

### Community 13 - "HalfLifeBand"
Cohesion: 0.33
Nodes (6): HalfLifeBand, long, medium, short, unknown, veryLong

### Community 14 - "Build and install PharmaShift using only Windows"
Cohesion: 0.22
Nodes (7): PharmaShift Delivery Roadmap, Phase 2 - Visual Pharmacology and Safety, Phase 3 - Backup, Restore, and Export, Phase 4 - Drug Information Import, Phase 5 - Focus, Practice, and Motivation, Recommended Next Step, PharmaShift

### Community 15 - "CaseIterable"
Cohesion: 0.40
Nodes (5): CaseIterable, ProdrugStatus, no, unknown, yes

### Community 16 - "Codable"
Cohesion: 0.40
Nodes (5): Codable, VerificationStatus, pendingPharmacist, personal, pharmacistVerified

### Community 17 - "ConfidenceLevel"
Cohesion: 0.40
Nodes (5): ConfidenceLevel, mastered, medium, strong, weak

### Community 18 - "DurationBand"
Cohesion: 0.40
Nodes (5): DurationBand, long, medium, short, unknown

### Community 19 - "OnsetBand"
Cohesion: 0.40
Nodes (5): OnsetBand, fast, moderate, slow, unknown

### Community 21 - "ModelAndPersistenceTests"
Cohesion: 0.50
Nodes (3): 1. Build the IPA on GitHub, 2. Install from Windows, Build and install PharmaShift using only Windows

### Community 23 - "ReportEditorView"
Cohesion: 0.38
Nodes (4): ReportEditorView, Binding, Date, ReferenceWritableKeyPath

### Community 24 - "Q: What should PharmaShift do after Phase 1?"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: What should PharmaShift do after Phase 1?, Source Nodes

## Knowledge Gaps
- **113 isolated node(s):** `graphify`, `Phase 2 - Visual Pharmacology and Safety`, `Phase 3 - Backup, Restore, and Export`, `Phase 4 - Drug Information Import`, `Phase 5 - Focus, Practice, and Motivation` (+108 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **1 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `String` connect `String` to `ShiftLog`, `SwiftUI`, `Drug`, `ImageCapture.swift`, `Chapter`, `QuestionType`, `LibraryView`, `PracticeSessionView`, `ShiftView`, `Identifiable`, `SafetyFlag`, `DosingFrequency`, `HalfLifeBand`, `CaseIterable`, `Codable`, `ConfidenceLevel`, `DurationBand`, `OnsetBand`, `ReportEditorView`?**
  _High betweenness centrality (0.305) - this node is a cross-community bridge._
- **Why does `Drug` connect `ShiftLog` to `SwiftUI`, `Drug`, `ImageCapture.swift`, `String`, `Chapter`, `QuestionType`, `LibraryView`, `PracticeSessionView`, `ShiftView`, `Identifiable`, `SafetyFlag`, `DosingFrequency`, `HalfLifeBand`, `CaseIterable`, `Codable`, `ConfidenceLevel`, `DurationBand`, `OnsetBand`?**
  _High betweenness centrality (0.245) - this node is a cross-community bridge._
- **Why does `Chapter` connect `Chapter` to `ShiftLog`, `SwiftUI`, `Drug`, `String`, `PracticeSessionView`, `ShiftView`, `Identifiable`, `CaseIterable`, `Codable`?**
  _High betweenness centrality (0.101) - this node is a cross-community bridge._
- **Are the 15 inferred relationships involving `Drug` (e.g. with `.safetyFlagBinding()` and `.grade()`) actually correct?**
  _`Drug` has 15 INFERRED edges - model-reasoned connections that need verification._
- **What connects `graphify`, `Phase 2 - Visual Pharmacology and Safety`, `Phase 3 - Backup, Restore, and Export` to the rest of the system?**
  _113 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `ShiftLog` be split into smaller, more focused modules?**
  _Cohesion score 0.13170731707317074 - nodes in this community are weakly interconnected._
- **Should `SwiftUI` be split into smaller, more focused modules?**
  _Cohesion score 0.05314009661835749 - nodes in this community are weakly interconnected._