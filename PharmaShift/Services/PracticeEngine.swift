import Foundation
import NaturalLanguage
import SwiftData

enum PracticeMode: String, CaseIterable, Identifiable, Codable {
    case smartSession = "Smart Session"
    case scientificToTrade = "Scientific → Trade"
    case tradeToScientific = "Trade → Scientific"
    case classExamples = "Class → Examples"
    case drugUse = "Drug → Use"
    case drugWarning = "Drug → Warning"
    case imageQuiz = "Image Quiz"
    case counseling = "Counseling"
    case weakDrug = "Weak Drugs"
    case dueReview = "Due Review"
    case systemSpecific = "System Practice"
    case casePractice = "Case Practice"

    var id: String { rawValue }
    var icon: String {
        switch self {
        case .smartSession: "sparkles.rectangle.stack.fill"
        case .scientificToTrade, .tradeToScientific: "arrow.left.arrow.right"
        case .classExamples: "square.grid.2x2"
        case .drugUse: "cross.vial"
        case .drugWarning: "exclamationmark.triangle"
        case .imageQuiz: "photo"
        case .counseling: "quote.bubble"
        case .weakDrug: "bolt.heart"
        case .dueReview: "calendar.badge.clock"
        case .systemSpecific: "books.vertical"
        case .casePractice: "person.text.rectangle"
        }
    }
    var detail: String {
        switch self {
        case .smartSession: "A focused mix of due, weak, visual, safety, and counseling questions"
        case .scientificToTrade: "Choose or recall a trade name"
        case .tradeToScientific: "Choose or recall the scientific name"
        case .classExamples: "Match classes to drug examples"
        case .drugUse: "Match drugs to their main uses"
        case .drugWarning: "Practice important warnings"
        case .imageQuiz: "Recognize package photos"
        case .counseling: "Recall, reveal, and self-rate"
        case .weakDrug: "Adapt to weak mastery checks"
        case .dueReview: "Review cards scheduled for today"
        case .systemSpecific: "Five questions from one system"
        case .casePractice: "Educational recall cases"
        }
    }
}

enum PracticeGenerator {
    static let questionCount = 5

