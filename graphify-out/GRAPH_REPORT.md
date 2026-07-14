# Graph Report - pharmashift  (2026-07-14)

## Corpus Check
- 45 files · ~190,283 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1304 nodes · 3391 edges · 77 communities (76 shown, 1 thin omitted)
- Extraction: 96% EXTRACTED · 4% INFERRED · 0% AMBIGUOUS · INFERRED: 138 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `ec3c674b`
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
- [[_COMMUNITY_PharmacologyScale|PharmacologyScale]]
- [[_COMMUNITY_Build and install PharmaShift using only Windows|Build and install PharmaShift using only Windows]]
- [[_COMMUNITY_CaseIterable|CaseIterable]]
- [[_COMMUNITY_Codable|Codable]]
- [[_COMMUNITY_BackupDataView|BackupDataView]]
- [[_COMMUNITY_DurationBand|DurationBand]]
- [[_COMMUNITY_.makeBackup|.makeBackup]]
- [[_COMMUNITY_AGENTS|AGENTS.md]]
- [[_COMMUNITY_ModelAndPersistenceTests|ModelAndPersistenceTests]]
- [[_COMMUNITY_QuestionType|QuestionType]]
- [[_COMMUNITY_String|String]]
- [[_COMMUNITY_Q What should PharmaShift do after Phase 1|Q: What should PharmaShift do after Phase 1?]]
- [[_COMMUNITY_Identifiable|Identifiable]]
- [[_COMMUNITY_FocusField|FocusField]]
- [[_COMMUNITY_DrugImportView.swift|DrugImportView.swift]]
- [[_COMMUNITY_Foundation|Foundation]]
- [[_COMMUNITY_ReportEditorView|ReportEditorView]]
- [[_COMMUNITY_Path|Path]]
- [[_COMMUNITY_ModelAndPersistenceTests|ModelAndPersistenceTests]]
- [[_COMMUNITY_Design|Design]]
- [[_COMMUNITY_PharmacologyScale|PharmacologyScale]]
- [[_COMMUNITY_SwiftData|SwiftData]]
- [[_COMMUNITY_LibraryView|LibraryView]]
- [[_COMMUNITY_PharmaShiftUITests|PharmaShiftUITests]]
- [[_COMMUNITY_Drug|Drug]]
- [[_COMMUNITY_SafetyRadar|SafetyRadar]]
- [[_COMMUNITY_StarterContent|StarterContent]]
- [[_COMMUNITY_PracticeView|PracticeView]]
- [[_COMMUNITY_ImportSection|ImportSection]]
- [[_COMMUNITY_.apply|.apply]]
- [[_COMMUNITY_.parsePacket|.parsePacket]]
- [[_COMMUNITY_.contains|.contains]]
- [[_COMMUNITY_CounselingSpeechRecognizer|CounselingSpeechRecognizer]]
- [[_COMMUNITY_ImportStage|ImportStage]]
- [[_COMMUNITY_QuestionType|QuestionType]]
- [[_COMMUNITY_.canonicalKey|.canonicalKey]]
- [[_COMMUNITY_PracticeQuestion|PracticeQuestion]]
- [[_COMMUNITY_CameraPicker|CameraPicker]]
- [[_COMMUNITY_.generate|.generate]]
- [[_COMMUNITY_DoseCalculatorError|DoseCalculatorError]]
- [[_COMMUNITY_DrugCardAnchor|DrugCardAnchor]]
- [[_COMMUNITY_ImportedDosingFrequency|ImportedDosingFrequency]]
- [[_COMMUNITY_.populate|.populate]]
- [[_COMMUNITY_DrugDetailSheet|DrugDetailSheet]]
- [[_COMMUNITY_SafetyFlag|SafetyFlag]]
- [[_COMMUNITY_CodingKeys|CodingKeys]]
- [[_COMMUNITY_DeepSeekURLProtocolStub|DeepSeekURLProtocolStub]]
- [[_COMMUNITY_.generate|.generate]]
- [[_COMMUNITY_DrugBackupDTO|DrugBackupDTO]]
- [[_COMMUNITY_HalfLifeBand|HalfLifeBand]]
- [[_COMMUNITY_DrugCardPage|DrugCardPage]]
- [[_COMMUNITY_MemoryReviewGrade|MemoryReviewGrade]]
- [[_COMMUNITY_EliminationPathway|EliminationPathway]]
- [[_COMMUNITY_XCTestCase|XCTestCase]]
- [[_COMMUNITY_AtomicNoteKind|AtomicNoteKind]]
- [[_COMMUNITY_DrugEvidenceQuality|DrugEvidenceQuality]]
- [[_COMMUNITY_HalfLifeBand|HalfLifeBand]]
- [[_COMMUNITY_PKBand|PKBand]]
- [[_COMMUNITY_BackupImportPreviewView|BackupImportPreviewView]]
- [[_COMMUNITY_BackupError|BackupError]]
- [[_COMMUNITY_UIImage|UIImage]]
- [[_COMMUNITY_Severity|Severity]]
- [[_COMMUNITY_.path|.path]]
- [[_COMMUNITY_BackupRestoreMode|BackupRestoreMode]]

