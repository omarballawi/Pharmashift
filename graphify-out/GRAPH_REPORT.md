# Graph Report - pharmashift  (2026-07-15)

## Corpus Check
- 45 files · ~197,679 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1405 nodes · 3764 edges · 81 communities (80 shown, 1 thin omitted)
- Extraction: 95% EXTRACTED · 5% INFERRED · 0% AMBIGUOUS · INFERRED: 171 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `c8f75761`
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
- [[_COMMUNITY_DosingFrequency|DosingFrequency]]
- [[_COMMUNITY_DrugBackupDTO|DrugBackupDTO]]
- [[_COMMUNITY_String|String]]
- [[_COMMUNITY_EliminationPathway|EliminationPathway]]
- [[_COMMUNITY_BackupImportPreviewView|BackupImportPreviewView]]
- [[_COMMUNITY_ExcretionRoute|ExcretionRoute]]
- [[_COMMUNITY_String|String]]
- [[_COMMUNITY_AppTheme|AppTheme]]
- [[_COMMUNITY_BackupImportPreviewView|BackupImportPreviewView]]
- [[_COMMUNITY_ReportFile.swift|ReportFile.swift]]
- [[_COMMUNITY_DrugMigrationPlan|DrugMigrationPlan]]
- [[_COMMUNITY_DrugEvidenceQuality|DrugEvidenceQuality]]
- [[_COMMUNITY_SaveAction|SaveAction]]
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
- `DrugImportView` --calls--> `DeepSeekIdentityResolver`  [INFERRED]
  PharmaShift/Features/Library/DrugImportView.swift → PharmaShift/Services/DeepSeekLearningService.swift
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

## Communities (81 total, 1 thin omitted)

### Community 0 - "ShiftLog"
Cohesion: 0.17
Nodes (9): DrugImportView, Bool, Drug, PhotosPickerItem, DrugImportFormattingService, DrugPackageRecognizing, DrugSourceProvider, FastDrugGatheringService (+1 more)

### Community 1 - "SwiftUI"
Cohesion: 0.16
Nodes (11): Coordinator, NativeCropScrollView, Bool, Int, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollView, UIScrollViewDelegate (+3 more)

### Community 2 - "Drug"
Cohesion: 0.24
Nodes (14): BackupRecordCounts, DailyActivityBackupDTO, DrugProductBackupDTO, DrugRelationshipBackupDTO, EncounterBackupDTO, LearningProfileBackupDTO, PharmaShiftBackup, ReviewBackupDTO (+6 more)

### Community 3 - "ImageCapture.swift"
Cohesion: 0.10
Nodes (15): LearningSettingsView, Binding, Bool, DeepSeekKeyStore, geminiHTTPStatus, GeminiKeyStore, GeminiPackageVisionService, keychain (+7 more)

### Community 4 - "String"
Cohesion: 0.12
Nodes (22): deepSeekHTTPStatus, DrugImportValidator, Flashcard, GeneratedReviewQuestionDTO, ImportedAdverseEffects, ImportedArabicExplanation, ImportedCounseling, ImportedDrugInfo (+14 more)

### Community 5 - "Chapter"
Cohesion: 0.12
Nodes (20): DoseRegimensView, DoseCalculationResult, DoseCalculator, DoseFormulaKind, fixed, mgPerKgPerDay, mgPerKgPerDose, mgPerSquareMeter (+12 more)

### Community 6 - "QuestionType"
Cohesion: 0.19
Nodes (5): DrugRelationshipRefreshService, MockDrugSourceProvider, Int, ModelContext, TrustedDrugSourcePacketExtractor

### Community 7 - "LibraryView"
Cohesion: 0.10
Nodes (15): NSNumber, DeepSeekJSONSanitizer, DrugDataConsistencyNormalizer, DrugImportApplier, memorization, PromptBuilder, Any, Data (+7 more)