    static func generate(mode: PracticeMode, drugs: [Drug], chapter: Chapter? = nil, cases: [PracticeCase] = StarterContent.cases) -> [PracticeQuestion] {
        let known = drugs.filter { !$0.isUnknown }
        if mode == .casePractice {
            guard !cases.isEmpty else { return [] }
            return (0..<questionCount).map { index in
                let item = cases[index % cases.count]
                return PracticeQuestion(
                    drugID: known.first(where: { $0.scientificName.localizedCaseInsensitiveCompare(item.relatedScientificName) == .orderedSame })?.id,
                    drugName: item.relatedScientificName,
                    prompt: item.prompt,
                    correctAnswer: item.expectedIdea,
                    explanation: item.expectedIdea,
                    questionType: .casePractice,
                    interaction: .recall,
                    caseID: item.id,
                    difficulty: difficulty(for: index),
                    learningObjective: "Apply a saved drug fact to a short patient situation",
                    sourceField: "case"
                )
            }
        }
        var eligible = known.filter { chapter == nil || $0.chapter == chapter }
        if mode == .weakDrug {
            let weak = eligible.filter { $0.confidenceLevel == .weak || $0.isConfusing || !$0.isMastered }
            if !weak.isEmpty { eligible = weak }
        }
        if mode == .dueReview {
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.startOfDay(for: .now)) ?? .now
            eligible = eligible.filter { $0.nextReviewDate < tomorrow }
        }
        if mode == .imageQuiz { eligible = eligible.filter { !$0.packageImages.isEmpty } }
        if mode == .classExamples { eligible = eligible.filter { !$0.drugClass.trimmed.isEmpty } }
        guard !eligible.isEmpty else { return [] }
        eligible.sort {
            if $0.masteryCount != $1.masteryCount { return $0.masteryCount < $1.masteryCount }
            if $0.nextReviewDate != $1.nextReviewDate { return $0.nextReviewDate < $1.nextReviewDate }
            return $0.displayName.localizedCaseInsensitiveCompare($1.displayName) == .orderedAscending
        }
        return (0..<questionCount).map { index in
            QuestionQualityValidator.sanitized(
                makeQuestion(mode: mode, drug: eligible[index % eligible.count], all: known, index: index)
            )
        }
    }

    private static func makeQuestion(mode: PracticeMode, drug: Drug, all: [Drug], index: Int) -> PracticeQuestion {
        let difficulty = difficulty(for: index)
        let resolvedMode: PracticeMode
        if mode == .weakDrug {
            if !drug.masteryScientificName { resolvedMode = .tradeToScientific }
            else if !drug.masteryTradeName { resolvedMode = .scientificToTrade }
            else if !drug.masteryClass && !drug.drugClass.trimmed.isEmpty { resolvedMode = .classExamples }
            else if !drug.masteryUse { resolvedMode = .drugUse }
            else if !drug.masteryWarning { resolvedMode = .drugWarning }
            else { resolvedMode = .counseling }
        } else if mode == .smartSession || mode == .systemSpecific || mode == .dueReview {
            let rotation: [PracticeMode] = drug.packageImages.isEmpty
                ? [.tradeToScientific, .classExamples, .drugUse, .drugWarning, .counseling]
                : [.tradeToScientific, .imageQuiz, .drugUse, .drugWarning, .counseling]
            resolvedMode = rotation[index % rotation.count]
        } else { resolvedMode = mode }

        switch resolvedMode {
        case .scientificToTrade:
            return PracticeQuestion(
                drugID: drug.id,
                drugName: drug.displayName,
                prompt: "Name one brand of \(drug.scientificName).",
                correctAnswer: drug.firstTradeName,
                explanation: "A saved local brand for \(drug.scientificName) is \(drug.firstTradeName).",
                questionType: .tradeName,
                interaction: .textEntry,
                difficulty: difficulty,
                learningObjective: "Recall brand-to-ingredient identity",
                sourceField: "products.tradeName",
                acceptedAnswers: drug.effectiveTradeNames
            )
        case .tradeToScientific:
            return PracticeQuestion(
                drugID: drug.id,
                drugName: drug.displayName,
                prompt: "What is the active ingredient in \(drug.firstTradeName)?",
                correctAnswer: drug.scientificName,
                explanation: "\(drug.firstTradeName) is saved under \(drug.scientificName).",
                questionType: .scientificName,
                interaction: .textEntry,
                difficulty: difficulty,
                learningObjective: "Recall ingredient from a shelf brand",
                sourceField: "scientificName"
            )
        case .classExamples:
            return recallQuestion(
                drug: drug,
                prompt: "Recall one drug in the \(drug.drugClass) class.",
                answer: drug.displayName,
                type: .drugClass,
                difficulty: difficulty,
                objective: "Retrieve a class example without ambiguous options",
                source: "drugClass"
            )
        case .drugUse:
            let answer = drug.indications.first(where: { !$0.trimmed.isEmpty }) ?? "No verified indication is saved yet."
            let candidates = sameChapterCandidates(for: drug, in: all).compactMap { $0.indications.first }
            let choices = multipleChoice(correct: answer, candidates: candidates, index: index)
            return PracticeQuestion(
                drugID: drug.id,
                drugName: drug.displayName,
                prompt: "Which saved use belongs to \(drug.displayName)?",
                correctAnswer: answer,
                choices: choices,
                explanation: answer,
                questionType: .use,
                interaction: choices.isEmpty ? .recall : .multipleChoice,
                difficulty: difficulty,
                learningObjective: "Connect the active drug to its main indication",
                sourceField: "indications"
            )
        case .drugWarning:
            let answer = drug.warnings.first(where: { !$0.trimmed.isEmpty })
                ?? drug.contraindications.first(where: { !$0.trimmed.isEmpty })
                ?? "No verified warning is saved yet."
            return recallQuestion(
                drug: drug,
                prompt: "Before supplying \(drug.displayName), what key warning must you recall?",
                answer: answer,
                type: .warning,
                difficulty: difficulty,
                objective: "Retrieve the drug-specific safety cue",
                source: drug.warnings.isEmpty ? "contraindications" : "warnings"
            )
        case .imageQuiz:
            let choices = multipleChoice(
                correct: drug.displayName,
                candidates: sameChapterCandidates(for: drug, in: all).map(\.displayName),
                index: index
            )
            return PracticeQuestion(
                drugID: drug.id,
                drugName: drug.displayName,
                prompt: "Which active drug does this package belong to?",
                correctAnswer: drug.displayName,
                choices: choices,
                explanation: "This package is attached to the \(drug.displayName) profile.",
                questionType: .scientificName,
                interaction: choices.isEmpty ? .textEntry : .multipleChoice,
                imageData: drug.packageImages.first,
                difficulty: difficulty,
                learningObjective: "Recognize a shelf package and retrieve its active drug",
                sourceField: "packageImages"
            )
        case .counseling:
            let prompt: String
            let answer: String
            if let flashcard = drug.importedFlashcardPairs.first {
                prompt = flashcard.question
                answer = flashcard.answer
            } else {
                prompt = "Recall a patient counseling sentence for \(drug.displayName)."
                answer = drug.counselingSentence.isEmpty ? "Draft and verify a counseling sentence with your pharmacist." : drug.counselingSentence
            }
            return recallQuestion(
                drug: drug,
                prompt: prompt,
                answer: answer,
                type: .counseling,
                difficulty: difficulty,
                objective: "Practice a concise patient-facing explanation",
                source: "counseling"
            )
        case .smartSession, .weakDrug, .dueReview, .systemSpecific, .casePractice:
            return recallQuestion(
                drug: drug,
                prompt: "What is the most important fact you would use to identify \(drug.displayName)?",
                answer: drug.mustKnow.first ?? drug.indications.first ?? drug.drugClass,
                type: .use,
                difficulty: difficulty,
                objective: "Retrieve a high-value identifying fact",
                source: "mustKnow"
            )
        }
    }

    static func generatedReview(for drug: Drug) -> [PracticeQuestion] {
        Array(drug.generatedReviewQuestions.prefix(8)).map { item in
            let difficulty: QuestionDifficulty = switch item.difficulty.lowercased() {
            case "easy", "foundation": .foundation
            case "hard", "challenge": .challenge
            default: .application
            }
            return QuestionQualityValidator.sanitized(PracticeQuestion(
                drugID: drug.id,
                drugName: drug.displayName,
                prompt: item.prompt,
                correctAnswer: item.correctAnswer,
                choices: item.choices,
                explanation: item.explanation,
                questionType: item.questionType,
                interaction: item.interaction,
                imageData: item.questionType == .scientificName ? drug.packageImages.first : nil,
                difficulty: difficulty,
                learningObjective: "Recall a generated question from this saved profile",
                sourceField: item.relatedField
            ))
        }
    }

    private static func multipleChoice(correct: String, candidates: [String], index: Int) -> [String] {
        let unique = candidates.filter {
            !$0.trimmed.isEmpty
                && $0.count <= QuestionQualityValidator.maximumChoiceLength
                && $0.localizedCaseInsensitiveCompare(correct) != .orderedSame
        }
            .reduce(into: [String]()) { values, item in
                if !values.contains(where: { $0.localizedCaseInsensitiveCompare(item) == .orderedSame }) { values.append(item) }
            }
        guard unique.count >= 2, !correct.trimmed.isEmpty else { return [] }
        var values = Array(unique.prefix(3)).map(\.trimmed)
        values.insert(correct, at: index % (values.count + 1))
        let provisional = PracticeQuestion(
            drugID: nil,
            drugName: "",
            prompt: "Saved fact",
            correctAnswer: correct,
            choices: values,
            questionType: .use,
            interaction: .multipleChoice
        )
        return QuestionQualityValidator.isValid(provisional) ? values : []
    }

    private static func recallQuestion(
        drug: Drug,
        prompt: String,
        answer: String,
        type: QuestionType,
        difficulty: QuestionDifficulty,
        objective: String,
        source: String
    ) -> PracticeQuestion {
        PracticeQuestion(
            drugID: drug.id,
            drugName: drug.displayName,
            prompt: prompt,
            correctAnswer: answer,
            explanation: answer,
            questionType: type,
            interaction: .recall,
            difficulty: difficulty,
            learningObjective: objective,
            sourceField: source
        )
    }

    private static func sameChapterCandidates(for drug: Drug, in all: [Drug]) -> [Drug] {
        let local = all.filter { $0.id != drug.id && $0.chapter == drug.chapter }
        return local.count >= 2 ? local : all.filter { $0.id != drug.id }
    }

    private static func difficulty(for index: Int) -> QuestionDifficulty {
        switch index {
        case 0, 1: .foundation
        case 2, 3: .application
        default: .challenge
        }
    }
}

