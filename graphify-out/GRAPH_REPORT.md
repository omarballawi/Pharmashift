# Graph Report - pharmashift  (2026-07-16)

## Corpus Check
- 54 files · ~460,159 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1548 nodes · 4116 edges · 79 communities (76 shown, 3 thin omitted)
- Extraction: 95% EXTRACTED · 5% INFERRED · 0% AMBIGUOUS · INFERRED: 190 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `b0d86d71`
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
- [[_COMMUNITY_DrugEditorSection|DrugEditorSection]]
- [[_COMMUNITY_VerificationStatus|VerificationStatus]]
- [[_COMMUNITY_String|String]]

## God Nodes (most connected - your core abstractions)
1. `Drug` - 47 edges
2. `DrugImportView` - 40 edges
3. `Chapter` - 40 edges
4. `DrugEditorView` - 39 edges
5. `ImportedDrugInfo` - 38 edges
6. `Drug` - 36 edges
7. `DeepSeekKeyStore` - 33 edges
8. `CodingKeys` - 32 edges
9. `DrugImportServiceTests` - 29 edges
10. `DrugProduct` - 29 edges

## Surprising Connections (you probably didn't know these)
- `PreviewData` --calls--> `ShiftLog`  [INFERRED]
  PharmaShift/Shared/PreviewSupport.swift → PharmaShift/Models/Models.swift
- `AppNavigation` --references--> `PracticeMode`  [EXTRACTED]
  PharmaShift/App/AppShell.swift → PharmaShift/Services/PracticeEngine.swift
- `YouView` --references--> `LearningProfile`  [EXTRACTED]
  PharmaShift/App/AppShell.swift → PharmaShift/Models/Models.swift
- `LearningSettingsView` --references--> `LearningProfile`  [EXTRACTED]
  PharmaShift/App/AppShell.swift → PharmaShift/Models/Models.swift
- `PharmaShiftApp` --calls--> `AppTheme`  [INFERRED]
  PharmaShift/App/PharmaShiftApp.swift → PharmaShift/App/AppTheme.swift

## Import Cycles
- None detected.

## Communities (79 total, 3 thin omitted)

### Community 0 - "ShiftLog"
Cohesion: 0.11
Nodes (13): DrugFilter, Bool, Calendar, Date, Drug, Drug, Bool, Data (+5 more)

### Community 1 - "SwiftUI"
Cohesion: 0.16
Nodes (11): NSObject, Coordinator, NativeCropScrollView, Bool, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollView, UIScrollViewDelegate (+3 more)

### Community 2 - "Drug"
Cohesion: 0.17
Nodes (25): Hashable, Identifiable, AdverseEffectEntry, AtomicDrugNote, ClinicalDoseEntry, ConfidenceLevel, mastered, medium (+17 more)

### Community 3 - "ImageCapture.swift"
Cohesion: 0.22
Nodes (5): DrugLibraryMigrationService, DrugProduct, IngredientComponent, IngredientIdentity, ModelContext

### Community 4 - "String"
Cohesion: 0.10
Nodes (18): DeepSeekFastDrugGatherService, deepSeekHTTPStatus, DrugImportValidator, ProfileGenerationGroup, adverseEffects, counselingAndLearning, dosageFormsAndDosing, identityAndUses (+10 more)

### Community 5 - "Chapter"
Cohesion: 0.11
Nodes (21): DoseRegimensView, Double, DoseCalculationResult, DoseCalculator, DoseFormulaKind, fixed, mgPerKgPerDay, mgPerKgPerDose (+13 more)

### Community 6 - "QuestionType"
Cohesion: 0.13
Nodes (13): NSNumber, DeepSeekJSONSanitizer, DrugDataConsistencyNormalizer, DrugImportApplier, ImportSelection, Any, Bool, Double (+5 more)

