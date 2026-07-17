# Graph Report - pharmashift  (2026-07-17)

## Corpus Check
- 54 files · ~462,373 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1608 nodes · 4282 edges · 95 communities (90 shown, 5 thin omitted)
- Extraction: 96% EXTRACTED · 4% INFERRED · 0% AMBIGUOUS · INFERRED: 185 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `3075de72`
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
- [[_COMMUNITY_LocalDrugGraphView|LocalDrugGraphView]]
- [[_COMMUNITY_HalfLifeBand|HalfLifeBand]]
- [[_COMMUNITY_DurationBand|DurationBand]]
- [[_COMMUNITY_AtomicNotesView|AtomicNotesView]]
- [[_COMMUNITY_BackupError|BackupError]]
- [[_COMMUNITY_ImportMode|ImportMode]]
- [[_COMMUNITY_Binding|Binding]]
- [[_COMMUNITY_LibrarySummaryRow|LibrarySummaryRow]]
- [[_COMMUNITY_LibrarySummaryRow|LibrarySummaryRow]]
- [[_COMMUNITY_Data|Data]]
- [[_COMMUNITY_AppSheet|AppSheet]]

## God Nodes (most connected - your core abstractions)
1. `View` - 148 edges
2. `Drug` - 48 edges
3. `Chapter` - 42 edges
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

## Communities (95 total, 5 thin omitted)

### Community 0 - "ShiftLog"
Cohesion: 0.11
Nodes (13): DrugFilter, Bool, Calendar, Date, Drug, Drug, Bool, Data (+5 more)

### Community 1 - "SwiftUI"
Cohesion: 0.17
Nodes (10): Coordinator, NativeCropScrollView, Bool, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollView, UIScrollViewDelegate, UITapGestureRecognizer (+2 more)

### Community 2 - "Drug"
Cohesion: 0.25
Nodes (6): PracticeCase, StarterContent, Drug, Int, ModelContext, String

### Community 3 - "ImageCapture.swift"
Cohesion: 0.22
Nodes (5): DrugLibraryMigrationService, DrugProduct, IngredientComponent, IngredientIdentity, ModelContext

### Community 4 - "String"
Cohesion: 0.10
Nodes (18): deepSeekHTTPStatus, DrugImportValidator, ImportSelection, ProfileGenerationGroup, adverseEffects, counselingAndLearning, dosageFormsAndDosing, identityAndUses (+10 more)

### Community 5 - "Chapter"
Cohesion: 0.11
Nodes (21): DoseRegimensView, Double, DoseCalculationResult, DoseCalculator, DoseFormulaKind, fixed, mgPerKgPerDay, mgPerKgPerDose (+13 more)

### Community 6 - "QuestionType"
Cohesion: 0.12
Nodes (16): DrugImportView, Bool, Drug, PhotosPickerItem, DeepSeekIdentityResolver, DrugIdentityResolving, ResolvedDrugIdentity, DeepSeekDrugImportService (+8 more)

### Community 7 - "LibraryView"
Cohesion: 0.06
Nodes (17): HTTPURLResponse, LearningSettingsView, Binding, Bool, DeepSeekKeyStore, openRouterHTTPStatus, keychain, OpenRouterKeyStore (+9 more)

### Community 8 - "PracticeSessionView"
Cohesion: 0.10
Nodes (22): Int, ConfirmDrugIdentityView, FlowChips, ImportFromPhotoView, ImportMemorizationChallengeView, ImportMode, aiDraft, trusted (+14 more)

### Community 9 - "ShiftView"
Cohesion: 0.13
Nodes (24): Double, YouView, HomeView, DailyActivity, DrugRelationship, DrugRelationshipKind, contraindicatedCombination, interaction (+16 more)

### Community 10 - "Identifiable"
Cohesion: 0.07
Nodes (30): CodingKeys, adverseReactions, boxedWarning, brandName, clinicalPharmacology, contraindications, dosageAndAdministration, dosageForm (+22 more)

### Community 11 - "SafetyFlag"
Cohesion: 0.20
Nodes (31): Codable, Equatable, EliminationInfo, EliminationRouteInfo, ProdrugInfo, Flashcard, GeneratedReviewQuestionDTO, ImportedAdverseEffects (+23 more)

### Community 12 - "DosingFrequency"
Cohesion: 0.13
Nodes (12): NSNumber, DeepSeekJSONSanitizer, DrugDataConsistencyNormalizer, Any, Data, Double, Int, Set (+4 more)

