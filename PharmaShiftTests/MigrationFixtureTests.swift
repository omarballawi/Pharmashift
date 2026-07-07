import SwiftData
import XCTest
@testable import PharmaShift

private typealias CurrentDrugModel = Drug

private enum Phase1DrugSchema: VersionedSchema {
    static var versionIdentifier = Schema.Version(1, 0, 0)
    static var models: [any PersistentModel.Type] { [Drug.self] }

    @Model
    final class Drug {
        @Attribute(.unique) var id: UUID
        var scientificName: String
        var tradeNames: [String]
        var chapterRaw: String
        var drugClass: String
        var dosageForms: [String]
        var strengths: [String]
        var indications: [String]
        var howToTake: String
        var foodInstruction: String
        var commonSideEffects: [String]
        var warnings: [String]
        var counselingSentence: String
        var patientQuestions: [String]
        var shelfLocation: String
        @Attribute(.externalStorage) var imageData: Data?
        var confidenceRaw: String
        var timesSeen: Int
        var dateAdded: Date
        var lastSeenDate: Date?
        var lastReviewed: Date?
        var nextReviewDate: Date
        var masteryScientificName: Bool
        var masteryTradeName: Bool
        var masteryClass: Bool
        var masteryUse: Bool
        var masteryWarning: Bool
        var masteryCounseling: Bool
        var notes: String
        var captureLabel: String
        var isUnknown: Bool
        var isConfusing: Bool
        var correctStreak: Int
        var safetyFlagsRaw: [String]
        var starterSeedID: String?
        var sourceNote: String
        var verificationRaw: String
        var routes: [String] = []
        var mechanism: String = ""
        var contraindications: [String] = []
        var interactions: [String] = []
        var toxicity: String = ""
        var halfLifeText: String = ""
        var halfLifeBandRaw: String = "Unknown"
        var onsetText: String = ""
        var onsetBandRaw: String = "Unknown"
        var durationText: String = ""
        var durationBandRaw: String = "Unknown"
        var dosingFrequencyRaw: String = "Unknown"
        var timesPerDay: Int?
        var prodrugStatusRaw: String = "Unknown"
        var excretionRouteRaw: String = "Unknown"
        var excretionNotes: String = ""
        var renalCaution: String = ""
        var hepaticCaution: String = ""
        var pregnancyCaution: String = ""
        var contraindicationSeverityRaw: String = "Unknown"
        var toxicitySeverityRaw: String = "Unknown"
        var warningSeverityRaw: String = "Unknown"
        var interactionSeverityRaw: String = "Unknown"
        var renalSeverityRaw: String = "Unknown"
        var hepaticSeverityRaw: String = "Unknown"
        var pregnancySeverityRaw: String = "Unknown"
        var arabicExplanation: String = ""
        var arabicMechanism: String = ""
        var arabicCounseling: String = ""
        var arabicPersonalNotes: String = ""
        var sourceURL: String = ""
        var importedSourceName: String = ""
        @Attribute(.externalStorage) var thumbnailData: Data?

