# Graph Report - pharmashift  (2026-07-12)

## Corpus Check
- 44 files · ~67,598 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1056 nodes · 2584 edges · 64 communities (60 shown, 4 thin omitted)
- Extraction: 96% EXTRACTED · 4% INFERRED · 0% AMBIGUOUS · INFERRED: 95 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `4b4cce8d`
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
- [[_COMMUNITY_ImportedExcretionRoute|ImportedExcretionRoute]]
- [[_COMMUNITY_DrugSearchResult|DrugSearchResult]]
- [[_COMMUNITY_AppTheme|AppTheme]]
- [[_COMMUNITY_.importIfNeeded|.importIfNeeded]]
- [[_COMMUNITY_ImportStage|ImportStage]]
- [[_COMMUNITY_.containsObviousIdentifier|.containsObviousIdentifier]]
- [[_COMMUNITY_DosingFrequency|DosingFrequency]]
- [[_COMMUNITY_ImportedDosingFrequency|ImportedDosingFrequency]]
- [[_COMMUNITY_MigrationFixtureTests.swift|MigrationFixtureTests.swift]]
- [[_COMMUNITY_CropViewportState|CropViewportState]]
- [[_COMMUNITY_LearningSettingsView|LearningSettingsView]]
- [[_COMMUNITY_.matches|.matches]]
- [[_COMMUNITY_.generate|.generate]]
- [[_COMMUNITY_ReportFile.swift|ReportFile.swift]]
- [[_COMMUNITY_ImageFlowDestination|ImageFlowDestination]]
- [[_COMMUNITY_OnsetBand|OnsetBand]]
- [[_COMMUNITY_SaveAction|SaveAction]]
- [[_COMMUNITY_ImageAcquisitionSource|ImageAcquisitionSource]]
- [[_COMMUNITY_XCTest|XCTest]]
- [[_COMMUNITY_CropViewportState|CropViewportState]]
- [[_COMMUNITY_DrugEditorSection|DrugEditorSection]]
- [[_COMMUNITY_URL|URL]]
- [[_COMMUNITY_HalfLifeBand|HalfLifeBand]]
- [[_COMMUNITY_ImportSelection|ImportSelection]]
- [[_COMMUNITY_UIImage|UIImage]]

## God Nodes (most connected - your core abstractions)
1. `DrugImportView` - 40 edges
2. `DrugEditorView` - 39 edges
3. `Chapter` - 39 edges
4. `CodingKeys` - 30 edges
5. `ShiftLog` - 28 edges
6. `Drug` - 27 edges
7. `Drug` - 26 edges
8. `UserConfirmedDrugIdentity` - 24 edges
9. `ImportedDrugInfo` - 24 edges
10. `PracticeMode` - 24 edges

## Surprising Connections (you probably didn't know these)
- `PharmaShiftApp` --calls--> `AppTheme`  [INFERRED]
  PharmaShift/App/PharmaShiftApp.swift → PharmaShift/App/AppTheme.swift
- `DrugImportView` --calls--> `DeepSeekFastDrugGatherService`  [INFERRED]
  PharmaShift/Features/Library/DrugImportView.swift → PharmaShift/Services/DrugImportService.swift
- `PreviewData` --calls--> `ShiftLog`  [INFERRED]
  PharmaShift/Shared/PreviewSupport.swift → PharmaShift/Models/Models.swift
- `AppNavigation` --references--> `PracticeMode`  [EXTRACTED]
  PharmaShift/App/AppShell.swift → PharmaShift/Services/PracticeEngine.swift
- `LearningSettingsView` --references--> `LearningProfile`  [EXTRACTED]
  PharmaShift/App/AppShell.swift → PharmaShift/Models/Models.swift

## Import Cycles
- None detected.

## Communities (64 total, 4 thin omitted)

### Community 0 - "ShiftLog"
Cohesion: 0.24
Nodes (12): DailyActivity, Drug, EncounterNote, LearningProfile, ReviewLog, ShiftLog, Bool, Calendar (+4 more)

### Community 1 - "SwiftUI"
Cohesion: 0.16
Nodes (11): Coordinator, NativeCropScrollView, Bool, Int, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollView, UIScrollViewDelegate (+3 more)

