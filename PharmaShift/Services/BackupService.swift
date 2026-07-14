import Foundation
import SwiftData

struct BackupRecordCounts: Codable, Equatable {
    var drugs: Int
    var reviews: Int
    var shifts: Int
    var encounters: Int
    var reports: Int
    var learningProfiles: Int
    var dailyActivities: Int

    var total: Int { drugs + reviews + shifts + encounters + reports + learningProfiles + dailyActivities }

    init(drugs: Int, reviews: Int, shifts: Int, encounters: Int, reports: Int, learningProfiles: Int = 0, dailyActivities: Int = 0) {
        self.drugs = drugs; self.reviews = reviews; self.shifts = shifts; self.encounters = encounters; self.reports = reports
        self.learningProfiles = learningProfiles; self.dailyActivities = dailyActivities
    }

    enum CodingKeys: String, CodingKey { case drugs, reviews, shifts, encounters, reports, learningProfiles, dailyActivities }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        drugs = try values.decode(Int.self, forKey: .drugs); reviews = try values.decode(Int.self, forKey: .reviews)
        shifts = try values.decode(Int.self, forKey: .shifts); encounters = try values.decode(Int.self, forKey: .encounters)
        reports = try values.decode(Int.self, forKey: .reports)
        learningProfiles = try values.decodeIfPresent(Int.self, forKey: .learningProfiles) ?? 0
        dailyActivities = try values.decodeIfPresent(Int.self, forKey: .dailyActivities) ?? 0
    }
}

struct PharmaShiftBackup: Codable {
    static let currentSchemaVersion = 4

    var schemaVersion: Int
    var exportedAt: Date
    var counts: BackupRecordCounts
    var includesImages: Bool
    var drugs: [DrugBackupDTO]
    var reviews: [ReviewBackupDTO]
    var shifts: [ShiftBackupDTO]
    var encounters: [EncounterBackupDTO]
    var reports: [TrainingReportBackupDTO]
    var learningProfiles: [LearningProfileBackupDTO]?
    var dailyActivities: [DailyActivityBackupDTO]?
    var products: [DrugProductBackupDTO]? = nil
    var relationships: [DrugRelationshipBackupDTO]? = nil
}

struct DrugBackupDTO: Codable {
    var id: UUID
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
    var imageData: Data?
    var thumbnailData: Data?
    var additionalImageData: [Data] = []
    var additionalThumbnailData: [Data] = []
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
    var routes: [String]
    var mechanism: String
    var mechanismKeywords: [String] = []
    var contraindications: [String]
    var interactions: [String]
    var toxicity: String
    var halfLifeText: String
    var halfLifeHours: Double?
    var halfLifeBandRaw: String
    var onsetText: String
    var onsetMinutes: Double?
    var onsetBandRaw: String
    var durationText: String
    var durationHours: Double?
    var durationBandRaw: String
    var dosingFrequencyRaw: String
    var timesPerDay: Int?
    var prodrugStatusRaw: String
    var excretionRouteRaw: String
    var excretionNotes: String
    var pkMemoryLineArabic: String = ""
    var renalCaution: String
    var hepaticCaution: String
    var pregnancyCaution: String
    var contraindicationSeverityRaw: String
    var toxicitySeverityRaw: String
    var warningSeverityRaw: String
    var interactionSeverityRaw: String
    var renalSeverityRaw: String
    var hepaticSeverityRaw: String
    var pregnancySeverityRaw: String
    var arabicExplanation: String
    var arabicMechanism: String
    var arabicCounseling: String
    var arabicMemoryStory: String = ""
    var arabicImportantNote: String = ""
    var arabicPersonalNotes: String
    var counselingHowToTakeArabic: String = ""
    var counselingFoodArabic: String = ""
    var patientFeelingsArabic: [String] = []
    var seekHelpArabic: [String] = []
    var missedDoseArabic: String = ""
    var seriousSideEffects: [String] = []
    var mustKnow: [String] = []
    var flashcards: [String] = []
    var oneLineSummaryArabic: String = ""
    var sourceNeedsReview: Bool = false
    var sourceMissingFields: [String] = []
    var sourceQualityNotes: String = ""
    var trustedSourceWasTruncated: Bool = false
    var sourceURL: String
    var importedSourceName: String
    var sourceUpdatedAt: Date?
    var reviewQuestionsJSON: String = ""
    var memoryItemsJSON: String = ""
    var atomicNotesJSON: String = ""
    var reviewQuestionsNeedRegeneration: Bool = false
    var canonicalIngredientKey: String?
    var activeIngredients: [String]?
    var rxNormConceptIDs: [String]?
    var doseRegimensJSON: String?
    var prodrugInfoJSON: String?
    var eliminationInfoJSON: String?
    var fieldEvidenceJSON: String?
    var lastKnowledgeRefreshAt: Date?

