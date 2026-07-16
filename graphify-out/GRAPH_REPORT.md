# Graph Report - pharmashift  (2026-07-17)

## Corpus Check
- 54 files · ~462,202 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1603 nodes · 4267 edges · 88 communities (85 shown, 3 thin omitted)
- Extraction: 96% EXTRACTED · 4% INFERRED · 0% AMBIGUOUS · INFERRED: 184 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `8f7f9519`
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

## God Nodes (most connected - your core abstractions)
1. `View` - 147 edges
2. `Drug` - 48 edges
3. `DrugImportView` - 40 edges
4. `Chapter` - 40 edges
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

## Communities (88 total, 3 thin omitted)

### Community 0 - "ShiftLog"
Cohesion: 0.12
Nodes (13): DrugFilter, Bool, Calendar, Date, Drug, Drug, Bool, Data (+5 more)

### Community 1 - "SwiftUI"
Cohesion: 0.16
Nodes (11): Coordinator, NativeCropScrollView, Bool, Int, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollView, UIScrollViewDelegate (+3 more)

### Community 2 - "Drug"
Cohesion: 0.25
Nodes (8): ProdrugStatus, active, prodrug, unknown, ImportedProdrugStatus, active, prodrug, unknown

### Community 3 - "ImageCapture.swift"
Cohesion: 0.26
Nodes (3): DrugLibraryMigrationService, IngredientIdentity, ModelContext

### Community 4 - "String"
Cohesion: 0.09
Nodes (16): DrugRelationshipRefreshService, FastGatherPromptBuilder, ProfileGenerationGroup, adverseEffects, counselingAndLearning, dosageFormsAndDosing, identityAndUses, interactions (+8 more)

### Community 5 - "Chapter"
Cohesion: 0.11
Nodes (28): Double, YouView, HomeView, DailyActivity, DoseCalculationResult, DoseCalculator, DoseFormulaKind, fixed (+20 more)

### Community 6 - "QuestionType"
Cohesion: 0.21
Nodes (8): NSNumber, DeepSeekJSONSanitizer, memorization, PromptBuilder, Any, Bool, Data, UInt8

### Community 7 - "LibraryView"
Cohesion: 0.16
Nodes (9): HTTPURLResponse, DeepSeekDrugImportService, DeepSeekFastDrugGatherService, deepSeekHTTPStatus, openRouterHTTPStatus, OpenRouterKeyStore, OpenRouterPackageVisionService, URLSession (+1 more)

### Community 8 - "PracticeSessionView"
Cohesion: 0.05
Nodes (44): Int, ConfirmDrugIdentityView, DrugImportView, FlowChips, ImportFromPhotoView, ImportMemorizationChallengeView, ImportMode, aiDraft (+36 more)

### Community 9 - "ShiftView"
Cohesion: 0.16
Nodes (16): ActiveShiftCard, ActiveShiftContent, EncounterEditorView, EndShiftView, ShiftPhase, ShiftPhaseRow, ShiftView, Binding (+8 more)

### Community 10 - "Identifiable"
Cohesion: 0.07
Nodes (29): CodingKeys, adverseReactions, boxedWarning, brandName, clinicalPharmacology, contraindications, dosageAndAdministration, dosageForm (+21 more)

### Community 11 - "SafetyFlag"
Cohesion: 0.12
Nodes (9): DrugImportApplier, DrugImportValidator, ImportSelection, Double, Drug, Set, DrugImportServiceTests, Bool (+1 more)

### Community 12 - "DosingFrequency"
Cohesion: 0.13
Nodes (13): DrugImagePayload, DrugPhotoGalleryView, DrugPhotoView, DrugThumbnailView, ImageDraft, ImageEditorView, ImageFlowDestination, camera (+5 more)

### Community 13 - ".image"
Cohesion: 0.16
Nodes (12): NaturalLanguage, Drug, FocusAction, addDrug, finishShift, practiceWeak, reviewDue, FocusModeEngine (+4 more)

