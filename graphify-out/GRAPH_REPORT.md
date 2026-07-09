# Graph Report - pharmashift-main-release-fix  (2026-07-09)

## Corpus Check
- 41 files · ~35,230 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1024 nodes · 2346 edges · 72 communities (64 shown, 8 thin omitted)
- Extraction: 97% EXTRACTED · 3% INFERRED · 0% AMBIGUOUS · INFERRED: 64 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `6e689f95`
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
- [[_COMMUNITY_CropViewportState|CropViewportState]]
- [[_COMMUNITY_.apply|.apply]]
- [[_COMMUNITY_ImportedDurationBand|ImportedDurationBand]]
- [[_COMMUNITY_DrugImportServiceTests|DrugImportServiceTests]]
- [[_COMMUNITY_PracticeMode|PracticeMode]]
- [[_COMMUNITY_PracticeSessionView|PracticeSessionView]]
- [[_COMMUNITY_PharmaShiftUITests|PharmaShiftUITests]]
- [[_COMMUNITY_Observation|Observation]]
- [[_COMMUNITY_SwiftData|SwiftData]]
- [[_COMMUNITY_SafetyFlag|SafetyFlag]]
- [[_COMMUNITY_.matches|.matches]]
- [[_COMMUNITY_ImportedDosingFrequency|ImportedDosingFrequency]]
- [[_COMMUNITY_DrugMigrationPlan|DrugMigrationPlan]]
- [[_COMMUNITY_PracticeView|PracticeView]]
- [[_COMMUNITY_ImportedExcretionRoute|ImportedExcretionRoute]]
- [[_COMMUNITY_SaveAction|SaveAction]]
- [[_COMMUNITY_XCTestCase|XCTestCase]]
- [[_COMMUNITY_DrugDetailSheet|DrugDetailSheet]]
- [[_COMMUNITY_ReportView.swift|ReportView.swift]]
- [[_COMMUNITY_Double|Double]]
- [[_COMMUNITY_ReferenceWritableKeyPath|ReferenceWritableKeyPath]]
- [[_COMMUNITY_Color|Color]]
- [[_COMMUNITY_Data|Data]]
- [[_COMMUNITY_Void|Void]]

## God Nodes (most connected - your core abstractions)
1. `DrugEditorView` - 39 edges
2. `Chapter` - 38 edges
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
- `PharmaShiftApp` --calls--> `AppTheme`  [INFERRED]
  PharmaShift/App/PharmaShiftApp.swift → PharmaShift/App/AppTheme.swift
- `BackupImportPreview` --references--> `PharmaShiftBackup`  [EXTRACTED]
  PharmaShift/Features/Backup/BackupDataView.swift → PharmaShift/Services/BackupService.swift

## Import Cycles
- None detected.

## Communities (72 total, 8 thin omitted)

### Community 0 - "ShiftLog"
Cohesion: 0.25
Nodes (12): DailyActivity, Drug, EncounterNote, LearningProfile, ReviewLog, ShiftLog, Bool, Calendar (+4 more)

### Community 1 - "SwiftUI"
Cohesion: 0.20
Nodes (10): DrugCardAnchor, arabic, counseling, identity, mastery, notes, pharmacology, review (+2 more)

### Community 2 - "Drug"
Cohesion: 0.16
Nodes (10): AboutView, AppShell, MoreView, DrugDetailView, Color, Content, Drug, Set (+2 more)

### Community 3 - "ImageCapture.swift"
Cohesion: 0.16
Nodes (11): Coordinator, NativeCropScrollView, Bool, Int, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollView, UIScrollViewDelegate (+3 more)

### Community 4 - "String"
Cohesion: 0.08
Nodes (20): Drug, FocusAction, addDrug, finishShift, practiceWeak, reviewDue, FocusModeEngine, FocusRecommendation (+12 more)

### Community 5 - "Chapter"
Cohesion: 0.15
Nodes (12): DosingFrequency, asNeeded, fourTimesDaily, onceDaily, other, threeTimesDaily, twiceDaily, unknown (+4 more)

### Community 6 - "QuestionType"
Cohesion: 0.24
Nodes (5): PreviewData, ModelContainer, PhotosUI, SwiftUI, UIKit