    init(_ drug: Drug, includesImages: Bool) {
        id = drug.id
        scientificName = drug.scientificName
        tradeNames = drug.tradeNames
        chapterRaw = drug.chapterRaw
        drugClass = drug.drugClass
        dosageForms = drug.dosageForms
        strengths = drug.strengths
        indications = drug.indications
        howToTake = drug.howToTake
        foodInstruction = drug.foodInstruction
        commonSideEffects = drug.commonSideEffects
        warnings = drug.warnings
        counselingSentence = drug.counselingSentence
        patientQuestions = drug.patientQuestions
        shelfLocation = drug.shelfLocation
        imageData = includesImages ? drug.imageData : nil
        thumbnailData = includesImages ? drug.thumbnailData : nil
        additionalImageData = includesImages ? drug.additionalImageData : []
        additionalThumbnailData = includesImages ? drug.additionalThumbnailData : []
        confidenceRaw = drug.confidenceRaw
        timesSeen = drug.timesSeen
        dateAdded = drug.dateAdded
        lastSeenDate = drug.lastSeenDate
        lastReviewed = drug.lastReviewed
        nextReviewDate = drug.nextReviewDate
        masteryScientificName = drug.masteryScientificName
        masteryTradeName = drug.masteryTradeName
        masteryClass = drug.masteryClass
        masteryUse = drug.masteryUse
        masteryWarning = drug.masteryWarning
        masteryCounseling = drug.masteryCounseling
        notes = drug.notes
        captureLabel = drug.captureLabel
        isUnknown = drug.isUnknown
        isConfusing = drug.isConfusing
        correctStreak = drug.correctStreak
        safetyFlagsRaw = drug.safetyFlagsRaw
        starterSeedID = drug.starterSeedID
        sourceNote = drug.sourceNote
        verificationRaw = drug.verificationRaw
        routes = drug.routes
        mechanism = drug.mechanism
        mechanismKeywords = drug.mechanismKeywords
        contraindications = drug.contraindications
        interactions = drug.interactions
        toxicity = drug.toxicity
        halfLifeText = drug.halfLifeText
        halfLifeHours = drug.halfLifeHours
        halfLifeBandRaw = drug.halfLifeBandRaw
        onsetText = drug.onsetText
        onsetMinutes = drug.onsetMinutes
        onsetBandRaw = drug.onsetBandRaw
        durationText = drug.durationText
        durationHours = drug.durationHours
        durationBandRaw = drug.durationBandRaw
        dosingFrequencyRaw = drug.dosingFrequencyRaw
        timesPerDay = drug.timesPerDay
        prodrugStatusRaw = drug.prodrugStatusRaw
        excretionRouteRaw = drug.excretionRouteRaw
        excretionNotes = drug.excretionNotes
        pkMemoryLineArabic = drug.pkMemoryLineArabic
        renalCaution = drug.renalCaution
        hepaticCaution = drug.hepaticCaution
        pregnancyCaution = drug.pregnancyCaution
        contraindicationSeverityRaw = drug.contraindicationSeverityRaw
        toxicitySeverityRaw = drug.toxicitySeverityRaw
        warningSeverityRaw = drug.warningSeverityRaw
        interactionSeverityRaw = drug.interactionSeverityRaw
        renalSeverityRaw = drug.renalSeverityRaw
        hepaticSeverityRaw = drug.hepaticSeverityRaw
        pregnancySeverityRaw = drug.pregnancySeverityRaw
        arabicExplanation = drug.arabicExplanation
        arabicMechanism = drug.arabicMechanism
        arabicCounseling = drug.arabicCounseling
        arabicMemoryStory = drug.arabicMemoryStory
        arabicImportantNote = drug.arabicImportantNote
        arabicPersonalNotes = drug.arabicPersonalNotes
        counselingHowToTakeArabic = drug.counselingHowToTakeArabic
        counselingFoodArabic = drug.counselingFoodArabic
        patientFeelingsArabic = drug.patientFeelingsArabic
        seekHelpArabic = drug.seekHelpArabic
        missedDoseArabic = drug.missedDoseArabic
        seriousSideEffects = drug.seriousSideEffects
        mustKnow = drug.mustKnow
        flashcards = drug.flashcards
        oneLineSummaryArabic = drug.oneLineSummaryArabic
        sourceNeedsReview = drug.sourceNeedsReview
        sourceMissingFields = drug.sourceMissingFields
        sourceQualityNotes = drug.sourceQualityNotes
        trustedSourceWasTruncated = drug.trustedSourceWasTruncated
        sourceURL = drug.sourceURL
        importedSourceName = drug.importedSourceName
        sourceUpdatedAt = drug.sourceUpdatedAt
        reviewQuestionsJSON = drug.reviewQuestionsJSON
        memoryItemsJSON = drug.memoryItemsJSON
        atomicNotesJSON = drug.atomicNotesJSON
        reviewQuestionsNeedRegeneration = drug.reviewQuestionsNeedRegeneration
        canonicalIngredientKey = drug.canonicalIngredientKey
        activeIngredients = drug.activeIngredients
        rxNormConceptIDs = drug.rxNormConceptIDs
        doseRegimensJSON = drug.doseRegimensJSON
        prodrugInfoJSON = drug.prodrugInfoJSON
        eliminationInfoJSON = drug.eliminationInfoJSON
        fieldEvidenceJSON = drug.fieldEvidenceJSON
        lastKnowledgeRefreshAt = drug.lastKnowledgeRefreshAt
    }