### Community 14 - "Build and install PharmaShift using only Windows"
Cohesion: 0.14
Nodes (11): Final Release Gate, PharmaShift Delivery Roadmap, Phase 2 - Visual Pharmacology and Safety, Phase 3 - Backup, Restore, and Export, Phase 4 - Drug Information Import, Phase 5 - Focus, Practice, and Motivation, Renlyst 2.0 — Product and Interface Rebuild, Renlyst (+3 more)

### Community 15 - "CaseIterable"
Cohesion: 0.33
Nodes (7): MigrationStage, PersistentModel, CurrentDrugSchema, DrugMigrationPlan, Phase1DrugSchema, SchemaMigrationPlan, VersionedSchema

### Community 16 - "Codable"
Cohesion: 0.17
Nodes (40): Codable, CoreFoundation, Equatable, Hashable, Identifiable, AdverseEffectEntry, ClinicalDoseEntry, DosageFormGroup (+32 more)

### Community 17 - "ImageCapture.swift"
Cohesion: 0.13
Nodes (17): Error, FileDocument, FileWrapper, BackupDataView, BackupExportKind, complete, csv, lightweight (+9 more)

### Community 18 - "DurationBand"
Cohesion: 0.07
Nodes (29): AppNavigation, AppSheet, addHub, capture, AppShell, AppTab, library, practice (+21 more)

### Community 19 - "HomeView"
Cohesion: 0.05
Nodes (41): CaseIterable, ConfidenceLevel, mastered, medium, strong, weak, ExcretionRoute, hepatic (+33 more)

### Community 21 - "ModelAndPersistenceTests"
Cohesion: 0.09
Nodes (19): CaptureView, FocusField, scientific, trade, unknownLabel, SaveAction, another, later (+11 more)

### Community 22 - "QuestionType"
Cohesion: 0.06
Nodes (33): ImportedDosingFrequency, fourTimesDaily, onceDaily, other, PRN, threeTimesDaily, twiceDaily, unknown (+25 more)

### Community 23 - "HomeView"
Cohesion: 0.15
Nodes (6): LegacyDrugDetailView, Bool, Color, Content, Set, ScrollViewProxy

### Community 24 - "Q: What should PharmaShift do after Phase 1?"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: What should PharmaShift do after Phase 1?, Source Nodes

### Community 25 - "Identifiable"
Cohesion: 0.32
Nodes (3): DrugBrandService, Drug, ModelContext

### Community 26 - "FocusField"
Cohesion: 0.10
Nodes (21): DrugDeletionSheet, LibraryDrugRow, LibraryKnowledgeMapView, LibraryScope, all, due, needsAttention, noPhoto (+13 more)

### Community 27 - "DrugImportView.swift"
Cohesion: 0.07
Nodes (20): CoreTransferable, Foundation, PrivacyValidator, Bool, String, ReportBuilder, Calendar, Drug (+12 more)

### Community 28 - "Foundation"
Cohesion: 0.21
Nodes (14): BackupRecordCounts, DailyActivityBackupDTO, DrugProductBackupDTO, DrugRelationshipBackupDTO, EncounterBackupDTO, LearningProfileBackupDTO, PharmaShiftBackup, ReviewBackupDTO (+6 more)

### Community 29 - "ReportEditorView"
Cohesion: 0.15
Nodes (21): View, ArabicSummarySurface, BrandProductRow, DrugBrandsScreen, DrugCounselingScreen, DrugDetailView, DrugDosingScreen, DrugIdentityHeader (+13 more)

### Community 30 - "Path"
Cohesion: 0.23
Nodes (5): BackupService, Data, ModelContext, BackupServiceTests, ModelContainer

### Community 31 - ".apply"
Cohesion: 0.19
Nodes (7): DeepSeekKeyStore, keychain, StorageLocation, appPreferences, keychain, protectedFile, String

### Community 32 - "Design"
Cohesion: 0.11
Nodes (17): Accessibility floor, Color, Core flows, Design, Dials, Direction, Drug overview, Imagery and icons (+9 more)

### Community 33 - "PharmacologyScale"
Cohesion: 0.13
Nodes (12): DailyRefreshView, LegacyPracticeView, MistakeVaultView, PracticeChoiceRow, PracticeChoiceState, correct, dimmed, idle (+4 more)