### Community 8 - "PracticeSessionView"
Cohesion: 0.16
Nodes (18): ConfirmDrugIdentityView, FlowChips, ImportFromPhotoView, ImportMemorizationChallengeView, ImportPreviewView, ImportSourceSearchView, Binding, Color (+10 more)

### Community 9 - "ShiftView"
Cohesion: 0.07
Nodes (34): report, ReportEditorView, ReportView, Binding, Date, Double, Drug, ReferenceWritableKeyPath (+26 more)

### Community 10 - "Identifiable"
Cohesion: 0.07
Nodes (30): CodingKeys, adverseReactions, boxedWarning, brandName, clinicalPharmacology, contraindications, dosageAndAdministration, dosageForm (+22 more)

### Community 11 - "SafetyFlag"
Cohesion: 0.29
Nodes (5): ObservableObject, CounselingSpeechRecognizer, VoiceCounselingView, SFSpeechAudioBufferRecognitionRequest, SFSpeechRecognitionTask

### Community 12 - "DosingFrequency"
Cohesion: 0.10
Nodes (17): Drug, FocusAction, addDrug, finishShift, practiceWeak, reviewDue, FocusModeEngine, FocusRecommendation (+9 more)

### Community 13 - ".image"
Cohesion: 0.18
Nodes (7): PracticeView, Int, AIPracticePack, AIPracticePackStore, DeepSeekPracticeService, Date, Drug

### Community 14 - "Build and install PharmaShift using only Windows"
Cohesion: 0.15
Nodes (10): Final Release Gate, PharmaShift Delivery Roadmap, Phase 2 - Visual Pharmacology and Safety, Phase 3 - Backup, Restore, and Export, Phase 4 - Drug Information Import, Phase 5 - Focus, Practice, and Motivation, Renlyst, 1. Build the IPA on GitHub (+2 more)

### Community 15 - "CaseIterable"
Cohesion: 0.24
Nodes (5): PharmaShift, MigrationFixtureTests, ReportBuilderTests, XCTest, XCTestCase

### Community 16 - "Codable"
Cohesion: 0.15
Nodes (8): HTTPURLResponse, DeepSeekURLProtocolStub, DrugImportServiceTests, Bool, Data, String, URLRequest, URLProtocol

### Community 17 - "ImageCapture.swift"
Cohesion: 0.13
Nodes (17): Error, FileDocument, FileWrapper, BackupDataView, BackupExportKind, complete, csv, lightweight (+9 more)

### Community 18 - "DurationBand"
Cohesion: 0.07
Nodes (37): AboutView, AppNavigation, AppShell, AppTab, capture, home, library, more (+29 more)

### Community 19 - "HomeView"
Cohesion: 0.23
Nodes (8): AVFoundation, DailyRefreshView, MistakeVaultView, PhotosUI, Speech, SwiftData, SwiftUI, UIKit

### Community 21 - "ModelAndPersistenceTests"
Cohesion: 0.09
Nodes (15): CaptureView, Binding, Bool, Data, Drug, Int, PhotosPickerItem, String (+7 more)

### Community 22 - "QuestionType"
Cohesion: 0.23
Nodes (5): BackupService, Data, ModelContext, BackupServiceTests, ModelContainer

### Community 23 - "HomeView"
Cohesion: 0.14
Nodes (6): CounselingBuilderView, DrugDetailView, Bool, Color, Set, ScrollViewProxy

### Community 24 - "Q: What should PharmaShift do after Phase 1?"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: What should PharmaShift do after Phase 1?, Source Nodes

### Community 25 - "Identifiable"
Cohesion: 0.15
Nodes (8): Drug, Bool, Data, Date, Int, String, UUID, ModelAndPersistenceTests

### Community 26 - "FocusField"
Cohesion: 0.10
Nodes (13): AltibbiProvider, DailyMedProvider, DeepSeekDrugImportService, DeepSeekFastDrugGatherService, DrugSearchRanker, DrugSearchResult, DrugSourceProviderFactory, MockDeepSeekDrugImportService (+5 more)

