# Graph Report - pharmashift  (2026-07-17)

## Corpus Check
- 54 files · ~462,608 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1612 nodes · 4296 edges · 84 communities (80 shown, 4 thin omitted)
- Extraction: 96% EXTRACTED · 4% INFERRED · 0% AMBIGUOUS · INFERRED: 185 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `55d2590d`
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
- [[_COMMUNITY_Binding|Binding]]
- [[_COMMUNITY_DrugDetailSheet|DrugDetailSheet]]
- [[_COMMUNITY_Bool|Bool]]
- [[_COMMUNITY_VerificationStatus|VerificationStatus]]
- [[_COMMUNITY_.isValid|.isValid]]
- [[_COMMUNITY_LocalDrugGraphView|LocalDrugGraphView]]
- [[_COMMUNITY_BackupError|BackupError]]
- [[_COMMUNITY_Binding|Binding]]

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
- `DrugImportView` --calls--> `DeepSeekIdentityResolver`  [INFERRED]
  PharmaShift/Features/Library/DrugImportView.swift → PharmaShift/Services/DeepSeekLearningService.swift
- `PreviewData` --calls--> `ShiftLog`  [INFERRED]
  PharmaShift/Shared/PreviewSupport.swift → PharmaShift/Models/Models.swift

## Import Cycles
- None detected.

## Communities (84 total, 4 thin omitted)

### Community 0 - "ShiftLog"
Cohesion: 0.05
Nodes (36): BrandProductForm, Binding, Bool, Data, Int, PhotosPickerItem, DrugLibraryMigrationService, DrugProduct (+28 more)

### Community 1 - "SwiftUI"
Cohesion: 0.15
Nodes (13): Coordinator, CropViewportState, NativeCropScrollView, Bool, CGSize, UIEdgeInsets, UIImagePickerControllerDelegate, UINavigationControllerDelegate (+5 more)

### Community 2 - "Drug"
Cohesion: 0.12
Nodes (11): title, DailyMedProvider, DeepSeekDrugImportService, DeepSeekFastDrugGatherService, DrugImportFormattingService, DrugSourceProviderFactory, MockDeepSeekDrugImportService, OpenFDALabelProvider (+3 more)

### Community 3 - "ImageCapture.swift"
Cohesion: 0.20
Nodes (9): AIPracticePackView, Drug, AIPracticePack, AIPracticePackStore, AIPracticeQuestion, DeepSeekPracticeService, Bool, Date (+1 more)

### Community 4 - "String"
Cohesion: 0.13
Nodes (15): deepSeekHTTPStatus, ProfileGenerationGroup, adverseEffects, counselingAndLearning, dosageFormsAndDosing, identityAndUses, interactions, pharmacology (+7 more)

### Community 5 - "Chapter"
Cohesion: 0.13
Nodes (19): DoseCalculationResult, DoseCalculator, DoseFormulaKind, fixed, mgPerKgPerDay, mgPerKgPerDose, mgPerSquareMeter, DosePatientInput (+11 more)

### Community 6 - "QuestionType"
Cohesion: 0.25
Nodes (4): openRouterHTTPStatus, OpenRouterKeyStore, OpenRouterPackageVisionService, UserDefaults

### Community 7 - "LibraryView"
Cohesion: 0.16
Nodes (9): OSStatus, LearningSettingsView, Binding, Bool, DeepSeekKeyStore, KeyStoreError, keychain, readBackFailed (+1 more)

### Community 8 - "PracticeSessionView"
Cohesion: 0.06
Nodes (35): Int, ConfirmDrugIdentityView, DrugImportView, FlowChips, ImportFromPhotoView, ImportMemorizationChallengeView, ImportMode, aiDraft (+27 more)

### Community 9 - "ShiftView"
Cohesion: 0.20
Nodes (16): AtomicDrugNote, DailyActivity, Drug, DrugRelationship, EncounterNote, LearningProfile, MemoryItemState, ReviewLog (+8 more)

### Community 10 - "Identifiable"
Cohesion: 0.07
Nodes (29): CodingKeys, adverseReactions, boxedWarning, brandName, clinicalPharmacology, contraindications, dosageAndAdministration, dosageForm (+21 more)

### Community 11 - "SafetyFlag"
Cohesion: 0.33
Nodes (6): AtomicNoteKind, confusingPoint, memoryTrick, patientCounseling, shelfObservation, sourceCorrection

### Community 12 - "DosingFrequency"
Cohesion: 0.14
Nodes (9): NSNumber, DeepSeekJSONSanitizer, memorization, PackageRecognitionResult, Any, Bool, Data, Double (+1 more)

