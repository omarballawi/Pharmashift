# Graph Report - pharmashift  (2026-07-13)

## Corpus Check
- 44 files · ~67,904 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1066 nodes · 2618 edges · 50 communities (49 shown, 1 thin omitted)
- Extraction: 96% EXTRACTED · 4% INFERRED · 0% AMBIGUOUS · INFERRED: 101 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `f74d3827`
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
- [[_COMMUNITY_Q What should PharmaShift do after Phase 1|Q: What should PharmaShift do after Phase 1?]]
- [[_COMMUNITY_Identifiable|Identifiable]]
- [[_COMMUNITY_FocusField|FocusField]]
- [[_COMMUNITY_Foundation|Foundation]]
- [[_COMMUNITY_ReportEditorView|ReportEditorView]]
- [[_COMMUNITY_Path|Path]]
- [[_COMMUNITY_ModelAndPersistenceTests|ModelAndPersistenceTests]]
- [[_COMMUNITY_Design|Design]]
- [[_COMMUNITY_PharmacologyScale|PharmacologyScale]]
- [[_COMMUNITY_LibraryView|LibraryView]]
- [[_COMMUNITY_Drug|Drug]]
- [[_COMMUNITY_SafetyRadar|SafetyRadar]]
- [[_COMMUNITY_ImportStage|ImportStage]]
- [[_COMMUNITY_DosingFrequency|DosingFrequency]]
- [[_COMMUNITY_QuestionType|QuestionType]]
- [[_COMMUNITY_PracticeQuestion|PracticeQuestion]]
- [[_COMMUNITY_.generate|.generate]]
- [[_COMMUNITY_ReportFile.swift|ReportFile.swift]]
- [[_COMMUNITY_ImportedDosingFrequency|ImportedDosingFrequency]]
- [[_COMMUNITY_.populate|.populate]]
- [[_COMMUNITY_SafetyFlag|SafetyFlag]]
- [[_COMMUNITY_CropViewportState|CropViewportState]]
- [[_COMMUNITY_DrugEditorSection|DrugEditorSection]]
- [[_COMMUNITY_HalfLifeBand|HalfLifeBand]]
- [[_COMMUNITY_VerificationStatus|VerificationStatus]]
- [[_COMMUNITY_StorageLocation|StorageLocation]]
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

## Communities (50 total, 1 thin omitted)

### Community 0 - "ShiftLog"
Cohesion: 0.25
Nodes (12): DailyActivity, Drug, EncounterNote, LearningProfile, ReviewLog, ShiftLog, Bool, Calendar (+4 more)

### Community 1 - "SwiftUI"
Cohesion: 0.15
Nodes (12): NSObject, Coordinator, NativeCropScrollView, Bool, Int, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollView (+4 more)

### Community 2 - "Drug"
Cohesion: 0.14
Nodes (12): DailyMedProvider, DeepSeekDrugImportService, DeepSeekFastDrugGatherService, DrugImportFormattingService, DrugSourceProvider, DrugSourceProviderFactory, MockDeepSeekDrugImportService, OpenFDALabelProvider (+4 more)

### Community 3 - "ImageCapture.swift"
Cohesion: 0.15
Nodes (14): BackupImportPreviewView, Int, Void, DrugDetailSheet, editor, review, DrugDetailView, Color (+6 more)

### Community 4 - "String"
Cohesion: 0.27
Nodes (5): Encoder, DrugImportValidator, FastGatherPromptBuilder, UserConfirmedDrugIdentity, URLRequest

### Community 5 - "Chapter"
Cohesion: 0.18
Nodes (11): ImageIO, DrugImagePayload, DrugPhotoGalleryView, DrugPhotoView, DrugThumbnailView, ImageDraft, ImageEditorView, CGFloat (+3 more)

### Community 6 - "QuestionType"
Cohesion: 0.27
Nodes (8): PromptBuilder, SPLParser, SPLXMLDelegate, String, TrustedDrugSourcePacket, TrustedDrugSourcePacketExtractor, XMLParser, XMLParserDelegate

### Community 7 - "LibraryView"
Cohesion: 0.23
Nodes (8): DrugEditorView, Binding, Bool, Double, Drug, Int, PhotosPickerItem, ReferenceWritableKeyPath

### Community 8 - "PracticeSessionView"
Cohesion: 0.13
Nodes (11): DrugImportView, Data, Drug, PhotosPickerItem, DeepSeekIdentityResolver, DrugIdentityResolving, DrugImportApplier, FastDrugGatheringService (+3 more)

### Community 9 - "ShiftView"
Cohesion: 0.16
Nodes (16): ActiveShiftCard, ActiveShiftContent, EncounterEditorView, EndShiftView, ShiftPhase, ShiftPhaseRow, ShiftView, Binding (+8 more)

### Community 10 - "Identifiable"
Cohesion: 0.05
Nodes (37): CodingKey, CodingKeys, dailyActivities, drugs, encounters, learningProfiles, reports, reviews (+29 more)

