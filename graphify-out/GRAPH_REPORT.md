# Graph Report - pharmashift-main-release-fix  (2026-07-09)

## Corpus Check
- 41 files · ~35,256 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1008 nodes · 2352 edges · 68 communities (56 shown, 12 thin omitted)
- Extraction: 97% EXTRACTED · 3% INFERRED · 0% AMBIGUOUS · INFERRED: 74 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `47642ef8`
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
- [[_COMMUNITY_CameraPicker|CameraPicker]]
- [[_COMMUNITY_DrugCardAnchor|DrugCardAnchor]]
- [[_COMMUNITY_ShiftView|ShiftView]]
- [[_COMMUNITY_Identifiable|Identifiable]]
- [[_COMMUNITY_SafetyFlag|SafetyFlag]]
- [[_COMMUNITY_LibraryView|LibraryView]]
- [[_COMMUNITY_Foundation|Foundation]]
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
- [[_COMMUNITY_DrugEditorSection|DrugEditorSection]]
- [[_COMMUNITY_Design|Design]]
- [[_COMMUNITY_PharmacologyScale|PharmacologyScale]]
- [[_COMMUNITY_.reportSection|.reportSection]]
- [[_COMMUNITY_.importIfNeeded|.importIfNeeded]]
- [[_COMMUNITY_Identifiable|Identifiable]]
- [[_COMMUNITY_Drug|Drug]]
- [[_COMMUNITY_SafetyRadar|SafetyRadar]]
- [[_COMMUNITY_BackupImportPreviewView|BackupImportPreviewView]]
- [[_COMMUNITY_DrugSearchResult|DrugSearchResult]]
- [[_COMMUNITY_AppTheme|AppTheme]]
- [[_COMMUNITY_Foundation|Foundation]]
- [[_COMMUNITY_AppTab|AppTab]]
- [[_COMMUNITY_.containsObviousIdentifier|.containsObviousIdentifier]]
- [[_COMMUNITY_LearningSettingsView|LearningSettingsView]]
- [[_COMMUNITY_ImportSection|ImportSection]]
- [[_COMMUNITY_CaseIterable|CaseIterable]]
- [[_COMMUNITY_DurationBand|DurationBand]]
- [[_COMMUNITY_.apply|.apply]]
- [[_COMMUNITY_ImportedDurationBand|ImportedDurationBand]]
- [[_COMMUNITY_DrugImportServiceTests|DrugImportServiceTests]]
- [[_COMMUNITY_PracticeMode|PracticeMode]]
- [[_COMMUNITY_PracticeSessionView|PracticeSessionView]]
- [[_COMMUNITY_PharmaShiftUITests|PharmaShiftUITests]]
- [[_COMMUNITY_FocusField|FocusField]]
- [[_COMMUNITY_SwiftData|SwiftData]]
- [[_COMMUNITY_Binding|Binding]]
- [[_COMMUNITY_.matches|.matches]]
- [[_COMMUNITY_ImportedDosingFrequency|ImportedDosingFrequency]]
- [[_COMMUNITY_DrugMigrationPlan|DrugMigrationPlan]]
- [[_COMMUNITY_PracticeView|PracticeView]]
- [[_COMMUNITY_Content|Content]]
- [[_COMMUNITY_Data|Data]]
- [[_COMMUNITY_Drug|Drug]]
- [[_COMMUNITY_PhotosPickerItem|PhotosPickerItem]]
- [[_COMMUNITY_String|String]]
- [[_COMMUNITY_Void|Void]]

## God Nodes (most connected - your core abstractions)
1. `DrugEditorView` - 39 edges
2. `Chapter` - 39 edges
3. `DrugImportView` - 33 edges
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
- `LearningSettingsView` --references--> `LearningProfile`  [EXTRACTED]
  PharmaShift/App/AppShell.swift → PharmaShift/Models/Models.swift
- `PharmaShiftApp` --calls--> `AppTheme`  [INFERRED]
  PharmaShift/App/PharmaShiftApp.swift → PharmaShift/App/AppTheme.swift
- `BackupImportPreview` --references--> `PharmaShiftBackup`  [EXTRACTED]
  PharmaShift/Features/Backup/BackupDataView.swift → PharmaShift/Services/BackupService.swift
