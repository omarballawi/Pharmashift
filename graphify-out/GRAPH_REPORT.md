# Graph Report - pharmashift  (2026-07-17)

## Corpus Check
- 54 files · ~462,261 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1604 nodes · 4269 edges · 91 communities (87 shown, 4 thin omitted)
- Extraction: 96% EXTRACTED · 4% INFERRED · 0% AMBIGUOUS · INFERRED: 184 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `b521e987`
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
- [[_COMMUNITY_DoseRegimensView|DoseRegimensView]]
- [[_COMMUNITY_Decoder|Decoder]]
- [[_COMMUNITY_ReportFile.swift|ReportFile.swift]]
- [[_COMMUNITY_String|String]]
- [[_COMMUNITY_MemoryReviewGrade|MemoryReviewGrade]]
- [[_COMMUNITY_DrugDetailView.swift|DrugDetailView.swift]]
- [[_COMMUNITY_ExcretionRoute|ExcretionRoute]]
- [[_COMMUNITY_.matches|.matches]]
- [[_COMMUNITY_AIPracticePayload|AIPracticePayload]]
- [[_COMMUNITY_SafetyFlag|SafetyFlag]]
- [[_COMMUNITY_DrugSearchResult|DrugSearchResult]]
- [[_COMMUNITY_DrugDetailSheet|DrugDetailSheet]]
- [[_COMMUNITY_DrugEditorSection|DrugEditorSection]]
- [[_COMMUNITY_DrugEvidenceQuality|DrugEvidenceQuality]]
- [[_COMMUNITY_VerificationStatus|VerificationStatus]]
- [[_COMMUNITY_.isValid|.isValid]]
- [[_COMMUNITY_LibraryCompareView|LibraryCompareView]]
- [[_COMMUNITY_String|String]]
- [[_COMMUNITY_DrugRelationshipKind|DrugRelationshipKind]]
- [[_COMMUNITY_DurationBand|DurationBand]]
- [[_COMMUNITY_MemoryReviewGrade|MemoryReviewGrade]]
- [[_COMMUNITY_DrugDetailView.swift|DrugDetailView.swift]]
- [[_COMMUNITY_SafetySeverity|SafetySeverity]]
- [[_COMMUNITY_.removePhoto|.removePhoto]]
- [[_COMMUNITY_Binding|Binding]]

## God Nodes (most connected - your core abstractions)
1. `View` - 147 edges
2. `Drug` - 48 edges
3. `Chapter` - 41 edges
4. `DrugImportView` - 40 edges
5. `DrugEditorView` - 39 edges
6. `ImportedDrugInfo` - 38 edges
7. `PracticeQuestion` - 37 edges
8. `Drug` - 36 edges
9. `DeepSeekKeyStore` - 33 edges
10. `CodingKeys` - 32 edges

## Surprising Connections (you probably didn't know these)
- `LibraryToolsView` --references--> `View`  [EXTRACTED]
  PharmaShift/Features/Library/Library2View.swift → PharmaShift/App/AppShell.swift
- `ShelfQuestChaptersView` --references--> `View`  [EXTRACTED]
  PharmaShift/Features/Library/Library2View.swift → PharmaShift/App/AppShell.swift
- `PracticeModesView` --references--> `View`  [EXTRACTED]
  PharmaShift/Features/Practice/Practice2View.swift → PharmaShift/App/AppShell.swift
- `PreviewData` --calls--> `ShiftLog`  [INFERRED]
  PharmaShift/Shared/PreviewSupport.swift → PharmaShift/Models/Models.swift
- `AppRoute` --references--> `DrugTopic`  [EXTRACTED]
  PharmaShift/App/AppShell.swift → PharmaShift/Features/Library/DrugOverviewView.swift

## Import Cycles
- None detected.

## Communities (91 total, 4 thin omitted)

### Community 0 - "ShiftLog"
Cohesion: 0.11
Nodes (13): DrugFilter, Bool, Calendar, Date, Drug, Drug, Bool, Data (+5 more)