### Community 13 - ".image"
Cohesion: 0.16
Nodes (13): NaturalLanguage, Drug, FocusAction, addDrug, finishShift, practiceWeak, reviewDue, FocusModeEngine (+5 more)

### Community 14 - "Build and install PharmaShift using only Windows"
Cohesion: 0.14
Nodes (11): Final Release Gate, PharmaShift Delivery Roadmap, Phase 2 - Visual Pharmacology and Safety, Phase 3 - Backup, Restore, and Export, Phase 4 - Drug Information Import, Phase 5 - Focus, Practice, and Motivation, Renlyst 2.0 — Product and Interface Rebuild, Renlyst (+3 more)

### Community 15 - "CaseIterable"
Cohesion: 0.13
Nodes (17): Error, FileDocument, FileWrapper, BackupDataView, BackupExportKind, complete, csv, lightweight (+9 more)

### Community 16 - "Codable"
Cohesion: 0.16
Nodes (13): NSObject, OSStatus, KeyStoreError, readBackFailed, NameKind, brand, generic, SPLParser (+5 more)

### Community 17 - "ImageCapture.swift"
Cohesion: 0.37
Nodes (5): CGRect, ImageCompressor, CGSize, Int, UIImage

### Community 18 - "DurationBand"
Cohesion: 0.14
Nodes (13): Chapter, antibiotics, cardiovascular, dermatology, earNoseOropharynx, endocrine, eye, gastrointestinal (+5 more)

### Community 19 - "HomeView"
Cohesion: 0.24
Nodes (5): PharmaShiftUITests, Int, String, XCUIApplication, XCUIElement

### Community 21 - "ModelAndPersistenceTests"
Cohesion: 0.09
Nodes (16): CaptureView, Binding, Bool, Data, Int, PhotosPickerItem, String, UUID (+8 more)

### Community 22 - "QuestionType"
Cohesion: 0.16
Nodes (11): ReportView, Drug, EndShiftView, Binding, ReferenceWritableKeyPath, ShiftLog, TrainingReport, ReportBuilder (+3 more)

### Community 23 - "HomeView"
Cohesion: 0.15
Nodes (6): LegacyDrugDetailView, Bool, Color, Content, Set, ScrollViewProxy

### Community 24 - "Q: What should PharmaShift do after Phase 1?"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: What should PharmaShift do after Phase 1?, Source Nodes

### Community 25 - "Identifiable"
Cohesion: 0.29
Nodes (6): DrugBrandService, DrugDeletionImpact, DrugLibraryMutationService, Drug, Int, ModelContext

### Community 26 - "FocusField"
Cohesion: 0.09
Nodes (22): DrugDeletionSheet, LibraryCompareView, LibraryDrugRow, LibraryKnowledgeMapView, LibraryScope, all, due, needsAttention (+14 more)

### Community 27 - "DrugImportView.swift"
Cohesion: 0.20
Nodes (4): Foundation, PrivacyValidator, Bool, String

### Community 28 - "Foundation"
Cohesion: 0.21
Nodes (14): BackupRecordCounts, DailyActivityBackupDTO, DrugProductBackupDTO, DrugRelationshipBackupDTO, EncounterBackupDTO, LearningProfileBackupDTO, PharmaShiftBackup, ReviewBackupDTO (+6 more)

### Community 29 - "ReportEditorView"
Cohesion: 0.15
Nodes (22): View, ArabicSummarySurface, BrandProductRow, DrugBrandsScreen, DrugCounselingScreen, DrugDetailView, DrugDosingScreen, DrugIdentityHeader (+14 more)

### Community 30 - "Path"
Cohesion: 0.22
Nodes (5): BackupService, Data, ModelContext, BackupServiceTests, ModelContainer

### Community 31 - ".apply"
Cohesion: 0.24
Nodes (9): Observation, ReviewScheduler, Bool, Calendar, Date, Drug, Int, String (+1 more)

### Community 32 - "Design"
Cohesion: 0.11
Nodes (17): Accessibility floor, Color, Core flows, Design, Dials, Direction, Drug overview, Imagery and icons (+9 more)

### Community 33 - "PharmacologyScale"
Cohesion: 0.22
Nodes (10): DrugImagePayload, DrugPhotoGalleryView, DrugPhotoView, DrugThumbnailView, ImageDraft, ImageEditorView, CGFloat, Data (+2 more)

### Community 34 - "SwiftData"
Cohesion: 0.25
Nodes (6): PharmaShift, MigrationFixtureTests, ReportBuilderTests, SwiftData, XCTest, XCTestCase

