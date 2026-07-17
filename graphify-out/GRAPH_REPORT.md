# Graph Report - pharmashift  (2026-07-17)

## Corpus Check
- 54 files · ~462,656 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1612 nodes · 4296 edges · 93 communities (89 shown, 4 thin omitted)
- Extraction: 96% EXTRACTED · 4% INFERRED · 0% AMBIGUOUS · INFERRED: 185 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `676933c4`
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
- [[_COMMUNITY_MemoryAnchorKind|MemoryAnchorKind]]
- [[_COMMUNITY_VerificationStatus|VerificationStatus]]
- [[_COMMUNITY_.isValid|.isValid]]
- [[_COMMUNITY_ImportStage|ImportStage]]
- [[_COMMUNITY_LocalDrugGraphView|LocalDrugGraphView]]
- [[_COMMUNITY_DrugLibraryMutationService.swift|DrugLibraryMutationService.swift]]
- [[_COMMUNITY_AppTab|AppTab]]
- [[_COMMUNITY_ExcretionRoute|ExcretionRoute]]
- [[_COMMUNITY_BackupError|BackupError]]
- [[_COMMUNITY_Bool|Bool]]
- [[_COMMUNITY_Int|Int]]
- [[_COMMUNITY_Binding|Binding]]
- [[_COMMUNITY_String|String]]
- [[_COMMUNITY_NameKind|NameKind]]

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

## Communities (93 total, 4 thin omitted)

### Community 0 - "ShiftLog"
Cohesion: 0.11
Nodes (15): DrugFilter, Bool, Calendar, Date, Drug, Drug, MigrationFixtureTests, Bool (+7 more)

### Community 1 - "SwiftUI"
Cohesion: 0.13
Nodes (13): Context, CameraPicker, Coordinator, Any, Bool, UIImagePickerController, UIImagePickerControllerDelegate, UINavigationControllerDelegate (+5 more)

### Community 2 - "Drug"
Cohesion: 0.13
Nodes (8): title, DailyMedProvider, DeepSeekFastDrugGatherService, DrugSourceProviderFactory, OpenFDALabelProvider, RxNormProvider, URLResponse, URLSession

### Community 3 - "ImageCapture.swift"
Cohesion: 0.14
Nodes (15): AIPracticePackView, LegacyPracticeView, AIPracticePack, AIPracticePackStore, Choice, DeepSeekContentResponse, DeepSeekIdentityResolver, DeepSeekJSONClient (+7 more)

### Community 4 - "String"
Cohesion: 0.12
Nodes (16): deepSeekHTTPStatus, DrugImportValidator, ProfileGenerationGroup, adverseEffects, counselingAndLearning, dosageFormsAndDosing, identityAndUses, interactions (+8 more)

### Community 5 - "Chapter"
Cohesion: 0.13
Nodes (19): DoseCalculationResult, DoseCalculator, DoseFormulaKind, fixed, mgPerKgPerDay, mgPerKgPerDose, mgPerSquareMeter, DosePatientInput (+11 more)

### Community 6 - "QuestionType"
Cohesion: 0.15
Nodes (11): Int, DrugImportView, ImportMode, aiDraft, trusted, Bool, Drug, PhotosPickerItem (+3 more)

### Community 7 - "LibraryView"
Cohesion: 0.20
Nodes (7): OSStatus, DeepSeekKeyStore, KeyStoreError, keychain, readBackFailed, String, UserDefaults

### Community 8 - "PracticeSessionView"
Cohesion: 0.10
Nodes (23): ConfirmDrugIdentityView, FlowChips, ImportFromPhotoView, ImportMemorizationChallengeView, ImportPreviewView, ImportSourceSearchView, ImportStage, challenge (+15 more)

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
Cohesion: 0.22
Nodes (6): NSNumber, DeepSeekJSONSanitizer, memorization, Any, Data, UInt8

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
Cohesion: 0.07
Nodes (26): BrandProductForm, Binding, Bool, Data, Int, PhotosPickerItem, DrugDeletionSheet, Void (+18 more)

### Community 17 - "ImageCapture.swift"
Cohesion: 0.11
Nodes (16): DailyRefreshView, MistakeVaultView, PracticeChoiceRow, PracticeChoiceState, correct, dimmed, idle, incorrect (+8 more)

### Community 18 - "DurationBand"
Cohesion: 0.05
Nodes (42): AboutView, AddHubView, AddRouteRow, AppNavigation, AppRoute, drug, drugTopic, AppSheet (+34 more)

### Community 19 - "HomeView"
Cohesion: 0.21
Nodes (6): PharmaShiftUITests, Bool, Int, String, XCUIApplication, XCUIElement

