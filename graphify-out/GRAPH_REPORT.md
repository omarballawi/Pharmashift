# Graph Report - pharmashift  (2026-07-15)

## Corpus Check
- 45 files · ~198,364 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1414 nodes · 3795 edges · 80 communities (76 shown, 4 thin omitted)
- Extraction: 95% EXTRACTED · 5% INFERRED · 0% AMBIGUOUS · INFERRED: 173 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `677b8b3d`
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
- [[_COMMUNITY_.image|.image]]
- [[_COMMUNITY_Build and install PharmaShift using only Windows|Build and install PharmaShift using only Windows]]
- [[_COMMUNITY_CaseIterable|CaseIterable]]
- [[_COMMUNITY_Codable|Codable]]
- [[_COMMUNITY_ImageCapture.swift|ImageCapture.swift]]
- [[_COMMUNITY_DurationBand|DurationBand]]
- [[_COMMUNITY_HomeView|HomeView]]
- [[_COMMUNITY_AGENTS|AGENTS.md]]
- [[_COMMUNITY_ModelAndPersistenceTests|ModelAndPersistenceTests]]
- [[_COMMUNITY_QuestionType|QuestionType]]
- [[_COMMUNITY_HomeView|HomeView]]
- [[_COMMUNITY_Q What should PharmaShift do after Phase 1|Q: What should PharmaShift do after Phase 1?]]
- [[_COMMUNITY_Identifiable|Identifiable]]
- [[_COMMUNITY_FocusField|FocusField]]
- [[_COMMUNITY_DrugImportView.swift|DrugImportView.swift]]
- [[_COMMUNITY_Foundation|Foundation]]
- [[_COMMUNITY_ReportEditorView|ReportEditorView]]
- [[_COMMUNITY_Path|Path]]
- [[_COMMUNITY_.apply|.apply]]
- [[_COMMUNITY_Design|Design]]
- [[_COMMUNITY_PharmacologyScale|PharmacologyScale]]
- [[_COMMUNITY_SwiftData|SwiftData]]
- [[_COMMUNITY_LibraryView|LibraryView]]
- [[_COMMUNITY_ReviewRating|ReviewRating]]
- [[_COMMUNITY_.generate|.generate]]
- [[_COMMUNITY_SafetyRadar|SafetyRadar]]
- [[_COMMUNITY_StarterContent|StarterContent]]
- [[_COMMUNITY_MemoryReviewGrade|MemoryReviewGrade]]
- [[_COMMUNITY_DosingFrequency|DosingFrequency]]
- [[_COMMUNITY_SafetyRadar|SafetyRadar]]
- [[_COMMUNITY_DrugRelationshipKind|DrugRelationshipKind]]
- [[_COMMUNITY_ImportedDosingFrequency|ImportedDosingFrequency]]
- [[_COMMUNITY_.record|.record]]
- [[_COMMUNITY_Binding|Binding]]
- [[_COMMUNITY_DurationBand|DurationBand]]
- [[_COMMUNITY_DrugEditorSection|DrugEditorSection]]
- [[_COMMUNITY_PracticeQuestion|PracticeQuestion]]
- [[_COMMUNITY_Color|Color]]
- [[_COMMUNITY_.generate|.generate]]
- [[_COMMUNITY_ImportedExcretionRoute|ImportedExcretionRoute]]
- [[_COMMUNITY_DrugEditorSection|DrugEditorSection]]
- [[_COMMUNITY_ImportedDosingFrequency|ImportedDosingFrequency]]
- [[_COMMUNITY_ImportedDosingFrequency|ImportedDosingFrequency]]
- [[_COMMUNITY_FocusField|FocusField]]
- [[_COMMUNITY_SafetyFlag|SafetyFlag]]
- [[_COMMUNITY_Components.swift|Components.swift]]
- [[_COMMUNITY_PhotosPickerItem|PhotosPickerItem]]
- [[_COMMUNITY_String|String]]
- [[_COMMUNITY_CGPoint|CGPoint]]
- [[_COMMUNITY_.canonicalKey|.canonicalKey]]
- [[_COMMUNITY_.apply|.apply]]
- [[_COMMUNITY_MemoryReviewGrade|MemoryReviewGrade]]
- [[_COMMUNITY_Bool|Bool]]
- [[_COMMUNITY_DeepSeekURLProtocolStub|DeepSeekURLProtocolStub]]
- [[_COMMUNITY_VerificationStatus|VerificationStatus]]
- [[_COMMUNITY_DrugBackupDTO|DrugBackupDTO]]
- [[_COMMUNITY_String|String]]
- [[_COMMUNITY_MemoryReviewGrade|MemoryReviewGrade]]
- [[_COMMUNITY_BackupImportPreviewView|BackupImportPreviewView]]
- [[_COMMUNITY_ExcretionRoute|ExcretionRoute]]
- [[_COMMUNITY_SafetyFlag|SafetyFlag]]
- [[_COMMUNITY_AppTheme|AppTheme]]
- [[_COMMUNITY_Double|Double]]
- [[_COMMUNITY_Components.swift|Components.swift]]
- [[_COMMUNITY_VerificationStatus|VerificationStatus]]
- [[_COMMUNITY_VerificationStatus|VerificationStatus]]
- [[_COMMUNITY_String|String]]

