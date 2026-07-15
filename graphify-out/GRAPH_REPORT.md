# Graph Report - pharmashift  (2026-07-15)

## Corpus Check
- 45 files · ~197,829 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1394 nodes · 3759 edges · 71 communities (69 shown, 2 thin omitted)
- Extraction: 95% EXTRACTED · 5% INFERRED · 0% AMBIGUOUS · INFERRED: 174 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `34fa2f2a`
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
- [[_COMMUNITY_FocusField|FocusField]]
- [[_COMMUNITY_Components.swift|Components.swift]]
- [[_COMMUNITY_PhotosPickerItem|PhotosPickerItem]]
- [[_COMMUNITY_String|String]]
- [[_COMMUNITY_CGPoint|CGPoint]]
- [[_COMMUNITY_.apply|.apply]]
- [[_COMMUNITY_MemoryReviewGrade|MemoryReviewGrade]]
- [[_COMMUNITY_Bool|Bool]]
- [[_COMMUNITY_DeepSeekURLProtocolStub|DeepSeekURLProtocolStub]]
- [[_COMMUNITY_String|String]]
- [[_COMMUNITY_MemoryReviewGrade|MemoryReviewGrade]]
- [[_COMMUNITY_ExcretionRoute|ExcretionRoute]]
- [[_COMMUNITY_Double|Double]]
- [[_COMMUNITY_VerificationStatus|VerificationStatus]]
- [[_COMMUNITY_String|String]]
- [[_COMMUNITY_String|String]]

## God Nodes (most connected - your core abstractions)
1. `Drug` - 47 edges
2. `Chapter` - 43 edges
3. `DrugEditorView` - 39 edges
4. `DrugImportView` - 39 edges
5. `ImportedDrugInfo` - 38 edges
6. `DeepSeekKeyStore` - 33 edges
7. `Drug` - 32 edges
8. `CodingKeys` - 32 edges
9. `DrugImportServiceTests` - 29 edges
10. `UserConfirmedDrugIdentity` - 29 edges

## Surprising Connections (you probably didn't know these)
- `PharmaShiftApp` --calls--> `AppTheme`  [INFERRED]
  PharmaShift/App/PharmaShiftApp.swift → PharmaShift/App/AppTheme.swift
- `DrugImportView` --calls--> `DeepSeekIdentityResolver`  [INFERRED]
  PharmaShift/Features/Library/DrugImportView.swift → PharmaShift/Services/DeepSeekLearningService.swift
- `PreviewData` --calls--> `ShiftLog`  [INFERRED]
  PharmaShift/Shared/PreviewSupport.swift → PharmaShift/Models/Models.swift
- `AppNavigation` --references--> `PracticeMode`  [EXTRACTED]
  PharmaShift/App/AppShell.swift → PharmaShift/Services/PracticeEngine.swift
- `LearningSettingsView` --references--> `LearningProfile`  [EXTRACTED]
  PharmaShift/App/AppShell.swift → PharmaShift/Models/Models.swift

## Import Cycles
- None detected.

## Communities (71 total, 2 thin omitted)

### Community 0 - "ShiftLog"
Cohesion: 0.16
Nodes (11): DrugImportView, ImportMode, aiDraft, trusted, Bool, Data, Drug, PhotosPickerItem (+3 more)

### Community 1 - "SwiftUI"
Cohesion: 0.14
Nodes (14): NSObject, Coordinator, CropViewportState, NativeCropScrollView, Bool, CGSize, UIEdgeInsets, UIImagePickerControllerDelegate (+6 more)

### Community 2 - "Drug"
Cohesion: 0.19
Nodes (19): Hashable, Identifiable, AdverseEffectEntry, ClinicalDoseEntry, DosageFormGroup, DrugInteractionEntry, FormStrength, IngredientComponent (+11 more)

### Community 3 - "ImageCapture.swift"
Cohesion: 0.12
Nodes (13): LearningSettingsView, Binding, Bool, DeepSeekKeyStore, keychain, OpenRouterKeyStore, OpenRouterPackageVisionService, StorageLocation (+5 more)

### Community 4 - "String"
Cohesion: 0.13
Nodes (13): deepSeekHTTPStatus, FastGatherPromptBuilder, ProfileGenerationGroup, adverseEffects, counselingAndLearning, dosageFormsAndDosing, identityAndUses, interactions (+5 more)

### Community 5 - "Chapter"
Cohesion: 0.11
Nodes (21): DoseRegimensView, Double, DoseCalculationResult, DoseCalculator, DoseFormulaKind, fixed, mgPerKgPerDay, mgPerKgPerDose (+13 more)

### Community 6 - "QuestionType"
Cohesion: 0.16
Nodes (9): NSNumber, DeepSeekJSONSanitizer, MockOpenRouterPackageVisionService, PromptBuilder, Any, Bool, Data, Set (+1 more)