### Community 1 - "SwiftUI"
Cohesion: 0.15
Nodes (14): Coordinator, CropViewportState, NativeCropScrollView, Bool, CGPoint, CGSize, UIEdgeInsets, UIImagePickerControllerDelegate (+6 more)

### Community 2 - "Drug"
Cohesion: 0.13
Nodes (14): SafetyFlag, anticoagulant, children, controlledDrug, corticosteroid, insulin, pregnancy, severeSymptoms (+6 more)

### Community 3 - "ImageCapture.swift"
Cohesion: 0.30
Nodes (5): DrugLibraryMigrationService, DrugProduct, IngredientComponent, IngredientIdentity, ModelContext

### Community 4 - "String"
Cohesion: 0.13
Nodes (19): NSObject, deepSeekHTTPStatus, ProfileGenerationGroup, adverseEffects, counselingAndLearning, dosageFormsAndDosing, identityAndUses, interactions (+11 more)

### Community 5 - "Chapter"
Cohesion: 0.14
Nodes (22): DoseCalculationResult, DoseCalculator, DoseFormulaKind, fixed, mgPerKgPerDay, mgPerKgPerDose, mgPerSquareMeter, DosePatientInput (+14 more)

### Community 6 - "QuestionType"
Cohesion: 0.15
Nodes (10): DrugImportView, Bool, Drug, PhotosPickerItem, DeepSeekIdentityResolver, DrugIdentityResolving, DrugPackageRecognizing, FastDrugGatheringService (+2 more)

### Community 7 - "LibraryView"
Cohesion: 0.06
Nodes (18): HTTPURLResponse, LearningSettingsView, Binding, Bool, DeepSeekKeyStore, keychain, OpenRouterKeyStore, OpenRouterPackageVisionService (+10 more)

### Community 8 - "PracticeSessionView"
Cohesion: 0.06
Nodes (37): Int, ConfirmDrugIdentityView, FlowChips, ImportFromPhotoView, ImportMemorizationChallengeView, ImportMode, aiDraft, trusted (+29 more)

### Community 9 - "ShiftView"
Cohesion: 0.12
Nodes (15): report, ReportEditorView, ReportView, Binding, Date, Double, Drug, ReferenceWritableKeyPath (+7 more)

### Community 10 - "Identifiable"
Cohesion: 0.07
Nodes (30): CodingKeys, adverseReactions, boxedWarning, brandName, clinicalPharmacology, contraindications, dosageAndAdministration, dosageForm (+22 more)

### Community 11 - "SafetyFlag"
Cohesion: 0.12
Nodes (14): NSNumber, DeepSeekJSONSanitizer, DrugDataConsistencyNormalizer, DrugImportApplier, DrugImportValidator, ImportSelection, Any, Bool (+6 more)

### Community 12 - "DosingFrequency"
Cohesion: 0.16
Nodes (8): DrugImagePayload, DrugPhotoGalleryView, DrugThumbnailView, ImageDraft, ImageEditorView, Drug, Int, Void

### Community 13 - ".image"
Cohesion: 0.16
Nodes (13): NaturalLanguage, Drug, FocusAction, addDrug, finishShift, practiceWeak, reviewDue, FocusModeEngine (+5 more)

### Community 14 - "Build and install PharmaShift using only Windows"
Cohesion: 0.14
Nodes (11): Final Release Gate, PharmaShift Delivery Roadmap, Phase 2 - Visual Pharmacology and Safety, Phase 3 - Backup, Restore, and Export, Phase 4 - Drug Information Import, Phase 5 - Focus, Practice, and Motivation, Renlyst 2.0 — Product and Interface Rebuild, Renlyst (+3 more)

### Community 15 - "CaseIterable"
Cohesion: 0.28
Nodes (9): ProductImagePipeline, ProductPhoto, SafetyRadar, CGFloat, CGPoint, Data, Int, Path (+1 more)

### Community 16 - "Codable"
Cohesion: 0.23
Nodes (31): Codable, Equatable, Hashable, AdverseEffectEntry, ClinicalDoseEntry, DosageFormGroup, DrugInteractionEntry, EliminationInfo (+23 more)

