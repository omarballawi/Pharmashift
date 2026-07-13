# Graph Report - pharmashift  (2026-07-13)

## Corpus Check
- 44 files · ~68,090 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1076 nodes · 2642 edges · 47 communities (44 shown, 3 thin omitted)
- Extraction: 96% EXTRACTED · 4% INFERRED · 0% AMBIGUOUS · INFERRED: 106 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `e91a4265`
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
- [[_COMMUNITY_Build and install PharmaShift using only Windows|Build and install PharmaShift using only Windows]]
- [[_COMMUNITY_CaseIterable|CaseIterable]]
- [[_COMMUNITY_Codable|Codable]]
- [[_COMMUNITY_DurationBand|DurationBand]]
- [[_COMMUNITY_AGENTS|AGENTS.md]]
- [[_COMMUNITY_ModelAndPersistenceTests|ModelAndPersistenceTests]]
- [[_COMMUNITY_QuestionType|QuestionType]]
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
- [[_COMMUNITY_ImportStage|ImportStage]]
- [[_COMMUNITY_QuestionType|QuestionType]]
- [[_COMMUNITY_PracticeQuestion|PracticeQuestion]]
- [[_COMMUNITY_.generate|.generate]]
- [[_COMMUNITY_ImportedDosingFrequency|ImportedDosingFrequency]]
- [[_COMMUNITY_.populate|.populate]]
- [[_COMMUNITY_SafetyFlag|SafetyFlag]]
- [[_COMMUNITY_HalfLifeBand|HalfLifeBand]]
- [[_COMMUNITY_UIImage|UIImage]]

## God Nodes (most connected - your core abstractions)
1. `DrugImportView` - 40 edges
2. `DrugEditorView` - 39 edges
3. `Chapter` - 39 edges
4. `CodingKeys` - 30 edges
5. `DeepSeekKeyStore` - 29 edges
6. `ShiftLog` - 28 edges
7. `Drug` - 27 edges
8. `Drug` - 26 edges
9. `UserConfirmedDrugIdentity` - 24 edges
10. `ImportedDrugInfo` - 24 edges

## Surprising Connections (you probably didn't know these)
- `DrugImportView` --calls--> `DeepSeekIdentityResolver`  [INFERRED]
  PharmaShift/Features/Library/DrugImportView.swift → PharmaShift/Services/DeepSeekLearningService.swift
- `DrugImportView` --calls--> `DeepSeekFastDrugGatherService`  [INFERRED]
  PharmaShift/Features/Library/DrugImportView.swift → PharmaShift/Services/DrugImportService.swift
- `PreviewData` --calls--> `ShiftLog`  [INFERRED]
  PharmaShift/Shared/PreviewSupport.swift → PharmaShift/Models/Models.swift
- `AppNavigation` --references--> `PracticeMode`  [EXTRACTED]
  PharmaShift/App/AppShell.swift → PharmaShift/Services/PracticeEngine.swift
- `LearningSettingsView` --references--> `LearningProfile`  [EXTRACTED]
  PharmaShift/App/AppShell.swift → PharmaShift/Models/Models.swift

## Import Cycles
- None detected.

## Communities (47 total, 3 thin omitted)

### Community 0 - "ShiftLog"
Cohesion: 0.25
Nodes (12): DailyActivity, Drug, EncounterNote, LearningProfile, ReviewLog, Bool, Calendar, Data (+4 more)

### Community 1 - "SwiftUI"
Cohesion: 0.06
Nodes (42): Any, CGRect, CGSize, Context, ImageIO, LocalizedError, NSObject, CameraPicker (+34 more)

### Community 2 - "Drug"
Cohesion: 0.17
Nodes (8): DeepSeekDrugImportService, DrugImportFormattingService, DrugSearchRanker, DrugSearchResult, DrugSourceProvider, DrugSourceProviderFactory, MockDeepSeekDrugImportService, MockDrugSourceProvider

### Community 3 - "ImageCapture.swift"
Cohesion: 0.12
Nodes (16): DosingFrequency, asNeeded, fourTimesDaily, onceDaily, other, threeTimesDaily, twiceDaily, unknown (+8 more)

### Community 4 - "String"
Cohesion: 0.20
Nodes (7): Encoder, DeepSeekFastDrugGatherService, deepSeekHTTPStatus, DrugImportValidator, FastGatherPromptBuilder, URLRequest, UserConfirmedDrugIdentity

### Community 5 - "Chapter"
Cohesion: 0.27
Nodes (7): Identifiable, PracticeAnswer, PracticeSessionResult, ReviewRating, correct, partlyCorrect, wrong

### Community 6 - "QuestionType"
Cohesion: 0.13
Nodes (16): title, DailyMedProvider, NameKind, brand, generic, OpenFDALabelProvider, PromptBuilder, RxNormProvider (+8 more)