### Community 7 - "LibraryView"
Cohesion: 0.32
Nodes (8): PracticeAnswer, PracticeSessionResult, ReviewLog, ReviewRating, correct, partlyCorrect, wrong, String

### Community 8 - "PracticeSessionView"
Cohesion: 0.20
Nodes (13): ConfirmDrugIdentityView, FlowChips, ImportFromPhotoView, ImportMemorizationChallengeView, ImportPreviewView, ImportSourceSearchView, Binding, Color (+5 more)

### Community 9 - "ShiftView"
Cohesion: 0.16
Nodes (16): ActiveShiftCard, ActiveShiftContent, EncounterEditorView, EndShiftView, ShiftPhase, ShiftPhaseRow, ShiftView, Binding (+8 more)

### Community 10 - "Identifiable"
Cohesion: 0.07
Nodes (30): CodingKeys, adverseReactions, boxedWarning, brandName, clinicalPharmacology, contraindications, dosageAndAdministration, dosageForm (+22 more)

### Community 11 - "SafetyFlag"
Cohesion: 0.26
Nodes (4): PracticeEngineTests, Drug, Int, ModelContainer

### Community 12 - "DosingFrequency"
Cohesion: 0.18
Nodes (12): ImageIO, DrugImagePayload, DrugPhotoGalleryView, DrugPhotoView, DrugThumbnailView, ImageDraft, ImageEditorView, CGFloat (+4 more)

### Community 13 - ".image"
Cohesion: 0.16
Nodes (13): Drug, FocusAction, addDrug, finishShift, practiceWeak, reviewDue, FocusModeEngine, FocusRecommendation (+5 more)

### Community 14 - "Build and install PharmaShift using only Windows"
Cohesion: 0.15
Nodes (10): Final Release Gate, PharmaShift Delivery Roadmap, Phase 2 - Visual Pharmacology and Safety, Phase 3 - Backup, Restore, and Export, Phase 4 - Drug Information Import, Phase 5 - Focus, Practice, and Motivation, Renlyst, 1. Build the IPA on GitHub (+2 more)

### Community 15 - "CaseIterable"
Cohesion: 0.36
Nodes (4): PharmaShift, SwiftData, UIKit, XCTest

### Community 16 - "Codable"
Cohesion: 0.05
Nodes (77): Codable, Equatable, EliminationInfo, EliminationPathway, biliaryFecal, mixed, other, pulmonary (+69 more)

### Community 17 - "ImageCapture.swift"
Cohesion: 0.13
Nodes (17): Error, FileDocument, FileWrapper, BackupDataView, BackupExportKind, complete, csv, lightweight (+9 more)

### Community 18 - "DurationBand"
Cohesion: 0.07
Nodes (37): AboutView, AppNavigation, AppShell, AppTab, capture, home, library, more (+29 more)

### Community 19 - "HomeView"
Cohesion: 0.07
Nodes (29): CaseIterable, LibrarySection, cards, compare, graph, ConfidenceLevel, mastered, medium (+21 more)

### Community 21 - "ModelAndPersistenceTests"
Cohesion: 0.09
Nodes (19): CaptureView, FocusField, scientific, trade, unknownLabel, SaveAction, another, later (+11 more)

### Community 22 - "QuestionType"
Cohesion: 0.27
Nodes (6): report, ReportEditorView, Binding, Date, ReferenceWritableKeyPath, String

### Community 23 - "HomeView"
Cohesion: 0.10
Nodes (11): DrugDetailSheet, atomicNotes, editor, regenerateReview, review, DrugDetailView, Bool, Color (+3 more)

### Community 24 - "Q: What should PharmaShift do after Phase 1?"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: What should PharmaShift do after Phase 1?, Source Nodes

### Community 25 - "Identifiable"
Cohesion: 0.08
Nodes (24): DrugFilter, Bool, Calendar, Date, Drug, ReviewScheduler, Bool, Calendar (+16 more)

### Community 26 - "FocusField"
Cohesion: 0.36
Nodes (7): MigrationStage, PersistentModel, CurrentDrugSchema, DrugMigrationPlan, Phase1DrugSchema, SchemaMigrationPlan, VersionedSchema

### Community 27 - "DrugImportView.swift"
Cohesion: 0.06
Nodes (46): ClosedRange, DrugEditorView, Binding, Bool, Double, Drug, Int, PhotosPickerItem (+38 more)

### Community 28 - "Foundation"
Cohesion: 0.21
Nodes (14): BackupRecordCounts, DailyActivityBackupDTO, DrugProductBackupDTO, DrugRelationshipBackupDTO, EncounterBackupDTO, LearningProfileBackupDTO, PharmaShiftBackup, ReviewBackupDTO (+6 more)