enum QuestionQualityValidator {
    static let maximumChoiceLength = 64

    static func isValid(_ question: PracticeQuestion) -> Bool {
        guard !question.prompt.trimmed.isEmpty, question.prompt.count <= 180, !question.correctAnswer.trimmed.isEmpty else { return false }
        if question.prompt.count >= 20,
           let promptLanguage = NLLanguageRecognizer.dominantLanguage(for: question.prompt),
           promptLanguage != .english {
            return false
        }
        guard question.interaction == .multipleChoice else { return true }
        guard (3...4).contains(question.choices.count) else { return false }
        guard question.choices.allSatisfy({ !$0.trimmed.isEmpty && $0.count <= maximumChoiceLength && !$0.contains("\n") }) else { return false }

        let normalized = question.choices.map(normalize)
        guard Set(normalized).count == normalized.count else { return false }
        guard normalized.filter({ $0 == normalize(question.correctAnswer) }).count == 1 else { return false }
        return languagesAreCoherent(question.choices, expectedFrom: question.correctAnswer)
    }

    static func sanitized(_ question: PracticeQuestion) -> PracticeQuestion {
        guard question.interaction == .multipleChoice, !isValid(question) else { return question }
        var safe = question
        safe.choices = []
        safe.interaction = .recall
        return safe
    }