## God Nodes (most connected - your core abstractions)
1. `Chapter` - 42 edges
2. `DrugImportView` - 41 edges
3. `Drug` - 41 edges
4. `DrugEditorView` - 39 edges
5. `Drug` - 30 edges
6. `CodingKeys` - 30 edges
7. `DeepSeekKeyStore` - 29 edges
8. `ShiftLog` - 28 edges
9. `ImportedDrugInfo` - 28 edges
10. `PracticeSessionView` - 27 edges

## Surprising Connections (you probably didn't know these)
- `PreviewData` --calls--> `ShiftLog`  [INFERRED]
  PharmaShift/Shared/PreviewSupport.swift → PharmaShift/Models/Models.swift
- `AppNavigation` --references--> `PracticeMode`  [EXTRACTED]
  PharmaShift/App/AppShell.swift → PharmaShift/Services/PracticeEngine.swift
- `LearningSettingsView` --references--> `LearningProfile`  [EXTRACTED]
  PharmaShift/App/AppShell.swift → PharmaShift/Models/Models.swift
- `PharmaShiftApp` --calls--> `AppTheme`  [INFERRED]
  PharmaShift/App/PharmaShiftApp.swift → PharmaShift/App/AppTheme.swift
- `BackupImportPreview` --references--> `PharmaShiftBackup`  [EXTRACTED]
  PharmaShift/Features/Backup/BackupDataView.swift → PharmaShift/Services/BackupService.swift

## Import Cycles
- None detected.

## Communities (77 total, 1 thin omitted)

### Community 0 - "ShiftLog"
Cohesion: 0.14
Nodes (25): ReportView, Drug, AtomicDrugNote, DailyActivity, DrugRelationship, DrugRelationshipKind, contraindicatedCombination, interaction (+17 more)

### Community 1 - "SwiftUI"
Cohesion: 0.15
Nodes (13): Coordinator, CropViewportState, NativeCropScrollView, Bool, CGSize, UIEdgeInsets, UIImagePickerControllerDelegate, UINavigationControllerDelegate (+5 more)

### Community 2 - "Drug"
Cohesion: 0.36
Nodes (3): title, DrugSearchRanker, DrugSearchResult

### Community 3 - "ImageCapture.swift"
Cohesion: 0.25
Nodes (8): ImportedDosingFrequency, fourTimesDaily, onceDaily, other, PRN, threeTimesDaily, twiceDaily, unknown

### Community 4 - "String"
Cohesion: 0.17
Nodes (7): Encoder, DrugImportValidator, FastGatherPromptBuilder, URLRequest, UserConfirmedDrugIdentity, DrugImportServiceTests, String

### Community 5 - "Chapter"
Cohesion: 0.14
Nodes (22): Identifiable, DoseCalculationResult, DoseCalculator, DoseFormulaKind, fixed, mgPerKgPerDay, mgPerKgPerDose, mgPerSquareMeter (+14 more)

