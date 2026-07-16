# Graph Report - pharmashift  (2026-07-16)

## Corpus Check
- 54 files · ~460,155 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1569 nodes · 4052 edges · 100 communities (81 shown, 19 thin omitted)
- Extraction: 96% EXTRACTED · 4% INFERRED · 0% AMBIGUOUS · INFERRED: 156 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `afd4fdb2`
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
- [[_COMMUNITY_AppTheme.swift|AppTheme.swift]]
- [[_COMMUNITY_AtomicNotesView|AtomicNotesView]]
- [[_COMMUNITY_DrugEditorSection|DrugEditorSection]]
- [[_COMMUNITY_ConfidenceLevel|ConfidenceLevel]]
- [[_COMMUNITY_VerificationStatus|VerificationStatus]]
- [[_COMMUNITY_DrugRelationshipKind|DrugRelationshipKind]]
- [[_COMMUNITY_FocusField|FocusField]]
- [[_COMMUNITY_String|String]]
- [[_COMMUNITY_RenlystSurface|RenlystSurface]]
- [[_COMMUNITY_URL|URL]]
- [[_COMMUNITY_String|String]]
- [[_COMMUNITY_String|String]]
- [[_COMMUNITY_RenlystPrimaryButtonStyle|RenlystPrimaryButtonStyle]]
- [[_COMMUNITY_Set|Set]]
- [[_COMMUNITY_String|String]]
- [[_COMMUNITY_String|String]]
- [[_COMMUNITY_String|String]]
- [[_COMMUNITY_String|String]]
- [[_COMMUNITY_String|String]]
- [[_COMMUNITY_Encoder|Encoder]]
- [[_COMMUNITY_String|String]]
- [[_COMMUNITY_String|String]]
- [[_COMMUNITY_String|String]]
- [[_COMMUNITY_String|String]]

## God Nodes (most connected - your core abstractions)
1. `String` - 220 edges
2. `Drug` - 47 edges
3. `DrugImportView` - 40 edges
4. `Chapter` - 40 edges
5. `DrugEditorView` - 39 edges
6. `ImportedDrugInfo` - 35 edges
7. `DeepSeekKeyStore` - 33 edges
8. `CodingKeys` - 32 edges
9. `DrugProduct` - 29 edges
10. `DrugImportServiceTests` - 29 edges

## Surprising Connections (you probably didn't know these)
- `DrugImportView` --calls--> `DeepSeekIdentityResolver`  [INFERRED]
  PharmaShift/Features/Library/DrugImportView.swift → PharmaShift/Services/DeepSeekLearningService.swift
- `PreviewData` --calls--> `ShiftLog`  [INFERRED]
  PharmaShift/Shared/PreviewSupport.swift → PharmaShift/Models/Models.swift
- `AppTab` --references--> `String`  [EXTRACTED]
  PharmaShift/App/AppShell.swift → PharmaShift/Models/Models.swift
- `AppSheet` --references--> `Chapter`  [EXTRACTED]
  PharmaShift/App/AppShell.swift → PharmaShift/Models/Models.swift
- `AppSheet` --references--> `String`  [EXTRACTED]
  PharmaShift/App/AppShell.swift → PharmaShift/Models/Models.swift

## Import Cycles
- None detected.

## Communities (100 total, 19 thin omitted)

### Community 0 - "ShiftLog"
Cohesion: 0.17
Nodes (5): deepSeekHTTPStatus, DrugImportValidator, UserConfirmedDrugIdentity, DrugImportServiceTests, String

### Community 1 - "SwiftUI"
Cohesion: 0.13
Nodes (13): Any, Context, CameraPicker, Coordinator, Bool, UIImagePickerController, UIImagePickerControllerDelegate, UINavigationControllerDelegate (+5 more)

### Community 2 - "Drug"
Cohesion: 0.21
Nodes (22): Hashable, Identifiable, AdverseEffectEntry, AtomicDrugNote, ClinicalDoseEntry, DosageFormGroup, Drug, DrugFieldEvidence (+14 more)

### Community 3 - "ImageCapture.swift"
Cohesion: 0.07
Nodes (21): BrandProductForm, Binding, Bool, Data, Int, PhotosPickerItem, DrugLibraryMigrationService, DrugProduct (+13 more)

### Community 4 - "String"
Cohesion: 0.13
Nodes (12): FastGatherPromptBuilder, ProfileGenerationGroup, adverseEffects, counselingAndLearning, dosageFormsAndDosing, identityAndUses, interactions, pharmacology (+4 more)

