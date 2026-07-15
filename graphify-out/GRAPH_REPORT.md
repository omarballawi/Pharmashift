# Graph Report - pharmashift  (2026-07-15)

## Corpus Check
- 45 files · ~197,799 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1408 nodes · 3775 edges · 73 communities (72 shown, 1 thin omitted)
- Extraction: 95% EXTRACTED · 5% INFERRED · 0% AMBIGUOUS · INFERRED: 171 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `d1770ab5`
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
- [[_COMMUNITY_DrugBackupDTO|DrugBackupDTO]]
- [[_COMMUNITY_String|String]]
- [[_COMMUNITY_BackupImportPreviewView|BackupImportPreviewView]]
- [[_COMMUNITY_ExcretionRoute|ExcretionRoute]]
- [[_COMMUNITY_AppTheme|AppTheme]]
- [[_COMMUNITY_VerificationStatus|VerificationStatus]]

## God Nodes (most connected - your core abstractions)
1. `Drug` - 47 edges
2. `Chapter` - 42 edges
3. `DrugImportView` - 40 edges
4. `DrugEditorView` - 39 edges
5. `ImportedDrugInfo` - 37 edges
6. `DeepSeekKeyStore` - 33 edges
7. `CodingKeys` - 32 edges
8. `Drug` - 31 edges
9. `PracticeQuestion` - 28 edges
10. `ShiftLog` - 28 edges

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

## Communities (73 total, 1 thin omitted)

### Community 0 - "ShiftLog"
Cohesion: 0.05
Nodes (41): DrugImportView, ImportMode, aiDraft, trusted, Bool, Data, Drug, PhotosPickerItem (+33 more)

### Community 1 - "SwiftUI"
Cohesion: 0.14
Nodes (14): NSObject, Coordinator, CropViewportState, NativeCropScrollView, Bool, CGSize, UIEdgeInsets, UIImagePickerControllerDelegate (+6 more)

### Community 2 - "Drug"
Cohesion: 0.21
Nodes (14): BackupRecordCounts, DailyActivityBackupDTO, DrugProductBackupDTO, DrugRelationshipBackupDTO, EncounterBackupDTO, LearningProfileBackupDTO, PharmaShiftBackup, ReviewBackupDTO (+6 more)

### Community 3 - "ImageCapture.swift"
Cohesion: 0.06
Nodes (18): HTTPURLResponse, LearningSettingsView, Binding, Bool, DeepSeekKeyStore, GeminiKeyStore, GeminiPackageVisionService, keychain (+10 more)

### Community 4 - "String"
Cohesion: 0.14
Nodes (13): deepSeekHTTPStatus, DrugImportValidator, FastGatherPromptBuilder, ProfileGenerationGroup, adverseEffects, counselingAndLearning, identityAndDosing, interactionsAndWarnings (+5 more)

### Community 5 - "Chapter"
Cohesion: 0.20
Nodes (14): DoseRegimensView, DailyActivity, DoseCalculationResult, DoseCalculator, DosePatientInput, DoseRegimen, LearningProfile, PatientSexAtBirth (+6 more)

### Community 6 - "QuestionType"
Cohesion: 0.27
Nodes (5): DrugRelationshipRefreshService, DrugSearchRanker, DrugSearchResult, MockDrugSourceProvider, ModelContext

### Community 7 - "LibraryView"
Cohesion: 0.08
Nodes (24): NSNumber, DeepSeekJSONSanitizer, DrugDataConsistencyNormalizer, DrugImportApplier, ImportSection, adverseEffects, arabicExplanation, counseling (+16 more)

### Community 8 - "PracticeSessionView"
Cohesion: 0.12
Nodes (23): AboutView, AppShell, CommandPaletteView, MoreView, Drug, ConfirmDrugIdentityView, FlowChips, ImportFromPhotoView (+15 more)

### Community 9 - "ShiftView"
Cohesion: 0.16
Nodes (16): ActiveShiftCard, ActiveShiftContent, EncounterEditorView, EndShiftView, ShiftPhase, ShiftPhaseRow, ShiftView, Binding (+8 more)

### Community 10 - "Identifiable"
Cohesion: 0.07
Nodes (30): CodingKeys, adverseReactions, boxedWarning, brandName, clinicalPharmacology, contraindications, dosageAndAdministration, dosageForm (+22 more)

### Community 11 - "SafetyFlag"
Cohesion: 0.43
Nodes (4): ObservableObject, CounselingSpeechRecognizer, SFSpeechAudioBufferRecognitionRequest, SFSpeechRecognitionTask