### Community 6 - "QuestionType"
Cohesion: 0.17
Nodes (7): DeepSeekDrugImportService, DeepSeekFastDrugGatherService, DrugImportFormattingService, MockDeepSeekDrugImportService, OpenFDALabelProvider, RxNormProvider, URLSession

### Community 7 - "LibraryView"
Cohesion: 0.06
Nodes (35): Hashable, DrugEditorView, Binding, Bool, Double, Drug, Int, PhotosPickerItem (+27 more)

### Community 8 - "PracticeSessionView"
Cohesion: 0.15
Nodes (11): DrugImportView, ImportMemorizationChallengeView, Bool, Data, Drug, PhotosPickerItem, DeepSeekIdentityResolver, DrugIdentityResolving (+3 more)

### Community 9 - "ShiftView"
Cohesion: 0.16
Nodes (16): ActiveShiftCard, ActiveShiftContent, EncounterEditorView, EndShiftView, ShiftPhase, ShiftPhaseRow, ShiftView, Binding (+8 more)

### Community 10 - "Identifiable"
Cohesion: 0.07
Nodes (27): CodingKeys, adverseReactions, boxedWarning, brandName, clinicalPharmacology, contraindications, dosageAndAdministration, dosageForm (+19 more)

### Community 11 - "SafetyFlag"
Cohesion: 0.12
Nodes (16): AVFoundation, AtomicNotesView, CounselingBuilderView, DoseRegimensView, Item, LocalDrugGraphView, MechanismBuilderView, ProductLeafletEditorView (+8 more)

### Community 12 - "DosingFrequency"
Cohesion: 0.16
Nodes (13): Drug, FocusAction, addDrug, finishShift, practiceWeak, reviewDue, FocusModeEngine, FocusRecommendation (+5 more)

### Community 13 - "PharmacologyScale"
Cohesion: 0.15
Nodes (16): ClosedRange, PKTimelineChallengeView, Binding, EmptyStateView, LabeledValue, MasteryBadge, MetricCard, PharmacologyMeter (+8 more)

### Community 14 - "Build and install PharmaShift using only Windows"
Cohesion: 0.15
Nodes (10): Final Release Gate, PharmaShift Delivery Roadmap, Phase 2 - Visual Pharmacology and Safety, Phase 3 - Backup, Restore, and Export, Phase 4 - Drug Information Import, Phase 5 - Focus, Practice, and Motivation, Renlyst, 1. Build the IPA on GitHub (+2 more)

### Community 15 - "CaseIterable"
Cohesion: 0.16
Nodes (12): ConfirmDrugIdentityView, FlowChips, ImportFromPhotoView, ImportMode, aiDraft, trusted, ImportPreviewView, ImportSourceSearchView (+4 more)

### Community 16 - "Codable"
Cohesion: 0.20
Nodes (15): BackupRecordCounts, BackupRestoreSummary, DailyActivityBackupDTO, DrugProductBackupDTO, DrugRelationshipBackupDTO, EncounterBackupDTO, LearningProfileBackupDTO, PharmaShiftBackup (+7 more)

### Community 17 - "BackupDataView"
Cohesion: 0.13
Nodes (17): Error, FileDocument, FileWrapper, BackupDataView, BackupExportKind, complete, csv, lightweight (+9 more)

### Community 18 - "DurationBand"
Cohesion: 0.05
Nodes (47): App, LinearGradient, Observation, AboutView, AppNavigation, AppShell, AppTab, capture (+39 more)

### Community 19 - ".makeBackup"
Cohesion: 0.22
Nodes (5): BackupService, Data, ModelContext, BackupServiceTests, ModelContainer

### Community 21 - "ModelAndPersistenceTests"
Cohesion: 0.10
Nodes (15): CaptureView, Binding, Bool, Data, Drug, Int, PhotosPickerItem, String (+7 more)

### Community 22 - "QuestionType"
Cohesion: 0.26
Nodes (4): PracticeEngineTests, Drug, Int, ModelContainer

### Community 23 - "String"
Cohesion: 0.20
Nodes (5): DrugDetailView, Color, Content, String, T