        init(id: UUID, imageData: Data, thumbnailData: Data) {
            self.id = id; scientificName = "Legacy medicine"; tradeNames = ["Legacy brand"]
            chapterRaw = Chapter.endocrine.rawValue; drugClass = "Legacy class"; dosageForms = ["Tablet"]; strengths = ["500 mg"]
            indications = ["Legacy use"]; howToTake = "With food"; foodInstruction = "After a meal"
            commonSideEffects = ["Nausea"]; warnings = ["Legacy warning"]; counselingSentence = "Legacy counseling"
            patientQuestions = ["Legacy question"]; shelfLocation = "A1"; self.imageData = imageData; self.thumbnailData = thumbnailData
            confidenceRaw = ConfidenceLevel.medium.rawValue; timesSeen = 4; dateAdded = Date(timeIntervalSince1970: 1_700_000_000)
            lastSeenDate = dateAdded; lastReviewed = dateAdded; nextReviewDate = dateAdded.addingTimeInterval(86_400)
            masteryScientificName = true; masteryTradeName = true; masteryClass = false; masteryUse = false; masteryWarning = false; masteryCounseling = false
            notes = "Legacy notes"; captureLabel = "Legacy box"; isUnknown = false; isConfusing = true; correctStreak = 2
            safetyFlagsRaw = [SafetyFlag.pregnancy.rawValue]; starterSeedID = "legacy-seed"; sourceNote = "Legacy source"; verificationRaw = VerificationStatus.personal.rawValue
            routes = ["Oral"]; mechanism = "Legacy mechanism"; contraindications = ["Legacy contraindication"]; interactions = ["Legacy interaction"]
            toxicity = "Legacy toxicity"; halfLifeText = "6 hours"; halfLifeBandRaw = HalfLifeBand.medium.rawValue
            onsetText = "30 minutes"; onsetBandRaw = OnsetBand.fast.rawValue; durationText = "12 hours"; durationBandRaw = DurationBand.medium.rawValue
            dosingFrequencyRaw = DosingFrequency.twiceDaily.rawValue; timesPerDay = 2; prodrugStatusRaw = ProdrugStatus.no.rawValue
            excretionRouteRaw = ExcretionRoute.renal.rawValue; excretionNotes = "Legacy excretion"; renalCaution = "Renal caution"
            hepaticCaution = "Hepatic caution"; pregnancyCaution = "Pregnancy caution"; contraindicationSeverityRaw = SafetySeverity.high.rawValue
            toxicitySeverityRaw = SafetySeverity.medium.rawValue; warningSeverityRaw = SafetySeverity.high.rawValue
            interactionSeverityRaw = SafetySeverity.medium.rawValue; renalSeverityRaw = SafetySeverity.high.rawValue
            hepaticSeverityRaw = SafetySeverity.low.rawValue; pregnancySeverityRaw = SafetySeverity.high.rawValue
            arabicExplanation = "شرح عربي قديم"; arabicMechanism = "آلية قديمة"; arabicCounseling = "إرشاد قديم"; arabicPersonalNotes = "ملاحظات عربية"
            sourceURL = "https://example.test/legacy"; importedSourceName = "Legacy provider"
        }
    }
}

private enum CurrentDrugSchema: VersionedSchema {
    static var versionIdentifier = Schema.Version(2, 0, 0)
    static var models: [any PersistentModel.Type] { [CurrentDrugModel.self] }
}

private enum DrugMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] { [Phase1DrugSchema.self, CurrentDrugSchema.self] }
    static var stages: [MigrationStage] { [.lightweight(fromVersion: Phase1DrugSchema.self, toVersion: CurrentDrugSchema.self)] }
}

@MainActor
final class MigrationFixtureTests: XCTestCase {
    func testPhase1StoreMigratesAllDataAndExternalImages() throws {
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: directory) }
        let url = directory.appendingPathComponent("Phase1Fixture.store")
        let configuration = ModelConfiguration(url: url)
        let id = UUID(); let image = Data((0..<2_048).map { UInt8($0 % 251) }); let thumbnail = Data([9, 8, 7, 6])

        var legacyContainer: ModelContainer? = try ModelContainer(for: Phase1DrugSchema.Drug.self, configurations: configuration)
        legacyContainer?.mainContext.insert(Phase1DrugSchema.Drug(id: id, imageData: image, thumbnailData: thumbnail))
        try legacyContainer?.mainContext.save()
        legacyContainer = nil

        let migratedContainer = try ModelContainer(for: CurrentDrugModel.self, migrationPlan: DrugMigrationPlan.self, configurations: configuration)
        let drug = try XCTUnwrap(migratedContainer.mainContext.fetch(FetchDescriptor<CurrentDrugModel>()).first)
        XCTAssertEqual(drug.id, id); XCTAssertEqual(drug.scientificName, "Legacy medicine"); XCTAssertEqual(drug.tradeNames, ["Legacy brand"])
        XCTAssertEqual(drug.imageData, image); XCTAssertEqual(drug.thumbnailData, thumbnail); XCTAssertEqual(drug.arabicExplanation, "شرح عربي قديم")
        XCTAssertEqual(drug.notes, "Legacy notes"); XCTAssertEqual(drug.mechanism, "Legacy mechanism"); XCTAssertEqual(drug.masteryCount, 2)
        XCTAssertNil(drug.halfLifeHours); XCTAssertNil(drug.onsetMinutes); XCTAssertNil(drug.durationHours); XCTAssertNil(drug.sourceUpdatedAt)
    }
}
