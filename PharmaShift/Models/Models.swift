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
    case vitaminsSupplements = "Vitamins/Supplements"
    case other = "Other"

    var id: String { rawValue }

    var arabicName: String {
        switch self {
        case .cardiovascular: "القلب والأوعية الدموية"
        case .respiratory: "الجهاز التنفسي"
        case .endocrine: "جهاز الغدد الصماء"
        case .musculoskeletal: "العضلات والمفاصل"
        case .eye: "العين"
        case .earNoseOropharynx: "الأذن والأنف والبلعوم"
        case .gastrointestinal: "الجهاز الهضمي"
        case .dermatology: "الأمراض الجلدية"
        case .antibiotics: "المضادات الحيوية"
        case .otc: "أدوية بدون وصفة"
        case .vitaminsSupplements: "الفيتامينات والمكملات"
        case .other: "أخرى"
        }
    }

    var icon: String {
        switch self {
        case .cardiovascular: "heart.fill"
        case .respiratory: "lungs.fill"
        case .endocrine: "drop.fill"
        case .musculoskeletal: "figure.strengthtraining.traditional"
        case .eye: "eye.fill"
        case .earNoseOropharynx: "ear.fill"
        case .gastrointestinal: "cross.vial.fill"
        case .dermatology: "allergens.fill"
        case .antibiotics: "shield.lefthalf.filled"
        case .otc: "basket.fill"
        case .vitaminsSupplements: "leaf.fill"
        case .other: "square.grid.2x2.fill"
        }
    }

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

enum HalfLifeBand: String, Codable, CaseIterable, Identifiable {
    case unknown = "Unknown", short = "Short", medium = "Medium", long = "Long", veryLong = "Very long"
    var id: String { rawValue }
}

enum OnsetBand: String, Codable, CaseIterable, Identifiable {
    case unknown = "Unknown", fast = "Fast", moderate = "Moderate", slow = "Slow"
    var id: String { rawValue }
}

enum DurationBand: String, Codable, CaseIterable, Identifiable {
    case unknown = "Unknown", short = "Short", medium = "Medium", long = "Long"
    var id: String { rawValue }
}

enum DosingFrequency: String, Codable, CaseIterable, Identifiable {
    case unknown = "Unknown", onceDaily = "Once daily", twiceDaily = "Twice daily"
    case threeTimesDaily = "Three times daily", fourTimesDaily = "Four times daily", asNeeded = "PRN", other = "Other"
    var id: String { rawValue }
}

enum ProdrugStatus: String, Codable, CaseIterable, Identifiable {
    case unknown = "Unknown", active = "Active", prodrug = "Prodrug"
    var id: String { rawValue }
}

enum ExcretionRoute: String, Codable, CaseIterable, Identifiable {
    case unknown = "Unknown", renal = "Renal", hepatic = "Hepatic", mixed = "Mixed"
    var id: String { rawValue }
}

enum SafetySeverity: String, Codable, CaseIterable, Identifiable {
    case unknown = "Unknown", low = "Low", medium = "Medium", high = "High"
    var id: String { rawValue }
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

enum MemoryReviewGrade: String, CaseIterable, Identifiable {
    case again = "Again"
    case hard = "Hard"
    case good = "Good"
    case easy = "Easy"
    var id: String { rawValue }
}

enum PracticeInteraction: String, Codable {
    case multipleChoice
    case trueFalse
    case textEntry
    case recall
}

struct PracticeQuestion: Identifiable, Codable, Equatable {
    var id: UUID
    var drugID: UUID?
    var drugName: String
    var prompt: String
    var correctAnswer: String
    var choices: [String]
    var explanation: String?
    var questionType: QuestionType
    var interaction: PracticeInteraction
    var imageData: Data?
    var caseID: String?

    init(id: UUID = UUID(), drugID: UUID?, drugName: String, prompt: String, correctAnswer: String, choices: [String] = [], explanation: String? = nil, questionType: QuestionType, interaction: PracticeInteraction, imageData: Data? = nil, caseID: String? = nil) {
        self.id = id; self.drugID = drugID; self.drugName = drugName; self.prompt = prompt
        self.correctAnswer = correctAnswer; self.choices = choices; self.explanation = explanation
        self.questionType = questionType; self.interaction = interaction; self.imageData = imageData; self.caseID = caseID
    }
}

struct GeneratedReviewQuestion: Identifiable, Codable, Equatable, Sendable {
    var id: UUID
    var prompt: String
    var choices: [String]
    var correctAnswer: String
    var explanation: String
    var questionTypeRaw: String
    var interactionRaw: String
    var relatedField: String
    var difficulty: String

    init(
        id: UUID = UUID(),
        prompt: String,
        choices: [String],
        correctAnswer: String,
        explanation: String,
        questionType: QuestionType,
        interaction: PracticeInteraction = .multipleChoice,
        relatedField: String = "",
        difficulty: String = "medium"
    ) {
        self.id = id
        self.prompt = prompt
        self.choices = choices
        self.correctAnswer = correctAnswer
        self.explanation = explanation
        self.questionTypeRaw = questionType.rawValue
        self.interactionRaw = interaction.rawValue
        self.relatedField = relatedField
        self.difficulty = difficulty
    }

    var questionType: QuestionType { QuestionType(rawValue: questionTypeRaw) ?? .use }
    var interaction: PracticeInteraction { PracticeInteraction(rawValue: interactionRaw) ?? .multipleChoice }
}

struct MemoryItemState: Identifiable, Codable, Equatable, Sendable {
    var id: UUID = UUID()
    var fieldRaw: String
    var difficulty: Double = 5
    var stabilityDays: Double = 0.5
    var retrievability: Double = 1
    var dueDate: Date = .now
    var lastReviewed: Date?
    var repetitions: Int = 0
    var lapses: Int = 0

    var field: QuestionType { QuestionType(rawValue: fieldRaw) ?? .use }
    var strengthLabel: String {
        if repetitions == 0 { return "New" }
        if retrievability < 0.55 { return "Weak" }
        if stabilityDays < 7 { return "Medium" }
        return "Strong"
    }
}

enum AtomicNoteKind: String, Codable, CaseIterable, Identifiable, Sendable {
    case memoryTrick = "Memory trick"
    case patientCounseling = "Patient counseling"
    case shelfObservation = "Shelf observation"
    case confusingPoint = "Confusing point"
    case sourceCorrection = "Source correction"
    var id: String { rawValue }
}

struct AtomicDrugNote: Identifiable, Codable, Equatable, Sendable {
    var id: UUID = UUID()
    var createdAt: Date = .now
    var kindRaw: String
    var text: String
    var linkedField: String = "General"
    var context: String = ""
    var kind: AtomicNoteKind { AtomicNoteKind(rawValue: kindRaw) ?? .confusingPoint }
}

struct PracticeAnswer: Identifiable, Codable, Equatable {
    var id: UUID
    var questionID: UUID
    var response: String
    var rating: ReviewRating
    var isCorrect: Bool

    init(id: UUID = UUID(), questionID: UUID, response: String, rating: ReviewRating) {
        self.id = id; self.questionID = questionID; self.response = response; self.rating = rating; self.isCorrect = rating == .correct
    }
}

struct PracticeSessionResult: Identifiable, Codable, Equatable {
    var id: UUID
    var completedAt: Date
    var modeRaw: String
    var answers: [PracticeAnswer]
    var questionCount: Int
    var correctCount: Int

