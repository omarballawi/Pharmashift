# Graph Report - pharmashift  (2026-07-12)

## Corpus Check
- 44 files · ~66,207 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1020 nodes · 2462 edges · 45 communities (43 shown, 2 thin omitted)
- Extraction: 96% EXTRACTED · 4% INFERRED · 0% AMBIGUOUS · INFERRED: 87 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `7736a402`
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
- [[_COMMUNITY_HalfLifeBand|HalfLifeBand]]
- [[_COMMUNITY_Build and install PharmaShift using only Windows|Build and install PharmaShift using only Windows]]
- [[_COMMUNITY_CaseIterable|CaseIterable]]
- [[_COMMUNITY_Codable|Codable]]
- [[_COMMUNITY_ConfidenceLevel|ConfidenceLevel]]
- [[_COMMUNITY_DurationBand|DurationBand]]
- [[_COMMUNITY_OnsetBand|OnsetBand]]
- [[_COMMUNITY_AGENTS|AGENTS.md]]
- [[_COMMUNITY_ModelAndPersistenceTests|ModelAndPersistenceTests]]
- [[_COMMUNITY_QuestionType|QuestionType]]
- [[_COMMUNITY_ReportEditorView|ReportEditorView]]
- [[_COMMUNITY_Q What should PharmaShift do after Phase 1|Q: What should PharmaShift do after Phase 1?]]
- [[_COMMUNITY_Identifiable|Identifiable]]
- [[_COMMUNITY_FocusField|FocusField]]
- [[_COMMUNITY_AppTheme|AppTheme]]
- [[_COMMUNITY_Foundation|Foundation]]
- [[_COMMUNITY_ReportEditorView|ReportEditorView]]
- [[_COMMUNITY_Path|Path]]
- [[_COMMUNITY_ModelAndPersistenceTests|ModelAndPersistenceTests]]
- [[_COMMUNITY_Design|Design]]
- [[_COMMUNITY_PharmacologyScale|PharmacologyScale]]
- [[_COMMUNITY_.reportSection|.reportSection]]
- [[_COMMUNITY_LibraryView|LibraryView]]
- [[_COMMUNITY_Components.swift|Components.swift]]
- [[_COMMUNITY_Drug|Drug]]
- [[_COMMUNITY_SafetyRadar|SafetyRadar]]
- [[_COMMUNITY_ImportedExcretionRoute|ImportedExcretionRoute]]
- [[_COMMUNITY_DrugSearchResult|DrugSearchResult]]
- [[_COMMUNITY_AppTheme|AppTheme]]
- [[_COMMUNITY_.importIfNeeded|.importIfNeeded]]
- [[_COMMUNITY_.containsObviousIdentifier|.containsObviousIdentifier]]
- [[_COMMUNITY_MigrationFixtureTests.swift|MigrationFixtureTests.swift]]

## God Nodes (most connected - your core abstractions)
1. `DrugEditorView` - 39 edges
2. `Chapter` - 39 edges
3. `DrugImportView` - 36 edges
4. `CodingKeys` - 30 edges
5. `ShiftLog` - 28 edges
6. `Drug` - 27 edges
7. `Drug` - 26 edges
8. `PracticeMode` - 24 edges
9. `PracticeQuestion` - 22 edges
10. `Coordinator` - 22 edges

## Surprising Connections (you probably didn't know these)
- `PreviewData` --calls--> `ShiftLog`  [INFERRED]
  PharmaShift/Shared/PreviewSupport.swift → PharmaShift/Models/Models.swift
- `AppNavigation` --references--> `PracticeMode`  [EXTRACTED]
  PharmaShift/App/AppShell.swift → PharmaShift/Services/PracticeEngine.swift
- `LearningSettingsView` --references--> `LearningProfile`  [EXTRACTED]
  PharmaShift/App/AppShell.swift → PharmaShift/Models/Models.swift
- `PharmaShiftApp` --calls--> `AppTheme`  [INFERRED]
  PharmaShift/App/PharmaShiftApp.swift → PharmaShift/App/AppTheme.swift
- `CaptureView` --references--> `Chapter`  [EXTRACTED]
  PharmaShift/Features/Capture/CaptureView.swift → PharmaShift/Models/Models.swift

## Import Cycles
- None detected.

## Communities (45 total, 2 thin omitted)

### Community 0 - "ShiftLog"
Cohesion: 0.25
Nodes (12): DailyActivity, Drug, EncounterNote, LearningProfile, ReviewLog, Bool, Calendar, Data (+4 more)

### Community 1 - "SwiftUI"
Cohesion: 0.12
Nodes (14): PracticeView, Int, PracticeMode, casePractice, classExamples, counseling, drugUse, drugWarning (+6 more)

### Community 2 - "Drug"
Cohesion: 0.14
Nodes (11): DailyMedProvider, DrugSearchRanker, DrugSearchResult, DrugSourceProvider, DrugSourceProviderFactory, MockDrugSourceProvider, OpenFDALabelProvider, RxNormProvider (+3 more)