### Community 12 - "DosingFrequency"
Cohesion: 0.10
Nodes (17): Drug, FocusAction, addDrug, finishShift, practiceWeak, reviewDue, FocusModeEngine, FocusRecommendation (+9 more)

### Community 13 - ".image"
Cohesion: 0.33
Nodes (3): PracticeView, Drug, Int

### Community 14 - "Build and install PharmaShift using only Windows"
Cohesion: 0.15
Nodes (10): Final Release Gate, PharmaShift Delivery Roadmap, Phase 2 - Visual Pharmacology and Safety, Phase 3 - Backup, Restore, and Export, Phase 4 - Drug Information Import, Phase 5 - Focus, Practice, and Motivation, Renlyst, 1. Build the IPA on GitHub (+2 more)

### Community 15 - "CaseIterable"
Cohesion: 0.16
Nodes (12): MigrationStage, PersistentModel, PharmaShift, CurrentDrugSchema, DrugMigrationPlan, MigrationFixtureTests, Phase1DrugSchema, ReportBuilderTests (+4 more)

### Community 16 - "Codable"
Cohesion: 0.14
Nodes (35): CoreFoundation, Equatable, OSStatus, Flashcard, GeneratedReviewQuestionDTO, ImportedAdverseEffects, ImportedArabicExplanation, ImportedCounseling (+27 more)

### Community 17 - "ImageCapture.swift"
Cohesion: 0.13
Nodes (17): Error, FileDocument, FileWrapper, BackupDataView, BackupExportKind, complete, csv, lightweight (+9 more)

### Community 18 - "DurationBand"
Cohesion: 0.22
Nodes (12): HomeView, ShelfQuestView, SignalRow, Bool, Color, Double, Drug, Int (+4 more)

### Community 19 - "HomeView"
Cohesion: 0.18
Nodes (10): LibraryFilterView, Bool, Double, WeaknessRadarView, PreviewData, ModelContainer, PhotosUI, SwiftData (+2 more)

### Community 21 - "ModelAndPersistenceTests"
Cohesion: 0.09
Nodes (19): CaptureView, FocusField, scientific, trade, unknownLabel, SaveAction, another, later (+11 more)

### Community 22 - "QuestionType"
Cohesion: 0.22
Nodes (5): BackupService, Data, ModelContext, BackupServiceTests, ModelContainer

### Community 23 - "HomeView"
Cohesion: 0.16
Nodes (4): DrugDetailView, Bool, Color, ScrollViewProxy

### Community 24 - "Q: What should PharmaShift do after Phase 1?"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: What should PharmaShift do after Phase 1?, Source Nodes

### Community 25 - "Identifiable"
Cohesion: 0.11
Nodes (13): DrugFilter, Bool, Calendar, Date, Drug, Drug, Bool, Data (+5 more)

### Community 26 - "FocusField"
Cohesion: 0.11
Nodes (10): AltibbiProvider, DailyMedProvider, DeepSeekDrugImportService, DeepSeekFastDrugGatherService, DrugSourceProviderFactory, OpenFDALabelProvider, URL, URLRequest (+2 more)

### Community 27 - "DrugImportView.swift"
Cohesion: 0.05
Nodes (44): ClosedRange, PKTimelineChallengeView, Double, DrugEditorSection, basics, counseling, notes, pk (+36 more)

### Community 28 - "Foundation"
Cohesion: 0.17
Nodes (24): Decodable, Encodable, APIError, Candidate, Choice, Content, DailyMedSearchItem, DailyMedSearchPayload (+16 more)

### Community 29 - "ReportEditorView"
Cohesion: 0.13
Nodes (33): Codable, Hashable, Identifiable, AdverseEffectEntry, AtomicDrugNote, AtomicNoteKind, confusingPoint, memoryTrick (+25 more)

### Community 30 - "Path"
Cohesion: 0.17
Nodes (11): Item, SafetySortView, DrugEvidenceQuality, aiUnverified, altibbi, manual, officialLabel, productLeaflet (+3 more)

### Community 31 - ".apply"
Cohesion: 0.14
Nodes (14): AppNavigation, Chapter, antibiotics, cardiovascular, dermatology, earNoseOropharynx, endocrine, eye (+6 more)

### Community 32 - "Design"
Cohesion: 0.17
Nodes (11): Accessibility floor, Aesthetic direction, Brand voice, Color tokens, Core component inventory, Design, Dials, Last updated (+3 more)

### Community 33 - "PharmacologyScale"
Cohesion: 0.15
Nodes (8): ProductLeafletEditorView, Binding, Data, PhotosPickerItem, ImageFlowDestination, camera, crop, library