    init(id: UUID = UUID(), completedAt: Date = .now, modeRaw: String, answers: [PracticeAnswer]) {
        self.id = id; self.completedAt = completedAt; self.modeRaw = modeRaw; self.answers = answers
        self.questionCount = answers.count; self.correctCount = answers.filter(\.isCorrect).count
    }
}

enum PatientSexAtBirth: String, Codable, CaseIterable, Identifiable, Sendable {
    case female = "Female"
    case male = "Male"

    var id: String { rawValue }
}

enum DosePopulation: String, Codable, CaseIterable, Identifiable, Sendable {
    case adult = "Adult"
    case pediatric = "Child"
    case geriatric = "Older adult"
    case special = "Special population"

    var id: String { rawValue }
}

enum DoseFormulaKind: String, Codable, CaseIterable, Identifiable, Sendable {
    case fixed = "Fixed dose"
    case mgPerKgPerDose = "mg/kg/dose"
    case mgPerKgPerDay = "mg/kg/day"
    case mgPerSquareMeter = "mg/m²"

    var id: String { rawValue }
}

struct IngredientComponent: Identifiable, Codable, Equatable, Hashable, Sendable {
    var name: String
    var saltForm: String = ""
    var strengthValue: Double? = nil
    var strengthUnit: String = ""
    var displayStrength: String = ""

    var id: String {
        [name, saltForm, displayStrength, strengthValue?.description ?? "", strengthUnit]
            .map(IngredientIdentity.normalize)
            .joined(separator: "|")
    }

    var strengthText: String {
        if !displayStrength.trimmed.isEmpty { return displayStrength.trimmed }
        guard let strengthValue else { return "" }
        return [strengthValue.formatted(.number.precision(.fractionLength(0...3))), strengthUnit.trimmed]
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }
}

struct FormStrength: Identifiable, Codable, Equatable, Hashable, Sendable {
    var strength: String
    var tradeNames: [String] = []
    var id: String { IngredientIdentity.normalize(strength + "|" + tradeNames.joined(separator: "|")) }
}

struct DosageFormGroup: Identifiable, Codable, Equatable, Hashable, Sendable {
    var dosageForm: String
    var strengths: [FormStrength]
    var id: String { IngredientIdentity.normalize(dosageForm) }
}

struct ClinicalDoseEntry: Identifiable, Codable, Equatable, Hashable, Sendable {
    var indication: String
    var population: String
    var doseText: String
    var route: String = ""
    var frequency: String = ""
    var duration: String = ""
    var adjuncts: [String] = []
    var considerations: [String] = []
    var sourceIDs: [String] = []
    var id: String {
        [indication, population, doseText, route, frequency]
            .map(IngredientIdentity.normalize)
            .joined(separator: "|")
    }
}

enum InteractionCategory: String, Codable, CaseIterable, Identifiable, Sendable {
    case contraindicated = "Contraindicated"
    case seriousUseAlternative = "Serious - Use Alternative"
    case monitorClosely = "Monitor Closely"
    case minor = "Minor"
    case unknown = "Uncategorized"
    var id: String { rawValue }

    init(from decoder: Decoder) throws {
        let value = (try? decoder.singleValueContainer().decode(String.self)) ?? ""
        let normalized = IngredientIdentity.normalize(value)
        if normalized.contains("contraindicated") { self = .contraindicated }
        else if normalized.contains("serious") || normalized.contains("alternative") { self = .seriousUseAlternative }
        else if normalized.contains("monitor") { self = .monitorClosely }
        else if normalized.contains("minor") { self = .minor }
        else { self = .unknown }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}

struct DrugInteractionEntry: Identifiable, Codable, Equatable, Hashable, Sendable {
    var drugName: String
    var category: InteractionCategory
    var effect: String = ""
    var management: String = ""
    var sourceIDs: [String] = []
    var id: String { IngredientIdentity.normalize(category.rawValue + "|" + drugName) }
}

struct AdverseEffectEntry: Identifiable, Codable, Equatable, Hashable, Sendable {
    var name: String
    var incidence: String = ""
    var isSerious: Bool = false
    var sourceIDs: [String] = []
    var id: String { IngredientIdentity.normalize((isSerious ? "serious|" : "common|") + name + "|" + incidence) }
}

struct ReproductiveSafetyProfile: Codable, Equatable, Hashable, Sendable {
    var pregnancy: String = ""
    var lactation: String = ""
    var pregnancyArabicNote: String = ""
    var lactationArabicNote: String = ""
    var sourceIDs: [String] = []
}

struct PharmacologyProfile: Codable, Equatable, Hashable, Sendable {
    var mechanismOfAction: String = ""
    var absorption: [String] = []
    var distribution: [String] = []
    var metabolism: [String] = []
    var elimination: [String] = []
    var sourceIDs: [String] = []
}

struct DoseRegimen: Identifiable, Codable, Equatable, Sendable {
    var indication: String
    var population: DosePopulation
    var formula: DoseFormulaKind
    var route: String
    var minimumAgeMonths: Int?
    var maximumAgeMonths: Int?
    var minimumWeightKG: Double?
    var maximumWeightKG: Double?
    var sexRestriction: PatientSexAtBirth?
    var fixedDoseMG: Double?
    var amountPerKG: Double?
    var amountPerSquareMeter: Double?
    var dividedDoses: Int?
    var intervalHours: Double?
    var maximumSingleDoseMG: Double?
    var maximumDailyDoseMG: Double?
    var durationText: String
    var renalAdjustment: String
    var hepaticAdjustment: String
    var requiresMeasuredWeight: Bool
    var sourceIDs: [String]
    var id: String { "\(population.rawValue)|\(indication)|\(route)|\(formula.rawValue)" }

    init(
        indication: String,
        population: DosePopulation,
        formula: DoseFormulaKind,
        route: String = "",
        minimumAgeMonths: Int? = nil,
        maximumAgeMonths: Int? = nil,
        minimumWeightKG: Double? = nil,
        maximumWeightKG: Double? = nil,
        sexRestriction: PatientSexAtBirth? = nil,
        fixedDoseMG: Double? = nil,
        amountPerKG: Double? = nil,
        amountPerSquareMeter: Double? = nil,
        dividedDoses: Int? = nil,
        intervalHours: Double? = nil,
        maximumSingleDoseMG: Double? = nil,
        maximumDailyDoseMG: Double? = nil,
        durationText: String = "",
        renalAdjustment: String = "",
        hepaticAdjustment: String = "",
        requiresMeasuredWeight: Bool = false,
        sourceIDs: [String] = []
    ) {
        self.indication = indication
        self.population = population
        self.formula = formula
        self.route = route
        self.minimumAgeMonths = minimumAgeMonths
        self.maximumAgeMonths = maximumAgeMonths
        self.minimumWeightKG = minimumWeightKG
        self.maximumWeightKG = maximumWeightKG
        self.sexRestriction = sexRestriction
        self.fixedDoseMG = fixedDoseMG
        self.amountPerKG = amountPerKG
        self.amountPerSquareMeter = amountPerSquareMeter
        self.dividedDoses = dividedDoses
        self.intervalHours = intervalHours
        self.maximumSingleDoseMG = maximumSingleDoseMG
        self.maximumDailyDoseMG = maximumDailyDoseMG
        self.durationText = durationText
        self.renalAdjustment = renalAdjustment
        self.hepaticAdjustment = hepaticAdjustment
        self.requiresMeasuredWeight = requiresMeasuredWeight
        self.sourceIDs = sourceIDs
    }
}

struct DosePatientInput: Equatable, Sendable {
    var ageMonths: Int
    var sexAtBirth: PatientSexAtBirth?
    var measuredWeightKG: Double?
    var estimatedWeightKG: Double?
    var heightCM: Double?
    var renalFunction: String
    var hepaticFunction: String
    var isPregnant: Bool