### Community 34 - "SwiftData"
Cohesion: 0.41
Nodes (5): CGRect, ImageCompressor, CGFloat, CGSize, UIImage

### Community 35 - "LibraryView"
Cohesion: 0.05
Nodes (55): ButtonStyle, ClosedRange, Configuration, ImageIO, DrugEditorView, Binding, Bool, Double (+47 more)

### Community 36 - "ReviewRating"
Cohesion: 0.24
Nodes (5): PharmaShiftUITests, Int, String, XCUIApplication, XCUIElement

### Community 37 - ".generate"
Cohesion: 0.33
Nodes (4): PracticeSessionView, Drug, String, PracticeQuestion

### Community 38 - "SafetyRadar"
Cohesion: 0.19
Nodes (6): AtomicNotesView, ProductLeafletEditorView, Binding, Data, Drug, PhotosPickerItem

### Community 40 - "MemoryReviewGrade"
Cohesion: 0.20
Nodes (8): InteractionCategory, contraindicated, minor, monitorClosely, seriousUseAlternative, unknown, Decoder, Encoder

### Community 41 - "DosingFrequency"
Cohesion: 0.27
Nodes (6): report, ReportEditorView, Binding, Date, ReferenceWritableKeyPath, String

### Community 42 - "SafetyRadar"
Cohesion: 0.16
Nodes (4): PracticeEngineTests, Drug, Int, ModelContainer

### Community 43 - "DrugRelationshipKind"
Cohesion: 0.54
Nodes (3): PracticeGenerator, Drug, Int

### Community 44 - "SafetyFlag"
Cohesion: 0.21
Nodes (12): ReviewRating, correct, partlyCorrect, wrong, ReviewScheduler, Bool, Calendar, Date (+4 more)

### Community 45 - ".record"
Cohesion: 0.15
Nodes (9): BrandProductForm, Binding, Bool, Data, Int, PhotosPickerItem, BrandProductDraft, Bool (+1 more)

### Community 46 - "ReportFile.swift"
Cohesion: 0.07
Nodes (41): Decodable, AIPracticePayload, AIPracticeQuestion, Choice, CodingKeys, answer, choices, explanation (+33 more)

### Community 47 - "HalfLifeBand"
Cohesion: 0.23
Nodes (9): Destination, PracticeModesView, PracticeSummary, PracticeToolsSection, QuickPracticeSection, RecommendedPracticeCard, Int, String (+1 more)

### Community 48 - "DrugEditorSection"
Cohesion: 0.15
Nodes (13): DrugCardPage, adverse, brands, counseling, doses, forms, interactions, notes (+5 more)

### Community 49 - "PracticeQuestion"
Cohesion: 0.70
Nodes (5): Encodable, DeepSeekRequest, Message, ResponseFormat, Thinking

### Community 50 - "Color"
Cohesion: 0.13
Nodes (14): PracticeView, PracticeMode, casePractice, classExamples, counseling, drugUse, drugWarning, dueReview (+6 more)

### Community 51 - ".generate"
Cohesion: 0.15
Nodes (6): title, DailyMedProvider, DrugSourceProviderFactory, OpenFDALabelProvider, RxNormProvider, URLResponse

### Community 52 - "ImportedExcretionRoute"
Cohesion: 0.07
Nodes (28): LocalizedError, OSStatus, DoseCalculatorError, ageOutsideRegimen, heightRequired, invalidRegimen, sexOutsideRegimen, weightRequired (+20 more)

### Community 53 - "DrugEditorSection"
Cohesion: 0.20
Nodes (10): DrugCardAnchor, arabic, counseling, identity, mastery, notes, pharmacology, review (+2 more)

### Community 54 - ".containsObviousIdentifier"
Cohesion: 0.47
Nodes (3): DrugDeletionImpact, DrugLibraryMutationService, Int

### Community 55 - "NameKind"
Cohesion: 0.33
Nodes (6): AtomicNoteKind, confusingPoint, memoryTrick, patientCounseling, shelfObservation, sourceCorrection

