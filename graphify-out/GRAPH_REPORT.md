# Graph Report - pharmashift  (2026-07-15)

## Corpus Check
- 45 files · ~197,543 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1404 nodes · 3755 edges · 75 communities (71 shown, 4 thin omitted)
- Extraction: 95% EXTRACTED · 5% INFERRED · 0% AMBIGUOUS · INFERRED: 170 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `659f55e0`
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
- [[_COMMUNITY_Bool|Bool]]
- [[_COMMUNITY_DeepSeekURLProtocolStub|DeepSeekURLProtocolStub]]
- [[_COMMUNITY_DosingFrequency|DosingFrequency]]
- [[_COMMUNITY_DrugBackupDTO|DrugBackupDTO]]
- [[_COMMUNITY_UIImage|UIImage]]
- [[_COMMUNITY_BackupImportPreviewView|BackupImportPreviewView]]
- [[_COMMUNITY_AppTheme|AppTheme]]
- [[_COMMUNITY_String|String]]
- [[_COMMUNITY_BackupError|BackupError]]
- [[_COMMUNITY_FocusField|FocusField]]
- [[_COMMUNITY_SafetyRadar|SafetyRadar]]

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

## Communities (75 total, 4 thin omitted)

### Community 0 - "ShiftLog"
Cohesion: 0.31
Nodes (6): PracticeAnswer, PracticeSessionResult, ReviewRating, correct, partlyCorrect, wrong

### Community 1 - "SwiftUI"
Cohesion: 0.16
Nodes (11): Coordinator, NativeCropScrollView, Bool, Int, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollView, UIScrollViewDelegate (+3 more)

### Community 2 - "Drug"
Cohesion: 0.27
Nodes (20): Hashable, Identifiable, AdverseEffectEntry, AtomicDrugNote, ClinicalDoseEntry, DosageFormGroup, DoseCalculationResult, DoseRegimen (+12 more)

### Community 3 - "ImageCapture.swift"
Cohesion: 0.16
Nodes (7): LearningSettingsView, Binding, Bool, geminiHTTPStatus, GeminiKeyStore, GeminiPackageVisionService, URLRequest

### Community 4 - "String"
Cohesion: 0.17
Nodes (11): deepSeekHTTPStatus, DrugImportValidator, ProfileGenerationGroup, adverseEffects, counselingAndLearning, identityAndDosing, interactionsAndWarnings, reproductiveAndPharmacology (+3 more)

### Community 5 - "Chapter"
Cohesion: 0.29
Nodes (5): DoseCalculator, DosePatientInput, PatientSexAtBirth, female, male

### Community 6 - "QuestionType"
Cohesion: 0.11
Nodes (12): AltibbiProvider, title, DailyMedProvider, DeepSeekFastDrugGatherService, DrugSearchRanker, DrugSearchResult, DrugSourceProviderFactory, MockDrugSourceProvider (+4 more)

### Community 7 - "LibraryView"
Cohesion: 0.29
Nodes (3): PromptBuilder, Data, UInt8

### Community 8 - "PracticeSessionView"
Cohesion: 0.05
Nodes (43): Int, ConfirmDrugIdentityView, DrugImportView, FlowChips, ImportFromPhotoView, ImportMemorizationChallengeView, ImportMode, aiDraft (+35 more)

### Community 9 - "ShiftView"
Cohesion: 0.16
Nodes (16): ActiveShiftCard, ActiveShiftContent, EncounterEditorView, EndShiftView, ShiftPhase, ShiftPhaseRow, ShiftView, Binding (+8 more)

### Community 10 - "Identifiable"
Cohesion: 0.07
Nodes (29): CodingKeys, adverseReactions, boxedWarning, brandName, clinicalPharmacology, contraindications, dosageAndAdministration, dosageForm (+21 more)

### Community 11 - "SafetyFlag"
Cohesion: 0.23
Nodes (6): ObservableObject, CounselingSpeechRecognizer, Bool, VoiceCounselingView, SFSpeechAudioBufferRecognitionRequest, SFSpeechRecognitionTask

### Community 12 - "DosingFrequency"
Cohesion: 0.06
Nodes (33): Drug, FocusAction, addDrug, finishShift, practiceWeak, reviewDue, FocusModeEngine, FocusRecommendation (+25 more)

### Community 14 - "Build and install PharmaShift using only Windows"
Cohesion: 0.15
Nodes (10): Final Release Gate, PharmaShift Delivery Roadmap, Phase 2 - Visual Pharmacology and Safety, Phase 3 - Backup, Restore, and Export, Phase 4 - Drug Information Import, Phase 5 - Focus, Practice, and Motivation, Renlyst, 1. Build the IPA on GitHub (+2 more)

