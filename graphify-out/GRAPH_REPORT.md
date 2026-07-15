# Graph Report - pharmashift  (2026-07-15)

## Corpus Check
- 45 files · ~197,829 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1422 nodes · 3753 edges · 84 communities (70 shown, 14 thin omitted)
- Extraction: 95% EXTRACTED · 5% INFERRED · 0% AMBIGUOUS · INFERRED: 170 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `f770dc80`
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
- [[_COMMUNITY_SafetyFlag|SafetyFlag]]
- [[_COMMUNITY_.record|.record]]
- [[_COMMUNITY_ReportFile.swift|ReportFile.swift]]
- [[_COMMUNITY_HalfLifeBand|HalfLifeBand]]
- [[_COMMUNITY_DrugEditorSection|DrugEditorSection]]
- [[_COMMUNITY_PracticeQuestion|PracticeQuestion]]
- [[_COMMUNITY_Color|Color]]
- [[_COMMUNITY_.generate|.generate]]
- [[_COMMUNITY_ImportedExcretionRoute|ImportedExcretionRoute]]
- [[_COMMUNITY_DrugEditorSection|DrugEditorSection]]
- [[_COMMUNITY_.containsObviousIdentifier|.containsObviousIdentifier]]
- [[_COMMUNITY_NameKind|NameKind]]
- [[_COMMUNITY_FocusField|FocusField]]
- [[_COMMUNITY_Unit|Unit]]
- [[_COMMUNITY_Components.swift|Components.swift]]
- [[_COMMUNITY_PhotosPickerItem|PhotosPickerItem]]
- [[_COMMUNITY_String|String]]
- [[_COMMUNITY_CGPoint|CGPoint]]
- [[_COMMUNITY_Bool|Bool]]
- [[_COMMUNITY_.apply|.apply]]
- [[_COMMUNITY_MemoryReviewGrade|MemoryReviewGrade]]
- [[_COMMUNITY_Bool|Bool]]
- [[_COMMUNITY_DeepSeekURLProtocolStub|DeepSeekURLProtocolStub]]
- [[_COMMUNITY_Decoder|Decoder]]
- [[_COMMUNITY_Double|Double]]
- [[_COMMUNITY_String|String]]
- [[_COMMUNITY_MemoryReviewGrade|MemoryReviewGrade]]
- [[_COMMUNITY_Drug|Drug]]
- [[_COMMUNITY_ExcretionRoute|ExcretionRoute]]
- [[_COMMUNITY_Encoder|Encoder]]
- [[_COMMUNITY_Int|Int]]
- [[_COMMUNITY_Double|Double]]
- [[_COMMUNITY_ModelContext|ModelContext]]
- [[_COMMUNITY_Set|Set]]
- [[_COMMUNITY_String|String]]
- [[_COMMUNITY_URL|URL]]
- [[_COMMUNITY_VerificationStatus|VerificationStatus]]
- [[_COMMUNITY_URLRequest|URLRequest]]
- [[_COMMUNITY_String|String]]
- [[_COMMUNITY_String|String]]

## God Nodes (most connected - your core abstractions)
1. `String` - 118 edges
2. `Drug` - 47 edges
3. `Chapter` - 42 edges
4. `DrugEditorView` - 39 edges
5. `DrugImportView` - 39 edges
6. `ImportedDrugInfo` - 38 edges
7. `DeepSeekKeyStore` - 33 edges
8. `CodingKeys` - 32 edges
9. `Drug` - 32 edges
10. `UserConfirmedDrugIdentity` - 29 edges

## Surprising Connections (you probably didn't know these)
- `DrugImportView` --calls--> `DeepSeekIdentityResolver`  [INFERRED]
  PharmaShift/Features/Library/DrugImportView.swift → PharmaShift/Services/DeepSeekLearningService.swift
- `ImportFromPhotoView` --references--> `PackageRecognitionResult`  [EXTRACTED]
  PharmaShift/Features/Library/DrugImportView.swift → PharmaShift/Services/DrugImportService.swift
- `DrugImportView` --references--> `DrugSearchResult`  [EXTRACTED]
  PharmaShift/Features/Library/DrugImportView.swift → PharmaShift/Services/DrugImportService.swift
