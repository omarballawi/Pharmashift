import XCTest
@testable import PharmaShift

@MainActor
final class DrugImportServiceTests: XCTestCase {
    func testSPLParserMapsOfficialLOINCSectionsAndConservativePK() throws {
        let xml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <document xmlns="urn:hl7-org:v3">
          <component><structuredBody>
            <component><section><code code="34067-9"/><text><paragraph>Used for type 2 diabetes. Onset is 30 minutes. Duration is 12 hours.</paragraph></text></section></component>
            <component><section><code code="34068-7"/><text><paragraph>Take with meals.</paragraph></text></section></component>
            <component><section><code code="34070-3"/><text><paragraph>Severe renal failure.</paragraph></text></section></component>
            <component><section><code code="43685-7"/><text><paragraph>Monitor for lactic acidosis.</paragraph></text></section></component>
            <component><section><code code="34084-4"/><text><paragraph>Nausea and diarrhea.</paragraph></text></section></component>
            <component><section><code code="34073-7"/><text><paragraph>Alcohol may increase risk.</paragraph></text></section></component>
            <component><section><code code="43679-0"/><text><paragraph>Reduces hepatic glucose production.</paragraph></text></section></component>
            <component><section><code code="43682-4"/><text><paragraph>The terminal half-life is 6.2 hours.</paragraph></text></section></component>
            <component><section><code code="88828-9"/><text><paragraph>Adjust for renal impairment.</paragraph></text></section></component>
            <component><section><code code="88829-5"/><text><paragraph>Avoid in severe hepatic impairment.</paragraph></text></section></component>
            <component><section><code code="42228-7"/><text><paragraph>Use in pregnancy only when appropriate.</paragraph></text></section></component>
          </structuredBody></component>
          <manufacturedProduct><manufacturedMaterial><name>Glucophage</name><formCode displayName="Tablet"/><strength value="500 mg"/><asEntityWithGeneric><genericMedicine><name>Metformin hydrochloride</name></genericMedicine></asEntityWithGeneric></manufacturedMaterial></manufacturedProduct>
        </document>
        """
        let result = try SPLParser.parse(data: Data(xml.utf8), labelID: "abc")
        XCTAssertEqual(result.scientificName, "Metformin hydrochloride")
        XCTAssertEqual(result.tradeNames, ["Glucophage"])
        XCTAssertEqual(result.dosageForms, ["Tablet"])
        XCTAssertEqual(result.strengths, ["500 mg"])
        XCTAssertEqual(result.halfLifeHours, 6.2, accuracy: 0.001)
        XCTAssertEqual(result.onsetMinutes, 30)
        XCTAssertEqual(result.durationHours, 12)
        XCTAssertTrue(result.rawSectionText.keys.contains("34067-9"))
        XCTAssertEqual(result.sourceName, "DailyMed")
    }

    func testNumericExtractionRejectsRangesAndConflictingMeasurements() {
        XCTAssertNil(ConservativeNumericExtractor.halfLifeHours(from: "The half-life is 5 to 8 hours."))
        XCTAssertNil(ConservativeNumericExtractor.halfLifeHours(from: "Half-life is 6 hours; a second half-life is 9 hours."))
        XCTAssertNil(ConservativeNumericExtractor.halfLifeHours(from: "Pharmacokinetic information is unavailable."))
        XCTAssertEqual(ConservativeNumericExtractor.halfLifeHours(from: "The half-life is 90 minutes."), 1.5)
    }

    func testSelectiveImportDefaultsToEmptyFieldsAndPreservesProtectedContent() {
        let drug = Drug(scientificName: "Existing", imageData: Data([7]))
        drug.notes = "personal"
        drug.arabicExplanation = "شرح شخصي"
        drug.masteryScientificName = true
        drug.warnings = []
        let info = makeInfo()
        let defaults = DrugImportApplier.defaultSelection(info: info, drug: drug)
        XCTAssertFalse(defaults.contains(.scientificName))
        XCTAssertTrue(defaults.contains(.warnings))

        DrugImportApplier.apply(info, selection: ImportSelection(fields: [.scientificName, .warnings, .halfLifeHours]), to: drug)
        XCTAssertEqual(drug.scientificName, "Imported name")
        XCTAssertEqual(drug.warnings, ["Imported warning"])
        XCTAssertEqual(drug.halfLifeHours, 4)
        XCTAssertEqual(drug.imageData, Data([7]))
        XCTAssertEqual(drug.notes, "personal")
        XCTAssertEqual(drug.arabicExplanation, "شرح شخصي")
        XCTAssertTrue(drug.masteryScientificName)
        XCTAssertEqual(drug.importedSourceName, "DailyMed")
        XCTAssertTrue(drug.sourceURL.contains("setid=test"))
    }

    func testMockProviderIsDeterministic() async throws {
        let search = DrugSearchResult(genericName: "Imported name", brandNames: [], formulation: "Tablet", labelTitle: "IMPORTED NAME TABLET", updateDate: nil, labelID: "test")
        let provider = MockDrugInfoProvider(results: [search], details: ["test": makeInfo()])
        XCTAssertEqual(try await provider.searchDrug(query: "Imported").map(\.labelID), ["test"])
        XCTAssertEqual(try await provider.fetchDrugDetails(id: "test").scientificName, "Imported name")
    }

    private func makeInfo() -> ImportedDrugInfo {
        ImportedDrugInfo(
            scientificName: "Imported name", tradeNames: ["Brand"], dosageForms: ["Tablet"], strengths: ["10 mg"],
            indications: ["Imported use"], howToTake: "Once daily", commonSideEffects: ["Nausea"], warnings: ["Imported warning"],
            mechanism: "Mechanism", contraindications: ["Contraindication"], interactions: ["Interaction"], halfLifeText: "Half-life is 4 hours",
            halfLifeHours: 4, onsetMinutes: nil, durationHours: nil, renalCaution: "Renal", hepaticCaution: "Hepatic",
            pregnancyCaution: "Pregnancy", counselingSentence: "Counseling", rawSectionText: [:], sourceName: "DailyMed",
            sourceURL: URL(string: "https://dailymed.nlm.nih.gov/dailymed/drugInfo.cfm?setid=test")!, sourceUpdatedAt: nil
        )
    }
}
