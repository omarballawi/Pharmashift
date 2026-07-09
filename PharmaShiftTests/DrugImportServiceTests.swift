import XCTest
@testable import PharmaShift

@MainActor
final class DrugImportServiceTests: XCTestCase {
    func testOCRCandidateExtractionIsConservative() {
        let candidate = OCRService.candidate(from: [
            "Coversyl",
            "Perindopril arginine",
            "5 mg tablets",
            "Servier"
        ])
        XCTAssertEqual(candidate.possibleTradeName, "Coversyl")
        XCTAssertEqual(candidate.possibleScientificName, "Perindopril arginine")
        XCTAssertEqual(candidate.possibleStrength, "5 mg tablets")
        XCTAssertEqual(candidate.possibleDosageForm, "5 mg tablets")
        XCTAssertTrue(candidate.rawText.contains("Coversyl"))
    }

    func testSPLParserBuildsTrustedPacketAndTrimsUsefulSections() throws {
        let xml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <document xmlns="urn:hl7-org:v3">
          <component><structuredBody>
            <component><section><code code="34067-9"/><text><paragraph>Used for type 2 diabetes.</paragraph></text></section></component>
            <component><section><code code="34068-7"/><text><paragraph>Take with meals.</paragraph></text></section></component>
            <component><section><code code="34070-3"/><text><paragraph>Severe renal failure.</paragraph></text></section></component>
            <component><section><code code="43685-7"/><text><paragraph>Monitor for lactic acidosis.</paragraph></text></section></component>
            <component><section><code code="34084-4"/><text><paragraph>Nausea and diarrhea.</paragraph></text></section></component>
            <component><section><code code="34073-7"/><text><paragraph>Alcohol may increase risk.</paragraph></text></section></component>
            <component><section><code code="43682-4"/><text><paragraph>The terminal half-life is 6.2 hours.</paragraph></text></section></component>
          </structuredBody></component>
          <manufacturedProduct><manufacturedMaterial><name>Glucophage</name><formCode displayName="Tablet"/><routeCode displayName="Oral"/><asEntityWithGeneric><genericMedicine><name>Metformin hydrochloride</name></genericMedicine></asEntityWithGeneric></manufacturedMaterial></manufacturedProduct>
        </document>
        """
        let packet = try SPLParser.parsePacket(data: Data(xml.utf8), labelID: "abc")
        XCTAssertEqual(packet.sourceName, "DailyMed")
        XCTAssertTrue(packet.sourceURL.contains("setid=abc"))
        XCTAssertEqual(packet.indicationsText, "Used for type 2 diabetes.")
        XCTAssertEqual(packet.dosageFormsText, "Tablet")
        XCTAssertEqual(packet.routeText, "Oral")
        XCTAssertEqual(packet.activeIngredientText, "Metformin hydrochloride")
    }

    func testTrustedPacketExtractorMarksTruncation() {
        let long = String(repeating: "Long warning sentence. ", count: 300)
        let packet = TrustedDrugSourcePacketExtractor.packet(sourceName: "Test", sourceURL: "https://example.test", sections: ["warnings": long])
        XCTAssertTrue(packet.isTruncated)
        XCTAssertLessThanOrEqual(packet.warningsText.count, TrustedDrugSourcePacketExtractor.sectionLimit)
    }

    func testDeepSeekRequestUsesJSONModeAndNoImagePayload() throws {
        let request = try DeepSeekDrugImportService.makeRequest(apiKey: "secret", packet: mockPacket(), identity: confirmedIdentity())
        let body = try XCTUnwrap(request.httpBody)
        let text = String(decoding: body, as: UTF8.self)
        XCTAssertTrue(text.contains("\"model\":\"deepseek-v4-flash\""))
        XCTAssertTrue(text.contains("\"response_format\":{\"type\":\"json_object\"}"))
        XCTAssertTrue(text.contains("\"thinking\":{\"type\":\"disabled\"}"))
        XCTAssertFalse(text.localizedCaseInsensitiveContains("imageData"))
        XCTAssertFalse(text.localizedCaseInsensitiveContains("base64"))
    }

    func testValidatorOverridesIdentityAndFallsBackInvalidEnumsToUnknown() throws {
        let json = """
        {
          "identity": {"scientificName": "Wrong", "tradeNames": ["Wrong"], "system": "Wrong", "class": "Wrong", "dosageForm": "Wrong", "strength": "Wrong", "route": "Wrong"},
          "usesMechanism": {"mainUses": ["Use"], "simpleMechanismArabic": "شرح", "mechanismKeywords": ["ACE"]},
          "pharmacokinetics": {"halfLifeDisplay": "unknown", "halfLifeBand": "nonsense", "onsetDisplay": "unknown", "onsetBand": "fast", "durationDisplay": "unknown", "durationBand": "long", "dosingFrequency": "onceDaily", "prodrugStatus": "prodrug", "excretionRoute": "renal", "pkMemoryLineArabic": "خط"},
          "safety": {"contraindications": {"severity": "high", "items": ["A"]}, "toxicity": {"severity": "low", "items": []}, "warnings": {"severity": "medium", "items": ["W"]}, "interactions": {"severity": "medium", "items": []}, "renalCaution": {"severity": "medium", "note": "renal"}, "hepaticCaution": {"severity": "low", "note": "hepatic"}, "pregnancyCaution": {"severity": "high", "simpleNoteArabic": "حمل"}},
          "counseling": {"howToTakeArabic": "خذ", "foodInstructionArabic": "بعد الاكل", "simplePatientSentenceArabic": "جملة", "whatPatientMayFeelArabic": ["دوخة"], "whenToSeekHelpArabic": ["تورم"], "missedDoseArabic": "لا تضاعف"},
          "arabicExplanation": {"shortExplanation": "شرح", "memoryStory": "قصة", "importantNote": "ملاحظة"},
          "adverseEffects": {"common": ["Nausea"], "serious": ["Angioedema"]},
          "memorization": {"mustKnow": ["Know"], "flashcards": [{"question": "Q", "answer": "A"}], "oneLineSummaryArabic": "سطر"},
          "sourceQuality": {"sourceName": "AI", "sourceURL": "AI", "needsReview": false, "missingImportantFields": [], "notes": ""}
        }
        """
        let packet = mockPacket(isTruncated: true)
        let info = try DrugImportValidator.parse(jsonString: json, confirmedIdentity: confirmedIdentity(), packet: packet)
        XCTAssertEqual(info.identity.scientificName, "Perindopril arginine")
        XCTAssertEqual(info.identity.tradeNames, ["Coversyl"])
        XCTAssertEqual(info.pharmacokinetics.halfLifeBand, .unknown)
        XCTAssertEqual(info.sourceQuality.sourceName, "DailyMed")
        XCTAssertTrue(info.sourceQuality.needsReview)
    }

    func testValidatorRejectsMarkdownWrappedJSON() {
        XCTAssertThrowsError(try DrugImportValidator.parse(jsonString: "```json\n{}\n```", confirmedIdentity: confirmedIdentity(), packet: mockPacket()))
    }

    func testImportApplierSavesSelectedSectionsAndIdentityOverride() throws {
        let drug = Drug(scientificName: "Existing")
        let info = try DrugImportValidator.parse(jsonString: validJSON(), confirmedIdentity: confirmedIdentity(), packet: mockPacket())
        DrugImportApplier.apply(info, selection: ImportSelection(sections: [.identity, .safety, .memorization, .sourceQuality]), to: drug)
        XCTAssertEqual(drug.scientificName, "Perindopril arginine")
        XCTAssertEqual(drug.tradeNames, ["Coversyl"])
        XCTAssertEqual(drug.warnings, ["Main warning"])
        XCTAssertEqual(drug.warningSeverityRaw, SafetySeverity.high.rawValue)
        XCTAssertEqual(drug.mustKnow, ["Coversyl = Perindopril"])
        XCTAssertEqual(drug.flashcards, ["Scientific?\tPerindopril arginine"])
        XCTAssertEqual(drug.importedSourceName, "DailyMed")
        XCTAssertTrue(drug.mechanism.isEmpty)
    }

    private func confirmedIdentity() -> UserConfirmedDrugIdentity {
        UserConfirmedDrugIdentity(scientificName: "Perindopril arginine", tradeNames: ["Coversyl"], strength: "5 mg", dosageForm: "Tablet", route: "Oral", system: "Cardiovascular", drugClass: "ACE inhibitor")
    }

    private func mockPacket(isTruncated: Bool = false) -> TrustedDrugSourcePacket {
        TrustedDrugSourcePacket(sourceName: "DailyMed", sourceURL: "https://dailymed.nlm.nih.gov/test", indicationsText: "Hypertension", dosageText: "Once daily", contraindicationsText: "Pregnancy", warningsText: "Main warning", adverseReactionsText: "Dizziness", interactionsText: "NSAIDs", pharmacokineticsText: "Long duration", pregnancyText: "Avoid", dosageFormsText: "Tablet", routeText: "Oral", activeIngredientText: "Perindopril", lastUpdatedText: nil, isTruncated: isTruncated)
    }

    private func validJSON() -> String {
        """
        {
          "identity": {"scientificName": "", "tradeNames": [], "system": "", "class": "", "dosageForm": "", "strength": "", "route": ""},
          "usesMechanism": {"mainUses": ["Hypertension"], "simpleMechanismArabic": "Mechanism", "mechanismKeywords": ["ACE"]},
          "pharmacokinetics": {"halfLifeDisplay": "long", "halfLifeBand": "long", "onsetDisplay": "moderate", "onsetBand": "moderate", "durationDisplay": "24h", "durationBand": "long", "dosingFrequency": "onceDaily", "prodrugStatus": "prodrug", "excretionRoute": "renal", "pkMemoryLineArabic": "PK"},
          "safety": {"contraindications": {"severity": "high", "items": ["Contra"]}, "toxicity": {"severity": "medium", "items": ["Toxic"]}, "warnings": {"severity": "high", "items": ["Main warning"]}, "interactions": {"severity": "medium", "items": ["Interaction"]}, "renalCaution": {"severity": "medium", "note": "Renal"}, "hepaticCaution": {"severity": "low", "note": "Hepatic"}, "pregnancyCaution": {"severity": "high", "simpleNoteArabic": "Pregnancy"}},
          "counseling": {"howToTakeArabic": "Take", "foodInstructionArabic": "Food", "simplePatientSentenceArabic": "Sentence", "whatPatientMayFeelArabic": ["Dizzy"], "whenToSeekHelpArabic": ["Swelling"], "missedDoseArabic": "Missed"},
          "arabicExplanation": {"shortExplanation": "Short", "memoryStory": "Story", "importantNote": "Note"},
          "adverseEffects": {"common": ["Dizziness"], "serious": ["Angioedema"]},
          "memorization": {"mustKnow": ["Coversyl = Perindopril"], "flashcards": [{"question": "Scientific?", "answer": "Perindopril arginine"}], "oneLineSummaryArabic": "Summary"},
          "sourceQuality": {"sourceName": "", "sourceURL": "", "needsReview": false, "missingImportantFields": [], "notes": ""}
        }
        """
    }
}