- `ImportSourceSearchView` --references--> `DrugSearchResult`  [EXTRACTED]
  PharmaShift/Features/Library/DrugImportView.swift → PharmaShift/Services/DrugImportService.swift
- `DrugImportView` --references--> `TrustedDrugSourcePacket`  [EXTRACTED]
  PharmaShift/Features/Library/DrugImportView.swift → PharmaShift/Services/DrugImportService.swift

## Import Cycles
- None detected.

## Communities (84 total, 14 thin omitted)

### Community 0 - "ShiftLog"
Cohesion: 0.24
Nodes (5): DrugImportView, Bool, Drug, PhotosPickerItem, DrugPackageRecognizing

### Community 1 - "SwiftUI"
Cohesion: 0.16
Nodes (11): Coordinator, NativeCropScrollView, Bool, Int, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollView, UIScrollViewDelegate (+3 more)

### Community 2 - "Drug"
Cohesion: 0.17
Nodes (27): Equatable, Hashable, Identifiable, AdverseEffectEntry, AtomicDrugNote, ClinicalDoseEntry, DosageFormGroup, DrugInteractionEntry (+19 more)

### Community 3 - "ImageCapture.swift"
Cohesion: 0.19
Nodes (6): DeepSeekKeyStore, keychain, StorageLocation, appPreferences, keychain, protectedFile

### Community 4 - "String"
Cohesion: 0.11
Nodes (13): Encoder, ProfileGenerationGroup, adverseEffects, counselingAndLearning, dosageFormsAndDosing, identityAndUses, interactions, pharmacology (+5 more)

### Community 5 - "Chapter"
Cohesion: 0.13
Nodes (19): DoseCalculationResult, DoseCalculator, DoseFormulaKind, fixed, mgPerKgPerDay, mgPerKgPerDose, mgPerSquareMeter, DosePatientInput (+11 more)

### Community 6 - "QuestionType"
Cohesion: 0.14
Nodes (9): AdverseEffectEntry, Any, Bool, Data, Double, NSNumber, DeepSeekJSONSanitizer, Set (+1 more)

### Community 7 - "LibraryView"
Cohesion: 0.15
Nodes (8): LearningSettingsView, Binding, Bool, responseFormat, OpenRouterKeyStore, OpenRouterPackageVisionService, Data, UserDefaults

### Community 8 - "PracticeSessionView"
Cohesion: 0.28
Nodes (7): FlowChips, ImportFromPhotoView, ImportPreviewView, Color, Data, String, View

### Community 9 - "ShiftView"
Cohesion: 0.07
Nodes (34): report, ReportEditorView, ReportView, Binding, Date, Double, Drug, ReferenceWritableKeyPath (+26 more)

### Community 10 - "Identifiable"
Cohesion: 0.07
Nodes (29): CodingKeys, adverseReactions, boxedWarning, brandName, clinicalPharmacology, contraindications, dosageAndAdministration, dosageForm (+21 more)

### Community 11 - "SafetyFlag"
Cohesion: 0.26
Nodes (4): PracticeEngineTests, Drug, Int, ModelContainer

### Community 12 - "DosingFrequency"
Cohesion: 0.20
Nodes (11): ImageIO, DrugImagePayload, DrugPhotoGalleryView, DrugPhotoView, DrugThumbnailView, ImageDraft, ImageEditorView, CGFloat (+3 more)

### Community 13 - ".image"
Cohesion: 0.16
Nodes (13): Drug, FocusAction, addDrug, finishShift, practiceWeak, reviewDue, FocusModeEngine, FocusRecommendation (+5 more)

### Community 14 - "Build and install PharmaShift using only Windows"
Cohesion: 0.15
Nodes (10): Final Release Gate, PharmaShift Delivery Roadmap, Phase 2 - Visual Pharmacology and Safety, Phase 3 - Backup, Restore, and Export, Phase 4 - Drug Information Import, Phase 5 - Focus, Practice, and Motivation, Renlyst, 1. Build the IPA on GitHub (+2 more)

### Community 15 - "CaseIterable"
Cohesion: 0.26
Nodes (5): PharmaShift, MigrationFixtureTests, ReportBuilderTests, XCTest, XCTestCase