    func makeModel() -> Drug {
        let drug = Drug(id: id)
        apply(to: drug, includeImages: true)
        return drug
    }

    func apply(to drug: Drug, includeImages: Bool) {
        drug.scientificName = scientificName
        drug.tradeNames = tradeNames
        drug.chapterRaw = chapterRaw
        drug.drugClass = drugClass
        drug.dosageForms = dosageForms
        drug.strengths = strengths
        drug.indications = indications
        drug.howToTake = howToTake
        drug.foodInstruction = foodInstruction
        drug.commonSideEffects = commonSideEffects
        drug.warnings = warnings
        drug.counselingSentence = counselingSentence
        drug.patientQuestions = patientQuestions
        drug.shelfLocation = shelfLocation
        if includeImages {
            drug.imageData = imageData
            drug.thumbnailData = thumbnailData
            drug.additionalImageData = additionalImageData
            drug.additionalThumbnailData = additionalThumbnailData
        }
        drug.confidenceRaw = confidenceRaw
        drug.timesSeen = timesSeen
        drug.dateAdded = dateAdded
        drug.lastSeenDate = lastSeenDate
        drug.lastReviewed = lastReviewed
        drug.nextReviewDate = nextReviewDate
        drug.masteryScientificName = masteryScientificName
        drug.masteryTradeName = masteryTradeName
        drug.masteryClass = masteryClass
        drug.masteryUse = masteryUse
        drug.masteryWarning = masteryWarning
        drug.masteryCounseling = masteryCounseling
        drug.notes = notes
        drug.captureLabel = captureLabel
        drug.isUnknown = isUnknown
        drug.isConfusing = isConfusing
        drug.correctStreak = correctStreak
        drug.safetyFlagsRaw = safetyFlagsRaw
        drug.starterSeedID = starterSeedID
        drug.sourceNote = sourceNote
        drug.verificationRaw = verificationRaw
        drug.routes = routes
        drug.mechanism = mechanism
        drug.mechanismKeywords = mechanismKeywords
        drug.contraindications = contraindications
        drug.interactions = interactions
        drug.toxicity = toxicity
        drug.halfLifeText = halfLifeText
        drug.halfLifeHours = halfLifeHours
        drug.halfLifeBandRaw = halfLifeBandRaw
        drug.onsetText = onsetText
        drug.onsetMinutes = onsetMinutes
        drug.onsetBandRaw = onsetBandRaw
        drug.durationText = durationText
        drug.durationHours = durationHours
        drug.durationBandRaw = durationBandRaw
        drug.dosingFrequencyRaw = dosingFrequencyRaw
        drug.timesPerDay = timesPerDay
        drug.prodrugStatusRaw = prodrugStatusRaw
        drug.excretionRouteRaw = excretionRouteRaw
        drug.excretionNotes = excretionNotes
        drug.pkMemoryLineArabic = pkMemoryLineArabic
        drug.renalCaution = renalCaution
        drug.hepaticCaution = hepaticCaution
        drug.pregnancyCaution = pregnancyCaution
        drug.contraindicationSeverityRaw = contraindicationSeverityRaw
        drug.toxicitySeverityRaw = toxicitySeverityRaw
        drug.warningSeverityRaw = warningSeverityRaw
        drug.interactionSeverityRaw = interactionSeverityRaw
        drug.renalSeverityRaw = renalSeverityRaw
        drug.hepaticSeverityRaw = hepaticSeverityRaw
        drug.pregnancySeverityRaw = pregnancySeverityRaw
        drug.arabicExplanation = arabicExplanation
        drug.arabicMechanism = arabicMechanism
        drug.arabicCounseling = arabicCounseling
        drug.arabicMemoryStory = arabicMemoryStory
        drug.arabicImportantNote = arabicImportantNote
        drug.arabicPersonalNotes = arabicPersonalNotes
        drug.counselingHowToTakeArabic = counselingHowToTakeArabic
        drug.counselingFoodArabic = counselingFoodArabic
        drug.patientFeelingsArabic = patientFeelingsArabic
        drug.seekHelpArabic = seekHelpArabic
        drug.missedDoseArabic = missedDoseArabic
        drug.seriousSideEffects = seriousSideEffects
        drug.mustKnow = mustKnow
        drug.flashcards = flashcards
        drug.oneLineSummaryArabic = oneLineSummaryArabic
        drug.sourceNeedsReview = sourceNeedsReview
        drug.sourceMissingFields = sourceMissingFields
        drug.sourceQualityNotes = sourceQualityNotes
        drug.trustedSourceWasTruncated = trustedSourceWasTruncated
        drug.sourceURL = sourceURL
        drug.importedSourceName = importedSourceName
        drug.sourceUpdatedAt = sourceUpdatedAt
        drug.reviewQuestionsJSON = reviewQuestionsJSON
        drug.memoryItemsJSON = memoryItemsJSON
        drug.atomicNotesJSON = atomicNotesJSON
        drug.reviewQuestionsNeedRegeneration = reviewQuestionsNeedRegeneration
        drug.canonicalIngredientKey = canonicalIngredientKey ?? IngredientIdentity.canonicalKey(names: [scientificName])
        drug.activeIngredients = activeIngredients ?? [scientificName].filter { !$0.trimmed.isEmpty }
        drug.rxNormConceptIDs = rxNormConceptIDs ?? []
        drug.doseRegimensJSON = doseRegimensJSON ?? ""
        drug.prodrugInfoJSON = prodrugInfoJSON ?? ""
        drug.eliminationInfoJSON = eliminationInfoJSON ?? ""
        drug.fieldEvidenceJSON = fieldEvidenceJSON ?? ""
        drug.lastKnowledgeRefreshAt = lastKnowledgeRefreshAt
    }
}