### Community 13 - ".image"
Cohesion: 0.09
Nodes (23): NaturalLanguage, HomeView, RecentStudySection, RecommendedActionCard, CGFloat, Drug, Int, String (+15 more)

### Community 14 - "Build and install PharmaShift using only Windows"
Cohesion: 0.14
Nodes (11): Final Release Gate, PharmaShift Delivery Roadmap, Phase 2 - Visual Pharmacology and Safety, Phase 3 - Backup, Restore, and Export, Phase 4 - Drug Information Import, Phase 5 - Focus, Practice, and Motivation, Renlyst 2.0 — Product and Interface Rebuild, Renlyst (+3 more)

### Community 15 - "CaseIterable"
Cohesion: 0.13
Nodes (17): Error, FileDocument, FileWrapper, BackupDataView, BackupExportKind, complete, csv, lightweight (+9 more)

### Community 16 - "Codable"
Cohesion: 0.15
Nodes (7): DrugImportApplier, DrugImportValidator, ImportSelection, Drug, Set, DrugImportServiceTests, String

### Community 17 - "ImageCapture.swift"
Cohesion: 0.16
Nodes (14): DailyRefreshView, LegacyPracticeView, MistakeVaultView, PracticeChoiceRow, PracticeChoiceState, correct, dimmed, idle (+6 more)

### Community 18 - "DurationBand"
Cohesion: 0.05
Nodes (42): AboutView, AddHubView, AddRouteRow, AppNavigation, AppRoute, drug, drugTopic, AppSheet (+34 more)

### Community 19 - "HomeView"
Cohesion: 0.20
Nodes (6): PharmaShiftUITests, Bool, Int, String, XCUIApplication, XCUIElement

### Community 21 - "ModelAndPersistenceTests"
Cohesion: 0.13
Nodes (12): CaptureView, Binding, Bool, Data, Int, PhotosPickerItem, String, UUID (+4 more)

### Community 22 - "QuestionType"
Cohesion: 0.23
Nodes (27): Codable, Equatable, EliminationInfo, EliminationRouteInfo, PharmacologyProfile, ProdrugInfo, ReproductiveSafetyProfile, Flashcard (+19 more)

### Community 23 - "HomeView"
Cohesion: 0.15
Nodes (6): LegacyDrugDetailView, Bool, Color, Content, Set, ScrollViewProxy

### Community 24 - "Q: What should PharmaShift do after Phase 1?"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: What should PharmaShift do after Phase 1?, Source Nodes

### Community 25 - "Identifiable"
Cohesion: 0.19
Nodes (10): DrugImagePayload, DrugPhotoGalleryView, DrugPhotoView, DrugThumbnailView, ImageDraft, ImageEditorView, Data, Drug (+2 more)

### Community 26 - "FocusField"
Cohesion: 0.09
Nodes (22): DrugDeletionSheet, LibraryCompareView, LibraryDrugRow, LibraryKnowledgeMapView, LibraryScope, all, due, needsAttention (+14 more)

### Community 27 - "DrugImportView.swift"
Cohesion: 0.22
Nodes (6): AltibbiProvider, DrugDataConsistencyNormalizer, URL, Unit, hours, minutes

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
Cohesion: 0.29
Nodes (8): ReviewScheduler, Bool, Calendar, Date, Drug, Int, String, ReviewSchedulerTests

### Community 32 - "Design"
Cohesion: 0.11
Nodes (17): Accessibility floor, Color, Core flows, Design, Dials, Direction, Drug overview, Imagery and icons (+9 more)

### Community 33 - "PharmacologyScale"
Cohesion: 0.40
Nodes (5): DrugRelationshipKind, contraindicatedCombination, interaction, relatedUse, sameClass

### Community 34 - "SwiftData"
Cohesion: 0.05
Nodes (30): CoreTransferable, Foundation, report, ReportEditorView, ReportView, Binding, Date, Double (+22 more)

### Community 35 - "LibraryView"
Cohesion: 0.43
Nodes (4): CGRect, ImageCompressor, CGFloat, UIImage

### Community 36 - "ReviewRating"
Cohesion: 0.12
Nodes (13): App, LinearGradient, Observation, AppTheme, RenlystLayout, RenlystMotion, CGFloat, Color (+5 more)

### Community 37 - ".generate"
Cohesion: 0.24
Nodes (7): PracticeSessionView, MemoryReviewGrade, again, easy, good, hard, PracticeQuestion

### Community 38 - "SafetyRadar"
Cohesion: 0.10
Nodes (15): AtomicNotesView, DoseRegimensView, DrugBrandsSheet, addProduct, DrugBrandsView, LocalDrugGraphView, ProductLeafletEditorView, Binding (+7 more)

