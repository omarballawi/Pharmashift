# Graph Report - pharmashift  (2026-07-15)

## Corpus Check
- 45 files · ~198,045 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1410 nodes · 3789 edges · 76 communities (72 shown, 4 thin omitted)
- Extraction: 95% EXTRACTED · 5% INFERRED · 0% AMBIGUOUS · INFERRED: 173 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `150d1106`
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
- [[_COMMUNITY_BackupImportPreviewView|BackupImportPreviewView]]
- [[_COMMUNITY_ExcretionRoute|ExcretionRoute]]
- [[_COMMUNITY_AppTheme|AppTheme]]
- [[_COMMUNITY_Double|Double]]
- [[_COMMUNITY_VerificationStatus|VerificationStatus]]
- [[_COMMUNITY_String|String]]

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

## Communities (76 total, 4 thin omitted)

### Community 0 - "ShiftLog"
Cohesion: 0.20
Nodes (8): DrugImportView, Bool, Drug, PhotosPickerItem, DrugPackageRecognizing, DrugSourceProvider, FastDrugGatheringService, TrustedDrugSourcePacket

### Community 1 - "SwiftUI"
Cohesion: 0.14
Nodes (14): Coordinator, CropViewportState, NativeCropScrollView, Bool, CGSize, Int, UIEdgeInsets, UIImagePickerControllerDelegate (+6 more)

### Community 2 - "Drug"
Cohesion: 0.24
Nodes (14): BackupRecordCounts, DailyActivityBackupDTO, DrugProductBackupDTO, DrugRelationshipBackupDTO, EncounterBackupDTO, LearningProfileBackupDTO, PharmaShiftBackup, ReviewBackupDTO (+6 more)

### Community 3 - "ImageCapture.swift"
Cohesion: 0.13
Nodes (13): OSStatus, LearningSettingsView, Binding, Bool, DeepSeekKeyStore, KeyStoreError, keychain, readBackFailed (+5 more)

### Community 4 - "String"
Cohesion: 0.16
Nodes (11): deepSeekHTTPStatus, DrugImportValidator, ProfileGenerationGroup, adverseEffects, counselingAndLearning, identityAndDosing, interactionsAndWarnings, reproductiveAndPharmacology (+3 more)

### Community 5 - "Chapter"
Cohesion: 0.12
Nodes (16): DoseCalculator, DoseFormulaKind, fixed, mgPerKgPerDay, mgPerKgPerDose, mgPerSquareMeter, DosePatientInput, DosePopulation (+8 more)

### Community 6 - "QuestionType"
Cohesion: 0.16
Nodes (7): DrugRelationshipRefreshService, DrugSearchRanker, DrugSearchResult, MockDrugSourceProvider, Int, ModelContext, TrustedDrugSourcePacketExtractor

### Community 7 - "LibraryView"
Cohesion: 0.17
Nodes (9): NSNumber, DeepSeekJSONSanitizer, memorization, PromptBuilder, Any, Bool, Data, Set (+1 more)

### Community 8 - "PracticeSessionView"
Cohesion: 0.17
Nodes (13): FlowChips, ImportPreviewView, Binding, Color, Content, String, ImportSelection, Severity (+5 more)

### Community 9 - "ShiftView"
Cohesion: 0.07
Nodes (32): report, ReportEditorView, ReportView, Binding, Date, Double, Drug, ReferenceWritableKeyPath (+24 more)

### Community 10 - "Identifiable"
Cohesion: 0.07
Nodes (29): CodingKeys, adverseReactions, boxedWarning, brandName, clinicalPharmacology, contraindications, dosageAndAdministration, dosageForm (+21 more)

### Community 11 - "SafetyFlag"
Cohesion: 0.43
Nodes (4): ObservableObject, CounselingSpeechRecognizer, SFSpeechAudioBufferRecognitionRequest, SFSpeechRecognitionTask

### Community 12 - "DosingFrequency"
Cohesion: 0.09
Nodes (20): Drug, FocusAction, addDrug, finishShift, practiceWeak, reviewDue, FocusModeEngine, FocusRecommendation (+12 more)

### Community 13 - ".image"
Cohesion: 0.24
Nodes (4): openRouterHTTPStatus, OpenRouterKeyStore, OpenRouterPackageVisionService, UserDefaults

### Community 14 - "Build and install PharmaShift using only Windows"
Cohesion: 0.15
Nodes (10): Final Release Gate, PharmaShift Delivery Roadmap, Phase 2 - Visual Pharmacology and Safety, Phase 3 - Backup, Restore, and Export, Phase 4 - Drug Information Import, Phase 5 - Focus, Practice, and Motivation, Renlyst, 1. Build the IPA on GitHub (+2 more)

