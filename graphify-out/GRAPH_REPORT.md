# Graph Report - pharmashift  (2026-07-13)

## Corpus Check
- 44 files · ~67,803 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1062 nodes · 2605 edges · 54 communities (52 shown, 2 thin omitted)
- Extraction: 96% EXTRACTED · 4% INFERRED · 0% AMBIGUOUS · INFERRED: 101 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `431b347c`
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
- [[_COMMUNITY_ImportStage|ImportStage]]
- [[_COMMUNITY_.containsObviousIdentifier|.containsObviousIdentifier]]
- [[_COMMUNITY_DosingFrequency|DosingFrequency]]
- [[_COMMUNITY_ImportedDosingFrequency|ImportedDosingFrequency]]
- [[_COMMUNITY_.generate|.generate]]
- [[_COMMUNITY_ReportFile.swift|ReportFile.swift]]
- [[_COMMUNITY_CropViewportState|CropViewportState]]
- [[_COMMUNITY_DrugEditorSection|DrugEditorSection]]
- [[_COMMUNITY_HalfLifeBand|HalfLifeBand]]
- [[_COMMUNITY_ImportSelection|ImportSelection]]
- [[_COMMUNITY_UIImage|UIImage]]

## God Nodes (most connected - your core abstractions)
1. `DrugImportView` - 40 edges
2. `DrugEditorView` - 39 edges
3. `Chapter` - 39 edges
4. `CodingKeys` - 30 edges
5. `ShiftLog` - 28 edges
6. `DeepSeekKeyStore` - 28 edges
7. `Drug` - 27 edges
8. `Drug` - 26 edges
9. `UserConfirmedDrugIdentity` - 24 edges
10. `ImportedDrugInfo` - 24 edges

## Surprising Connections (you probably didn't know these)
- `PharmaShiftApp` --calls--> `AppTheme`  [INFERRED]
  PharmaShift/App/PharmaShiftApp.swift → PharmaShift/App/AppTheme.swift
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

## Communities (54 total, 2 thin omitted)

### Community 0 - "ShiftLog"
Cohesion: 0.06
Nodes (50): PracticeSessionView, Drug, String, ReportView, Drug, DailyActivity, Drug, EncounterNote (+42 more)

### Community 1 - "SwiftUI"
Cohesion: 0.16
Nodes (11): Coordinator, NativeCropScrollView, Bool, Int, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollView, UIScrollViewDelegate (+3 more)

### Community 2 - "Drug"
Cohesion: 0.15
Nodes (12): DailyMedProvider, DrugSearchRanker, DrugSearchResult, DrugSourceProvider, MockDrugSourceProvider, OpenFDALabelProvider, RxNormProvider, Int (+4 more)

### Community 3 - "ImageCapture.swift"
Cohesion: 0.17
Nodes (10): DrugDetailSheet, editor, review, DrugDetailView, Color, Content, Drug, Set (+2 more)

### Community 4 - "String"
Cohesion: 0.13
Nodes (11): Encoder, DeepSeekDrugImportService, DeepSeekFastDrugGatherService, DrugImportFormattingService, DrugImportValidator, DrugSourceProviderFactory, FastGatherPromptBuilder, MockDeepSeekDrugImportService (+3 more)

### Community 5 - "Chapter"
Cohesion: 0.12
Nodes (10): CoreTransferable, Foundation, PrivacyValidator, Bool, String, ReportFile, String, Transferable (+2 more)

### Community 6 - "QuestionType"
Cohesion: 0.24
Nodes (8): NSObject, NameKind, brand, generic, SPLParser, SPLXMLDelegate, XMLParser, XMLParserDelegate

### Community 7 - "LibraryView"
Cohesion: 0.06
Nodes (47): ClosedRange, Hashable, DrugEditorView, Binding, Bool, Double, Drug, Int (+39 more)

### Community 8 - "PracticeSessionView"
Cohesion: 0.28
Nodes (5): DrugImportApplier, FastDrugGatheringService, ImportSelection, Drug, Set

### Community 9 - "ShiftView"
Cohesion: 0.16
Nodes (16): ActiveShiftCard, ActiveShiftContent, EncounterEditorView, EndShiftView, ShiftPhase, ShiftPhaseRow, ShiftView, Binding (+8 more)

### Community 10 - "Identifiable"
Cohesion: 0.05
Nodes (37): CodingKey, CodingKeys, dailyActivities, drugs, encounters, learningProfiles, reports, reviews (+29 more)

### Community 11 - "SafetyFlag"
Cohesion: 0.06
Nodes (32): ImportedDosingFrequency, fourTimesDaily, onceDaily, other, PRN, threeTimesDaily, twiceDaily, unknown (+24 more)