### Community 15 - "CaseIterable"
Cohesion: 0.36
Nodes (4): PharmaShift, SwiftData, UIKit, XCTest

### Community 16 - "Codable"
Cohesion: 0.20
Nodes (15): BackupRecordCounts, BackupRestoreSummary, DailyActivityBackupDTO, DrugProductBackupDTO, DrugRelationshipBackupDTO, EncounterBackupDTO, LearningProfileBackupDTO, PharmaShiftBackup (+7 more)

### Community 17 - "ImageCapture.swift"
Cohesion: 0.13
Nodes (17): Error, FileDocument, FileWrapper, BackupDataView, BackupExportKind, complete, csv, lightweight (+9 more)

### Community 18 - "DurationBand"
Cohesion: 0.07
Nodes (37): AboutView, AppNavigation, AppShell, AppTab, capture, home, library, more (+29 more)

### Community 19 - "HomeView"
Cohesion: 0.22
Nodes (8): DrugEditorSection, basics, counseling, notes, pk, safety, uses, PhotosUI

### Community 21 - "ModelAndPersistenceTests"
Cohesion: 0.09
Nodes (15): CaptureView, Binding, Bool, Data, Drug, Int, PhotosPickerItem, String (+7 more)

### Community 22 - "QuestionType"
Cohesion: 0.29
Nodes (5): Context, CameraPicker, Any, UIImagePickerController, UIViewControllerRepresentable

### Community 23 - "HomeView"
Cohesion: 0.27
Nodes (3): DrugDetailView, Color, String

### Community 24 - "Q: What should PharmaShift do after Phase 1?"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: What should PharmaShift do after Phase 1?, Source Nodes

### Community 25 - "Identifiable"
Cohesion: 0.05
Nodes (34): CoreTransferable, Foundation, DrugFilter, Bool, Calendar, Date, Drug, PrivacyValidator (+26 more)

### Community 26 - "FocusField"
Cohesion: 0.16
Nodes (11): OSStatus, DeepSeekKeyStore, KeyStoreError, keychain, readBackFailed, StorageLocation, appPreferences, keychain (+3 more)

### Community 27 - "DrugImportView.swift"
Cohesion: 0.20
Nodes (11): ImageIO, DrugImagePayload, DrugPhotoGalleryView, DrugPhotoView, DrugThumbnailView, ImageDraft, ImageEditorView, CGFloat (+3 more)

### Community 28 - "Foundation"
Cohesion: 0.12
Nodes (30): CoreFoundation, Decodable, Encodable, Candidate, Choice, Content, DailyMedSearchItem, DailyMedSearchPayload (+22 more)

### Community 29 - "ReportEditorView"
Cohesion: 0.35
Nodes (21): Codable, Equatable, EliminationInfo, EliminationRouteInfo, ProdrugInfo, Flashcard, GeneratedReviewQuestionDTO, ImportedAdverseEffects (+13 more)

### Community 30 - "Path"
Cohesion: 0.18
Nodes (9): NSObject, NameKind, brand, generic, SPLParser, SPLXMLDelegate, Data, XMLParser (+1 more)

### Community 31 - ".apply"
Cohesion: 0.10
Nodes (18): NSNumber, DeepSeekJSONSanitizer, DrugDataConsistencyNormalizer, DrugImportApplier, DrugRelationshipRefreshService, ImportSelection, Any, Bool (+10 more)

### Community 32 - "Design"
Cohesion: 0.17
Nodes (11): Accessibility floor, Aesthetic direction, Brand voice, Color tokens, Core component inventory, Design, Dials, Last updated (+3 more)

### Community 33 - "PharmacologyScale"
Cohesion: 0.09
Nodes (28): AIPracticePack, AIPracticePackStore, AIPracticePayload, AIPracticeQuestion, Choice, CodingKeys, answer, choices (+20 more)

### Community 34 - "SwiftData"
Cohesion: 0.23
Nodes (4): PharmaShiftUITests, Int, XCUIApplication, XCUIElement

### Community 35 - "LibraryView"
Cohesion: 0.10
Nodes (18): BackupImportPreviewView, Int, Void, PKTimelineChallengeView, CompareCanvasView, DrugRow, KnowledgeGraphView, LibraryFilterView (+10 more)