### Community 35 - "LibraryView"
Cohesion: 0.27
Nodes (6): report, ReportEditorView, Binding, Date, ReferenceWritableKeyPath, String

### Community 36 - "ReviewRating"
Cohesion: 0.18
Nodes (9): App, LinearGradient, AppTheme, RenlystLayout, RenlystMotion, CGFloat, Color, PharmaShiftApp (+1 more)

### Community 37 - ".generate"
Cohesion: 0.14
Nodes (16): DailyRefreshView, LegacyPracticeView, MistakeVaultView, PracticeChoiceRow, PracticeChoiceState, correct, dimmed, idle (+8 more)

### Community 38 - "SafetyRadar"
Cohesion: 0.24
Nodes (5): ProductLeafletEditorView, Binding, Data, Drug, PhotosPickerItem

### Community 40 - "MemoryReviewGrade"
Cohesion: 0.26
Nodes (9): RecentStudySection, RecommendedActionCard, CGFloat, Drug, Int, String, Void, TodayHero (+1 more)

### Community 41 - "DosingFrequency"
Cohesion: 0.22
Nodes (7): BackupImportPreviewView, Int, Void, BackupRestoreMode, merge, replace, BackupRestoreSummary

### Community 42 - "SafetyRadar"
Cohesion: 0.16
Nodes (4): PracticeEngineTests, Drug, Int, ModelContainer

### Community 43 - "DrugRelationshipKind"
Cohesion: 0.54
Nodes (3): PracticeGenerator, Drug, Int

### Community 44 - "SafetyFlag"
Cohesion: 0.20
Nodes (10): CodingKeys, answer, choices, explanation, finishReason, message, prompt, questions (+2 more)

### Community 45 - ".record"
Cohesion: 0.20
Nodes (10): ImportSection, adverseEffects, arabicExplanation, counseling, identity, memorization, pharmacokinetics, safety (+2 more)

### Community 46 - "ReportFile.swift"
Cohesion: 0.13
Nodes (18): AIPracticePackView, Drug, AIPracticePack, AIPracticePackStore, AIPracticePayload, AIPracticeQuestion, Choice, DeepSeekContentResponse (+10 more)

### Community 47 - "HalfLifeBand"
Cohesion: 0.23
Nodes (9): Destination, PracticeModesView, PracticeSummary, PracticeToolsSection, QuickPracticeSection, RecommendedPracticeCard, Int, String (+1 more)

### Community 48 - "DrugEditorSection"
Cohesion: 0.15
Nodes (13): DrugCardPage, adverse, brands, counseling, doses, forms, interactions, notes (+5 more)

### Community 49 - "PracticeQuestion"
Cohesion: 0.17
Nodes (25): CoreFoundation, Decodable, Encodable, APIError, Candidate, Choice, DailyMedSearchItem, DailyMedSearchPayload (+17 more)

### Community 50 - "Color"
Cohesion: 0.12
Nodes (14): PracticeView, PracticeMode, casePractice, classExamples, counseling, drugUse, drugWarning, dueReview (+6 more)

### Community 51 - ".generate"
Cohesion: 0.29
Nodes (6): DrugBrandsSheet, addProduct, DrugBrandsView, LocalDrugGraphView, CGPoint, CGSize

### Community 52 - "ImportedExcretionRoute"
Cohesion: 0.08
Nodes (25): LocalizedError, DoseCalculatorError, ageOutsideRegimen, heightRequired, invalidRegimen, sexOutsideRegimen, weightRequired, DrugImportError (+17 more)

### Community 53 - "DrugEditorSection"
Cohesion: 0.20
Nodes (10): DrugCardAnchor, arabic, counseling, identity, mastery, notes, pharmacology, review (+2 more)

### Community 54 - ".containsObviousIdentifier"
Cohesion: 0.22
Nodes (9): CodingKey, CodingKeys, dailyActivities, drugs, encounters, learningProfiles, reports, reviews (+1 more)

### Community 55 - "NameKind"
Cohesion: 0.22
Nodes (12): ImageIO, EmptyStateView, LabeledValue, MasteryBadge, MetricCard, PharmacologyMeter, PharmacologyStatusCard, RenlystEmptyState (+4 more)

### Community 56 - "FocusField"
Cohesion: 0.09
Nodes (15): AltibbiProvider, DailyMedProvider, DeepSeekFastDrugGatherService, DrugRelationshipRefreshService, DrugSearchRanker, DrugSearchResult, DrugSourceProvider, DrugSourceProviderFactory (+7 more)