- `BackupImportPreviewView` --references--> `BackupRestoreSummary`  [EXTRACTED]
  PharmaShift/Features/Backup/BackupDataView.swift → PharmaShift/Services/BackupService.swift

## Import Cycles
- None detected.

## Communities (68 total, 12 thin omitted)

### Community 0 - "ShiftLog"
Cohesion: 0.07
Nodes (45): PracticeSessionView, String, ReportView, Drug, DailyActivity, Drug, EncounterNote, LearningProfile (+37 more)

### Community 1 - "SwiftUI"
Cohesion: 0.20
Nodes (11): ImageIO, DrugImagePayload, DrugPhotoGalleryView, DrugPhotoView, DrugThumbnailView, ImageDraft, ImageEditorView, CGFloat (+3 more)

### Community 2 - "Drug"
Cohesion: 0.17
Nodes (10): DrugDetailSheet, editor, review, DrugDetailView, Color, Content, Drug, Set (+2 more)

### Community 3 - "ImageCapture.swift"
Cohesion: 0.15
Nodes (12): NSObject, Coordinator, NativeCropScrollView, Bool, Int, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollView (+4 more)

### Community 4 - "String"
Cohesion: 0.08
Nodes (20): Drug, FocusAction, addDrug, finishShift, practiceWeak, reviewDue, FocusModeEngine, FocusRecommendation (+12 more)

### Community 5 - "Chapter"
Cohesion: 0.41
Nodes (4): CGRect, CGSize, ImageCompressor, UIImage

### Community 6 - "QuestionType"
Cohesion: 0.23
Nodes (8): Double, WeaknessRadarView, PreviewData, ModelContainer, PhotosUI, SwiftData, SwiftUI, UIKit

### Community 7 - "CameraPicker"
Cohesion: 0.29
Nodes (5): Any, Context, CameraPicker, UIImagePickerController, UIViewControllerRepresentable

### Community 8 - "DrugCardAnchor"
Cohesion: 0.20
Nodes (10): DrugCardAnchor, arabic, counseling, identity, mastery, notes, pharmacology, review (+2 more)

### Community 9 - "ShiftView"
Cohesion: 0.16
Nodes (16): ActiveShiftCard, ActiveShiftContent, EncounterEditorView, EndShiftView, ShiftPhase, ShiftPhaseRow, ShiftView, Binding (+8 more)

### Community 10 - "Identifiable"
Cohesion: 0.05
Nodes (37): CodingKey, CodingKeys, dailyActivities, drugs, encounters, learningProfiles, reports, reviews (+29 more)

### Community 11 - "SafetyFlag"
Cohesion: 0.07
Nodes (27): Encoder, ImportedDosingFrequency, fourTimesDaily, onceDaily, other, PRN, threeTimesDaily, twiceDaily (+19 more)

### Community 12 - "LibraryView"
Cohesion: 0.27
Nodes (7): DrugRow, LibraryFilterView, LibraryView, Bool, Drug, Int, String

### Community 13 - "Foundation"
Cohesion: 0.22
Nodes (4): Foundation, PrivacyValidator, Bool, String

### Community 14 - "Build and install PharmaShift using only Windows"
Cohesion: 0.15
Nodes (10): Final Release Gate, PharmaShift Delivery Roadmap, Phase 2 - Visual Pharmacology and Safety, Phase 3 - Backup, Restore, and Export, Phase 4 - Drug Information Import, Phase 5 - Focus, Practice, and Motivation, PharmaShift, 1. Build the IPA on GitHub (+2 more)

### Community 15 - "CaseIterable"
Cohesion: 0.18
Nodes (11): Color, Content, Flashcard, ImportSection, ImportSelection, AboutView, AppShell, MoreView (+3 more)

### Community 16 - "Codable"
Cohesion: 0.09
Nodes (30): BackupError, duplicateIdentifiers, invalidCounts, malformed, newerVersion, BackupRecordCounts, BackupRestoreMode, merge (+22 more)

### Community 17 - "ConfidenceLevel"
Cohesion: 0.20
Nodes (10): ImportSection, adverseEffects, arabicExplanation, counseling, identity, memorization, pharmacokinetics, safety (+2 more)

### Community 18 - "DurationBand"
Cohesion: 0.05
Nodes (37): AppNavigation, HomeView, Color, Double, Drug, Int, String, SystemDashboardCard (+29 more)