### Community 7 - "LibraryView"
Cohesion: 0.06
Nodes (52): ClosedRange, BackupDataView, BackupImportPreviewView, Int, Void, DrugDetailSheet, editor, review (+44 more)

### Community 8 - "PracticeSessionView"
Cohesion: 0.24
Nodes (5): DrugImportView, Drug, PhotosPickerItem, FastDrugGatheringService, OCRService

### Community 9 - "ShiftView"
Cohesion: 0.15
Nodes (17): ActiveShiftCard, ActiveShiftContent, EncounterEditorView, EndShiftView, ShiftPhase, ShiftPhaseRow, ShiftView, Binding (+9 more)

### Community 10 - "Identifiable"
Cohesion: 0.06
Nodes (36): CodingKey, CodingKeys, dailyActivities, drugs, encounters, learningProfiles, reports, reviews (+28 more)

### Community 11 - "SafetyFlag"
Cohesion: 0.50
Nodes (4): VerificationStatus, pendingPharmacist, personal, pharmacistVerified

### Community 12 - "DosingFrequency"
Cohesion: 0.16
Nodes (13): Drug, FocusAction, addDrug, finishShift, practiceWeak, reviewDue, FocusModeEngine, FocusRecommendation (+5 more)

### Community 14 - "Build and install PharmaShift using only Windows"
Cohesion: 0.15
Nodes (10): Final Release Gate, PharmaShift Delivery Roadmap, Phase 2 - Visual Pharmacology and Safety, Phase 3 - Backup, Restore, and Export, Phase 4 - Drug Information Import, Phase 5 - Focus, Practice, and Motivation, Renlyst, 1. Build the IPA on GitHub (+2 more)

### Community 15 - "CaseIterable"
Cohesion: 0.21
Nodes (9): FlowChips, ImportPreviewView, Color, String, Severity, high, low, medium (+1 more)

### Community 16 - "Codable"
Cohesion: 0.06
Nodes (45): Error, FileDocument, FileWrapper, BackupExportKind, complete, csv, lightweight, BackupImportPreview (+37 more)

### Community 18 - "DurationBand"
Cohesion: 0.05
Nodes (37): App, Observation, AboutView, AppNavigation, AppShell, AppTab, capture, home (+29 more)

### Community 21 - "ModelAndPersistenceTests"
Cohesion: 0.08
Nodes (20): CaptureView, FocusField, scientific, trade, unknownLabel, SaveAction, another, later (+12 more)

### Community 22 - "QuestionType"
Cohesion: 0.18
Nodes (7): PracticeGenerator, Drug, Int, PracticeEngineTests, Drug, Int, ModelContainer

### Community 24 - "Q: What should PharmaShift do after Phase 1?"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: What should PharmaShift do after Phase 1?, Source Nodes

### Community 25 - "Identifiable"
Cohesion: 0.05
Nodes (31): CoreTransferable, Foundation, DrugFilter, Bool, Calendar, Date, Drug, PrivacyValidator (+23 more)

### Community 26 - "FocusField"
Cohesion: 0.07
Nodes (20): HTTPURLResponse, LearningSettingsView, Binding, Bool, DeepSeekKeyStore, keychain, StorageLocation, appPreferences (+12 more)

### Community 27 - "DrugImportView.swift"
Cohesion: 0.32
Nodes (6): ConfirmDrugIdentityView, ImportMemorizationChallengeView, ImportSourceSearchView, Binding, Bool, Void

### Community 28 - "Foundation"
Cohesion: 0.15
Nodes (25): Decodable, Encodable, OSStatus, Candidate, Choice, DailyMedSearchItem, DailyMedSearchPayload, DeepSeekRequest (+17 more)

### Community 29 - "ReportEditorView"
Cohesion: 0.42
Nodes (18): Codable, Equatable, Flashcard, ImportedAdverseEffects, ImportedArabicExplanation, ImportedCounseling, ImportedDrugInfo, ImportedIdentity (+10 more)

### Community 30 - "Path"
Cohesion: 0.12
Nodes (14): PracticeView, Int, PracticeMode, casePractice, classExamples, counseling, drugUse, drugWarning (+6 more)

### Community 31 - "ModelAndPersistenceTests"
Cohesion: 0.22
Nodes (9): DrugImportError, aiReturnedEmpty, invalidAIJSON, invalidQuery, invalidResponse, missingDeepSeekKey, parsingFailed, unresolvedLocalBrand (+1 more)

### Community 32 - "Design"
Cohesion: 0.17
Nodes (11): Accessibility floor, Aesthetic direction, Brand voice, Color tokens, Core component inventory, Design, Dials, Last updated (+3 more)

### Community 33 - "PharmacologyScale"
Cohesion: 0.20
Nodes (12): AIPracticePayload, AIPracticeQuestion, Choice, DeepSeekContentResponse, DeepSeekIdentityResolver, DeepSeekJSONClient, DrugIdentityResolving, Message (+4 more)