### Community 27 - "DrugImportView.swift"
Cohesion: 0.14
Nodes (17): ClosedRange, PKTimelineChallengeView, Binding, Double, EmptyStateView, LabeledValue, MasteryBadge, MetricCard (+9 more)

### Community 28 - "Foundation"
Cohesion: 0.14
Nodes (30): CoreFoundation, Decodable, Encodable, Candidate, Choice, Content, DailyMedSearchItem, DailyMedSearchPayload (+22 more)

### Community 29 - "ReportEditorView"
Cohesion: 0.18
Nodes (32): Codable, Equatable, Hashable, Identifiable, AdverseEffectEntry, AtomicDrugNote, ClinicalDoseEntry, DosageFormGroup (+24 more)

### Community 30 - "Path"
Cohesion: 0.15
Nodes (10): Item, SafetySortView, DrugLibraryMigrationService, DrugProduct, IngredientIdentity, Data, Decoder, ModelContext (+2 more)

### Community 31 - ".apply"
Cohesion: 0.22
Nodes (9): ImportSection, adverseEffects, arabicExplanation, counseling, identity, pharmacokinetics, safety, sourceQuality (+1 more)

### Community 32 - "Design"
Cohesion: 0.17
Nodes (11): Accessibility floor, Aesthetic direction, Brand voice, Color tokens, Core component inventory, Design, Dials, Last updated (+3 more)

### Community 33 - "PharmacologyScale"
Cohesion: 0.19
Nodes (13): AIPracticePayload, AIPracticeQuestion, Choice, DeepSeekContentResponse, DeepSeekIdentityResolver, DeepSeekJSONClient, DrugIdentityResolving, Message (+5 more)

### Community 34 - "SwiftData"
Cohesion: 0.27
Nodes (7): DrugEditorView, Binding, Bool, Drug, Int, PhotosPickerItem, ReferenceWritableKeyPath

### Community 35 - "LibraryView"
Cohesion: 0.22
Nodes (6): CompareCanvasView, DrugRow, KnowledgeGraphView, Binding, Drug, UUID

### Community 36 - "ReviewRating"
Cohesion: 0.28
Nodes (4): PharmaShiftUITests, Int, XCUIApplication, XCUIElement

### Community 37 - ".generate"
Cohesion: 0.15
Nodes (13): DrugProfileSection, adverse, brands, counseling, doses, forms, interactions, notes (+5 more)

### Community 38 - "SafetyRadar"
Cohesion: 0.13
Nodes (10): AtomicNotesView, LocalDrugGraphView, MechanismBuilderView, ProductLeafletEditorView, CGPoint, CGSize, Data, Drug (+2 more)

### Community 39 - "StarterContent"
Cohesion: 0.40
Nodes (4): CGRect, ImageCompressor, CGSize, UIImage

### Community 40 - "MemoryReviewGrade"
Cohesion: 0.25
Nodes (7): InteractionCategory, contraindicated, minor, monitorClosely, seriousUseAlternative, unknown, Encoder

### Community 41 - "DosingFrequency"
Cohesion: 0.10
Nodes (12): LibraryFilterView, LibrarySection, cards, compare, graph, LibraryView, Bool, CGPoint (+4 more)

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
Cohesion: 0.07
Nodes (30): CaseIterable, ConfidenceLevel, mastered, medium, strong, weak, DrugRelationshipKind, contraindicatedCombination (+22 more)

### Community 46 - "Binding"
Cohesion: 0.20
Nodes (11): SafetySeverity, high, low, medium, unknown, SafetyRadar, CGFloat, CGPoint (+3 more)

### Community 47 - "DurationBand"
Cohesion: 0.14
Nodes (13): PracticeInteraction, multipleChoice, recall, textEntry, trueFalse, QuestionType, casePractice, counseling (+5 more)

