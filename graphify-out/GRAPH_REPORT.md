# Graph Report - pharmashift  (2026-07-09)

## Corpus Check
- 41 files · ~35,154 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 987 nodes · 2343 edges · 49 communities (46 shown, 3 thin omitted)
- Extraction: 97% EXTRACTED · 3% INFERRED · 0% AMBIGUOUS · INFERRED: 67 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `8897ff74`
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
- [[_COMMUNITY_ImportSection|ImportSection]]
- [[_COMMUNITY_MigrationFixtureTests.swift|MigrationFixtureTests.swift]]
- [[_COMMUNITY_PracticeView|PracticeView]]

## God Nodes (most connected - your core abstractions)
1. `DrugEditorView` - 39 edges
2. `Chapter` - 39 edges
3. `DrugImportView` - 32 edges
4. `CodingKeys` - 30 edges
5. `ShiftLog` - 28 edges
6. `Drug` - 26 edges
7. `Drug` - 26 edges
8. `PracticeMode` - 24 edges
9. `Coordinator` - 22 edges
10. `SwiftData` - 21 edges

## Surprising Connections (you probably didn't know these)
- `PreviewData` --calls--> `ShiftLog`  [INFERRED]
  PharmaShift/Shared/PreviewSupport.swift → PharmaShift/Models/Models.swift
- `AppNavigation` --references--> `PracticeMode`  [EXTRACTED]
  PharmaShift/App/AppShell.swift → PharmaShift/Services/PracticeEngine.swift
- `LearningSettingsView` --references--> `LearningProfile`  [EXTRACTED]
  PharmaShift/App/AppShell.swift → PharmaShift/Models/Models.swift
- `CaptureView` --references--> `Chapter`  [EXTRACTED]
  PharmaShift/Features/Capture/CaptureView.swift → PharmaShift/Models/Models.swift
- `CaptureView` --references--> `ImageAcquisitionSource`  [EXTRACTED]
  PharmaShift/Features/Capture/CaptureView.swift → PharmaShift/Shared/ImageCapture.swift

## Import Cycles
- None detected.

## Communities (49 total, 3 thin omitted)

### Community 0 - "ShiftLog"
Cohesion: 0.05
Nodes (64): Identifiable, PracticeSessionView, String, ReportView, Drug, DailyActivity, Drug, EncounterNote (+56 more)

### Community 1 - "SwiftUI"
Cohesion: 0.20
Nodes (10): DrugCardAnchor, arabic, counseling, identity, mastery, notes, pharmacology, review (+2 more)

### Community 2 - "Drug"
Cohesion: 0.18
Nodes (10): DrugDetailSheet, editor, review, DrugDetailView, Color, Content, Drug, Set (+2 more)

### Community 3 - "ImageCapture.swift"
Cohesion: 0.07
Nodes (37): Any, CGRect, CGSize, Context, ImageIO, CameraPicker, Coordinator, CropGrid (+29 more)

### Community 4 - "String"
Cohesion: 0.08
Nodes (21): Drug, FocusAction, addDrug, finishShift, practiceWeak, reviewDue, FocusModeEngine, FocusRecommendation (+13 more)

### Community 5 - "Chapter"
Cohesion: 0.22
Nodes (8): HomeView, Color, Double, Drug, Int, String, SystemDashboardCard, SystemDashboardMetrics

### Community 6 - "QuestionType"
Cohesion: 0.20
Nodes (9): MigrationStage, PersistentModel, PharmaShift, CurrentDrugSchema, DrugMigrationPlan, Phase1DrugSchema, SchemaMigrationPlan, VersionedSchema (+1 more)

### Community 7 - "LibraryView"
Cohesion: 0.26
Nodes (7): DrugEditorView, Binding, Bool, Double, Drug, PhotosPickerItem, ReferenceWritableKeyPath

### Community 8 - "PracticeSessionView"
Cohesion: 0.22
Nodes (8): Double, WeaknessRadarView, PreviewData, ModelContainer, PhotosUI, SwiftData, SwiftUI, UIKit

### Community 9 - "ShiftView"
Cohesion: 0.16
Nodes (16): ActiveShiftCard, ActiveShiftContent, EncounterEditorView, EndShiftView, ShiftPhase, ShiftPhaseRow, ShiftView, Binding (+8 more)