### Community 24 - "Q: What should PharmaShift do after Phase 1?"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: What should PharmaShift do after Phase 1?, Source Nodes

### Community 25 - "Identifiable"
Cohesion: 0.13
Nodes (11): DrugFilter, Bool, Calendar, Date, Drug, Drug, Bool, Date (+3 more)

### Community 26 - "FocusField"
Cohesion: 0.13
Nodes (16): OSStatus, LearningSettingsView, Binding, Bool, DeepSeekKeyStore, deepSeekHTTPStatus, KeyStoreError, keychain (+8 more)

### Community 27 - "DrugImportView.swift"
Cohesion: 0.16
Nodes (11): ImageIO, DrugImagePayload, DrugPhotoGalleryView, DrugPhotoView, DrugThumbnailView, ImageDraft, ImageEditorView, Data (+3 more)

### Community 28 - "Foundation"
Cohesion: 0.15
Nodes (25): Decodable, Encodable, Candidate, Choice, DailyMedProvider, DailyMedSearchItem, DailyMedSearchPayload, DeepSeekRequest (+17 more)

### Community 29 - "ReportEditorView"
Cohesion: 0.34
Nodes (21): Codable, Equatable, EliminationInfo, EliminationRouteInfo, ProdrugInfo, Flashcard, GeneratedReviewQuestionDTO, ImportedAdverseEffects (+13 more)

### Community 30 - "Path"
Cohesion: 0.10
Nodes (18): DailyRefreshView, MistakeVaultView, PracticeView, Drug, Int, PracticeMode, casePractice, classExamples (+10 more)

### Community 31 - "ModelAndPersistenceTests"
Cohesion: 0.11
Nodes (12): DrugImportError, aiReturnedEmpty, invalidAIJSON, invalidQuery, invalidResponse, missingDeepSeekKey, parsingFailed, unresolvedLocalBrand (+4 more)

### Community 32 - "Design"
Cohesion: 0.17
Nodes (11): Accessibility floor, Aesthetic direction, Brand voice, Color tokens, Core component inventory, Design, Dials, Last updated (+3 more)

### Community 33 - "PharmacologyScale"
Cohesion: 0.15
Nodes (15): AIPracticePack, AIPracticePackStore, AIPracticePayload, AIPracticeQuestion, Choice, DeepSeekContentResponse, DeepSeekJSONClient, DeepSeekPracticeService (+7 more)

### Community 34 - "SwiftData"
Cohesion: 0.19
Nodes (10): MigrationStage, PersistentModel, PharmaShift, CurrentDrugSchema, DrugMigrationPlan, Phase1DrugSchema, SchemaMigrationPlan, SwiftData (+2 more)

### Community 35 - "LibraryView"
Cohesion: 0.12
Nodes (18): CompareCanvasView, DrugRow, KnowledgeGraphView, LibraryFilterView, LibrarySection, cards, compare, graph (+10 more)

### Community 36 - "PharmaShiftUITests"
Cohesion: 0.24
Nodes (4): PharmaShiftUITests, Int, XCUIApplication, XCUIElement

### Community 37 - "Drug"
Cohesion: 0.19
Nodes (7): AltibbiProvider, DrugDataConsistencyNormalizer, Double, URL, Unit, hours, minutes

### Community 38 - "SafetyRadar"
Cohesion: 0.19
Nodes (8): report, ReportEditorView, Binding, Date, Double, ReferenceWritableKeyPath, String, WeaknessRadarView

### Community 39 - "StarterContent"
Cohesion: 0.36
Nodes (4): CGRect, ImageCompressor, CGFloat, UIImage

### Community 40 - "PracticeView"
Cohesion: 0.12
Nodes (10): CoreTransferable, Foundation, PrivacyValidator, Bool, String, ReportFile, String, Transferable (+2 more)

### Community 41 - "ImportSection"
Cohesion: 0.17
Nodes (11): Content, ImportSection, adverseEffects, arabicExplanation, counseling, identity, memorization, pharmacokinetics (+3 more)

