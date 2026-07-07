# Graph Report - pharmashift  (2026-07-07)

## Corpus Check
- 41 files · ~28,914 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 815 nodes · 1867 edges · 46 communities (43 shown, 3 thin omitted)
- Extraction: 95% EXTRACTED · 5% INFERRED · 0% AMBIGUOUS · INFERRED: 87 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `01391734`
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
- [[_COMMUNITY_ModelAndPersistenceTests|ModelAndPersistenceTests]]
- [[_COMMUNITY_Design|Design]]
- [[_COMMUNITY_PharmacologyScale|PharmacologyScale]]
- [[_COMMUNITY_.reportSection|.reportSection]]
- [[_COMMUNITY_LibraryView|LibraryView]]
- [[_COMMUNITY_Components.swift|Components.swift]]
- [[_COMMUNITY_Drug|Drug]]
- [[_COMMUNITY_SafetyRadar|SafetyRadar]]
- [[_COMMUNITY_DrugEditorSection|DrugEditorSection]]
- [[_COMMUNITY_DrugSearchResult|DrugSearchResult]]
- [[_COMMUNITY_AppTheme|AppTheme]]
- [[_COMMUNITY_Foundation|Foundation]]
- [[_COMMUNITY_AppTab|AppTab]]
- [[_COMMUNITY_.containsObviousIdentifier|.containsObviousIdentifier]]
- [[_COMMUNITY_LearningSettingsView|LearningSettingsView]]

## God Nodes (most connected - your core abstractions)
1. `Chapter` - 39 edges
2. `DrugEditorView` - 36 edges
3. `ImportField` - 31 edges
4. `ShiftLog` - 28 edges
5. `Drug` - 27 edges
6. `Drug` - 26 edges
7. `PracticeMode` - 24 edges
8. `Coordinator` - 22 edges
9. `SwiftData` - 20 edges
10. `PracticeSessionView` - 20 edges

## Surprising Connections (you probably didn't know these)
- `LearningSettingsView` --references--> `LearningProfile`  [EXTRACTED]
  PharmaShift/App/AppShell.swift → PharmaShift/Models/Models.swift
- `PharmaShiftApp` --calls--> `AppTheme`  [INFERRED]
  PharmaShift/App/PharmaShiftApp.swift → PharmaShift/App/AppTheme.swift
- `BackupImportPreview` --references--> `PharmaShiftBackup`  [EXTRACTED]
  PharmaShift/Features/Backup/BackupDataView.swift → PharmaShift/Services/BackupService.swift
- `CaptureView` --references--> `Chapter`  [EXTRACTED]
  PharmaShift/Features/Capture/CaptureView.swift → PharmaShift/Models/Models.swift
- `CaptureView` --references--> `ImageDraft`  [EXTRACTED]
  PharmaShift/Features/Capture/CaptureView.swift → PharmaShift/Shared/ImageCapture.swift

## Import Cycles
- None detected.

## Communities (46 total, 3 thin omitted)

### Community 0 - "ShiftLog"
Cohesion: 0.06
Nodes (55): Equatable, PracticeSessionView, String, ReportView, Drug, DailyActivity, Drug, EncounterNote (+47 more)

### Community 1 - "SwiftUI"
Cohesion: 0.20
Nodes (10): DrugCardAnchor, arabic, counseling, identity, mastery, notes, pharmacology, review (+2 more)

### Community 2 - "Drug"
Cohesion: 0.14
Nodes (11): Content, AboutView, AppShell, MoreView, Int, DrugDetailView, Color, Drug (+3 more)

### Community 3 - "ImageCapture.swift"
Cohesion: 0.06
Nodes (41): Any, CGRect, CGSize, Context, ImageIO, LocalizedError, NSObject, CameraPicker (+33 more)

### Community 4 - "String"
Cohesion: 0.10
Nodes (15): Array, FocusModeEngine, LearningProgressService, PracticeGenerator, Bool, Calendar, Date, Drug (+7 more)

### Community 5 - "Chapter"
Cohesion: 0.05
Nodes (37): AppNavigation, HomeView, Color, Double, Drug, Int, String, SystemDashboardCard (+29 more)