### Community 7 - "LibraryView"
Cohesion: 0.05
Nodes (19): HTTPURLResponse, LearningSettingsView, Binding, Bool, DeepSeekKeyStore, keychain, OpenRouterKeyStore, OpenRouterPackageVisionService (+11 more)

### Community 8 - "PracticeSessionView"
Cohesion: 0.06
Nodes (39): Int, ConfirmDrugIdentityView, DrugImportView, FlowChips, ImportFromPhotoView, ImportMemorizationChallengeView, ImportMode, aiDraft (+31 more)

### Community 9 - "ShiftView"
Cohesion: 0.16
Nodes (16): ActiveShiftCard, ActiveShiftContent, EncounterEditorView, EndShiftView, ShiftPhase, ShiftPhaseRow, ShiftView, Binding (+8 more)

### Community 10 - "Identifiable"
Cohesion: 0.07
Nodes (30): CodingKeys, adverseReactions, boxedWarning, brandName, clinicalPharmacology, contraindications, dosageAndAdministration, dosageForm (+22 more)

### Community 11 - "SafetyFlag"
Cohesion: 0.14
Nodes (14): Double, YouView, PracticeInteraction, multipleChoice, recall, textEntry, trueFalse, Data (+6 more)

### Community 12 - "DosingFrequency"
Cohesion: 0.20
Nodes (11): ImageIO, DrugImagePayload, DrugPhotoGalleryView, DrugPhotoView, DrugThumbnailView, ImageDraft, ImageEditorView, CGFloat (+3 more)

### Community 13 - ".image"
Cohesion: 0.07
Nodes (27): HomeView, RecentStudySection, RecommendedActionCard, CGFloat, Drug, Int, String, Void (+19 more)

### Community 14 - "Build and install PharmaShift using only Windows"
Cohesion: 0.14
Nodes (11): Final Release Gate, PharmaShift Delivery Roadmap, Phase 2 - Visual Pharmacology and Safety, Phase 3 - Backup, Restore, and Export, Phase 4 - Drug Information Import, Phase 5 - Focus, Practice, and Motivation, Renlyst 2.0 — Product and Interface Rebuild, Renlyst (+3 more)

### Community 15 - "CaseIterable"
Cohesion: 0.24
Nodes (10): MigrationStage, PersistentModel, CurrentDrugSchema, DrugMigrationPlan, MigrationFixtureTests, Phase1DrugSchema, ReportBuilderTests, SchemaMigrationPlan (+2 more)

### Community 16 - "Codable"
Cohesion: 0.18
Nodes (31): Codable, Equatable, EliminationInfo, EliminationRouteInfo, ProdrugInfo, Flashcard, GeneratedReviewQuestionDTO, ImportedAdverseEffects (+23 more)

### Community 17 - "ImageCapture.swift"
Cohesion: 0.13
Nodes (17): Error, FileDocument, FileWrapper, BackupDataView, BackupExportKind, complete, csv, lightweight (+9 more)

### Community 18 - "DurationBand"
Cohesion: 0.07
Nodes (29): AboutView, AddHubView, AddRouteRow, AppNavigation, AppSheet, addHub, capture, AppShell (+21 more)

### Community 19 - "HomeView"
Cohesion: 0.07
Nodes (29): CaseIterable, DrugEvidenceQuality, aiUnverified, altibbi, manual, officialLabel, productLeaflet, DurationBand (+21 more)

### Community 21 - "ModelAndPersistenceTests"
Cohesion: 0.08
Nodes (19): CaptureView, FocusField, scientific, trade, unknownLabel, Binding, Bool, Data (+11 more)

### Community 22 - "QuestionType"
Cohesion: 0.05
Nodes (37): ImportedDosingFrequency, fourTimesDaily, onceDaily, other, PRN, threeTimesDaily, twiceDaily, unknown (+29 more)

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
Cohesion: 0.08
Nodes (24): DrugDeletionSheet, LibraryCompareView, LibraryDrugRow, LibraryKnowledgeMapView, LibraryScope, all, due, needsAttention (+16 more)