### Community 34 - "SwiftData"
Cohesion: 0.24
Nodes (5): PharmaShift, MigrationFixtureTests, ReportBuilderTests, XCTest, XCTestCase

### Community 35 - "LibraryView"
Cohesion: 0.25
Nodes (7): DrugRow, LibraryFilterView, LibraryView, Bool, Drug, Int, String

### Community 37 - "Drug"
Cohesion: 0.33
Nodes (7): MigrationStage, PersistentModel, CurrentDrugSchema, DrugMigrationPlan, Phase1DrugSchema, SchemaMigrationPlan, VersionedSchema

### Community 38 - "SafetyRadar"
Cohesion: 0.22
Nodes (9): report, ReportEditorView, ReportView, Binding, Date, Drug, ReferenceWritableKeyPath, String (+1 more)

### Community 39 - "StarterContent"
Cohesion: 0.18
Nodes (7): Hashable, PracticeCase, StarterContent, Drug, Int, ModelContext, String

### Community 40 - "PracticeView"
Cohesion: 0.28
Nodes (5): AIPracticePack, AIPracticePackStore, DeepSeekPracticeService, Date, Drug

### Community 41 - "ImportSection"
Cohesion: 0.11
Nodes (16): Content, DrugImportApplier, ImportSection, adverseEffects, arabicExplanation, counseling, identity, memorization (+8 more)

### Community 46 - "ImportStage"
Cohesion: 0.18
Nodes (9): Int, ImportFromPhotoView, ImportStage, challenge, confirm, photo, preview, source (+1 more)

### Community 47 - "QuestionType"
Cohesion: 0.12
Nodes (16): PracticeInteraction, multipleChoice, recall, ProdrugStatus, active, prodrug, unknown, QuestionType (+8 more)

### Community 49 - "PracticeQuestion"
Cohesion: 0.44
Nodes (4): PracticeSessionView, Drug, String, PracticeQuestion

### Community 51 - ".generate"
Cohesion: 0.16
Nodes (11): ImportMode, aiDraft, trusted, Double, WeaknessRadarView, PreviewData, ModelContainer, PhotosUI (+3 more)

### Community 54 - "ImportedDosingFrequency"
Cohesion: 0.07
Nodes (29): ImportedDurationBand, long, medium, short, unknown, ImportedExcretionRoute, hepatic, mixed (+21 more)

### Community 55 - ".populate"
Cohesion: 0.42
Nodes (4): ReportBuilder, Calendar, Drug, String

### Community 57 - "SafetyFlag"
Cohesion: 0.25
Nodes (8): SafetyFlag, anticoagulant, children, controlledDrug, corticosteroid, insulin, pregnancy, severeSymptoms

### Community 62 - "HalfLifeBand"
Cohesion: 0.05
Nodes (44): CaseIterable, DrugCardAnchor, arabic, counseling, identity, mastery, notes, pharmacology (+36 more)

## Knowledge Gaps
- **250 isolated node(s):** `home`, `library`, `capture`, `practice`, `more` (+245 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **3 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Chapter` connect `DurationBand` to `ShiftLog`, `Chapter`, `LibraryView`, `ShiftView`, `QuestionType`, `Codable`, `PracticeQuestion`, `ModelAndPersistenceTests`, `QuestionType`, `HalfLifeBand`, `ReportEditorView`, `Path`?**
  _High betweenness centrality (0.072) - this node is a cross-community bridge._
- **Why does `Foundation` connect `Identifiable` to `PharmacologyScale`, `SwiftData`, `StarterContent`, `DosingFrequency`, `QuestionType`, `Codable`, `DurationBand`, `Foundation`?**
  _High betweenness centrality (0.053) - this node is a cross-community bridge._
- **Why does `DrugImportView` connect `PracticeSessionView` to `PharmacologyScale`, `Drug`, `SwiftUI`, `String`, `QuestionType`, `LibraryView`, `ImportSection`, `ImportStage`, `CaseIterable`, `.generate`, `ModelAndPersistenceTests`, `DrugImportView.swift`, `ReportEditorView`?**
  _High betweenness centrality (0.051) - this node is a cross-community bridge._
- **Are the 2 inferred relationships involving `DrugImportView` (e.g. with `DeepSeekIdentityResolver` and `DeepSeekFastDrugGatherService`) actually correct?**
  _`DrugImportView` has 2 INFERRED edges - model-reasoned connections that need verification._
- **What connects `home`, `library`, `capture` to the rest of the system?**
  _250 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `SwiftUI` be split into smaller, more focused modules?**
  _Cohesion score 0.05949367088607595 - nodes in this community are weakly interconnected._
- **Should `ImageCapture.swift` be split into smaller, more focused modules?**
  _Cohesion score 0.125 - nodes in this community are weakly interconnected._