## God Nodes (most connected - your core abstractions)
1. `Drug` - 47 edges
2. `Chapter` - 42 edges
3. `DrugEditorView` - 39 edges
4. `DrugImportView` - 39 edges
5. `ImportedDrugInfo` - 37 edges
6. `DeepSeekKeyStore` - 33 edges
7. `CodingKeys` - 32 edges
8. `Drug` - 31 edges
9. `PracticeQuestion` - 28 edges
10. `ShiftLog` - 28 edges

## Surprising Connections (you probably didn't know these)
- `DrugImportView` --calls--> `DeepSeekIdentityResolver`  [INFERRED]
  PharmaShift/Features/Library/DrugImportView.swift → PharmaShift/Services/DeepSeekLearningService.swift
- `PreviewData` --calls--> `ShiftLog`  [INFERRED]
  PharmaShift/Shared/PreviewSupport.swift → PharmaShift/Models/Models.swift
- `AppNavigation` --references--> `PracticeMode`  [EXTRACTED]
  PharmaShift/App/AppShell.swift → PharmaShift/Services/PracticeEngine.swift
- `LearningSettingsView` --references--> `LearningProfile`  [EXTRACTED]
  PharmaShift/App/AppShell.swift → PharmaShift/Models/Models.swift
- `PharmaShiftApp` --calls--> `AppTheme`  [INFERRED]
  PharmaShift/App/PharmaShiftApp.swift → PharmaShift/App/AppTheme.swift

## Import Cycles
- None detected.

## Communities (80 total, 4 thin omitted)

### Community 0 - "ShiftLog"
Cohesion: 0.19
Nodes (8): DrugImportView, Bool, Drug, PhotosPickerItem, DrugImportFormattingService, DrugPackageRecognizing, DrugSourceProvider, FastDrugGatheringService

### Community 1 - "SwiftUI"
Cohesion: 0.17
Nodes (10): Coordinator, NativeCropScrollView, Bool, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollView, UIScrollViewDelegate, UITapGestureRecognizer (+2 more)

### Community 2 - "Drug"
Cohesion: 0.15
Nodes (31): Hashable, Identifiable, AdverseEffectEntry, AtomicDrugNote, AtomicNoteKind, confusingPoint, memoryTrick, patientCounseling (+23 more)

### Community 3 - "ImageCapture.swift"
Cohesion: 0.18
Nodes (6): DeepSeekKeyStore, keychain, StorageLocation, appPreferences, keychain, protectedFile

### Community 4 - "String"
Cohesion: 0.12
Nodes (17): IngredientComponent, deepSeekHTTPStatus, DrugImportValidator, MockOpenRouterPackageVisionService, PackageRecognitionResult, ProfileGenerationGroup, adverseEffects, counselingAndLearning (+9 more)

### Community 5 - "Chapter"
Cohesion: 0.14
Nodes (18): DoseCalculator, DoseFormulaKind, fixed, mgPerKgPerDay, mgPerKgPerDose, mgPerSquareMeter, DosePatientInput, DosePopulation (+10 more)