    var effectiveWeightKG: Double? { measuredWeightKG ?? estimatedWeightKG }
    var usesEstimatedWeight: Bool { measuredWeightKG == nil && estimatedWeightKG != nil }
}

struct DoseCalculationResult: Equatable, Sendable {
    var dosePerAdministrationMG: Double
    var totalDailyDoseMG: Double
    var administrationsPerDay: Int
    var equation: String
    var usedEstimatedWeight: Bool
    var appliedMaximum: Bool
    var cautions: [String]
}

enum ProdrugClassification: String, Codable, CaseIterable, Identifiable, Sendable {
    case unknown = "Unknown"
    case activeDrug = "Active drug"
    case prodrug = "Prodrug"

    var id: String { rawValue }
}

struct ProdrugInfo: Codable, Equatable, Sendable {
    var classification: ProdrugClassification = .unknown
    var administeredCompound: String = ""
    var activeCompound: String = ""
    var activationSite: String = ""
    var activationPathway: String = ""
    var explanation: String = ""
    var sourceIDs: [String] = []
}

enum EliminationPathway: String, Codable, CaseIterable, Identifiable, Sendable {
    case renalUrine = "Kidneys / urine"
    case biliaryFecal = "Bile / feces"
    case pulmonary = "Lungs / exhalation"
    case mixed = "Mixed pathways"
    case other = "Other"
    case unknown = "Unknown"

    var id: String { rawValue }
}

struct EliminationRouteInfo: Identifiable, Codable, Equatable, Sendable {
    var pathway: EliminationPathway
    var percentage: Double?
    var detail: String
    var id: String { "\(pathway.rawValue)|\(percentage ?? -1)|\(detail)" }
}

struct EliminationInfo: Codable, Equatable, Sendable {
    var metabolismSite: String = ""
    var metabolismEnzymes: [String] = []
    var routes: [EliminationRouteInfo] = []
    var dominantPathway: EliminationPathway = .unknown
    var summary: String = ""
    var sourceIDs: [String] = []
}

enum DrugEvidenceQuality: String, Codable, CaseIterable, Sendable {
    case officialLabel
    case productLeaflet
    case altibbi
    case aiUnverified
    case manual
}

struct DrugFieldEvidence: Identifiable, Codable, Equatable, Sendable {
    var id: UUID = UUID()
    var fieldKey: String
    var sourceID: String
    var sourceName: String
    var sourceURL: String
    var quality: DrugEvidenceQuality
    var retrievedAt: Date
    var valueFingerprint: String
}

enum DrugRelationshipKind: String, Codable, CaseIterable, Identifiable, Sendable {
    case interaction = "Interaction"
    case contraindicatedCombination = "Avoid together"
    case sameClass = "Same class"
    case relatedUse = "Related use"

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
    var additionalImageData: [Data] = []
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
    var mechanismKeywords: [String] = []
    var contraindications: [String] = []
    var interactions: [String] = []
    var toxicity: String = ""
    var halfLifeText: String = ""
    var halfLifeHours: Double? = nil
    var halfLifeBandRaw: String = "Unknown"
    var onsetText: String = ""
    var onsetMinutes: Double? = nil
    var onsetBandRaw: String = "Unknown"
    var durationText: String = ""
    var durationHours: Double? = nil
    var durationBandRaw: String = "Unknown"
    var dosingFrequencyRaw: String = "Unknown"
    var timesPerDay: Int?
    var prodrugStatusRaw: String = "Unknown"
    var excretionRouteRaw: String = "Unknown"
    var excretionNotes: String = ""
    var pkMemoryLineArabic: String = ""
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
    var arabicMemoryStory: String = ""
    var arabicImportantNote: String = ""
    var arabicPersonalNotes: String = ""
    var counselingHowToTakeArabic: String = ""
    var counselingFoodArabic: String = ""
    var patientFeelingsArabic: [String] = []
    var seekHelpArabic: [String] = []
    var missedDoseArabic: String = ""
    var seriousSideEffects: [String] = []
    var mustKnow: [String] = []
    var flashcards: [String] = []
    var reviewQuestionsJSON: String = ""
    var memoryItemsJSON: String = ""
    var atomicNotesJSON: String = ""
    var reviewQuestionsNeedRegeneration: Bool = false
    var oneLineSummaryArabic: String = ""
    var sourceNeedsReview: Bool = false
    var sourceMissingFields: [String] = []
    var sourceQualityNotes: String = ""
    var trustedSourceWasTruncated: Bool = false
    var sourceURL: String = ""
    var importedSourceName: String = ""
    var sourceUpdatedAt: Date? = nil
    @Attribute(.externalStorage) var thumbnailData: Data?
    var additionalThumbnailData: [Data] = []
    var canonicalIngredientKey: String = ""
    var activeIngredients: [String] = []
    var rxNormConceptIDs: [String] = []
    var doseRegimensJSON: String = ""
    var prodrugInfoJSON: String = ""
    var eliminationInfoJSON: String = ""
    var fieldEvidenceJSON: String = ""
    var dosageFormGroupsJSON: String = ""
    var clinicalDosesJSON: String = ""
    var interactionEntriesJSON: String = ""
    var adverseEffectEntriesJSON: String = ""
    var reproductiveSafetyJSON: String = ""
    var pharmacologyProfileJSON: String = ""
    var lastKnowledgeRefreshAt: Date? = nil
    @Relationship(deleteRule: .cascade, inverse: \DrugProduct.profile) var products: [DrugProduct] = []

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
        self.timesPerDay = nil
        self.thumbnailData = nil
        self.additionalImageData = []
        self.additionalThumbnailData = []
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

    var halfLifeBand: HalfLifeBand {
        get { HalfLifeBand(rawValue: halfLifeBandRaw) ?? .unknown }
        set { halfLifeBandRaw = newValue.rawValue }
    }

    var onsetBand: OnsetBand {
        get { OnsetBand(rawValue: onsetBandRaw) ?? .unknown }
        set { onsetBandRaw = newValue.rawValue }
    }

    var durationBand: DurationBand {
        get { DurationBand(rawValue: durationBandRaw) ?? .unknown }
        set { durationBandRaw = newValue.rawValue }
    }

    var dosingFrequency: DosingFrequency {
        get { DosingFrequency(rawValue: dosingFrequencyRaw) ?? .unknown }
        set { dosingFrequencyRaw = newValue.rawValue }
    }