struct DrugProductBackupDTO: Codable {
    var id: UUID
    var profileID: UUID?
    var productKey: String
    var tradeName: String
    var manufacturer: String
    var strength: String
    var dosageForm: String
    var route: String
    var country: String
    var shelfLocation: String
    var imageData: Data?
    var additionalImageData: [Data]
    var thumbnailData: Data?
    var additionalThumbnailData: [Data]
    var leafletText: String
    var leafletUpdatedAt: Date?
    var sourceName: String
    var sourceURL: String
    var dateAdded: Date

    init(_ model: DrugProduct, includesImages: Bool) {
        id = model.id; profileID = model.profile?.id; productKey = model.productKey; tradeName = model.tradeName
        manufacturer = model.manufacturer; strength = model.strength; dosageForm = model.dosageForm; route = model.route
        country = model.country; shelfLocation = model.shelfLocation
        imageData = includesImages ? model.imageData : nil; additionalImageData = includesImages ? model.additionalImageData : []
        thumbnailData = includesImages ? model.thumbnailData : nil; additionalThumbnailData = includesImages ? model.additionalThumbnailData : []
        leafletText = model.leafletText; leafletUpdatedAt = model.leafletUpdatedAt; sourceName = model.sourceName; sourceURL = model.sourceURL; dateAdded = model.dateAdded
    }

    func makeModel(profile: Drug?, includesImages: Bool) -> DrugProduct {
        DrugProduct(id: id, productKey: productKey, tradeName: tradeName, manufacturer: manufacturer, strength: strength, dosageForm: dosageForm, route: route, country: country, shelfLocation: shelfLocation, imageData: includesImages ? imageData : nil, additionalImageData: includesImages ? additionalImageData : [], thumbnailData: includesImages ? thumbnailData : nil, additionalThumbnailData: includesImages ? additionalThumbnailData : [], leafletText: leafletText, leafletUpdatedAt: leafletUpdatedAt, sourceName: sourceName, sourceURL: sourceURL, dateAdded: dateAdded, profile: profile)
    }
}

struct DrugRelationshipBackupDTO: Codable {
    var id: UUID
    var relationshipKey: String
    var kindRaw: String
    var severityRaw: String
    var summary: String
    var managementNote: String
    var sourceURLs: [String]
    var checkedAt: Date
    var sourceDrugID: UUID?
    var targetDrugID: UUID?

    init(_ model: DrugRelationship) {
        id = model.id; relationshipKey = model.relationshipKey; kindRaw = model.kindRaw; severityRaw = model.severityRaw
        summary = model.summary; managementNote = model.managementNote; sourceURLs = model.sourceURLs; checkedAt = model.checkedAt
        sourceDrugID = model.sourceDrug?.id; targetDrugID = model.targetDrug?.id
    }
}

struct ReviewBackupDTO: Codable {
    var id: UUID
    var drugID: UUID?
    var drugNameSnapshot: String
    var date: Date
    var questionTypeRaw: String
    var ratingRaw: String
    var wasCorrect: Bool
    var scoreBefore: Int
    var scoreAfter: Int
    var caseID: String?

    init(_ model: ReviewLog) {
        id = model.id; drugID = model.drug?.id; drugNameSnapshot = model.drugNameSnapshot
        date = model.date; questionTypeRaw = model.questionTypeRaw; ratingRaw = model.ratingRaw
        wasCorrect = model.wasCorrect; scoreBefore = model.scoreBefore; scoreAfter = model.scoreAfter; caseID = model.caseID
    }
}