### Community 36 - "ReviewRating"
Cohesion: 0.18
Nodes (6): AtomicNotesView, ProductLeafletEditorView, Binding, Data, PhotosPickerItem, IngredientIdentity

### Community 37 - ".generate"
Cohesion: 0.14
Nodes (13): DrugProfileSection, adverse, brands, counseling, doses, forms, interactions, notes (+5 more)

### Community 38 - "SafetyRadar"
Cohesion: 0.13
Nodes (14): AVFoundation, CounselingBuilderView, DoseRegimensView, Item, LocalDrugGraphView, MechanismBuilderView, SafetySortView, CGPoint (+6 more)

### Community 39 - "StarterContent"
Cohesion: 0.40
Nodes (4): CGRect, ImageCompressor, CGSize, UIImage

### Community 40 - "MemoryReviewGrade"
Cohesion: 0.33
Nodes (4): DrugLibraryMigrationService, IngredientComponent, ModelContext, PackageRecognitionResult

### Community 41 - "DosingFrequency"
Cohesion: 0.17
Nodes (12): HalfLifeBand, long, medium, short, unknown, veryLong, PKBand, long (+4 more)

### Community 42 - "SafetyRadar"
Cohesion: 0.28
Nodes (3): Decoder, Encoder, T

### Community 43 - "DrugRelationshipKind"
Cohesion: 0.22
Nodes (5): BackupService, Data, ModelContext, BackupServiceTests, ModelContainer

### Community 44 - "ImportedDosingFrequency"
Cohesion: 0.20
Nodes (10): DrugDetailSheet, atomicNotes, counselingBuilder, editor, mechanism, pkTimeline, regenerateReview, review (+2 more)

### Community 45 - ".record"
Cohesion: 0.20
Nodes (10): DurationBand, long, medium, short, unknown, ImportedDurationBand, long, medium (+2 more)

### Community 46 - "Binding"
Cohesion: 0.25
Nodes (8): SafetyFlag, anticoagulant, children, controlledDrug, corticosteroid, insulin, pregnancy, severeSymptoms

### Community 47 - "DurationBand"
Cohesion: 0.12
Nodes (14): PracticeInteraction, multipleChoice, recall, textEntry, trueFalse, QuestionType, casePractice, counseling (+6 more)

### Community 48 - "DrugEditorSection"
Cohesion: 0.24
Nodes (11): DailyActivity, DrugRelationship, EncounterNote, LearningProfile, ReviewLog, ShiftLog, Bool, Calendar (+3 more)

### Community 49 - "PracticeQuestion"
Cohesion: 0.15
Nodes (14): DailyRefreshView, MistakeVaultView, PracticeSessionView, PracticeView, Color, Drug, Int, String (+6 more)

### Community 50 - "Color"
Cohesion: 0.20
Nodes (10): OnsetBand, fast, moderate, slow, unknown, ImportedOnsetBand, fast, moderate (+2 more)

### Community 51 - ".generate"
Cohesion: 0.33
Nodes (6): AtomicNoteKind, confusingPoint, memoryTrick, patientCounseling, shelfObservation, sourceCorrection

### Community 52 - "ImportedExcretionRoute"
Cohesion: 0.10
Nodes (21): LocalizedError, DoseCalculatorError, ageOutsideRegimen, heightRequired, invalidRegimen, sexOutsideRegimen, weightRequired, DrugImportError (+13 more)

### Community 53 - "DrugEditorSection"
Cohesion: 0.20
Nodes (10): DrugCardAnchor, arabic, counseling, identity, mastery, notes, pharmacology, review (+2 more)

### Community 54 - "ImportedDosingFrequency"
Cohesion: 0.09
Nodes (22): ExcretionRoute, hepatic, mixed, renal, unknown, ProdrugStatus, active, prodrug (+14 more)

### Community 55 - "ImportedDosingFrequency"
Cohesion: 0.15
Nodes (13): report, ReportEditorView, ReportView, Binding, Date, Drug, ReferenceWritableKeyPath, String (+5 more)

### Community 56 - "FocusField"
Cohesion: 0.33
Nodes (6): DrugEvidenceQuality, aiUnverified, altibbi, manual, officialLabel, productLeaflet

### Community 57 - "SafetyFlag"
Cohesion: 0.40
Nodes (5): ConfidenceLevel, mastered, medium, strong, weak

### Community 58 - "Components.swift"
Cohesion: 0.50
Nodes (3): BackupRestoreMode, merge, replace