### Community 6 - "QuestionType"
Cohesion: 0.13
Nodes (12): DrugDataConsistencyNormalizer, DrugImportApplier, DrugRelationshipRefreshService, ImportSelection, MockDrugSourceProvider, Double, Drug, ModelContext (+4 more)

### Community 7 - "LibraryView"
Cohesion: 0.19
Nodes (7): NSNumber, DeepSeekJSONSanitizer, memorization, Any, Bool, Data, UInt8

### Community 8 - "PracticeSessionView"
Cohesion: 0.16
Nodes (11): FlowChips, ImportPreviewView, Binding, Color, Content, String, Severity, high (+3 more)

### Community 9 - "ShiftView"
Cohesion: 0.16
Nodes (16): ActiveShiftCard, ActiveShiftContent, EncounterEditorView, EndShiftView, ShiftPhase, ShiftPhaseRow, ShiftView, Binding (+8 more)

### Community 10 - "Identifiable"
Cohesion: 0.07
Nodes (29): CodingKeys, adverseReactions, boxedWarning, brandName, clinicalPharmacology, contraindications, dosageAndAdministration, dosageForm (+21 more)

### Community 11 - "SafetyFlag"
Cohesion: 0.21
Nodes (6): ObservableObject, CounselingSpeechRecognizer, Bool, VoiceCounselingView, SFSpeechAudioBufferRecognitionRequest, SFSpeechRecognitionTask

### Community 12 - "DosingFrequency"
Cohesion: 0.16
Nodes (13): Drug, FocusAction, addDrug, finishShift, practiceWeak, reviewDue, FocusModeEngine, FocusRecommendation (+5 more)

### Community 13 - ".image"
Cohesion: 0.17
Nodes (7): LearningSettingsView, Binding, Bool, openRouterHTTPStatus, OpenRouterKeyStore, OpenRouterPackageVisionService, UserDefaults

### Community 14 - "Build and install PharmaShift using only Windows"
Cohesion: 0.15
Nodes (10): Final Release Gate, PharmaShift Delivery Roadmap, Phase 2 - Visual Pharmacology and Safety, Phase 3 - Backup, Restore, and Export, Phase 4 - Drug Information Import, Phase 5 - Focus, Practice, and Motivation, Renlyst, 1. Build the IPA on GitHub (+2 more)

### Community 15 - "CaseIterable"
Cohesion: 0.16
Nodes (13): MigrationStage, PersistentModel, PharmaShift, CurrentDrugSchema, DrugMigrationPlan, MigrationFixtureTests, Phase1DrugSchema, ReportBuilderTests (+5 more)

### Community 16 - "Codable"
Cohesion: 0.24
Nodes (24): Codable, CoreFoundation, Equatable, ProdrugInfo, Flashcard, GeneratedReviewQuestionDTO, ImportedAdverseEffects, ImportedArabicExplanation (+16 more)

### Community 17 - "ImageCapture.swift"
Cohesion: 0.13
Nodes (17): Error, FileDocument, FileWrapper, BackupDataView, BackupExportKind, complete, csv, lightweight (+9 more)

### Community 18 - "DurationBand"
Cohesion: 0.08
Nodes (32): AppNavigation, AppTab, capture, home, library, more, practice, HomeView (+24 more)

### Community 19 - "HomeView"
Cohesion: 0.11
Nodes (17): FocusField, scientific, trade, unknownLabel, SaveAction, another, later, open (+9 more)

### Community 21 - "ModelAndPersistenceTests"
Cohesion: 0.14
Nodes (11): CaptureView, Binding, Bool, Data, Drug, Int, PhotosPickerItem, String (+3 more)

### Community 22 - "QuestionType"
Cohesion: 0.27
Nodes (6): report, ReportEditorView, Binding, Date, ReferenceWritableKeyPath, String

### Community 23 - "HomeView"
Cohesion: 0.19
Nodes (4): DrugDetailView, Color, Content, ScrollViewProxy

### Community 24 - "Q: What should PharmaShift do after Phase 1?"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: What should PharmaShift do after Phase 1?, Source Nodes