### Community 5 - "Chapter"
Cohesion: 0.18
Nodes (17): DoseCalculationResult, DoseCalculator, DosePatientInput, DosePopulation, adult, geriatric, pediatric, special (+9 more)

### Community 6 - "QuestionType"
Cohesion: 0.09
Nodes (21): DrugDataConsistencyNormalizer, DrugImportApplier, DrugRelationshipRefreshService, ImportSection, adverseEffects, arabicExplanation, counseling, identity (+13 more)

### Community 7 - "LibraryView"
Cohesion: 0.16
Nodes (6): DeepSeekFastDrugGatherService, openRouterHTTPStatus, OpenRouterKeyStore, OpenRouterPackageVisionService, URLSession, UserDefaults

### Community 8 - "PracticeSessionView"
Cohesion: 0.08
Nodes (30): DrugPackageRecognizing, DrugSearchResult, FastDrugGatheringService, ImportedDrugInfo, Int, PackageRecognitionResult, ConfirmDrugIdentityView, DrugImportView (+22 more)

### Community 9 - "ShiftView"
Cohesion: 0.15
Nodes (15): ActiveShiftCard, ActiveShiftContent, EncounterEditorView, EndShiftView, ShiftPhase, ShiftPhaseRow, ShiftView, Binding (+7 more)

### Community 10 - "Identifiable"
Cohesion: 0.07
Nodes (29): CodingKeys, adverseReactions, boxedWarning, brandName, clinicalPharmacology, contraindications, dosageAndAdministration, dosageForm (+21 more)

### Community 11 - "SafetyFlag"
Cohesion: 0.14
Nodes (14): Double, YouView, PracticeInteraction, multipleChoice, recall, textEntry, trueFalse, String (+6 more)

### Community 12 - "DosingFrequency"
Cohesion: 0.18
Nodes (11): ImageIO, DrugImagePayload, DrugPhotoGalleryView, DrugPhotoView, DrugThumbnailView, ImageDraft, ImageEditorView, CGFloat (+3 more)

### Community 13 - ".image"
Cohesion: 0.09
Nodes (22): HomeView, RecentStudySection, RecommendedActionCard, CGFloat, Drug, Int, Void, TodayHero (+14 more)

### Community 14 - "Build and install PharmaShift using only Windows"
Cohesion: 0.20
Nodes (8): Final Release Gate, PharmaShift Delivery Roadmap, Phase 2 - Visual Pharmacology and Safety, Phase 3 - Backup, Restore, and Export, Phase 4 - Drug Information Import, Phase 5 - Focus, Practice, and Motivation, Renlyst 2.0 — Product and Interface Rebuild, Renlyst

### Community 15 - "CaseIterable"
Cohesion: 0.24
Nodes (10): MigrationStage, PersistentModel, CurrentDrugSchema, DrugMigrationPlan, MigrationFixtureTests, Phase1DrugSchema, ReportBuilderTests, SchemaMigrationPlan (+2 more)

### Community 16 - "Codable"
Cohesion: 0.16
Nodes (9): OSStatus, DeepSeekKeyStore, KeyStoreError, keychain, readBackFailed, StorageLocation, appPreferences, keychain (+1 more)

### Community 17 - "ImageCapture.swift"
Cohesion: 0.13
Nodes (17): Error, FileDocument, FileWrapper, BackupDataView, BackupExportKind, complete, csv, lightweight (+9 more)

### Community 18 - "DurationBand"
Cohesion: 0.12
Nodes (16): AboutView, AddHubView, AddRouteRow, AppNavigation, AppSheet, addHub, capture, AppShell (+8 more)

### Community 19 - "HomeView"
Cohesion: 0.07
Nodes (28): CaseIterable, DoseFormulaKind, fixed, mgPerKgPerDay, mgPerKgPerDose, mgPerSquareMeter, DosingFrequency, asNeeded (+20 more)

### Community 21 - "ModelAndPersistenceTests"
Cohesion: 0.09
Nodes (14): CaptureView, Binding, Bool, Data, Drug, Int, PhotosPickerItem, ImageAcquisitionSource (+6 more)

### Community 22 - "QuestionType"
Cohesion: 0.05
Nodes (80): Codable, Equatable, EliminationInfo, EliminationPathway, biliaryFecal, mixed, other, pulmonary (+72 more)

### Community 23 - "HomeView"
Cohesion: 0.14
Nodes (6): LegacyDrugDetailView, Bool, Color, Content, ScrollViewProxy, Set

### Community 24 - "Q: What should PharmaShift do after Phase 1?"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: What should PharmaShift do after Phase 1?, Source Nodes