### Community 21 - "ModelAndPersistenceTests"
Cohesion: 0.09
Nodes (16): CaptureView, Binding, Bool, Data, Int, PhotosPickerItem, String, UUID (+8 more)

### Community 22 - "QuestionType"
Cohesion: 0.23
Nodes (27): Codable, Equatable, EliminationInfo, EliminationRouteInfo, PharmacologyProfile, ProdrugInfo, ReproductiveSafetyProfile, Flashcard (+19 more)

### Community 23 - "HomeView"
Cohesion: 0.18
Nodes (7): LearningSettingsView, Binding, Bool, openRouterHTTPStatus, OpenRouterKeyStore, OpenRouterPackageVisionService, URLRequest

### Community 24 - "Q: What should PharmaShift do after Phase 1?"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: What should PharmaShift do after Phase 1?, Source Nodes

### Community 25 - "Identifiable"
Cohesion: 0.22
Nodes (10): DrugImagePayload, DrugPhotoGalleryView, DrugPhotoView, DrugThumbnailView, ImageDraft, ImageEditorView, CGFloat, Data (+2 more)

### Community 26 - "FocusField"
Cohesion: 0.11
Nodes (19): LibraryDrugRow, LibraryKnowledgeMapView, LibraryScope, all, due, needsAttention, noPhoto, LibrarySort (+11 more)

### Community 27 - "DrugImportView.swift"
Cohesion: 0.23
Nodes (4): AltibbiProvider, DrugDataConsistencyNormalizer, Double, URL

### Community 28 - "Foundation"
Cohesion: 0.21
Nodes (14): BackupRecordCounts, DailyActivityBackupDTO, DrugProductBackupDTO, DrugRelationshipBackupDTO, EncounterBackupDTO, LearningProfileBackupDTO, PharmaShiftBackup, ReviewBackupDTO (+6 more)

### Community 29 - "ReportEditorView"
Cohesion: 0.15
Nodes (21): View, ArabicSummarySurface, BrandProductRow, DrugBrandsScreen, DrugCounselingScreen, DrugDetailView, DrugDosingScreen, DrugIdentityHeader (+13 more)

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
Cohesion: 0.20
Nodes (6): DrugImportApplier, ImportSelection, Drug, Set, DrugImportServiceTests, String

### Community 34 - "SwiftData"
Cohesion: 0.16
Nodes (7): DrugRelationshipRefreshService, DrugSearchRanker, DrugSearchResult, MockDrugSourceProvider, Int, ModelContext, TrustedDrugSourcePacketExtractor

### Community 35 - "LibraryView"
Cohesion: 0.37
Nodes (5): CGRect, ImageCompressor, CGSize, Int, UIImage

### Community 36 - "ReviewRating"
Cohesion: 0.15
Nodes (10): App, LinearGradient, Observation, AppTheme, RenlystLayout, RenlystMotion, CGFloat, Color (+2 more)

### Community 37 - ".generate"
Cohesion: 0.33
Nodes (4): PracticeSessionView, Drug, String, PracticeQuestion

### Community 38 - "SafetyRadar"
Cohesion: 0.24
Nodes (5): ProductLeafletEditorView, Binding, Data, Drug, PhotosPickerItem

### Community 40 - "MemoryReviewGrade"
Cohesion: 0.27
Nodes (6): AIPracticePayload, AIPracticeQuestion, DeepSeekPracticeService, Bool, Decoder, Drug

### Community 41 - "DosingFrequency"
Cohesion: 0.22
Nodes (7): BackupImportPreviewView, Int, Void, BackupRestoreMode, merge, replace, BackupRestoreSummary

### Community 42 - "SafetyRadar"
Cohesion: 0.21
Nodes (4): PracticeEngineTests, Drug, Int, ModelContainer

### Community 43 - "DrugRelationshipKind"
Cohesion: 0.35
Nodes (3): PracticeGenerator, Drug, Int

### Community 44 - "SafetyFlag"
Cohesion: 0.22
Nodes (9): DrugTopic, brands, counseling, dosing, pharmacology, safety, sources, uses (+1 more)

### Community 45 - ".record"
Cohesion: 0.42
Nodes (6): ProductImagePipeline, ProductPhoto, CGFloat, Data, Int, UIImage

### Community 46 - "ReportFile.swift"
Cohesion: 0.20
Nodes (10): CodingKeys, answer, choices, explanation, finishReason, message, prompt, questions (+2 more)

### Community 47 - "HalfLifeBand"
Cohesion: 0.23
Nodes (9): Destination, PracticeModesView, PracticeSummary, PracticeToolsSection, QuickPracticeSection, RecommendedPracticeCard, Int, String (+1 more)

### Community 48 - "DrugEditorSection"
Cohesion: 0.15
Nodes (6): LegacyDrugDetailView, Bool, Color, Content, Set, ScrollViewProxy