### Community 25 - "Identifiable"
Cohesion: 0.11
Nodes (13): DrugFilter, Bool, Calendar, Date, Drug, Drug, Bool, Data (+5 more)

### Community 26 - "FocusField"
Cohesion: 0.13
Nodes (9): title, DailyMedProvider, DeepSeekDrugImportService, DeepSeekFastDrugGatherService, DrugSourceProviderFactory, OpenFDALabelProvider, RxNormProvider, URLResponse (+1 more)

### Community 27 - "DrugImportView.swift"
Cohesion: 0.30
Nodes (7): DrugEditorView, Binding, Bool, Double, Drug, PhotosPickerItem, ReferenceWritableKeyPath

### Community 28 - "Foundation"
Cohesion: 0.21
Nodes (14): BackupRecordCounts, DailyActivityBackupDTO, DrugProductBackupDTO, DrugRelationshipBackupDTO, EncounterBackupDTO, LearningProfileBackupDTO, PharmaShiftBackup, ReviewBackupDTO (+6 more)

### Community 29 - "ReportEditorView"
Cohesion: 0.08
Nodes (26): CaseIterable, LibrarySection, cards, compare, graph, ConfidenceLevel, mastered, medium (+18 more)

### Community 30 - "Path"
Cohesion: 0.22
Nodes (5): BackupService, Data, ModelContext, BackupServiceTests, ModelContainer

### Community 31 - ".apply"
Cohesion: 0.20
Nodes (6): PracticeCase, StarterContent, Drug, Int, ModelContext, String

### Community 32 - "Design"
Cohesion: 0.17
Nodes (11): Accessibility floor, Aesthetic direction, Brand voice, Color tokens, Core component inventory, Design, Dials, Last updated (+3 more)

### Community 33 - "PharmacologyScale"
Cohesion: 0.29
Nodes (8): ReviewScheduler, Bool, Calendar, Date, Drug, Int, String, ReviewSchedulerTests

### Community 34 - "SwiftData"
Cohesion: 0.16
Nodes (7): ProductLeafletEditorView, Data, PhotosPickerItem, ImageFlowDestination, camera, crop, library

### Community 35 - "LibraryView"
Cohesion: 0.16
Nodes (13): CompareCanvasView, DrugRow, KnowledgeGraphView, LibraryFilterView, LibraryView, Binding, Bool, CGPoint (+5 more)

### Community 36 - "ReviewRating"
Cohesion: 0.28
Nodes (4): PharmaShiftUITests, Int, XCUIApplication, XCUIElement

### Community 37 - ".generate"
Cohesion: 0.17
Nodes (12): DrugProfileSection, adverse, counseling, doses, forms, interactions, notes, overview (+4 more)

### Community 38 - "SafetyRadar"
Cohesion: 0.19
Nodes (8): DoseRegimensView, LocalDrugGraphView, MechanismBuilderView, CGPoint, CGSize, Double, Drug, Int

### Community 39 - "StarterContent"
Cohesion: 0.18
Nodes (12): ImageIO, DrugImagePayload, DrugPhotoGalleryView, DrugPhotoView, DrugThumbnailView, ImageDraft, ImageEditorView, CGFloat (+4 more)

### Community 40 - "MemoryReviewGrade"
Cohesion: 0.18
Nodes (7): Drug, DrugProduct, Calendar, Data, Decoder, Encoder, T

### Community 41 - "DosingFrequency"
Cohesion: 0.15
Nodes (10): AboutView, AppShell, CommandPaletteView, MoreView, Drug, Double, WeaknessRadarView, PreviewData (+2 more)

### Community 42 - "SafetyRadar"
Cohesion: 0.18
Nodes (12): SafetySeverity, high, low, medium, unknown, DosingFrequencyMeter, SafetyRadar, CGFloat (+4 more)

### Community 43 - "DrugRelationshipKind"
Cohesion: 0.14
Nodes (16): ClosedRange, PKTimelineChallengeView, Binding, EmptyStateView, LabeledValue, MasteryBadge, MetricCard, PharmacologyMeter (+8 more)