### Community 17 - "ImageCapture.swift"
Cohesion: 0.13
Nodes (17): Error, FileDocument, FileWrapper, BackupDataView, BackupExportKind, complete, csv, lightweight (+9 more)

### Community 18 - "DurationBand"
Cohesion: 0.11
Nodes (18): AppNavigation, AppSheet, addHub, capture, AppShell, Chapter, antibiotics, cardiovascular (+10 more)

### Community 19 - "HomeView"
Cohesion: 0.40
Nodes (5): ConfidenceLevel, mastered, medium, strong, weak

### Community 21 - "ModelAndPersistenceTests"
Cohesion: 0.09
Nodes (15): CaptureView, Binding, Bool, Data, Drug, Int, PhotosPickerItem, String (+7 more)

### Community 22 - "QuestionType"
Cohesion: 0.25
Nodes (8): ImportedDosingFrequency, fourTimesDaily, onceDaily, other, PRN, threeTimesDaily, twiceDaily, unknown

### Community 23 - "HomeView"
Cohesion: 0.12
Nodes (11): DrugDetailSheet, atomicNotes, editor, regenerateReview, review, LegacyDrugDetailView, Bool, Color (+3 more)

### Community 24 - "Q: What should PharmaShift do after Phase 1?"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: What should PharmaShift do after Phase 1?, Source Nodes

### Community 25 - "Identifiable"
Cohesion: 0.41
Nodes (3): DrugBrandService, Drug, ModelContext

### Community 26 - "FocusField"
Cohesion: 0.09
Nodes (22): DrugDeletionSheet, LibraryCompareView, LibraryDrugRow, LibraryKnowledgeMapView, LibraryScope, all, due, needsAttention (+14 more)

### Community 27 - "DrugImportView.swift"
Cohesion: 0.22
Nodes (4): Foundation, PrivacyValidator, Bool, String

### Community 28 - "Foundation"
Cohesion: 0.20
Nodes (16): BackupRecordCounts, DailyActivityBackupDTO, DrugBackupDTO, DrugRelationshipBackupDTO, EncounterBackupDTO, LearningProfileBackupDTO, PharmaShiftBackup, ReviewBackupDTO (+8 more)

### Community 29 - "ReportEditorView"
Cohesion: 0.09
Nodes (27): ArabicSummarySurface, BrandProductRow, DrugBrandsScreen, DrugCounselingScreen, DrugDetailView, DrugDosingScreen, DrugIdentityHeader, DrugIdentityText (+19 more)

### Community 30 - "Path"
Cohesion: 0.21
Nodes (6): BackupService, DrugProductBackupDTO, Data, ModelContext, BackupServiceTests, ModelContainer

### Community 31 - ".apply"
Cohesion: 0.29
Nodes (5): ButtonStyle, Configuration, RenlystPrimaryButtonStyle, RenlystTileButtonStyle, Color

### Community 32 - "Design"
Cohesion: 0.11
Nodes (17): Accessibility floor, Color, Core flows, Design, Dials, Direction, Drug overview, Imagery and icons (+9 more)

### Community 33 - "PharmacologyScale"
Cohesion: 0.40
Nodes (5): PracticeChoiceState, correct, dimmed, idle, incorrect

### Community 34 - "SwiftData"
Cohesion: 0.29
Nodes (6): CGRect, DrugPhotoView, ImageCompressor, CGFloat, Data, UIImage

### Community 35 - "LibraryView"
Cohesion: 0.18
Nodes (12): DrugEditorView, Binding, Bool, Drug, Int, PhotosPickerItem, ReferenceWritableKeyPath, SafetySeverity (+4 more)

### Community 36 - "ReviewRating"
Cohesion: 0.07
Nodes (26): MigrationStage, PersistentModel, PharmaShift, ShelfQuestView, Double, Drug, Int, String (+18 more)

### Community 37 - ".generate"
Cohesion: 0.17
Nodes (11): DailyRefreshView, LegacyPracticeView, MistakeVaultView, PracticeChoiceRow, PracticeQuestionHeader, PracticeSessionView, Color, Drug (+3 more)