### Community 16 - "Codable"
Cohesion: 0.06
Nodes (62): ClinicalDoseEntry, Codable, CoreFoundation, Decoder, DosageFormGroup, DoseRegimen, DrugInteractionEntry, DurationBand (+54 more)

### Community 17 - "ImageCapture.swift"
Cohesion: 0.13
Nodes (17): Error, FileDocument, FileWrapper, BackupDataView, BackupExportKind, complete, csv, lightweight (+9 more)

### Community 18 - "DurationBand"
Cohesion: 0.06
Nodes (44): App, LinearGradient, AboutView, AppNavigation, AppShell, AppTab, capture, home (+36 more)

### Community 19 - "HomeView"
Cohesion: 0.05
Nodes (41): CaseIterable, LibrarySection, cards, compare, graph, ConfidenceLevel, mastered, medium (+33 more)

### Community 21 - "ModelAndPersistenceTests"
Cohesion: 0.09
Nodes (19): CaptureView, FocusField, scientific, trade, unknownLabel, SaveAction, another, later (+11 more)

### Community 22 - "QuestionType"
Cohesion: 0.22
Nodes (9): DosingFrequency, ImportedDosingFrequency, fourTimesDaily, onceDaily, other, PRN, threeTimesDaily, twiceDaily (+1 more)

### Community 23 - "HomeView"
Cohesion: 0.10
Nodes (11): DrugDetailSheet, atomicNotes, editor, regenerateReview, review, DrugDetailView, Bool, Color (+3 more)

### Community 24 - "Q: What should PharmaShift do after Phase 1?"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: What should PharmaShift do after Phase 1?, Source Nodes

### Community 25 - "Identifiable"
Cohesion: 0.05
Nodes (32): CoreTransferable, Foundation, Observation, DrugFilter, Bool, Calendar, Date, Drug (+24 more)

### Community 26 - "FocusField"
Cohesion: 0.33
Nodes (7): MigrationStage, PersistentModel, CurrentDrugSchema, DrugMigrationPlan, Phase1DrugSchema, SchemaMigrationPlan, VersionedSchema

### Community 27 - "DrugImportView.swift"
Cohesion: 0.05
Nodes (54): ClosedRange, DrugEditorView, Binding, Bool, Double, Drug, Int, PhotosPickerItem (+46 more)

### Community 28 - "Foundation"
Cohesion: 0.24
Nodes (14): BackupRecordCounts, DailyActivityBackupDTO, DrugProductBackupDTO, DrugRelationshipBackupDTO, EncounterBackupDTO, LearningProfileBackupDTO, PharmaShiftBackup, ReviewBackupDTO (+6 more)

### Community 29 - "ReportEditorView"
Cohesion: 0.29
Nodes (7): DrugEditorSection, basics, counseling, notes, pk, safety, uses

### Community 30 - "Path"
Cohesion: 0.23
Nodes (5): BackupService, Data, ModelContext, BackupServiceTests, ModelContainer

### Community 31 - ".apply"
Cohesion: 0.15
Nodes (14): ConfirmDrugIdentityView, ImportMemorizationChallengeView, ImportMode, aiDraft, trusted, ImportSourceSearchView, ImportStage, challenge (+6 more)

### Community 32 - "Design"
Cohesion: 0.17
Nodes (11): Accessibility floor, Aesthetic direction, Brand voice, Color tokens, Core component inventory, Design, Dials, Last updated (+3 more)

### Community 33 - "PharmacologyScale"
Cohesion: 0.25
Nodes (6): Color, MemoryReviewGrade, again, easy, good, hard

### Community 34 - "SwiftData"
Cohesion: 0.40
Nodes (4): CGRect, ImageCompressor, CGSize, UIImage

### Community 35 - "LibraryView"
Cohesion: 0.15
Nodes (6): LibraryView, CGPoint, CGSize, Int, Int, ModelContext

### Community 36 - "ReviewRating"
Cohesion: 0.28
Nodes (4): PharmaShiftUITests, Int, XCUIApplication, XCUIElement

### Community 37 - ".generate"
Cohesion: 0.35
Nodes (4): PracticeSessionView, Drug, String, PracticeQuestion