### Community 40 - "MemoryReviewGrade"
Cohesion: 0.23
Nodes (8): ClosedRange, Double, OrbitMark, PharmacologyScale, duration, halfLife, onset, Double

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
Cohesion: 0.22
Nodes (8): DrugTopic, brands, counseling, dosing, pharmacology, safety, sources, uses

### Community 45 - ".record"
Cohesion: 0.42
Nodes (6): ProductImagePipeline, ProductPhoto, CGFloat, Data, Int, UIImage

### Community 46 - "ReportFile.swift"
Cohesion: 0.09
Nodes (27): Decodable, AIPracticePayload, Choice, CodingKeys, answer, choices, explanation, finishReason (+19 more)

### Community 47 - "HalfLifeBand"
Cohesion: 0.23
Nodes (9): Destination, PracticeModesView, PracticeSummary, PracticeToolsSection, QuickPracticeSection, RecommendedPracticeCard, Int, String (+1 more)

### Community 48 - "DrugEditorSection"
Cohesion: 0.10
Nodes (18): DrugCardPage, adverse, brands, counseling, doses, forms, interactions, notes (+10 more)

### Community 49 - "PracticeQuestion"
Cohesion: 0.10
Nodes (28): CoreFoundation, Encodable, NSObject, APIError, Choice, DailyMedSearchItem, DailyMedSearchPayload, DeepSeekRequest (+20 more)

### Community 50 - "Color"
Cohesion: 0.12
Nodes (14): PracticeView, PracticeMode, casePractice, classExamples, counseling, drugUse, drugWarning, dueReview (+6 more)

### Community 51 - ".generate"
Cohesion: 0.21
Nodes (9): SafetySeverity, high, low, medium, unknown, SafetyRadar, CGPoint, Color (+1 more)

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
Cohesion: 0.16
Nodes (7): DrugRelationshipRefreshService, DrugSearchRanker, DrugSearchResult, MockDrugSourceProvider, Int, ModelContext, TrustedDrugSourcePacketExtractor

### Community 57 - "Unit"
Cohesion: 0.22
Nodes (6): HTTPURLResponse, DeepSeekURLProtocolStub, Bool, Data, URLRequest, URLProtocol

### Community 58 - "Components.swift"
Cohesion: 0.29
Nodes (5): Context, CameraPicker, Any, UIImagePickerController, UIViewControllerRepresentable

### Community 59 - "PhotosPickerItem"
Cohesion: 0.22
Nodes (9): DosingFrequency, asNeeded, fourTimesDaily, onceDaily, other, threeTimesDaily, twiceDaily, unknown (+1 more)

### Community 60 - "String"
Cohesion: 0.05
Nodes (37): ImportedDosingFrequency, fourTimesDaily, onceDaily, other, PRN, threeTimesDaily, twiceDaily, unknown (+29 more)

### Community 61 - "CGPoint"
Cohesion: 0.28
Nodes (6): PharmaShift, MigrationFixtureTests, ReportBuilderTests, SwiftData, XCTest, XCTestCase

### Community 62 - "Bool"
Cohesion: 0.22
Nodes (9): ImportSection, adverseEffects, arabicExplanation, counseling, identity, pharmacokinetics, safety, sourceQuality (+1 more)

### Community 63 - ".apply"
Cohesion: 0.40
Nodes (4): ButtonStyle, Configuration, RenlystPrimaryButtonStyle, RenlystTileButtonStyle

### Community 64 - "MemoryReviewGrade"
Cohesion: 0.25
Nodes (4): ImageFlowDestination, camera, crop, library

### Community 65 - "Bool"
Cohesion: 0.24
Nodes (8): DrugEditorView, Binding, Bool, Drug, Int, PhotosPickerItem, ReferenceWritableKeyPath, DrugSourceProvider

### Community 66 - "DoseRegimensView"
Cohesion: 0.33
Nodes (7): MigrationStage, PersistentModel, CurrentDrugSchema, DrugMigrationPlan, Phase1DrugSchema, SchemaMigrationPlan, VersionedSchema

### Community 67 - "Decoder"
Cohesion: 0.16
Nodes (16): ActiveShiftCard, ActiveShiftContent, EncounterEditorView, EndShiftView, ShiftPhase, ShiftPhaseRow, ShiftView, Binding (+8 more)

### Community 68 - "ReportFile.swift"
Cohesion: 0.06
Nodes (31): CaseIterable, DrugEvidenceQuality, aiUnverified, altibbi, manual, officialLabel, productLeaflet, DurationBand (+23 more)