### Community 6 - "QuestionType"
Cohesion: 0.08
Nodes (19): MigrationStage, PersistentModel, PharmaShift, Double, WeaknessRadarView, CurrentDrugSchema, DrugMigrationPlan, MigrationFixtureTests (+11 more)

### Community 7 - "LibraryView"
Cohesion: 0.29
Nodes (6): CoreTransferable, ReportFile, String, Transferable, TransferRepresentation, UniformTypeIdentifiers

### Community 8 - "PracticeSessionView"
Cohesion: 0.50
Nodes (4): Identifiable, DrugDetailSheet, editor, review

### Community 9 - "ShiftView"
Cohesion: 0.16
Nodes (16): ActiveShiftCard, ActiveShiftContent, EncounterEditorView, EndShiftView, ShiftPhase, ShiftPhaseRow, ShiftView, Binding (+8 more)

### Community 10 - "Identifiable"
Cohesion: 0.40
Nodes (5): ExcretionRoute, hepatic, mixed, renal, unknown

### Community 11 - "SafetyFlag"
Cohesion: 0.12
Nodes (17): Error, FileDocument, FileWrapper, BackupDataView, BackupExportKind, complete, csv, lightweight (+9 more)

### Community 12 - "DosingFrequency"
Cohesion: 0.29
Nodes (7): DosingFrequency, asNeeded, fourTimesDaily, onceDaily, threeTimesDaily, twiceDaily, unknown

### Community 13 - "HalfLifeBand"
Cohesion: 0.33
Nodes (6): HalfLifeBand, long, medium, short, unknown, veryLong

### Community 14 - "Build and install PharmaShift using only Windows"
Cohesion: 0.15
Nodes (10): Final Release Gate, PharmaShift Delivery Roadmap, Phase 2 - Visual Pharmacology and Safety, Phase 3 - Backup, Restore, and Export, Phase 4 - Drug Information Import, Phase 5 - Focus, Practice, and Motivation, PharmaShift, 1. Build the IPA on GitHub (+2 more)

### Community 15 - "CaseIterable"
Cohesion: 0.40
Nodes (5): CaseIterable, ProdrugStatus, no, unknown, yes

### Community 16 - "Codable"
Cohesion: 0.07
Nodes (40): Codable, Decoder, BackupImportPreviewView, BackupError, duplicateIdentifiers, invalidCounts, malformed, newerVersion (+32 more)

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
Cohesion: 0.08
Nodes (22): CaptureView, FocusField, scientific, trade, unknownLabel, SaveAction, another, later (+14 more)

### Community 22 - "QuestionType"
Cohesion: 0.26
Nodes (8): ReviewScheduler, Bool, Calendar, Date, Drug, Int, String, ReviewSchedulerTests

### Community 23 - "ReportEditorView"
Cohesion: 0.08
Nodes (28): Hashable, DrugEditorView, Binding, Bool, Double, Drug, PhotosPickerItem, ReferenceWritableKeyPath (+20 more)

### Community 24 - "Q: What should PharmaShift do after Phase 1?"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: What should PharmaShift do after Phase 1?, Source Nodes

### Community 25 - "Identifiable"
Cohesion: 0.10
Nodes (20): ImportField, commonSideEffects, contraindications, counselingSentence, dosageForms, durationHours, halfLifeHours, halfLifeText (+12 more)

### Community 26 - "FocusField"
Cohesion: 0.27
Nodes (8): ConservativeNumericExtractor, SPLParser, SPLXMLDelegate, Data, Double, String, XMLParser, XMLParserDelegate

### Community 27 - "AppTheme"
Cohesion: 0.17
Nodes (10): CodingKey, DateFormatter, CodingKeys, publishedDate, setid, title, DailyMedProvider, Bool (+2 more)

### Community 28 - "Foundation"
Cohesion: 0.14
Nodes (15): Decodable, DailyMedSearchPayload, DrugImportError, invalidQuery, invalidResponse, parsingFailed, DrugInfoProviderFactory, Item (+7 more)

