import Foundation
import XCTest
@testable import PharmaShift

@MainActor
final class DrugImportServiceTests: XCTestCase {
    func testPackageRecognitionKeepsCombinationComponentsSeparateFromMarketedStrength() {
        let result = PackageRecognitionResult(
            tradeName: "Savesto",
            manufacturer: "",
            ingredients: [
                IngredientComponent(name: "Sacubitril", strengthValue: 24, strengthUnit: "mg"),
                IngredientComponent(name: "Valsartan", strengthValue: 26, strengthUnit: "mg")
            ],
            marketedStrengthLabel: "50 mg",
            dosageForm: "Tablet",
            route: "Oral",
            country: "",
            confidence: 0.95,
            ambiguities: []
        )
        XCTAssertEqual(result.scientificName, "Sacubitril + Valsartan")
        XCTAssertEqual(result.ingredients.map(\.strengthText), ["24 mg", "26 mg"])
        XCTAssertEqual(result.marketedStrengthLabel, "50 mg")
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

    func testTrustedPacketExtractorPreservesLongNamedInteractionLists() {
        let names = (1...160).map { "InteractionDrug\($0)" }.joined(separator: ", ")
        let packet = TrustedDrugSourcePacketExtractor.packet(
            sourceName: "Test",
            sourceURL: "https://example.test",
            sections: ["interactions": names]
        )
        XCTAssertTrue(packet.interactionsText.contains("InteractionDrug160"))
        XCTAssertGreaterThan(packet.interactionsText.count, TrustedDrugSourcePacketExtractor.sectionLimit)
    }

    func testConsistencyNormalizerDerivesBandsAndFixesOralTypo() {
        let drug = Drug(scientificName: "Example")
        drug.routes = ["Orak"]
        drug.onsetText = "30–60 minutes"
        drug.durationText = "6–8 hours"
        drug.halfLifeText = "2 days"
        drug.dosingFrequency = .threeTimesDaily
        DrugDataConsistencyNormalizer.normalize(drug)
        XCTAssertEqual(drug.routes, ["Oral"])
        XCTAssertEqual(drug.onsetMinutes, 45)
        XCTAssertEqual(drug.onsetBand, .fast)
        XCTAssertEqual(drug.durationHours, 7)
        XCTAssertEqual(drug.durationBand, .short)
        XCTAssertEqual(drug.halfLifeHours, 48)
        XCTAssertEqual(drug.halfLifeBand, .long)
        XCTAssertEqual(drug.timesPerDay, 3)
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

    func testOpenRouterPackageRecognitionUsesConfiguredModelAndReadsAssistantContent() async throws {
        let preferences = try XCTUnwrap(UserDefaults(suiteName: "OpenRouterTests.\(UUID().uuidString)"))
        let storage = DeepSeekKeyStore(
            service: "openrouter.\(UUID().uuidString)",
            fallbackDirectory: FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString),
            allowsKeychain: false,
            allowsProtectedFile: false,
            preferences: preferences
        )
        let modelPreferenceKey = "openrouter.test-model.\(UUID().uuidString)"
        let keyStore = OpenRouterKeyStore(storage: storage, preferences: preferences, modelPreferenceKey: modelPreferenceKey)
        XCTAssertEqual(keyStore.modelID(), "google/gemini-2.5-flash")
        keyStore.saveModelID("google/gemini-3-flash-preview")
        try keyStore.save(apiKey: "openrouter-test-key")
        defer { keyStore.delete() }
        let resultJSON = """
        {"tradeName":"Savesto","manufacturer":"","ingredients":[{"name":"Sacubitril","saltForm":"","strengthValue":24,"strengthUnit":"mg","displayStrength":"24 mg"},{"name":"Valsartan","saltForm":"","strengthValue":26,"strengthUnit":"mg","displayStrength":"26 mg"}],"marketedStrengthLabel":"50 mg","dosageForm":"Tablet","route":"Oral","country":"Iraq","confidence":0.98,"ambiguities":[]}
        """
        let responseBody = try JSONSerialization.data(withJSONObject: [
            "choices": [["message": ["role": "assistant", "content": resultJSON]]]
        ])
        let outboundRequest = try OpenRouterPackageVisionService.makeRequest(apiKey: "openrouter-test-key", model: keyStore.modelID(), images: [Data([1, 2, 3])])
        let outboundBody = try XCTUnwrap(outboundRequest.httpBody)
        let outboundJSON = try XCTUnwrap(try JSONSerialization.jsonObject(with: outboundBody) as? [String: Any])
        let messages = try XCTUnwrap(outboundJSON["messages"] as? [[String: Any]])
        let content = try XCTUnwrap(messages.first?["content"] as? [[String: Any]])
        let imageURL = try XCTUnwrap(content.last?["image_url"] as? [String: Any])
        let responseFormat = try XCTUnwrap(outboundJSON["response_format"] as? [String: Any])
        let jsonSchema = try XCTUnwrap(responseFormat["json_schema"] as? [String: Any])
        let provider = try XCTUnwrap(outboundJSON["provider"] as? [String: Any])
        XCTAssertEqual(outboundRequest.url?.absoluteString, "https://openrouter.ai/api/v1/chat/completions")
        XCTAssertEqual(outboundRequest.value(forHTTPHeaderField: "Authorization"), "Bearer openrouter-test-key")
        XCTAssertNil(outboundRequest.value(forHTTPHeaderField: "x-goog-api-key"))
        XCTAssertEqual(outboundJSON["model"] as? String, "google/gemini-3-flash-preview")
        XCTAssertEqual(messages.first?["role"] as? String, "user")
        XCTAssertEqual(content.first?["type"] as? String, "text")
        XCTAssertEqual(content.last?["type"] as? String, "image_url")
        XCTAssertEqual(imageURL["url"] as? String, "data:image/jpeg;base64,\(Data([1, 2, 3]).base64EncodedString())")
        XCTAssertEqual(responseFormat["type"] as? String, "json_schema")
        XCTAssertEqual(jsonSchema["name"] as? String, "drug_package")
        XCTAssertEqual(jsonSchema["strict"] as? Bool, true)
        XCTAssertEqual(provider["require_parameters"] as? Bool, true)
        DeepSeekURLProtocolStub.requestHandler = { request in
            XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Bearer openrouter-test-key")
            return (try XCTUnwrap(HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)), responseBody)
        }
        defer { DeepSeekURLProtocolStub.requestHandler = nil }
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [DeepSeekURLProtocolStub.self]
        let service = OpenRouterPackageVisionService(session: URLSession(configuration: configuration), keyStore: keyStore)
        let result = try await service.recognize(images: [Data([1, 2, 3])])
        XCTAssertEqual(result.tradeName, "Savesto")
        XCTAssertEqual(result.ingredients.map(\.strengthText), ["24 mg", "26 mg"])
        XCTAssertEqual(result.marketedStrengthLabel, "50 mg")

        DeepSeekURLProtocolStub.requestHandler = { request in
            let errorBody = try JSONSerialization.data(withJSONObject: ["error": ["message": "Invalid request payload"]])
            return (try XCTUnwrap(HTTPURLResponse(url: request.url!, statusCode: 400, httpVersion: nil, headerFields: nil)), errorBody)
        }
        do {
            _ = try await service.recognize(images: [Data([1, 2, 3])])
            XCTFail("Expected OpenRouter HTTP failure")
        } catch {
            XCTAssertTrue(error.localizedDescription.contains("HTTP 400"))
            XCTAssertTrue(error.localizedDescription.contains("Invalid request payload"))
        }
    }