### Community 48 - "DrugEditorSection"
Cohesion: 0.18
Nodes (18): DailyActivity, Drug, DrugRelationship, EncounterNote, LearningProfile, MemoryItemState, PracticeAnswer, PracticeSessionResult (+10 more)

### Community 49 - "PracticeQuestion"
Cohesion: 0.35
Nodes (4): PracticeSessionView, Drug, String, PracticeQuestion

### Community 50 - "Color"
Cohesion: 0.15
Nodes (13): PracticeMode, casePractice, classExamples, counseling, drugUse, drugWarning, dueReview, imageQuiz (+5 more)

### Community 51 - ".generate"
Cohesion: 0.33
Nodes (6): AtomicNoteKind, confusingPoint, memoryTrick, patientCounseling, shelfObservation, sourceCorrection

### Community 52 - "ImportedExcretionRoute"
Cohesion: 0.08
Nodes (24): LocalizedError, OSStatus, DoseCalculatorError, ageOutsideRegimen, heightRequired, invalidRegimen, sexOutsideRegimen, weightRequired (+16 more)

### Community 53 - "DrugEditorSection"
Cohesion: 0.20
Nodes (10): DrugCardAnchor, arabic, counseling, identity, mastery, notes, pharmacology, review (+2 more)

### Community 54 - "ImportedDosingFrequency"
Cohesion: 0.06
Nodes (38): ImportedDosingFrequency, fourTimesDaily, onceDaily, other, PRN, threeTimesDaily, twiceDaily, unknown (+30 more)

### Community 55 - "ImportedDosingFrequency"
Cohesion: 0.39
Nodes (4): DrugBackupDTO, Bool, Double, Drug

### Community 56 - "FocusField"
Cohesion: 0.25
Nodes (8): SafetyFlag, anticoagulant, children, controlledDrug, corticosteroid, insulin, pregnancy, severeSymptoms

### Community 57 - "SafetyFlag"
Cohesion: 0.20
Nodes (10): CodingKeys, answer, choices, explanation, finishReason, message, prompt, questions (+2 more)

### Community 58 - "Components.swift"
Cohesion: 0.22
Nodes (7): BackupImportPreviewView, Int, Void, BackupRestoreMode, merge, replace, BackupRestoreSummary

### Community 59 - "PhotosPickerItem"
Cohesion: 0.17
Nodes (5): Foundation, Observation, PrivacyValidator, Bool, String

### Community 60 - "String"
Cohesion: 0.20
Nodes (11): ImageIO, DrugImagePayload, DrugPhotoGalleryView, DrugPhotoView, DrugThumbnailView, ImageDraft, ImageEditorView, CGFloat (+3 more)

### Community 61 - "CGPoint"
Cohesion: 0.44
Nodes (3): PracticeGenerator, Drug, Int

### Community 62 - ".canonicalKey"
Cohesion: 0.29
Nodes (7): DrugEditorSection, basics, counseling, notes, pk, safety, uses

### Community 63 - ".apply"
Cohesion: 0.21
Nodes (8): NSObject, NameKind, brand, generic, SPLParser, SPLXMLDelegate, XMLParser, XMLParserDelegate

### Community 64 - "MemoryReviewGrade"
Cohesion: 0.25
Nodes (6): Color, MemoryReviewGrade, again, easy, good, hard

### Community 65 - "Bool"
Cohesion: 0.33
Nodes (5): Double, PracticeCase, StarterContent, Drug, String

### Community 66 - "DeepSeekURLProtocolStub"
Cohesion: 0.29
Nodes (5): Context, CameraPicker, Any, UIImagePickerController, UIViewControllerRepresentable

### Community 67 - "DosingFrequency"
Cohesion: 0.33
Nodes (6): HalfLifeBand, long, medium, short, unknown, veryLong

### Community 68 - "DrugBackupDTO"
Cohesion: 0.40
Nodes (5): BackupError, duplicateIdentifiers, invalidCounts, malformed, newerVersion