### Community 2 - "Drug"
Cohesion: 0.10
Nodes (14): DailyMedProvider, DeepSeekDrugImportService, DeepSeekFastDrugGatherService, DrugImportApplier, DrugImportFormattingService, DrugSourceProvider, DrugSourceProviderFactory, FastDrugGatheringService (+6 more)

### Community 3 - "ImageCapture.swift"
Cohesion: 0.17
Nodes (10): DrugDetailSheet, editor, review, DrugDetailView, Color, Content, Drug, Set (+2 more)

### Community 4 - "String"
Cohesion: 0.27
Nodes (5): Encoder, DrugImportValidator, FastGatherPromptBuilder, UserConfirmedDrugIdentity, URLRequest

### Community 5 - "Chapter"
Cohesion: 0.27
Nodes (7): ReportView, Drug, TrainingReport, ReportBuilder, Calendar, Drug, String

### Community 6 - "QuestionType"
Cohesion: 0.12
Nodes (12): NSObject, NameKind, brand, generic, PromptBuilder, SPLParser, SPLXMLDelegate, Int (+4 more)

### Community 7 - "LibraryView"
Cohesion: 0.32
Nodes (6): DrugEditorView, Binding, Bool, Drug, PhotosPickerItem, ReferenceWritableKeyPath

### Community 8 - "PracticeSessionView"
Cohesion: 0.26
Nodes (8): PracticeSessionView, Drug, String, PracticeInteraction, multipleChoice, recall, PracticeQuestion, Data

### Community 9 - "ShiftView"
Cohesion: 0.16
Nodes (16): ActiveShiftCard, ActiveShiftContent, EncounterEditorView, EndShiftView, ShiftPhase, ShiftPhaseRow, ShiftView, Binding (+8 more)

### Community 10 - "Identifiable"
Cohesion: 0.05
Nodes (37): CodingKey, CodingKeys, dailyActivities, drugs, encounters, learningProfiles, reports, reviews (+29 more)

### Community 11 - "SafetyFlag"
Cohesion: 0.07
Nodes (29): ImportedDurationBand, long, medium, short, unknown, ImportedExcretionRoute, hepatic, mixed (+21 more)

### Community 12 - "DosingFrequency"
Cohesion: 0.05
Nodes (34): PracticeView, Int, Drug, FocusAction, addDrug, finishShift, practiceWeak, reviewDue (+26 more)

### Community 13 - "HalfLifeBand"
Cohesion: 0.08
Nodes (33): CaseIterable, Identifiable, ConfidenceLevel, mastered, medium, strong, weak, DurationBand (+25 more)

### Community 14 - "Build and install PharmaShift using only Windows"
Cohesion: 0.15
Nodes (10): Final Release Gate, PharmaShift Delivery Roadmap, Phase 2 - Visual Pharmacology and Safety, Phase 3 - Backup, Restore, and Export, Phase 4 - Drug Information Import, Phase 5 - Focus, Practice, and Motivation, Renlyst, 1. Build the IPA on GitHub (+2 more)

### Community 15 - "CaseIterable"
Cohesion: 0.22
Nodes (11): FlowChips, ImportFromPhotoView, ImportPreviewView, Color, String, Severity, high, low (+3 more)

### Community 16 - "Codable"
Cohesion: 0.06
Nodes (46): Error, FileDocument, FileWrapper, BackupDataView, BackupExportKind, complete, csv, lightweight (+38 more)

### Community 17 - "ConfidenceLevel"
Cohesion: 0.25
Nodes (8): QuestionType, casePractice, counseling, drugClass, scientificName, tradeName, use, warning

### Community 18 - "DurationBand"
Cohesion: 0.06
Nodes (34): Observation, AboutView, AppNavigation, AppShell, AppTab, capture, home, library (+26 more)

### Community 19 - "OnsetBand"
Cohesion: 0.39
Nodes (5): ConfirmDrugIdentityView, ImportMemorizationChallengeView, ImportSourceSearchView, Bool, Void

### Community 21 - "ModelAndPersistenceTests"
Cohesion: 0.08
Nodes (19): CaptureView, SaveAction, another, later, open, Binding, Bool, Data (+11 more)

### Community 22 - "QuestionType"
Cohesion: 0.20
Nodes (10): ImportSection, adverseEffects, arabicExplanation, counseling, identity, memorization, pharmacokinetics, safety (+2 more)

### Community 23 - "ReportEditorView"
Cohesion: 0.12
Nodes (16): DosingFrequency, asNeeded, fourTimesDaily, onceDaily, other, threeTimesDaily, twiceDaily, unknown (+8 more)