    func testFastGatherRequestUsesPackageTextWithoutTrustedProviders() throws {
        XCTAssertEqual(ProfileGenerationGroup.allCases.count, 8)
        let request = try DeepSeekFastDrugGatherService.makeRequest(apiKey: "secret", identity: confirmedIdentity(), packageText: "Coversyl 5 mg tablet. Oral.", group: .interactions)
        let text = String(decoding: try XCTUnwrap(request.httpBody), as: UTF8.self)
        XCTAssertTrue(text.contains("\"max_tokens\":4000"))
        XCTAssertTrue(text.contains("Coversyl 5 mg tablet"))
        XCTAssertTrue(text.contains("experimental AI-only"))
        XCTAssertTrue(text.contains("complete categorized interaction list"))
        XCTAssertTrue(text.contains("keep sourceIDs empty"))
        XCTAssertFalse(text.contains("Trusted source packet:"))
        XCTAssertFalse(text.localizedCaseInsensitiveContains("imageData"))
    }

    func testStandaloneAIDraftUsesConfirmedIdentityWithoutSourceRequirement() throws {
        let info = try DrugImportValidator.parseAIDraft(jsonString: validJSON(), confirmedIdentity: confirmedIdentity(), packageText: "Coversyl 5 mg tablet")
        XCTAssertEqual(info.identity.scientificName, "Perindopril arginine")
        XCTAssertEqual(info.sourceQuality.sourceName, "Generated with AI")
        XCTAssertEqual(info.sourceQuality.sourceURL, "")
        XCTAssertTrue(info.sourceQuality.needsReview)
        XCTAssertTrue(info.sourceQuality.notes.contains("editable"))
    }