### Community 69 - "String"
Cohesion: 0.39
Nodes (4): DrugBackupDTO, Bool, Double, Drug

### Community 70 - "MemoryReviewGrade"
Cohesion: 0.40
Nodes (4): CropGrid, CGPoint, Path, Shape

### Community 71 - "DrugDetailView.swift"
Cohesion: 0.50
Nodes (4): FocusField, scientific, trade, unknownLabel

### Community 72 - "ExcretionRoute"
Cohesion: 0.12
Nodes (18): GeneratedReviewQuestion, PracticeInteraction, multipleChoice, recall, textEntry, trueFalse, QuestionDifficulty, application (+10 more)

### Community 73 - ".matches"
Cohesion: 0.18
Nodes (10): Accessibility & Inclusion, Anti-references, Brand Personality, Design Principles, Platform, Positioning, Product, Product Purpose (+2 more)

### Community 74 - "AIPracticePayload"
Cohesion: 0.50
Nodes (4): VerificationStatus, pendingPharmacist, personal, pharmacistVerified

### Community 75 - "SafetyFlag"
Cohesion: 0.11
Nodes (27): Hashable, Identifiable, AdverseEffectEntry, ClinicalDoseEntry, ConfidenceLevel, mastered, medium, strong (+19 more)

### Community 77 - "DrugDetailSheet"
Cohesion: 0.11
Nodes (18): Double, YouView, InteractionCategory, contraindicated, minor, monitorClosely, seriousUseAlternative, unknown (+10 more)

### Community 80 - "VerificationStatus"
Cohesion: 0.14
Nodes (13): SaveAction, another, later, open, DrugEditorSection, basics, counseling, notes (+5 more)

### Community 83 - "LocalDrugGraphView"
Cohesion: 0.29
Nodes (7): EliminationPathway, biliaryFecal, mixed, other, pulmonary, renalUrine, unknown

### Community 87 - "BackupError"
Cohesion: 0.40
Nodes (5): BackupError, duplicateIdentifiers, invalidCounts, malformed, newerVersion

### Community 90 - "Binding"
Cohesion: 0.25
Nodes (8): SafetyFlag, anticoagulant, children, controlledDrug, corticosteroid, insulin, pregnancy, severeSymptoms

## Knowledge Gaps
- **392 isolated node(s):** `today`, `library`, `practice`, `you`, `drugTopic` (+387 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **4 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `View` connect `ReportEditorView` to `ShiftLog`, `ImageCapture.swift`, `LibraryView`, `PracticeSessionView`, `.image`, `CaseIterable`, `ImageCapture.swift`, `DurationBand`, `ModelAndPersistenceTests`, `HomeView`, `Identifiable`, `FocusField`, `SwiftData`, `.generate`, `SafetyRadar`, `MemoryReviewGrade`, `DosingFrequency`, `.record`, `ReportFile.swift`, `HalfLifeBand`, `DrugEditorSection`, `Color`, `.generate`, `NameKind`, `PhotosPickerItem`, `.apply`, `Bool`, `Decoder`, `Binding`, `DrugDetailSheet`, `Bool`?**
  _High betweenness centrality (0.179) - this node is a cross-community bridge._
- **Why does `SwiftData` connect `CGPoint` to `ShiftLog`, `SwiftData`, `Decoder`, `ReviewRating`, `SafetyRadar`, `PracticeSessionView`, `SafetyFlag`, `.image`, `CaseIterable`, `VerificationStatus`, `HalfLifeBand`, `DurationBand`, `ImageCapture.swift`, `PracticeQuestion`, `FocusField`, `Foundation`, `ReportEditorView`?**
  _High betweenness centrality (0.064) - this node is a cross-community bridge._
- **Why does `Foundation` connect `SwiftData` to `ShiftLog`, `ReviewRating`, `SafetyFlag`, `.image`, `ReportFile.swift`, `PracticeQuestion`, `Foundation`, `CGPoint`?**
  _High betweenness centrality (0.050) - this node is a cross-community bridge._
- **What connects `today`, `library`, `practice` to the rest of the system?**
  _392 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `ShiftLog` be split into smaller, more focused modules?**
  _Cohesion score 0.05364314400458979 - nodes in this community are weakly interconnected._
- **Should `Drug` be split into smaller, more focused modules?**
  _Cohesion score 0.12043010752688173 - nodes in this community are weakly interconnected._
- **Should `String` be split into smaller, more focused modules?**
  _Cohesion score 0.12666666666666668 - nodes in this community are weakly interconnected._