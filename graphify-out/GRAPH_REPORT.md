# Graph Report - pharmashift  (2026-07-07)

## Corpus Check
- 31 files · ~17,974 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 486 nodes · 1117 edges · 30 communities (27 shown, 3 thin omitted)
- Extraction: 94% EXTRACTED · 6% INFERRED · 0% AMBIGUOUS · INFERRED: 63 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `8db701d6`
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

## God Nodes (most connected - your core abstractions)
1. `String` - 82 edges
2. `Drug` - 77 edges
3. `Chapter` - 37 edges
4. `DrugEditorView` - 34 edges
5. `ShiftLog` - 22 edges
6. `Coordinator` - 22 edges
7. `SafetySeverity` - 18 edges
8. `ReviewLog` - 18 edges
9. `CaptureView` - 17 edges
10. `QuestionType` - 17 edges

## Surprising Connections (you probably didn't know these)
- `AppTab` --references--> `String`  [EXTRACTED]
  PharmaShift/App/AppShell.swift → PharmaShift/Models/Models.swift
- `PharmaShiftApp` --calls--> `AppTheme`  [INFERRED]
  PharmaShift/App/PharmaShiftApp.swift → PharmaShift/App/AppTheme.swift
- `CaptureView` --references--> `Chapter`  [EXTRACTED]
  PharmaShift/Features/Capture/CaptureView.swift → PharmaShift/Models/Models.swift
- `CaptureView` --references--> `Drug`  [EXTRACTED]
  PharmaShift/Features/Capture/CaptureView.swift → PharmaShift/Models/Models.swift
- `CaptureView` --references--> `String`  [EXTRACTED]
  PharmaShift/Features/Capture/CaptureView.swift → PharmaShift/Models/Models.swift

## Import Cycles
- None detected.

## Communities (30 total, 3 thin omitted)

### Community 0 - "ShiftLog"
Cohesion: 0.06
Nodes (34): ModelContainer, PracticeView, ReportView, Double, WeaknessRadarView, EndShiftView, Binding, ReferenceWritableKeyPath (+26 more)

### Community 1 - "SwiftUI"
Cohesion: 0.20
Nodes (10): DrugCardAnchor, arabic, counseling, identity, mastery, notes, pharmacology, review (+2 more)

### Community 2 - "Drug"
Cohesion: 0.10
Nodes (24): ClosedRange, DrugEditorView, Binding, Bool, Double, PhotosPickerItem, ReferenceWritableKeyPath, SafetySeverity (+16 more)

### Community 3 - "ImageCapture.swift"
Cohesion: 0.06
Nodes (40): Any, CGRect, CGSize, Context, ImageIO, LocalizedError, NSObject, CameraPicker (+32 more)

### Community 4 - "String"
Cohesion: 0.08
Nodes (28): Content, HomeView, Color, Double, Int, SystemDashboardCard, SystemDashboardMetrics, DrugDetailSheet (+20 more)

### Community 5 - "Chapter"
Cohesion: 0.07
Nodes (30): AboutView, AppNavigation, AppShell, AppTab, capture, home, library, more (+22 more)

### Community 6 - "QuestionType"
Cohesion: 0.19
Nodes (6): PharmaShift, ReportBuilderTests, PharmaShiftUITests, UIKit, XCTest, XCTestCase

### Community 7 - "LibraryView"
Cohesion: 0.24
Nodes (5): ModelContext, LibraryView, Int, StarterContent, Int

### Community 8 - "PracticeSessionView"
Cohesion: 0.33
Nodes (3): PhotosUI, SwiftData, SwiftUI

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
Cohesion: 0.22
Nodes (9): Codable, ReviewRating, correct, partlyCorrect, wrong, VerificationStatus, pendingPharmacist, personal (+1 more)

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
Cohesion: 0.09
Nodes (20): CaptureView, FocusField, scientific, trade, unknownLabel, SaveAction, another, later (+12 more)

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
Cohesion: 0.38
Nodes (4): ReportEditorView, Binding, Date, ReferenceWritableKeyPath

### Community 27 - "AppTheme"
Cohesion: 0.40
Nodes (5): App, AppTheme, Color, PharmaShiftApp, Scene

### Community 28 - "Foundation"
Cohesion: 0.33
Nodes (5): CoreTransferable, ReportFile, Transferable, TransferRepresentation, UniformTypeIdentifiers

## Knowledge Gaps
- **125 isolated node(s):** `home`, `library`, `capture`, `practice`, `more` (+120 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **3 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `String` connect `String` to `ShiftLog`, `SwiftUI`, `Drug`, `ImageCapture.swift`, `Chapter`, `LibraryView`, `ShiftView`, `Identifiable`, `SafetyFlag`, `DosingFrequency`, `HalfLifeBand`, `CaseIterable`, `Codable`, `ConfidenceLevel`, `DurationBand`, `OnsetBand`, `ModelAndPersistenceTests`, `QuestionType`, `ReportEditorView`, `Identifiable`, `Foundation`, `ReportEditorView`?**
  _High betweenness centrality (0.339) - this node is a cross-community bridge._
- **Why does `Drug` connect `ShiftLog` to `Drug`, `ImageCapture.swift`, `String`, `Chapter`, `LibraryView`, `ShiftView`, `Identifiable`, `SafetyFlag`, `DosingFrequency`, `HalfLifeBand`, `CaseIterable`, `Codable`, `ConfidenceLevel`, `DurationBand`, `OnsetBand`, `ModelAndPersistenceTests`?**
  _High betweenness centrality (0.209) - this node is a cross-community bridge._
- **Why does `Chapter` connect `Chapter` to `ShiftLog`, `Drug`, `String`, `ShiftView`, `CaseIterable`, `Codable`, `ConfidenceLevel`, `ModelAndPersistenceTests`, `AppTheme`?**
  _High betweenness centrality (0.084) - this node is a cross-community bridge._
- **Are the 15 inferred relationships involving `Drug` (e.g. with `.safetyFlagBinding()` and `.grade()`) actually correct?**
  _`Drug` has 15 INFERRED edges - model-reasoned connections that need verification._
- **What connects `home`, `library`, `capture` to the rest of the system?**
  _125 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `ShiftLog` be split into smaller, more focused modules?**
  _Cohesion score 0.06342342342342343 - nodes in this community are weakly interconnected._
- **Should `Drug` be split into smaller, more focused modules?**
  _Cohesion score 0.0966183574879227 - nodes in this community are weakly interconnected._