    var prodrugStatus: ProdrugStatus {
        get {
            if prodrugStatusRaw == "Yes" { return .prodrug }
            if prodrugStatusRaw == "No" { return .active }
            return ProdrugStatus(rawValue: prodrugStatusRaw) ?? .unknown
        }
        set { prodrugStatusRaw = newValue.rawValue }
    }

    var excretionRoute: ExcretionRoute {
        get { ExcretionRoute(rawValue: excretionRouteRaw) ?? .unknown }
        set { excretionRouteRaw = newValue.rawValue }
    }

    var isImported: Bool { !importedSourceName.trimmed.isEmpty }
    var isIncomplete: Bool {
        isUnknown || scientificName.trimmed.isEmpty || effectiveTradeNames.isEmpty || dosageForms.isEmpty
    }

    var displayName: String {
        if !scientificName.trimmed.isEmpty { return scientificName.trimmed }
        if let tradeName = effectiveTradeNames.first, !tradeName.trimmed.isEmpty { return tradeName.trimmed }
        return captureLabel.trimmed.isEmpty ? "Unknown drug" : captureLabel.trimmed
    }

    var effectiveTradeNames: [String] {
        var names = tradeNames
        for product in products where !product.tradeName.trimmed.isEmpty && !names.contains(where: { $0.caseInsensitiveCompare(product.tradeName) == .orderedSame }) {
            names.append(product.tradeName)
        }
        return names
    }
    var firstTradeName: String { effectiveTradeNames.first ?? "No trade name yet" }
    var packageImages: [Data] {
        let legacy = [imageData].compactMap { $0 } + additionalImageData
        let productImages = products.flatMap(\.packageImages)
        return legacy + productImages
    }
    var packageThumbnails: [Data] {
        let legacy = [thumbnailData].compactMap { $0 } + additionalThumbnailData
        let productThumbnails = products.flatMap(\.packageThumbnails)
        let thumbnails = legacy + productThumbnails
        return thumbnails.isEmpty ? packageImages : thumbnails
    }
    var ingredientNames: [String] { activeIngredients.isEmpty ? [scientificName].filter { !$0.trimmed.isEmpty } : activeIngredients }
    var doseRegimens: [DoseRegimen] {
        get { Self.decode([DoseRegimen].self, from: doseRegimensJSON) ?? [] }
        set { doseRegimensJSON = Self.encode(newValue) }
    }
    var dosageFormGroups: [DosageFormGroup] {
        get {
            if let value = Self.decode([DosageFormGroup].self, from: dosageFormGroupsJSON), !value.isEmpty { return value }
            guard !dosageForms.isEmpty else { return [] }
            return dosageForms.map { form in
                DosageFormGroup(dosageForm: form, strengths: strengths.map { FormStrength(strength: $0) })
            }
        }
        set {
            dosageFormGroupsJSON = Self.encode(newValue)
            dosageForms = newValue.map(\.dosageForm).filter { !$0.trimmed.isEmpty }
            strengths = newValue.flatMap(\.strengths).map(\.strength).reduce(into: [String]()) { values, item in
                if !values.contains(where: { $0.localizedCaseInsensitiveCompare(item) == .orderedSame }) { values.append(item) }
            }
        }
    }
    var clinicalDoses: [ClinicalDoseEntry] {
        get { Self.decode([ClinicalDoseEntry].self, from: clinicalDosesJSON) ?? [] }
        set { clinicalDosesJSON = Self.encode(newValue) }
    }
    var interactionEntries: [DrugInteractionEntry] {
        get {
            if let value = Self.decode([DrugInteractionEntry].self, from: interactionEntriesJSON), !value.isEmpty { return value }
            return interactions.filter { !$0.trimmed.isEmpty }.map { DrugInteractionEntry(drugName: $0, category: .unknown) }
        }
        set {
            interactionEntriesJSON = Self.encode(newValue)
            interactions = newValue.map(\.drugName)
        }
    }
    var adverseEffectEntries: [AdverseEffectEntry] {
        get {
            if let value = Self.decode([AdverseEffectEntry].self, from: adverseEffectEntriesJSON), !value.isEmpty { return value }
            return commonSideEffects.map { AdverseEffectEntry(name: $0) }
                + seriousSideEffects.map { AdverseEffectEntry(name: $0, isSerious: true) }
        }
        set {
            adverseEffectEntriesJSON = Self.encode(newValue)
            commonSideEffects = newValue.filter { !$0.isSerious }.map(\.name)
            seriousSideEffects = newValue.filter(\.isSerious).map(\.name)
        }
    }
    var reproductiveSafety: ReproductiveSafetyProfile {
        get {
            Self.decode(ReproductiveSafetyProfile.self, from: reproductiveSafetyJSON)
                ?? ReproductiveSafetyProfile(pregnancy: pregnancyCaution, pregnancyArabicNote: pregnancyCaution)
        }
        set {
            reproductiveSafetyJSON = Self.encode(newValue)
            pregnancyCaution = newValue.pregnancyArabicNote.trimmed.isEmpty ? newValue.pregnancy : newValue.pregnancyArabicNote
        }
    }
    var pharmacologyProfile: PharmacologyProfile {
        get {
            Self.decode(PharmacologyProfile.self, from: pharmacologyProfileJSON)
                ?? PharmacologyProfile(mechanismOfAction: mechanism, metabolism: excretionNotes.trimmed.isEmpty ? [] : [excretionNotes])
        }
        set {
            pharmacologyProfileJSON = Self.encode(newValue)
            mechanism = newValue.mechanismOfAction
        }
    }
    var prodrugInfo: ProdrugInfo {
        get {
            if let value = Self.decode(ProdrugInfo.self, from: prodrugInfoJSON) { return value }
            return ProdrugInfo(
                classification: prodrugStatus == .prodrug ? .prodrug : (prodrugStatus == .active ? .activeDrug : .unknown),
                administeredCompound: scientificName,
                explanation: "",
                sourceIDs: []
            )
        }
        set {
            prodrugInfoJSON = Self.encode(newValue)
            switch newValue.classification {
            case .prodrug: prodrugStatus = .prodrug
            case .activeDrug: prodrugStatus = .active
            case .unknown: prodrugStatus = .unknown
            }
        }
    }
    var eliminationInfo: EliminationInfo {
        get {
            if let value = Self.decode(EliminationInfo.self, from: eliminationInfoJSON) { return value }
            let pathway: EliminationPathway = switch excretionRoute {
            case .renal: .renalUrine
            case .hepatic: .biliaryFecal
            case .mixed: .mixed
            case .unknown: .unknown
            }
            return EliminationInfo(routes: excretionNotes.trimmed.isEmpty ? [] : [EliminationRouteInfo(pathway: pathway, detail: excretionNotes)], dominantPathway: pathway, summary: excretionNotes)
        }
        set {
            eliminationInfoJSON = Self.encode(newValue)
            excretionNotes = newValue.summary
            switch newValue.dominantPathway {
            case .renalUrine: excretionRoute = .renal
            case .biliaryFecal: excretionRoute = .hepatic
            case .mixed: excretionRoute = .mixed
            case .other, .pulmonary: excretionRoute = .unknown
            case .unknown: excretionRoute = .unknown
            }
        }
    }
    var fieldEvidence: [DrugFieldEvidence] {
        get { Self.decode([DrugFieldEvidence].self, from: fieldEvidenceJSON) ?? [] }
        set { fieldEvidenceJSON = Self.encode(newValue) }
    }
    var generatedReviewQuestions: [GeneratedReviewQuestion] {
        get {
            guard let data = reviewQuestionsJSON.data(using: .utf8) else { return [] }
            return (try? JSONDecoder().decode([GeneratedReviewQuestion].self, from: data)) ?? []
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue), let value = String(data: data, encoding: .utf8) else {
                reviewQuestionsJSON = ""
                return
            }
            reviewQuestionsJSON = value
        }
    }