### Community 56 - "FocusField"
Cohesion: 0.13
Nodes (12): NSObject, NameKind, brand, generic, SPLParser, SPLXMLDelegate, DeepSeekURLProtocolStub, Data (+4 more)

### Community 57 - "Unit"
Cohesion: 0.13
Nodes (14): AboutView, AddHubView, AddRouteRow, AppRoute, drug, drugTopic, CommandPaletteView, DrugRouteDestination (+6 more)

### Community 58 - "Components.swift"
Cohesion: 0.22
Nodes (7): BackupImportPreviewView, Int, Void, BackupRestoreMode, merge, replace, BackupRestoreSummary

### Community 59 - "PhotosPickerItem"
Cohesion: 0.26
Nodes (9): RecentStudySection, RecommendedActionCard, CGFloat, Drug, Int, String, Void, TodayHero (+1 more)

### Community 60 - "String"
Cohesion: 0.18
Nodes (6): AltibbiProvider, DrugDataConsistencyNormalizer, URL, Unit, hours, minutes

### Community 61 - "CGPoint"
Cohesion: 0.15
Nodes (9): Observation, RenlystLayout, RenlystMotion, CGFloat, Double, WeaknessRadarView, PreviewData, ModelContainer (+1 more)

### Community 62 - "Bool"
Cohesion: 0.22
Nodes (6): DoseRegimensView, LocalDrugGraphView, CGPoint, CGSize, Double, Int

### Community 63 - ".apply"
Cohesion: 0.22
Nodes (9): CodingKey, CodingKeys, dailyActivities, drugs, encounters, learningProfiles, reports, reviews (+1 more)

### Community 64 - "MemoryReviewGrade"
Cohesion: 0.39
Nodes (4): DrugBackupDTO, Bool, Double, Drug

### Community 65 - "Bool"
Cohesion: 0.29
Nodes (6): App, LinearGradient, AppTheme, Color, PharmaShiftApp, Scene

### Community 66 - "DoseRegimensView"
Cohesion: 0.29
Nodes (7): EliminationPathway, biliaryFecal, mixed, other, pulmonary, renalUrine, unknown

### Community 67 - "Decoder"
Cohesion: 0.22
Nodes (9): DrugTopic, brands, counseling, dosing, pharmacology, safety, sources, uses (+1 more)

### Community 68 - "ReportFile.swift"
Cohesion: 0.36
Nodes (5): AIPracticePackView, Drug, AIPracticePack, AIPracticePackStore, Date

### Community 69 - "String"
Cohesion: 0.29
Nodes (5): Context, CameraPicker, Any, UIImagePickerController, UIViewControllerRepresentable

### Community 70 - "MemoryReviewGrade"
Cohesion: 0.40
Nodes (5): BackupError, duplicateIdentifiers, invalidCounts, malformed, newerVersion

### Community 72 - "ExcretionRoute"
Cohesion: 0.13
Nodes (14): GeneratedReviewQuestion, PracticeInteraction, multipleChoice, recall, textEntry, trueFalse, QuestionType, casePractice (+6 more)

### Community 73 - ".matches"
Cohesion: 0.18
Nodes (10): Accessibility & Inclusion, Anti-references, Brand Personality, Design Principles, Platform, Positioning, Product, Product Purpose (+2 more)

### Community 74 - "AIPracticePayload"
Cohesion: 0.20
Nodes (8): PharmaShift, MigrationFixtureTests, ReportBuilderTests, PhotosUI, SwiftData, UIKit, XCTest, XCTestCase

### Community 75 - "SafetyFlag"
Cohesion: 0.25
Nodes (8): MemoryAnchor, MemoryAnchorKind, counseling, empty, mechanism, mustKnow, safety, use

### Community 76 - "DrugSearchResult"
Cohesion: 0.39
Nodes (4): DrugSearchRanker, DrugSearchResult, MockDrugSourceProvider, Int

### Community 77 - "DrugDetailSheet"
Cohesion: 0.29
Nodes (5): DrugDetailSheet, atomicNotes, editor, regenerateReview, review

