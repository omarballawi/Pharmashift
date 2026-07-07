import Foundation
import SwiftData

enum Chapter: String, Codable, CaseIterable, Identifiable {
    case cardiovascular = "Cardiovascular"
    case respiratory = "Respiratory"
    case endocrine = "Endocrine"
    case musculoskeletal = "Musculoskeletal"
    case eye = "Eye"
    case earNoseOropharynx = "Ear/Nose/Oropharynx"
    case gastrointestinal = "Gastrointestinal"
    case dermatology = "Dermatology"
    case antibiotics = "Antibiotics"
    case otc = "OTC"
    case other = "Other"

    var id: String { rawValue }

    var quickClasses: [String] {
        switch self {
        case .cardiovascular:
            ["ACE inhibitors", "ARBs", "Beta blockers", "Calcium channel blockers", "Diuretics", "Statins", "Nitrates", "Antiplatelets", "Anticoagulants", "Antiarrhythmics"]
        case .respiratory:
            ["SABA", "LABA", "Inhaled corticosteroids", "Antimuscarinics", "Leukotriene receptor antagonists", "Methylxanthines", "Antihistamines", "Cough suppressants", "Expectorants/mucolytics", "Decongestants"]
        case .endocrine:
            ["Biguanides", "Sulfonylureas", "DPP-4 inhibitors", "SGLT2 inhibitors", "Insulins", "GLP-1 agonists", "Thyroid hormones", "Antithyroid drugs", "Corticosteroids", "Bisphosphonates", "Sex hormones"]
        default:
            []
        }
    }
}

enum ConfidenceLevel: String, Codable, CaseIterable, Identifiable {
    case weak = "Weak"
    case medium = "Medium"
    case strong = "Strong"
    case mastered = "Mastered"

    var id: String { rawValue }
}

enum SafetyFlag: String, Codable, CaseIterable, Identifiable {
    case anticoagulant = "Anticoagulant / antiplatelet"
    case insulin = "Insulin"
    case corticosteroid = "Corticosteroid"
    case pregnancy = "Pregnancy"
    case children = "Children"
    case controlledDrug = "Controlled drug"
    case severeSymptoms = "Severe symptoms"

    var id: String { rawValue }
}

enum VerificationStatus: String, Codable {
    case personal = "Personal entry"
    case pendingPharmacist = "Needs pharmacist verification"
    case pharmacistVerified = "Pharmacist verified"
}

enum QuestionType: String, Codable, CaseIterable, Identifiable {
    case scientificName = "Scientific name"
    case tradeName = "Trade name"
    case drugClass = "Class"
    case use = "Use"
    case warning = "Warning"
    case counseling = "Counseling"
    case casePractice = "Case practice"

    var id: String { rawValue }
}

enum ReviewRating: String, Codable, CaseIterable, Identifiable {
    case correct = "Correct"
    case partlyCorrect = "Partly correct"
    case wrong = "Wrong"

    var id: String { rawValue }
}

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

    init(
        id: UUID = UUID(),
        scientificName: String = "",
        tradeNames: [String] = [],
        chapter: Chapter = .other,
        drugClass: String = "",
        dosageForms: [String] = [],
        strengths: [String] = [],
        indications: [String] = [],
        howToTake: String = "",
        foodInstruction: String = "",
        commonSideEffects: [String] = [],
        warnings: [String] = [],
        counselingSentence: String = "",
        patientQuestions: [String] = [],
        shelfLocation: String = "",
        imageData: Data? = nil,
        timesSeen: Int = 1,
        dateAdded: Date = .now,
        lastSeenDate: Date? = .now,
        nextReviewDate: Date = .now,
        notes: String = "",
        captureLabel: String = "",
        isUnknown: Bool = false,
        isConfusing: Bool = false,
        safetyFlags: [SafetyFlag] = [],
        starterSeedID: String? = nil,
        sourceNote: String = "",
        verificationStatus: VerificationStatus = .personal
    ) {
        self.id = id
        self.scientificName = scientificName
        self.tradeNames = tradeNames
        self.chapterRaw = chapter.rawValue
        self.drugClass = drugClass
        self.dosageForms = dosageForms
        self.strengths = strengths
        self.indications = indications
        self.howToTake = howToTake
        self.foodInstruction = foodInstruction
        self.commonSideEffects = commonSideEffects
        self.warnings = warnings
        self.counselingSentence = counselingSentence
        self.patientQuestions = patientQuestions
        self.shelfLocation = shelfLocation
        self.imageData = imageData
        self.confidenceRaw = ConfidenceLevel.weak.rawValue
        self.timesSeen = timesSeen
        self.dateAdded = dateAdded
        self.lastSeenDate = lastSeenDate
        self.lastReviewed = nil
        self.nextReviewDate = nextReviewDate
        self.masteryScientificName = false
        self.masteryTradeName = false
        self.masteryClass = false
        self.masteryUse = false
        self.masteryWarning = false
        self.masteryCounseling = false
        self.notes = notes
        self.captureLabel = captureLabel
        self.isUnknown = isUnknown
        self.isConfusing = isConfusing
        self.correctStreak = 0
        self.safetyFlagsRaw = safetyFlags.map(\.rawValue)
        self.starterSeedID = starterSeedID
        self.sourceNote = sourceNote
        self.verificationRaw = verificationStatus.rawValue
    }

    var chapter: Chapter {
        get { Chapter(rawValue: chapterRaw) ?? .other }
        set { chapterRaw = newValue.rawValue }
    }

    var confidenceLevel: ConfidenceLevel {
        get { ConfidenceLevel(rawValue: confidenceRaw) ?? .weak }
        set { confidenceRaw = newValue.rawValue }
    }

    var safetyFlags: [SafetyFlag] {
        get { safetyFlagsRaw.compactMap(SafetyFlag.init(rawValue:)) }
        set { safetyFlagsRaw = newValue.map(\.rawValue) }
    }

    var verificationStatus: VerificationStatus {
        get { VerificationStatus(rawValue: verificationRaw) ?? .personal }
        set { verificationRaw = newValue.rawValue }
    }

    var displayName: String {
        if !scientificName.trimmed.isEmpty { return scientificName.trimmed }
        if let tradeName = tradeNames.first, !tradeName.trimmed.isEmpty { return tradeName.trimmed }
        return captureLabel.trimmed.isEmpty ? "Unknown drug" : captureLabel.trimmed
    }

    var firstTradeName: String { tradeNames.first ?? "No trade name yet" }

    var masteryCount: Int {
        [masteryScientificName, masteryTradeName, masteryClass, masteryUse, masteryWarning, masteryCounseling]
            .filter { $0 }.count
    }

    var isMastered: Bool { masteryCount == 6 }

    func recalculateConfidence() {
        confidenceLevel = switch masteryCount {
        case 6: .mastered
        case 4...5: .strong
        case 2...3: .medium
        default: .weak
        }
    }

    func setMastery(for questionType: QuestionType, value: Bool) {
        switch questionType {
        case .scientificName: masteryScientificName = value
        case .tradeName: masteryTradeName = value
        case .drugClass: masteryClass = value
        case .use: masteryUse = value
        case .warning: masteryWarning = value
        case .counseling: masteryCounseling = value
        case .casePractice: break
        }
        recalculateConfidence()
    }

    func markSeen(on date: Date = .now, calendar: Calendar = .current) {
        guard lastSeenDate.map({ !calendar.isDate($0, inSameDayAs: date) }) ?? true else { return }
        timesSeen += 1
        lastSeenDate = date
    }
}