### Community 7 - "LibraryView"
Cohesion: 0.29
Nodes (7): DrugEditorSection, basics, counseling, notes, pk, safety, uses

### Community 8 - "PracticeSessionView"
Cohesion: 0.22
Nodes (11): ImageIO, DrugImagePayload, DrugPhotoGalleryView, DrugPhotoView, DrugThumbnailView, ImageDraft, ImageEditorView, CGFloat (+3 more)

### Community 9 - "ShiftView"
Cohesion: 0.16
Nodes (16): ActiveShiftCard, ActiveShiftContent, EncounterEditorView, EndShiftView, ShiftPhase, ShiftPhaseRow, ShiftView, Binding (+8 more)

### Community 10 - "Identifiable"
Cohesion: 0.05
Nodes (37): CodingKey, CodingKeys, dailyActivities, drugs, encounters, learningProfiles, reports, reviews (+29 more)

### Community 11 - "SafetyFlag"
Cohesion: 0.08
Nodes (23): ImportedDurationBand, long, medium, short, unknown, ImportedOnsetBand, fast, moderate (+15 more)

### Community 12 - "DosingFrequency"
Cohesion: 0.45
Nodes (4): CGRect, CGSize, ImageCompressor, UIImage

### Community 13 - "HalfLifeBand"
Cohesion: 0.33
Nodes (6): HalfLifeBand, long, medium, short, unknown, veryLong

### Community 14 - "Build and install PharmaShift using only Windows"
Cohesion: 0.15
Nodes (10): Final Release Gate, PharmaShift Delivery Roadmap, Phase 2 - Visual Pharmacology and Safety, Phase 3 - Backup, Restore, and Export, Phase 4 - Drug Information Import, Phase 5 - Focus, Practice, and Motivation, PharmaShift, 1. Build the IPA on GitHub (+2 more)

### Community 15 - "CaseIterable"
Cohesion: 0.23
Nodes (7): Color, Flashcard, ImportSelection, FlowChips, ImportPreviewView, String, Severity

### Community 16 - "Codable"
Cohesion: 0.08
Nodes (32): BackupImportPreviewView, Int, BackupError, duplicateIdentifiers, invalidCounts, malformed, newerVersion, BackupRecordCounts (+24 more)

### Community 17 - "ConfidenceLevel"
Cohesion: 0.14
Nodes (14): DrugImportApplier, ImportSection, adverseEffects, arabicExplanation, counseling, identity, memorization, pharmacokinetics (+6 more)

### Community 18 - "DurationBand"
Cohesion: 0.14
Nodes (14): AppNavigation, Chapter, antibiotics, cardiovascular, dermatology, earNoseOropharynx, endocrine, eye (+6 more)

### Community 19 - "OnsetBand"
Cohesion: 0.31
Nodes (6): DeepSeekDrugImportService, DeepSeekKeyStore, DrugImportFormattingService, DrugSourceProviderFactory, MockDeepSeekDrugImportService, Data

### Community 21 - "ModelAndPersistenceTests"
Cohesion: 0.09
Nodes (19): CaptureView, FocusField, scientific, trade, unknownLabel, Binding, Bool, Data (+11 more)

### Community 22 - "QuestionType"
Cohesion: 0.09
Nodes (26): CaseIterable, ConfidenceLevel, mastered, medium, strong, weak, DurationBand, long (+18 more)

### Community 23 - "ReportEditorView"
Cohesion: 0.10
Nodes (26): ClosedRange, SafetySeverity, high, low, medium, unknown, DosingFrequencyMeter, EmptyStateView (+18 more)

### Community 24 - "Q: What should PharmaShift do after Phase 1?"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: What should PharmaShift do after Phase 1?, Source Nodes

### Community 25 - "Identifiable"
Cohesion: 0.43
Nodes (4): CGImagePropertyOrientation, OCRDrugCandidate, OCRService, UIImage

### Community 26 - "FocusField"
Cohesion: 0.35
Nodes (8): Identifiable, PracticeAnswer, PracticeSessionResult, ReviewRating, correct, partlyCorrect, wrong, String

### Community 27 - "AppTheme"
Cohesion: 0.23
Nodes (8): DailyMedProvider, DrugSearchResult, DrugSourceProvider, MockDrugSourceProvider, OpenFDALabelProvider, RxNormProvider, String, URLSession