struct ShiftBackupDTO: Codable {
    var id: UUID
    var date: Date
    var startedAt: Date
    var endedAt: Date?
    var chapterFocusRaw: String
    var newDrugsAdded: Int
    var reviewsCompleted: Int
    var pharmacistQuestions: [String]
    var whatILearned: String
    var confusingDrugs: [String]
    var notes: String
    var tomorrowReview: String
    var isCompleted: Bool

    init(_ model: ShiftLog) {
        id = model.id; date = model.date; startedAt = model.startedAt; endedAt = model.endedAt
        chapterFocusRaw = model.chapterFocusRaw; newDrugsAdded = model.newDrugsAdded; reviewsCompleted = model.reviewsCompleted
        pharmacistQuestions = model.pharmacistQuestions; whatILearned = model.whatILearned
        confusingDrugs = model.confusingDrugs; notes = model.notes; tomorrowReview = model.tomorrowReview; isCompleted = model.isCompleted
    }
}

struct EncounterBackupDTO: Codable {
    var id: UUID
    var date: Date
    var topic: String
    var relatedDrugID: UUID?
    var relatedDrugNameSnapshot: String
    var whatHappened: String
    var whatILearned: String
    var pharmacistNote: String
    var privacyConfirmed: Bool

    init(_ model: EncounterNote) {
        id = model.id; date = model.date; topic = model.topic; relatedDrugID = model.relatedDrug?.id
        relatedDrugNameSnapshot = model.relatedDrugNameSnapshot; whatHappened = model.whatHappened
        whatILearned = model.whatILearned; pharmacistNote = model.pharmacistNote; privacyConfirmed = model.privacyConfirmed
    }
}

struct TrainingReportBackupDTO: Codable {
    var id: UUID
    var periodStart: Date
    var periodEnd: Date
    var generatedAt: Date
    var updatedAt: Date
    var trainingSummary: String
    var skillsLearned: String
    var categoriesStudied: String
    var dosageFormsSeen: String
    var counselingPoints: String
    var pharmacistQuestions: String
    var challenges: String
    var notesAndRecommendations: String
    var masteredDrugs: String

    init(_ model: TrainingReport) {
        id = model.id; periodStart = model.periodStart; periodEnd = model.periodEnd
        generatedAt = model.generatedAt; updatedAt = model.updatedAt; trainingSummary = model.trainingSummary
        skillsLearned = model.skillsLearned; categoriesStudied = model.categoriesStudied
        dosageFormsSeen = model.dosageFormsSeen; counselingPoints = model.counselingPoints
        pharmacistQuestions = model.pharmacistQuestions; challenges = model.challenges
        notesAndRecommendations = model.notesAndRecommendations; masteredDrugs = model.masteredDrugs
    }
}

struct LearningProfileBackupDTO: Codable {
    var id: UUID
    var currentStreak: Int
    var longestStreak: Int
    var completedSessions: Int
    var completedQuestions: Int
    var correctAnswers: Int
    var badges: [String]
    var lastActivityDate: Date?
    var weakDrugRemindersEnabled: Bool

    init(_ model: LearningProfile) {
        id = model.id; currentStreak = model.currentStreak; longestStreak = model.longestStreak
        completedSessions = model.completedSessions; completedQuestions = model.completedQuestions; correctAnswers = model.correctAnswers
        badges = model.badges; lastActivityDate = model.lastActivityDate; weakDrugRemindersEnabled = model.weakDrugRemindersEnabled
    }
}

struct DailyActivityBackupDTO: Codable {
    var id: UUID
    var day: Date
    var sessionsCompleted: Int
    var questionsAnswered: Int
    var correctAnswers: Int
    var missionCompleted: Bool

    init(_ model: DailyActivity) {
        id = model.id; day = model.day; sessionsCompleted = model.sessionsCompleted
        questionsAnswered = model.questionsAnswered; correctAnswers = model.correctAnswers; missionCompleted = model.missionCompleted
    }
}

enum BackupRestoreMode: Equatable { case merge, replace }

struct BackupRestoreSummary: Equatable {
    var counts: BackupRecordCounts
    var mode: BackupRestoreMode
}

enum BackupError: LocalizedError, Equatable {
    case malformed
    case newerVersion(Int)
    case invalidCounts
    case duplicateIdentifiers

    var errorDescription: String? {
        switch self {
        case .malformed: "This file is not a valid Renlyst backup."
        case .newerVersion(let version): "This backup uses schema version \(version), which is newer than this app supports."
        case .invalidCounts: "The backup record counts do not match its contents."
        case .duplicateIdentifiers: "The backup contains duplicate record identifiers."
        }
    }
}