### Community 10 - "Identifiable"
Cohesion: 0.05
Nodes (37): CodingKey, CodingKeys, dailyActivities, drugs, encounters, learningProfiles, reports, reviews (+29 more)

### Community 11 - "SafetyFlag"
Cohesion: 0.08
Nodes (24): Encoder, ImportedDurationBand, long, medium, short, unknown, ImportedExcretionRoute, hepatic (+16 more)

### Community 12 - "DosingFrequency"
Cohesion: 0.18
Nodes (4): MigrationFixtureTests, ReportBuilderTests, PharmaShiftUITests, XCTestCase

### Community 13 - "HalfLifeBand"
Cohesion: 0.13
Nodes (15): CaseIterable, ConfidenceLevel, mastered, medium, strong, weak, OnsetBand, fast (+7 more)

### Community 14 - "Build and install PharmaShift using only Windows"
Cohesion: 0.15
Nodes (10): Final Release Gate, PharmaShift Delivery Roadmap, Phase 2 - Visual Pharmacology and Safety, Phase 3 - Backup, Restore, and Export, Phase 4 - Drug Information Import, Phase 5 - Focus, Practice, and Motivation, PharmaShift, 1. Build the IPA on GitHub (+2 more)

### Community 15 - "CaseIterable"
Cohesion: 0.07
Nodes (33): Int, AboutView, AppShell, LearningSettingsView, MoreView, Binding, Bool, report (+25 more)

### Community 16 - "Codable"
Cohesion: 0.05
Nodes (48): Error, FileDocument, FileWrapper, BackupDataView, BackupExportKind, complete, csv, lightweight (+40 more)

### Community 17 - "ConfidenceLevel"
Cohesion: 0.27
Nodes (7): DrugRow, LibraryFilterView, LibraryView, Bool, Drug, Int, String

### Community 18 - "DurationBand"
Cohesion: 0.14
Nodes (14): AppNavigation, Chapter, antibiotics, cardiovascular, dermatology, earNoseOropharynx, endocrine, eye (+6 more)

### Community 19 - "OnsetBand"
Cohesion: 0.29
Nodes (7): DrugEditorSection, basics, counseling, notes, pk, safety, uses

### Community 21 - "ModelAndPersistenceTests"
Cohesion: 0.08
Nodes (20): CaptureView, FocusField, scientific, trade, unknownLabel, SaveAction, another, later (+12 more)

### Community 22 - "QuestionType"
Cohesion: 0.26
Nodes (8): ReviewScheduler, Bool, Calendar, Date, Drug, Int, String, ReviewSchedulerTests

### Community 23 - "ReportEditorView"
Cohesion: 0.06
Nodes (37): ClosedRange, DosingFrequency, asNeeded, fourTimesDaily, onceDaily, other, threeTimesDaily, twiceDaily (+29 more)

### Community 24 - "Q: What should PharmaShift do after Phase 1?"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: What should PharmaShift do after Phase 1?, Source Nodes

### Community 25 - "Identifiable"
Cohesion: 0.30
Nodes (3): DrugImportServiceTests, Bool, String

### Community 26 - "FocusField"
Cohesion: 0.33
Nodes (6): HalfLifeBand, long, medium, short, unknown, veryLong

### Community 27 - "AppTheme"
Cohesion: 0.18
Nodes (9): DailyMedProvider, DrugSearchResult, DrugSourceProvider, DrugSourceProviderFactory, MockDrugSourceProvider, OpenFDALabelProvider, RxNormProvider, URLResponse (+1 more)

### Community 28 - "Foundation"
Cohesion: 0.15
Nodes (26): Decodable, Encodable, Candidate, Choice, DailyMedSearchItem, DailyMedSearchPayload, DeepSeekRequest, DeepSeekResponse (+18 more)

### Community 29 - "ReportEditorView"
Cohesion: 0.29
Nodes (23): Codable, Equatable, Flashcard, ImportedAdverseEffects, ImportedArabicExplanation, ImportedCounseling, ImportedDrugInfo, ImportedIdentity (+15 more)

### Community 30 - "Path"
Cohesion: 0.12
Nodes (13): DrugImportView, Data, Drug, PhotosPickerItem, DeepSeekDrugImportService, DeepSeekKeyStore, DrugImportApplier, DrugImportFormattingService (+5 more)

### Community 31 - "ModelAndPersistenceTests"
Cohesion: 0.47
Nodes (3): CGImagePropertyOrientation, OCRService, UIImage