### Community 28 - "Foundation"
Cohesion: 0.19
Nodes (22): Decodable, Encodable, Candidate, Choice, DailyMedSearchItem, DailyMedSearchPayload, DeepSeekRequest, DeepSeekResponse (+14 more)

### Community 29 - "ReportEditorView"
Cohesion: 0.29
Nodes (23): Codable, Equatable, Flashcard, ImportedAdverseEffects, ImportedArabicExplanation, ImportedCounseling, ImportedDrugInfo, ImportedIdentity (+15 more)

### Community 30 - "Path"
Cohesion: 0.12
Nodes (14): Data, DrugSearchResult, ImportedDrugInfo, DrugImportView, ImportSourceSearchView, Drug, DrugImagePayload, DrugImportFormattingService (+6 more)

### Community 31 - "ModelAndPersistenceTests"
Cohesion: 0.10
Nodes (24): Chapter, DosingFrequency, Double, DurationBand, ExcretionRoute, HalfLifeBand, ImageAcquisitionSource, OnsetBand (+16 more)

### Community 32 - "Design"
Cohesion: 0.17
Nodes (11): Accessibility floor, Aesthetic direction, Brand voice, Color tokens, Core component inventory, Design, Dials, Last updated (+3 more)

### Community 33 - "PharmacologyScale"
Cohesion: 0.10
Nodes (16): Encoder, NSObject, DrugImportValidator, NameKind, brand, generic, PromptBuilder, SPLParser (+8 more)

### Community 34 - ".reportSection"
Cohesion: 0.24
Nodes (7): Content, ImportSection, ConfirmDrugIdentityView, ImportMemorizationChallengeView, Binding, Bool, Void

### Community 35 - "LibraryView"
Cohesion: 0.27
Nodes (7): DrugRow, LibraryFilterView, LibraryView, Bool, Drug, Int, String

### Community 36 - "Components.swift"
Cohesion: 0.19
Nodes (7): Hashable, PracticeCase, StarterContent, Drug, Int, ModelContext, String

### Community 37 - "Drug"
Cohesion: 0.18
Nodes (8): Drug, Bool, Data, Date, Int, String, UUID, ModelAndPersistenceTests

### Community 38 - "SafetyRadar"
Cohesion: 0.18
Nodes (11): LocalizedError, DrugImportError, aiReturnedEmpty, invalidAIJSON, invalidQuery, invalidResponse, missingDeepSeekKey, parsingFailed (+3 more)

### Community 39 - "DrugEditorSection"
Cohesion: 0.29
Nodes (5): Any, Context, CameraPicker, UIImagePickerController, UIViewControllerRepresentable

### Community 40 - "DrugSearchResult"
Cohesion: 0.06
Nodes (29): CoreTransferable, Error, FileDocument, FileWrapper, BackupDataView, BackupExportKind, complete, csv (+21 more)

### Community 41 - "AppTheme"
Cohesion: 0.22
Nodes (8): HomeView, Color, Double, Drug, Int, String, SystemDashboardCard, SystemDashboardMetrics

### Community 42 - "Foundation"
Cohesion: 0.33
Nodes (3): LearningSettingsView, Binding, Bool

### Community 43 - "AppTab"
Cohesion: 0.33
Nodes (6): AppTab, capture, home, library, more, practice

### Community 44 - ".containsObviousIdentifier"
Cohesion: 0.20
Nodes (4): Foundation, PrivacyValidator, Bool, String

### Community 45 - "LearningSettingsView"
Cohesion: 0.27
Nodes (7): ReportView, Drug, TrainingReport, ReportBuilder, Calendar, Drug, String

### Community 46 - "ImportSection"
Cohesion: 0.18
Nodes (9): Int, OCRDrugCandidate, ImportFromPhotoView, ImportStage, challenge, confirm, photo, preview (+1 more)

### Community 48 - "CropViewportState"
Cohesion: 0.25
Nodes (6): CropGrid, CropViewportState, CGPoint, Path, Shape, UIEdgeInsets

### Community 49 - ".apply"
Cohesion: 0.23
Nodes (8): ReviewScheduler, Bool, Calendar, Date, Drug, Int, String, ReviewSchedulerTests