### Community 69 - "String"
Cohesion: 0.22
Nodes (9): DosingFrequency, asNeeded, fourTimesDaily, onceDaily, other, threeTimesDaily, twiceDaily, unknown (+1 more)

### Community 70 - "EliminationPathway"
Cohesion: 0.28
Nodes (5): DrugFilter, Bool, Calendar, Date, Drug

### Community 71 - "BackupImportPreviewView"
Cohesion: 0.25
Nodes (7): Int, ImportStage, challenge, confirm, photo, preview, source

### Community 72 - "ExcretionRoute"
Cohesion: 0.25
Nodes (6): CropGrid, CropViewportState, CGPoint, Path, Shape, UIEdgeInsets

### Community 73 - "String"
Cohesion: 0.50
Nodes (4): FocusField, scientific, trade, unknownLabel

### Community 74 - "AppTheme"
Cohesion: 0.33
Nodes (6): App, LinearGradient, AppTheme, Color, PharmaShiftApp, Scene

### Community 75 - "BackupImportPreviewView"
Cohesion: 0.67
Nodes (3): ImportMode, aiDraft, trusted

### Community 76 - "ReportFile.swift"
Cohesion: 0.29
Nodes (6): CoreTransferable, ReportFile, String, Transferable, TransferRepresentation, UniformTypeIdentifiers

### Community 77 - "DrugMigrationPlan"
Cohesion: 0.33
Nodes (7): MigrationStage, PersistentModel, CurrentDrugSchema, DrugMigrationPlan, Phase1DrugSchema, SchemaMigrationPlan, VersionedSchema

### Community 78 - "DrugEvidenceQuality"
Cohesion: 0.33
Nodes (6): DrugEvidenceQuality, aiUnverified, altibbi, manual, officialLabel, productLeaflet

### Community 79 - "SaveAction"
Cohesion: 0.50
Nodes (4): SaveAction, another, later, open

### Community 80 - "VerificationStatus"
Cohesion: 0.50
Nodes (4): VerificationStatus, pendingPharmacist, personal, pharmacistVerified

## Knowledge Gaps
- **343 isolated node(s):** `home`, `library`, `capture`, `practice`, `more` (+338 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **1 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Chapter` connect `DurationBand` to `Bool`, `SwiftData`, `LibraryView`, `ShiftView`, `AppTheme`, `.image`, `.record`, `DrugEditorSection`, `PracticeQuestion`, `CGPoint`, `ModelAndPersistenceTests`, `QuestionType`, `ReportEditorView`, `Path`?**
  _High betweenness centrality (0.076) - this node is a cross-community bridge._
- **Why does `SwiftData` connect `HomeView` to `Bool`, `Drug`, `PracticeSessionView`, `ShiftView`, `DosingFrequency`, `DosingFrequency`, `CaseIterable`, `ImageCapture.swift`, `DurationBand`, `Foundation`, `ReportEditorView`?**
  _High betweenness centrality (0.076) - this node is a cross-community bridge._
- **Why does `Foundation` connect `PhotosPickerItem` to `PharmacologyScale`, `Drug`, `Bool`, `DosingFrequency`, `ReportFile.swift`, `CaseIterable`, `Foundation`, `ReportEditorView`?**
  _High betweenness centrality (0.046) - this node is a cross-community bridge._
- **What connects `home`, `library`, `capture` to the rest of the system?**
  _343 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `ImageCapture.swift` be split into smaller, more focused modules?**
  _Cohesion score 0.10204081632653061 - nodes in this community are weakly interconnected._
- **Should `String` be split into smaller, more focused modules?**
  _Cohesion score 0.12179487179487179 - nodes in this community are weakly interconnected._
- **Should `Chapter` be split into smaller, more focused modules?**
  _Cohesion score 0.12433862433862433 - nodes in this community are weakly interconnected._