### Community 29 - "ReportEditorView"
Cohesion: 0.29
Nodes (7): DrugEditorSection, basics, counseling, notes, pk, safety, uses

### Community 30 - "Path"
Cohesion: 0.23
Nodes (5): BackupService, Data, ModelContext, BackupServiceTests, ModelContainer

### Community 31 - ".apply"
Cohesion: 0.25
Nodes (7): Int, ImportStage, challenge, confirm, photo, preview, source

### Community 32 - "Design"
Cohesion: 0.17
Nodes (11): Accessibility floor, Aesthetic direction, Brand voice, Color tokens, Core component inventory, Design, Dials, Last updated (+3 more)

### Community 33 - "PharmacologyScale"
Cohesion: 0.25
Nodes (6): Color, MemoryReviewGrade, again, easy, good, hard

### Community 34 - "SwiftData"
Cohesion: 0.42
Nodes (3): CGRect, ImageCompressor, UIImage

### Community 35 - "LibraryView"
Cohesion: 0.09
Nodes (14): CompareCanvasView, DrugRow, KnowledgeGraphView, LibraryFilterView, LibraryView, Binding, Bool, CGPoint (+6 more)

### Community 36 - "ReviewRating"
Cohesion: 0.25
Nodes (4): PharmaShiftUITests, Int, XCUIApplication, XCUIElement

### Community 37 - ".generate"
Cohesion: 0.38
Nodes (3): PracticeSessionView, String, PracticeQuestion

### Community 38 - "SafetyRadar"
Cohesion: 0.13
Nodes (13): AtomicNotesView, LocalDrugGraphView, CGPoint, CGSize, Drug, Int, AtomicDrugNote, AtomicNoteKind (+5 more)

### Community 39 - "StarterContent"
Cohesion: 0.15
Nodes (27): CoreFoundation, Decodable, Encodable, APIError, Candidate, Choice, DailyMedSearchItem, DailyMedSearchPayload (+19 more)

### Community 40 - "MemoryReviewGrade"
Cohesion: 0.17
Nodes (9): InteractionCategory, contraindicated, minor, monitorClosely, seriousUseAlternative, unknown, Decoder, Encoder (+1 more)

### Community 41 - "DosingFrequency"
Cohesion: 0.24
Nodes (7): DrugBrandsSheet, addProduct, DrugBrandsView, Double, WeaknessRadarView, PhotosUI, SwiftUI

### Community 42 - "SafetyRadar"
Cohesion: 0.33
Nodes (6): DrugEvidenceQuality, aiUnverified, altibbi, manual, officialLabel, productLeaflet

### Community 43 - "DrugRelationshipKind"
Cohesion: 0.44
Nodes (3): PracticeGenerator, Drug, Int

### Community 44 - "SafetyFlag"
Cohesion: 0.40
Nodes (5): DurationBand, long, medium, short, unknown

### Community 45 - ".record"
Cohesion: 0.26
Nodes (3): DrugLibraryMigrationService, IngredientIdentity, ModelContext

### Community 46 - "ReportFile.swift"
Cohesion: 0.08
Nodes (18): CoreTransferable, Foundation, LinearGradient, Observation, AppTheme, Color, PrivacyValidator, Bool (+10 more)

### Community 47 - "HalfLifeBand"
Cohesion: 0.50
Nodes (4): VerificationStatus, pendingPharmacist, personal, pharmacistVerified

### Community 48 - "DrugEditorSection"
Cohesion: 0.15
Nodes (13): DrugCardPage, adverse, brands, counseling, doses, forms, interactions, notes (+5 more)

### Community 49 - "PracticeQuestion"
Cohesion: 0.08
Nodes (28): AIPracticePack, AIPracticePackStore, AIPracticePayload, AIPracticeQuestion, Choice, CodingKeys, answer, choices (+20 more)

### Community 50 - "Color"
Cohesion: 0.10
Nodes (18): DailyRefreshView, MistakeVaultView, PracticeView, Drug, Int, PracticeMode, casePractice, classExamples (+10 more)

### Community 51 - ".generate"
Cohesion: 0.09
Nodes (14): AltibbiProvider, DailyMedProvider, DeepSeekFastDrugGatherService, DrugRelationshipRefreshService, DrugSearchRanker, DrugSearchResult, DrugSourceProvider, MockDrugSourceProvider (+6 more)

### Community 52 - "ImportedExcretionRoute"
Cohesion: 0.08
Nodes (25): LocalizedError, OSStatus, DoseCalculatorError, ageOutsideRegimen, heightRequired, invalidRegimen, sexOutsideRegimen, weightRequired (+17 more)

### Community 53 - "DrugEditorSection"
Cohesion: 0.20
Nodes (10): DrugCardAnchor, arabic, counseling, identity, mastery, notes, pharmacology, review (+2 more)

