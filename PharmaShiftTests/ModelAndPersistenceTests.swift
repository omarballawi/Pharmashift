import SwiftData
import UIKit
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

    func testArabicSearchAndFutureReadyDefaults() {
        let drug = Drug(scientificName: "Enalapril", chapter: .cardiovascular)
        drug.arabicExplanation = "يستخدم لعلاج ارتفاع ضغط الدم"
        drug.arabicCounseling = "خذ الدواء في نفس الوقت يومياً"

        XCTAssertTrue(DrugFilter(searchText: "ضغط الدم").matches(drug))
        XCTAssertEqual(drug.halfLifeBand, .unknown)
        XCTAssertEqual(drug.prodrugStatus, .unknown)
        XCTAssertEqual(drug.excretionRoute, .unknown)
        XCTAssertFalse(drug.isImported)
        XCTAssertTrue(drug.isIncomplete)
    }

    func testExpandedLibraryFilters() {
        let drug = Drug(scientificName: "Test", chapter: .respiratory, imageData: nil, isConfusing: true)
        drug.importedSourceName = "DailyMed"
        let filter = DrugFilter(weakOnly: true, incompleteOnly: true, missingImageOnly: true, importedOnly: true)
        XCTAssertTrue(filter.matches(drug))
    }

    func testSystemDashboardMetricsUsesAllSixMasteryChecks() {
        let first = Drug(scientificName: "A", chapter: .cardiovascular)
        first.masteryScientificName = true
        first.masteryTradeName = true
        first.masteryClass = true
        let second = Drug(scientificName: "B", chapter: .cardiovascular)
        second.masteryScientificName = true
        second.masteryTradeName = true
        second.masteryClass = true
        second.masteryUse = true
        second.masteryWarning = true
        second.masteryCounseling = true
        second.recalculateConfidence()

        let metrics = SystemDashboardMetrics(chapter: .cardiovascular, drugs: [first, second], dueCount: 1)
        XCTAssertEqual(metrics.masteredCount, 1)
        XCTAssertEqual(metrics.masteryProgress, 0.75, accuracy: 0.001)
        XCTAssertEqual(metrics.dueCount, 1)
    }

    func testImagePipelineCreatesCompressedCardAndThumbnail() throws {
        let image = UIGraphicsImageRenderer(size: CGSize(width: 2400, height: 1800)).image { context in
            UIColor.systemTeal.setFill()
            context.cgContext.fill(CGRect(x: 0, y: 0, width: 2400, height: 1800))
        }
        let payload = try ImageCompressor.payload(from: image)
        let full = try XCTUnwrap(UIImage(data: payload.imageData))
        let thumbnail = try XCTUnwrap(UIImage(data: payload.thumbnailData))
        XCTAssertLessThanOrEqual(max(full.size.width, full.size.height), 1600)
        XCTAssertEqual(thumbnail.size.width, 256)
        XCTAssertEqual(thumbnail.size.height, 256)
    }

    func testFutureReadyFieldsPersist() throws {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Drug.self, ReviewLog.self, ShiftLog.self, EncounterNote.self, TrainingReport.self, configurations: configuration)
        let drug = Drug(scientificName: "Ramipril", chapter: .cardiovascular)
        drug.mechanism = "ACE inhibition"
        drug.halfLifeBand = .long
        drug.arabicExplanation = "دواء لتدريب البطاقة"
        drug.sourceURL = "https://example.test/ramipril"
        drug.importedSourceName = "Mock provider"
        container.mainContext.insert(drug)
        try container.mainContext.save()

        let saved = try XCTUnwrap(container.mainContext.fetch(FetchDescriptor<Drug>()).first)
        XCTAssertEqual(saved.mechanism, "ACE inhibition")
        XCTAssertEqual(saved.halfLifeBand, .long)
        XCTAssertEqual(saved.arabicExplanation, "دواء لتدريب البطاقة")
        XCTAssertTrue(saved.isImported)
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
