# Graph Report - pharmashift  (2026-07-17)

## Corpus Check
- 54 files · ~462,319 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1607 nodes · 4277 edges · 87 communities (82 shown, 5 thin omitted)
- Extraction: 96% EXTRACTED · 4% INFERRED · 0% AMBIGUOUS · INFERRED: 185 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `d68ba0c7`
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
- [[_COMMUNITY_DurationBand|DurationBand]]
- [[_COMMUNITY_SafetySeverity|SafetySeverity]]
- [[_COMMUNITY_Binding|Binding]]
- [[_COMMUNITY_LibrarySummaryRow|LibrarySummaryRow]]

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
- `PharmaShiftApp` --calls--> `AppTheme`  [INFERRED]
  PharmaShift/App/PharmaShiftApp.swift → PharmaShift/App/AppTheme.swift
- `DrugImportView` --calls--> `DeepSeekIdentityResolver`  [INFERRED]
  PharmaShift/Features/Library/DrugImportView.swift → PharmaShift/Services/DeepSeekLearningService.swift

## Import Cycles
- None detected.

## Communities (87 total, 5 thin omitted)

### Community 0 - "ShiftLog"
Cohesion: 0.11
Nodes (13): DrugFilter, Bool, Calendar, Date, Drug, Drug, Bool, Data (+5 more)

### Community 1 - "SwiftUI"
Cohesion: 0.16
Nodes (12): Coordinator, NativeCropScrollView, Bool, CGSize, Int, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollView (+4 more)

### Community 2 - "Drug"
Cohesion: 0.25
Nodes (6): PracticeCase, StarterContent, Drug, Int, ModelContext, String

### Community 4 - "String"
Cohesion: 0.10
Nodes (15): deepSeekHTTPStatus, DrugSearchRanker, FastGatherPromptBuilder, ProfileGenerationGroup, adverseEffects, counselingAndLearning, dosageFormsAndDosing, identityAndUses (+7 more)

### Community 5 - "Chapter"
Cohesion: 0.14
Nodes (20): DoseCalculationResult, DoseCalculator, DoseFormulaKind, fixed, mgPerKgPerDay, mgPerKgPerDose, mgPerSquareMeter, DosePatientInput (+12 more)

### Community 6 - "QuestionType"
Cohesion: 0.10
Nodes (20): Int, ConfirmDrugIdentityView, DrugImportView, ImportFromPhotoView, ImportMemorizationChallengeView, ImportMode, aiDraft, trusted (+12 more)

### Community 7 - "LibraryView"
Cohesion: 0.11
Nodes (9): LearningSettingsView, Binding, Bool, DeepSeekKeyStore, openRouterHTTPStatus, keychain, OpenRouterKeyStore, OpenRouterPackageVisionService (+1 more)

### Community 8 - "PracticeSessionView"
Cohesion: 0.19
Nodes (9): FlowChips, ImportPreviewView, Color, String, Severity, high, low, medium (+1 more)

### Community 9 - "ShiftView"
Cohesion: 0.10
Nodes (39): Hashable, Identifiable, AdverseEffectEntry, AtomicDrugNote, ClinicalDoseEntry, DailyActivity, DosageFormGroup, Drug (+31 more)

### Community 10 - "Identifiable"
Cohesion: 0.05
Nodes (38): CodingKey, CodingKeys, dailyActivities, drugs, encounters, learningProfiles, reports, reviews (+30 more)

### Community 11 - "SafetyFlag"
Cohesion: 0.09
Nodes (21): Binding, Content, DrugDataConsistencyNormalizer, DrugImportApplier, ImportSection, adverseEffects, arabicExplanation, counseling (+13 more)

### Community 12 - "DosingFrequency"
Cohesion: 0.28
Nodes (4): DeepSeekJSONSanitizer, Any, Data, UInt8

### Community 13 - ".image"
Cohesion: 0.09
Nodes (23): NaturalLanguage, HomeView, RecentStudySection, RecommendedActionCard, CGFloat, Drug, Int, String (+15 more)

### Community 14 - "Build and install PharmaShift using only Windows"
Cohesion: 0.14
Nodes (11): Final Release Gate, PharmaShift Delivery Roadmap, Phase 2 - Visual Pharmacology and Safety, Phase 3 - Backup, Restore, and Export, Phase 4 - Drug Information Import, Phase 5 - Focus, Practice, and Motivation, Renlyst 2.0 — Product and Interface Rebuild, Renlyst (+3 more)

### Community 15 - "CaseIterable"
Cohesion: 0.30
Nodes (8): ProductImagePipeline, ProductPhoto, CGFloat, CGPoint, Data, Int, Path, UIImage