### Community 56 - "FocusField"
Cohesion: 0.15
Nodes (10): NameKind, brand, generic, SPLParser, SPLXMLDelegate, Int, TrustedDrugSourcePacket, TrustedDrugSourcePacketExtractor (+2 more)

### Community 58 - "Components.swift"
Cohesion: 0.22
Nodes (7): BackupImportPreviewView, Int, Void, BackupRestoreMode, merge, replace, BackupRestoreSummary

### Community 59 - "PhotosPickerItem"
Cohesion: 0.20
Nodes (10): ImportSection, adverseEffects, arabicExplanation, counseling, identity, memorization, pharmacokinetics, safety (+2 more)

### Community 60 - "String"
Cohesion: 0.22
Nodes (6): HTTPURLResponse, DeepSeekURLProtocolStub, Bool, Data, URLRequest, URLProtocol

### Community 61 - "CGPoint"
Cohesion: 0.50
Nodes (3): App, PharmaShiftApp, Scene

### Community 63 - ".apply"
Cohesion: 0.22
Nodes (9): CodingKey, CodingKeys, dailyActivities, drugs, encounters, learningProfiles, reports, reviews (+1 more)

### Community 64 - "MemoryReviewGrade"
Cohesion: 0.39
Nodes (4): DrugBackupDTO, Bool, Double, Drug

### Community 65 - "Bool"
Cohesion: 0.15
Nodes (8): ProductLeafletEditorView, Binding, Data, PhotosPickerItem, ImageFlowDestination, camera, crop, library

### Community 66 - "DeepSeekURLProtocolStub"
Cohesion: 0.40
Nodes (5): ExcretionRoute, hepatic, mixed, renal, unknown

### Community 69 - "String"
Cohesion: 0.29
Nodes (5): Context, CameraPicker, Any, UIImagePickerController, UIViewControllerRepresentable

### Community 70 - "MemoryReviewGrade"
Cohesion: 0.40
Nodes (5): BackupError, duplicateIdentifiers, invalidCounts, malformed, newerVersion

### Community 72 - "ExcretionRoute"
Cohesion: 0.15
Nodes (14): GeneratedReviewQuestion, PracticeInteraction, multipleChoice, recall, textEntry, trueFalse, QuestionType, casePractice (+6 more)

### Community 75 - "Double"
Cohesion: 0.18
Nodes (7): DrugDataConsistencyNormalizer, DrugImportApplier, Double, Drug, Unit, hours, minutes

### Community 80 - "VerificationStatus"
Cohesion: 0.16
Nodes (18): ReportView, Drug, DailyActivity, Drug, DrugFieldEvidence, DrugProduct, DrugRelationship, EncounterNote (+10 more)

### Community 83 - "String"
Cohesion: 0.40
Nodes (4): CropGrid, CGPoint, Path, Shape

### Community 93 - "String"
Cohesion: 0.18
Nodes (4): DrugImportValidator, UserConfirmedDrugIdentity, DrugImportServiceTests, String

## Knowledge Gaps
- **340 isolated node(s):** `home`, `library`, `capture`, `practice`, `more` (+335 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **2 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Chapter` connect `DurationBand` to `Drug`, `LibraryView`, `.generate`, `LibraryView`, `ShiftView`, `DrugRelationshipKind`, `ReportFile.swift`, `Codable`, `VerificationStatus`, `Color`, `HomeView`, `ModelAndPersistenceTests`, `DrugImportView.swift`, `String`, `Path`?**
  _High betweenness centrality (0.060) - this node is a cross-community bridge._
- **Why does `SwiftData` connect `CaseIterable` to `Drug`, `LibraryView`, `StarterContent`, `PracticeSessionView`, `DosingFrequency`, `ShiftView`, `.image`, `ImageCapture.swift`, `DurationBand`, `Color`, `.containsObviousIdentifier`, `FocusField`, `DrugImportView.swift`, `Foundation`, `CGPoint`?**
  _High betweenness centrality (0.050) - this node is a cross-community bridge._
- **Why does `Foundation` connect `ReportFile.swift` to `Drug`, `StarterContent`, `.image`, `CaseIterable`, `PracticeQuestion`, `DrugImportView.swift`, `Foundation`?**
  _High betweenness centrality (0.041) - this node is a cross-community bridge._
- **What connects `home`, `library`, `capture` to the rest of the system?**
  _340 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `SwiftUI` be split into smaller, more focused modules?**
  _Cohesion score 0.14461538461538462 - nodes in this community are weakly interconnected._
- **Should `ImageCapture.swift` be split into smaller, more focused modules?**
  _Cohesion score 0.11748381128584644 - nodes in this community are weakly interconnected._
- **Should `String` be split into smaller, more focused modules?**
  _Cohesion score 0.12666666666666668 - nodes in this community are weakly interconnected._