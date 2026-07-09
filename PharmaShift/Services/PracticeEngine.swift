import Foundation
import SwiftData

enum PracticeMode: String, CaseIterable, Identifiable, Codable {
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
                return PracticeQuestion(drugID: known.first(where: { $0.scientificName.localizedCaseInsensitiveCompare(item.relatedScientificName) == .orderedSame })?.id,
                                        drugName: item.relatedScientificName, prompt: item.prompt, correctAnswer: item.expectedIdea,
                                        explanation: item.expectedIdea, questionType: .casePractice, interaction: .recall, caseID: item.id)
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
        if mode == .imageQuiz { eligible = eligible.filter { $0.imageData != nil } }
        guard !eligible.isEmpty else { return [] }
        eligible.sort {
            if $0.masteryCount != $1.masteryCount { return $0.masteryCount < $1.masteryCount }
            if $0.nextReviewDate != $1.nextReviewDate { return $0.nextReviewDate < $1.nextReviewDate }
            return $0.displayName.localizedCaseInsensitiveCompare($1.displayName) == .orderedAscending
        }
        return (0..<questionCount).map { index in
            makeQuestion(mode: mode, drug: eligible[index % eligible.count], all: known, index: index)
        }
    }

    private static func makeQuestion(mode: PracticeMode, drug: Drug, all: [Drug], index: Int) -> PracticeQuestion {
        let resolvedMode: PracticeMode
        if mode == .weakDrug {
            if !drug.masteryScientificName { resolvedMode = .tradeToScientific }
            else if !drug.masteryTradeName { resolvedMode = .scientificToTrade }
            else if !drug.masteryClass { resolvedMode = .classExamples }
            else if !drug.masteryUse { resolvedMode = .drugUse }
            else if !drug.masteryWarning { resolvedMode = .drugWarning }
            else { resolvedMode = .counseling }
        } else if mode == .systemSpecific || mode == .dueReview {
            resolvedMode = [.tradeToScientific, .classExamples, .drugUse, .drugWarning, .counseling][index % 5]
        } else { resolvedMode = mode }

        let prompt: String
        let answer: String
        let questionType: QuestionType
        let candidates: [String]
        let image: Data?
        switch resolvedMode {
        case .scientificToTrade:
            prompt = "Choose a trade name for \(drug.scientificName)."; answer = drug.firstTradeName; questionType = .tradeName
            candidates = all.compactMap(\.tradeNames.first); image = nil
        case .tradeToScientific:
            prompt = "What is the scientific name for \(drug.firstTradeName)?"; answer = drug.scientificName; questionType = .scientificName
            candidates = all.map(\.scientificName); image = nil
        case .classExamples:
            prompt = "Which drug is an example of \(drug.drugClass.isEmpty ? "this recorded class" : drug.drugClass)?"; answer = drug.displayName; questionType = .drugClass
            candidates = all.map(\.displayName); image = nil
        case .drugUse:
            prompt = "What is a main use of \(drug.displayName)?"; answer = drug.indications.first ?? "Complete the indication with your pharmacist."; questionType = .use
            candidates = all.compactMap(\.indications.first); image = nil
        case .drugWarning:
            prompt = "What is an important warning for \(drug.displayName)?"; answer = drug.warnings.first ?? "Complete the warning with your pharmacist."; questionType = .warning
            candidates = all.compactMap(\.warnings.first); image = nil
        case .imageQuiz:
            prompt = "Which drug package is shown?"; answer = drug.displayName; questionType = .scientificName
            candidates = all.map(\.displayName); image = drug.imageData
        case .counseling:
            if let flashcard = drug.importedFlashcardPairs.first {
                prompt = flashcard.question
                answer = flashcard.answer
            } else {
                prompt = "Recall a patient counseling sentence for \(drug.displayName)."
                answer = drug.counselingSentence.isEmpty ? "Draft and verify a counseling sentence with your pharmacist." : drug.counselingSentence
            }
            questionType = .counseling; candidates = []; image = nil
        case .weakDrug, .dueReview, .systemSpecific, .casePractice:
            fatalError("Resolved above")
        }
        let choices = multipleChoice(correct: answer, candidates: candidates, index: index)
        return PracticeQuestion(drugID: drug.id, drugName: drug.displayName, prompt: prompt, correctAnswer: answer,
                                choices: choices, explanation: answer, questionType: questionType,
                                interaction: choices.isEmpty ? .recall : .multipleChoice, imageData: image)
    }

    private static func multipleChoice(correct: String, candidates: [String], index: Int) -> [String] {
        let unique = candidates.filter { !$0.trimmed.isEmpty && $0.localizedCaseInsensitiveCompare(correct) != .orderedSame }
            .reduce(into: [String]()) { values, item in
                if !values.contains(where: { $0.localizedCaseInsensitiveCompare(item) == .orderedSame }) { values.append(item) }
            }
        guard unique.count >= 2, !correct.trimmed.isEmpty else { return [] }
        var values = Array(unique.prefix(3))
        values.insert(correct, at: index % (values.count + 1))
        return values
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