### Community 16 - "Codable"
Cohesion: 0.14
Nodes (37): Codable, Equatable, EliminationInfo, EliminationPathway, biliaryFecal, mixed, other, pulmonary (+29 more)

### Community 17 - "ImageCapture.swift"
Cohesion: 0.35
Nodes (3): CGRect, ImageCompressor, UIImage

### Community 18 - "DurationBand"
Cohesion: 0.11
Nodes (17): AppNavigation, AppSheet, addHub, capture, Chapter, antibiotics, cardiovascular, dermatology (+9 more)

### Community 19 - "HomeView"
Cohesion: 0.24
Nodes (5): PharmaShiftUITests, Int, String, XCUIApplication, XCUIElement

### Community 21 - "ModelAndPersistenceTests"
Cohesion: 0.12
Nodes (12): CaptureView, Binding, Bool, Data, Int, PhotosPickerItem, String, UUID (+4 more)

### Community 22 - "QuestionType"
Cohesion: 0.19
Nodes (10): Encodable, NSNumber, DeepSeekRequest, DrugImportValidator, Message, ResponseFormat, Bool, Double (+2 more)

### Community 23 - "HomeView"
Cohesion: 0.11
Nodes (13): Int, DrugDetailSheet, atomicNotes, editor, regenerateReview, review, LegacyDrugDetailView, Bool (+5 more)

### Community 24 - "Q: What should PharmaShift do after Phase 1?"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: What should PharmaShift do after Phase 1?, Source Nodes

### Community 25 - "Identifiable"
Cohesion: 0.06
Nodes (28): BrandProductForm, Binding, Bool, Data, Int, PhotosPickerItem, DrugLibraryMigrationService, DrugProduct (+20 more)

### Community 26 - "FocusField"
Cohesion: 0.09
Nodes (22): DrugDeletionSheet, LibraryCompareView, LibraryDrugRow, LibraryKnowledgeMapView, LibraryScope, all, due, needsAttention (+14 more)

### Community 27 - "DrugImportView.swift"
Cohesion: 0.20
Nodes (4): Foundation, PrivacyValidator, Bool, String

### Community 28 - "Foundation"
Cohesion: 0.05
Nodes (55): CoreTransferable, Error, FileDocument, FileWrapper, BackupDataView, BackupExportKind, complete, csv (+47 more)

### Community 29 - "ReportEditorView"
Cohesion: 0.15
Nodes (24): View, ArabicSummarySurface, BrandProductRow, DrugBrandsScreen, DrugCounselingScreen, DrugDetailView, DrugDosingScreen, DrugIdentityHeader (+16 more)

### Community 30 - "Path"
Cohesion: 0.27
Nodes (5): BackupServiceTests, ModelContainer, MigrationFixtureTests, ReportBuilderTests, XCTestCase

### Community 31 - ".apply"
Cohesion: 0.32
Nodes (6): SafetySeverity, high, low, medium, unknown, SafetyRadar

### Community 32 - "Design"
Cohesion: 0.11
Nodes (17): Accessibility floor, Color, Core flows, Design, Dials, Direction, Drug overview, Imagery and icons (+9 more)

### Community 33 - "PharmacologyScale"
Cohesion: 0.14
Nodes (12): DailyRefreshView, LegacyPracticeView, MistakeVaultView, PracticeChoiceRow, PracticeChoiceState, correct, dimmed, idle (+4 more)

### Community 34 - "SwiftData"
Cohesion: 0.27
Nodes (10): Choice, DeepSeekContentResponse, DeepSeekIdentityResolver, DeepSeekJSONClient, DrugIdentityResolving, Message, ResolvedDrugIdentity, Data (+2 more)

### Community 35 - "LibraryView"
Cohesion: 0.25
Nodes (8): DrugEditorView, Binding, Bool, Double, Drug, Int, PhotosPickerItem, ReferenceWritableKeyPath

### Community 36 - "ReviewRating"
Cohesion: 0.12
Nodes (15): App, PharmaShift, PharmaShiftApp, FocusField, scientific, trade, unknownLabel, PreviewData (+7 more)

### Community 37 - ".generate"
Cohesion: 0.33
Nodes (4): PracticeSessionView, Drug, String, PracticeQuestion

### Community 38 - "SafetyRadar"
Cohesion: 0.09
Nodes (19): AtomicNotesView, DoseRegimensView, DrugBrandsSheet, addProduct, DrugBrandsView, LocalDrugGraphView, ProductLeafletEditorView, Binding (+11 more)

### Community 40 - "MemoryReviewGrade"
Cohesion: 0.24
Nodes (5): DeepSeekDrugImportService, DeepSeekFastDrugGatherService, DrugImportFormattingService, DrugSourceProviderFactory, URLSession

