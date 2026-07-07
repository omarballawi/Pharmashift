# Graph Report - pharmashift  (2026-07-07)

## Corpus Check
- 31 files · ~17,935 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 483 nodes · 1111 edges · 31 communities (30 shown, 1 thin omitted)
- Extraction: 94% EXTRACTED · 6% INFERRED · 0% AMBIGUOUS · INFERRED: 63 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `83b1d1fd`
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
- [[_COMMUNITY_QuestionType|QuestionType]]
- [[_COMMUNITY_ReportEditorView|ReportEditorView]]
- [[_COMMUNITY_Q What should PharmaShift do after Phase 1|Q: What should PharmaShift do after Phase 1?]]
- [[_COMMUNITY_Identifiable|Identifiable]]
- [[_COMMUNITY_FocusField|FocusField]]
- [[_COMMUNITY_AppTheme|AppTheme]]
- [[_COMMUNITY_Foundation|Foundation]]
- [[_COMMUNITY_ReportEditorView|ReportEditorView]]
- [[_COMMUNITY_ReportFile.swift|ReportFile.swift]]

## God Nodes (most connected - your core abstractions)
1. `String` - 81 edges
2. `Drug` - 77 edges
3. `Chapter` - 37 edges
4. `DrugEditorView` - 33 edges
5. `ShiftLog` - 22 edges
6. `Coordinator` - 22 edges
7. `SafetySeverity` - 18 edges
8. `ReviewLog` - 18 edges
9. `QuestionType` - 17 edges
10. `CaptureView` - 16 edges

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

## Communities (31 total, 1 thin omitted)

### Community 0 - "ShiftLog"
Cohesion: 0.07
Nodes (31): ReportView, Double, WeaknessRadarView, EndShiftView, Binding, ReferenceWritableKeyPath, Drug, EncounterNote (+23 more)

### Community 1 - "SwiftUI"
Cohesion: 0.16
Nodes (9): CaptureView, Binding, Bool, Data, PhotosPickerItem, ImageFlowDestination, camera, crop (+1 more)

### Community 2 - "Drug"
Cohesion: 0.10
Nodes (23): ClosedRange, DrugEditorView, Binding, Bool, Double, PhotosPickerItem, ReferenceWritableKeyPath, SafetySeverity (+15 more)

### Community 3 - "ImageCapture.swift"
Cohesion: 0.07
Nodes (32): Any, CGRect, CGSize, Context, NSObject, CameraPicker, Coordinator, CropViewportState (+24 more)

### Community 4 - "String"
Cohesion: 0.08
Nodes (29): Content, HomeView, Color, Double, Int, SystemDashboardCard, SystemDashboardMetrics, DrugDetailSheet (+21 more)

### Community 5 - "Chapter"
Cohesion: 0.06
Nodes (31): AboutView, AppNavigation, AppShell, AppTab, capture, home, library, more (+23 more)

### Community 6 - "QuestionType"
Cohesion: 0.09
Nodes (13): ModelContainer, PharmaShift, DrugFilter, Bool, Calendar, Date, PrivacyValidator, Bool (+5 more)

### Community 7 - "LibraryView"
Cohesion: 0.24
Nodes (5): ModelContext, LibraryView, Int, StarterContent, Int

### Community 8 - "PracticeSessionView"
Cohesion: 0.29
Nodes (5): App, PharmaShiftApp, Scene, SwiftData, SwiftUI

### Community 9 - "ShiftView"
Cohesion: 0.33
Nodes (9): ActiveShiftCard, ActiveShiftContent, ShiftPhase, ShiftPhaseRow, ShiftView, Bool, Date, Double (+1 more)

### Community 10 - "Identifiable"
Cohesion: 0.40
Nodes (5): ExcretionRoute, hepatic, mixed, renal, unknown

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
Cohesion: 0.15
Nodes (10): PharmaShift Delivery Roadmap, Phase 2 - Visual Pharmacology and Safety, Phase 3 - Backup, Restore, and Export, Phase 4 - Drug Information Import, Phase 5 - Focus, Practice, and Motivation, Recommended Next Step, PharmaShift, 1. Build the IPA on GitHub (+2 more)

### Community 15 - "CaseIterable"
Cohesion: 0.40
Nodes (5): CaseIterable, ProdrugStatus, no, unknown, yes