### Community 38 - "SafetyRadar"
Cohesion: 0.12
Nodes (15): AtomicNotesView, DoseRegimensView, DrugBrandsSheet, addProduct, DrugBrandsView, LocalDrugGraphView, ProductLeafletEditorView, Binding (+7 more)

### Community 40 - "MemoryReviewGrade"
Cohesion: 0.16
Nodes (9): InteractionCategory, contraindicated, minor, monitorClosely, seriousUseAlternative, unknown, Decoder, Encoder (+1 more)

### Community 41 - "DosingFrequency"
Cohesion: 0.17
Nodes (12): HalfLifeBand, long, medium, short, unknown, veryLong, PKBand, long (+4 more)

### Community 42 - "SafetyRadar"
Cohesion: 0.16
Nodes (4): PracticeEngineTests, Drug, Int, ModelContainer

### Community 43 - "DrugRelationshipKind"
Cohesion: 0.30
Nodes (7): QuestionDifficulty, application, challenge, foundation, PracticeGenerator, Drug, Int

### Community 44 - "SafetyFlag"
Cohesion: 0.29
Nodes (8): ReviewScheduler, Bool, Calendar, Date, Drug, Int, String, ReviewSchedulerTests

### Community 45 - ".record"
Cohesion: 0.17
Nodes (9): BrandProductForm, Binding, Bool, Data, Int, PhotosPickerItem, BrandProductDraft, Bool (+1 more)

### Community 46 - "ReportFile.swift"
Cohesion: 0.09
Nodes (28): AIPracticePackView, Drug, AIPracticePack, AIPracticePackStore, AIPracticePayload, AIPracticeQuestion, Choice, CodingKeys (+20 more)

### Community 47 - "HalfLifeBand"
Cohesion: 0.23
Nodes (9): Destination, PracticeModesView, PracticeSummary, PracticeToolsSection, QuickPracticeSection, RecommendedPracticeCard, Int, String (+1 more)

### Community 48 - "DrugEditorSection"
Cohesion: 0.15
Nodes (13): DrugCardPage, adverse, brands, counseling, doses, forms, interactions, notes (+5 more)

### Community 49 - "PracticeQuestion"
Cohesion: 0.10
Nodes (36): CoreFoundation, Decodable, Encodable, OSStatus, APIError, Candidate, Choice, DailyMedSearchItem (+28 more)

### Community 50 - "Color"
Cohesion: 0.13
Nodes (14): PracticeView, PracticeMode, casePractice, classExamples, counseling, drugUse, drugWarning, dueReview (+6 more)

### Community 51 - ".generate"
Cohesion: 0.22
Nodes (8): ClosedRange, Double, OrbitMark, PharmacologyScale, duration, halfLife, onset, Double

### Community 52 - "ImportedExcretionRoute"
Cohesion: 0.08
Nodes (26): LocalizedError, DoseCalculatorError, ageOutsideRegimen, heightRequired, invalidRegimen, sexOutsideRegimen, weightRequired, DrugImportError (+18 more)

### Community 53 - "DrugEditorSection"
Cohesion: 0.20
Nodes (10): DrugCardAnchor, arabic, counseling, identity, mastery, notes, pharmacology, review (+2 more)

### Community 54 - ".containsObviousIdentifier"
Cohesion: 0.18
Nodes (12): Identifiable, AppTab, library, practice, today, you, PracticeAnswer, PracticeSessionResult (+4 more)

### Community 55 - "NameKind"
Cohesion: 0.33
Nodes (6): AtomicNoteKind, confusingPoint, memoryTrick, patientCounseling, shelfObservation, sourceCorrection

### Community 56 - "FocusField"
Cohesion: 0.09
Nodes (14): DailyMedProvider, DeepSeekFastDrugGatherService, DrugRelationshipRefreshService, DrugSearchRanker, DrugSearchResult, DrugSourceProvider, MockDrugSourceProvider, OpenFDALabelProvider (+6 more)

### Community 57 - "Unit"
Cohesion: 0.12
Nodes (19): AboutView, AddHubView, AddRouteRow, AppRoute, drug, drugTopic, CommandPaletteView, DrugRouteDestination (+11 more)