### Community 19 - "OnsetBand"
Cohesion: 0.32
Nodes (5): DrugImportApplier, ImportSelection, Data, Drug, Set

### Community 21 - "ModelAndPersistenceTests"
Cohesion: 0.09
Nodes (19): CaptureView, SaveAction, another, later, open, Binding, Bool, Data (+11 more)

### Community 22 - "QuestionType"
Cohesion: 0.25
Nodes (8): SafetyFlag, anticoagulant, children, controlledDrug, corticosteroid, insulin, pregnancy, severeSymptoms

### Community 23 - "ReportEditorView"
Cohesion: 0.06
Nodes (47): ClosedRange, Hashable, DrugEditorView, Binding, Bool, Double, Drug, Int (+39 more)

### Community 24 - "Q: What should PharmaShift do after Phase 1?"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: What should PharmaShift do after Phase 1?, Source Nodes

### Community 25 - "Identifiable"
Cohesion: 0.47
Nodes (3): CGImagePropertyOrientation, OCRService, UIImage

### Community 26 - "FocusField"
Cohesion: 0.25
Nodes (6): CropGrid, CropViewportState, CGPoint, Path, Shape, UIEdgeInsets

### Community 27 - "AppTheme"
Cohesion: 0.14
Nodes (13): DailyMedProvider, DeepSeekDrugImportService, DeepSeekKeyStore, DrugImportFormattingService, DrugSearchResult, DrugSourceProvider, DrugSourceProviderFactory, MockDeepSeekDrugImportService (+5 more)

### Community 28 - "Foundation"
Cohesion: 0.17
Nodes (21): Decodable, Candidate, Choice, DailyMedSearchItem, DailyMedSearchPayload, DeepSeekResponse, DrugImportValidator, Group (+13 more)

### Community 29 - "ReportEditorView"
Cohesion: 0.29
Nodes (23): Codable, Equatable, Flashcard, ImportedAdverseEffects, ImportedArabicExplanation, ImportedCounseling, ImportedDrugInfo, ImportedIdentity (+15 more)

### Community 30 - "Path"
Cohesion: 0.12
Nodes (16): Binding, Bool, Data, Drug, DrugImagePayload, DrugImportFormattingService, DrugSearchResult, DrugSourceProvider (+8 more)

### Community 31 - "DrugEditorSection"
Cohesion: 0.29
Nodes (7): DrugEditorSection, basics, counseling, notes, pk, safety, uses

### Community 32 - "Design"
Cohesion: 0.17
Nodes (11): Accessibility floor, Aesthetic direction, Brand voice, Color tokens, Core component inventory, Design, Dials, Last updated (+3 more)

### Community 33 - "PharmacologyScale"
Cohesion: 0.16
Nodes (16): Encodable, DeepSeekRequest, ResponseFormat, SPLParser, SPLXMLDelegate, Bool, Double, Int (+8 more)

### Community 34 - ".reportSection"
Cohesion: 0.22
Nodes (6): OCRDrugCandidate, FlowChips, ImportFromPhotoView, ImportMemorizationChallengeView, ImportSourceSearchView, Void

### Community 36 - "Identifiable"
Cohesion: 0.33
Nodes (6): Identifiable, ConfidenceLevel, mastered, medium, strong, weak

### Community 37 - "Drug"
Cohesion: 0.20
Nodes (8): Drug, Bool, Data, Date, Int, String, UUID, ModelAndPersistenceTests

### Community 38 - "SafetyRadar"
Cohesion: 0.18
Nodes (11): LocalizedError, DrugImportError, aiReturnedEmpty, invalidAIJSON, invalidQuery, invalidResponse, missingDeepSeekKey, parsingFailed (+3 more)

### Community 39 - "BackupImportPreviewView"
Cohesion: 0.33
Nodes (3): BackupImportPreviewView, Int, Void

### Community 40 - "DrugSearchResult"
Cohesion: 0.07
Nodes (28): CoreTransferable, Error, FileDocument, FileWrapper, BackupDataView, BackupExportKind, complete, csv (+20 more)

### Community 41 - "AppTheme"
Cohesion: 0.33
Nodes (6): HalfLifeBand, long, medium, short, unknown, veryLong