@MainActor
enum BackupService {
    static func makeBackup(context: ModelContext, includesImages: Bool, exportedAt: Date = .now) throws -> PharmaShiftBackup {
        let drugs = try context.fetch(FetchDescriptor<Drug>()).map { DrugBackupDTO($0, includesImages: includesImages) }
        let reviews = try context.fetch(FetchDescriptor<ReviewLog>()).map(ReviewBackupDTO.init)
        let shifts = try context.fetch(FetchDescriptor<ShiftLog>()).map(ShiftBackupDTO.init)
        let encounters = try context.fetch(FetchDescriptor<EncounterNote>()).map(EncounterBackupDTO.init)
        let reports = try context.fetch(FetchDescriptor<TrainingReport>()).map(TrainingReportBackupDTO.init)
        let profiles = try context.fetch(FetchDescriptor<LearningProfile>()).map(LearningProfileBackupDTO.init)
        let activities = try context.fetch(FetchDescriptor<DailyActivity>()).map(DailyActivityBackupDTO.init)
        let products = try context.fetch(FetchDescriptor<DrugProduct>()).map { DrugProductBackupDTO($0, includesImages: includesImages) }
        let relationships = try context.fetch(FetchDescriptor<DrugRelationship>()).map(DrugRelationshipBackupDTO.init)
        return PharmaShiftBackup(
            schemaVersion: PharmaShiftBackup.currentSchemaVersion,
            exportedAt: exportedAt,
            counts: .init(drugs: drugs.count, reviews: reviews.count, shifts: shifts.count, encounters: encounters.count, reports: reports.count, learningProfiles: profiles.count, dailyActivities: activities.count),
            includesImages: includesImages,
            drugs: drugs, reviews: reviews, shifts: shifts, encounters: encounters, reports: reports,
            learningProfiles: profiles, dailyActivities: activities, products: products, relationships: relationships
        )
    }