### Community 44 - "ImportedDosingFrequency"
Cohesion: 0.20
Nodes (10): DrugDetailSheet, atomicNotes, counselingBuilder, editor, mechanism, pkTimeline, regenerateReview, review (+2 more)

### Community 45 - ".record"
Cohesion: 0.40
Nodes (4): CGRect, ImageCompressor, CGSize, UIImage

### Community 46 - "Binding"
Cohesion: 0.33
Nodes (6): DrugRelationship, DrugRelationshipKind, contraindicatedCombination, interaction, relatedUse, sameClass

### Community 47 - "DurationBand"
Cohesion: 0.22
Nodes (8): IngredientIdentity, PracticeAnswer, PracticeSessionResult, ReviewRating, correct, partlyCorrect, wrong, String

### Community 49 - "PracticeQuestion"
Cohesion: 0.06
Nodes (43): Decodable, AIPracticePack, AIPracticePackStore, AIPracticePayload, AIPracticeQuestion, Choice, CodingKeys, answer (+35 more)

### Community 50 - "Color"
Cohesion: 0.06
Nodes (34): DailyRefreshView, MistakeVaultView, PracticeSessionView, PracticeView, Color, Drug, Int, String (+26 more)

### Community 51 - ".generate"
Cohesion: 0.11
Nodes (19): Encodable, NSObject, DeepSeekRequest, FastGatherPromptBuilder, Message, NameKind, brand, generic (+11 more)

### Community 52 - "ImportedExcretionRoute"
Cohesion: 0.08
Nodes (24): LocalizedError, OSStatus, DoseCalculatorError, ageOutsideRegimen, heightRequired, invalidRegimen, sexOutsideRegimen, weightRequired (+16 more)

### Community 53 - "DrugEditorSection"
Cohesion: 0.20
Nodes (10): DrugCardAnchor, arabic, counseling, identity, mastery, notes, pharmacology, review (+2 more)

### Community 54 - "ImportedDosingFrequency"
Cohesion: 0.09
Nodes (21): OnsetBand, fast, moderate, slow, unknown, ProdrugStatus, active, prodrug (+13 more)

### Community 55 - "ImportedDosingFrequency"
Cohesion: 0.17
Nodes (12): HalfLifeBand, long, medium, short, unknown, veryLong, PKBand, long (+4 more)

### Community 56 - "FocusField"
Cohesion: 0.24
Nodes (9): ConfirmDrugIdentityView, ImportFromPhotoView, ImportMemorizationChallengeView, ImportMode, aiDraft, trusted, ImportSourceSearchView, Data (+1 more)

### Community 57 - "SafetyFlag"
Cohesion: 0.22
Nodes (9): AVFoundation, CounselingBuilderView, DrugBrandsSheet, addProduct, DrugBrandsView, Item, SafetySortView, Set (+1 more)

### Community 58 - "Components.swift"
Cohesion: 0.22
Nodes (7): BackupImportPreviewView, Int, Void, BackupRestoreMode, merge, replace, BackupRestoreSummary

### Community 59 - "PhotosPickerItem"
Cohesion: 0.22
Nodes (9): ImportSection, adverseEffects, arabicExplanation, counseling, identity, pharmacokinetics, safety, sourceQuality (+1 more)

### Community 60 - "String"
Cohesion: 0.29
Nodes (5): Context, CameraPicker, Any, UIImagePickerController, UIViewControllerRepresentable

### Community 61 - "CGPoint"
Cohesion: 0.11
Nodes (11): CoreTransferable, Foundation, Observation, PrivacyValidator, Bool, String, ReportFile, String (+3 more)

### Community 62 - ".canonicalKey"
Cohesion: 0.20
Nodes (10): DurationBand, long, medium, short, unknown, ImportedDurationBand, long, medium (+2 more)

### Community 63 - ".apply"
Cohesion: 0.22
Nodes (9): CodingKey, CodingKeys, dailyActivities, drugs, encounters, learningProfiles, reports, reviews (+1 more)

### Community 64 - "MemoryReviewGrade"
Cohesion: 0.39
Nodes (4): DrugBackupDTO, Bool, Double, Drug

### Community 65 - "Bool"
Cohesion: 0.25
Nodes (6): CropGrid, CropViewportState, CGPoint, Path, Shape, UIEdgeInsets

