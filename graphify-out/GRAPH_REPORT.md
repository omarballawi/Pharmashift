# Graph Report - pharmashift  (2026-07-17)

## Corpus Check
- 54 files · ~462,479 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1609 nodes · 4288 edges · 84 communities (77 shown, 7 thin omitted)
- Extraction: 96% EXTRACTED · 4% INFERRED · 0% AMBIGUOUS · INFERRED: 185 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `30f2cdb0`
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
- [[_COMMUNITY_DrugDetailSheet|DrugDetailSheet]]
- [[_COMMUNITY_VerificationStatus|VerificationStatus]]
- [[_COMMUNITY_.isValid|.isValid]]
- [[_COMMUNITY_LocalDrugGraphView|LocalDrugGraphView]]
- [[_COMMUNITY_BackupError|BackupError]]
- [[_COMMUNITY_Binding|Binding]]
- [[_COMMUNITY_LibrarySummaryRow|LibrarySummaryRow]]
- [[_COMMUNITY_Data|Data]]

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

## Communities (84 total, 7 thin omitted)

### Community 0 - "ShiftLog"
Cohesion: 0.11
Nodes (13): DrugFilter, Bool, Calendar, Date, Drug, Drug, Bool, Data (+5 more)

### Community 1 - "SwiftUI"
Cohesion: 0.15
Nodes (14): Coordinator, CropViewportState, NativeCropScrollView, Bool, CGPoint, CGSize, UIEdgeInsets, UIImagePickerControllerDelegate (+6 more)

### Community 2 - "Drug"
Cohesion: 0.12
Nodes (14): DrugImportView, Bool, Drug, PhotosPickerItem, DeepSeekIdentityResolver, DrugIdentityResolving, DeepSeekDrugImportService, DeepSeekFastDrugGatherService (+6 more)

### Community 3 - "ImageCapture.swift"
Cohesion: 0.22
Nodes (5): DrugLibraryMigrationService, DrugProduct, IngredientComponent, IngredientIdentity, ModelContext

### Community 4 - "String"
Cohesion: 0.14
Nodes (15): deepSeekHTTPStatus, FastGatherPromptBuilder, ProfileGenerationGroup, adverseEffects, counselingAndLearning, dosageFormsAndDosing, identityAndUses, interactions (+7 more)

### Community 5 - "Chapter"
Cohesion: 0.17
Nodes (16): HomeView, DoseRegimensView, Double, DailyActivity, DoseCalculationResult, DoseCalculator, DosePatientInput, DoseRegimen (+8 more)

### Community 6 - "QuestionType"
Cohesion: 0.20
Nodes (8): DrugDeletionSheet, Void, DrugDeletionHistoryPolicy, eraseHistory, keepHistory, DrugDeletionImpact, DrugLibraryMutationService, Int

### Community 7 - "LibraryView"
Cohesion: 0.10
Nodes (16): OSStatus, LearningSettingsView, Binding, Bool, DeepSeekKeyStore, openRouterHTTPStatus, KeyStoreError, keychain (+8 more)

### Community 8 - "PracticeSessionView"
Cohesion: 0.10
Nodes (22): Int, ConfirmDrugIdentityView, FlowChips, ImportFromPhotoView, ImportMemorizationChallengeView, ImportMode, aiDraft, trusted (+14 more)

### Community 9 - "ShiftView"
Cohesion: 0.11
Nodes (23): ReportView, Drug, EndShiftView, Binding, ReferenceWritableKeyPath, DrugRelationship, EncounterNote, PracticeAnswer (+15 more)

### Community 10 - "Identifiable"
Cohesion: 0.07
Nodes (30): CodingKeys, adverseReactions, boxedWarning, brandName, clinicalPharmacology, contraindications, dosageAndAdministration, dosageForm (+22 more)

### Community 11 - "SafetyFlag"
Cohesion: 0.08
Nodes (26): CaseIterable, AtomicNoteKind, confusingPoint, memoryTrick, patientCounseling, shelfObservation, sourceCorrection, ConfidenceLevel (+18 more)