### Community 11 - "SafetyFlag"
Cohesion: 0.33
Nodes (6): ImportedExcretionRoute, hepatic, mixed, other, renal, unknown

### Community 12 - "DosingFrequency"
Cohesion: 0.06
Nodes (30): PracticeView, Int, Drug, FocusAction, addDrug, finishShift, practiceWeak, reviewDue (+22 more)

### Community 13 - "HalfLifeBand"
Cohesion: 0.38
Nodes (4): CGRect, CGSize, ImageCompressor, UIImage

### Community 14 - "Build and install PharmaShift using only Windows"
Cohesion: 0.15
Nodes (10): Final Release Gate, PharmaShift Delivery Roadmap, Phase 2 - Visual Pharmacology and Safety, Phase 3 - Backup, Restore, and Export, Phase 4 - Drug Information Import, Phase 5 - Focus, Practice, and Motivation, Renlyst, 1. Build the IPA on GitHub (+2 more)

### Community 15 - "CaseIterable"
Cohesion: 0.06
Nodes (37): Int, ConfirmDrugIdentityView, FlowChips, ImportFromPhotoView, ImportMemorizationChallengeView, ImportMode, aiDraft, trusted (+29 more)

### Community 16 - "Codable"
Cohesion: 0.09
Nodes (30): BackupError, duplicateIdentifiers, invalidCounts, malformed, newerVersion, BackupRecordCounts, BackupRestoreMode, merge (+22 more)

### Community 17 - "ConfidenceLevel"
Cohesion: 0.29
Nodes (5): Any, Context, CameraPicker, UIImagePickerController, UIViewControllerRepresentable

### Community 18 - "DurationBand"
Cohesion: 0.06
Nodes (34): Observation, AboutView, AppNavigation, AppShell, AppTab, capture, home, library (+26 more)

### Community 19 - "OnsetBand"
Cohesion: 0.25
Nodes (6): CropGrid, CropViewportState, CGPoint, Path, Shape, UIEdgeInsets

### Community 21 - "ModelAndPersistenceTests"
Cohesion: 0.09
Nodes (16): CaptureView, SaveAction, another, later, open, Binding, Bool, Data (+8 more)

### Community 22 - "QuestionType"
Cohesion: 0.67
Nodes (3): ImageAcquisitionSource, camera, library

### Community 24 - "Q: What should PharmaShift do after Phase 1?"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: What should PharmaShift do after Phase 1?, Source Nodes

### Community 25 - "Identifiable"
Cohesion: 0.06
Nodes (25): Foundation, DrugFilter, Bool, Calendar, Date, Drug, PrivacyValidator, Bool (+17 more)

### Community 26 - "FocusField"
Cohesion: 0.09
Nodes (12): LearningSettingsView, Binding, Bool, DeepSeekKeyStore, deepSeekHTTPStatus, keychain, Data, URL (+4 more)

### Community 28 - "Foundation"
Cohesion: 0.14
Nodes (20): Encodable, OSStatus, DailyMedSearchItem, DailyMedSearchPayload, DeepSeekRequest, KeyStoreError, readBackFailed, Message (+12 more)

### Community 29 - "ReportEditorView"
Cohesion: 0.39
Nodes (19): Codable, Equatable, ResolvedDrugIdentity, Flashcard, ImportedAdverseEffects, ImportedArabicExplanation, ImportedCounseling, ImportedDrugInfo (+11 more)

### Community 30 - "Path"
Cohesion: 0.18
Nodes (14): ClosedRange, EmptyStateView, LabeledValue, MasteryBadge, MetricCard, PharmacologyMeter, PharmacologyScale, duration (+6 more)

### Community 31 - "ModelAndPersistenceTests"
Cohesion: 0.17
Nodes (12): LocalizedError, DrugImportError, aiReturnedEmpty, invalidAIJSON, invalidQuery, invalidResponse, missingDeepSeekKey, parsingFailed (+4 more)

### Community 32 - "Design"
Cohesion: 0.17
Nodes (11): Accessibility floor, Aesthetic direction, Brand voice, Color tokens, Core component inventory, Design, Dials, Last updated (+3 more)

### Community 33 - "PharmacologyScale"
Cohesion: 0.13
Nodes (21): Decodable, AIPracticePack, AIPracticePackStore, AIPracticePayload, AIPracticeQuestion, Choice, DeepSeekContentResponse, DeepSeekJSONClient (+13 more)

### Community 35 - "LibraryView"
Cohesion: 0.11
Nodes (14): Hashable, DrugRow, LibraryFilterView, LibraryView, Bool, Drug, Int, String (+6 more)

### Community 37 - "Drug"
Cohesion: 0.25
Nodes (8): DosingFrequency, asNeeded, fourTimesDaily, onceDaily, other, threeTimesDaily, twiceDaily, unknown