### Community 25 - "Identifiable"
Cohesion: 0.16
Nodes (9): NSNumber, DeepSeekJSONSanitizer, PromptBuilder, Any, Bool, Data, Double, Int (+1 more)

### Community 26 - "FocusField"
Cohesion: 0.09
Nodes (22): DrugDeletionSheet, LibraryCompareView, LibraryDrugRow, LibraryKnowledgeMapView, LibraryScope, all, due, needsAttention (+14 more)

### Community 27 - "DrugImportView.swift"
Cohesion: 0.07
Nodes (33): ButtonStyle, ClosedRange, Configuration, DrugEditorView, Binding, Bool, Double, Drug (+25 more)

### Community 28 - "Foundation"
Cohesion: 0.21
Nodes (14): BackupRecordCounts, DailyActivityBackupDTO, DrugProductBackupDTO, DrugRelationshipBackupDTO, EncounterBackupDTO, LearningProfileBackupDTO, PharmaShiftBackup, ReviewBackupDTO (+6 more)

### Community 29 - "ReportEditorView"
Cohesion: 0.10
Nodes (24): ArabicSummarySurface, BrandProductRow, DrugBrandsScreen, DrugCounselingScreen, DrugDetailView, DrugDosingScreen, DrugIdentityHeader, DrugOverviewSheet (+16 more)

### Community 30 - "Path"
Cohesion: 0.22
Nodes (5): BackupService, Data, ModelContext, BackupServiceTests, ModelContainer

### Community 31 - ".apply"
Cohesion: 0.28
Nodes (6): ShelfQuestView, Double, Drug, Int, SystemDashboardMetrics, SwiftUI

### Community 32 - "Design"
Cohesion: 0.11
Nodes (17): Accessibility floor, Color, Core flows, Design, Dials, Direction, Drug overview, Imagery and icons (+9 more)

### Community 33 - "PharmacologyScale"
Cohesion: 0.22
Nodes (4): DailyRefreshView, LegacyPracticeView, Color, Int

### Community 34 - "SwiftData"
Cohesion: 0.35
Nodes (5): CGRect, ImageCompressor, CGSize, Int, UIImage

### Community 35 - "LibraryView"
Cohesion: 0.10
Nodes (21): Destination, FlowChips, DrugPharmacologyScreen, DrugSafetyScreen, LibrarySummaryRow, Int, PracticeToolsSection, EmptyStateView (+13 more)

### Community 36 - "ReviewRating"
Cohesion: 0.26
Nodes (4): PharmaShiftUITests, Int, XCUIApplication, XCUIElement

### Community 37 - ".generate"
Cohesion: 0.22
Nodes (8): PracticeSessionView, Drug, MemoryReviewGrade, again, easy, good, hard, PracticeQuestion

### Community 38 - "SafetyRadar"
Cohesion: 0.28
Nodes (5): ProductLeafletEditorView, Binding, Data, Drug, PhotosPickerItem

### Community 40 - "MemoryReviewGrade"
Cohesion: 0.20
Nodes (8): Encoder, InteractionCategory, contraindicated, minor, monitorClosely, seriousUseAlternative, unknown, Decoder

### Community 41 - "DosingFrequency"
Cohesion: 0.24
Nodes (7): report, ReportEditorView, Binding, Date, Double, ReferenceWritableKeyPath, WeaknessRadarView

### Community 42 - "SafetyRadar"
Cohesion: 0.14
Nodes (10): NSObject, NameKind, brand, generic, SPLParser, SPLXMLDelegate, TrustedDrugSourcePacketExtractor, Data (+2 more)

### Community 43 - "DrugRelationshipKind"
Cohesion: 0.38
Nodes (4): PracticeGenerator, Drug, Int, PracticeCase

### Community 44 - "SafetyFlag"
Cohesion: 0.16
Nodes (15): ReviewScheduler, Bool, Calendar, Date, Drug, Int, String, Drug (+7 more)

### Community 45 - ".record"
Cohesion: 0.17
Nodes (8): Flashcard, ImportSection, ImportSelection, ImportPreviewView, Binding, Color, Content, Severity

### Community 46 - "ReportFile.swift"
Cohesion: 0.14
Nodes (13): AIPracticePayload, AIPracticeQuestion, Choice, DeepSeekContentResponse, DeepSeekIdentityResolver, DeepSeekJSONClient, DeepSeekPracticeService, Message (+5 more)

### Community 47 - "HalfLifeBand"
Cohesion: 0.21
Nodes (9): AIPracticePackView, PracticeModesView, PracticeSummary, QuickPracticeSection, RecommendedPracticeCard, Drug, Int, Void (+1 more)