### Community 24 - "Q: What should PharmaShift do after Phase 1?"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: What should PharmaShift do after Phase 1?, Source Nodes

### Community 25 - "Identifiable"
Cohesion: 0.18
Nodes (8): Drug, Bool, Data, Date, Int, String, UUID, ModelAndPersistenceTests

### Community 26 - "FocusField"
Cohesion: 0.13
Nodes (16): OSStatus, LearningSettingsView, Binding, Bool, DeepSeekKeyStore, deepSeekHTTPStatus, KeyStoreError, keychain (+8 more)

### Community 27 - "AppTheme"
Cohesion: 0.19
Nodes (11): ReviewScheduler, Bool, Calendar, Date, Drug, Int, String, MigrationFixtureTests (+3 more)

### Community 28 - "Foundation"
Cohesion: 0.20
Nodes (21): Decodable, Encodable, Candidate, Choice, DailyMedSearchItem, DailyMedSearchPayload, DeepSeekRequest, DeepSeekResponse (+13 more)

### Community 29 - "ReportEditorView"
Cohesion: 0.45
Nodes (17): Codable, Equatable, Flashcard, ImportedAdverseEffects, ImportedArabicExplanation, ImportedCounseling, ImportedDrugInfo, ImportedIdentity (+9 more)

### Community 30 - "Path"
Cohesion: 0.18
Nodes (11): ImageIO, DrugImagePayload, DrugPhotoGalleryView, DrugPhotoView, DrugThumbnailView, ImageDraft, ImageEditorView, CGFloat (+3 more)

### Community 31 - "ModelAndPersistenceTests"
Cohesion: 0.17
Nodes (12): LocalizedError, DrugImportError, aiReturnedEmpty, invalidAIJSON, invalidQuery, invalidResponse, missingDeepSeekKey, parsingFailed (+4 more)

### Community 32 - "Design"
Cohesion: 0.17
Nodes (11): Accessibility floor, Aesthetic direction, Brand voice, Color tokens, Core component inventory, Design, Dials, Last updated (+3 more)

### Community 33 - "PharmacologyScale"
Cohesion: 0.09
Nodes (24): DrugImportView, ImportMode, aiDraft, trusted, Data, Drug, PhotosPickerItem, AIPracticePack (+16 more)

### Community 34 - ".reportSection"
Cohesion: 0.38
Nodes (4): CGRect, CGSize, ImageCompressor, UIImage

### Community 35 - "LibraryView"
Cohesion: 0.27
Nodes (7): DrugRow, LibraryFilterView, LibraryView, Bool, Drug, Int, String

### Community 37 - "Drug"
Cohesion: 0.50
Nodes (4): VerificationStatus, pendingPharmacist, personal, pharmacistVerified

### Community 38 - "SafetyRadar"
Cohesion: 0.20
Nodes (11): SafetySeverity, high, low, medium, unknown, SafetyRadar, CGFloat, CGPoint (+3 more)

### Community 39 - "ImportedExcretionRoute"
Cohesion: 0.15
Nodes (11): FocusField, scientific, trade, unknownLabel, Double, WeaknessRadarView, PreviewData, ModelContainer (+3 more)

### Community 40 - "DrugSearchResult"
Cohesion: 0.24
Nodes (8): ClosedRange, Double, PharmacologyMeter, PharmacologyScale, duration, halfLife, onset, Double

### Community 41 - "AppTheme"
Cohesion: 0.50
Nodes (3): App, PharmaShiftApp, Scene

### Community 42 - ".importIfNeeded"
Cohesion: 0.27
Nodes (6): report, ReportEditorView, Binding, Date, ReferenceWritableKeyPath, String

### Community 43 - "ImportStage"
Cohesion: 0.25
Nodes (7): Int, ImportStage, challenge, confirm, photo, preview, source

### Community 44 - ".containsObviousIdentifier"
Cohesion: 0.27
Nodes (3): DrugImportServiceTests, Bool, String

### Community 45 - "DosingFrequency"
Cohesion: 0.27
Nodes (8): DosingFrequencyMeter, EmptyStateView, LabeledValue, MasteryBadge, MetricCard, PharmacologyStatusCard, Drug, String

### Community 46 - "ImportedDosingFrequency"
Cohesion: 0.22
Nodes (4): Foundation, PrivacyValidator, Bool, String