### Community 38 - "SafetyRadar"
Cohesion: 0.07
Nodes (28): CoreTransferable, Error, FileDocument, FileWrapper, BackupDataView, BackupExportKind, complete, csv (+20 more)

### Community 43 - "ImportStage"
Cohesion: 0.31
Nodes (4): LearningProgressService, Bool, ModelContext, Int

### Community 45 - "DosingFrequency"
Cohesion: 0.18
Nodes (12): SafetySeverity, high, low, medium, unknown, DosingFrequencyMeter, SafetyRadar, CGFloat (+4 more)

### Community 47 - "QuestionType"
Cohesion: 0.15
Nodes (12): PracticeInteraction, multipleChoice, recall, QuestionType, casePractice, counseling, drugClass, scientificName (+4 more)

### Community 49 - "PracticeQuestion"
Cohesion: 0.21
Nodes (10): PracticeSessionView, Drug, String, PracticeAnswer, PracticeQuestion, PracticeSessionResult, ReviewRating, correct (+2 more)

### Community 51 - ".generate"
Cohesion: 0.06
Nodes (29): App, MigrationStage, PersistentModel, PharmaShift, PharmaShiftApp, FocusField, scientific, trade (+21 more)

### Community 52 - "ReportFile.swift"
Cohesion: 0.20
Nodes (10): DrugCardAnchor, arabic, counseling, identity, mastery, notes, pharmacology, review (+2 more)

### Community 54 - "ImportedDosingFrequency"
Cohesion: 0.06
Nodes (31): ImportedDosingFrequency, fourTimesDaily, onceDaily, other, PRN, threeTimesDaily, twiceDaily, unknown (+23 more)

### Community 55 - ".populate"
Cohesion: 0.27
Nodes (7): ReportView, Drug, TrainingReport, ReportBuilder, Calendar, Drug, String

### Community 57 - "SafetyFlag"
Cohesion: 0.25
Nodes (8): SafetyFlag, anticoagulant, children, controlledDrug, corticosteroid, insulin, pregnancy, severeSymptoms

### Community 58 - "CropViewportState"
Cohesion: 0.33
Nodes (4): DrugSearchRanker, DrugSearchResult, MockDrugSourceProvider, Int

### Community 59 - "DrugEditorSection"
Cohesion: 0.29
Nodes (7): DrugEditorSection, basics, counseling, notes, pk, safety, uses

### Community 62 - "HalfLifeBand"
Cohesion: 0.08
Nodes (33): CaseIterable, Identifiable, ConfidenceLevel, mastered, medium, strong, weak, DurationBand (+25 more)

### Community 70 - "VerificationStatus"
Cohesion: 0.50
Nodes (4): VerificationStatus, pendingPharmacist, personal, pharmacistVerified

### Community 71 - "StorageLocation"
Cohesion: 0.50
Nodes (4): StorageLocation, appPreferences, keychain, protectedFile

### Community 73 - "UIImage"
Cohesion: 0.47
Nodes (3): CGImagePropertyOrientation, OCRService, UIImage

## Knowledge Gaps
- **250 isolated node(s):** `home`, `library`, `capture`, `practice`, `more` (+245 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **1 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `DrugImportView` connect `PracticeSessionView` to `Drug`, `ImageCapture.swift`, `String`, `Chapter`, `QuestionType`, `HalfLifeBand`, `CaseIterable`, `ModelAndPersistenceTests`, `CropViewportState`, `ReportEditorView`?**
  _High betweenness centrality (0.073) - this node is a cross-community bridge._
- **Why does `Chapter` connect `DurationBand` to `ShiftLog`, `ImageCapture.swift`, `LibraryView`, `ShiftView`, `DosingFrequency`, `Codable`, `PracticeQuestion`, `ModelAndPersistenceTests`, `ReportEditorView`, `HalfLifeBand`?**
  _High betweenness centrality (0.064) - this node is a cross-community bridge._
- **Why does `SwiftData` connect `.generate` to `LibraryView`, `ImageCapture.swift`, `SafetyRadar`, `ShiftView`, `DosingFrequency`, `CaseIterable`, `Codable`, `DurationBand`, `HalfLifeBand`?**
  _High betweenness centrality (0.054) - this node is a cross-community bridge._
- **Are the 2 inferred relationships involving `DrugImportView` (e.g. with `DeepSeekIdentityResolver` and `DeepSeekFastDrugGatherService`) actually correct?**
  _`DrugImportView` has 2 INFERRED edges - model-reasoned connections that need verification._
- **What connects `home`, `library`, `capture` to the rest of the system?**
  _250 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Drug` be split into smaller, more focused modules?**
  _Cohesion score 0.1354679802955665 - nodes in this community are weakly interconnected._
- **Should `ImageCapture.swift` be split into smaller, more focused modules?**
  _Cohesion score 0.1452991452991453 - nodes in this community are weakly interconnected._