    private static func normalize(_ value: String) -> String {
        value.trimmed
            .folding(options: [.caseInsensitive, .diacriticInsensitive], locale: .current)
            .replacingOccurrences(of: #"\s+"#, with: " ", options: .regularExpression)
    }

    private static func languagesAreCoherent(_ values: [String], expectedFrom answer: String) -> Bool {
        guard let expected = NLLanguageRecognizer.dominantLanguage(for: answer) else { return true }
        return values.allSatisfy { value in
            guard value.count >= 12, let detected = NLLanguageRecognizer.dominantLanguage(for: value) else { return true }
            return detected == expected
        }
    }
}

private extension Drug {
    var importedFlashcardPairs: [(question: String, answer: String)] {
        flashcards.compactMap { raw in
            let parts = raw.components(separatedBy: "\t")
            guard parts.count >= 2 else { return nil }
            return (parts[0], parts.dropFirst().joined(separator: "\t"))
        }
    }
}

@MainActor
enum LearningProgressService {
    static func profile(in context: ModelContext) throws -> LearningProfile {
        if let profile = try context.fetch(FetchDescriptor<LearningProfile>()).first { return profile }
        let profile = LearningProfile(); context.insert(profile); return profile
    }

    @discardableResult
    static func record(result: PracticeSessionResult, context: ModelContext, now: Date = .now, calendar: Calendar = .current) throws -> LearningProfile {
        let profile = try profile(in: context)
        let day = calendar.startOfDay(for: now)
        let activities = try context.fetch(FetchDescriptor<DailyActivity>())
        let activity = activities.first(where: { calendar.isDate($0.day, inSameDayAs: day) }) ?? {
            let value = DailyActivity(day: day); context.insert(value); return value
        }()
        activity.sessionsCompleted += 1
        activity.questionsAnswered += result.questionCount
        activity.correctAnswers += result.correctCount
        activity.missionCompleted = activity.sessionsCompleted >= 1

        if let last = profile.lastActivityDate {
            let lastDay = calendar.startOfDay(for: last)
            if calendar.isDate(lastDay, inSameDayAs: day) {
                if profile.currentStreak == 0 { profile.currentStreak = 1 }
            } else if calendar.date(byAdding: .day, value: 1, to: lastDay).map({ calendar.isDate($0, inSameDayAs: day) }) == true {
                profile.currentStreak += 1
            } else {
                profile.currentStreak = 1
            }
        } else { profile.currentStreak = 1 }
        profile.longestStreak = max(profile.longestStreak, profile.currentStreak)
        profile.completedSessions += 1
        profile.completedQuestions += result.questionCount
        profile.correctAnswers += result.correctCount
        profile.lastActivityDate = now
        award("First Five", when: profile.completedQuestions >= 5, profile: profile)
        award("Three Day Streak", when: profile.currentStreak >= 3, profile: profile)
        award("Practice 25", when: profile.completedQuestions >= 25, profile: profile)
        let logs = try context.fetch(FetchDescriptor<ReviewLog>())
        award("Recovered 10 forgotten facts", when: logs.filter { $0.wasCorrect && $0.scoreAfter > $0.scoreBefore }.count >= 10, profile: profile)
        award("Completed 7 counseling practices", when: logs.filter { $0.wasCorrect && $0.questionType == .counseling }.count >= 7, profile: profile)
        award("Solved 5 cases without hints", when: logs.filter { $0.wasCorrect && $0.questionType == .casePractice }.count >= 5, profile: profile)
        let drugs = try context.fetch(FetchDescriptor<Drug>()).filter { !$0.isUnknown && !$0.drugClass.trimmed.isEmpty }
        let masteredClass = Dictionary(grouping: drugs, by: { $0.drugClass.lowercased() }).values.contains { !$0.isEmpty && $0.allSatisfy(\.isMastered) }
        award("Mastered an entire class", when: masteredClass, profile: profile)
        try context.save()
        return profile
    }