### Community 12 - "DosingFrequency"
Cohesion: 0.11
Nodes (12): DrugDataConsistencyNormalizer, DrugImportApplier, DrugImportValidator, ImportSelection, Double, Drug, Set, Unit (+4 more)

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
Cohesion: 0.21
Nodes (8): NSObject, NameKind, brand, generic, SPLParser, SPLXMLDelegate, XMLParser, XMLParserDelegate

### Community 17 - "ImageCapture.swift"
Cohesion: 0.40
Nodes (5): PracticeChoiceState, correct, dimmed, idle, incorrect

### Community 18 - "DurationBand"
Cohesion: 0.06
Nodes (42): AboutView, AddHubView, AddRouteRow, AppNavigation, AppRoute, drug, drugTopic, AppSheet (+34 more)

### Community 19 - "HomeView"
Cohesion: 0.07
Nodes (23): HTTPURLResponse, MigrationStage, PersistentModel, PharmaShift, DeepSeekURLProtocolStub, Bool, Data, URLRequest (+15 more)

### Community 21 - "ModelAndPersistenceTests"
Cohesion: 0.09
Nodes (16): CaptureView, Binding, Bool, Data, Int, PhotosPickerItem, String, UUID (+8 more)

### Community 22 - "QuestionType"
Cohesion: 0.17
Nodes (8): NSNumber, DeepSeekJSONSanitizer, MockOpenRouterPackageVisionService, PromptBuilder, Any, Bool, Data, UInt8

### Community 23 - "HomeView"
Cohesion: 0.15
Nodes (6): LegacyDrugDetailView, Bool, Color, Content, Set, ScrollViewProxy

### Community 24 - "Q: What should PharmaShift do after Phase 1?"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: What should PharmaShift do after Phase 1?, Source Nodes

### Community 25 - "Identifiable"
Cohesion: 0.45
Nodes (3): DrugBrandService, Drug, ModelContext

### Community 26 - "FocusField"
Cohesion: 0.10
Nodes (20): LibraryCompareView, LibraryDrugRow, LibraryKnowledgeMapView, LibraryScope, all, due, needsAttention, noPhoto (+12 more)

### Community 27 - "DrugImportView.swift"
Cohesion: 0.41
Nodes (3): CGRect, ImageCompressor, UIImage

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
Cohesion: 0.07
Nodes (25): CoreTransferable, Foundation, Observation, PrivacyValidator, Bool, String, ReportFile, String (+17 more)

### Community 32 - "Design"
Cohesion: 0.11
Nodes (17): Accessibility floor, Color, Core flows, Design, Dials, Direction, Drug overview, Imagery and icons (+9 more)

### Community 33 - "PharmacologyScale"
Cohesion: 0.40
Nodes (5): DrugRelationshipKind, contraindicatedCombination, interaction, relatedUse, sameClass

### Community 34 - "SwiftData"
Cohesion: 0.29
Nodes (5): Context, CameraPicker, Any, UIImagePickerController, UIViewControllerRepresentable

### Community 35 - "LibraryView"
Cohesion: 0.27
Nodes (6): report, ReportEditorView, Binding, Date, ReferenceWritableKeyPath, String

### Community 36 - "ReviewRating"
Cohesion: 0.20
Nodes (9): App, LinearGradient, AppTheme, RenlystLayout, RenlystMotion, CGFloat, Color, PharmaShiftApp (+1 more)

### Community 37 - ".generate"
Cohesion: 0.14
Nodes (16): DailyRefreshView, LegacyPracticeView, MistakeVaultView, PracticeChoiceRow, PracticeQuestionHeader, PracticeSessionView, Color, Drug (+8 more)

### Community 38 - "SafetyRadar"
Cohesion: 0.24
Nodes (5): ProductLeafletEditorView, Binding, Data, Drug, PhotosPickerItem

### Community 40 - "MemoryReviewGrade"
Cohesion: 0.26
Nodes (9): RecentStudySection, RecommendedActionCard, CGFloat, Drug, Int, String, Void, TodayHero (+1 more)