### Community 59 - "PhotosPickerItem"
Cohesion: 0.33
Nodes (6): InteractionCategory, contraindicated, minor, monitorClosely, seriousUseAlternative, unknown

### Community 60 - "String"
Cohesion: 0.40
Nodes (5): DosePopulation, adult, geriatric, pediatric, special

### Community 61 - "CGPoint"
Cohesion: 0.50
Nodes (4): VerificationStatus, pendingPharmacist, personal, pharmacistVerified

### Community 62 - ".canonicalKey"
Cohesion: 0.08
Nodes (26): CaseIterable, LibrarySection, cards, compare, graph, DoseFormulaKind, fixed, mgPerKgPerDay (+18 more)

### Community 65 - "Bool"
Cohesion: 0.22
Nodes (9): CodingKey, CodingKeys, dailyActivities, drugs, encounters, learningProfiles, reports, reviews (+1 more)

### Community 66 - "DeepSeekURLProtocolStub"
Cohesion: 0.28
Nodes (5): HTTPURLResponse, DeepSeekURLProtocolStub, Bool, URLRequest, URLProtocol

### Community 67 - "DosingFrequency"
Cohesion: 0.12
Nodes (16): DosingFrequency, asNeeded, fourTimesDaily, onceDaily, other, threeTimesDaily, twiceDaily, unknown (+8 more)

### Community 68 - "DrugBackupDTO"
Cohesion: 0.39
Nodes (4): DrugBackupDTO, Bool, Double, Drug

### Community 73 - "UIImage"
Cohesion: 0.36
Nodes (7): MigrationStage, PersistentModel, CurrentDrugSchema, DrugMigrationPlan, Phase1DrugSchema, SchemaMigrationPlan, VersionedSchema

### Community 75 - "BackupImportPreviewView"
Cohesion: 0.25
Nodes (6): CropGrid, CropViewportState, CGPoint, Path, Shape, UIEdgeInsets

### Community 77 - "AppTheme"
Cohesion: 0.20
Nodes (8): App, LinearGradient, Observation, AppTheme, Color, PharmaShiftApp, Scene, SwiftUI

### Community 82 - "BackupError"
Cohesion: 0.40
Nodes (5): BackupError, duplicateIdentifiers, invalidCounts, malformed, newerVersion

### Community 83 - "FocusField"
Cohesion: 0.22
Nodes (8): FocusField, scientific, trade, unknownLabel, SaveAction, another, later, open

### Community 86 - "SafetyRadar"
Cohesion: 0.06
Nodes (40): ClosedRange, DrugEditorView, Binding, Bool, Double, Drug, Int, PhotosPickerItem (+32 more)

## Knowledge Gaps
- **344 isolated node(s):** `home`, `library`, `capture`, `practice`, `more` (+339 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **4 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Chapter` connect `DurationBand` to `Drug`, `LibraryView`, `ShiftView`, `DosingFrequency`, `AppTheme`, `DrugEditorSection`, `PracticeQuestion`, `ModelAndPersistenceTests`, `SafetyRadar`, `HomeView`, `ReportEditorView`, `.canonicalKey`?**
  _High betweenness centrality (0.076) - this node is a cross-community bridge._
- **Why does `SwiftData` connect `CaseIterable` to `Drug`, `LibraryView`, `SafetyRadar`, `PracticeSessionView`, `ShiftView`, `UIImage`, `DosingFrequency`, `AppTheme`, `.image`, `Codable`, `ImageCapture.swift`, `DurationBand`, `FocusField`, `HomeView`, `PracticeQuestion`, `SafetyRadar`, `Foundation`, `.apply`?**
  _High betweenness centrality (0.075) - this node is a cross-community bridge._
- **Why does `DrugImportView` connect `PracticeSessionView` to `PharmacologyScale`, `LibraryView`, `String`, `QuestionType`, `ModelAndPersistenceTests`, `DrugImportView.swift`, `Foundation`, `ReportEditorView`, `.apply`?**
  _High betweenness centrality (0.049) - this node is a cross-community bridge._
- **What connects `home`, `library`, `capture` to the rest of the system?**
  _344 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `QuestionType` be split into smaller, more focused modules?**
  _Cohesion score 0.10810810810810811 - nodes in this community are weakly interconnected._
- **Should `PracticeSessionView` be split into smaller, more focused modules?**
  _Cohesion score 0.051759834368530024 - nodes in this community are weakly interconnected._
- **Should `Identifiable` be split into smaller, more focused modules?**
  _Cohesion score 0.06896551724137931 - nodes in this community are weakly interconnected._