### Community 38 - "SafetyRadar"
Cohesion: 0.13
Nodes (9): AtomicNotesView, DoseRegimensView, LocalDrugGraphView, CGPoint, CGSize, Double, Drug, Int (+1 more)

### Community 39 - "StarterContent"
Cohesion: 0.28
Nodes (5): CompareCanvasView, DrugRow, Binding, Drug, UUID

### Community 40 - "MemoryReviewGrade"
Cohesion: 0.25
Nodes (7): InteractionCategory, contraindicated, minor, monitorClosely, seriousUseAlternative, unknown, Encoder

### Community 41 - "DosingFrequency"
Cohesion: 0.21
Nodes (8): LibraryFilterView, Bool, DailyRefreshView, MistakeVaultView, PhotosUI, SwiftData, SwiftUI, UIKit

### Community 42 - "SafetyRadar"
Cohesion: 0.29
Nodes (7): ExcretionRoute, ImportedExcretionRoute, hepatic, mixed, other, renal, unknown

### Community 43 - "DrugRelationshipKind"
Cohesion: 0.38
Nodes (3): PracticeGenerator, Drug, Int

### Community 44 - "SafetyFlag"
Cohesion: 0.29
Nodes (7): HalfLifeBand, PKBand, long, medium, short, unknown, veryLong

### Community 45 - ".record"
Cohesion: 0.29
Nodes (3): DrugLibraryMigrationService, Decoder, ModelContext

### Community 46 - "ReportFile.swift"
Cohesion: 0.33
Nodes (6): AtomicNoteKind, confusingPoint, memoryTrick, patientCounseling, shelfObservation, sourceCorrection

### Community 47 - "HalfLifeBand"
Cohesion: 0.40
Nodes (5): DrugRelationshipKind, contraindicatedCombination, interaction, relatedUse, sameClass

### Community 48 - "DrugEditorSection"
Cohesion: 0.15
Nodes (13): DrugCardPage, adverse, brands, counseling, doses, forms, interactions, notes (+5 more)

### Community 49 - "PracticeQuestion"
Cohesion: 0.06
Nodes (44): Decodable, PracticeView, Int, AIPracticePack, AIPracticePackStore, AIPracticePayload, AIPracticeQuestion, Choice (+36 more)

### Community 50 - "Color"
Cohesion: 0.14
Nodes (13): PracticeMode, casePractice, classExamples, counseling, drugUse, drugWarning, dueReview, imageQuiz (+5 more)

### Community 51 - ".generate"
Cohesion: 0.12
Nodes (10): AltibbiProvider, DeepSeekDrugImportService, DeepSeekFastDrugGatherService, DrugSourceProvider, OpenFDALabelProvider, RxNormProvider, URL, URLRequest (+2 more)

### Community 52 - "ImportedExcretionRoute"
Cohesion: 0.08
Nodes (25): LocalizedError, OSStatus, DoseCalculatorError, ageOutsideRegimen, heightRequired, invalidRegimen, sexOutsideRegimen, weightRequired (+17 more)

### Community 53 - "DrugEditorSection"
Cohesion: 0.20
Nodes (10): DrugCardAnchor, arabic, counseling, identity, mastery, notes, pharmacology, review (+2 more)

### Community 54 - ".containsObviousIdentifier"
Cohesion: 0.67
Nodes (3): DrugBrandsSheet, addProduct, DrugBrandsView

### Community 55 - "NameKind"
Cohesion: 0.67
Nodes (3): NameKind, brand, generic

### Community 56 - "FocusField"
Cohesion: 0.21
Nodes (13): Encodable, NSObject, DailyMedProvider, DailyMedSearchItem, DeepSeekRequest, Message, ResponseFormat, SPLParser (+5 more)

### Community 57 - "Unit"
Cohesion: 0.67
Nodes (3): Unit, hours, minutes

### Community 58 - "Components.swift"
Cohesion: 0.22
Nodes (7): BackupImportPreviewView, Int, Void, BackupRestoreMode, merge, replace, BackupRestoreSummary

### Community 59 - "PhotosPickerItem"
Cohesion: 0.17
Nodes (12): Content, ImportSection, adverseEffects, arabicExplanation, counseling, identity, memorization, pharmacokinetics (+4 more)