    var memoryItems: [MemoryItemState] {
        get {
            if let data = memoryItemsJSON.data(using: .utf8),
               let decoded = try? JSONDecoder().decode([MemoryItemState].self, from: data),
               !decoded.isEmpty { return decoded }
            return QuestionType.allCases.filter { $0 != .casePractice }.map { MemoryItemState(fieldRaw: $0.rawValue) }
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue), let value = String(data: data, encoding: .utf8) else {
                memoryItemsJSON = ""
                return
            }
            memoryItemsJSON = value
        }
    }

    var atomicNotes: [AtomicDrugNote] {
        get {
            guard let data = atomicNotesJSON.data(using: .utf8) else { return [] }
            return (try? JSONDecoder().decode([AtomicDrugNote].self, from: data)) ?? []
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue), let value = String(data: data, encoding: .utf8) else { atomicNotesJSON = ""; return }
            atomicNotesJSON = value
        }
    }

    var reviewContentFingerprint: String {
        [scientificName, effectiveTradeNames.joined(separator: "|"), drugClass, indications.joined(separator: "|"), mechanism,
         halfLifeText, onsetText, durationText, warnings.joined(separator: "|"), contraindications.joined(separator: "|"),
         interactions.joined(separator: "|"), counselingSentence, howToTake, foodInstruction].joined(separator: "¦")
    }

    var masteryCount: Int {
        [masteryScientificName, masteryTradeName, masteryClass, masteryUse, masteryWarning, masteryCounseling]
            .filter { $0 }.count
    }

    var requiredMasteryCount: Int { drugClass.trimmed.isEmpty ? 5 : 6 }
    var isMastered: Bool { masteryCount >= requiredMasteryCount }

    func recalculateConfidence() {
        let count = masteryCount
        let required = requiredMasteryCount
        if count >= required { confidenceLevel = .mastered }
        else if count >= 4 { confidenceLevel = .strong }
        else if count >= 2 { confidenceLevel = .medium }
        else { confidenceLevel = .weak }
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

    private static func encode<T: Encodable>(_ value: T) -> String {
        guard let data = try? JSONEncoder().encode(value) else { return "" }
        return String(data: data, encoding: .utf8) ?? ""
    }

    private static func decode<T: Decodable>(_ type: T.Type, from string: String) -> T? {
        guard let data = string.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }
}

@Model
final class DrugProduct {
    @Attribute(.unique) var id: UUID
    @Attribute(.unique) var productKey: String
    var tradeName: String
    var manufacturer: String
    var strength: String
    var marketedStrengthLabel: String = ""
    var ingredientComponentsJSON: String = ""
    var dosageForm: String
    var route: String
    var country: String
    var shelfLocation: String
    @Attribute(.externalStorage) var imageData: Data?
    var additionalImageData: [Data]
    @Attribute(.externalStorage) var thumbnailData: Data?
    var additionalThumbnailData: [Data]
    var leafletText: String
    var leafletUpdatedAt: Date?
    var sourceName: String
    var sourceURL: String
    var dateAdded: Date
    var profile: Drug?

    init(
        id: UUID = UUID(),
        productKey: String,
        tradeName: String,
        manufacturer: String = "",
        strength: String = "",
        marketedStrengthLabel: String = "",
        ingredientComponents: [IngredientComponent] = [],
        dosageForm: String = "",
        route: String = "",
        country: String = "",
        shelfLocation: String = "",
        imageData: Data? = nil,
        additionalImageData: [Data] = [],
        thumbnailData: Data? = nil,
        additionalThumbnailData: [Data] = [],
        leafletText: String = "",
        leafletUpdatedAt: Date? = nil,
        sourceName: String = "",
        sourceURL: String = "",
        dateAdded: Date = .now,
        profile: Drug? = nil
    ) {
        self.id = id
        self.productKey = productKey
        self.tradeName = tradeName
        self.manufacturer = manufacturer
        self.strength = strength
        self.marketedStrengthLabel = marketedStrengthLabel.trimmed.isEmpty ? strength : marketedStrengthLabel
        self.ingredientComponentsJSON = Self.encode(ingredientComponents)
        self.dosageForm = dosageForm
        self.route = route
        self.country = country
        self.shelfLocation = shelfLocation
        self.imageData = imageData
        self.additionalImageData = additionalImageData
        self.thumbnailData = thumbnailData
        self.additionalThumbnailData = additionalThumbnailData
        self.leafletText = leafletText
        self.leafletUpdatedAt = leafletUpdatedAt
        self.sourceName = sourceName
        self.sourceURL = sourceURL
        self.dateAdded = dateAdded
        self.profile = profile
    }

    var packageImages: [Data] { [imageData].compactMap { $0 } + additionalImageData }
    var packageThumbnails: [Data] {
        let thumbnails = [thumbnailData].compactMap { $0 } + additionalThumbnailData
        return thumbnails.isEmpty ? packageImages : thumbnails
    }
    var ingredientComponents: [IngredientComponent] {
        get { Self.decode([IngredientComponent].self, from: ingredientComponentsJSON) ?? [] }
        set { ingredientComponentsJSON = Self.encode(newValue) }
    }

    private static func encode<T: Encodable>(_ value: T) -> String {
        guard let data = try? JSONEncoder().encode(value) else { return "" }
        return String(data: data, encoding: .utf8) ?? ""
    }

    private static func decode<T: Decodable>(_ type: T.Type, from string: String) -> T? {
        guard let data = string.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }
}

@Model
final class DrugRelationship {
    @Attribute(.unique) var id: UUID
    @Attribute(.unique) var relationshipKey: String
    var kindRaw: String
    var severityRaw: String
    var summary: String
    var managementNote: String
    var sourceURLs: [String]
    var checkedAt: Date
    @Relationship(deleteRule: .nullify) var sourceDrug: Drug?
    @Relationship(deleteRule: .nullify) var targetDrug: Drug?

    init(
        id: UUID = UUID(),
        relationshipKey: String,
        kind: DrugRelationshipKind,
        severity: SafetySeverity = .unknown,
        summary: String,
        managementNote: String = "",
        sourceURLs: [String] = [],
        checkedAt: Date = .now,
        sourceDrug: Drug? = nil,
        targetDrug: Drug? = nil
    ) {
        self.id = id
        self.relationshipKey = relationshipKey
        self.kindRaw = kind.rawValue
        self.severityRaw = severity.rawValue
        self.summary = summary
        self.managementNote = managementNote
        self.sourceURLs = sourceURLs
        self.checkedAt = checkedAt
        self.sourceDrug = sourceDrug
        self.targetDrug = targetDrug
    }