### Community 27 - "DrugImportView.swift"
Cohesion: 0.12
Nodes (19): DrugEditorView, Binding, Bool, Double, Drug, Int, PhotosPickerItem, ReferenceWritableKeyPath (+11 more)

### Community 28 - "Foundation"
Cohesion: 0.21
Nodes (14): BackupRecordCounts, DailyActivityBackupDTO, DrugProductBackupDTO, DrugRelationshipBackupDTO, EncounterBackupDTO, LearningProfileBackupDTO, PharmaShiftBackup, ReviewBackupDTO (+6 more)

### Community 29 - "ReportEditorView"
Cohesion: 0.11
Nodes (27): ArabicSummarySurface, BrandProductRow, DrugBrandsScreen, DrugCounselingScreen, DrugDetailView, DrugDosingScreen, DrugIdentityHeader, DrugOverviewSheet (+19 more)

### Community 30 - "Path"
Cohesion: 0.22
Nodes (5): BackupService, Data, ModelContext, BackupServiceTests, ModelContainer

### Community 31 - ".apply"
Cohesion: 0.38
Nodes (6): ShelfQuestView, Double, Drug, Int, String, SystemDashboardMetrics

### Community 32 - "Design"
Cohesion: 0.11
Nodes (17): Accessibility floor, Color, Core flows, Design, Dials, Direction, Drug overview, Imagery and icons (+9 more)

### Community 33 - "PharmacologyScale"
Cohesion: 0.29
Nodes (3): LegacyPracticeView, Color, Int

### Community 34 - "SwiftData"
Cohesion: 0.38
Nodes (5): CGRect, ImageCompressor, CGSize, Int, UIImage

### Community 35 - "LibraryView"
Cohesion: 0.10
Nodes (26): ClosedRange, DosingFrequencyMeter, EmptyStateView, LabeledValue, MasteryBadge, MetricCard, OrbitMark, PharmacologyMeter (+18 more)

### Community 36 - "ReviewRating"
Cohesion: 0.24
Nodes (5): PharmaShiftUITests, Int, String, XCUIApplication, XCUIElement

### Community 37 - ".generate"
Cohesion: 0.19
Nodes (11): DailyRefreshView, MistakeVaultView, PracticeSessionView, Drug, String, MemoryReviewGrade, again, easy (+3 more)

### Community 38 - "SafetyRadar"
Cohesion: 0.11
Nodes (13): AtomicNotesView, DrugBrandsSheet, addProduct, DrugBrandsView, LocalDrugGraphView, ProductLeafletEditorView, Binding, CGPoint (+5 more)

### Community 40 - "MemoryReviewGrade"
Cohesion: 0.20
Nodes (8): InteractionCategory, contraindicated, minor, monitorClosely, seriousUseAlternative, unknown, Decoder, Encoder

### Community 41 - "DosingFrequency"
Cohesion: 0.27
Nodes (6): report, ReportEditorView, Binding, Date, ReferenceWritableKeyPath, String

### Community 42 - "SafetyRadar"
Cohesion: 0.16
Nodes (8): DeepSeekDrugImportService, DrugImportFormattingService, DrugPackageRecognizing, DrugSourceProviderFactory, FastDrugGatheringService, MockDeepSeekDrugImportService, MockFastDrugGatherService, MockOpenRouterPackageVisionService

### Community 43 - "DrugRelationshipKind"
Cohesion: 0.44
Nodes (3): PracticeGenerator, Drug, Int

### Community 44 - "SafetyFlag"
Cohesion: 0.29
Nodes (8): ReviewScheduler, Bool, Calendar, Date, Drug, Int, String, ReviewSchedulerTests

### Community 45 - ".record"
Cohesion: 0.18
Nodes (9): BrandProductForm, Binding, Bool, Data, Int, PhotosPickerItem, BrandProductDraft, Bool (+1 more)