### Community 34 - "SwiftData"
Cohesion: 0.27
Nodes (6): report, ReportEditorView, Binding, Date, ReferenceWritableKeyPath, String

### Community 35 - "LibraryView"
Cohesion: 0.10
Nodes (14): CompareCanvasView, DrugRow, KnowledgeGraphView, LibrarySection, cards, compare, graph, LibraryView (+6 more)

### Community 36 - "ReviewRating"
Cohesion: 0.28
Nodes (4): PharmaShiftUITests, Int, XCUIApplication, XCUIElement

### Community 37 - ".generate"
Cohesion: 0.15
Nodes (13): DrugProfileSection, adverse, brands, counseling, doses, forms, interactions, notes (+5 more)

### Community 38 - "SafetyRadar"
Cohesion: 0.13
Nodes (12): AVFoundation, AtomicNotesView, CounselingBuilderView, LocalDrugGraphView, MechanismBuilderView, CGPoint, CGSize, Drug (+4 more)

### Community 39 - "StarterContent"
Cohesion: 0.42
Nodes (3): CGRect, ImageCompressor, UIImage

### Community 40 - "MemoryReviewGrade"
Cohesion: 0.20
Nodes (8): InteractionCategory, contraindicated, minor, monitorClosely, seriousUseAlternative, unknown, Decoder, Encoder

### Community 41 - "DosingFrequency"
Cohesion: 0.38
Nodes (4): ReportBuilder, Calendar, Drug, String

### Community 42 - "SafetyRadar"
Cohesion: 0.29
Nodes (8): ReviewScheduler, Bool, Calendar, Date, Drug, Int, String, ReviewSchedulerTests

### Community 43 - "DrugRelationshipKind"
Cohesion: 0.22
Nodes (9): CodingKey, CodingKeys, dailyActivities, drugs, encounters, learningProfiles, reports, reviews (+1 more)

### Community 44 - "ImportedDosingFrequency"
Cohesion: 0.20
Nodes (10): DrugDetailSheet, atomicNotes, counselingBuilder, editor, mechanism, pkTimeline, regenerateReview, review (+2 more)

### Community 45 - ".record"
Cohesion: 0.08
Nodes (26): CaseIterable, ConfidenceLevel, mastered, medium, strong, weak, ExcretionRoute, hepatic (+18 more)

### Community 46 - "Binding"
Cohesion: 0.20
Nodes (11): DrugRelationship, DrugRelationshipKind, contraindicatedCombination, interaction, relatedUse, sameClass, SafetySeverity, high (+3 more)

### Community 47 - "DurationBand"
Cohesion: 0.14
Nodes (15): GeneratedReviewQuestion, MemoryItemState, PracticeInteraction, multipleChoice, recall, textEntry, trueFalse, QuestionType (+7 more)

### Community 48 - "DrugEditorSection"
Cohesion: 0.14
Nodes (11): Drug, DrugLibraryMigrationService, DrugProduct, Calendar, Data, ModelContext, VerificationStatus, pendingPharmacist (+3 more)

### Community 49 - "PracticeQuestion"
Cohesion: 0.38
Nodes (3): PracticeSessionView, String, PracticeQuestion

### Community 50 - "Color"
Cohesion: 0.15
Nodes (13): PracticeMode, casePractice, classExamples, counseling, drugUse, drugWarning, dueReview, imageQuiz (+5 more)

### Community 51 - ".generate"
Cohesion: 0.17
Nodes (8): NameKind, brand, generic, SPLParser, SPLXMLDelegate, TrustedDrugSourcePacketExtractor, XMLParser, XMLParserDelegate

### Community 52 - "ImportedExcretionRoute"
Cohesion: 0.09
Nodes (22): LocalizedError, DoseCalculatorError, ageOutsideRegimen, heightRequired, invalidRegimen, sexOutsideRegimen, weightRequired, DrugImportError (+14 more)

### Community 53 - "DrugEditorSection"
Cohesion: 0.20
Nodes (10): DrugCardAnchor, arabic, counseling, identity, mastery, notes, pharmacology, review (+2 more)

### Community 54 - "ImportedDosingFrequency"
Cohesion: 0.06
Nodes (33): ImportedDosingFrequency, fourTimesDaily, onceDaily, other, PRN, threeTimesDaily, twiceDaily, unknown (+25 more)

### Community 55 - "ImportedDosingFrequency"
Cohesion: 0.39
Nodes (4): DrugBackupDTO, Bool, Double, Drug

### Community 56 - "FocusField"
Cohesion: 0.25
Nodes (8): SafetyFlag, anticoagulant, children, controlledDrug, corticosteroid, insulin, pregnancy, severeSymptoms