    var kind: DrugRelationshipKind {
        get { DrugRelationshipKind(rawValue: kindRaw) ?? .interaction }
        set { kindRaw = newValue.rawValue }
    }

    var severity: SafetySeverity {
        get { SafetySeverity(rawValue: severityRaw) ?? .unknown }
        set { severityRaw = newValue.rawValue }
    }
}

enum IngredientIdentity {
    static func canonicalKey(names: [String], rxNormIDs: [String] = []) -> String {
        let identifiers = rxNormIDs.map(normalize).filter { !$0.isEmpty }.sorted()
        if !identifiers.isEmpty { return "rxcui:" + identifiers.joined(separator: "+") }
        return "ingredient:" + names.map(normalize).filter { !$0.isEmpty }.sorted().joined(separator: "+")
    }

    static func productKey(tradeName: String, manufacturer: String, strength: String, dosageForm: String, ingredientKey: String) -> String {
        [ingredientKey, tradeName, manufacturer, strength, dosageForm].map(normalize).joined(separator: "|")
    }

    static func normalize(_ value: String) -> String {
        value.folding(options: [.caseInsensitive, .diacriticInsensitive, .widthInsensitive], locale: Locale(identifier: "en_US_POSIX"))
            .lowercased()
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { !$0.isEmpty }
            .joined(separator: "-")
    }
}

enum PediatricWeightReference {
    static let sourceName = "WHO weight-for-age standards"
    static let sourceURL = "https://www.who.int/tools/child-growth-standards/standards/weight-for-age"

    static func medianWeightKG(ageMonths: Int, sex: PatientSexAtBirth) -> Double? {
        guard (0...120).contains(ageMonths) else { return nil }
        return (sex == .female ? femaleMedianKG : maleMedianKG)[ageMonths]
    }

    private static let femaleMedianKG: [Double] = [
        3.2322, 4.1873, 5.1282, 5.8458, 6.4237, 6.8985, 7.297, 7.6422, 7.9487, 8.2254, 8.48, 8.7192,
        8.9481, 9.1699, 9.387, 9.6008, 9.8124, 10.0226, 10.2315, 10.4393, 10.6464, 10.8534, 11.0608, 11.2688,
        11.4775, 11.6864, 11.8947, 12.1015, 12.3059, 12.5073, 12.7055, 12.9006, 13.093, 13.2837, 13.4731, 13.6618,
        13.8503, 14.0385, 14.2265, 14.414, 14.601, 14.7873, 14.9727, 15.1573, 15.341, 15.524, 15.7064, 15.8882,
        16.0697, 16.2511, 16.4322, 16.6133, 16.7942, 16.9748, 17.1551, 17.3347, 17.5136, 17.6916, 17.8686, 18.0445,
        18.2193, 18.2579, 18.4329, 18.6073, 18.7811, 18.9545, 19.1276, 19.3004, 19.473, 19.6455, 19.818, 19.9908,
        20.1639, 20.3377, 20.5124, 20.6885, 20.8661, 21.0457, 21.2274, 21.4113, 21.5979, 21.7872, 21.9795, 22.1751,
        22.374, 22.5762, 22.7816, 22.9904, 23.2025, 23.418, 23.6369, 23.8593, 24.0853, 24.3149, 24.5482, 24.7853,
        25.0262, 25.271, 25.5197, 25.7721, 26.0284, 26.2883, 26.5519, 26.819, 27.0896, 27.3635, 27.6406, 27.9208,
        28.204, 28.4901, 28.7791, 29.0711, 29.3663, 29.6646, 29.9663, 30.2715, 30.5805, 30.8934, 31.2105, 31.5319, 31.8578
    ]

    private static let maleMedianKG: [Double] = [
        3.3464, 4.4709, 5.5675, 6.3762, 7.0023, 7.5105, 7.934, 8.297, 8.6151, 8.9014, 9.1649, 9.4122,
        9.6479, 9.8749, 10.0953, 10.3108, 10.5228, 10.7319, 10.9385, 11.143, 11.3462, 11.5486, 11.7504, 11.9514,
        12.1515, 12.3502, 12.5466, 12.7401, 12.9303, 13.1169, 13.3, 13.4798, 13.6567, 13.8309, 14.0031, 14.1736,
        14.3429, 14.5113, 14.6791, 14.8466, 15.014, 15.1813, 15.3486, 15.5158, 15.6828, 15.8497, 16.0163, 16.1827,
        16.3489, 16.515, 16.6811, 16.8471, 17.0132, 17.1792, 17.3452, 17.5111, 17.6768, 17.8422, 18.0073, 18.1722,
        18.3366, 18.5057, 18.6802, 18.8563, 19.034, 19.2132, 19.394, 19.5765, 19.7607, 19.9468, 20.1344, 20.3235,
        20.5137, 20.7052, 20.8979, 21.0918, 21.287, 21.4833, 21.681, 21.8799, 22.08, 22.2813, 22.4837, 22.6872,
        22.8915, 23.0968, 23.3029, 23.5101, 23.7182, 23.9272, 24.1371, 24.3479, 24.5595, 24.7722, 24.9858, 25.2005,
        25.4163, 25.6332, 25.8513, 26.0706, 26.2911, 26.5128, 26.7358, 26.9602, 27.1861, 27.4137, 27.6432, 27.875,
        28.1092, 28.3459, 28.5854, 28.8277, 29.0731, 29.3217, 29.5736, 29.8289, 30.0877, 30.3501, 30.616, 30.8854, 31.1586
    ]
}

enum DoseCalculatorError: LocalizedError, Equatable {
    case ageOutsideRegimen
    case sexOutsideRegimen
    case weightRequired
    case heightRequired
    case invalidRegimen

    var errorDescription: String? {
        switch self {
        case .ageOutsideRegimen: "This regimen does not cover the entered age."
        case .sexOutsideRegimen: "This regimen does not cover the selected sex."
        case .weightRequired: "A measured weight is required for this regimen. WHO estimates are available only through age 10."
        case .heightRequired: "Height is required for a body-surface-area regimen."
        case .invalidRegimen: "This regimen does not contain enough structured dose data."
        }
    }
}