### Community 41 - "DosingFrequency"
Cohesion: 0.22
Nodes (7): BackupImportPreviewView, Int, Void, BackupRestoreMode, merge, replace, BackupRestoreSummary

### Community 43 - "DrugRelationshipKind"
Cohesion: 0.35
Nodes (3): PracticeGenerator, Drug, Int

### Community 44 - "SafetyFlag"
Cohesion: 0.22
Nodes (8): DrugTopic, brands, counseling, dosing, pharmacology, safety, sources, uses

### Community 45 - ".record"
Cohesion: 0.20
Nodes (10): ImportSection, adverseEffects, arabicExplanation, counseling, identity, memorization, pharmacokinetics, safety (+2 more)

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
Cohesion: 0.18
Nodes (24): CoreFoundation, Decodable, Encodable, APIError, Candidate, Choice, DailyMedSearchItem, DailyMedSearchPayload (+16 more)

### Community 50 - "Color"
Cohesion: 0.12
Nodes (14): PracticeView, PracticeMode, casePractice, classExamples, counseling, drugUse, drugWarning, dueReview (+6 more)

### Community 51 - ".generate"
Cohesion: 0.50
Nodes (4): FocusField, scientific, trade, unknownLabel

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
Cohesion: 0.05
Nodes (50): ButtonStyle, ClosedRange, Configuration, ImageIO, DrugEditorView, Binding, Bool, Double (+42 more)

### Community 56 - "FocusField"
Cohesion: 0.08
Nodes (16): AltibbiProvider, DailyMedProvider, DrugRelationshipRefreshService, DrugSearchRanker, DrugSearchResult, DrugSourceProvider, MockDrugSourceProvider, OpenFDALabelProvider (+8 more)

### Community 57 - "Unit"
Cohesion: 0.29
Nodes (6): DrugBrandsSheet, addProduct, DrugBrandsView, LocalDrugGraphView, CGPoint, CGSize

### Community 59 - "PhotosPickerItem"
Cohesion: 0.29
Nodes (5): DrugDetailSheet, atomicNotes, editor, regenerateReview, review

### Community 60 - "String"
Cohesion: 0.06
Nodes (61): Equatable, ResolvedDrugIdentity, Flashcard, GeneratedReviewQuestionDTO, ImportedAdverseEffects, ImportedArabicExplanation, ImportedCounseling, ImportedDosingFrequency (+53 more)

### Community 61 - "CGPoint"
Cohesion: 0.22
Nodes (8): Double, WeaknessRadarView, PreviewData, ModelContainer, PhotosUI, SwiftData, SwiftUI, UIKit

### Community 62 - "Bool"
Cohesion: 0.18
Nodes (9): BrandProductForm, Binding, Bool, Data, Int, PhotosPickerItem, BrandProductDraft, Bool (+1 more)

### Community 63 - ".apply"
Cohesion: 0.50
Nodes (4): SaveAction, another, later, open

### Community 64 - "MemoryReviewGrade"
Cohesion: 0.33
Nodes (6): DrugEvidenceQuality, aiUnverified, altibbi, manual, officialLabel, productLeaflet

### Community 65 - "Bool"
Cohesion: 0.40
Nodes (5): SafetySeverity, high, low, medium, unknown

### Community 66 - "DoseRegimensView"
Cohesion: 0.33
Nodes (6): HalfLifeBand, long, medium, short, unknown, veryLong

### Community 67 - "Decoder"
Cohesion: 0.19
Nodes (13): ActiveShiftCard, ActiveShiftContent, EncounterEditorView, ShiftPhase, ShiftPhaseRow, ShiftView, Bool, Date (+5 more)

### Community 68 - "ReportFile.swift"
Cohesion: 0.13
Nodes (39): Codable, Hashable, Identifiable, AdverseEffectEntry, AtomicDrugNote, ClinicalDoseEntry, DosageFormGroup, Drug (+31 more)

### Community 69 - "String"
Cohesion: 0.39
Nodes (4): DrugBackupDTO, Bool, Double, Drug

### Community 71 - "DrugDetailView.swift"
Cohesion: 0.18
Nodes (11): DrugImagePayload, DrugPhotoGalleryView, DrugPhotoView, DrugThumbnailView, ImageDraft, ImageEditorView, CGFloat, Data (+3 more)