### Community 3 - "ImageCapture.swift"
Cohesion: 0.07
Nodes (37): Any, CGRect, CGSize, Context, ImageIO, CameraPicker, Coordinator, CropGrid (+29 more)

### Community 4 - "String"
Cohesion: 0.16
Nodes (13): Drug, FocusAction, addDrug, finishShift, practiceWeak, reviewDue, FocusModeEngine, FocusRecommendation (+5 more)

### Community 5 - "Chapter"
Cohesion: 0.27
Nodes (7): ReportView, Drug, TrainingReport, ReportBuilder, Calendar, Drug, String

### Community 6 - "QuestionType"
Cohesion: 0.20
Nodes (8): DeepSeekDrugImportService, DrugImportFormattingService, MockDeepSeekDrugImportService, Bool, Int, TrustedDrugSourcePacket, TrustedDrugSourcePacketExtractor, UserConfirmedDrugIdentity

### Community 7 - "LibraryView"
Cohesion: 0.06
Nodes (42): DrugCardAnchor, arabic, counseling, identity, mastery, notes, pharmacology, review (+34 more)

### Community 8 - "PracticeSessionView"
Cohesion: 0.23
Nodes (8): Double, WeaknessRadarView, PreviewData, ModelContainer, PhotosUI, SwiftData, SwiftUI, UIKit

### Community 9 - "ShiftView"
Cohesion: 0.16
Nodes (17): ActiveShiftCard, ActiveShiftContent, EncounterEditorView, EndShiftView, ShiftPhase, ShiftPhaseRow, ShiftView, Binding (+9 more)

### Community 10 - "Identifiable"
Cohesion: 0.05
Nodes (37): CodingKey, CodingKeys, dailyActivities, drugs, encounters, learningProfiles, reports, reviews (+29 more)

### Community 11 - "SafetyFlag"
Cohesion: 0.08
Nodes (24): Encoder, ImportedDurationBand, long, medium, short, unknown, ImportedOnsetBand, fast (+16 more)

### Community 12 - "DosingFrequency"
Cohesion: 0.19
Nodes (9): NSObject, NameKind, brand, generic, SPLParser, SPLXMLDelegate, Data, XMLParser (+1 more)

### Community 13 - "HalfLifeBand"
Cohesion: 0.07
Nodes (39): CaseIterable, Identifiable, ConfidenceLevel, mastered, medium, strong, weak, DurationBand (+31 more)

### Community 14 - "Build and install PharmaShift using only Windows"
Cohesion: 0.15
Nodes (10): Final Release Gate, PharmaShift Delivery Roadmap, Phase 2 - Visual Pharmacology and Safety, Phase 3 - Backup, Restore, and Export, Phase 4 - Drug Information Import, Phase 5 - Focus, Practice, and Motivation, Renlyst, 1. Build the IPA on GitHub (+2 more)

### Community 15 - "CaseIterable"
Cohesion: 0.05
Nodes (40): Int, AboutView, AppShell, LearningSettingsView, MoreView, Binding, Bool, report (+32 more)

### Community 16 - "Codable"
Cohesion: 0.05
Nodes (48): Error, FileDocument, FileWrapper, BackupDataView, BackupExportKind, complete, csv, lightweight (+40 more)

### Community 17 - "ConfidenceLevel"
Cohesion: 0.17
Nodes (11): PracticeInteraction, multipleChoice, recall, QuestionType, casePractice, counseling, drugClass, scientificName (+3 more)

### Community 18 - "DurationBand"
Cohesion: 0.07
Nodes (28): AppNavigation, AppTab, capture, home, library, more, practice, HomeView (+20 more)

### Community 19 - "OnsetBand"
Cohesion: 0.44
Nodes (4): PracticeSessionView, Drug, String, PracticeQuestion

### Community 21 - "ModelAndPersistenceTests"
Cohesion: 0.18
Nodes (8): CaptureView, Binding, Bool, Data, Drug, Int, PhotosPickerItem, String

### Community 22 - "QuestionType"
Cohesion: 0.14
Nodes (14): DrugImportApplier, ImportSection, adverseEffects, arabicExplanation, counseling, identity, memorization, pharmacokinetics (+6 more)

### Community 23 - "ReportEditorView"
Cohesion: 0.06
Nodes (37): ClosedRange, DosingFrequency, asNeeded, fourTimesDaily, onceDaily, other, threeTimesDaily, twiceDaily (+29 more)

### Community 24 - "Q: What should PharmaShift do after Phase 1?"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: What should PharmaShift do after Phase 1?, Source Nodes

### Community 25 - "Identifiable"
Cohesion: 0.26
Nodes (4): PracticeEngineTests, Drug, Int, ModelContainer

### Community 26 - "FocusField"
Cohesion: 0.36
Nodes (7): MigrationStage, PersistentModel, CurrentDrugSchema, DrugMigrationPlan, Phase1DrugSchema, SchemaMigrationPlan, VersionedSchema

