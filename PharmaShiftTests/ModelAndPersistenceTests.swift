import SwiftData
import XCTest
@testable import PharmaShift

@MainActor
final class ModelAndPersistenceTests: XCTestCase {
    func testMasteryRequiresAllSixChecks() {
        let drug = Drug(scientificName: "Test")
        drug.masteryScientificName = true
        drug.masteryTradeName = true
        drug.masteryClass = true
        drug.masteryUse = true
        drug.masteryWarning = true
        drug.recalculateConfidence()
        XCTAssertEqual(drug.masteryCount, 5)
        XCTAssertFalse(drug.isMastered)
        XCTAssertEqual(drug.confidenceLevel, .strong)

        drug.masteryCounseling = true
        drug.recalculateConfidence()
        XCTAssertTrue(drug.isMastered)
        XCTAssertEqual(drug.confidenceLevel, .mastered)
    }

    func testSeenCountOnlyIncrementsOncePerDay() {
        let calendar = Calendar(identifier: .gregorian)
        let day = Date(timeIntervalSince1970: 1_750_000_000)
        let drug = Drug(scientificName: "Test", timesSeen: 0, lastSeenDate: nil)
        drug.markSeen(on: day, calendar: calendar)
        drug.markSeen(on: day.addingTimeInterval(60), calendar: calendar)
        XCTAssertEqual(drug.timesSeen, 1)
    }

    func testStarterImportIsIdempotent() throws {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Drug.self, ReviewLog.self, ShiftLog.self, EncounterNote.self, TrainingReport.self, configurations: configuration)
        let first = try StarterContent.importIfNeeded(into: container.mainContext)
        let second = try StarterContent.importIfNeeded(into: container.mainContext)
        XCTAssertEqual(first, 12)
        XCTAssertEqual(second, 0)
        XCTAssertEqual(try container.mainContext.fetchCount(FetchDescriptor<Drug>()), 12)
    }

    func testPrivacyValidatorFindsPhoneAndEmail() {
        XCTAssertTrue(PrivacyValidator.containsObviousIdentifier("Call 07701234567"))
        XCTAssertTrue(PrivacyValidator.containsObviousIdentifier("student@example.com"))
        XCTAssertFalse(PrivacyValidator.containsObviousIdentifier("Observed inhaler counseling under supervision"))
    }

    func testCombinedDrugFilters() {
        let drug = Drug(scientificName: "Salbutamol", tradeNames: ["Ventolin"], chapter: .respiratory, drugClass: "SABA", shelfLocation: "A3", nextReviewDate: .distantPast)
        let matching = DrugFilter(searchText: "vent", chapter: Chapter.respiratory.rawValue, drugClass: "saba", shelf: "a3", dueOnly: true)
        XCTAssertTrue(matching.matches(drug))
        var rejected = matching
        rejected.chapter = Chapter.endocrine.rawValue
        XCTAssertFalse(rejected.matches(drug))
    }

    func testIncompleteShiftRestoresAndDeletedDrugLeavesReviewSnapshot() throws {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Drug.self, ReviewLog.self, ShiftLog.self, EncounterNote.self, TrainingReport.self, configurations: configuration)
        let context = container.mainContext
        let drug = Drug(scientificName: "Test Drug")
        let log = ReviewLog(drug: drug, drugNameSnapshot: drug.displayName, questionType: .use, rating: .correct, scoreBefore: 0, scoreAfter: 1)
        let shift = ShiftLog(chapterFocus: .other)
        context.insert(drug); context.insert(log); context.insert(shift)
        try context.save()

        XCTAssertEqual(try context.fetch(FetchDescriptor<ShiftLog>()).filter { !$0.isCompleted }.count, 1)
        context.delete(drug)
        try context.save()
        let retainedLog = try XCTUnwrap(context.fetch(FetchDescriptor<ReviewLog>()).first)
        XCTAssertEqual(retainedLog.drugNameSnapshot, "Test Drug")
        XCTAssertNil(retainedLog.drug)
    }
}