### Community 46 - "ReportFile.swift"
Cohesion: 0.13
Nodes (17): AIPracticePackView, Drug, AIPracticePack, AIPracticePackStore, AIPracticePayload, AIPracticeQuestion, Choice, DeepSeekContentResponse (+9 more)

### Community 47 - "HalfLifeBand"
Cohesion: 0.23
Nodes (9): Destination, PracticeModesView, PracticeSummary, PracticeToolsSection, QuickPracticeSection, RecommendedPracticeCard, Int, String (+1 more)

### Community 48 - "DrugEditorSection"
Cohesion: 0.10
Nodes (18): DrugCardPage, adverse, brands, counseling, doses, forms, interactions, notes (+10 more)

### Community 49 - "PracticeQuestion"
Cohesion: 0.12
Nodes (31): CoreFoundation, Decodable, Encodable, OSStatus, APIError, Candidate, Choice, DailyMedSearchItem (+23 more)

### Community 50 - "Color"
Cohesion: 0.13
Nodes (14): PracticeView, PracticeMode, casePractice, classExamples, counseling, drugUse, drugWarning, dueReview (+6 more)

### Community 51 - ".generate"
Cohesion: 0.11
Nodes (18): AltibbiProvider, DailyMedProvider, DrugRelationshipRefreshService, DrugSearchRanker, DrugSearchResult, DrugSourceProvider, MockDrugSourceProvider, OpenFDALabelProvider (+10 more)

### Community 52 - "ImportedExcretionRoute"
Cohesion: 0.08
Nodes (26): LocalizedError, DoseCalculatorError, ageOutsideRegimen, heightRequired, invalidRegimen, sexOutsideRegimen, weightRequired, DrugImportError (+18 more)

### Community 53 - "DrugEditorSection"
Cohesion: 0.20
Nodes (10): DrugCardAnchor, arabic, counseling, identity, mastery, notes, pharmacology, review (+2 more)

### Community 54 - ".containsObviousIdentifier"
Cohesion: 0.20
Nodes (4): Foundation, PrivacyValidator, Bool, String

### Community 55 - "NameKind"
Cohesion: 0.33
Nodes (6): AtomicNoteKind, confusingPoint, memoryTrick, patientCounseling, shelfObservation, sourceCorrection

### Community 56 - "FocusField"
Cohesion: 0.33
Nodes (6): HalfLifeBand, long, medium, short, unknown, veryLong

### Community 57 - "Unit"
Cohesion: 0.25
Nodes (8): DosingFrequency, asNeeded, fourTimesDaily, onceDaily, other, threeTimesDaily, twiceDaily, unknown

### Community 58 - "Components.swift"
Cohesion: 0.22
Nodes (7): BackupImportPreviewView, Int, Void, BackupRestoreMode, merge, replace, BackupRestoreSummary

### Community 59 - "PhotosPickerItem"
Cohesion: 0.20
Nodes (10): CodingKeys, answer, choices, explanation, finishReason, message, prompt, questions (+2 more)

### Community 60 - "String"
Cohesion: 0.25
Nodes (7): ReportView, Drug, TrainingReport, ReportBuilder, Calendar, Drug, String

### Community 61 - "CGPoint"
Cohesion: 0.22
Nodes (8): Double, WeaknessRadarView, PreviewData, ModelContainer, PhotosUI, SwiftData, SwiftUI, UIKit

### Community 62 - "Bool"
Cohesion: 0.29
Nodes (6): CoreTransferable, ReportFile, String, Transferable, TransferRepresentation, UniformTypeIdentifiers

### Community 63 - ".apply"
Cohesion: 0.22
Nodes (9): CodingKey, CodingKeys, dailyActivities, drugs, encounters, learningProfiles, reports, reviews (+1 more)

### Community 64 - "MemoryReviewGrade"
Cohesion: 0.39
Nodes (4): DrugBackupDTO, Bool, Double, Drug

### Community 65 - "Bool"
Cohesion: 0.17
Nodes (10): App, LinearGradient, Observation, AppTheme, RenlystLayout, RenlystMotion, CGFloat, Color (+2 more)