### Community 28 - "Foundation"
Cohesion: 0.17
Nodes (23): Decodable, Encodable, Candidate, Choice, DailyMedSearchItem, DailyMedSearchPayload, DeepSeekRequest, DeepSeekResponse (+15 more)

### Community 29 - "ReportEditorView"
Cohesion: 0.30
Nodes (22): Codable, Equatable, Flashcard, ImportedAdverseEffects, ImportedArabicExplanation, ImportedCounseling, ImportedDrugInfo, ImportedIdentity (+14 more)

### Community 30 - "Path"
Cohesion: 0.39
Nodes (3): PracticeGenerator, Drug, Int

### Community 31 - "ModelAndPersistenceTests"
Cohesion: 0.43
Nodes (4): CGImagePropertyOrientation, OCRDrugCandidate, OCRService, UIImage

### Community 32 - "Design"
Cohesion: 0.17
Nodes (11): Accessibility floor, Aesthetic direction, Brand voice, Color tokens, Core component inventory, Design, Dials, Last updated (+3 more)

### Community 33 - "PharmacologyScale"
Cohesion: 0.14
Nodes (14): AIPracticePack, AIPracticePayload, AIPracticeQuestion, Choice, DeepSeekContentResponse, DeepSeekJSONClient, Message, ResolvedDrugIdentity (+6 more)

### Community 34 - ".reportSection"
Cohesion: 0.29
Nodes (4): ImageFlowDestination, camera, crop, library

### Community 35 - "LibraryView"
Cohesion: 0.06
Nodes (24): CoreTransferable, Foundation, Hashable, DrugRow, LibraryFilterView, LibraryView, Bool, Drug (+16 more)

### Community 36 - "Components.swift"
Cohesion: 0.29
Nodes (3): AIPracticePackStore, DeepSeekPracticeService, Drug

### Community 37 - "Drug"
Cohesion: 0.50
Nodes (4): VerificationStatus, pendingPharmacist, personal, pharmacistVerified

### Community 38 - "SafetyRadar"
Cohesion: 0.17
Nodes (12): LocalizedError, DrugImportError, aiReturnedEmpty, invalidAIJSON, invalidQuery, invalidResponse, missingDeepSeekKey, parsingFailed (+4 more)

### Community 39 - "ImportedExcretionRoute"
Cohesion: 0.33
Nodes (6): ImportedExcretionRoute, hepatic, mixed, other, renal, unknown

### Community 40 - "DrugSearchResult"
Cohesion: 0.50
Nodes (4): FocusField, scientific, trade, unknownLabel

### Community 41 - "AppTheme"
Cohesion: 0.25
Nodes (6): App, Observation, AppTheme, Color, PharmaShiftApp, Scene

### Community 42 - ".importIfNeeded"
Cohesion: 0.50
Nodes (4): SaveAction, another, later, open

### Community 44 - ".containsObviousIdentifier"
Cohesion: 0.05
Nodes (28): DrugFilter, Bool, Calendar, Date, Drug, ReviewScheduler, Bool, Calendar (+20 more)

### Community 47 - "MigrationFixtureTests.swift"
Cohesion: 0.25
Nodes (8): SafetyFlag, anticoagulant, children, controlledDrug, corticosteroid, insulin, pregnancy, severeSymptoms

## Knowledge Gaps
- **244 isolated node(s):** `home`, `library`, `capture`, `practice`, `more` (+239 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **2 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `DrugImportView` connect `CaseIterable` to `PharmacologyScale`, `.reportSection`, `Drug`, `ImageCapture.swift`, `QuestionType`, `QuestionType`, `ReportEditorView`, `ModelAndPersistenceTests`?**
  _High betweenness centrality (0.062) - this node is a cross-community bridge._
- **Why does `Chapter` connect `DurationBand` to `ShiftLog`, `SwiftUI`, `LibraryView`, `AppTheme`, `ShiftView`, `HalfLifeBand`, `OnsetBand`, `ModelAndPersistenceTests`, `ReportEditorView`, `Path`?**
  _High betweenness centrality (0.062) - this node is a cross-community bridge._
- **Why does `SwiftData` connect `PracticeSessionView` to `LibraryView`, `String`, `LibraryView`, `ShiftView`, `HalfLifeBand`, `CaseIterable`, `Codable`, `DurationBand`, `FocusField`, `AppTheme`?**
  _High betweenness centrality (0.061) - this node is a cross-community bridge._
- **What connects `home`, `library`, `capture` to the rest of the system?**
  _244 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `SwiftUI` be split into smaller, more focused modules?**
  _Cohesion score 0.125 - nodes in this community are weakly interconnected._
- **Should `Drug` be split into smaller, more focused modules?**
  _Cohesion score 0.14408602150537633 - nodes in this community are weakly interconnected._
- **Should `ImageCapture.swift` be split into smaller, more focused modules?**
  _Cohesion score 0.06811263318112633 - nodes in this community are weakly interconnected._