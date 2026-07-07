import Foundation
import Observation

@MainActor
@Observable
final class ReviewScheduler {
    private(set) var lastIntervalDays: Int = 0

    func apply(
        rating: ReviewRating,
        questionType: QuestionType,
        to drug: Drug,
        now: Date = .now,
        calendar: Calendar = .current,
        caseID: String? = nil
    ) -> ReviewLog {
        let scoreBefore = drug.masteryCount
        let days: Int

        switch rating {
        case .wrong:
            drug.correctStreak = 0
            drug.setMastery(for: questionType, value: false)
            days = 1
        case .partlyCorrect:
            drug.correctStreak = 0
            drug.recalculateConfidence()
            days = 3
        case .correct:
            drug.correctStreak += 1
            drug.setMastery(for: questionType, value: true)
            days = switch drug.correctStreak {
            case 1: 7
            case 2: 14
            default: 30
            }
        }

        drug.lastReviewed = now
        let start = calendar.startOfDay(for: now)
        drug.nextReviewDate = calendar.date(byAdding: .day, value: days, to: start) ?? now
        lastIntervalDays = days

        return ReviewLog(
            drug: drug,
            drugNameSnapshot: drug.displayName,
            date: now,
            questionType: questionType,
            rating: rating,
            scoreBefore: scoreBefore,
            scoreAfter: drug.masteryCount,
            caseID: caseID
        )
    }

    func isDue(_ drug: Drug, now: Date = .now, calendar: Calendar = .current) -> Bool {
        drug.nextReviewDate < calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: now))!
    }
}