### Community 57 - "Unit"
Cohesion: 0.22
Nodes (10): AddHubView, AppRoute, drug, drugTopic, CaptureSheetView, CommandPaletteView, DrugRouteDestination, Drug (+2 more)

### Community 58 - "Components.swift"
Cohesion: 0.19
Nodes (25): Hashable, Identifiable, AdverseEffectEntry, AtomicDrugNote, ClinicalDoseEntry, DosageFormGroup, Drug, DrugFieldEvidence (+17 more)

### Community 59 - "PhotosPickerItem"
Cohesion: 0.28
Nodes (9): ProductImagePipeline, ProductPhoto, SafetyRadar, CGFloat, CGPoint, Data, Int, Path (+1 more)

### Community 60 - "String"
Cohesion: 0.05
Nodes (37): ImportedDosingFrequency, fourTimesDaily, onceDaily, other, PRN, threeTimesDaily, twiceDaily, unknown (+29 more)

### Community 61 - "CGPoint"
Cohesion: 0.12
Nodes (15): FocusField, scientific, trade, unknownLabel, SaveAction, another, later, open (+7 more)

### Community 62 - "Bool"
Cohesion: 0.18
Nodes (9): BrandProductForm, Binding, Bool, Data, Int, PhotosPickerItem, BrandProductDraft, Bool (+1 more)

### Community 63 - ".apply"
Cohesion: 0.22
Nodes (8): ClosedRange, Double, OrbitMark, PharmacologyScale, duration, halfLife, onset, Double

### Community 64 - "MemoryReviewGrade"
Cohesion: 0.29
Nodes (5): Context, CameraPicker, Any, UIImagePickerController, UIViewControllerRepresentable

### Community 65 - "Bool"
Cohesion: 0.29
Nodes (5): ButtonStyle, Configuration, RenlystPrimaryButtonStyle, RenlystTileButtonStyle, Color

### Community 66 - "DoseRegimensView"
Cohesion: 0.22
Nodes (8): DrugTopic, brands, counseling, dosing, pharmacology, safety, sources, uses

### Community 67 - "Decoder"
Cohesion: 0.19
Nodes (13): ActiveShiftCard, ActiveShiftContent, EncounterEditorView, ShiftPhase, ShiftPhaseRow, ShiftView, Bool, Date (+5 more)

### Community 68 - "ReportFile.swift"
Cohesion: 0.07
Nodes (29): CaseIterable, AtomicNoteKind, confusingPoint, memoryTrick, patientCounseling, shelfObservation, sourceCorrection, ConfidenceLevel (+21 more)

### Community 69 - "String"
Cohesion: 0.39
Nodes (4): DrugBackupDTO, Bool, Double, Drug

### Community 70 - "MemoryReviewGrade"
Cohesion: 0.33
Nodes (7): MigrationStage, PersistentModel, CurrentDrugSchema, DrugMigrationPlan, Phase1DrugSchema, SchemaMigrationPlan, VersionedSchema

### Community 71 - "DrugDetailView.swift"
Cohesion: 0.18
Nodes (12): DrugEditorView, Binding, Bool, Drug, Int, PhotosPickerItem, ReferenceWritableKeyPath, SafetySeverity (+4 more)

### Community 72 - "ExcretionRoute"
Cohesion: 0.10
Nodes (17): PracticeInteraction, multipleChoice, recall, textEntry, trueFalse, QuestionDifficulty, application, challenge (+9 more)

### Community 73 - ".matches"
Cohesion: 0.18
Nodes (10): Accessibility & Inclusion, Anti-references, Brand Personality, Design Principles, Platform, Positioning, Product, Product Purpose (+2 more)

### Community 74 - "AIPracticePayload"
Cohesion: 0.22
Nodes (9): DosingFrequency, asNeeded, fourTimesDaily, onceDaily, other, threeTimesDaily, twiceDaily, unknown (+1 more)

### Community 75 - "SafetyFlag"
Cohesion: 0.29
Nodes (7): MemoryAnchorKind, counseling, empty, mechanism, mustKnow, safety, use

### Community 76 - "DrugSearchResult"
Cohesion: 0.25
Nodes (6): CropGrid, CropViewportState, CGPoint, Path, Shape, UIEdgeInsets

### Community 77 - "DrugDetailSheet"
Cohesion: 0.18
Nodes (10): InteractionCategory, contraindicated, minor, monitorClosely, seriousUseAlternative, unknown, Decoder, Encoder (+2 more)