### Community 57 - "SafetyFlag"
Cohesion: 0.33
Nodes (6): AppTab, capture, home, library, more, practice

### Community 58 - "Components.swift"
Cohesion: 0.22
Nodes (7): BackupImportPreviewView, Int, Void, BackupRestoreMode, merge, replace, BackupRestoreSummary

### Community 59 - "PhotosPickerItem"
Cohesion: 0.12
Nodes (10): CoreTransferable, Foundation, PrivacyValidator, Bool, String, ReportFile, String, Transferable (+2 more)

### Community 60 - "String"
Cohesion: 0.18
Nodes (12): ImageIO, DrugImagePayload, DrugPhotoGalleryView, DrugPhotoView, DrugThumbnailView, ImageDraft, ImageEditorView, CGFloat (+4 more)

### Community 61 - "CGPoint"
Cohesion: 0.44
Nodes (3): PracticeGenerator, Drug, Int

### Community 62 - ".canonicalKey"
Cohesion: 0.40
Nodes (5): DoseFormulaKind, fixed, mgPerKgPerDay, mgPerKgPerDose, mgPerSquareMeter

### Community 63 - ".apply"
Cohesion: 0.40
Nodes (5): DosePopulation, adult, geriatric, pediatric, special

### Community 64 - "MemoryReviewGrade"
Cohesion: 0.25
Nodes (6): Color, MemoryReviewGrade, again, easy, good, hard

### Community 65 - "Bool"
Cohesion: 0.40
Nodes (5): DurationBand, long, medium, short, unknown

### Community 66 - "DeepSeekURLProtocolStub"
Cohesion: 0.29
Nodes (5): Context, CameraPicker, Any, UIImagePickerController, UIViewControllerRepresentable

### Community 68 - "DrugBackupDTO"
Cohesion: 0.40
Nodes (5): BackupError, duplicateIdentifiers, invalidCounts, malformed, newerVersion

### Community 69 - "String"
Cohesion: 0.25
Nodes (8): DosingFrequency, asNeeded, fourTimesDaily, onceDaily, other, threeTimesDaily, twiceDaily, unknown

### Community 71 - "BackupImportPreviewView"
Cohesion: 0.25
Nodes (7): Int, ImportStage, challenge, confirm, photo, preview, source

### Community 72 - "ExcretionRoute"
Cohesion: 0.40
Nodes (4): CropGrid, CGPoint, Path, Shape

### Community 74 - "AppTheme"
Cohesion: 0.22
Nodes (7): App, LinearGradient, Observation, AppTheme, Color, PharmaShiftApp, Scene

### Community 80 - "VerificationStatus"
Cohesion: 0.19
Nodes (14): ReportView, Drug, EncounterNote, PracticeAnswer, PracticeSessionResult, ReviewLog, ReviewRating, correct (+6 more)

## Knowledge Gaps
- **343 isolated node(s):** `home`, `library`, `capture`, `practice`, `more` (+338 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **1 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Chapter` connect `.apply` to `LibraryView`, `ShiftView`, `AppTheme`, `.image`, `.record`, `DrugEditorSection`, `PracticeQuestion`, `DurationBand`, `VerificationStatus`, `CGPoint`, `ModelAndPersistenceTests`, `DrugImportView.swift`, `ReportEditorView`, `Path`?**
  _High betweenness centrality (0.075) - this node is a cross-community bridge._
- **Why does `SwiftData` connect `HomeView` to `Drug`, `SafetyRadar`, `PracticeSessionView`, `ShiftView`, `DosingFrequency`, `CaseIterable`, `Codable`, `ImageCapture.swift`, `DurationBand`, `DrugImportView.swift`, `ReportEditorView`?**
  _High betweenness centrality (0.075) - this node is a cross-community bridge._
- **Why does `DrugImportView` connect `ShiftLog` to `PharmacologyScale`, `String`, `QuestionType`, `BackupImportPreviewView`, `PracticeSessionView`, `LibraryView`, `Codable`, `HomeView`, `String`?**
  _High betweenness centrality (0.047) - this node is a cross-community bridge._
- **What connects `home`, `library`, `capture` to the rest of the system?**
  _343 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `ShiftLog` be split into smaller, more focused modules?**
  _Cohesion score 0.05271629778672032 - nodes in this community are weakly interconnected._
- **Should `SwiftUI` be split into smaller, more focused modules?**
  _Cohesion score 0.14461538461538462 - nodes in this community are weakly interconnected._
- **Should `ImageCapture.swift` be split into smaller, more focused modules?**
  _Cohesion score 0.05639097744360902 - nodes in this community are weakly interconnected._