    static func encode(_ backup: PharmaShiftBackup) throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
        encoder.dateEncodingStrategy = .iso8601
        return try encoder.encode(backup)
    }

    static func decode(_ data: Data) throws -> PharmaShiftBackup {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        guard let backup = try? decoder.decode(PharmaShiftBackup.self, from: data) else { throw BackupError.malformed }
        try validate(backup)
        return backup
    }

    static func validate(_ backup: PharmaShiftBackup) throws {
        guard backup.schemaVersion <= PharmaShiftBackup.currentSchemaVersion else { throw BackupError.newerVersion(backup.schemaVersion) }
        let actual = BackupRecordCounts(drugs: backup.drugs.count, reviews: backup.reviews.count, shifts: backup.shifts.count, encounters: backup.encounters.count, reports: backup.reports.count, learningProfiles: backup.learningProfiles?.count ?? 0, dailyActivities: backup.dailyActivities?.count ?? 0)
        guard backup.counts == actual else { throw BackupError.invalidCounts }
        let groups: [[UUID]] = [backup.drugs.map(\.id), backup.reviews.map(\.id), backup.shifts.map(\.id), backup.encounters.map(\.id), backup.reports.map(\.id), backup.learningProfiles?.map(\.id) ?? [], backup.dailyActivities?.map(\.id) ?? []]
        guard groups.allSatisfy({ Set($0).count == $0.count }) else { throw BackupError.duplicateIdentifiers }
        guard Set((backup.products ?? []).map(\.id)).count == (backup.products ?? []).count,
              Set((backup.relationships ?? []).map(\.id)).count == (backup.relationships ?? []).count else { throw BackupError.duplicateIdentifiers }
    }

    static func restore(_ backup: PharmaShiftBackup, mode: BackupRestoreMode, context: ModelContext) throws -> BackupRestoreSummary {
        try validate(backup)
        do {
            if mode == .replace { try deleteAll(context: context) }
            var drugsByID = Dictionary(uniqueKeysWithValues: try context.fetch(FetchDescriptor<Drug>()).map { ($0.id, $0) })
            for dto in backup.drugs {
                let model = drugsByID[dto.id] ?? dto.makeModel()
                dto.apply(to: model, includeImages: backup.includesImages || mode == .replace)
                if drugsByID[dto.id] == nil { context.insert(model); drugsByID[dto.id] = model }
            }

            var productsByID = Dictionary(uniqueKeysWithValues: try context.fetch(FetchDescriptor<DrugProduct>()).map { ($0.id, $0) })
            for dto in backup.products ?? [] where productsByID[dto.id] == nil {
                let model = dto.makeModel(profile: dto.profileID.flatMap { drugsByID[$0] }, includesImages: backup.includesImages || mode == .replace)
                context.insert(model); productsByID[dto.id] = model
            }

            var relationshipsByID = Dictionary(uniqueKeysWithValues: try context.fetch(FetchDescriptor<DrugRelationship>()).map { ($0.id, $0) })
            for dto in backup.relationships ?? [] {
                let model = relationshipsByID[dto.id] ?? DrugRelationship(id: dto.id, relationshipKey: dto.relationshipKey, kind: DrugRelationshipKind(rawValue: dto.kindRaw) ?? .interaction, severity: SafetySeverity(rawValue: dto.severityRaw) ?? .unknown, summary: dto.summary)
                model.relationshipKey = dto.relationshipKey; model.kindRaw = dto.kindRaw; model.severityRaw = dto.severityRaw; model.summary = dto.summary
                model.managementNote = dto.managementNote; model.sourceURLs = dto.sourceURLs; model.checkedAt = dto.checkedAt
                model.sourceDrug = dto.sourceDrugID.flatMap { drugsByID[$0] }; model.targetDrug = dto.targetDrugID.flatMap { drugsByID[$0] }
                if relationshipsByID[dto.id] == nil { context.insert(model); relationshipsByID[dto.id] = model }
            }

            var reviewsByID = Dictionary(uniqueKeysWithValues: try context.fetch(FetchDescriptor<ReviewLog>()).map { ($0.id, $0) })
            for dto in backup.reviews {
                let model = reviewsByID[dto.id] ?? ReviewLog(id: dto.id, drug: nil, drugNameSnapshot: dto.drugNameSnapshot, date: dto.date, questionType: QuestionType(rawValue: dto.questionTypeRaw) ?? .scientificName, rating: ReviewRating(rawValue: dto.ratingRaw) ?? .wrong, scoreBefore: dto.scoreBefore, scoreAfter: dto.scoreAfter, caseID: dto.caseID)
                model.drug = dto.drugID.flatMap { drugsByID[$0] }; model.drugNameSnapshot = dto.drugNameSnapshot
                model.date = dto.date; model.questionTypeRaw = dto.questionTypeRaw; model.ratingRaw = dto.ratingRaw
                model.wasCorrect = dto.wasCorrect; model.scoreBefore = dto.scoreBefore; model.scoreAfter = dto.scoreAfter; model.caseID = dto.caseID
                if reviewsByID[dto.id] == nil { context.insert(model); reviewsByID[dto.id] = model }
            }

            var shiftsByID = Dictionary(uniqueKeysWithValues: try context.fetch(FetchDescriptor<ShiftLog>()).map { ($0.id, $0) })
            for dto in backup.shifts {
                let model = shiftsByID[dto.id] ?? ShiftLog(id: dto.id, date: dto.date, chapterFocus: Chapter(rawValue: dto.chapterFocusRaw) ?? .other)
                model.date = dto.date; model.startedAt = dto.startedAt; model.endedAt = dto.endedAt
                model.chapterFocusRaw = dto.chapterFocusRaw; model.newDrugsAdded = dto.newDrugsAdded; model.reviewsCompleted = dto.reviewsCompleted
                model.pharmacistQuestions = dto.pharmacistQuestions; model.whatILearned = dto.whatILearned
                model.confusingDrugs = dto.confusingDrugs; model.notes = dto.notes; model.tomorrowReview = dto.tomorrowReview; model.isCompleted = dto.isCompleted
                if shiftsByID[dto.id] == nil { context.insert(model); shiftsByID[dto.id] = model }
            }

            var encountersByID = Dictionary(uniqueKeysWithValues: try context.fetch(FetchDescriptor<EncounterNote>()).map { ($0.id, $0) })
            for dto in backup.encounters {
                let model = encountersByID[dto.id] ?? EncounterNote(id: dto.id, date: dto.date)
                model.date = dto.date; model.topic = dto.topic; model.relatedDrug = dto.relatedDrugID.flatMap { drugsByID[$0] }
                model.relatedDrugNameSnapshot = dto.relatedDrugNameSnapshot; model.whatHappened = dto.whatHappened
                model.whatILearned = dto.whatILearned; model.pharmacistNote = dto.pharmacistNote; model.privacyConfirmed = dto.privacyConfirmed
                if encountersByID[dto.id] == nil { context.insert(model); encountersByID[dto.id] = model }
            }

            var reportsByID = Dictionary(uniqueKeysWithValues: try context.fetch(FetchDescriptor<TrainingReport>()).map { ($0.id, $0) })
            for dto in backup.reports {
                let model = reportsByID[dto.id] ?? TrainingReport(id: dto.id, periodStart: dto.periodStart, periodEnd: dto.periodEnd)
                model.periodStart = dto.periodStart; model.periodEnd = dto.periodEnd; model.generatedAt = dto.generatedAt; model.updatedAt = dto.updatedAt
                model.trainingSummary = dto.trainingSummary; model.skillsLearned = dto.skillsLearned; model.categoriesStudied = dto.categoriesStudied
                model.dosageFormsSeen = dto.dosageFormsSeen; model.counselingPoints = dto.counselingPoints
                model.pharmacistQuestions = dto.pharmacistQuestions; model.challenges = dto.challenges
                model.notesAndRecommendations = dto.notesAndRecommendations; model.masteredDrugs = dto.masteredDrugs
                if reportsByID[dto.id] == nil { context.insert(model); reportsByID[dto.id] = model }
            }

            var profilesByID = Dictionary(uniqueKeysWithValues: try context.fetch(FetchDescriptor<LearningProfile>()).map { ($0.id, $0) })
            for dto in backup.learningProfiles ?? [] {
                let model = profilesByID[dto.id] ?? LearningProfile(id: dto.id)
                model.currentStreak = dto.currentStreak; model.longestStreak = dto.longestStreak
                model.completedSessions = dto.completedSessions; model.completedQuestions = dto.completedQuestions; model.correctAnswers = dto.correctAnswers
                model.badges = dto.badges; model.lastActivityDate = dto.lastActivityDate; model.weakDrugRemindersEnabled = dto.weakDrugRemindersEnabled
                if profilesByID[dto.id] == nil { context.insert(model); profilesByID[dto.id] = model }
            }
            var activitiesByID = Dictionary(uniqueKeysWithValues: try context.fetch(FetchDescriptor<DailyActivity>()).map { ($0.id, $0) })
            for dto in backup.dailyActivities ?? [] {
                let model = activitiesByID[dto.id] ?? DailyActivity(id: dto.id, day: dto.day)
                model.day = dto.day; model.sessionsCompleted = dto.sessionsCompleted; model.questionsAnswered = dto.questionsAnswered
                model.correctAnswers = dto.correctAnswers; model.missionCompleted = dto.missionCompleted
                if activitiesByID[dto.id] == nil { context.insert(model); activitiesByID[dto.id] = model }
            }
            try context.save()
            return BackupRestoreSummary(counts: backup.counts, mode: mode)
        } catch {
            context.rollback()
            throw error
        }
    }

    static func drugCSV(context: ModelContext) throws -> Data {
        let header = ["id", "scientific_name", "trade_names", "chapter", "class", "dosage_forms", "strengths", "indications", "warnings", "notes", "arabic_explanation"]
        let rows = try context.fetch(FetchDescriptor<Drug>()).map { drug in
            [drug.id.uuidString, drug.scientificName, drug.tradeNames.joined(separator: " | "), drug.chapterRaw, drug.drugClass,
             drug.dosageForms.joined(separator: " | "), drug.strengths.joined(separator: " | "), drug.indications.joined(separator: " | "),
             drug.warnings.joined(separator: " | "), drug.notes, drug.arabicExplanation].map(csvEscape).joined(separator: ",")
        }
        return Data(([header.joined(separator: ",")] + rows).joined(separator: "\r\n").utf8)
    }

    static func trainingReportText(context: ModelContext) throws -> Data {
        let reports = try context.fetch(FetchDescriptor<TrainingReport>()).sorted { $0.periodStart < $1.periodStart }
        let text = reports.map { report in
            """
            Renlyst Training Report
            Period: \(report.periodStart.formatted(date: .abbreviated, time: .omitted)) – \(report.periodEnd.formatted(date: .abbreviated, time: .omitted))

            Training summary
            \(report.trainingSummary)

            Skills learned
            \(report.skillsLearned)

            Categories studied
            \(report.categoriesStudied)

            Dosage forms seen
            \(report.dosageFormsSeen)

            Counseling points
            \(report.counselingPoints)

            Pharmacist questions
            \(report.pharmacistQuestions)

            Challenges
            \(report.challenges)

            Notes and recommendations
            \(report.notesAndRecommendations)

            Mastered drugs
            \(report.masteredDrugs)
            """
        }.joined(separator: "\n\n— — —\n\n")
        return Data(text.utf8)
    }

    private static func deleteAll(context: ModelContext) throws {
        for model in try context.fetch(FetchDescriptor<DrugRelationship>()) { context.delete(model) }
        for model in try context.fetch(FetchDescriptor<DrugProduct>()) { context.delete(model) }
        for model in try context.fetch(FetchDescriptor<ReviewLog>()) { context.delete(model) }
        for model in try context.fetch(FetchDescriptor<EncounterNote>()) { context.delete(model) }
        for model in try context.fetch(FetchDescriptor<ShiftLog>()) { context.delete(model) }
        for model in try context.fetch(FetchDescriptor<TrainingReport>()) { context.delete(model) }
        for model in try context.fetch(FetchDescriptor<LearningProfile>()) { context.delete(model) }
        for model in try context.fetch(FetchDescriptor<DailyActivity>()) { context.delete(model) }
        for model in try context.fetch(FetchDescriptor<Drug>()) { context.delete(model) }
    }

    private static func csvEscape(_ value: String) -> String {
        "\"\(value.replacingOccurrences(of: "\"", with: "\"\""))\""
    }
}