### Community 50 - "ImportedDurationBand"
Cohesion: 0.15
Nodes (12): PracticeInteraction, multipleChoice, recall, QuestionType, casePractice, counseling, drugClass, scientificName (+4 more)

### Community 51 - "DrugImportServiceTests"
Cohesion: 0.27
Nodes (3): DrugImportServiceTests, Bool, String

### Community 52 - "PracticeMode"
Cohesion: 0.17
Nodes (12): PracticeMode, casePractice, classExamples, counseling, drugUse, drugWarning, dueReview, imageQuiz (+4 more)

### Community 53 - "PracticeSessionView"
Cohesion: 0.53
Nodes (3): PracticeSessionView, String, PracticeQuestion

### Community 54 - "PharmaShiftUITests"
Cohesion: 0.36
Nodes (3): PharmaShiftUITests, String, XCUIApplication

### Community 55 - "Observation"
Cohesion: 0.25
Nodes (6): App, Observation, AppTheme, Color, PharmaShiftApp, Scene

### Community 56 - "SwiftData"
Cohesion: 0.42
Nodes (3): PharmaShift, SwiftData, XCTest

### Community 57 - "SafetyFlag"
Cohesion: 0.25
Nodes (8): SafetyFlag, anticoagulant, children, controlledDrug, corticosteroid, insulin, pregnancy, severeSymptoms

### Community 58 - ".matches"
Cohesion: 0.32
Nodes (5): DrugFilter, Bool, Calendar, Date, Drug

### Community 59 - "ImportedDosingFrequency"
Cohesion: 0.25
Nodes (8): ImportedDosingFrequency, fourTimesDaily, onceDaily, other, PRN, threeTimesDaily, twiceDaily, unknown

### Community 60 - "DrugMigrationPlan"
Cohesion: 0.33
Nodes (7): MigrationStage, PersistentModel, CurrentDrugSchema, DrugMigrationPlan, Phase1DrugSchema, SchemaMigrationPlan, VersionedSchema

### Community 61 - "PracticeView"
Cohesion: 0.29
Nodes (3): PracticeView, Drug, Int

### Community 62 - "ImportedExcretionRoute"
Cohesion: 0.33
Nodes (6): ImportedExcretionRoute, hepatic, mixed, other, renal, unknown

### Community 63 - "SaveAction"
Cohesion: 0.50
Nodes (4): SaveAction, another, later, open

### Community 64 - "XCTestCase"
Cohesion: 0.50
Nodes (3): MigrationFixtureTests, ReportBuilderTests, XCTestCase

### Community 65 - "DrugDetailSheet"
Cohesion: 0.67
Nodes (3): DrugDetailSheet, editor, review

## Knowledge Gaps
- **243 isolated node(s):** `basics`, `uses`, `pk`, `safety`, `counseling` (+238 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **8 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Chapter` connect `DurationBand` to `ShiftLog`, `String`, `Components.swift`, `AppTheme`, `ShiftView`, `Codable`, `ReportEditorView`, `PracticeSessionView`, `ModelAndPersistenceTests`, `Observation`, `QuestionType`, `FocusField`, `PracticeView`?**
  _High betweenness centrality (0.080) - this node is a cross-community bridge._
- **Why does `DrugImportView` connect `Path` to `.reportSection`, `Drug`, `ImportSection`, `CaseIterable`?**
  _High betweenness centrality (0.060) - this node is a cross-community bridge._
- **Why does `SwiftData` connect `SwiftData` to `Drug`, `LibraryView`, `ReportView.swift`, `String`, `QuestionType`, `Components.swift`, `DrugSearchResult`, `ShiftView`, `CaseIterable`, `Codable`, `QuestionType`, `Observation`?**
  _High betweenness centrality (0.051) - this node is a cross-community bridge._
- **What connects `basics`, `uses`, `pk` to the rest of the system?**
  _243 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `String` be split into smaller, more focused modules?**
  _Cohesion score 0.08392603129445235 - nodes in this community are weakly interconnected._
- **Should `Identifiable` be split into smaller, more focused modules?**
  _Cohesion score 0.05405405405405406 - nodes in this community are weakly interconnected._
- **Should `SafetyFlag` be split into smaller, more focused modules?**
  _Cohesion score 0.08333333333333333 - nodes in this community are weakly interconnected._