    private static func award(_ badge: String, when condition: Bool, profile: LearningProfile) {
        if condition, !profile.badges.contains(badge) { profile.badges.append(badge) }
    }
}

enum FocusAction: String, Equatable {
    case addDrug
    case reviewDue
    case practiceWeak
    case finishShift
}

struct FocusRecommendation: Equatable {
    var action: FocusAction
    var title: String
    var subtitle: String
    var icon: String
}

enum FocusModeEngine {
    static func recommendation(drugs: [Drug], activeShift: ShiftLog?, now: Date = .now, calendar: Calendar = .current) -> FocusRecommendation {
        let known = drugs.filter { !$0.isUnknown }
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: now)) ?? now
        let due = known.filter { $0.nextReviewDate < tomorrow }
        let weak = known.filter { $0.confidenceLevel == .weak || $0.isConfusing || !$0.isMastered }
        if known.isEmpty { return .init(action: .addDrug, title: "Add one drug", subtitle: "Start with a package you saw today.", icon: "plus.circle.fill") }
        if !due.isEmpty { return .init(action: .reviewDue, title: "Review \(due.count) due drug\(due.count == 1 ? "" : "s")", subtitle: "One five-question session. Nothing else.", icon: "calendar.badge.clock") }
        if !weak.isEmpty { return .init(action: .practiceWeak, title: "Practice weak drugs", subtitle: "Strengthen the checks that need attention.", icon: "bolt.heart.fill") }
        if activeShift != nil { return .init(action: .finishShift, title: "Finish shift reflection", subtitle: "Capture what you learned before leaving.", icon: "checkmark.circle.fill") }
        return .init(action: .addDrug, title: "Add today’s drug", subtitle: "Keep your library connected to the shelf.", icon: "plus.circle.fill")
    }
}