### Community 32 - "Design"
Cohesion: 0.17
Nodes (11): Accessibility floor, Aesthetic direction, Brand voice, Color tokens, Core component inventory, Design, Dials, Last updated (+3 more)

### Community 33 - "PharmacologyScale"
Cohesion: 0.17
Nodes (12): NSObject, SPLParser, SPLXMLDelegate, Bool, Int, String, TrustedDrugSourcePacket, TrustedDrugSourcePacketExtractor (+4 more)

### Community 34 - ".reportSection"
Cohesion: 0.33
Nodes (6): PKBand, long, medium, short, unknown, veryLong

### Community 35 - "LibraryView"
Cohesion: 0.21
Nodes (7): Hashable, PracticeCase, StarterContent, Drug, Int, ModelContext, String

### Community 36 - "Components.swift"
Cohesion: 0.17
Nodes (12): PracticeMode, casePractice, classExamples, counseling, drugUse, drugWarning, dueReview, imageQuiz (+4 more)

### Community 37 - "Drug"
Cohesion: 0.15
Nodes (8): Drug, Bool, Data, Date, Int, String, UUID, ModelAndPersistenceTests

### Community 38 - "SafetyRadar"
Cohesion: 0.18
Nodes (11): LocalizedError, DrugImportError, aiReturnedEmpty, invalidAIJSON, invalidQuery, invalidResponse, missingDeepSeekKey, parsingFailed (+3 more)

### Community 39 - "DrugEditorSection"
Cohesion: 0.40
Nodes (5): DurationBand, long, medium, short, unknown

### Community 40 - "DrugSearchResult"
Cohesion: 0.40
Nodes (5): ExcretionRoute, hepatic, mixed, renal, unknown

### Community 41 - "AppTheme"
Cohesion: 0.22
Nodes (6): App, Observation, AppTheme, Color, PharmaShiftApp, Scene

### Community 42 - "Foundation"
Cohesion: 0.40
Nodes (5): SafetySeverity, high, low, medium, unknown

### Community 43 - "AppTab"
Cohesion: 0.33
Nodes (6): AppTab, capture, home, library, more, practice

### Community 44 - ".containsObviousIdentifier"
Cohesion: 0.10
Nodes (15): CoreTransferable, Foundation, DrugFilter, Bool, Calendar, Date, Drug, PrivacyValidator (+7 more)

### Community 45 - "LearningSettingsView"
Cohesion: 0.67
Nodes (3): ImageAcquisitionSource, camera, library

### Community 53 - "PracticeView"
Cohesion: 0.29
Nodes (3): PracticeView, Drug, Int

## Knowledge Gaps
- **243 isolated node(s):** `home`, `library`, `capture`, `practice`, `more` (+238 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **3 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Chapter` connect `DurationBand` to `ShiftLog`, `Drug`, `LibraryView`, `String`, `Chapter`, `LibraryView`, `AppTheme`, `ShiftView`, `HalfLifeBand`, `ModelAndPersistenceTests`, `PracticeView`, `ReportEditorView`?**
  _High betweenness centrality (0.074) - this node is a cross-community bridge._
- **Why does `DrugEditorView` connect `LibraryView` to `Drug`, `ImageCapture.swift`, `DrugEditorSection`, `PracticeSessionView`, `DrugSearchResult`, `Foundation`, `HalfLifeBand`, `ImportSection`, `LearningSettingsView`, `CaseIterable`, `DurationBand`, `OnsetBand`, `ModelAndPersistenceTests`, `ReportEditorView`, `FocusField`, `AppTheme`, `Path`?**
  _High betweenness centrality (0.059) - this node is a cross-community bridge._
- **Why does `CodingKeys` connect `Identifiable` to `PharmacologyScale`, `Foundation`?**
  _High betweenness centrality (0.053) - this node is a cross-community bridge._
- **What connects `home`, `library`, `capture` to the rest of the system?**
  _243 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `ShiftLog` be split into smaller, more focused modules?**
  _Cohesion score 0.052192982456140354 - nodes in this community are weakly interconnected._
- **Should `ImageCapture.swift` be split into smaller, more focused modules?**
  _Cohesion score 0.06594594594594595 - nodes in this community are weakly interconnected._
- **Should `String` be split into smaller, more focused modules?**
  _Cohesion score 0.08097165991902834 - nodes in this community are weakly interconnected._