### Community 41 - "DosingFrequency"
Cohesion: 0.29
Nodes (5): Context, CameraPicker, Any, UIImagePickerController, UIViewControllerRepresentable

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
Nodes (10): DrugImagePayload, DrugPhotoGalleryView, DrugPhotoView, DrugThumbnailView, ImageDraft, ImageEditorView, CGFloat, Data (+2 more)

### Community 46 - "ReportFile.swift"
Cohesion: 0.27
Nodes (6): AIPracticePayload, AIPracticeQuestion, DeepSeekPracticeService, Bool, Decoder, Drug

### Community 47 - "HalfLifeBand"
Cohesion: 0.23
Nodes (9): Destination, PracticeModesView, PracticeSummary, PracticeToolsSection, QuickPracticeSection, RecommendedPracticeCard, Int, String (+1 more)

### Community 48 - "DrugEditorSection"
Cohesion: 0.15
Nodes (13): DrugCardPage, adverse, brands, counseling, doses, forms, interactions, notes (+5 more)

### Community 49 - "PracticeQuestion"
Cohesion: 0.48
Nodes (7): Decodable, Choice, DeepSeekResponse, Group, OpenRouterChatResponse, RxNormApproxPayload, RxNormNamePayload

### Community 50 - "Color"
Cohesion: 0.12
Nodes (15): PracticeView, Drug, PracticeMode, casePractice, classExamples, counseling, drugUse, drugWarning (+7 more)

### Community 51 - ".generate"
Cohesion: 0.20
Nodes (10): DurationBand, long, medium, short, unknown, ImportedDurationBand, long, medium (+2 more)

### Community 52 - "ImportedExcretionRoute"
Cohesion: 0.08
Nodes (25): LocalizedError, DoseCalculatorError, ageOutsideRegimen, heightRequired, invalidRegimen, sexOutsideRegimen, weightRequired, DrugImportError (+17 more)

### Community 53 - "DrugEditorSection"
Cohesion: 0.20
Nodes (10): DrugCardAnchor, arabic, counseling, identity, mastery, notes, pharmacology, review (+2 more)

### Community 54 - ".containsObviousIdentifier"
Cohesion: 0.40
Nodes (5): AppTab, library, practice, today, you

### Community 55 - "NameKind"
Cohesion: 0.33
Nodes (6): AtomicNoteKind, confusingPoint, memoryTrick, patientCounseling, shelfObservation, sourceCorrection

### Community 56 - "FocusField"
Cohesion: 0.07
Nodes (40): CoreFoundation, NSObject, OSStatus, APIError, Candidate, title, DailyMedProvider, DailyMedSearchItem (+32 more)

### Community 57 - "Unit"
Cohesion: 0.15
Nodes (15): AboutView, AddHubView, AddRouteRow, AppRoute, drug, drugTopic, AppShell, CommandPaletteView (+7 more)

### Community 58 - "Components.swift"
Cohesion: 0.20
Nodes (10): OnsetBand, fast, moderate, slow, unknown, ImportedOnsetBand, fast, moderate (+2 more)

### Community 60 - "String"
Cohesion: 0.06
Nodes (31): HalfLifeBand, long, medium, short, unknown, veryLong, ProdrugStatus, active (+23 more)

### Community 61 - "CGPoint"
Cohesion: 0.25
Nodes (7): LinearGradient, Observation, AppTheme, RenlystLayout, RenlystMotion, CGFloat, Color

### Community 62 - "Bool"
Cohesion: 0.36
Nodes (4): AIPracticePackView, AIPracticePack, AIPracticePackStore, Date

### Community 63 - ".apply"
Cohesion: 0.22
Nodes (9): CaseIterable, ConfidenceLevel, mastered, medium, strong, weak, DrugDeletionHistoryPolicy, eraseHistory (+1 more)

### Community 64 - "MemoryReviewGrade"
Cohesion: 0.36
Nodes (7): MigrationStage, PersistentModel, CurrentDrugSchema, DrugMigrationPlan, Phase1DrugSchema, SchemaMigrationPlan, VersionedSchema

### Community 65 - "Bool"
Cohesion: 0.18
Nodes (11): ExcretionRoute, hepatic, mixed, renal, unknown, ImportedExcretionRoute, hepatic, mixed (+3 more)

### Community 66 - "DoseRegimensView"
Cohesion: 0.25
Nodes (6): CropGrid, CropViewportState, CGPoint, Path, Shape, UIEdgeInsets

### Community 67 - "Decoder"
Cohesion: 0.07
Nodes (32): report, ReportEditorView, ReportView, Binding, Date, Double, Drug, ReferenceWritableKeyPath (+24 more)