### Community 12 - "DosingFrequency"
Cohesion: 0.06
Nodes (30): PracticeView, Int, Drug, FocusAction, addDrug, finishShift, practiceWeak, reviewDue (+22 more)

### Community 13 - "HalfLifeBand"
Cohesion: 0.40
Nodes (5): CaseIterable, ProdrugStatus, active, prodrug, unknown

### Community 14 - "Build and install PharmaShift using only Windows"
Cohesion: 0.15
Nodes (10): Final Release Gate, PharmaShift Delivery Roadmap, Phase 2 - Visual Pharmacology and Safety, Phase 3 - Backup, Restore, and Export, Phase 4 - Drug Information Import, Phase 5 - Focus, Practice, and Motivation, Renlyst, 1. Build the IPA on GitHub (+2 more)

### Community 15 - "CaseIterable"
Cohesion: 0.23
Nodes (11): ConfirmDrugIdentityView, FlowChips, ImportFromPhotoView, ImportMemorizationChallengeView, ImportPreviewView, ImportSourceSearchView, Bool, Color (+3 more)

### Community 16 - "Codable"
Cohesion: 0.08
Nodes (30): BackupError, duplicateIdentifiers, invalidCounts, malformed, newerVersion, BackupRecordCounts, BackupRestoreMode, merge (+22 more)

### Community 17 - "ConfidenceLevel"
Cohesion: 0.17
Nodes (12): Error, FileDocument, FileWrapper, BackupDataView, BackupImportPreview, PharmaShiftExportDocument, Data, URL (+4 more)

### Community 18 - "DurationBand"
Cohesion: 0.06
Nodes (34): Observation, AboutView, AppNavigation, AppShell, AppTab, capture, home, library (+26 more)

### Community 19 - "OnsetBand"
Cohesion: 0.67
Nodes (3): ImportMode, aiDraft, trusted

### Community 21 - "ModelAndPersistenceTests"
Cohesion: 0.10
Nodes (15): CaptureView, Binding, Bool, Data, Drug, Int, PhotosPickerItem, String (+7 more)

### Community 22 - "QuestionType"
Cohesion: 0.20
Nodes (10): ImportSection, adverseEffects, arabicExplanation, counseling, identity, memorization, pharmacokinetics, safety (+2 more)

### Community 23 - "ReportEditorView"
Cohesion: 0.26
Nodes (8): ReviewScheduler, Bool, Calendar, Date, Drug, Int, String, ReviewSchedulerTests

### Community 24 - "Q: What should PharmaShift do after Phase 1?"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: What should PharmaShift do after Phase 1?, Source Nodes

### Community 25 - "Identifiable"
Cohesion: 0.17
Nodes (8): Drug, Bool, Data, Date, Int, String, UUID, ModelAndPersistenceTests

### Community 26 - "FocusField"
Cohesion: 0.12
Nodes (13): LearningSettingsView, Binding, Bool, DeepSeekKeyStore, deepSeekHTTPStatus, keychain, StorageLocation, appPreferences (+5 more)

### Community 27 - "AppTheme"
Cohesion: 0.28
Nodes (5): DrugFilter, Bool, Calendar, Date, Drug

### Community 28 - "Foundation"
Cohesion: 0.15
Nodes (26): Decodable, Encodable, OSStatus, Candidate, Choice, DailyMedSearchItem, DailyMedSearchPayload, DeepSeekRequest (+18 more)

### Community 29 - "ReportEditorView"
Cohesion: 0.29
Nodes (23): Codable, Equatable, Flashcard, ImportedAdverseEffects, ImportedArabicExplanation, ImportedCounseling, ImportedDrugInfo, ImportedIdentity (+15 more)

### Community 30 - "Path"
Cohesion: 0.20
Nodes (11): ImageIO, DrugImagePayload, DrugPhotoGalleryView, DrugPhotoView, DrugThumbnailView, ImageDraft, ImageEditorView, CGFloat (+3 more)

### Community 31 - "ModelAndPersistenceTests"
Cohesion: 0.17
Nodes (12): LocalizedError, DrugImportError, aiReturnedEmpty, invalidAIJSON, invalidQuery, invalidResponse, missingDeepSeekKey, parsingFailed (+4 more)

### Community 32 - "Design"
Cohesion: 0.17
Nodes (11): Accessibility floor, Aesthetic direction, Brand voice, Color tokens, Core component inventory, Design, Dials, Last updated (+3 more)

### Community 33 - "PharmacologyScale"
Cohesion: 0.07
Nodes (28): Int, DrugImportView, ImportStage, challenge, confirm, photo, preview, source (+20 more)