### Community 49 - "PracticeQuestion"
Cohesion: 0.13
Nodes (29): CoreFoundation, Decodable, Encodable, APIError, Candidate, Choice, DailyMedSearchItem, DailyMedSearchPayload (+21 more)

### Community 50 - "Color"
Cohesion: 0.12
Nodes (15): PracticeView, Drug, PracticeMode, casePractice, classExamples, counseling, drugUse, drugWarning (+7 more)

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
Cohesion: 0.13
Nodes (11): HTTPURLResponse, NSObject, SPLParser, SPLXMLDelegate, DeepSeekURLProtocolStub, Bool, Data, URLRequest (+3 more)

### Community 57 - "Unit"
Cohesion: 0.33
Nodes (3): PrivacyValidator, Bool, String

### Community 58 - "Components.swift"
Cohesion: 0.12
Nodes (14): report, ReportEditorView, ReportView, Binding, Date, Double, Drug, ReferenceWritableKeyPath (+6 more)

### Community 59 - "PhotosPickerItem"
Cohesion: 0.22
Nodes (9): DosingFrequency, asNeeded, fourTimesDaily, onceDaily, other, threeTimesDaily, twiceDaily, unknown (+1 more)

### Community 60 - "String"
Cohesion: 0.05
Nodes (37): ImportedDosingFrequency, fourTimesDaily, onceDaily, other, PRN, threeTimesDaily, twiceDaily, unknown (+29 more)

### Community 61 - "CGPoint"
Cohesion: 0.15
Nodes (14): GeneratedReviewQuestion, PracticeInteraction, multipleChoice, recall, textEntry, trueFalse, QuestionType, casePractice (+6 more)

### Community 62 - "Bool"
Cohesion: 0.12
Nodes (16): SaveAction, another, later, open, ShelfQuestView, Double, Drug, Int (+8 more)

### Community 63 - ".apply"
Cohesion: 0.40
Nodes (4): ButtonStyle, Configuration, RenlystPrimaryButtonStyle, RenlystTileButtonStyle

### Community 64 - "MemoryReviewGrade"
Cohesion: 0.29
Nodes (6): CoreTransferable, ReportFile, String, Transferable, TransferRepresentation, UniformTypeIdentifiers

### Community 65 - "Bool"
Cohesion: 0.24
Nodes (8): DrugEditorView, Binding, Bool, Drug, Int, PhotosPickerItem, ReferenceWritableKeyPath, DrugSourceProvider

### Community 66 - "DoseRegimensView"
Cohesion: 0.23
Nodes (8): ClosedRange, Double, OrbitMark, PharmacologyScale, duration, halfLife, onset, Double

### Community 67 - "Decoder"
Cohesion: 0.16
Nodes (16): ActiveShiftCard, ActiveShiftContent, EncounterEditorView, EndShiftView, ShiftPhase, ShiftPhaseRow, ShiftView, Binding (+8 more)

### Community 68 - "ReportFile.swift"
Cohesion: 0.06
Nodes (32): CaseIterable, ConfidenceLevel, mastered, medium, strong, weak, DrugRelationshipKind, contraindicatedCombination (+24 more)

### Community 69 - "String"
Cohesion: 0.39
Nodes (4): DrugBackupDTO, Bool, Double, Drug

### Community 70 - "MemoryReviewGrade"
Cohesion: 0.18
Nodes (8): CropGrid, CropViewportState, NativeCropScrollView, CGPoint, Path, Shape, UIEdgeInsets, UIViewRepresentable

### Community 71 - "DrugDetailView.swift"
Cohesion: 0.50
Nodes (4): FocusField, scientific, trade, unknownLabel

### Community 72 - "ExcretionRoute"
Cohesion: 0.15
Nodes (13): DrugCardPage, adverse, brands, counseling, doses, forms, interactions, notes (+5 more)

### Community 73 - ".matches"
Cohesion: 0.18
Nodes (10): Accessibility & Inclusion, Anti-references, Brand Personality, Design Principles, Platform, Positioning, Product, Product Purpose (+2 more)

### Community 74 - "AIPracticePayload"
Cohesion: 0.23
Nodes (4): Foundation, PharmaShift, ReportBuilderTests, XCTest

### Community 75 - "SafetyFlag"
Cohesion: 0.10
Nodes (29): Hashable, Identifiable, AdverseEffectEntry, ClinicalDoseEntry, DosageFormGroup, DrugFieldEvidence, DrugInteractionEntry, DurationBand (+21 more)

### Community 76 - "Binding"
Cohesion: 0.24
Nodes (6): DoseRegimensView, LocalDrugGraphView, CGPoint, CGSize, Double, Int

