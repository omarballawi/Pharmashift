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
        updateMemoryItem(for: questionType, rating: rating, drug: drug, now: now, fallbackDays: days, calendar: calendar)
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

    private func updateMemoryItem(for field: QuestionType, rating: ReviewRating, drug: Drug, now: Date, fallbackDays: Int, calendar: Calendar) {
        var items = drug.memoryItems
        guard let index = items.firstIndex(where: { $0.field == field }) else { return }
        var item = items[index]
        let elapsedDays = max(0, item.lastReviewed.map { now.timeIntervalSince($0) / 86_400 } ?? 0)
        item.retrievability = exp(-elapsedDays / max(item.stabilityDays, 0.1))
        item.lastReviewed = now
        switch rating {
        case .wrong:
            item.lapses += 1
            item.repetitions = 0
            item.difficulty = min(10, item.difficulty + 0.8)
            item.stabilityDays = max(0.25, item.stabilityDays * 0.45)
        case .partlyCorrect:
            item.repetitions += 1
            item.difficulty = min(10, item.difficulty + 0.15)
            item.stabilityDays = max(1, item.stabilityDays * 1.35)
        case .correct:
            item.repetitions += 1
            item.difficulty = max(1, item.difficulty - 0.2)
            let growth = 2.2 + (10 - item.difficulty) * 0.08
            item.stabilityDays = max(Double(fallbackDays), item.stabilityDays * growth)
        }
        item.retrievability = 1
        let interval = max(1, Int(item.stabilityDays.rounded()))
        item.dueDate = calendar.date(byAdding: .day, value: interval, to: calendar.startOfDay(for: now)) ?? now
        items[index] = item
        drug.memoryItems = items
        drug.nextReviewDate = item.dueDate
    }

    func isDue(_ drug: Drug, now: Date = .now, calendar: Calendar = .current) -> Bool {
        drug.nextReviewDate < calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: now))!
    }
}