### Community 34 - ".reportSection"
Cohesion: 0.41
Nodes (4): CGRect, CGSize, ImageCompressor, UIImage

### Community 35 - "LibraryView"
Cohesion: 0.05
Nodes (37): App, MigrationStage, PersistentModel, PharmaShift, PharmaShiftApp, FocusField, scientific, trade (+29 more)

### Community 36 - "Components.swift"
Cohesion: 0.18
Nodes (4): MigrationFixtureTests, ReportBuilderTests, PharmaShiftUITests, XCTestCase

### Community 37 - "Drug"
Cohesion: 0.25
Nodes (8): DosingFrequency, asNeeded, fourTimesDaily, onceDaily, other, threeTimesDaily, twiceDaily, unknown

### Community 38 - "SafetyRadar"
Cohesion: 0.40
Nodes (5): Identifiable, BackupExportKind, complete, csv, lightweight

### Community 39 - "ImportedExcretionRoute"
Cohesion: 0.40
Nodes (3): BackupImportPreviewView, Int, Void

### Community 40 - "DrugSearchResult"
Cohesion: 0.40
Nodes (5): ConfidenceLevel, mastered, medium, strong, weak

### Community 41 - "AppTheme"
Cohesion: 0.40
Nodes (5): DurationBand, long, medium, short, unknown

### Community 42 - ".importIfNeeded"
Cohesion: 0.27
Nodes (6): report, ReportEditorView, Binding, Date, ReferenceWritableKeyPath, String

### Community 43 - "ImportStage"
Cohesion: 0.40
Nodes (5): ExcretionRoute, hepatic, mixed, renal, unknown

### Community 44 - ".containsObviousIdentifier"
Cohesion: 0.23
Nodes (3): DrugImportServiceTests, Bool, String

### Community 45 - "DosingFrequency"
Cohesion: 0.40
Nodes (5): OnsetBand, fast, moderate, slow, unknown

### Community 46 - "ImportedDosingFrequency"
Cohesion: 0.40
Nodes (5): ImportedOnsetBand, fast, moderate, slow, unknown

### Community 51 - ".generate"
Cohesion: 0.29
Nodes (5): Any, Context, CameraPicker, UIImagePickerController, UIViewControllerRepresentable

### Community 52 - "ReportFile.swift"
Cohesion: 0.20
Nodes (10): DrugCardAnchor, arabic, counseling, identity, mastery, notes, pharmacology, review (+2 more)

### Community 58 - "CropViewportState"
Cohesion: 0.25
Nodes (6): CropGrid, CropViewportState, CGPoint, Path, Shape, UIEdgeInsets

### Community 59 - "DrugEditorSection"
Cohesion: 0.29
Nodes (7): DrugEditorSection, basics, counseling, notes, pk, safety, uses

### Community 62 - "HalfLifeBand"
Cohesion: 0.33
Nodes (6): HalfLifeBand, long, medium, short, unknown, veryLong

### Community 73 - "UIImage"
Cohesion: 0.47
Nodes (3): CGImagePropertyOrientation, OCRService, UIImage

## Knowledge Gaps
- **250 isolated node(s):** `home`, `library`, `capture`, `practice`, `more` (+245 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **2 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `DrugImportView` connect `PharmacologyScale` to `Drug`, `String`, `PracticeSessionView`, `CaseIterable`, `OnsetBand`, `ModelAndPersistenceTests`, `ReportEditorView`, `Path`, `ImportSelection`?**
  _High betweenness centrality (0.074) - this node is a cross-community bridge._
- **Why does `Chapter` connect `DurationBand` to `ShiftLog`, `ImageCapture.swift`, `SafetyRadar`, `LibraryView`, `ShiftView`, `DosingFrequency`, `HalfLifeBand`, `ModelAndPersistenceTests`, `ReportEditorView`?**
  _High betweenness centrality (0.073) - this node is a cross-community bridge._
- **Why does `CodingKeys` connect `Identifiable` to `Drug`, `Foundation`?**
  _High betweenness centrality (0.063) - this node is a cross-community bridge._
- **Are the 2 inferred relationships involving `DrugImportView` (e.g. with `DeepSeekIdentityResolver` and `DeepSeekFastDrugGatherService`) actually correct?**
  _`DrugImportView` has 2 INFERRED edges - model-reasoned connections that need verification._
- **What connects `home`, `library`, `capture` to the rest of the system?**
  _250 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `ShiftLog` be split into smaller, more focused modules?**
  _Cohesion score 0.06138975966562173 - nodes in this community are weakly interconnected._
- **Should `Drug` be split into smaller, more focused modules?**
  _Cohesion score 0.146218487394958 - nodes in this community are weakly interconnected._