enum DoseCalculator {
    static func calculate(regimen: DoseRegimen, input: DosePatientInput) throws -> DoseCalculationResult {
        if let minimum = regimen.minimumAgeMonths, input.ageMonths < minimum { throw DoseCalculatorError.ageOutsideRegimen }
        if let maximum = regimen.maximumAgeMonths, input.ageMonths > maximum { throw DoseCalculatorError.ageOutsideRegimen }
        if let restriction = regimen.sexRestriction, input.sexAtBirth != restriction { throw DoseCalculatorError.sexOutsideRegimen }

        let dosesPerDay = max(1, regimen.dividedDoses ?? regimen.intervalHours.map { max(1, Int((24 / $0).rounded())) } ?? 1)
        var perDose: Double
        var daily: Double
        var equation: String
        switch regimen.formula {
        case .fixed:
            guard let amount = regimen.fixedDoseMG, amount > 0 else { throw DoseCalculatorError.invalidRegimen }
            perDose = amount; daily = amount * Double(dosesPerDay)
            equation = "\(format(amount)) mg × \(dosesPerDay) dose(s)/day"
        case .mgPerKgPerDose, .mgPerKgPerDay:
            guard let weight = input.effectiveWeightKG, weight > 0, !regimen.requiresMeasuredWeight || input.measuredWeightKG != nil else { throw DoseCalculatorError.weightRequired }
            guard let amount = regimen.amountPerKG, amount > 0 else { throw DoseCalculatorError.invalidRegimen }
            if regimen.formula == .mgPerKgPerDose {
                perDose = amount * weight; daily = perDose * Double(dosesPerDay)
                equation = "\(format(amount)) mg/kg/dose × \(format(weight)) kg"
            } else {
                daily = amount * weight; perDose = daily / Double(dosesPerDay)
                equation = "(\(format(amount)) mg/kg/day × \(format(weight)) kg) ÷ \(dosesPerDay)"
            }
        case .mgPerSquareMeter:
            guard let weight = input.effectiveWeightKG, weight > 0, !regimen.requiresMeasuredWeight || input.measuredWeightKG != nil else { throw DoseCalculatorError.weightRequired }
            guard let height = input.heightCM, height > 0 else { throw DoseCalculatorError.heightRequired }
            guard let amount = regimen.amountPerSquareMeter, amount > 0 else { throw DoseCalculatorError.invalidRegimen }
            let bsa = sqrt((height * weight) / 3600)
            perDose = amount * bsa; daily = perDose * Double(dosesPerDay)
            equation = "\(format(amount)) mg/m² × √((\(format(height)) cm × \(format(weight)) kg) ÷ 3600)"
        }

        var capped = false
        if let maximum = regimen.maximumSingleDoseMG, perDose > maximum { perDose = maximum; capped = true }
        if let maximum = regimen.maximumDailyDoseMG, daily > maximum {
            daily = maximum; perDose = min(perDose, maximum / Double(dosesPerDay)); capped = true
        } else { daily = perDose * Double(dosesPerDay) }
        var cautions = ["Educational calculation only. Verify the indication, product, renal/hepatic function, and current clinical reference."]
        if input.usesEstimatedWeight { cautions.append("Uses the WHO median weight for age and sex, not this child's measured weight.") }
        if !input.renalFunction.trimmed.isEmpty && input.renalFunction != "Normal" { cautions.append(regimen.renalAdjustment.trimmed.isEmpty ? "No structured renal adjustment is available." : regimen.renalAdjustment) }
        if !input.hepaticFunction.trimmed.isEmpty && input.hepaticFunction != "Normal" { cautions.append(regimen.hepaticAdjustment.trimmed.isEmpty ? "No structured hepatic adjustment is available." : regimen.hepaticAdjustment) }
        if input.isPregnant { cautions.append("Pregnancy requires an indication-specific clinician review.") }
        return DoseCalculationResult(dosePerAdministrationMG: perDose, totalDailyDoseMG: daily, administrationsPerDay: dosesPerDay, equation: equation, usedEstimatedWeight: input.usesEstimatedWeight, appliedMaximum: capped, cautions: cautions)
    }

    private static func format(_ number: Double) -> String { number.formatted(.number.precision(.fractionLength(0...2))) }
}

@MainActor
enum DrugLibraryMigrationService {
    private static let migrationKey = "ingredient-product-migration-v1"
    private static let richProfileMigrationKey = "rich-profile-migration-v1"

    static func runIfNeeded(context: ModelContext) throws {
        if !UserDefaults.standard.bool(forKey: migrationKey) {
            let drugs = try context.fetch(FetchDescriptor<Drug>())
            let reviews = try context.fetch(FetchDescriptor<ReviewLog>())
            var owners: [String: Drug] = [:]
            for drug in drugs.sorted(by: { $0.dateAdded < $1.dateAdded }) {
                if drug.activeIngredients.isEmpty, !drug.scientificName.trimmed.isEmpty { drug.activeIngredients = [drug.scientificName] }
                let key = IngredientIdentity.canonicalKey(names: drug.ingredientNames, rxNormIDs: drug.rxNormConceptIDs)
                drug.canonicalIngredientKey = key
                let product = makeLegacyProduct(from: drug, ingredientKey: key)
                if let owner = owners[key], !key.hasSuffix("ingredient:") {
                    merge(drug, into: owner)
                    if let product, !owner.products.contains(where: { $0.productKey == product.productKey }) { product.profile = owner; owner.products.append(product); context.insert(product) }
                    for review in reviews where review.drug?.id == drug.id { review.drug = owner }
                    context.delete(drug)
                } else {
                    owners[key] = drug
                    if let product, !drug.products.contains(where: { $0.productKey == product.productKey }) { product.profile = drug; drug.products.append(product); context.insert(product) }
                }
            }
            try context.save()
            UserDefaults.standard.set(true, forKey: migrationKey)
        }
        try backfillRichProfilesIfNeeded(context: context)
        try repairProductAuthority(context: context)
    }

    private static func backfillRichProfilesIfNeeded(context: ModelContext) throws {
        guard !UserDefaults.standard.bool(forKey: richProfileMigrationKey) else { return }
        let drugs = try context.fetch(FetchDescriptor<Drug>())
        for drug in drugs {
            if drug.dosageFormGroupsJSON.trimmed.isEmpty { drug.dosageFormGroups = drug.dosageFormGroups }
            if drug.interactionEntriesJSON.trimmed.isEmpty { drug.interactionEntries = drug.interactionEntries }
            if drug.adverseEffectEntriesJSON.trimmed.isEmpty { drug.adverseEffectEntries = drug.adverseEffectEntries }
            if drug.reproductiveSafetyJSON.trimmed.isEmpty { drug.reproductiveSafety = drug.reproductiveSafety }
            if drug.pharmacologyProfileJSON.trimmed.isEmpty { drug.pharmacologyProfile = drug.pharmacologyProfile }
            for product in drug.products {
                if product.marketedStrengthLabel.trimmed.isEmpty { product.marketedStrengthLabel = product.strength }
                if product.ingredientComponents.isEmpty {
                    let components = drug.ingredientNames.map { IngredientComponent(name: $0, displayStrength: drug.ingredientNames.count == 1 ? product.strength : "") }
                    product.ingredientComponents = components
                }
            }
        }
        try context.save()
        UserDefaults.standard.set(true, forKey: richProfileMigrationKey)
    }