### Community 16 - "Codable"
Cohesion: 0.40
Nodes (5): Codable, VerificationStatus, pendingPharmacist, personal, pharmacistVerified

### Community 17 - "ConfidenceLevel"
Cohesion: 0.25
Nodes (8): Hashable, Identifiable, ConfidenceLevel, mastered, medium, strong, weak, PracticeCase

### Community 18 - "DurationBand"
Cohesion: 0.40
Nodes (5): DurationBand, long, medium, short, unknown

### Community 19 - "OnsetBand"
Cohesion: 0.40
Nodes (5): OnsetBand, fast, moderate, slow, unknown

### Community 21 - "ModelAndPersistenceTests"
Cohesion: 0.20
Nodes (10): DrugCardAnchor, arabic, counseling, identity, mastery, notes, pharmacology, review (+2 more)

### Community 22 - "QuestionType"
Cohesion: 0.25
Nodes (8): QuestionType, casePractice, counseling, drugClass, scientificName, tradeName, use, warning

### Community 23 - "ReportEditorView"
Cohesion: 0.29
Nodes (7): DrugEditorSection, basics, counseling, notes, pk, safety, uses

### Community 24 - "Q: What should PharmaShift do after Phase 1?"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: What should PharmaShift do after Phase 1?, Source Nodes

### Community 25 - "Identifiable"
Cohesion: 0.22
Nodes (8): ImageIO, LocalizedError, CropGrid, DrugThumbnailView, ImagePipelineError, invalidImage, processingFailed, Shape

### Community 26 - "FocusField"
Cohesion: 0.29
Nodes (6): FocusField, scientific, trade, unknownLabel, PhotosUI, UIKit

### Community 27 - "AppTheme"
Cohesion: 0.38
Nodes (4): ReportEditorView, Binding, Date, ReferenceWritableKeyPath

### Community 28 - "Foundation"
Cohesion: 0.20
Nodes (6): CoreTransferable, Foundation, ReportFile, Transferable, TransferRepresentation, UniformTypeIdentifiers

### Community 29 - "ReportEditorView"
Cohesion: 0.40
Nodes (3): Observation, AppTheme, Color

### Community 30 - "ReportFile.swift"
Cohesion: 0.50
Nodes (4): SaveAction, another, later, open

## Knowledge Gaps
- **123 isolated node(s):** `home`, `library`, `capture`, `practice`, `more` (+118 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **1 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `String` connect `String` to `ShiftLog`, `SwiftUI`, `Drug`, `ImageCapture.swift`, `Chapter`, `QuestionType`, `LibraryView`, `ShiftView`, `Identifiable`, `SafetyFlag`, `DosingFrequency`, `HalfLifeBand`, `CaseIterable`, `Codable`, `ConfidenceLevel`, `DurationBand`, `OnsetBand`, `ModelAndPersistenceTests`, `QuestionType`, `ReportEditorView`, `Identifiable`, `AppTheme`, `Foundation`?**
  _High betweenness centrality (0.335) - this node is a cross-community bridge._
- **Why does `Drug` connect `ShiftLog` to `SwiftUI`, `Drug`, `String`, `Chapter`, `QuestionType`, `LibraryView`, `ShiftView`, `Identifiable`, `SafetyFlag`, `DosingFrequency`, `HalfLifeBand`, `CaseIterable`, `Codable`, `ConfidenceLevel`, `DurationBand`, `OnsetBand`, `Identifiable`?**
  _High betweenness centrality (0.211) - this node is a cross-community bridge._
- **Why does `Chapter` connect `Chapter` to `ShiftLog`, `SwiftUI`, `Drug`, `String`, `ShiftView`, `CaseIterable`, `Codable`, `ConfidenceLevel`, `ReportEditorView`?**
  _High betweenness centrality (0.084) - this node is a cross-community bridge._
- **Are the 15 inferred relationships involving `Drug` (e.g. with `.safetyFlagBinding()` and `.grade()`) actually correct?**
  _`Drug` has 15 INFERRED edges - model-reasoned connections that need verification._
- **What connects `home`, `library`, `capture` to the rest of the system?**
  _123 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `ShiftLog` be split into smaller, more focused modules?**
  _Cohesion score 0.07451923076923077 - nodes in this community are weakly interconnected._
- **Should `Drug` be split into smaller, more focused modules?**
  _Cohesion score 0.09797979797979799 - nodes in this community are weakly interconnected._