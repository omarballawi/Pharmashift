import XCTest
@testable import PharmaShift

@MainActor
final class ReportBuilderTests: XCTestCase {
    func testReportIncludesAggregatesWithoutRepeatedSafetyNotice() {
        let now = Date.now
        let drug = Drug(scientificName: "Metformin", chapter: .endocrine, dosageForms: ["Tablet"], counselingSentence: "Take with food if instructed.", dateAdded: now)
        drug.masteryScientificName = true
        drug.masteryTradeName = true
        drug.masteryClass = true
        drug.masteryUse = true
        drug.masteryWarning = true
        drug.masteryCounseling = true
        drug.recalculateConfidence()
        let shift = ShiftLog(date: now, chapterFocus: .endocrine)
        shift.whatILearned = "Compared immediate and modified release forms."
        shift.finish(at: now)
        let report = TrainingReport(periodStart: now, periodEnd: now)

        ReportBuilder.populate(report, drugs: [drug], reviews: [], shifts: [shift], encounters: [])
        let output = ReportBuilder.text(for: report)

        XCTAssertTrue(output.contains("Metformin"))
        XCTAssertTrue(output.contains("Endocrine"))
        XCTAssertFalse(output.contains("EDUCATIONAL USE NOTICE"))
    }
}