### Community 72 - "ExcretionRoute"
Cohesion: 0.20
Nodes (8): QuestionType, casePractice, counseling, drugClass, scientificName, tradeName, use, warning

### Community 73 - ".matches"
Cohesion: 0.18
Nodes (10): Accessibility & Inclusion, Anti-references, Brand Personality, Design Principles, Platform, Positioning, Product, Product Purpose (+2 more)

### Community 74 - "AIPracticePayload"
Cohesion: 0.50
Nodes (3): CropGrid, Path, Shape

### Community 75 - "SafetyFlag"
Cohesion: 0.29
Nodes (7): MemoryAnchorKind, counseling, empty, mechanism, mustKnow, safety, use

### Community 77 - "DrugDetailSheet"
Cohesion: 0.09
Nodes (21): Double, YouView, InteractionCategory, contraindicated, minor, monitorClosely, seriousUseAlternative, unknown (+13 more)

### Community 80 - "VerificationStatus"
Cohesion: 0.29
Nodes (7): DrugEditorSection, basics, counseling, notes, pk, safety, uses

### Community 83 - "LocalDrugGraphView"
Cohesion: 0.29
Nodes (7): EliminationPathway, biliaryFecal, mixed, other, pulmonary, renalUrine, unknown

### Community 87 - "BackupError"
Cohesion: 0.40
Nodes (5): BackupError, duplicateIdentifiers, invalidCounts, malformed, newerVersion

### Community 90 - "Binding"
Cohesion: 0.14
Nodes (13): SafetyFlag, anticoagulant, children, controlledDrug, corticosteroid, insulin, pregnancy, severeSymptoms (+5 more)

## Knowledge Gaps
- **392 isolated node(s):** `today`, `library`, `practice`, `you`, `drugTopic` (+387 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **7 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `View` connect `ReportEditorView` to `Drug`, `Chapter`, `QuestionType`, `LibraryView`, `PracticeSessionView`, `ShiftView`, `CaseIterable`, `DurationBand`, `ModelAndPersistenceTests`, `HomeView`, `FocusField`, `LibraryView`, `.generate`, `SafetyRadar`, `MemoryReviewGrade`, `DosingFrequency`, `ReportFile.swift`, `HalfLifeBand`, `Color`, `NameKind`, `Unit`, `Components.swift`, `PhotosPickerItem`, `CGPoint`, `Bool`, `Decoder`, `DrugDetailView.swift`, `DrugDetailSheet`, `LibrarySummaryRow`, `Data`?**
  _High betweenness centrality (0.187) - this node is a cross-community bridge._
- **Why does `SwiftData` connect `CGPoint` to `Decoder`, `ReportFile.swift`, `.generate`, `QuestionType`, `MemoryReviewGrade`, `PracticeSessionView`, `.image`, `CaseIterable`, `HalfLifeBand`, `PracticeQuestion`, `DurationBand`, `HomeView`, `Unit`, `FocusField`, `Foundation`, `ReportEditorView`, `.apply`?**
  _High betweenness centrality (0.063) - this node is a cross-community bridge._
- **Why does `DrugImportView` connect `Drug` to `ImageCapture.swift`, `String`, `DrugDetailView.swift`, `PracticeSessionView`, `DosingFrequency`, `ModelAndPersistenceTests`, `FocusField`, `DrugImportView.swift`, `String`, `ReportEditorView`?**
  _High betweenness centrality (0.046) - this node is a cross-community bridge._
- **What connects `today`, `library`, `practice` to the rest of the system?**
  _392 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `ShiftLog` be split into smaller, more focused modules?**
  _Cohesion score 0.11083743842364532 - nodes in this community are weakly interconnected._
- **Should `SwiftUI` be split into smaller, more focused modules?**
  _Cohesion score 0.1476923076923077 - nodes in this community are weakly interconnected._
- **Should `Drug` be split into smaller, more focused modules?**
  _Cohesion score 0.1164021164021164 - nodes in this community are weakly interconnected._