### Community 29 - "ReportEditorView"
Cohesion: 0.22
Nodes (6): DrugImportApplier, ImportedDrugInfo, Date, Drug, URL, DrugImportServiceTests

### Community 30 - "Path"
Cohesion: 0.22
Nodes (9): DrugImportView, Binding, Bool, Drug, String, DrugInfoProvider, ImportSelection, Set (+1 more)

### Community 31 - "ModelAndPersistenceTests"
Cohesion: 0.19
Nodes (6): DrugFilter, Bool, Calendar, Date, Drug, ModelAndPersistenceTests

### Community 32 - "Design"
Cohesion: 0.17
Nodes (11): Accessibility floor, Aesthetic direction, Brand voice, Color tokens, Core component inventory, Design, Dials, Last updated (+3 more)

### Community 33 - "PharmacologyScale"
Cohesion: 0.27
Nodes (7): ClosedRange, PharmacologyMeter, PharmacologyScale, duration, halfLife, onset, Double

### Community 34 - ".reportSection"
Cohesion: 0.27
Nodes (6): report, ReportEditorView, Binding, Date, ReferenceWritableKeyPath, String

### Community 35 - "LibraryView"
Cohesion: 0.25
Nodes (7): DrugRow, LibraryFilterView, LibraryView, Bool, Drug, Int, String

### Community 36 - "Components.swift"
Cohesion: 0.31
Nodes (8): DosingFrequencyMeter, EmptyStateView, LabeledValue, MasteryBadge, MetricCard, PharmacologyStatusCard, Drug, String

### Community 37 - "Drug"
Cohesion: 0.33
Nodes (7): Drug, Bool, Data, Date, Int, String, UUID

### Community 38 - "SafetyRadar"
Cohesion: 0.43
Nodes (5): SafetyRadar, CGFloat, CGPoint, Int, Path

### Community 39 - "DrugEditorSection"
Cohesion: 0.29
Nodes (7): DrugEditorSection, basics, counseling, notes, pk, safety, uses

### Community 41 - "AppTheme"
Cohesion: 0.40
Nodes (5): App, AppTheme, Color, PharmaShiftApp, Scene

### Community 43 - "AppTab"
Cohesion: 0.33
Nodes (6): AppTab, capture, home, library, more, practice

### Community 44 - ".containsObviousIdentifier"
Cohesion: 0.33
Nodes (3): PrivacyValidator, Bool, String

### Community 45 - "LearningSettingsView"
Cohesion: 0.67
Nodes (3): LearningSettingsView, Binding, Bool

## Knowledge Gaps
- **189 isolated node(s):** `home`, `library`, `capture`, `practice`, `more` (+184 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **3 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Chapter` connect `Chapter` to `ShiftLog`, `String`, `PracticeSessionView`, `AppTheme`, `ShiftView`, `CaseIterable`, `Codable`, `ModelAndPersistenceTests`, `ReportEditorView`?**
  _High betweenness centrality (0.084) - this node is a cross-community bridge._
- **Why does `ImportField` connect `Identifiable` to `PracticeSessionView`, `CaseIterable`, `Codable`, `FocusField`, `AppTheme`, `Foundation`, `ReportEditorView`, `Path`?**
  _High betweenness centrality (0.075) - this node is a cross-community bridge._
- **Why does `SwiftData` connect `QuestionType` to `ShiftLog`, `Drug`, `String`, `ShiftView`, `SafetyFlag`, `Codable`, `ReportEditorView`?**
  _High betweenness centrality (0.058) - this node is a cross-community bridge._
- **What connects `home`, `library`, `capture` to the rest of the system?**
  _189 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `ShiftLog` be split into smaller, more focused modules?**
  _Cohesion score 0.06308473670141673 - nodes in this community are weakly interconnected._
- **Should `Drug` be split into smaller, more focused modules?**
  _Cohesion score 0.14285714285714285 - nodes in this community are weakly interconnected._
- **Should `ImageCapture.swift` be split into smaller, more focused modules?**
  _Cohesion score 0.062456140350877196 - nodes in this community are weakly interconnected._