### Community 42 - ".apply"
Cohesion: 0.29
Nodes (8): ReviewScheduler, Bool, Calendar, Date, Drug, Int, String, ReviewSchedulerTests

### Community 43 - ".parsePacket"
Cohesion: 0.18
Nodes (9): NSObject, NameKind, brand, generic, SPLParser, SPLXMLDelegate, Data, XMLParser (+1 more)

### Community 44 - ".contains"
Cohesion: 0.26
Nodes (6): DrugImportApplier, ImportSelection, Bool, Drug, Set, URLResponse

### Community 45 - "CounselingSpeechRecognizer"
Cohesion: 0.26
Nodes (6): ObservableObject, CounselingSpeechRecognizer, Bool, VoiceCounselingView, SFSpeechAudioBufferRecognitionRequest, SFSpeechRecognitionTask

### Community 46 - "ImportStage"
Cohesion: 0.25
Nodes (7): Int, ImportStage, challenge, confirm, photo, preview, source

### Community 47 - "QuestionType"
Cohesion: 0.14
Nodes (15): GeneratedReviewQuestion, MemoryItemState, PracticeInteraction, multipleChoice, recall, textEntry, trueFalse, QuestionType (+7 more)

### Community 48 - ".canonicalKey"
Cohesion: 0.27
Nodes (3): DrugLibraryMigrationService, IngredientIdentity, ModelContext

### Community 49 - "PracticeQuestion"
Cohesion: 0.38
Nodes (3): PracticeSessionView, String, PracticeQuestion

### Community 50 - "CameraPicker"
Cohesion: 0.29
Nodes (5): Any, Context, CameraPicker, UIImagePickerController, UIViewControllerRepresentable

### Community 51 - ".generate"
Cohesion: 0.11
Nodes (17): FocusField, scientific, trade, unknownLabel, SaveAction, another, later, open (+9 more)

### Community 52 - "DoseCalculatorError"
Cohesion: 0.20
Nodes (10): LocalizedError, DoseCalculatorError, ageOutsideRegimen, heightRequired, invalidRegimen, sexOutsideRegimen, weightRequired, ImagePipelineError (+2 more)

### Community 53 - "DrugCardAnchor"
Cohesion: 0.20
Nodes (10): DrugCardAnchor, arabic, counseling, identity, mastery, notes, pharmacology, review (+2 more)

### Community 54 - "ImportedDosingFrequency"
Cohesion: 0.09
Nodes (24): ImportedDurationBand, long, medium, short, unknown, ImportedExcretionRoute, hepatic, mixed (+16 more)

### Community 55 - ".populate"
Cohesion: 0.42
Nodes (4): ReportBuilder, Calendar, Drug, String

### Community 56 - "DrugDetailSheet"
Cohesion: 0.20
Nodes (10): DrugDetailSheet, atomicNotes, counselingBuilder, editor, mechanism, pkTimeline, regenerateReview, review (+2 more)

### Community 57 - "SafetyFlag"
Cohesion: 0.13
Nodes (16): Drug, DrugProduct, SafetyFlag, anticoagulant, children, controlledDrug, corticosteroid, insulin (+8 more)

### Community 58 - "CodingKeys"
Cohesion: 0.22
Nodes (9): CodingKey, CodingKeys, dailyActivities, drugs, encounters, learningProfiles, reports, reviews (+1 more)

### Community 59 - "DeepSeekURLProtocolStub"
Cohesion: 0.28
Nodes (5): HTTPURLResponse, DeepSeekURLProtocolStub, Bool, URLRequest, URLProtocol

### Community 60 - ".generate"
Cohesion: 0.44
Nodes (3): PracticeGenerator, Drug, Int

### Community 61 - "DrugBackupDTO"
Cohesion: 0.39
Nodes (4): DrugBackupDTO, Bool, Double, Drug

### Community 62 - "HalfLifeBand"
Cohesion: 0.07
Nodes (29): CaseIterable, ConfidenceLevel, mastered, medium, strong, weak, DurationBand, long (+21 more)