### Community 48 - "DrugEditorSection"
Cohesion: 0.13
Nodes (13): DrugCardPage, adverse, brands, counseling, doses, forms, interactions, notes (+5 more)

### Community 49 - "PracticeQuestion"
Cohesion: 0.12
Nodes (30): CoreFoundation, Decodable, Encodable, APIError, Candidate, Choice, DailyMedSearchItem, DailyMedSearchPayload (+22 more)

### Community 50 - "Color"
Cohesion: 0.13
Nodes (14): PracticeView, PracticeMode, casePractice, classExamples, counseling, drugUse, drugWarning, dueReview (+6 more)

### Community 51 - ".generate"
Cohesion: 0.14
Nodes (13): AltibbiProvider, title, DailyMedProvider, DrugSearchRanker, DrugSearchResult, DrugSourceProvider, MockDrugSourceProvider, OpenFDAFields (+5 more)

### Community 52 - "ImportedExcretionRoute"
Cohesion: 0.08
Nodes (25): LocalizedError, DoseCalculatorError, ageOutsideRegimen, heightRequired, invalidRegimen, sexOutsideRegimen, weightRequired, DrugImportError (+17 more)

### Community 53 - "DrugEditorSection"
Cohesion: 0.20
Nodes (10): DrugCardAnchor, arabic, counseling, identity, mastery, notes, pharmacology, review (+2 more)

### Community 54 - ".containsObviousIdentifier"
Cohesion: 0.13
Nodes (13): Chapter, antibiotics, cardiovascular, dermatology, earNoseOropharynx, endocrine, eye, gastrointestinal (+5 more)

### Community 55 - "NameKind"
Cohesion: 0.33
Nodes (6): AtomicNoteKind, confusingPoint, memoryTrick, patientCounseling, shelfObservation, sourceCorrection

### Community 56 - "FocusField"
Cohesion: 0.33
Nodes (6): HalfLifeBand, long, medium, short, unknown, veryLong

### Community 57 - "Unit"
Cohesion: 0.40
Nodes (5): DurationBand, long, medium, short, unknown

### Community 58 - "Components.swift"
Cohesion: 0.22
Nodes (7): BackupImportPreviewView, Int, Void, BackupRestoreMode, merge, replace, BackupRestoreSummary

### Community 59 - "PhotosPickerItem"
Cohesion: 0.20
Nodes (10): CodingKeys, answer, choices, explanation, finishReason, message, prompt, questions (+2 more)

### Community 60 - "String"
Cohesion: 0.06
Nodes (25): CoreTransferable, Foundation, DrugFilter, Bool, Calendar, Date, Drug, PrivacyValidator (+17 more)

### Community 61 - "CGPoint"
Cohesion: 0.19
Nodes (9): SaveAction, another, later, open, PreviewData, ModelContainer, PhotosUI, SwiftData (+1 more)

### Community 62 - "Bool"
Cohesion: 0.26
Nodes (4): PracticeEngineTests, Drug, Int, ModelContainer

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
Cohesion: 0.22
Nodes (6): DoseRegimensView, LocalDrugGraphView, CGPoint, CGSize, Double, Int

### Community 67 - "Decoder"
Cohesion: 0.20
Nodes (3): LearningSettingsView, Binding, Bool

### Community 68 - "ReportFile.swift"
Cohesion: 0.28
Nodes (5): HTTPURLResponse, DeepSeekURLProtocolStub, Bool, URLRequest, URLProtocol

### Community 70 - "MemoryReviewGrade"
Cohesion: 0.40
Nodes (5): BackupError, duplicateIdentifiers, invalidCounts, malformed, newerVersion

### Community 71 - "DrugDetailView.swift"
Cohesion: 0.25
Nodes (8): DrugBrandsSheet, addProduct, DrugBrandsView, DrugDetailSheet, atomicNotes, editor, regenerateReview, review

### Community 72 - "ExcretionRoute"
Cohesion: 0.20
Nodes (8): QuestionType, casePractice, counseling, drugClass, scientificName, tradeName, use, warning

### Community 73 - ".matches"
Cohesion: 0.18
Nodes (10): Accessibility & Inclusion, Anti-references, Brand Personality, Design Principles, Platform, Positioning, Product, Product Purpose (+2 more)

### Community 75 - "SafetyFlag"
Cohesion: 0.25
Nodes (8): SafetyFlag, anticoagulant, children, controlledDrug, corticosteroid, insulin, pregnancy, severeSymptoms

### Community 76 - "AppTheme.swift"
Cohesion: 0.33
Nodes (4): Observation, RenlystLayout, RenlystMotion, CGFloat