### Community 47 - "MigrationFixtureTests.swift"
Cohesion: 0.25
Nodes (8): SafetyFlag, anticoagulant, children, controlledDrug, corticosteroid, insulin, pregnancy, severeSymptoms

### Community 48 - "CropViewportState"
Cohesion: 0.32
Nodes (5): DrugFilter, Bool, Calendar, Date, Drug

### Community 49 - "LearningSettingsView"
Cohesion: 0.39
Nodes (3): DrugSearchRanker, DrugSearchResult, MockDrugSourceProvider

### Community 50 - ".matches"
Cohesion: 0.29
Nodes (6): CoreTransferable, ReportFile, String, Transferable, TransferRepresentation, UniformTypeIdentifiers

### Community 51 - ".generate"
Cohesion: 0.29
Nodes (5): Any, Context, CameraPicker, UIImagePickerController, UIViewControllerRepresentable

### Community 52 - "ReportFile.swift"
Cohesion: 0.20
Nodes (10): DrugCardAnchor, arabic, counseling, identity, mastery, notes, pharmacology, review (+2 more)

### Community 53 - "ImageFlowDestination"
Cohesion: 0.43
Nodes (5): Hashable, PracticeCase, StarterContent, Drug, String

### Community 54 - "OnsetBand"
Cohesion: 0.33
Nodes (7): MigrationStage, PersistentModel, CurrentDrugSchema, DrugMigrationPlan, Phase1DrugSchema, SchemaMigrationPlan, VersionedSchema

### Community 56 - "ImageAcquisitionSource"
Cohesion: 0.40
Nodes (3): BackupImportPreviewView, Int, Void

### Community 57 - "XCTest"
Cohesion: 0.40
Nodes (3): PharmaShift, SwiftData, XCTest

### Community 58 - "CropViewportState"
Cohesion: 0.25
Nodes (6): CropGrid, CropViewportState, CGPoint, Path, Shape, UIEdgeInsets

### Community 59 - "DrugEditorSection"
Cohesion: 0.29
Nodes (7): DrugEditorSection, basics, counseling, notes, pk, safety, uses

### Community 62 - "HalfLifeBand"
Cohesion: 0.33
Nodes (6): HalfLifeBand, long, medium, short, unknown, veryLong

### Community 63 - "ImportSelection"
Cohesion: 0.40
Nodes (4): Binding, Content, ImportSelection, Set

### Community 73 - "UIImage"
Cohesion: 0.43
Nodes (4): CGImagePropertyOrientation, OCRDrugCandidate, OCRService, UIImage

## Knowledge Gaps
- **249 isolated node(s):** `home`, `library`, `capture`, `practice`, `more` (+244 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **4 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `DrugImportView` connect `PharmacologyScale` to `Drug`, `.reportSection`, `String`, `QuestionType`, `UIImage`, `ImportStage`, `CaseIterable`, `LearningSettingsView`, `OnsetBand`, `ModelAndPersistenceTests`, `ReportEditorView`, `Path`, `ImportSelection`?**
  _High betweenness centrality (0.068) - this node is a cross-community bridge._
- **Why does `CodingKeys` connect `Identifiable` to `FocusField`, `Foundation`?**
  _High betweenness centrality (0.064) - this node is a cross-community bridge._
- **Why does `Chapter` connect `DurationBand` to `ShiftLog`, `ImageCapture.swift`, `LibraryView`, `PracticeSessionView`, `ShiftView`, `DosingFrequency`, `HalfLifeBand`, `ModelAndPersistenceTests`, `ImageFlowDestination`, `ReportEditorView`?**
  _High betweenness centrality (0.053) - this node is a cross-community bridge._
- **Are the 2 inferred relationships involving `DrugImportView` (e.g. with `DeepSeekIdentityResolver` and `DeepSeekFastDrugGatherService`) actually correct?**
  _`DrugImportView` has 2 INFERRED edges - model-reasoned connections that need verification._
- **What connects `home`, `library`, `capture` to the rest of the system?**
  _249 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Drug` be split into smaller, more focused modules?**
  _Cohesion score 0.1021021021021021 - nodes in this community are weakly interconnected._
- **Should `QuestionType` be split into smaller, more focused modules?**
  _Cohesion score 0.12121212121212122 - nodes in this community are weakly interconnected._