### Community 42 - "Foundation"
Cohesion: 0.33
Nodes (3): LearningSettingsView, Binding, Bool

### Community 43 - "AppTab"
Cohesion: 0.33
Nodes (6): AppTab, capture, home, library, more, practice

### Community 44 - ".containsObviousIdentifier"
Cohesion: 0.25
Nodes (6): App, Observation, AppTheme, Color, PharmaShiftApp, Scene

### Community 45 - "LearningSettingsView"
Cohesion: 0.33
Nodes (6): PKBand, long, medium, short, unknown, veryLong

### Community 46 - "ImportSection"
Cohesion: 0.25
Nodes (7): Int, ImportStage, challenge, confirm, photo, preview, source

### Community 47 - "CaseIterable"
Cohesion: 0.40
Nodes (5): CaseIterable, ProdrugStatus, active, prodrug, unknown

### Community 48 - "DurationBand"
Cohesion: 0.40
Nodes (5): DurationBand, long, medium, short, unknown

### Community 49 - ".apply"
Cohesion: 0.26
Nodes (8): ReviewScheduler, Bool, Calendar, Date, Drug, Int, String, ReviewSchedulerTests

### Community 50 - "ImportedDurationBand"
Cohesion: 0.40
Nodes (5): ExcretionRoute, hepatic, mixed, renal, unknown

### Community 51 - "DrugImportServiceTests"
Cohesion: 0.27
Nodes (3): DrugImportServiceTests, Bool, String

### Community 52 - "PracticeMode"
Cohesion: 0.40
Nodes (5): OnsetBand, fast, moderate, slow, unknown

### Community 53 - "PracticeSessionView"
Cohesion: 0.40
Nodes (5): ImportedDurationBand, long, medium, short, unknown

### Community 54 - "PharmaShiftUITests"
Cohesion: 0.18
Nodes (4): MigrationFixtureTests, ReportBuilderTests, PharmaShiftUITests, XCTestCase

### Community 55 - "FocusField"
Cohesion: 0.50
Nodes (4): FocusField, scientific, trade, unknownLabel

### Community 58 - ".matches"
Cohesion: 0.28
Nodes (5): DrugFilter, Bool, Calendar, Date, Drug

### Community 60 - "DrugMigrationPlan"
Cohesion: 0.33
Nodes (7): MigrationStage, PersistentModel, CurrentDrugSchema, DrugMigrationPlan, Phase1DrugSchema, SchemaMigrationPlan, VersionedSchema

## Knowledge Gaps
- **243 isolated node(s):** `photo`, `confirm`, `source`, `preview`, `challenge` (+238 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **12 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Chapter` connect `DurationBand` to `ShiftLog`, `Drug`, `Identifiable`, `String`, `ShiftView`, `.containsObviousIdentifier`, `CaseIterable`, `ModelAndPersistenceTests`, `ReportEditorView`, `ReportEditorView`?**
  _High betweenness centrality (0.062) - this node is a cross-community bridge._
- **Why does `SwiftData` connect `QuestionType` to `ShiftLog`, `Drug`, `.reportSection`, `String`, `DrugSearchResult`, `ShiftView`, `LibraryView`, `CaseIterable`, `Codable`, `DurationBand`, `ReportEditorView`, `SwiftData`?**
  _High betweenness centrality (0.058) - this node is a cross-community bridge._
- **Why does `DrugEditorView` connect `ReportEditorView` to `SwiftUI`, `Drug`, `Chapter`, `QuestionType`, `AppTheme`, `CaseIterable`, `DurationBand`, `CaseIterable`, `DurationBand`, `ImportedDurationBand`, `PracticeMode`, `ModelAndPersistenceTests`, `AppTheme`, `DrugEditorSection`?**
  _High betweenness centrality (0.057) - this node is a cross-community bridge._
- **What connects `photo`, `confirm`, `source` to the rest of the system?**
  _243 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `ShiftLog` be split into smaller, more focused modules?**
  _Cohesion score 0.07126207126207126 - nodes in this community are weakly interconnected._
- **Should `String` be split into smaller, more focused modules?**
  _Cohesion score 0.08392603129445235 - nodes in this community are weakly interconnected._
- **Should `Identifiable` be split into smaller, more focused modules?**
  _Cohesion score 0.05405405405405406 - nodes in this community are weakly interconnected._