### Community 66 - "DeepSeekURLProtocolStub"
Cohesion: 0.18
Nodes (11): ExcretionRoute, hepatic, mixed, renal, unknown, ImportedExcretionRoute, hepatic, mixed (+3 more)

### Community 67 - "VerificationStatus"
Cohesion: 0.12
Nodes (16): DosingFrequency, asNeeded, fourTimesDaily, onceDaily, other, threeTimesDaily, twiceDaily, unknown (+8 more)

### Community 68 - "DrugBackupDTO"
Cohesion: 0.27
Nodes (7): ReportView, Drug, TrainingReport, ReportBuilder, Calendar, Drug, String

### Community 70 - "MemoryReviewGrade"
Cohesion: 0.40
Nodes (5): BackupError, duplicateIdentifiers, invalidCounts, malformed, newerVersion

### Community 71 - "BackupImportPreviewView"
Cohesion: 0.25
Nodes (7): Int, ImportStage, challenge, confirm, photo, preview, source

### Community 72 - "ExcretionRoute"
Cohesion: 0.14
Nodes (13): PracticeInteraction, multipleChoice, recall, textEntry, trueFalse, QuestionType, casePractice, counseling (+5 more)

### Community 73 - "SafetyFlag"
Cohesion: 0.25
Nodes (8): SafetyFlag, anticoagulant, children, controlledDrug, corticosteroid, insulin, pregnancy, severeSymptoms

### Community 74 - "AppTheme"
Cohesion: 0.29
Nodes (6): App, LinearGradient, AppTheme, Color, PharmaShiftApp, Scene

### Community 75 - "Double"
Cohesion: 0.27
Nodes (4): AltibbiProvider, DrugSearchRanker, DrugSearchResult, URL

### Community 80 - "VerificationStatus"
Cohesion: 0.35
Nodes (9): DailyActivity, EncounterNote, LearningProfile, ReviewLog, ShiftLog, Bool, Date, Int (+1 more)

### Community 82 - "VerificationStatus"
Cohesion: 0.50
Nodes (4): VerificationStatus, pendingPharmacist, personal, pharmacistVerified

### Community 84 - "String"
Cohesion: 0.15
Nodes (8): HTTPURLResponse, DeepSeekURLProtocolStub, DrugImportServiceTests, Bool, Data, String, URLRequest, URLProtocol

## Knowledge Gaps
- **346 isolated node(s):** `home`, `library`, `capture`, `practice`, `more` (+341 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **4 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Chapter` connect `DurationBand` to `Drug`, `LibraryView`, `MemoryReviewGrade`, `ShiftView`, `AppTheme`, `DurationBand`, `Codable`, `VerificationStatus`, `Color`, `ModelAndPersistenceTests`, `DrugImportView.swift`, `ReportEditorView`?**
  _High betweenness centrality (0.083) - this node is a cross-community bridge._
- **Why does `SwiftData` connect `CaseIterable` to `Drug`, `LibraryView`, `DosingFrequency`, `AppTheme`, `ShiftView`, `DosingFrequency`, `Codable`, `ImageCapture.swift`, `DurationBand`, `HomeView`, `Color`, `FocusField`, `SafetyFlag`, `Foundation`, `.apply`?**
  _High betweenness centrality (0.074) - this node is a cross-community bridge._
- **Why does `Foundation` connect `CGPoint` to `Drug`, `DosingFrequency`, `CaseIterable`, `Codable`, `PracticeQuestion`, `Foundation`, `.apply`?**
  _High betweenness centrality (0.049) - this node is a cross-community bridge._
- **What connects `home`, `library`, `capture` to the rest of the system?**
  _346 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Drug` be split into smaller, more focused modules?**
  _Cohesion score 0.14583333333333334 - nodes in this community are weakly interconnected._
- **Should `String` be split into smaller, more focused modules?**
  _Cohesion score 0.12315270935960591 - nodes in this community are weakly interconnected._
- **Should `Chapter` be split into smaller, more focused modules?**
  _Cohesion score 0.13768115942028986 - nodes in this community are weakly interconnected._