### Community 79 - "DrugEvidenceQuality"
Cohesion: 0.29
Nodes (5): DrugDetailSheet, atomicNotes, editor, regenerateReview, review

### Community 80 - "VerificationStatus"
Cohesion: 0.29
Nodes (7): DrugEditorSection, basics, counseling, notes, pk, safety, uses

### Community 82 - "LibraryCompareView"
Cohesion: 0.29
Nodes (6): CoreTransferable, ReportFile, String, Transferable, TransferRepresentation, UniformTypeIdentifiers

### Community 83 - "LocalDrugGraphView"
Cohesion: 0.29
Nodes (7): EliminationPathway, biliaryFecal, mixed, other, pulmonary, renalUrine, unknown

### Community 84 - "HalfLifeBand"
Cohesion: 0.33
Nodes (6): DrugEvidenceQuality, aiUnverified, altibbi, manual, officialLabel, productLeaflet

### Community 85 - "DurationBand"
Cohesion: 0.36
Nodes (6): ShelfQuestView, Double, Drug, Int, String, SystemDashboardMetrics

### Community 86 - "AtomicNotesView"
Cohesion: 0.33
Nodes (6): HalfLifeBand, long, medium, short, unknown, veryLong

### Community 87 - "BackupError"
Cohesion: 0.40
Nodes (5): BackupError, duplicateIdentifiers, invalidCounts, malformed, newerVersion

### Community 89 - "ImportMode"
Cohesion: 0.40
Nodes (5): AppTab, library, practice, today, you

### Community 90 - "Binding"
Cohesion: 0.14
Nodes (13): SafetyFlag, anticoagulant, children, controlledDrug, corticosteroid, insulin, pregnancy, severeSymptoms (+5 more)

### Community 91 - "LibrarySummaryRow"
Cohesion: 0.40
Nodes (5): MemoryReviewGrade, again, easy, good, hard

### Community 95 - "AppSheet"
Cohesion: 0.20
Nodes (8): AboutView, AddRouteRow, AppNavigation, AppSheet, addHub, capture, AppShell, Color

## Knowledge Gaps
- **392 isolated node(s):** `today`, `library`, `practice`, `you`, `drugTopic` (+387 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **5 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `View` connect `ReportEditorView` to `Chapter`, `QuestionType`, `LibraryView`, `PracticeSessionView`, `ShiftView`, `CaseIterable`, `ModelAndPersistenceTests`, `QuestionType`, `HomeView`, `FocusField`, `PharmacologyScale`, `LibraryView`, `.generate`, `SafetyRadar`, `MemoryReviewGrade`, `DosingFrequency`, `ReportFile.swift`, `HalfLifeBand`, `Color`, `.generate`, `NameKind`, `Unit`, `PhotosPickerItem`, `CGPoint`, `Bool`, `.apply`, `Bool`, `Decoder`, `DrugDetailView.swift`, `AIPracticePayload`, `DrugEditorSection`, `DrugEvidenceQuality`, `DurationBand`, `LibrarySummaryRow`, `Data`, `AppSheet`?**
  _High betweenness centrality (0.181) - this node is a cross-community bridge._
- **Why does `SwiftData` connect `SwiftData` to `Drug`, `PracticeSessionView`, `.image`, `CaseIterable`, `FocusField`, `DrugImportView.swift`, `Foundation`, `ReportEditorView`, `ReviewRating`, `.generate`, `MemoryReviewGrade`, `HalfLifeBand`, `PracticeQuestion`, `.generate`, `Components.swift`, `CGPoint`, `Decoder`, `DurationBand`, `AppSheet`?**
  _High betweenness centrality (0.076) - this node is a cross-community bridge._
- **Why does `DrugImportView` connect `QuestionType` to `PharmacologyScale`, `ImageCapture.swift`, `String`, `PracticeSessionView`, `SafetyFlag`, `ModelAndPersistenceTests`, `SafetySeverity`, `FocusField`, `ReportEditorView`?**
  _High betweenness centrality (0.052) - this node is a cross-community bridge._
- **What connects `today`, `library`, `practice` to the rest of the system?**
  _392 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `ShiftLog` be split into smaller, more focused modules?**
  _Cohesion score 0.11083743842364532 - nodes in this community are weakly interconnected._
- **Should `String` be split into smaller, more focused modules?**
  _Cohesion score 0.10452961672473868 - nodes in this community are weakly interconnected._
- **Should `Chapter` be split into smaller, more focused modules?**
  _Cohesion score 0.11494252873563218 - nodes in this community are weakly interconnected._