### Community 15 - "CaseIterable"
Cohesion: 0.19
Nodes (8): PharmaShift, DailyRefreshView, MistakeVaultView, ReportBuilderTests, SwiftData, UIKit, XCTest, XCTestCase

### Community 16 - "Codable"
Cohesion: 0.21
Nodes (34): Codable, Equatable, Hashable, Identifiable, Item, AdverseEffectEntry, AtomicDrugNote, ClinicalDoseEntry (+26 more)

### Community 17 - "ImageCapture.swift"
Cohesion: 0.13
Nodes (17): Error, FileDocument, FileWrapper, BackupDataView, BackupExportKind, complete, csv, lightweight (+9 more)

### Community 18 - "DurationBand"
Cohesion: 0.22
Nodes (12): HomeView, ShelfQuestView, SignalRow, Bool, Color, Double, Drug, Int (+4 more)

### Community 19 - "HomeView"
Cohesion: 0.22
Nodes (8): FocusField, scientific, trade, unknownLabel, SaveAction, another, later, open

### Community 21 - "ModelAndPersistenceTests"
Cohesion: 0.14
Nodes (11): CaptureView, Binding, Bool, Data, Drug, Int, PhotosPickerItem, String (+3 more)

### Community 22 - "QuestionType"
Cohesion: 0.23
Nodes (5): BackupService, Data, ModelContext, BackupServiceTests, ModelContainer

### Community 23 - "HomeView"
Cohesion: 0.19
Nodes (4): DrugDetailView, Color, Content, ScrollViewProxy

### Community 24 - "Q: What should PharmaShift do after Phase 1?"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: What should PharmaShift do after Phase 1?, Source Nodes

### Community 25 - "Identifiable"
Cohesion: 0.05
Nodes (32): CoreTransferable, Foundation, DrugFilter, Bool, Calendar, Date, Drug, PrivacyValidator (+24 more)

### Community 26 - "FocusField"
Cohesion: 0.12
Nodes (11): title, DailyMedProvider, DeepSeekDrugImportService, DeepSeekFastDrugGatherService, DrugImportFormattingService, DrugSourceProviderFactory, MockDeepSeekDrugImportService, OpenFDALabelProvider (+3 more)

### Community 27 - "DrugImportView.swift"
Cohesion: 0.06
Nodes (47): ClosedRange, PKTimelineChallengeView, DrugEditorView, Binding, Bool, Double, Drug, Int (+39 more)

### Community 28 - "Foundation"
Cohesion: 0.15
Nodes (20): CoreFoundation, Encodable, Choice, DailyMedSearchItem, DailyMedSearchPayload, DeepSeekRequest, DeepSeekResponse, FastGatherPromptBuilder (+12 more)

### Community 29 - "ReportEditorView"
Cohesion: 0.08
Nodes (23): ConfidenceLevel, mastered, medium, strong, weak, DurationBand, long, medium (+15 more)

### Community 30 - "Path"
Cohesion: 0.33
Nodes (6): DrugEvidenceQuality, aiUnverified, altibbi, manual, officialLabel, productLeaflet

### Community 31 - ".apply"
Cohesion: 0.12
Nodes (10): LibrarySection, cards, compare, graph, LibraryView, CGPoint, CGSize, Int (+2 more)

### Community 32 - "Design"
Cohesion: 0.17
Nodes (11): Accessibility floor, Aesthetic direction, Brand voice, Color tokens, Core component inventory, Design, Dials, Last updated (+3 more)

### Community 33 - "PharmacologyScale"
Cohesion: 0.14
Nodes (14): AppNavigation, Chapter, antibiotics, cardiovascular, dermatology, earNoseOropharynx, endocrine, eye (+6 more)

### Community 34 - "SwiftData"
Cohesion: 0.15
Nodes (8): ProductLeafletEditorView, Binding, Data, PhotosPickerItem, ImageFlowDestination, camera, crop, library

### Community 35 - "LibraryView"
Cohesion: 0.19
Nodes (8): CompareCanvasView, DrugRow, KnowledgeGraphView, LibraryFilterView, Binding, Bool, Drug, UUID

### Community 36 - "ReviewRating"
Cohesion: 0.28
Nodes (4): PharmaShiftUITests, Int, XCUIApplication, XCUIElement

### Community 37 - ".generate"
Cohesion: 0.15
Nodes (13): DrugProfileSection, adverse, brands, counseling, doses, forms, interactions, notes (+5 more)