### Community 77 - "DrugDetailSheet"
Cohesion: 0.09
Nodes (22): Double, YouView, InteractionCategory, contraindicated, minor, monitorClosely, seriousUseAlternative, unknown (+14 more)

### Community 79 - "MemoryAnchorKind"
Cohesion: 0.29
Nodes (7): MemoryAnchorKind, counseling, empty, mechanism, mustKnow, safety, use

### Community 80 - "VerificationStatus"
Cohesion: 0.29
Nodes (7): DrugEditorSection, basics, counseling, notes, pk, safety, uses

### Community 82 - "ImportStage"
Cohesion: 0.22
Nodes (9): ImportSection, adverseEffects, arabicExplanation, counseling, identity, pharmacokinetics, safety, sourceQuality (+1 more)

### Community 83 - "LocalDrugGraphView"
Cohesion: 0.36
Nodes (7): MigrationStage, PersistentModel, CurrentDrugSchema, DrugMigrationPlan, Phase1DrugSchema, SchemaMigrationPlan, VersionedSchema

### Community 84 - "DrugLibraryMutationService.swift"
Cohesion: 0.29
Nodes (5): DrugDetailSheet, atomicNotes, editor, regenerateReview, review

### Community 85 - "AppTab"
Cohesion: 0.33
Nodes (6): DrugEvidenceQuality, aiUnverified, altibbi, manual, officialLabel, productLeaflet

### Community 87 - "BackupError"
Cohesion: 0.40
Nodes (5): BackupError, duplicateIdentifiers, invalidCounts, malformed, newerVersion

### Community 88 - "Bool"
Cohesion: 0.50
Nodes (3): LibraryCompareView, Binding, UUID

### Community 89 - "Int"
Cohesion: 0.60
Nodes (3): DeepSeekDrugImportService, DrugImportFormattingService, MockDeepSeekDrugImportService

### Community 90 - "Binding"
Cohesion: 0.25
Nodes (8): SafetyFlag, anticoagulant, children, controlledDrug, corticosteroid, insulin, pregnancy, severeSymptoms

### Community 91 - "String"
Cohesion: 0.67
Nodes (3): DrugBrandsSheet, addProduct, DrugBrandsView

### Community 92 - "NameKind"
Cohesion: 0.67
Nodes (3): NameKind, brand, generic

## Knowledge Gaps
- **392 isolated node(s):** `today`, `library`, `practice`, `you`, `drugTopic` (+387 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **4 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `View` connect `ReportEditorView` to `ImageCapture.swift`, `QuestionType`, `PracticeSessionView`, `.image`, `CaseIterable`, `Codable`, `ImageCapture.swift`, `DurationBand`, `ModelAndPersistenceTests`, `HomeView`, `Identifiable`, `FocusField`, `.generate`, `SafetyRadar`, `DosingFrequency`, `SafetyFlag`, `.record`, `HalfLifeBand`, `DrugEditorSection`, `PracticeQuestion`, `Color`, `.generate`, `NameKind`, `Components.swift`, `PhotosPickerItem`, `Bool`, `.apply`, `Bool`, `DoseRegimensView`, `Decoder`, `Binding`, `DrugDetailSheet`, `Bool`, `DrugLibraryMutationService.swift`, `ExcretionRoute`, `Bool`, `String`?**
  _High betweenness centrality (0.179) - this node is a cross-community bridge._
- **Why does `SwiftData` connect `Bool` to `Decoder`, `ReviewRating`, `Components.swift`, `PracticeSessionView`, `AIPracticePayload`, `SafetyFlag`, `.image`, `CaseIterable`, `HalfLifeBand`, `ImageCapture.swift`, `DurationBand`, `PracticeQuestion`, `Codable`, `LocalDrugGraphView`, `FocusField`, `String`, `Foundation`, `ReportEditorView`?**
  _High betweenness centrality (0.064) - this node is a cross-community bridge._
- **Why does `Foundation` connect `AIPracticePayload` to `MemoryReviewGrade`, `ImageCapture.swift`, `ReviewRating`, `SafetyFlag`, `.image`, `Codable`, `PracticeQuestion`, `DurationBand`, `Unit`, `Foundation`?**
  _High betweenness centrality (0.050) - this node is a cross-community bridge._
- **What connects `today`, `library`, `practice` to the rest of the system?**
  _392 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `ShiftLog` be split into smaller, more focused modules?**
  _Cohesion score 0.1111111111111111 - nodes in this community are weakly interconnected._
- **Should `SwiftUI` be split into smaller, more focused modules?**
  _Cohesion score 0.1339031339031339 - nodes in this community are weakly interconnected._
- **Should `Drug` be split into smaller, more focused modules?**
  _Cohesion score 0.13 - nodes in this community are weakly interconnected._