### Community 63 - "DrugCardPage"
Cohesion: 0.25
Nodes (8): DrugCardPage, brands, counsel, doses, learn, links, overview, safety

### Community 64 - "MemoryReviewGrade"
Cohesion: 0.25
Nodes (6): Color, MemoryReviewGrade, again, easy, good, hard

### Community 65 - "EliminationPathway"
Cohesion: 0.29
Nodes (7): EliminationPathway, biliaryFecal, mixed, other, pulmonary, renalUrine, unknown

### Community 66 - "XCTestCase"
Cohesion: 0.33
Nodes (5): MigrationFixtureTests, Data, UUID, ReportBuilderTests, XCTestCase

### Community 67 - "AtomicNoteKind"
Cohesion: 0.33
Nodes (6): AtomicNoteKind, confusingPoint, memoryTrick, patientCounseling, shelfObservation, sourceCorrection

### Community 68 - "DrugEvidenceQuality"
Cohesion: 0.33
Nodes (6): DrugEvidenceQuality, aiUnverified, altibbi, manual, officialLabel, productLeaflet

### Community 69 - "HalfLifeBand"
Cohesion: 0.33
Nodes (6): HalfLifeBand, long, medium, short, unknown, veryLong

### Community 70 - "PKBand"
Cohesion: 0.33
Nodes (6): PKBand, long, medium, short, unknown, veryLong

### Community 71 - "BackupImportPreviewView"
Cohesion: 0.40
Nodes (3): BackupImportPreviewView, Int, Void

### Community 72 - "BackupError"
Cohesion: 0.40
Nodes (5): BackupError, duplicateIdentifiers, invalidCounts, malformed, newerVersion

### Community 73 - "UIImage"
Cohesion: 0.38
Nodes (3): CGImagePropertyOrientation, OCRService, UIImage

### Community 74 - "Severity"
Cohesion: 0.40
Nodes (5): Severity, high, low, medium, unknown

### Community 75 - ".path"
Cohesion: 0.40
Nodes (4): CropGrid, CGPoint, Path, Shape

### Community 76 - "BackupRestoreMode"
Cohesion: 0.50
Nodes (3): BackupRestoreMode, merge, replace

## Knowledge Gaps
- **316 isolated node(s):** `home`, `library`, `capture`, `practice`, `more` (+311 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **1 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `SwiftData` connect `SwiftData` to `LibraryView`, `Chapter`, `SafetyRadar`, `LibraryView`, `ShiftView`, `SafetyFlag`, `DosingFrequency`, `CaseIterable`, `Codable`, `BackupDataView`, `DurationBand`, `.generate`, `Foundation`, `Path`?**
  _High betweenness centrality (0.062) - this node is a cross-community bridge._
- **Why does `Chapter` connect `DurationBand` to `ShiftLog`, `LibraryView`, `Chapter`, `LibraryView`, `ShiftView`, `PracticeQuestion`, `ModelAndPersistenceTests`, `String`, `HalfLifeBand`, `SafetyFlag`, `.generate`, `ReportEditorView`, `Path`?**
  _High betweenness centrality (0.053) - this node is a cross-community bridge._
- **Why does `DrugEditorView` connect `LibraryView` to `LibraryView`, `HalfLifeBand`, `QuestionType`, `StarterContent`, `DurationBand`, `.generate`, `ModelAndPersistenceTests`, `String`, `DrugImportView.swift`, `Foundation`, `HalfLifeBand`?**
  _High betweenness centrality (0.053) - this node is a cross-community bridge._
- **What connects `home`, `library`, `capture` to the rest of the system?**
  _316 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `ShiftLog` be split into smaller, more focused modules?**
  _Cohesion score 0.13846153846153847 - nodes in this community are weakly interconnected._
- **Should `Chapter` be split into smaller, more focused modules?**
  _Cohesion score 0.1354679802955665 - nodes in this community are weakly interconnected._
- **Should `LibraryView` be split into smaller, more focused modules?**
  _Cohesion score 0.06451612903225806 - nodes in this community are weakly interconnected._