### Community 38 - "SafetyRadar"
Cohesion: 0.13
Nodes (14): AVFoundation, CounselingBuilderView, DoseRegimensView, LocalDrugGraphView, MechanismBuilderView, SafetySortView, CGPoint, CGSize (+6 more)

### Community 39 - "StarterContent"
Cohesion: 0.37
Nodes (4): CGRect, ImageCompressor, CGFloat, UIImage

### Community 40 - "MemoryReviewGrade"
Cohesion: 0.16
Nodes (9): InteractionCategory, contraindicated, minor, monitorClosely, seriousUseAlternative, unknown, Decoder, Encoder (+1 more)

### Community 41 - "DosingFrequency"
Cohesion: 0.15
Nodes (12): CaseIterable, AboutView, AppShell, AppTab, capture, home, library, more (+4 more)

### Community 42 - "SafetyRadar"
Cohesion: 0.29
Nodes (5): Context, CameraPicker, Any, UIImagePickerController, UIViewControllerRepresentable

### Community 43 - "DrugRelationshipKind"
Cohesion: 0.22
Nodes (9): CodingKey, CodingKeys, dailyActivities, drugs, encounters, learningProfiles, reports, reviews (+1 more)

### Community 44 - "ImportedDosingFrequency"
Cohesion: 0.20
Nodes (10): DrugDetailSheet, atomicNotes, counselingBuilder, editor, mechanism, pkTimeline, regenerateReview, review (+2 more)

### Community 45 - ".record"
Cohesion: 0.29
Nodes (7): EliminationPathway, biliaryFecal, mixed, other, pulmonary, renalUrine, unknown

### Community 46 - "Binding"
Cohesion: 0.40
Nodes (5): DrugRelationshipKind, contraindicatedCombination, interaction, relatedUse, sameClass

### Community 47 - "DurationBand"
Cohesion: 0.12
Nodes (21): GeneratedReviewQuestion, PracticeAnswer, PracticeInteraction, multipleChoice, recall, textEntry, trueFalse, PracticeSessionResult (+13 more)

### Community 48 - "DrugEditorSection"
Cohesion: 0.29
Nodes (3): DrugLibraryMigrationService, IngredientIdentity, ModelContext

### Community 49 - "PracticeQuestion"
Cohesion: 0.05
Nodes (47): Decodable, PracticeSessionView, PracticeView, Color, Drug, Int, String, MemoryReviewGrade (+39 more)

### Community 50 - "Color"
Cohesion: 0.15
Nodes (13): PracticeMode, casePractice, classExamples, counseling, drugUse, drugWarning, dueReview, imageQuiz (+5 more)

### Community 51 - ".generate"
Cohesion: 0.18
Nodes (9): NSObject, NameKind, brand, generic, SPLParser, SPLXMLDelegate, Data, XMLParser (+1 more)

### Community 52 - "ImportedExcretionRoute"
Cohesion: 0.10
Nodes (21): LocalizedError, DoseCalculatorError, ageOutsideRegimen, heightRequired, invalidRegimen, sexOutsideRegimen, weightRequired, DrugImportError (+13 more)

### Community 53 - "DrugEditorSection"
Cohesion: 0.20
Nodes (10): DrugCardAnchor, arabic, counseling, identity, mastery, notes, pharmacology, review (+2 more)

### Community 54 - "ImportedDosingFrequency"
Cohesion: 0.04
Nodes (45): DosingFrequency, asNeeded, fourTimesDaily, onceDaily, other, threeTimesDaily, twiceDaily, unknown (+37 more)

### Community 55 - "ImportedDosingFrequency"
Cohesion: 0.39
Nodes (4): DrugBackupDTO, Bool, Double, Drug

### Community 56 - "FocusField"
Cohesion: 0.27
Nodes (9): ConfirmDrugIdentityView, ImportFromPhotoView, ImportMemorizationChallengeView, ImportMode, aiDraft, trusted, ImportSourceSearchView, Data (+1 more)

### Community 57 - "SafetyFlag"
Cohesion: 0.28
Nodes (5): HTTPURLResponse, DeepSeekURLProtocolStub, Bool, URLRequest, URLProtocol

### Community 58 - "Components.swift"
Cohesion: 0.22
Nodes (7): BackupImportPreviewView, Int, Void, BackupRestoreMode, merge, replace, BackupRestoreSummary

### Community 59 - "PhotosPickerItem"
Cohesion: 0.22
Nodes (9): ImportSection, adverseEffects, arabicExplanation, counseling, identity, pharmacokinetics, safety, sourceQuality (+1 more)