### Community 66 - "DoseRegimensView"
Cohesion: 0.29
Nodes (7): EliminationPathway, biliaryFecal, mixed, other, pulmonary, renalUrine, unknown

### Community 67 - "Decoder"
Cohesion: 0.33
Nodes (4): ButtonStyle, Configuration, RenlystPrimaryButtonStyle, Color

### Community 68 - "ReportFile.swift"
Cohesion: 0.50
Nodes (4): SaveAction, another, later, open

### Community 69 - "String"
Cohesion: 0.29
Nodes (5): Context, CameraPicker, Any, UIImagePickerController, UIViewControllerRepresentable

### Community 70 - "MemoryReviewGrade"
Cohesion: 0.40
Nodes (5): BackupError, duplicateIdentifiers, invalidCounts, malformed, newerVersion

### Community 72 - "ExcretionRoute"
Cohesion: 0.20
Nodes (8): QuestionType, casePractice, counseling, drugClass, scientificName, tradeName, use, warning

### Community 73 - ".matches"
Cohesion: 0.18
Nodes (10): Accessibility & Inclusion, Anti-references, Brand Personality, Design Principles, Platform, Positioning, Product, Product Purpose (+2 more)

### Community 75 - "SafetyFlag"
Cohesion: 0.25
Nodes (8): SafetyFlag, anticoagulant, children, controlledDrug, corticosteroid, insulin, pregnancy, severeSymptoms

### Community 78 - "DrugEditorSection"
Cohesion: 0.29
Nodes (7): DrugEditorSection, basics, counseling, notes, pk, safety, uses

### Community 80 - "VerificationStatus"
Cohesion: 0.17
Nodes (21): DailyActivity, DrugRelationship, DrugRelationshipKind, contraindicatedCombination, interaction, relatedUse, sameClass, EncounterNote (+13 more)

### Community 83 - "String"
Cohesion: 0.25
Nodes (6): CropGrid, CropViewportState, CGPoint, Path, Shape, UIEdgeInsets

## Knowledge Gaps
- **377 isolated node(s):** `today`, `library`, `practice`, `you`, `addHub` (+372 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **3 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `SwiftData` connect `CGPoint` to `Drug`, `.generate`, `SafetyRadar`, `PracticeSessionView`, `ShiftView`, `AIPracticePayload`, `.image`, `HalfLifeBand`, `CaseIterable`, `ImageCapture.swift`, `DurationBand`, `PracticeQuestion`, `.containsObviousIdentifier`, `FocusField`, `DrugImportView.swift`, `Foundation`, `ReportEditorView`?**
  _High betweenness centrality (0.078) - this node is a cross-community bridge._
- **Why does `DrugImportView` connect `PracticeSessionView` to `ImageCapture.swift`, `String`, `QuestionType`, `SafetyRadar`, `DosingFrequency`, `Codable`, `.generate`, `ModelAndPersistenceTests`, `ReportEditorView`?**
  _High betweenness centrality (0.043) - this node is a cross-community bridge._
- **Why does `Foundation` connect `.containsObviousIdentifier` to `Bool`, `Drug`, `AIPracticePayload`, `.image`, `ReportFile.swift`, `PracticeQuestion`, `DrugImportView.swift`, `Foundation`, `Bool`?**
  _High betweenness centrality (0.038) - this node is a cross-community bridge._
- **What connects `today`, `library`, `practice` to the rest of the system?**
  _377 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `ShiftLog` be split into smaller, more focused modules?**
  _Cohesion score 0.11083743842364532 - nodes in this community are weakly interconnected._
- **Should `String` be split into smaller, more focused modules?**
  _Cohesion score 0.0975609756097561 - nodes in this community are weakly interconnected._
- **Should `Chapter` be split into smaller, more focused modules?**
  _Cohesion score 0.11494252873563218 - nodes in this community are weakly interconnected._