    func testKeyStoreFallsBackToProtectedDeviceStorage() throws {
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
        defer { try? FileManager.default.removeItem(at: directory) }
        let store = DeepSeekKeyStore(service: "test.\(UUID().uuidString)", fallbackDirectory: directory, allowsKeychain: false)
        XCTAssertEqual(try store.save(apiKey: " sk-test\n123 "), .protectedFile)
        XCTAssertEqual(store.apiKey(), "sk-test123")
        XCTAssertTrue(store.savedKeyStatusDescription().contains("protected device storage"))
        store.delete()
        XCTAssertNil(store.apiKey())
    }

    func testKeyStoreFallsBackToAppPreferencesWhenOtherStoresAreUnavailable() throws {
        let suiteName = "RenlystTests.\(UUID().uuidString)"
        let preferences = try XCTUnwrap(UserDefaults(suiteName: suiteName))
        defer { preferences.removePersistentDomain(forName: suiteName) }
        let store = DeepSeekKeyStore(
            service: "test.\(UUID().uuidString)",
            fallbackDirectory: FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString),
            allowsKeychain: false,
            allowsProtectedFile: false,
            preferences: preferences
        )
        XCTAssertEqual(try store.save(apiKey: "sk-test-preferences"), .appPreferences)
        XCTAssertEqual(store.apiKey(), "sk-test-preferences")
        XCTAssertTrue(store.savedKeyStatusDescription().contains("app preferences"))
        store.delete()
        XCTAssertNil(store.apiKey())
    }

    func testFormatterUsesPersistedPreferenceKeyForAuthorization() async throws {
        let suiteName = "RenlystFormatterTests.\(UUID().uuidString)"
        let preferences = try XCTUnwrap(UserDefaults(suiteName: suiteName))
        defer { preferences.removePersistentDomain(forName: suiteName) }
        let store = DeepSeekKeyStore(
            service: "formatter.\(UUID().uuidString)",
            fallbackDirectory: FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString),
            allowsKeychain: false,
            allowsProtectedFile: false,
            preferences: preferences
        )
        try store.save(apiKey: "ui-test-persisted-key")

        let responseBody = try JSONSerialization.data(withJSONObject: [
            "choices": [["message": ["content": validJSON()]]]
        ])
        DeepSeekURLProtocolStub.requestHandler = { request in
            XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Bearer ui-test-persisted-key")
            let response = try XCTUnwrap(HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: ["Content-Type": "application/json"]))
            return (response, responseBody)
        }
        defer { DeepSeekURLProtocolStub.requestHandler = nil }

        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [DeepSeekURLProtocolStub.self]
        let service = DeepSeekDrugImportService(session: URLSession(configuration: configuration), keyStore: store)
        let info = try await service.format(packet: mockPacket(), identity: confirmedIdentity())
        XCTAssertEqual(info.identity.scientificName, "Perindopril arginine")
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
        XCTAssertEqual(info.identity.class, "Wrong")
        XCTAssertEqual(info.pharmacokinetics.halfLifeBand, .unknown)
        XCTAssertEqual(info.sourceQuality.sourceName, "DailyMed")
        XCTAssertTrue(info.sourceQuality.needsReview)
    }

    func testIdentityNeedsANameButNotClassOrProductDetails() {
        XCTAssertTrue(UserConfirmedDrugIdentity(scientificName: "", tradeNames: ["Gasec"], strength: "", dosageForm: "", route: "", system: "", drugClass: "").isComplete)
        XCTAssertFalse(UserConfirmedDrugIdentity(scientificName: "", tradeNames: [], strength: "20 mg", dosageForm: "Tablet", route: "Oral", system: "GI", drugClass: "").isComplete)
    }

    func testSearchRankerPrioritizesIngredientAndForm() {
        let identity = UserConfirmedDrugIdentity(scientificName: "Omeprazole", tradeNames: ["Gasec"], strength: "20 mg", dosageForm: "Capsule", route: "Oral", system: "GI", drugClass: "")
        let results = [
            DrugSearchResult(id: "tablet", displayName: "Omeprazole tablet", activeIngredient: "Omeprazole", dosageForm: "Tablet", sourceName: "DailyMed"),
            DrugSearchResult(id: "capsule", displayName: "Omeprazole capsule", activeIngredient: "Omeprazole", dosageForm: "Capsule", sourceName: "DailyMed")
        ]
        XCTAssertEqual(DrugSearchRanker.ranked(results, identity: identity).first?.id, "capsule")
    }

    func testValidatorAcceptsMarkdownWrappedJSON() throws {
        let wrapped = "DeepSeek result:\n```json\n\(validJSON())\n```"
        let info = try DrugImportValidator.parse(jsonString: wrapped, confirmedIdentity: confirmedIdentity(), packet: mockPacket())
        XCTAssertEqual(info.identity.scientificName, "Perindopril arginine")
        XCTAssertEqual(info.memorization.reviewQuestions?.count, 8)
    }

    func testValidatorRepairsIncompleteCardAndNormalizesDoseTypes() throws {
        let partial = """
        Here is the compact result:
        ```json
        {
          "identity": {"class": "ACE inhibitor"},
          "usesMechanism": {"mainUses": ["Hypertension"]},
          "doseRegimens": [{
            "indication": "Hypertension",
            "population": "pediatric",
            "formula": "mg per kg per day",
            "amountPerKG": "2.5",
            "dividedDoses": "2",
            "requiresMeasuredWeight": "true"
          }],
          "prodrugInfo": {"classification": "active drug", "explanation": "Administered compound is active."},
          "eliminationInfo": {"dominantPathway": "renal", "summary": "Eliminated mainly in urine."}
        }
        ```
        """
        let info = try DrugImportValidator.parseAIDraft(jsonString: partial, confirmedIdentity: confirmedIdentity(), packageText: "")
        XCTAssertEqual(info.identity.class, "ACE inhibitor")
        XCTAssertEqual(info.usesMechanism.mainUses, ["Hypertension"])
        XCTAssertEqual(info.doseRegimens?.first?.population, .pediatric)
        XCTAssertEqual(info.doseRegimens?.first?.formula, .mgPerKgPerDay)
        XCTAssertEqual(info.doseRegimens?.first?.amountPerKG, 2.5)
        XCTAssertEqual(info.doseRegimens?.first?.dividedDoses, 2)
        XCTAssertEqual(info.doseRegimens?.first?.requiresMeasuredWeight, true)
        XCTAssertEqual(info.prodrugInfo?.classification, .activeDrug)
        XCTAssertEqual(info.eliminationInfo?.dominantPathway, .renalUrine)
        XCTAssertEqual(info.memorization.reviewQuestions?.count, 8)
    }

    func testValidatorDecodesCompleteClinicalListsAndCombinationIdentity() throws {
        let json = """
        {
          "identity": {"activeIngredients":[{"name":"Sacubitril","saltForm":"","strengthValue":24,"strengthUnit":"mg","displayStrength":"24 mg"},{"name":"Valsartan","saltForm":"","strengthValue":26,"strengthUnit":"mg","displayStrength":"26 mg"}],"marketedStrengthLabel":"50 mg"},
          "dosageFormGroups":[{"dosageForm":"Tablet","strengths":[{"strength":"50 mg","tradeNames":["Savesto"]}]}],
          "clinicalDoses":[{"indication":"Heart failure","population":"Adult","doseText":"Use the sourced titration regimen","route":"Oral","frequency":"Twice daily","duration":"","adjuncts":[],"considerations":["Verify current guideline"],"sourceIDs":[]}],
          "interactionEntries":[{"drugName":"Aliskiren","category":"Contraindicated","effect":"Increased risk","management":"Avoid","sourceIDs":[]}],
          "adverseEffectEntries":[{"name":"Hypotension","incidence":"18%","isSerious":false,"sourceIDs":[]}],
          "reproductiveSafety":{"pregnancy":"Fetal toxicity warning","lactation":"Data are limited","pregnancyArabicNote":"تجنب أثناء الحمل","lactationArabicNote":"راجع الطبيب","sourceIDs":[]},
          "pharmacologyProfile":{"mechanismOfAction":"ARNI combination","absorption":["Rapid absorption"],"distribution":[],"metabolism":[],"elimination":["Renal and fecal"],"sourceIDs":[]}
        }
        """
        let identity = UserConfirmedDrugIdentity(
            scientificName: "Sacubitril + Valsartan",
            tradeNames: ["Savesto"],
            strength: "50 mg",
            dosageForm: "Tablet",
            route: "Oral",
            system: "Cardiovascular",
            drugClass: "ARNI",
            ingredients: [IngredientComponent(name: "Sacubitril", displayStrength: "24 mg"), IngredientComponent(name: "Valsartan", displayStrength: "26 mg")],
            marketedStrengthLabel: "50 mg"
        )
        let info = try DrugImportValidator.parseAIDraft(jsonString: json, confirmedIdentity: identity, packageText: "")
        XCTAssertEqual(info.identity.activeIngredients?.count, 2)
        XCTAssertEqual(info.identity.marketedStrengthLabel, "50 mg")
        XCTAssertEqual(info.dosageFormGroups?.first?.strengths.first?.strength, "50 mg")
        XCTAssertEqual(info.clinicalDoses?.first?.indication, "Heart failure")
        XCTAssertEqual(info.interactionEntries?.first?.category, .contraindicated)
        XCTAssertEqual(info.adverseEffectEntries?.first?.incidence, "18%")
        XCTAssertEqual(info.reproductiveSafety?.lactation, "Data are limited")
        XCTAssertEqual(info.pharmacologyProfile?.mechanismOfAction, "ARNI combination")
    }

    func testJSONSanitizerHandlesBracesInsideStrings() throws {
        let data = try DeepSeekJSONSanitizer.objectData(from: "prefix {\"note\":\"use {carefully}\",\"ok\":true} suffix")
        let object = try XCTUnwrap(JSONSerialization.jsonObject(with: data) as? [String: Any])
        XCTAssertEqual(object["note"] as? String, "use {carefully}")
    }

    func testJSONSanitizerRepairsTruncatedObject() throws {
        let truncated = "{\"identity\":{\"class\":\"ACE inhibitor\"},\"usesMechanism\":{\"mainUses\":[\"Hypertension\"]},\"note\":\"cut off"
        let data = try DeepSeekJSONSanitizer.objectData(from: truncated)
        let object = try XCTUnwrap(JSONSerialization.jsonObject(with: data) as? [String: Any])
        XCTAssertEqual((object["identity"] as? [String: Any])?["class"] as? String, "ACE inhibitor")
        XCTAssertEqual(object["note"] as? String, "cut off")
    }

    func testImportApplierSavesSelectedSectionsAndIdentityOverride() throws {
        let drug = Drug(scientificName: "Existing")
        let info = try DrugImportValidator.parse(jsonString: validJSON(), confirmedIdentity: confirmedIdentity(), packet: mockPacket())
        DrugImportApplier.apply(info, selection: ImportSelection(sections: [.identity, .safety, .memorization, .sourceQuality]), to: drug)
        XCTAssertEqual(drug.scientificName, "Perindopril arginine")
        XCTAssertEqual(drug.tradeNames, ["Coversyl"])
        XCTAssertEqual(drug.warnings, ["Main warning"])
        XCTAssertEqual(drug.warningSeverityRaw, SafetySeverity.high.rawValue)
        XCTAssertTrue(drug.mustKnow.contains("Coversyl = Perindopril"))
        XCTAssertEqual(drug.mustKnow.count, 3)
        XCTAssertEqual(drug.flashcards, ["Scientific?\tPerindopril arginine"])
        XCTAssertEqual(drug.importedSourceName, "DailyMed")
        XCTAssertTrue(drug.mechanism.isEmpty)
    }

    func testImportApplierRespectsFieldLevelExclusions() throws {
        let drug = Drug(scientificName: "Keep me", tradeNames: ["Old trade"])
        let info = try DrugImportValidator.parse(jsonString: validJSON(), confirmedIdentity: confirmedIdentity(), packet: mockPacket())
        let selection = ImportSelection(sections: [.identity, .safety], excludedFieldKeys: ["identity.trade", "safety.warnings"])
        DrugImportApplier.apply(info, selection: selection, to: drug)
        XCTAssertEqual(drug.scientificName, "Perindopril arginine")
        XCTAssertEqual(drug.tradeNames, ["Old trade"])
        XCTAssertTrue(drug.warnings.isEmpty)
        XCTAssertFalse(drug.contraindications.isEmpty)
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

private final class DeepSeekURLProtocolStub: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        do {
            let handler = try XCTUnwrap(Self.requestHandler)
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
}