### Community 60 - "String"
Cohesion: 0.18
Nodes (10): ImageIO, DrugImagePayload, DrugPhotoGalleryView, DrugPhotoView, DrugThumbnailView, ImageDraft, ImageEditorView, Data (+2 more)

### Community 62 - ".canonicalKey"
Cohesion: 0.33
Nodes (6): AtomicNoteKind, confusingPoint, memoryTrick, patientCounseling, shelfObservation, sourceCorrection

### Community 63 - ".apply"
Cohesion: 0.36
Nodes (7): MigrationStage, PersistentModel, CurrentDrugSchema, DrugMigrationPlan, Phase1DrugSchema, SchemaMigrationPlan, VersionedSchema

### Community 64 - "MemoryReviewGrade"
Cohesion: 0.33
Nodes (6): HalfLifeBand, long, medium, short, unknown, veryLong

### Community 65 - "Bool"
Cohesion: 0.22
Nodes (8): DrugEditorSection, basics, counseling, notes, pk, safety, uses, PhotosUI

### Community 66 - "DeepSeekURLProtocolStub"
Cohesion: 0.40
Nodes (5): ExcretionRoute, hepatic, mixed, renal, unknown

### Community 67 - "VerificationStatus"
Cohesion: 0.40
Nodes (5): OnsetBand, fast, moderate, slow, unknown

### Community 68 - "DrugBackupDTO"
Cohesion: 0.40
Nodes (5): BackupError, duplicateIdentifiers, invalidCounts, malformed, newerVersion

### Community 71 - "BackupImportPreviewView"
Cohesion: 0.25
Nodes (7): Int, ImportStage, challenge, confirm, photo, preview, source

### Community 72 - "ExcretionRoute"
Cohesion: 0.40
Nodes (4): CropGrid, CGPoint, Path, Shape

### Community 74 - "AppTheme"
Cohesion: 0.16
Nodes (10): App, LinearGradient, Observation, AppTheme, Color, PharmaShiftApp, PreviewData, ModelContainer (+2 more)

### Community 75 - "Double"
Cohesion: 0.16
Nodes (9): AltibbiProvider, DrugDataConsistencyNormalizer, DrugImportApplier, Double, Drug, URL, Unit, hours (+1 more)

### Community 80 - "VerificationStatus"
Cohesion: 0.19
Nodes (18): DailyActivity, DoseCalculationResult, Drug, DrugFieldEvidence, DrugProduct, DrugRelationship, EncounterNote, LearningProfile (+10 more)

## Knowledge Gaps
- **343 isolated node(s):** `home`, `library`, `capture`, `practice`, `more` (+338 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **4 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Chapter` connect `PharmacologyScale` to `LibraryView`, `ShiftView`, `AppTheme`, `DosingFrequency`, `DosingFrequency`, `DurationBand`, `Codable`, `PracticeQuestion`, `DurationBand`, `VerificationStatus`, `ModelAndPersistenceTests`, `QuestionType`, `DrugImportView.swift`, `ReportEditorView`?**
  _High betweenness centrality (0.087) - this node is a cross-community bridge._
- **Why does `SwiftData` connect `CaseIterable` to `Bool`, `Drug`, `LibraryView`, `SafetyRadar`, `DosingFrequency`, `AppTheme`, `ShiftView`, `DosingFrequency`, `ImageCapture.swift`, `DurationBand`, `HomeView`, `FocusField`, `DrugImportView.swift`, `Foundation`, `ReportEditorView`, `.apply`?**
  _High betweenness centrality (0.066) - this node is a cross-community bridge._
- **Why does `DrugImportView` connect `ShiftLog` to `SwiftData`, `String`, `QuestionType`, `BackupImportPreviewView`, `StarterContent`, `PracticeSessionView`, `Codable`, `PracticeQuestion`, `FocusField`, `FocusField`, `String`?**
  _High betweenness centrality (0.042) - this node is a cross-community bridge._
- **What connects `home`, `library`, `capture` to the rest of the system?**
  _343 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `SwiftUI` be split into smaller, more focused modules?**
  _Cohesion score 0.14461538461538462 - nodes in this community are weakly interconnected._
- **Should `ImageCapture.swift` be split into smaller, more focused modules?**
  _Cohesion score 0.1349206349206349 - nodes in this community are weakly interconnected._
- **Should `Chapter` be split into smaller, more focused modules?**
  _Cohesion score 0.12380952380952381 - nodes in this community are weakly interconnected._