### Community 58 - "Components.swift"
Cohesion: 0.29
Nodes (6): BackupImportPreviewView, Void, BackupRestoreMode, merge, replace, BackupRestoreSummary

### Community 59 - "PhotosPickerItem"
Cohesion: 0.18
Nodes (11): ExcretionRoute, hepatic, mixed, renal, unknown, ImportedExcretionRoute, hepatic, mixed (+3 more)

### Community 60 - "String"
Cohesion: 0.13
Nodes (13): ImportedOnsetBand, fast, moderate, slow, unknown, ImportedProdrugStatus, active, prodrug (+5 more)

### Community 61 - "CGPoint"
Cohesion: 0.15
Nodes (11): App, LinearGradient, Observation, AppTheme, RenlystLayout, RenlystMotion, CGFloat, Color (+3 more)

### Community 62 - "Bool"
Cohesion: 0.20
Nodes (14): HomeView, AtomicDrugNote, DailyActivity, Drug, DrugFieldEvidence, DrugRelationship, EncounterNote, LearningProfile (+6 more)

### Community 63 - ".apply"
Cohesion: 0.22
Nodes (9): CodingKey, CodingKeys, dailyActivities, drugs, encounters, learningProfiles, reports, reviews (+1 more)

### Community 65 - "Bool"
Cohesion: 0.15
Nodes (13): CaseIterable, OnsetBand, fast, moderate, slow, unknown, ProdrugStatus, active (+5 more)

### Community 66 - "DoseRegimensView"
Cohesion: 0.29
Nodes (7): EliminationPathway, biliaryFecal, mixed, other, pulmonary, renalUrine, unknown

### Community 67 - "Decoder"
Cohesion: 0.17
Nodes (17): ActiveShiftCard, ActiveShiftContent, EncounterEditorView, EndShiftView, ShiftPhase, ShiftPhaseRow, ShiftView, Binding (+9 more)

### Community 68 - "ReportFile.swift"
Cohesion: 0.18
Nodes (10): FocusField, scientific, trade, unknownLabel, SaveAction, another, later, open (+2 more)

### Community 69 - "String"
Cohesion: 0.29
Nodes (5): Context, CameraPicker, Any, UIImagePickerController, UIViewControllerRepresentable

### Community 70 - "MemoryReviewGrade"
Cohesion: 0.40
Nodes (5): BackupError, duplicateIdentifiers, invalidCounts, malformed, newerVersion

### Community 71 - "DrugDetailView.swift"
Cohesion: 0.22
Nodes (12): ImageIO, EmptyStateView, LabeledValue, MasteryBadge, MetricCard, PharmacologyMeter, PharmacologyStatusCard, RenlystEmptyState (+4 more)

### Community 72 - "ExcretionRoute"
Cohesion: 0.15
Nodes (14): GeneratedReviewQuestion, PracticeInteraction, multipleChoice, recall, textEntry, trueFalse, QuestionType, casePractice (+6 more)

### Community 73 - ".matches"
Cohesion: 0.18
Nodes (10): Accessibility & Inclusion, Anti-references, Brand Personality, Design Principles, Platform, Positioning, Product, Product Purpose (+2 more)

### Community 74 - "AIPracticePayload"
Cohesion: 0.22
Nodes (9): DosingFrequency, asNeeded, fourTimesDaily, onceDaily, other, threeTimesDaily, twiceDaily, unknown (+1 more)

### Community 75 - "SafetyFlag"
Cohesion: 0.25
Nodes (8): MemoryAnchor, MemoryAnchorKind, counseling, empty, mechanism, mustKnow, safety, use

### Community 76 - "DrugSearchResult"
Cohesion: 0.26
Nodes (9): RecentStudySection, RecommendedActionCard, CGFloat, Drug, Int, String, Void, TodayHero (+1 more)

### Community 78 - "DrugEditorSection"
Cohesion: 0.29
Nodes (7): DrugEditorSection, basics, counseling, notes, pk, safety, uses

### Community 79 - "DrugEvidenceQuality"
Cohesion: 0.33
Nodes (6): DrugEvidenceQuality, aiUnverified, altibbi, manual, officialLabel, productLeaflet