@Model
final class ReviewLog {
    @Attribute(.unique) var id: UUID
    var drug: Drug?
    var drugNameSnapshot: String
    var date: Date
    var questionTypeRaw: String
    var ratingRaw: String
    var wasCorrect: Bool
    var scoreBefore: Int
    var scoreAfter: Int
    var caseID: String?

    init(drug: Drug?, drugNameSnapshot: String, date: Date = .now, questionType: QuestionType, rating: ReviewRating, scoreBefore: Int, scoreAfter: Int, caseID: String? = nil) {
        self.id = UUID()
        self.drug = drug
        self.drugNameSnapshot = drugNameSnapshot
        self.date = date
        self.questionTypeRaw = questionType.rawValue
        self.ratingRaw = rating.rawValue
        self.wasCorrect = rating == .correct
        self.scoreBefore = scoreBefore
        self.scoreAfter = scoreAfter
        self.caseID = caseID
    }

    var questionType: QuestionType { QuestionType(rawValue: questionTypeRaw) ?? .scientificName }
    var rating: ReviewRating { ReviewRating(rawValue: ratingRaw) ?? .wrong }
}

@Model
final class ShiftLog {
    @Attribute(.unique) var id: UUID
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

    init(date: Date = .now, chapterFocus: Chapter = .other) {
        self.id = UUID()
        self.date = date
        self.startedAt = date
        self.endedAt = nil
        self.chapterFocusRaw = chapterFocus.rawValue
        self.newDrugsAdded = 0
        self.reviewsCompleted = 0
        self.pharmacistQuestions = []
        self.whatILearned = ""
        self.confusingDrugs = []
        self.notes = ""
        self.tomorrowReview = ""
        self.isCompleted = false
    }

    var chapterFocus: Chapter {
        get { Chapter(rawValue: chapterFocusRaw) ?? .other }
        set { chapterFocusRaw = newValue.rawValue }
    }

    func finish(at date: Date = .now) {
        endedAt = date
        isCompleted = true
    }
}

@Model
final class EncounterNote {
    @Attribute(.unique) var id: UUID
    var date: Date
    var topic: String
    var relatedDrug: Drug?
    var relatedDrugNameSnapshot: String
    var whatHappened: String
    var whatILearned: String
    var pharmacistNote: String
    var privacyConfirmed: Bool

    init(date: Date = .now, topic: String = "", relatedDrug: Drug? = nil, whatHappened: String = "", whatILearned: String = "", pharmacistNote: String = "", privacyConfirmed: Bool = false) {
        self.id = UUID()
        self.date = date
        self.topic = topic
        self.relatedDrug = relatedDrug
        self.relatedDrugNameSnapshot = relatedDrug?.displayName ?? ""
        self.whatHappened = whatHappened
        self.whatILearned = whatILearned
        self.pharmacistNote = pharmacistNote
        self.privacyConfirmed = privacyConfirmed
    }

    var combinedText: String { [topic, whatHappened, whatILearned, pharmacistNote].joined(separator: " ") }
}

@Model
final class TrainingReport {
    @Attribute(.unique) var id: UUID
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

    init(periodStart: Date, periodEnd: Date) {
        self.id = UUID()
        self.periodStart = periodStart
        self.periodEnd = periodEnd
        self.generatedAt = .now
        self.updatedAt = .now
        self.trainingSummary = ""
        self.skillsLearned = ""
        self.categoriesStudied = ""
        self.dosageFormsSeen = ""
        self.counselingPoints = ""
        self.pharmacistQuestions = ""
        self.challenges = ""
        self.notesAndRecommendations = ""
        self.masteredDrugs = ""
    }
}

extension String {
    var trimmed: String { trimmingCharacters(in: .whitespacesAndNewlines) }

    var splitLines: [String] {
        components(separatedBy: .newlines).map(\.trimmed).filter { !$0.isEmpty }
    }
}