### Community 60 - "String"
Cohesion: 0.28
Nodes (5): HTTPURLResponse, DeepSeekURLProtocolStub, Bool, URLRequest, URLProtocol

### Community 63 - ".apply"
Cohesion: 0.22
Nodes (9): CodingKey, CodingKeys, dailyActivities, drugs, encounters, learningProfiles, reports, reviews (+1 more)

### Community 64 - "MemoryReviewGrade"
Cohesion: 0.39
Nodes (4): DrugBackupDTO, Bool, Double, Drug

### Community 65 - "Bool"
Cohesion: 0.15
Nodes (8): ProductLeafletEditorView, Binding, Data, PhotosPickerItem, ImageFlowDestination, camera, crop, library

### Community 69 - "String"
Cohesion: 0.29
Nodes (5): Context, CameraPicker, Any, UIImagePickerController, UIViewControllerRepresentable

### Community 70 - "MemoryReviewGrade"
Cohesion: 0.40
Nodes (5): BackupError, duplicateIdentifiers, invalidCounts, malformed, newerVersion

### Community 72 - "ExcretionRoute"
Cohesion: 0.14
Nodes (13): PracticeInteraction, multipleChoice, recall, textEntry, trueFalse, QuestionType, casePractice, counseling (+5 more)

### Community 75 - "Double"
Cohesion: 0.12
Nodes (9): Drug, Int, ModelContext, DrugDataConsistencyNormalizer, DrugImportApplier, DrugRelationshipRefreshService, DrugSearchRanker, DrugSearchResult (+1 more)

### Community 80 - "VerificationStatus"
Cohesion: 0.13
Nodes (28): DailyActivity, Drug, DrugFieldEvidence, DrugProduct, DrugRelationship, EncounterNote, IngredientComponent, LearningProfile (+20 more)

### Community 83 - "String"
Cohesion: 0.25
Nodes (6): CropGrid, CropViewportState, CGPoint, Path, Shape, UIEdgeInsets

### Community 93 - "String"
Cohesion: 0.17
Nodes (6): deepSeekHTTPStatus, DrugImportValidator, FastGatherPromptBuilder, UserConfirmedDrugIdentity, DrugImportServiceTests, String

## Knowledge Gaps
- **339 isolated node(s):** `CoreFoundation`, `Security`, `unknown`, `short`, `medium` (+334 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **14 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `String` connect `FocusField` to `ImageCapture.swift`, `String`, `QuestionType`, `LibraryView`, `Identifiable`, `Double`, `SafetyRadar`, `SafetyFlag`, `Codable`, `PracticeQuestion`, `.generate`, `ImportedExcretionRoute`, `QuestionType`, `PhotosPickerItem`, `String`?**
  _High betweenness centrality (0.102) - this node is a cross-community bridge._
- **Why does `SwiftData` connect `DosingFrequency` to `Drug`, `ShiftView`, `.image`, `CaseIterable`, `Codable`, `ImageCapture.swift`, `DurationBand`, `.containsObviousIdentifier`, `DrugImportView.swift`, `Foundation`, `.apply`?**
  _High betweenness centrality (0.079) - this node is a cross-community bridge._
- **Why does `Chapter` connect `DurationBand` to `Drug`, `.generate`, `ShiftView`, `DrugRelationshipKind`, `Codable`, `PracticeQuestion`, `VerificationStatus`, `HomeView`, `ModelAndPersistenceTests`, `DrugImportView.swift`, `Path`?**
  _High betweenness centrality (0.069) - this node is a cross-community bridge._
- **Are the 4 inferred relationships involving `String` (e.g. with `.numberValue()` and `.normalize()`) actually correct?**
  _`String` has 4 INFERRED edges - model-reasoned connections that need verification._
- **What connects `CoreFoundation`, `Security`, `unknown` to the rest of the system?**
  _339 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `String` be split into smaller, more focused modules?**
  _Cohesion score 0.10822510822510822 - nodes in this community are weakly interconnected._
- **Should `Chapter` be split into smaller, more focused modules?**
  _Cohesion score 0.12615384615384614 - nodes in this community are weakly interconnected._