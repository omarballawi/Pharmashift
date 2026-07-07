# Graph Report - pharmashift  (2026-07-07)

## Corpus Check
- 31 files · ~17,974 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 508 nodes · 1079 edges · 31 communities (24 shown, 7 thin omitted)
- Extraction: 97% EXTRACTED · 3% INFERRED · 0% AMBIGUOUS · INFERRED: 27 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `2152e50f`
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
- [[_COMMUNITY_Path|Path]]

## God Nodes (most connected - your core abstractions)
1. `String` - 68 edges
2. `Drug` - 54 edges
3. `Chapter` - 35 edges
4. `DrugEditorView` - 34 edges
5. `Coordinator` - 22 edges
6. `ShiftLog` - 21 edges
7. `CaptureView` - 17 edges
8. `QuestionType` - 17 edges
9. `ReviewLog` - 17 edges
10. `DrugDetailView` - 16 edges

## Surprising Connections (you probably didn't know these)
- `PreviewData` --calls--> `Drug`  [INFERRED]
  PharmaShift/Shared/PreviewSupport.swift → PharmaShift/Models/Models.swift
- `PreviewData` --calls--> `ShiftLog`  [INFERRED]
  PharmaShift/Shared/PreviewSupport.swift → PharmaShift/Models/Models.swift
- `CaptureView` --references--> `ImageAcquisitionSource`  [EXTRACTED]
  PharmaShift/Features/Capture/CaptureView.swift → PharmaShift/Shared/ImageCapture.swift
- `CaptureView` --references--> `ImageDraft`  [EXTRACTED]
  PharmaShift/Features/Capture/CaptureView.swift → PharmaShift/Shared/ImageCapture.swift
- `DrugEditorView` --references--> `ImageDraft`  [EXTRACTED]
  PharmaShift/Features/Library/DrugEditorView.swift → PharmaShift/Shared/ImageCapture.swift

## Import Cycles
- None detected.

## Communities (31 total, 7 thin omitted)

### Community 0 - "ShiftLog"
Cohesion: 0.10
Nodes (27): ReportEditorView, ReportView, Binding, Date, Double, ReferenceWritableKeyPath, WeaknessRadarView, EncounterEditorView (+19 more)

### Community 1 - "SwiftUI"
Cohesion: 0.08
Nodes (24): App, ModelContainer, Observation, AppTheme, Color, PharmaShiftApp, DrugCardAnchor, arabic (+16 more)

### Community 2 - "Drug"
Cohesion: 0.07
Nodes (31): ClosedRange, Content, DrugDetailView, Color, DrugRow, SafetySeverity, high, low (+23 more)

### Community 3 - "ImageCapture.swift"
Cohesion: 0.07
Nodes (37): Any, CGFloat, CGPoint, CGRect, CGSize, Context, ImageIO, Int (+29 more)

### Community 4 - "String"
Cohesion: 0.17
Nodes (9): PracticeMode, cases, counseling, drugClass, nameFlip, use, warning, PracticeSessionView (+1 more)

### Community 5 - "Chapter"
Cohesion: 0.07
Nodes (29): AboutView, AppNavigation, AppShell, AppTab, capture, home, library, more (+21 more)

### Community 6 - "QuestionType"
Cohesion: 0.10
Nodes (6): PharmaShift, ModelAndPersistenceTests, ReportBuilderTests, PharmaShiftUITests, XCTest, XCTestCase

### Community 7 - "LibraryView"
Cohesion: 0.07
Nodes (19): CoreTransferable, Foundation, Hashable, ModelContext, LibraryView, Int, DrugFilter, Bool (+11 more)

### Community 8 - "PracticeSessionView"
Cohesion: 0.25
Nodes (8): Identifiable, DrugDetailSheet, editor, review, ReviewRating, correct, partlyCorrect, wrong

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
Cohesion: 0.40
Nodes (5): ConfidenceLevel, mastered, medium, strong, weak

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
Cohesion: 0.14
Nodes (14): QuestionType, casePractice, counseling, drugClass, scientificName, tradeName, use, warning (+6 more)

### Community 23 - "ReportEditorView"
Cohesion: 0.10
Nodes (32): DosingFrequency, Double, DurationBand, ExcretionRoute, HalfLifeBand, LocalizedError, OnsetBand, PharmacologyScale (+24 more)

### Community 24 - "Q: What should PharmaShift do after Phase 1?"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: What should PharmaShift do after Phase 1?, Source Nodes

## Knowledge Gaps
- **125 isolated node(s):** `another`, `later`, `open`, `scientific`, `trade` (+120 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **7 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `String` connect `ShiftLog` to `SwiftUI`, `Drug`, `String`, `Chapter`, `LibraryView`, `PracticeSessionView`, `ShiftView`, `Identifiable`, `SafetyFlag`, `DosingFrequency`, `HalfLifeBand`, `CaseIterable`, `Codable`, `ConfidenceLevel`, `DurationBand`, `OnsetBand`, `QuestionType`?**
  _High betweenness centrality (0.189) - this node is a cross-community bridge._
- **Why does `Drug` connect `ShiftLog` to `SwiftUI`, `Drug`, `String`, `Chapter`, `LibraryView`, `ShiftView`, `Identifiable`, `SafetyFlag`, `DosingFrequency`, `HalfLifeBand`, `CaseIterable`, `Codable`, `ConfidenceLevel`, `DurationBand`, `OnsetBand`, `QuestionType`?**
  _High betweenness centrality (0.126) - this node is a cross-community bridge._
- **Why does `DrugEditorView` connect `ReportEditorView` to `SwiftUI`, `Drug`, `ImageCapture.swift`, `ModelAndPersistenceTests`?**
  _High betweenness centrality (0.085) - this node is a cross-community bridge._
- **Are the 6 inferred relationships involving `Drug` (e.g. with `.grade()` and `PreviewData`) actually correct?**
  _`Drug` has 6 INFERRED edges - model-reasoned connections that need verification._
- **What connects `another`, `later`, `open` to the rest of the system?**
  _125 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `ShiftLog` be split into smaller, more focused modules?**
  _Cohesion score 0.0962962962962963 - nodes in this community are weakly interconnected._
- **Should `SwiftUI` be split into smaller, more focused modules?**
  _Cohesion score 0.07765151515151515 - nodes in this community are weakly interconnected._