### Community 80 - "VerificationStatus"
Cohesion: 0.33
Nodes (4): Decoder, Encoder, UnknownImportEnum, RawRepresentable

### Community 82 - "LibraryCompareView"
Cohesion: 0.36
Nodes (3): DrugDeletionImpact, DrugLibraryMutationService, Int

### Community 83 - "String"
Cohesion: 0.50
Nodes (3): CropGrid, Path, Shape

### Community 84 - "DrugRelationshipKind"
Cohesion: 0.29
Nodes (6): CoreTransferable, ReportFile, String, Transferable, TransferRepresentation, UniformTypeIdentifiers

### Community 85 - "DurationBand"
Cohesion: 0.20
Nodes (10): DurationBand, long, medium, short, unknown, ImportedDurationBand, long, medium (+2 more)

### Community 86 - "MemoryReviewGrade"
Cohesion: 0.50
Nodes (3): DrugPharmacologyScreen, RenlystSurface, Content

### Community 87 - "DrugDetailView.swift"
Cohesion: 0.40
Nodes (5): DrugRelationshipKind, contraindicatedCombination, interaction, relatedUse, sameClass

### Community 88 - "SafetySeverity"
Cohesion: 0.40
Nodes (5): MemoryReviewGrade, again, easy, good, hard

### Community 89 - ".removePhoto"
Cohesion: 0.50
Nodes (4): ProdrugClassification, activeDrug, prodrug, unknown

### Community 90 - "Binding"
Cohesion: 0.50
Nodes (4): VerificationStatus, pendingPharmacist, personal, pharmacistVerified

## Knowledge Gaps
- **393 isolated node(s):** `today`, `library`, `practice`, `you`, `drug` (+388 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **4 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `View` connect `Unit` to `QuestionType`, `LibraryView`, `PracticeSessionView`, `ShiftView`, `DosingFrequency`, `CaseIterable`, `ImageCapture.swift`, `DurationBand`, `ModelAndPersistenceTests`, `HomeView`, `FocusField`, `ReportEditorView`, `.apply`, `SwiftData`, `LibraryView`, `ReviewRating`, `.generate`, `SafetyRadar`, `.record`, `ReportFile.swift`, `HalfLifeBand`, `Color`, `.generate`, `.containsObviousIdentifier`, `Components.swift`, `Bool`, `Decoder`, `DrugDetailView.swift`, `AIPracticePayload`, `DrugSearchResult`, `MemoryReviewGrade`?**
  _High betweenness centrality (0.197) - this node is a cross-community bridge._
- **Why does `SwiftData` connect `ReviewRating` to `Drug`, `Chapter`, `PracticeSessionView`, `ShiftView`, `.image`, `ImageCapture.swift`, `FocusField`, `Foundation`, `ReportEditorView`, `.generate`, `SafetyRadar`, `HalfLifeBand`, `PracticeQuestion`, `Unit`, `CGPoint`, `Decoder`, `ReportFile.swift`, `DrugSearchResult`, `LibraryCompareView`?**
  _High betweenness centrality (0.070) - this node is a cross-community bridge._
- **Why does `Chapter` connect `DurationBand` to `Bool`, `Drug`, `LibraryView`, `ReviewRating`, `.generate`, `Decoder`, `Chapter`, `SafetyRadar`, `SafetyFlag`, `Codable`, `Color`, `Path`, `ModelAndPersistenceTests`, `.containsObviousIdentifier`, `HomeView`, `CGPoint`, `Bool`?**
  _High betweenness centrality (0.043) - this node is a cross-community bridge._
- **What connects `today`, `library`, `practice` to the rest of the system?**
  _393 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `ShiftLog` be split into smaller, more focused modules?**
  _Cohesion score 0.11083743842364532 - nodes in this community are weakly interconnected._
- **Should `SwiftUI` be split into smaller, more focused modules?**
  _Cohesion score 0.1476923076923077 - nodes in this community are weakly interconnected._
- **Should `Drug` be split into smaller, more focused modules?**
  _Cohesion score 0.1286549707602339 - nodes in this community are weakly interconnected._