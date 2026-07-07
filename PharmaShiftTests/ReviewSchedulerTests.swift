import XCTest
@testable import PharmaShift

@MainActor
final class ReviewSchedulerTests: XCTestCase {
    private let calendar = Calendar(identifier: .gregorian)

    func testWrongSchedulesTomorrowAndClearsDomainMastery() {
        let now = Date(timeIntervalSince1970: 1_750_000_000)
        let drug = Drug(scientificName: "Test")
        drug.masteryWarning = true
        drug.correctStreak = 2
        let scheduler = ReviewScheduler()

        let log = scheduler.apply(rating: .wrong, questionType: .warning, to: drug, now: now, calendar: calendar)

        XCTAssertFalse(drug.masteryWarning)
        XCTAssertEqual(drug.correctStreak, 0)
        XCTAssertEqual(calendar.dateComponents([.day], from: calendar.startOfDay(for: now), to: drug.nextReviewDate).day, 1)
        XCTAssertFalse(log.wasCorrect)
    }

    func testCorrectIntervalsProgressSevenFourteenThirtyDays() {
        let now = Date(timeIntervalSince1970: 1_750_000_000)
        let drug = Drug(scientificName: "Test")
        let scheduler = ReviewScheduler()

        _ = scheduler.apply(rating: .correct, questionType: .drugClass, to: drug, now: now, calendar: calendar)
        XCTAssertEqual(scheduler.lastIntervalDays, 7)
        _ = scheduler.apply(rating: .correct, questionType: .use, to: drug, now: now, calendar: calendar)
        XCTAssertEqual(scheduler.lastIntervalDays, 14)
        _ = scheduler.apply(rating: .correct, questionType: .warning, to: drug, now: now, calendar: calendar)
        XCTAssertEqual(scheduler.lastIntervalDays, 30)
    }

    func testPartlyCorrectPreservesMasteryAndSchedulesThreeDays() {
        let drug = Drug(scientificName: "Test")
        drug.masteryUse = true
        let scheduler = ReviewScheduler()
        _ = scheduler.apply(rating: .partlyCorrect, questionType: .use, to: drug, calendar: calendar)
        XCTAssertTrue(drug.masteryUse)
        XCTAssertEqual(scheduler.lastIntervalDays, 3)
    }
}