### Community 68 - "ReportFile.swift"
Cohesion: 0.29
Nodes (7): DrugEditorSection, basics, counseling, notes, pk, safety, uses

### Community 69 - "String"
Cohesion: 0.33
Nodes (5): ButtonStyle, Configuration, RenlystPrimaryButtonStyle, RenlystTileButtonStyle, Color

### Community 70 - "MemoryReviewGrade"
Cohesion: 0.33
Nodes (6): DrugEvidenceQuality, aiUnverified, altibbi, manual, officialLabel, productLeaflet

### Community 71 - "DrugDetailView.swift"
Cohesion: 0.14
Nodes (19): ClosedRange, ImageIO, EmptyStateView, LabeledValue, MasteryBadge, MetricCard, OrbitMark, PharmacologyMeter (+11 more)

### Community 72 - "ExcretionRoute"
Cohesion: 0.25
Nodes (8): QuestionType, casePractice, counseling, drugClass, scientificName, tradeName, use, warning

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
Cohesion: 0.40
Nodes (5): MemoryReviewGrade, again, easy, good, hard

### Community 77 - "DrugDetailSheet"
Cohesion: 0.50
Nodes (4): SaveAction, another, later, open

### Community 78 - "DrugEditorSection"
Cohesion: 0.20
Nodes (10): CodingKeys, answer, choices, explanation, finishReason, message, prompt, questions (+2 more)

### Community 79 - "DrugEvidenceQuality"
Cohesion: 0.22
Nodes (6): HTTPURLResponse, DeepSeekURLProtocolStub, Bool, Data, URLRequest, URLProtocol

### Community 80 - "VerificationStatus"
Cohesion: 0.22
Nodes (8): DrugTopic, brands, counseling, dosing, pharmacology, safety, sources, uses

### Community 82 - "LibraryCompareView"
Cohesion: 0.50
Nodes (4): StorageLocation, appPreferences, keychain, protectedFile

### Community 85 - "DurationBand"
Cohesion: 0.38
Nodes (6): ShelfQuestView, Double, Drug, Int, String, SystemDashboardMetrics

### Community 88 - "SafetySeverity"
Cohesion: 0.25
Nodes (8): SafetyFlag, anticoagulant, children, controlledDrug, corticosteroid, insulin, pregnancy, severeSymptoms

### Community 90 - "Binding"
Cohesion: 0.33
Nodes (5): PracticeInteraction, multipleChoice, recall, textEntry, trueFalse

## Knowledge Gaps
- **392 isolated node(s):** `today`, `library`, `practice`, `you`, `drugTopic` (+387 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **5 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `View` connect `ReportEditorView` to `QuestionType`, `LibraryView`, `PracticeSessionView`, `ShiftView`, `SafetyFlag`, `.image`, `CaseIterable`, `ModelAndPersistenceTests`, `HomeView`, `Identifiable`, `FocusField`, `Foundation`, `.apply`, `PharmacologyScale`, `LibraryView`, `.generate`, `SafetyRadar`, `.record`, `HalfLifeBand`, `Color`, `Unit`, `Bool`, `Decoder`, `String`, `DrugDetailView.swift`, `AIPracticePayload`, `DurationBand`, `LibrarySummaryRow`?**
  _High betweenness centrality (0.174) - this node is a cross-community bridge._
- **Why does `SwiftData` connect `ReviewRating` to `MemoryReviewGrade`, `PharmacologyScale`, `Drug`, `Decoder`, `SafetyRadar`, `QuestionType`, `ShiftView`, `.image`, `HalfLifeBand`, `FocusField`, `Unit`, `FocusField`, `Foundation`, `ReportEditorView`, `Identifiable`?**
  _High betweenness centrality (0.059) - this node is a cross-community bridge._
- **Why does `Chapter` connect `DurationBand` to `PharmacologyScale`, `Drug`, `LibraryView`, `Decoder`, `.generate`, `ShiftView`, `SafetyRadar`, `Codable`, `Color`, `ModelAndPersistenceTests`, `DurationBand`, `HomeView`, `QuestionType`, `Foundation`, `CGPoint`, `.apply`?**
  _High betweenness centrality (0.043) - this node is a cross-community bridge._
- **What connects `today`, `library`, `practice` to the rest of the system?**
  _392 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `ShiftLog` be split into smaller, more focused modules?**
  _Cohesion score 0.11083743842364532 - nodes in this community are weakly interconnected._
- **Should `String` be split into smaller, more focused modules?**
  _Cohesion score 0.1010752688172043 - nodes in this community are weakly interconnected._
- **Should `Chapter` be split into smaller, more focused modules?**
  _Cohesion score 0.14153846153846153 - nodes in this community are weakly interconnected._