### Community 78 - "DrugEditorSection"
Cohesion: 0.29
Nodes (7): DrugEditorSection, basics, counseling, notes, pk, safety, uses

### Community 79 - "DrugEvidenceQuality"
Cohesion: 0.33
Nodes (6): DrugEvidenceQuality, aiUnverified, altibbi, manual, officialLabel, productLeaflet

### Community 80 - "VerificationStatus"
Cohesion: 0.14
Nodes (24): ReportView, Drug, AtomicDrugNote, Drug, DrugFieldEvidence, DrugProduct, DrugRelationship, EncounterNote (+16 more)

### Community 82 - "LibraryCompareView"
Cohesion: 0.50
Nodes (3): LibraryCompareView, Binding, UUID

### Community 83 - "String"
Cohesion: 0.25
Nodes (6): CropGrid, CropViewportState, CGPoint, Path, Shape, UIEdgeInsets

### Community 84 - "DrugRelationshipKind"
Cohesion: 0.40
Nodes (5): DrugRelationshipKind, contraindicatedCombination, interaction, relatedUse, sameClass

### Community 85 - "DurationBand"
Cohesion: 0.40
Nodes (5): DurationBand, long, medium, short, unknown

### Community 86 - "MemoryReviewGrade"
Cohesion: 0.40
Nodes (5): MemoryReviewGrade, again, easy, good, hard

### Community 87 - "DrugDetailView.swift"
Cohesion: 0.67
Nodes (3): DrugBrandsSheet, addProduct, DrugBrandsView

## Knowledge Gaps
- **393 isolated node(s):** `today`, `library`, `practice`, `you`, `drug` (+388 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **3 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `View` connect `ReportEditorView` to `Chapter`, `PracticeSessionView`, `ShiftView`, `DosingFrequency`, `ImageCapture.swift`, `DurationBand`, `ModelAndPersistenceTests`, `HomeView`, `FocusField`, `PharmacologyScale`, `LibraryView`, `.generate`, `SafetyRadar`, `DosingFrequency`, `.record`, `HalfLifeBand`, `Color`, `Unit`, `Components.swift`, `PhotosPickerItem`, `CGPoint`, `Bool`, `Decoder`, `ReportFile.swift`, `DrugDetailView.swift`, `DrugDetailSheet`, `VerificationStatus`, `LibraryCompareView`, `DrugDetailView.swift`?**
  _High betweenness centrality (0.168) - this node is a cross-community bridge._
- **Why does `SwiftData` connect `AIPracticePayload` to `Chapter`, `PracticeSessionView`, `ShiftView`, `.image`, `Codable`, `ImageCapture.swift`, `DurationBand`, `FocusField`, `DrugImportView.swift`, `Foundation`, `ReportEditorView`, `PharmacologyScale`, `HalfLifeBand`, `.containsObviousIdentifier`, `Unit`, `PhotosPickerItem`, `CGPoint`, `Bool`, `DrugDetailView.swift`?**
  _High betweenness centrality (0.066) - this node is a cross-community bridge._
- **Why does `Chapter` connect `DurationBand` to `Bool`, `PharmacologyScale`, `LibraryView`, `.generate`, `Chapter`, `ShiftView`, `SafetyRadar`, `SafetyFlag`, `Codable`, `VerificationStatus`, `Color`, `HomeView`, `ModelAndPersistenceTests`, `DrugImportView.swift`, `Path`?**
  _High betweenness centrality (0.049) - this node is a cross-community bridge._
- **What connects `today`, `library`, `practice` to the rest of the system?**
  _393 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `ShiftLog` be split into smaller, more focused modules?**
  _Cohesion score 0.1164021164021164 - nodes in this community are weakly interconnected._
- **Should `String` be split into smaller, more focused modules?**
  _Cohesion score 0.08831908831908832 - nodes in this community are weakly interconnected._
- **Should `Chapter` be split into smaller, more focused modules?**
  _Cohesion score 0.10953058321479374 - nodes in this community are weakly interconnected._