    private static func repairProductAuthority(context: ModelContext) throws {
        let drugs = try context.fetch(FetchDescriptor<Drug>())
        for drug in drugs {
            if drug.activeIngredients.isEmpty, !drug.scientificName.trimmed.isEmpty {
                drug.activeIngredients = [drug.scientificName]
            }
            if drug.canonicalIngredientKey.trimmed.isEmpty {
                drug.canonicalIngredientKey = IngredientIdentity.canonicalKey(names: drug.ingredientNames, rxNormIDs: drug.rxNormConceptIDs)
            }

            let legacyNames = drug.tradeNames.filter { !$0.trimmed.isEmpty }
            for (index, tradeName) in legacyNames.enumerated() where !drug.products.contains(where: {
                $0.tradeName.localizedCaseInsensitiveCompare(tradeName) == .orderedSame
            }) {
                let strength = drug.strengths.first ?? ""
                let product = DrugProduct(
                    productKey: IngredientIdentity.productKey(
                        tradeName: tradeName,
                        manufacturer: "",
                        strength: strength,
                        dosageForm: drug.dosageForms.first ?? "",
                        ingredientKey: drug.canonicalIngredientKey
                    ),
                    tradeName: tradeName,
                    strength: strength,
                    marketedStrengthLabel: strength,
                    ingredientComponents: drug.ingredientNames.map {
                        IngredientComponent(name: $0, displayStrength: drug.ingredientNames.count == 1 ? strength : "")
                    },
                    dosageForm: drug.dosageForms.first ?? "",
                    route: drug.routes.first ?? "",
                    shelfLocation: drug.shelfLocation,
                    imageData: index == 0 ? drug.imageData : nil,
                    additionalImageData: index == 0 ? drug.additionalImageData : [],
                    thumbnailData: index == 0 ? drug.thumbnailData : nil,
                    additionalThumbnailData: index == 0 ? drug.additionalThumbnailData : [],
                    sourceName: drug.importedSourceName,
                    sourceURL: drug.sourceURL,
                    dateAdded: drug.dateAdded,
                    profile: drug
                )
                context.insert(product)
                drug.products.append(product)
            }
            DrugBrandService.synchronizeCompatibilityCache(for: drug)
        }
        try context.save()
    }

    private static func makeLegacyProduct(from drug: Drug, ingredientKey: String) -> DrugProduct? {
        guard !drug.tradeNames.isEmpty || drug.imageData != nil || !drug.strengths.isEmpty || !drug.dosageForms.isEmpty else { return nil }
        let trade = drug.tradeNames.first ?? drug.displayName
        let strength = drug.strengths.first ?? ""
        let components = drug.ingredientNames.map { IngredientComponent(name: $0, displayStrength: drug.ingredientNames.count == 1 ? strength : "") }
        return DrugProduct(productKey: IngredientIdentity.productKey(tradeName: trade, manufacturer: "", strength: strength, dosageForm: drug.dosageForms.first ?? "", ingredientKey: ingredientKey), tradeName: trade, strength: strength, marketedStrengthLabel: strength, ingredientComponents: components, dosageForm: drug.dosageForms.first ?? "", route: drug.routes.first ?? "", shelfLocation: drug.shelfLocation, imageData: drug.imageData, additionalImageData: drug.additionalImageData, thumbnailData: drug.thumbnailData, additionalThumbnailData: drug.additionalThumbnailData, sourceName: drug.importedSourceName, sourceURL: drug.sourceURL, dateAdded: drug.dateAdded)
    }

    private static func merge(_ duplicate: Drug, into owner: Drug) {
        owner.tradeNames = unique(owner.tradeNames + duplicate.tradeNames)
        owner.dosageForms = unique(owner.dosageForms + duplicate.dosageForms)
        owner.strengths = unique(owner.strengths + duplicate.strengths)
        owner.routes = unique(owner.routes + duplicate.routes)
        owner.indications = unique(owner.indications + duplicate.indications)
        owner.interactions = unique(owner.interactions + duplicate.interactions)
        owner.notes = [owner.notes, duplicate.notes].filter { !$0.trimmed.isEmpty }.joined(separator: "\n\n")
        owner.timesSeen += duplicate.timesSeen
        owner.lastSeenDate = [owner.lastSeenDate, duplicate.lastSeenDate].compactMap { $0 }.max()
        if owner.imageData == nil { owner.imageData = duplicate.imageData; owner.thumbnailData = duplicate.thumbnailData }
        owner.additionalImageData += duplicate.additionalImageData
        owner.additionalThumbnailData += duplicate.additionalThumbnailData
    }

    private static func unique(_ values: [String]) -> [String] {
        var seen = Set<String>()
        return values.filter { seen.insert(IngredientIdentity.normalize($0)).inserted }
    }
}

@Model
final class ReviewLog {
    @Attribute(.unique) var id: UUID
    @Relationship(deleteRule: .nullify) var drug: Drug?
    var drugNameSnapshot: String
    var date: Date
    var questionTypeRaw: String
    var ratingRaw: String
    var wasCorrect: Bool
    var scoreBefore: Int
    var scoreAfter: Int
    var caseID: String?

    init(id: UUID = UUID(), drug: Drug?, drugNameSnapshot: String, date: Date = .now, questionType: QuestionType, rating: ReviewRating, scoreBefore: Int, scoreAfter: Int, caseID: String? = nil) {
        self.id = id
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

    init(id: UUID = UUID(), date: Date = .now, chapterFocus: Chapter = .other) {
        self.id = id
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
    @Relationship(deleteRule: .nullify) var relatedDrug: Drug?
    var relatedDrugNameSnapshot: String
    var whatHappened: String
    var whatILearned: String
    var pharmacistNote: String
    var privacyConfirmed: Bool

    init(id: UUID = UUID(), date: Date = .now, topic: String = "", relatedDrug: Drug? = nil, whatHappened: String = "", whatILearned: String = "", pharmacistNote: String = "", privacyConfirmed: Bool = false) {
        self.id = id
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

    init(id: UUID = UUID(), periodStart: Date, periodEnd: Date) {
        self.id = id
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

@Model
final class LearningProfile {
    @Attribute(.unique) var id: UUID
    var currentStreak: Int
    var longestStreak: Int
    var completedSessions: Int
    var completedQuestions: Int
    var correctAnswers: Int
    var badges: [String]
    var lastActivityDate: Date?
    var weakDrugRemindersEnabled: Bool

    init(id: UUID = UUID(), currentStreak: Int = 0, longestStreak: Int = 0, completedSessions: Int = 0, completedQuestions: Int = 0, correctAnswers: Int = 0, badges: [String] = [], lastActivityDate: Date? = nil, weakDrugRemindersEnabled: Bool = true) {
        self.id = id; self.currentStreak = currentStreak; self.longestStreak = longestStreak
        self.completedSessions = completedSessions; self.completedQuestions = completedQuestions; self.correctAnswers = correctAnswers
        self.badges = badges; self.lastActivityDate = lastActivityDate; self.weakDrugRemindersEnabled = weakDrugRemindersEnabled
    }
}

@Model
final class DailyActivity {
    @Attribute(.unique) var id: UUID
    var day: Date
    var sessionsCompleted: Int
    var questionsAnswered: Int
    var correctAnswers: Int
    var missionCompleted: Bool

    init(id: UUID = UUID(), day: Date, sessionsCompleted: Int = 0, questionsAnswered: Int = 0, correctAnswers: Int = 0, missionCompleted: Bool = false) {
        self.id = id; self.day = day; self.sessionsCompleted = sessionsCompleted
        self.questionsAnswered = questionsAnswered; self.correctAnswers = correctAnswers; self.missionCompleted = missionCompleted
    }
}

extension String {
    var trimmed: String { trimmingCharacters(in: .whitespacesAndNewlines) }
    var normalizedAPIKey: String {
        unicodeScalars.filter { !CharacterSet.whitespacesAndNewlines.contains($0) }.map { String($0) }.joined()
    }

    var splitLines: [String] {
        components(separatedBy: .newlines).map(\.trimmed).filter { !$0.isEmpty }
    }
}