### Community 78 - "DrugEditorSection"
Cohesion: 0.29
Nodes (7): DrugEditorSection, basics, counseling, notes, pk, safety, uses

### Community 79 - "ConfidenceLevel"
Cohesion: 0.40
Nodes (5): ConfidenceLevel, mastered, medium, strong, weak

### Community 80 - "VerificationStatus"
Cohesion: 0.13
Nodes (18): MistakeVaultView, ReportView, Drug, DailyActivity, DrugRelationship, EncounterNote, PracticeAnswer, PracticeSessionResult (+10 more)

### Community 81 - "DrugRelationshipKind"
Cohesion: 0.40
Nodes (5): DrugRelationshipKind, contraindicatedCombination, interaction, relatedUse, sameClass

### Community 82 - "FocusField"
Cohesion: 0.50
Nodes (4): FocusField, scientific, trade, unknownLabel

### Community 83 - "String"
Cohesion: 0.18
Nodes (8): CropGrid, CropViewportState, NativeCropScrollView, CGPoint, Path, Shape, UIEdgeInsets, UIViewRepresentable

### Community 84 - "RenlystSurface"
Cohesion: 0.50
Nodes (3): 1. Build the IPA on GitHub, 2. Install from Windows, Build and install Renlyst using only Windows

## Knowledge Gaps
- **376 isolated node(s):** `Direction`, `Dials`, `Navigation`, `Typography`, `Color` (+371 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **19 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `String` connect `SafetyFlag` to `Drug`, `ImageCapture.swift`, `Chapter`, `PracticeSessionView`, `ShiftView`, `DosingFrequency`, `.image`, `ImageCapture.swift`, `DurationBand`, `HomeView`, `ModelAndPersistenceTests`, `QuestionType`, `HomeView`, `FocusField`, `DrugImportView.swift`, `Foundation`, `ReportEditorView`, `Path`, `.apply`, `PharmacologyScale`, `LibraryView`, `ReviewRating`, `.generate`, `SafetyRadar`, `MemoryReviewGrade`, `DosingFrequency`, `DrugRelationshipKind`, `.record`, `ReportFile.swift`, `HalfLifeBand`, `DrugEditorSection`, `Color`, `ImportedExcretionRoute`, `DrugEditorSection`, `.containsObviousIdentifier`, `NameKind`, `FocusField`, `Unit`, `Components.swift`, `PhotosPickerItem`, `.apply`, `MemoryReviewGrade`, `DoseRegimensView`, `Decoder`, `MemoryReviewGrade`, `DrugDetailView.swift`, `ExcretionRoute`, `SafetyFlag`, `AtomicNotesView`, `DrugEditorSection`, `ConfidenceLevel`, `VerificationStatus`, `DrugRelationshipKind`?**
  _High betweenness centrality (0.352) - this node is a cross-community bridge._
- **Why does `SwiftData` connect `CGPoint` to `Drug`, `ImageCapture.swift`, `PracticeSessionView`, `ShiftView`, `.image`, `CaseIterable`, `ImageCapture.swift`, `DurationBand`, `FocusField`, `Foundation`, `ReportEditorView`, `.apply`, `PharmacologyScale`, `DosingFrequency`, `HalfLifeBand`, `PracticeQuestion`, `String`, `Bool`, `DrugDetailView.swift`, `AIPracticePayload`?**
  _High betweenness centrality (0.073) - this node is a cross-community bridge._
- **Why does `Chapter` connect `.containsObviousIdentifier` to `Bool`, `PharmacologyScale`, `Drug`, `.generate`, `QuestionType`, `ShiftView`, `SafetyFlag`, `DrugRelationshipKind`, `VerificationStatus`, `DurationBand`, `Color`, `HomeView`, `ModelAndPersistenceTests`, `QuestionType`, `DrugImportView.swift`, `String`, `.apply`?**
  _High betweenness centrality (0.049) - this node is a cross-community bridge._
- **Are the 2 inferred relationships involving `String` (e.g. with `.calculate()` and `.makeModel()`) actually correct?**
  _`String` has 2 INFERRED edges - model-reasoned connections that need verification._
- **What connects `Direction`, `Dials`, `Navigation` to the rest of the system?**
  _376 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `SwiftUI` be split into smaller, more focused modules?**
  _Cohesion score 0.1339031339031339 - nodes in this community are weakly interconnected._
- **Should `ImageCapture.swift` be split into smaller, more focused modules?**
  _Cohesion score 0.0673903211216644 - nodes in this community are weakly interconnected._