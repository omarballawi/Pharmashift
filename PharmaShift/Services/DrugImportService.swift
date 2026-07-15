import Foundation
import CoreFoundation
import Security
import SwiftData

struct PackageRecognitionResult: Codable, Equatable, Sendable {
    var tradeName: String
    var manufacturer: String
    var ingredients: [IngredientComponent]
    var marketedStrengthLabel: String
    var dosageForm: String
    var route: String
    var country: String
    var confidence: Double
    var ambiguities: [String]

    static let empty = PackageRecognitionResult(
        tradeName: "", manufacturer: "", ingredients: [], marketedStrengthLabel: "",
        dosageForm: "", route: "", country: "", confidence: 0, ambiguities: []
    )

    var scientificName: String { ingredients.map(\.name).filter { !$0.trimmed.isEmpty }.joined(separator: " + ") }
    var packageEvidenceText: String {
        let ingredientText = ingredients.map { component in
            [component.name, component.saltForm, component.strengthText].filter { !$0.trimmed.isEmpty }.joined(separator: " ")
        }.joined(separator: " + ")
        return [tradeName, manufacturer, ingredientText, marketedStrengthLabel, dosageForm, route, country]
            .filter { !$0.trimmed.isEmpty }
            .joined(separator: "\n")
    }
}

struct DrugSearchResult: Identifiable, Codable, Hashable, Sendable {
    var id: String
    var displayName: String
    var activeIngredient: String?
    var dosageForm: String?
    var sourceName: String
}

struct TrustedDrugSourcePacket: Codable, Equatable, Sendable {
    var sourceName: String
    var sourceURL: String
    var indicationsText: String
    var dosageText: String
    var contraindicationsText: String
    var warningsText: String
    var adverseReactionsText: String
    var interactionsText: String
    var pharmacokineticsText: String
    var pregnancyText: String
    var dosageFormsText: String
    var routeText: String
    var activeIngredientText: String
    var lastUpdatedText: String?
    var isTruncated: Bool
    var leafletText: String = ""

    static let empty = TrustedDrugSourcePacket(
        sourceName: "", sourceURL: "", indicationsText: "", dosageText: "", contraindicationsText: "",
        warningsText: "", adverseReactionsText: "", interactionsText: "", pharmacokineticsText: "",
        pregnancyText: "", dosageFormsText: "", routeText: "", activeIngredientText: "",
        lastUpdatedText: nil, isTruncated: false
    )
}

struct UserConfirmedDrugIdentity: Codable, Equatable, Sendable {
    var scientificName: String
    var tradeNames: [String]
    var strength: String
    var dosageForm: String
    var route: String
    var system: String
    var drugClass: String
    var ingredients: [IngredientComponent] = []
    var marketedStrengthLabel: String = ""

    var isComplete: Bool {
        !scientificName.trimmed.isEmpty || !tradeNames.joined().trimmed.isEmpty
    }
}

protocol UnknownImportEnum: RawRepresentable, Codable, CaseIterable where RawValue == String {
    static var unknown: Self { get }
}

extension UnknownImportEnum {
    init(from decoder: Decoder) throws {
        let value = (try? decoder.singleValueContainer().decode(String.self)) ?? "unknown"
        self = Self(rawValue: value) ?? .unknown
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}

enum PKBand: String, UnknownImportEnum, Sendable { case unknown, short, medium, long, veryLong }
enum ImportedOnsetBand: String, UnknownImportEnum, Sendable { case unknown, fast, moderate, slow }
enum ImportedDurationBand: String, UnknownImportEnum, Sendable { case unknown, short, medium, long }
enum ImportedDosingFrequency: String, UnknownImportEnum, Sendable { case unknown, onceDaily, twiceDaily, threeTimesDaily, fourTimesDaily, PRN, other }
enum ImportedProdrugStatus: String, UnknownImportEnum, Sendable { case unknown, active, prodrug }
enum ImportedExcretionRoute: String, UnknownImportEnum, Sendable { case unknown, renal, hepatic, mixed, other }
enum Severity: String, UnknownImportEnum, Sendable { case unknown, low, medium, high }

struct ImportedDrugInfo: Codable, Equatable, Sendable {
    var identity: ImportedIdentity
    var usesMechanism: ImportedUsesMechanism
    var pharmacokinetics: ImportedPK
    var safety: ImportedSafety
    var counseling: ImportedCounseling
    var arabicExplanation: ImportedArabicExplanation
    var adverseEffects: ImportedAdverseEffects
    var memorization: ImportedMemorization
    var sourceQuality: SourceQuality
    var doseRegimens: [DoseRegimen]? = nil
    var prodrugInfo: ProdrugInfo? = nil
    var eliminationInfo: EliminationInfo? = nil
    var dosageFormGroups: [DosageFormGroup]? = nil
    var clinicalDoses: [ClinicalDoseEntry]? = nil
    var interactionEntries: [DrugInteractionEntry]? = nil
    var adverseEffectEntries: [AdverseEffectEntry]? = nil
    var reproductiveSafety: ReproductiveSafetyProfile? = nil
    var pharmacologyProfile: PharmacologyProfile? = nil
}

struct ImportedIdentity: Codable, Equatable, Sendable {
    var scientificName: String
    var tradeNames: [String]
    var system: String
    var `class`: String
    var dosageForm: String
    var strength: String
    var route: String
    var activeIngredients: [IngredientComponent]? = nil
    var marketedStrengthLabel: String? = nil
}

struct ImportedUsesMechanism: Codable, Equatable, Sendable {
    var mainUses: [String]
    var simpleMechanismArabic: String
    var mechanismKeywords: [String]
}

struct ImportedPK: Codable, Equatable, Sendable {
    var halfLifeDisplay: String
    var halfLifeBand: PKBand
    var onsetDisplay: String
    var onsetBand: ImportedOnsetBand
    var durationDisplay: String
    var durationBand: ImportedDurationBand
    var dosingFrequency: ImportedDosingFrequency
    var prodrugStatus: ImportedProdrugStatus
    var excretionRoute: ImportedExcretionRoute
    var pkMemoryLineArabic: String
    var timesPerDay: Int? = nil
    var metabolism: String? = nil
    var excretionNotes: String? = nil
}

struct ImportedSafety: Codable, Equatable, Sendable {
    var contraindications: SafetyCategory
    var toxicity: SafetyCategory
    var warnings: SafetyCategory
    var interactions: SafetyCategory
    var renalCaution: SafetyNote
    var hepaticCaution: SafetyNote
    var pregnancyCaution: PregnancySafetyNote
}

struct SafetyCategory: Codable, Equatable, Sendable {
    var severity: Severity
    var items: [String]
}

struct SafetyNote: Codable, Equatable, Sendable {
    var severity: Severity
    var note: String
}

struct PregnancySafetyNote: Codable, Equatable, Sendable {
    var severity: Severity
    var simpleNoteArabic: String
}

struct ImportedCounseling: Codable, Equatable, Sendable {
    var howToTakeArabic: String
    var foodInstructionArabic: String
    var simplePatientSentenceArabic: String
    var whatPatientMayFeelArabic: [String]
    var whenToSeekHelpArabic: [String]
    var missedDoseArabic: String
}

struct ImportedArabicExplanation: Codable, Equatable, Sendable {
    var shortExplanation: String
    var memoryStory: String
    var importantNote: String
}

struct ImportedAdverseEffects: Codable, Equatable, Sendable {
    var common: [String]
    var serious: [String]
}

struct ImportedMemorization: Codable, Equatable, Sendable {
    var mustKnow: [String]
    var flashcards: [Flashcard]
    var oneLineSummaryArabic: String
    var reviewQuestions: [GeneratedReviewQuestionDTO]? = nil
}

struct GeneratedReviewQuestionDTO: Codable, Equatable, Sendable {
    var prompt: String
    var choices: [String]
    var correctAnswer: String
    var explanation: String
    var questionType: String
    var relatedField: String
    var difficulty: String
}

struct Flashcard: Codable, Equatable, Sendable, Identifiable {
    var id: String { question + answer }
    var question: String
    var answer: String
}

struct SourceQuality: Codable, Equatable, Sendable {
    var sourceName: String
    var sourceURL: String
    var needsReview: Bool
    var missingImportantFields: [String]
    var notes: String
}

enum ImportSection: String, Codable, CaseIterable, Identifiable, Sendable {
    case identity = "Identity"
    case usesMechanism = "Uses & mechanism"
    case pharmacokinetics = "Pharmacokinetics"
    case safety = "Safety"
    case counseling = "Counseling"
    case arabicExplanation = "Arabic explanation"
    case adverseEffects = "Adverse effects"
    case memorization = "Memorization"
    case sourceQuality = "Source quality"

    var id: String { rawValue }
}

struct ImportSelection: Equatable, Sendable {
    var sections: Set<ImportSection>
    var reviewQuestionPrompts: Set<String>? = nil
    var excludedFieldKeys: Set<String> = []
    func contains(_ section: ImportSection) -> Bool { sections.contains(section) }
    func includes(_ fieldKey: String) -> Bool { !excludedFieldKeys.contains(fieldKey) }
}

enum DrugImportError: LocalizedError, Equatable {
    case invalidQuery
    case invalidResponse
    case parsingFailed
    case missingDeepSeekKey
    case invalidAIJSON
    case aiResponseTruncated
    case aiReturnedEmpty
    case unresolvedLocalBrand
    case deepSeekHTTPStatus(Int)
    case missingGeminiKey
    case geminiHTTPStatus(Int, String)
    case packageRecognitionFailed

    var errorDescription: String? {
        switch self {
        case .invalidQuery: "Enter a confirmed drug name first."
        case .invalidResponse: "The trusted source returned an unexpected response. Please try again."
        case .parsingFailed: "The trusted source label could not be read."
        case .missingDeepSeekKey: "Add your DeepSeek API key in Settings before using AI formatting."
        case .invalidAIJSON: "DeepSeek returned unreadable data. Try again; Renlyst now accepts incomplete cards and fills safe defaults automatically."
        case .aiResponseTruncated: "DeepSeek cut the answer off before finishing the card. Retry once; Renlyst has reduced the request size for future cards."
        case .aiReturnedEmpty: "DeepSeek returned an empty response. Retry generation."
        case .unresolvedLocalBrand: "We could not safely identify this local trade name. Enter its active ingredient or ask your pharmacist."
        case .deepSeekHTTPStatus(let status): "DeepSeek connection failed (HTTP \(status)). Check that the key is active and has API access."
        case .missingGeminiKey: "Add your Gemini API key in Settings before scanning a package."
        case .geminiHTTPStatus(let status, let detail):
            detail.isEmpty
                ? "Gemini package recognition failed (HTTP \(status)). Check the saved key and try again."
                : "Gemini package recognition failed (HTTP \(status)): \(detail)"
        case .packageRecognitionFailed: "Gemini could not identify enough package facts. Retake clear front and back photos or enter the medicine manually."
        }
    }
}

protocol DrugSourceProvider: Sendable {
    var sourceName: String { get }
    func searchDrug(query: String) async throws -> [DrugSearchResult]
    func fetchDrugDetails(id: String) async throws -> TrustedDrugSourcePacket
}

enum DrugSourceProviderFactory {
    static func appDefault() -> [any DrugSourceProvider] {
        if ProcessInfo.processInfo.arguments.contains("-mockDrugImport") {
            return [MockDrugSourceProvider()]
        }
        return [AltibbiProvider(), RxNormProvider(), DailyMedProvider(), OpenFDALabelProvider()]
    }

    static func aiDefault() -> any DrugImportFormattingService {
        if ProcessInfo.processInfo.arguments.contains("-mockDrugImport") {
            return MockDeepSeekDrugImportService()
        }
        return DeepSeekDrugImportService()
    }
}

@MainActor
enum DrugRelationshipRefreshService {
    static func refresh(drugs: [Drug], context: ModelContext, providers: [any DrugSourceProvider] = DrugSourceProviderFactory.appDefault()) async throws -> Int {
        guard drugs.count > 1 else { return 0 }
        let preferred = providers.filter { $0.sourceName == "Altibbi" || $0.sourceName == "DailyMed" || $0.sourceName == "openFDA" }
        var found: [String: (Drug, Drug, String, String)] = [:]
        for drug in drugs where !drug.scientificName.trimmed.isEmpty {
            var packets: [TrustedDrugSourcePacket] = []
            for provider in preferred {
                guard let matches = try? await provider.searchDrug(query: drug.scientificName),
                      let match = matches.first,
                      let packet = try? await provider.fetchDrugDetails(id: match.id),
                      !packet.interactionsText.trimmed.isEmpty else { continue }
                packets.append(packet)
            }
            for packet in packets {
                let searchable = IngredientIdentity.normalize(packet.interactionsText)
                for other in drugs where other.id != drug.id {
                    let names = other.ingredientNames + other.effectiveTradeNames
                    guard names.contains(where: { name in
                        let needle = IngredientIdentity.normalize(name)
                        return needle.count >= 4 && searchable.contains(needle)
                    }) else { continue }
                    let ids = [drug.id.uuidString, other.id.uuidString].sorted()
                    let key = ids.joined(separator: "|") + "|interaction"
                    found[key] = (drug, other, TrustedDrugSourcePacketExtractor.compact(packet.interactionsText, limit: 700), packet.sourceURL)
                }
            }
            drug.lastKnowledgeRefreshAt = .now
        }
        let existing = try context.fetch(FetchDescriptor<DrugRelationship>())
        for (key, value) in found {
            if let relationship = existing.first(where: { $0.relationshipKey == key }) {
                relationship.summary = value.2; relationship.sourceURLs = [value.3]; relationship.checkedAt = .now
            } else {
                context.insert(DrugRelationship(relationshipKey: key, kind: .interaction, severity: .medium, summary: value.2, managementNote: "Review the linked source and ask a pharmacist before combining or changing therapy.", sourceURLs: [value.3], sourceDrug: value.0, targetDrug: value.1))
            }
        }
        try context.save()
        return found.count
    }
}

enum DrugSearchRanker {
    static func ranked(_ values: [DrugSearchResult], identity: UserConfirmedDrugIdentity) -> [DrugSearchResult] {
        let ingredient = identity.scientificName.trimmed.lowercased()
        let trade = identity.tradeNames.joined(separator: " ").trimmed.lowercased()
        let form = identity.dosageForm.trimmed.lowercased()
        let route = identity.route.trimmed.lowercased()
        var unique: [String: DrugSearchResult] = [:]
        for value in values {
            let key = [value.activeIngredient ?? value.displayName, value.dosageForm ?? "", value.sourceName]
                .joined(separator: "|").lowercased()
            if unique[key] == nil { unique[key] = value }
        }
        return unique.values.sorted { score($0, ingredient: ingredient, trade: trade, form: form, route: route) > score($1, ingredient: ingredient, trade: trade, form: form, route: route) }
    }

    private static func score(_ result: DrugSearchResult, ingredient: String, trade: String, form: String, route: String) -> Int {
        let activeIngredient = result.activeIngredient ?? ""
        let name = "\(result.displayName) \(activeIngredient)".lowercased()
        var value = 0
        if !ingredient.isEmpty && name == ingredient { value += 100 }
        else if !ingredient.isEmpty && name.contains(ingredient) { value += 80 }
        if !trade.isEmpty && name.contains(trade) { value += 60 }
        if !form.isEmpty && (result.dosageForm ?? "").lowercased().contains(form) { value += 15 }
        if !route.isEmpty && name.contains(route) { value += 5 }
        if result.sourceName == "Altibbi" { value += 8 }
        if result.sourceName == "DailyMed" { value += 3 }
        return value
    }
}

actor AltibbiProvider: DrugSourceProvider {
    let sourceName = "Altibbi"
    private static let sitemapURL = URL(string: "https://altibbi.com/sitemap/full/drugs_1.xml")!
    private let session: URLSession
    private var cachedURLs: [URL]?

    init(session: URLSession? = nil) {
        if let session { self.session = session }
        else {
            let configuration = URLSessionConfiguration.default
            configuration.urlCache = URLCache(memoryCapacity: 12_000_000, diskCapacity: 55_000_000)
            configuration.requestCachePolicy = .returnCacheDataElseLoad
            configuration.timeoutIntervalForRequest = 25
            self.session = URLSession(configuration: configuration)
        }
    }

    func searchDrug(query: String) async throws -> [DrugSearchResult] {
        let query = query.trimmed
        guard !query.isEmpty else { throw DrugImportError.invalidQuery }
        if let direct = URL(string: query), direct.host?.localizedCaseInsensitiveContains("altibbi.com") == true {
            return [result(for: direct)]
        }
        let needle = IngredientIdentity.normalize(query)
        let urls = try await drugURLs()
        return urls.filter { url in
            IngredientIdentity.normalize(url.deletingPathExtension().lastPathComponent.replacingOccurrences(of: "-علمي", with: "")).contains(needle)
        }.prefix(12).map(result(for:))
    }

    func fetchDrugDetails(id: String) async throws -> TrustedDrugSourcePacket {
        guard let url = URL(string: id) else { throw DrugImportError.invalidResponse }
        var request = URLRequest(url: url)
        request.setValue("Renlyst/1.7 educational drug-library reader", forHTTPHeaderField: "User-Agent")
        let (data, response) = try await session.data(for: request)
        try validate(response)
        guard let html = String(data: data, encoding: .utf8) else { throw DrugImportError.parsingFailed }
        let sections: [String: String] = [
            "indications": article(id: "termText0", html: html),
            "contraindications": article(id: "termText1", html: html),
            "adverse": article(id: "termText2", html: html),
            "warnings": article(id: "termText3", html: html),
            "interactions": article(id: "termText4", html: html),
            "dosage": article(id: "termText6", html: html)
        ]
        let title = firstMatch(#"<title>(.*?)</title>"#, in: html)
        let ingredient = title.components(separatedBy: ["،", ","]).first?.trimmed ?? url.lastPathComponent.replacingOccurrences(of: "-علمي", with: "")
        return TrustedDrugSourcePacketExtractor.packet(
            sourceName: sourceName,
            sourceURL: url.absoluteString,
            sections: sections,
            dosageForms: [article(id: "termText7", html: html)].filter { !$0.isEmpty },
            activeIngredients: [ingredient]
        )
    }

    private func drugURLs() async throws -> [URL] {
        if let cachedURLs { return cachedURLs }
        let (data, response) = try await session.data(from: Self.sitemapURL)
        try validate(response)
        guard let xml = String(data: data, encoding: .utf8) else { throw DrugImportError.parsingFailed }
        let urls = matches(#"<loc>(.*?)</loc>"#, in: xml).compactMap { URL(string: $0.replacingOccurrences(of: "&amp;", with: "&")) }
        cachedURLs = urls
        return urls
    }

    private func result(for url: URL) -> DrugSearchResult {
        let slug = url.lastPathComponent.replacingOccurrences(of: "-علمي", with: "").replacingOccurrences(of: "-", with: " ")
        return DrugSearchResult(id: url.absoluteString, displayName: slug, activeIngredient: slug, dosageForm: nil, sourceName: sourceName)
    }

    private func article(id: String, html: String) -> String {
        let escaped = NSRegularExpression.escapedPattern(for: id)
        let raw = firstMatch(#"<article[^>]*id=[\"']"# + escaped + #"[\"'][^>]*>([\s\S]*?)</article>"#, in: html)
        return Self.plainText(raw)
    }

    private func firstMatch(_ pattern: String, in text: String) -> String {
        matches(pattern, in: text).first ?? ""
    }

    private func matches(_ pattern: String, in text: String) -> [String] {
        guard let expression = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]) else { return [] }
        let range = NSRange(text.startIndex..., in: text)
        return expression.matches(in: text, range: range).compactMap { match in
            guard match.numberOfRanges > 1, let range = Range(match.range(at: 1), in: text) else { return nil }
            return String(text[range])
        }
    }

    private static func plainText(_ html: String) -> String {
        let withoutScripts = html.replacingOccurrences(of: #"<(script|style)[^>]*>[\s\S]*?</\1>"#, with: " ", options: [.regularExpression, .caseInsensitive])
        let withBreaks = withoutScripts.replacingOccurrences(of: #"</?(p|li|tr|h[1-6]|br|td)[^>]*>"#, with: "\n", options: [.regularExpression, .caseInsensitive])
        let stripped = withBreaks.replacingOccurrences(of: #"<[^>]+>"#, with: " ", options: .regularExpression)
        let decoded = stripped.replacingOccurrences(of: "&nbsp;", with: " ").replacingOccurrences(of: "&amp;", with: "&").replacingOccurrences(of: "&quot;", with: "\"").replacingOccurrences(of: "&#39;", with: "'")
        return decoded.replacingOccurrences(of: #"[ \t]+"#, with: " ", options: .regularExpression).replacingOccurrences(of: #"\n{3,}"#, with: "\n\n", options: .regularExpression).trimmed
    }

    private func validate(_ response: URLResponse) throws {
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else { throw DrugImportError.invalidResponse }
    }
}

protocol DrugPackageRecognizing: Sendable {
    func recognize(images: [Data]) async throws -> PackageRecognitionResult
}

actor GeminiPackageVisionService: DrugPackageRecognizing {
    static let model = "gemini-2.5-flash"
    static let endpoint = URL(string: "https://generativelanguage.googleapis.com/v1beta/interactions")!
    private let session: URLSession
    private let keyStore: GeminiKeyStore

    init(session: URLSession = .shared, keyStore: GeminiKeyStore = .shared) {
        self.session = session
        self.keyStore = keyStore
    }

    func recognize(images: [Data]) async throws -> PackageRecognitionResult {
        guard let apiKey = keyStore.apiKey(), !apiKey.trimmed.isEmpty else { throw DrugImportError.missingGeminiKey }
        guard !images.isEmpty else { throw DrugImportError.packageRecognitionFailed }
        let request = try Self.makeRequest(apiKey: apiKey, images: images)
        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse else { throw DrugImportError.packageRecognitionFailed }
        guard (200..<300).contains(http.statusCode) else {
            throw DrugImportError.geminiHTTPStatus(http.statusCode, Self.errorDetail(from: data))
        }
        let envelope = try JSONDecoder().decode(GeminiInteractionResponse.self, from: data)
        guard let text = envelope.steps.last(where: { $0.type == "model_output" })?.content?.first(where: { $0.type == "text" })?.text,
              let json = text.data(using: .utf8),
              let result = try? JSONDecoder().decode(PackageRecognitionResult.self, from: json),
              !result.tradeName.trimmed.isEmpty || !result.ingredients.isEmpty else {
            throw DrugImportError.packageRecognitionFailed
        }
        return result
    }

    static func makeRequest(apiKey: String, images: [Data]) throws -> URLRequest {
        var input: [[String: Any]] = images.map { ["type": "image", "mime_type": "image/jpeg", "data": $0.base64EncodedString()] }
        input.append(["type": "text", "text": Self.prompt])
        let body: [String: Any] = [
            "model": Self.model,
            "input": input,
            "store": false,
            "response_format": ["type": "text", "mime_type": "application/json", "schema": Self.schema]
        ]
        var request = URLRequest(url: Self.endpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "x-goog-api-key")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        return request
    }

    static func errorDetail(from data: Data) -> String {
        guard let envelope = try? JSONDecoder().decode(GeminiErrorEnvelope.self, from: data) else { return "" }
        return String(envelope.error.message.replacingOccurrences(of: "\n", with: " ").trimmed.prefix(300))
    }

    static let prompt = """
    Inspect these photos as views of the same medicine package. Extract only facts visible or strongly supported by the package. Do not provide indications, dosing advice, interactions, or other clinical knowledge. Preserve every active ingredient separately and preserve each printed component strength. The marketedStrengthLabel is the total or headline strength printed for the product and must never replace component strengths. Use empty strings and ambiguities when uncertain. Confidence must be between 0 and 1. Return JSON only.
    """

    static let schema: [String: Any] = [
        "type": "object",
        "properties": [
            "tradeName": ["type": "string"], "manufacturer": ["type": "string"],
            "ingredients": ["type": "array", "items": ["type": "object", "properties": [
                "name": ["type": "string"], "saltForm": ["type": "string"],
                "strengthValue": ["type": ["number", "null"]], "strengthUnit": ["type": "string"],
                "displayStrength": ["type": "string"]
            ], "required": ["name", "saltForm", "strengthValue", "strengthUnit", "displayStrength"], "additionalProperties": false]],
            "marketedStrengthLabel": ["type": "string"], "dosageForm": ["type": "string"],
            "route": ["type": "string"], "country": ["type": "string"],
            "confidence": ["type": "number", "minimum": 0, "maximum": 1],
            "ambiguities": ["type": "array", "items": ["type": "string"]]
        ],
        "required": ["tradeName", "manufacturer", "ingredients", "marketedStrengthLabel", "dosageForm", "route", "country", "confidence", "ambiguities"],
        "additionalProperties": false
    ]
}

private struct GeminiErrorEnvelope: Decodable {
    struct APIError: Decodable { var message: String }
    var error: APIError
}

private struct GeminiInteractionResponse: Decodable {
    struct Step: Decodable {
        struct Content: Decodable { var type: String; var text: String? }
        var type: String
        var content: [Content]?
    }
    var steps: [Step]
}

actor MockGeminiPackageVisionService: DrugPackageRecognizing {
    func recognize(images: [Data]) async throws -> PackageRecognitionResult {
        guard !images.isEmpty else { throw DrugImportError.packageRecognitionFailed }
        return PackageRecognitionResult(
            tradeName: "Savesto",
            manufacturer: "Mock manufacturer",
            ingredients: [
                IngredientComponent(name: "Sacubitril", strengthValue: 24, strengthUnit: "mg", displayStrength: "24 mg"),
                IngredientComponent(name: "Valsartan", strengthValue: 26, strengthUnit: "mg", displayStrength: "26 mg")
            ],
            marketedStrengthLabel: "50 mg",
            dosageForm: "Tablet",
            route: "Oral",
            country: "Iraq",
            confidence: 0.97,
            ambiguities: []
        )
    }
}

enum TrustedDrugSourcePacketExtractor {
    static let sectionLimit = 1_800

    static func packet(
        sourceName: String,
        sourceURL: String,
        sections: [String: String],
        dosageForms: [String] = [],
        routes: [String] = [],
        activeIngredients: [String] = [],
        lastUpdatedText: String? = nil
    ) -> TrustedDrugSourcePacket {
        var truncated = false
        func trim(_ keys: [String], limit: Int = sectionLimit) -> String {
            let joined = keys.compactMap { sections[$0] }.filter { !$0.trimmed.isEmpty }.joined(separator: "\n\n")
            let value = compact(joined, limit: limit)
            if value.count < joined.count { truncated = true }
            return value
        }
        let packet = TrustedDrugSourcePacket(
            sourceName: sourceName,
            sourceURL: sourceURL,
            indicationsText: trim(["indications", "34067-9", "purpose"]),
            dosageText: trim(["dosage", "34068-7", "dosage_and_administration"]),
            contraindicationsText: trim(["contraindications", "34070-3"]),
            warningsText: trim(["warnings", "43685-7", "34071-1", "warnings_and_precautions", "boxed_warning"]),
            adverseReactionsText: trim(["adverse", "34084-4", "adverse_reactions"]),
            interactionsText: trim(["interactions", "34073-7", "drug_interactions"], limit: 12_000),
            pharmacokineticsText: trim(["pharmacokinetics", "43682-4"]),
            pregnancyText: trim(["pregnancy", "42228-7", "pregnancy_or_breast_feeding", "use_in_specific_populations"]),
            dosageFormsText: compact(dosageForms.joined(separator: ", "), limit: 800),
            routeText: compact(routes.joined(separator: ", "), limit: 500),
            activeIngredientText: compact(activeIngredients.joined(separator: ", "), limit: 800),
            lastUpdatedText: lastUpdatedText,
            isTruncated: truncated
        )
        return packet
    }

    static func compact(_ text: String, limit: Int) -> String {
        let normalized = text.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression).trimmed
        guard normalized.count > limit else { return normalized }
        let prefix = normalized.prefix(limit)
        if let sentence = prefix.lastIndex(where: { ".;:".contains($0) }) {
            return String(prefix[...sentence]).trimmed
        }
        return String(prefix).trimmed
    }
}

actor RxNormProvider: DrugSourceProvider {
    let sourceName = "RxNorm"
    private let session: URLSession
    private var namesByID: [String: String] = [:]

    init(session: URLSession = .shared) { self.session = session }

    func searchDrug(query: String) async throws -> [DrugSearchResult] {
        let query = query.trimmed
        guard !query.isEmpty else { throw DrugImportError.invalidQuery }
        var components = URLComponents(string: "https://rxnav.nlm.nih.gov/REST/approximateTerm.json")!
        components.queryItems = [URLQueryItem(name: "term", value: query), URLQueryItem(name: "maxEntries", value: "8")]
        guard let url = components.url else { throw DrugImportError.invalidQuery }
        let (data, response) = try await session.data(from: url)
        try Self.validate(response)
        let payload = try JSONDecoder().decode(RxNormApproxPayload.self, from: data)
        let candidates = payload.approximateGroup.candidate ?? []
        var results: [DrugSearchResult] = []
        for candidate in candidates {
            let name = try await rxNormName(rxcui: candidate.rxcui)
            namesByID[candidate.rxcui] = name
            results.append(DrugSearchResult(id: candidate.rxcui, displayName: name, activeIngredient: name, dosageForm: nil, sourceName: sourceName))
        }
        return results
    }

    func fetchDrugDetails(id: String) async throws -> TrustedDrugSourcePacket {
        let name: String
        if let cachedName = namesByID[id] {
            name = cachedName
        } else {
            name = try await rxNormName(rxcui: id)
        }
        return TrustedDrugSourcePacket(
            sourceName: sourceName,
            sourceURL: "https://mor.nlm.nih.gov/RxNav/search?searchBy=RXCUI&searchTerm=\(id)",
            indicationsText: "", dosageText: "", contraindicationsText: "", warningsText: "",
            adverseReactionsText: "", interactionsText: "", pharmacokineticsText: "", pregnancyText: "",
            dosageFormsText: "", routeText: "", activeIngredientText: name, lastUpdatedText: nil, isTruncated: false
        )
    }

    private func rxNormName(rxcui: String) async throws -> String {
        guard let url = URL(string: "https://rxnav.nlm.nih.gov/REST/rxcui/\(rxcui)/name.json") else { throw DrugImportError.invalidResponse }
        let (data, response) = try await session.data(from: url)
        try Self.validate(response)
        let payload = try JSONDecoder().decode(RxNormNamePayload.self, from: data)
        return payload.idGroup.name ?? rxcui
    }

    private static func validate(_ response: URLResponse) throws {
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else { throw DrugImportError.invalidResponse }
    }
}

private struct RxNormApproxPayload: Decodable {
    struct Group: Decodable { var candidate: [Candidate]? }
    struct Candidate: Decodable { var rxcui: String }
    var approximateGroup: Group
}

private struct RxNormNamePayload: Decodable {
    struct Group: Decodable { var name: String? }
    var idGroup: Group
}

actor DailyMedProvider: DrugSourceProvider {
    let sourceName = "DailyMed"
    private let session: URLSession
    private var resultCache: [String: DailyMedSearchItem] = [:]

    init(session: URLSession? = nil) {
        if let session { self.session = session }
        else {
            let configuration = URLSessionConfiguration.default
            configuration.urlCache = URLCache(memoryCapacity: 8_000_000, diskCapacity: 40_000_000)
            configuration.requestCachePolicy = .returnCacheDataElseLoad
            self.session = URLSession(configuration: configuration)
        }
    }

    func searchDrug(query: String) async throws -> [DrugSearchResult] {
        let query = query.trimmed
        guard !query.isEmpty else { throw DrugImportError.invalidQuery }
        var components = URLComponents(string: "https://dailymed.nlm.nih.gov/dailymed/services/v2/spls.json")!
        components.queryItems = [URLQueryItem(name: "drug_name", value: query), URLQueryItem(name: "pagesize", value: "25")]
        guard let url = components.url else { throw DrugImportError.invalidQuery }
        let (data, response) = try await session.data(from: url)
        try Self.validate(response)
        let payload = try JSONDecoder().decode(DailyMedSearchPayload.self, from: data)
        return payload.data.map { item in
            resultCache[item.setid] = item
            let parsed = Self.parseTitle(item.title)
            return DrugSearchResult(id: item.setid, displayName: item.title, activeIngredient: parsed.generic, dosageForm: parsed.formulation.nilIfEmpty, sourceName: sourceName)
        }
    }

    func fetchDrugDetails(id: String) async throws -> TrustedDrugSourcePacket {
        guard let url = URL(string: "https://dailymed.nlm.nih.gov/dailymed/services/v2/spls/\(id).xml") else { throw DrugImportError.invalidResponse }
        let (data, response) = try await session.data(from: url)
        try Self.validate(response)
        return try SPLParser.parsePacket(data: data, labelID: id, metadata: resultCache[id])
    }

    private static func validate(_ response: URLResponse) throws {
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else { throw DrugImportError.invalidResponse }
    }

    static func parseTitle(_ title: String) -> (generic: String, formulation: String) {
        let ownerStart = title.lastIndex(of: "[")
        let withoutOwner = ownerStart.map { String(title[..<$0]) } ?? title
        let formWords = ["TABLET", "CAPSULE", "INJECTION", "SOLUTION", "SUSPENSION", "CREAM", "OINTMENT", "GEL", "SPRAY", "PATCH", "POWDER", "AEROSOL", "LOTION", "DROPS", "SYRUP"]
        let upper = withoutOwner.uppercased()
        let form = formWords.first(where: { upper.contains(" \($0)") }) ?? ""
        let generic: String
        if let formRange = form.isEmpty ? nil : upper.range(of: " \(form)") { generic = String(withoutOwner[..<formRange.lowerBound]).trimmed }
        else { generic = withoutOwner.trimmed }
        return (generic.capitalized, form.capitalized)
    }
}

private struct DailyMedSearchPayload: Decodable { var data: [DailyMedSearchItem] }
struct DailyMedSearchItem: Decodable {
    var publishedDate: String
    var title: String
    var setid: String
    enum CodingKeys: String, CodingKey { case publishedDate = "published_date", title, setid }
}

actor OpenFDALabelProvider: DrugSourceProvider {
    let sourceName = "openFDA"
    private let session: URLSession
    private var cached: [String: OpenFDALabelResult] = [:]

    init(session: URLSession = .shared) { self.session = session }

    func searchDrug(query: String) async throws -> [DrugSearchResult] {
        let query = query.trimmed
        guard !query.isEmpty else { throw DrugImportError.invalidQuery }
        var components = URLComponents(string: "https://api.fda.gov/drug/label.json")!
        components.queryItems = [
            URLQueryItem(name: "search", value: "openfda.generic_name:\"\(query)\"+openfda.brand_name:\"\(query)\""),
            URLQueryItem(name: "limit", value: "10")
        ]
        guard let url = components.url else { throw DrugImportError.invalidQuery }
        let (data, response) = try await session.data(from: url)
        try Self.validate(response)
        let payload = try JSONDecoder().decode(OpenFDALabelPayload.self, from: data)
        return payload.results.enumerated().map { index, item in
            let id = item.id ?? "openfda-\(index)-\(query)"
            cached[id] = item
            return DrugSearchResult(
                id: id,
                displayName: item.openfda.brandName?.first ?? item.openfda.genericName?.first ?? query,
                activeIngredient: item.openfda.genericName?.first,
                dosageForm: item.openfda.dosageForm?.first,
                sourceName: sourceName
            )
        }
    }

    func fetchDrugDetails(id: String) async throws -> TrustedDrugSourcePacket {
        guard let item = cached[id] else { throw DrugImportError.invalidResponse }
        let sections: [String: String] = [
            "indications": item.indicationsAndUsage?.joined(separator: "\n") ?? "",
            "purpose": item.purpose?.joined(separator: "\n") ?? "",
            "dosage": item.dosageAndAdministration?.joined(separator: "\n") ?? "",
            "contraindications": item.contraindications?.joined(separator: "\n") ?? "",
            "warnings": item.warnings?.joined(separator: "\n") ?? "",
            "warnings_and_precautions": item.warningsAndPrecautions?.joined(separator: "\n") ?? "",
            "boxed_warning": item.boxedWarning?.joined(separator: "\n") ?? "",
            "adverse": item.adverseReactions?.joined(separator: "\n") ?? "",
            "interactions": item.drugInteractions?.joined(separator: "\n") ?? "",
            "pharmacokinetics": item.clinicalPharmacology?.joined(separator: "\n") ?? "",
            "pregnancy": item.pregnancy?.joined(separator: "\n") ?? ""
        ]
        return TrustedDrugSourcePacketExtractor.packet(
            sourceName: sourceName,
            sourceURL: "https://open.fda.gov/apis/drug/label/",
            sections: sections,
            dosageForms: item.openfda.dosageForm ?? [],
            routes: item.openfda.route ?? [],
            activeIngredients: item.openfda.genericName ?? []
        )
    }

    private static func validate(_ response: URLResponse) throws {
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else { throw DrugImportError.invalidResponse }
    }
}

private struct OpenFDALabelPayload: Decodable { var results: [OpenFDALabelResult] }
private struct OpenFDALabelResult: Decodable {
    var id: String?
    var openfda: OpenFDAFields
    var indicationsAndUsage: [String]?
    var purpose: [String]?
    var dosageAndAdministration: [String]?
    var contraindications: [String]?
    var warnings: [String]?
    var warningsAndPrecautions: [String]?
    var boxedWarning: [String]?
    var adverseReactions: [String]?
    var drugInteractions: [String]?
    var clinicalPharmacology: [String]?
    var pregnancy: [String]?

    enum CodingKeys: String, CodingKey {
        case id, openfda, warnings, contraindications, purpose, pregnancy
        case indicationsAndUsage = "indications_and_usage"
        case dosageAndAdministration = "dosage_and_administration"
        case warningsAndPrecautions = "warnings_and_precautions"
        case boxedWarning = "boxed_warning"
        case adverseReactions = "adverse_reactions"
        case drugInteractions = "drug_interactions"
        case clinicalPharmacology = "clinical_pharmacology"
    }
}

private struct OpenFDAFields: Decodable {
    var genericName: [String]?
    var brandName: [String]?
    var dosageForm: [String]?
    var route: [String]?
    enum CodingKeys: String, CodingKey {
        case genericName = "generic_name", brandName = "brand_name", dosageForm = "dosage_form", route
    }
}

enum SPLParser {
    static let sectionCodes: [String: String] = [
        "34067-9": "indications", "34068-7": "dosage", "34070-3": "contraindications",
        "43685-7": "warnings", "34071-1": "warnings", "34084-4": "adverse",
        "34073-7": "interactions", "43679-0": "mechanism", "43682-4": "pharmacokinetics",
        "88828-9": "renal", "88829-5": "hepatic", "42228-7": "pregnancy",
        "88436-1": "counseling"
    ]

    static func parsePacket(data: Data, labelID: String, metadata: DailyMedSearchItem? = nil) throws -> TrustedDrugSourcePacket {
        let delegate = SPLXMLDelegate()
        let parser = XMLParser(data: data)
        parser.delegate = delegate
        guard parser.parse() else { throw parser.parserError ?? DrugImportError.parsingFailed }
        let sections = delegate.sections.mapValues { $0.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression).trimmed }
        let url = "https://dailymed.nlm.nih.gov/dailymed/drugInfo.cfm?setid=\(labelID)"
        return TrustedDrugSourcePacketExtractor.packet(
            sourceName: "DailyMed",
            sourceURL: url,
            sections: sections,
            dosageForms: delegate.forms,
            routes: delegate.routes,
            activeIngredients: delegate.genericNames,
            lastUpdatedText: metadata?.publishedDate
        )
    }
}

private final class SPLXMLDelegate: NSObject, XMLParserDelegate {
    var sections: [String: String] = [:]
    var genericNames: [String] = []
    var brandNames: [String] = []
    var forms: [String] = []
    var routes: [String] = []
    private var sectionStack: [String?] = []
    private var currentSectionKey: String?
    private var captureTextDepth = 0
    private var textBuffer = ""
    private var genericDepth = 0
    private var materialDepth = 0
    private var captureNameKind: NameKind?
    private var valueBuffer = ""
    private enum NameKind { case generic, brand }

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
        let name = elementName.lowercased()
        if name == "section" { sectionStack.append(currentSectionKey); currentSectionKey = nil }
        if name == "code", !sectionStack.isEmpty, let code = attributeDict["code"], let key = SPLParser.sectionCodes[code] { currentSectionKey = key }
        if name == "text", !sectionStack.isEmpty { captureTextDepth += 1; if captureTextDepth == 1 { textBuffer = "" } }
        if captureTextDepth > 0, name == "br" || name == "paragraph" || name == "item" { textBuffer += "\n" }
        if name == "genericmedicine" { genericDepth += 1 }
        if name == "manufacturedmaterial" { materialDepth += 1 }
        if name == "name", genericDepth > 0 { captureNameKind = .generic; valueBuffer = "" }
        else if name == "name", materialDepth > 0, genericDepth == 0 { captureNameKind = .brand; valueBuffer = "" }
        if name == "formcode", let value = attributeDict["displayName"] { appendUnique(value, to: &forms) }
        if name == "routecode", let value = attributeDict["displayName"] { appendUnique(value, to: &routes) }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if captureTextDepth > 0 { textBuffer += string }
        if captureNameKind != nil { valueBuffer += string }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        let name = elementName.lowercased()
        if name == "text", captureTextDepth > 0 {
            captureTextDepth -= 1
            if captureTextDepth == 0, let key = currentSectionKey { sections[key, default: ""] += " " + textBuffer }
        }
        if name == "name", let kind = captureNameKind {
            let value = valueBuffer.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression).trimmed
            if !value.isEmpty { if kind == .generic { appendUnique(value, to: &genericNames) } else { appendUnique(value, to: &brandNames) } }
            captureNameKind = nil
        }
        if name == "genericmedicine" { genericDepth = max(0, genericDepth - 1) }
        if name == "manufacturedmaterial" { materialDepth = max(0, materialDepth - 1) }
        if name == "section" { currentSectionKey = sectionStack.popLast() ?? nil }
    }

    private func appendUnique(_ value: String, to values: inout [String]) {
        if !values.contains(where: { $0.caseInsensitiveCompare(value) == .orderedSame }) { values.append(value) }
    }
}

protocol DrugImportFormattingService: Sendable {
    func format(packet: TrustedDrugSourcePacket, identity: UserConfirmedDrugIdentity) async throws -> ImportedDrugInfo
}

enum ProfileGenerationGroup: String, CaseIterable, Sendable {
    case identityAndDosing = "identity, uses, dosage forms, and indication-specific dosing"
    case interactionsAndWarnings = "contraindications, warnings, cautions, and the complete categorized interaction list"
    case adverseEffects = "common and serious adverse effects, preserving percentages"
    case reproductiveAndPharmacology = "pregnancy, lactation, mechanism, pharmacokinetics, absorption, distribution, metabolism, and elimination"
    case counselingAndLearning = "counseling, concise Arabic notes, memorization, and source quality"

    var instruction: String {
        "Generate only the \(rawValue) group. Keep every other top-level field present using empty values from the schema. Do not shorten a named-drug list just because it is long."
    }
}

private extension TrustedDrugSourcePacket {
    func scoped(to group: ProfileGenerationGroup?) -> TrustedDrugSourcePacket {
        guard let group else { return self }
        var value = self
        switch group {
        case .identityAndDosing:
            value.contraindicationsText = ""; value.warningsText = ""; value.adverseReactionsText = ""; value.interactionsText = ""; value.pharmacokineticsText = ""; value.pregnancyText = ""
        case .interactionsAndWarnings:
            value.indicationsText = ""; value.dosageText = ""; value.adverseReactionsText = ""; value.pharmacokineticsText = ""; value.pregnancyText = ""; value.dosageFormsText = ""
        case .adverseEffects:
            value.indicationsText = ""; value.dosageText = ""; value.contraindicationsText = ""; value.warningsText = ""; value.interactionsText = ""; value.pharmacokineticsText = ""; value.pregnancyText = ""; value.dosageFormsText = ""
        case .reproductiveAndPharmacology:
            value.indicationsText = ""; value.dosageText = ""; value.contraindicationsText = ""; value.adverseReactionsText = ""; value.interactionsText = ""; value.dosageFormsText = ""
        case .counselingAndLearning:
            value.contraindicationsText = ""; value.interactionsText = ""; value.pharmacokineticsText = ""; value.pregnancyText = ""; value.dosageFormsText = ""
        }
        return value
    }
}

private extension ImportedDrugInfo {
    static func merged(
        parts: [ProfileGenerationGroup: ImportedDrugInfo],
        identity: UserConfirmedDrugIdentity,
        packet: TrustedDrugSourcePacket? = nil
    ) -> ImportedDrugInfo {
        var result = parts[.identityAndDosing] ?? parts.values.first!
        if let value = parts[.interactionsAndWarnings] {
            result.safety = value.safety
            result.interactionEntries = value.interactionEntries
        }
        if let value = parts[.adverseEffects] {
            result.adverseEffects = value.adverseEffects
            result.adverseEffectEntries = value.adverseEffectEntries
        }
        if let value = parts[.reproductiveAndPharmacology] {
            result.pharmacokinetics = value.pharmacokinetics
            result.prodrugInfo = value.prodrugInfo
            result.eliminationInfo = value.eliminationInfo
            result.reproductiveSafety = value.reproductiveSafety
            result.pharmacologyProfile = value.pharmacologyProfile
        }
        if let value = parts[.counselingAndLearning] {
            result.counseling = value.counseling
            result.arabicExplanation = value.arabicExplanation
            result.memorization = value.memorization
            result.sourceQuality = value.sourceQuality
        }
        if let packet {
            result.sourceQuality.sourceName = packet.sourceName
            result.sourceQuality.sourceURL = packet.sourceURL
        }
        result.identity.scientificName = identity.scientificName
        result.identity.tradeNames = identity.tradeNames
        result.identity.activeIngredients = identity.ingredients.isEmpty ? result.identity.activeIngredients : identity.ingredients
        result.identity.marketedStrengthLabel = identity.marketedStrengthLabel.trimmed.isEmpty ? result.identity.marketedStrengthLabel : identity.marketedStrengthLabel
        result.memorization.reviewQuestions = LocalReviewQuestionBuilder.questions(for: result)
        return result
    }
}

actor DeepSeekDrugImportService: DrugImportFormattingService {
    static let model = "deepseek-v4-flash"
    private let session: URLSession
    private let keyStore: DeepSeekKeyStore

    init(session: URLSession? = nil, keyStore: DeepSeekKeyStore = .shared) {
        if let session {
            self.session = session
        } else {
            let configuration = URLSessionConfiguration.default
            configuration.waitsForConnectivity = false
            configuration.timeoutIntervalForRequest = 45
            configuration.timeoutIntervalForResource = 60
            self.session = URLSession(configuration: configuration)
        }
        self.keyStore = keyStore
    }

    func format(packet: TrustedDrugSourcePacket, identity: UserConfirmedDrugIdentity) async throws -> ImportedDrugInfo {
        let apiKey = keyStore.apiKey() ?? ProcessInfo.processInfo.environment["DEEPSEEK_API_KEY"]
        guard let apiKey, !apiKey.trimmed.isEmpty else { throw DrugImportError.missingDeepSeekKey }
        let session = self.session
        let parts = try await withThrowingTaskGroup(of: (ProfileGenerationGroup, ImportedDrugInfo).self) { group in
            for section in ProfileGenerationGroup.allCases {
                group.addTask {
                    let request = try Self.makeRequest(apiKey: apiKey, packet: packet, identity: identity, group: section)
                    let (data, response) = try await session.data(for: request)
                    guard let http = response as? HTTPURLResponse else { throw DrugImportError.invalidResponse }
                    guard (200..<300).contains(http.statusCode) else { throw DrugImportError.deepSeekHTTPStatus(http.statusCode) }
                    let payload = try JSONDecoder().decode(DeepSeekResponse.self, from: data)
                    guard let content = payload.choices.first?.message.content, !content.trimmed.isEmpty else { throw DrugImportError.aiReturnedEmpty }
                    do {
                        return (section, try DrugImportValidator.parse(jsonString: content, confirmedIdentity: identity, packet: packet))
                    } catch DrugImportError.invalidAIJSON where payload.choices.first?.finishReason == "length" {
                        throw DrugImportError.aiResponseTruncated
                    }
                }
            }
            var values: [ProfileGenerationGroup: ImportedDrugInfo] = [:]
            for try await (section, info) in group { values[section] = info }
            return values
        }
        return ImportedDrugInfo.merged(parts: parts, identity: identity, packet: packet)
    }

    static func makeRequest(apiKey: String, packet: TrustedDrugSourcePacket, identity: UserConfirmedDrugIdentity, group: ProfileGenerationGroup? = nil) throws -> URLRequest {
        var request = URLRequest(url: URL(string: "https://api.deepseek.com/chat/completions")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = try JSONEncoder().encode(DeepSeekRequest(
            model: model,
            messages: [
                .init(role: "system", content: PromptBuilder.systemPrompt),
                .init(role: "user", content: [PromptBuilder.userPrompt(identity: identity, packet: packet.scoped(to: group)), group?.instruction].compactMap { $0 }.joined(separator: "\n\n"))
            ],
            thinking: .init(type: "disabled"),
            responseFormat: .init(type: "json_object"),
            temperature: 0,
            maxTokens: 4_000,
            stream: false
        ))
        return request
    }
}

protocol FastDrugGatheringService: Sendable {
    func gather(identity: UserConfirmedDrugIdentity, packageText: String) async throws -> ImportedDrugInfo
}

actor MockFastDrugGatherService: FastDrugGatheringService {
    func gather(identity: UserConfirmedDrugIdentity, packageText: String) async throws -> ImportedDrugInfo {
        var info = try await MockDeepSeekDrugImportService().format(packet: .empty, identity: identity)
        info.sourceQuality = SourceQuality(sourceName: "Generated with AI", sourceURL: "", needsReview: false, missingImportantFields: [], notes: "Mock standalone AI card")
        return info
    }
}

actor DeepSeekFastDrugGatherService: FastDrugGatheringService {
    private let session: URLSession
    private let keyStore: DeepSeekKeyStore

    init(session: URLSession? = nil, keyStore: DeepSeekKeyStore = .shared) {
        if let session {
            self.session = session
        } else {
            let configuration = URLSessionConfiguration.default
            configuration.waitsForConnectivity = false
            configuration.timeoutIntervalForRequest = 45
            configuration.timeoutIntervalForResource = 60
            self.session = URLSession(configuration: configuration)
        }
        self.keyStore = keyStore
    }

    func gather(identity: UserConfirmedDrugIdentity, packageText: String) async throws -> ImportedDrugInfo {
        guard let apiKey = keyStore.apiKey(), !apiKey.trimmed.isEmpty else { throw DrugImportError.missingDeepSeekKey }
        let session = self.session
        let parts = try await withThrowingTaskGroup(of: (ProfileGenerationGroup, ImportedDrugInfo).self) { group in
            for section in ProfileGenerationGroup.allCases {
                group.addTask {
                    let request = try Self.makeRequest(apiKey: apiKey, identity: identity, packageText: packageText, group: section)
                    let (data, response) = try await session.data(for: request)
                    guard let http = response as? HTTPURLResponse else { throw DrugImportError.invalidResponse }
                    guard (200..<300).contains(http.statusCode) else { throw DrugImportError.deepSeekHTTPStatus(http.statusCode) }
                    let payload = try JSONDecoder().decode(DeepSeekResponse.self, from: data)
                    guard let content = payload.choices.first?.message.content, !content.trimmed.isEmpty else { throw DrugImportError.aiReturnedEmpty }
                    do {
                        return (section, try DrugImportValidator.parseAIDraft(jsonString: content, confirmedIdentity: identity, packageText: packageText))
                    } catch DrugImportError.invalidAIJSON where payload.choices.first?.finishReason == "length" {
                        throw DrugImportError.aiResponseTruncated
                    }
                }
            }
            var values: [ProfileGenerationGroup: ImportedDrugInfo] = [:]
            for try await (section, info) in group { values[section] = info }
            return values
        }
        return ImportedDrugInfo.merged(parts: parts, identity: identity)
    }

    static func makeRequest(apiKey: String, identity: UserConfirmedDrugIdentity, packageText: String, group: ProfileGenerationGroup? = nil) throws -> URLRequest {
        var request = URLRequest(url: URL(string: "https://api.deepseek.com/chat/completions")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = try JSONEncoder().encode(DeepSeekRequest(
            model: DeepSeekDrugImportService.model,
            messages: [
                .init(role: "system", content: FastGatherPromptBuilder.systemPrompt),
                .init(role: "user", content: [FastGatherPromptBuilder.userPrompt(identity: identity, packageText: packageText), group?.instruction].compactMap { $0 }.joined(separator: "\n\n"))
            ],
            thinking: .init(type: "disabled"),
            responseFormat: .init(type: "json_object"),
            temperature: 0,
            maxTokens: 4_000,
            stream: false
        ))
        return request
    }
}

private struct DeepSeekRequest: Encodable {
    struct Message: Encodable { var role: String; var content: String }
    struct Thinking: Encodable { var type: String }
    struct ResponseFormat: Encodable { var type: String }
    var model: String
    var messages: [Message]
    var thinking: Thinking
    var responseFormat: ResponseFormat
    var temperature: Double
    var maxTokens: Int
    var stream: Bool
    enum CodingKeys: String, CodingKey {
        case model, messages, thinking, temperature, stream
        case responseFormat = "response_format"
        case maxTokens = "max_tokens"
    }
}

private struct DeepSeekResponse: Decodable {
    struct Choice: Decodable {
        struct Message: Decodable { var content: String? }
        var message: Message
        var finishReason: String?
        enum CodingKeys: String, CodingKey { case message; case finishReason = "finish_reason" }
    }
    var choices: [Choice]
}

enum PromptBuilder {
    static let systemPrompt = """
    You are a pharmacy training formatter inside an iOS app.

    Your job is NOT to invent drug information.
    Your job is to transform trusted source text into a structured, simple, memorable drug card.

    You must use only the trusted source packet provided by the app.
    If the source packet does not contain a specific detail, write "unknown" or "check product leaflet/local pharmacist".
    Do not guess exact values.

    Audience:
    A pharmacy student doing summer training in a community pharmacy.

    Language style:
    Use Arabic explanations with English medical terms.
    Keep drug names, drug classes, mechanisms, pharmacokinetic terms, and safety terms in English.
    Use simple Iraqi/Arabic-friendly wording for patient counseling.
    Avoid long textbook paragraphs.
    Avoid boring writing.
    Make the content easy to memorize.

    Tone:
    Practical, clear, short, pharmacy-focused.
    Explain things like I am learning them from the shelf.
    Use short sentences.
    Use memorable lines.
    No unnecessary details.

    Important:
    Return valid JSON only.
    Do not use markdown.
    Do not write anything outside JSON.
    Do not include repeated disclaimers.
    Safety information belongs only inside the safety fields.
    If information is uncertain, set needsReview = true.
    """

    static func userPrompt(identity: UserConfirmedDrugIdentity, packet: TrustedDrugSourcePacket) -> String {
        """
        Create a structured drug card for my pharmacy training app.

        Use ONLY the trusted source packet below.
        Do not use outside knowledge unless the field is very general and clearly known.
        If a detail is missing from the source, write "unknown" or "check product leaflet/local pharmacist".

        User-confirmed drug data:
        Scientific name / ingredient set: \(identity.scientificName)
        Ingredient components: \(identity.ingredients.map { "\($0.name) \($0.strengthText)" }.joined(separator: " + "))
        Trade name(s): \(identity.tradeNames.joined(separator: ", "))
        Marketed package strength: \(identity.marketedStrengthLabel.isEmpty ? identity.strength : identity.marketedStrengthLabel)
        Dosage form: \(identity.dosageForm)
        Route: \(identity.route)
        System/chapter: \(identity.system)
        Class: derive from the active ingredient and trusted source when confident; otherwise leave it empty and mark source quality for review.

        Trusted source packet:
        Source name: \(packet.sourceName)
        Source URL: \(packet.sourceURL)

        Indications:
        \(packet.indicationsText)

        Dosage and administration:
        \(packet.dosageText)

        Contraindications:
        \(packet.contraindicationsText)

        Warnings and precautions:
        \(packet.warningsText)

        Adverse reactions:
        \(packet.adverseReactionsText)

        Drug interactions:
        \(packet.interactionsText)

        Pharmacokinetics:
        \(packet.pharmacokineticsText)

        Pregnancy/lactation:
        \(packet.pregnancyText)

        Dosage forms:
        \(packet.dosageFormsText)

        Route:
        \(packet.routeText)

        Active ingredient:
        \(packet.activeIngredientText)

        Product leaflet pasted by the user:
        \(packet.leafletText)

        Product leaflet facts override general product-form assumptions when they clearly refer to the confirmed package. Keep general population/indication dosing separate from the captured package strength.

        Detailed extraction requirements:
        - doseRegimens: capture each sourced indication/population separately. Use Adult, Child, Older adult, or Special population and only encode numeric dose math when the source states it.
        - prodrugInfo: say whether the administered compound is already active or is converted to a named active compound, including activation site/pathway when sourced.
        - eliminationInfo: identify the organ/pathway that removes the drug. Use Kidneys / urine, Bile / feces, Lungs / exhalation, Mixed pathways, Other, or Unknown. Add percentages only when stated.
        - Keep every active ingredient and its component strength separate. A marketed total such as "50 mg" is a product label, not an ingredient strength and not a clinical dose.
        - Never infer a numeric dose from package strength alone.
        - dosageFormGroups: include every commonly marketed form and strength found in the sources, grouped by dosage form.
        - clinicalDoses: include every sourced indication separately with the exact regimen text and dosing considerations.
        - interactionEntries: include all named interacting medicines, even when the list is long, and classify each as contraindicated, seriousUseAlternative, monitorClosely, minor, or unknown.
        - adverseEffectEntries: preserve a reported percentage when the source supplies one.
        - reproductiveSafety: write detailed English pregnancy and lactation text plus a concise Arabic note.
        - pharmacologyProfile: preserve mechanism, absorption, distribution, metabolism, and elimination as separate fields.

        Task:
        Fill my app sections using Arabic explanations with English medical terms.

        Output JSON only using this exact structure:
        \(cardJSONSchema)
        """
    }

    static let cardJSONSchema = """
        {
          "identity": {"scientificName": "", "tradeNames": [], "system": "", "class": "", "dosageForm": "", "strength": "", "route": "", "activeIngredients": [{"name": "", "saltForm": "", "strengthValue": null, "strengthUnit": "", "displayStrength": ""}], "marketedStrengthLabel": ""},
          "usesMechanism": {"mainUses": [], "simpleMechanismArabic": "", "mechanismKeywords": []},
          "pharmacokinetics": {"halfLifeDisplay": "", "halfLifeBand": "unknown", "onsetDisplay": "", "onsetBand": "unknown", "durationDisplay": "", "durationBand": "unknown", "dosingFrequency": "unknown", "timesPerDay": null, "prodrugStatus": "unknown", "metabolism": "", "excretionRoute": "unknown", "excretionNotes": "", "pkMemoryLineArabic": ""},
          "safety": {"contraindications": {"severity": "unknown", "items": []}, "toxicity": {"severity": "unknown", "items": []}, "warnings": {"severity": "unknown", "items": []}, "interactions": {"severity": "unknown", "items": []}, "renalCaution": {"severity": "unknown", "note": ""}, "hepaticCaution": {"severity": "unknown", "note": ""}, "pregnancyCaution": {"severity": "unknown", "simpleNoteArabic": ""}},
          "counseling": {"howToTakeArabic": "", "foodInstructionArabic": "", "simplePatientSentenceArabic": "", "whatPatientMayFeelArabic": [], "whenToSeekHelpArabic": [], "missedDoseArabic": ""},
          "arabicExplanation": {"shortExplanation": "", "memoryStory": "", "importantNote": ""},
          "adverseEffects": {"common": [], "serious": []},
          "memorization": {"mustKnow": [], "flashcards": [{"question": "", "answer": ""}], "oneLineSummaryArabic": "", "reviewQuestions": []},
          "doseRegimens": [{"indication": "", "population": "Adult", "formula": "Fixed dose", "route": "", "minimumAgeMonths": null, "maximumAgeMonths": null, "minimumWeightKG": null, "maximumWeightKG": null, "sexRestriction": null, "fixedDoseMG": null, "amountPerKG": null, "amountPerSquareMeter": null, "dividedDoses": 1, "intervalHours": null, "maximumSingleDoseMG": null, "maximumDailyDoseMG": null, "durationText": "", "renalAdjustment": "", "hepaticAdjustment": "", "requiresMeasuredWeight": false, "sourceIDs": []}],
          "prodrugInfo": {"classification": "Unknown", "administeredCompound": "", "activeCompound": "", "activationSite": "", "activationPathway": "", "explanation": "", "sourceIDs": []},
          "eliminationInfo": {"metabolismSite": "", "metabolismEnzymes": [], "routes": [{"pathway": "Unknown", "percentage": null, "detail": ""}], "dominantPathway": "Unknown", "summary": "", "sourceIDs": []},
          "dosageFormGroups": [{"dosageForm": "", "strengths": [{"strength": "", "tradeNames": []}]}],
          "clinicalDoses": [{"indication": "", "population": "Adult", "doseText": "", "route": "", "frequency": "", "duration": "", "adjuncts": [], "considerations": [], "sourceIDs": []}],
          "interactionEntries": [{"drugName": "", "category": "unknown", "effect": "", "management": "", "sourceIDs": []}],
          "adverseEffectEntries": [{"name": "", "incidence": "", "isSerious": false, "sourceIDs": []}],
          "reproductiveSafety": {"pregnancy": "", "lactation": "", "pregnancyArabicNote": "", "lactationArabicNote": "", "sourceIDs": []},
          "pharmacologyProfile": {"mechanismOfAction": "", "absorption": [], "distribution": [], "metabolism": [], "elimination": [], "sourceIDs": []},
          "sourceQuality": {"sourceName": "", "sourceURL": "", "needsReview": true, "missingImportantFields": [], "notes": ""}
        }
        """
    }
private enum FastGatherPromptBuilder {
    static let systemPrompt = """
    You create complete, practical pharmacy learning cards from a confirmed medicine identity and supplied package or leaflet text.
    Fill every relevant field: identity, class, uses, mechanism, indication- and population-specific dose regimens, pharmacokinetics, dosing frequency, precise active-drug/prodrug status, organ/pathway of elimination, adverse effects, safety, and counseling. Never treat package strength as a standard dose. Use "unknown" only when a fact genuinely cannot be established. Keep Arabic explanations short and Iraqi/Arabic-friendly while retaining English medical terms. Return JSON only.

    Keep the response compact. Do not create reviewQuestions; Renlyst builds those locally from the completed card so the clinical card cannot be lost to a long response.
    """

    static func userPrompt(identity: UserConfirmedDrugIdentity, packageText: String) -> String {
        """
        Create a complete, compact pharmacy learning card draft. Trusted source lookup did not return a usable page, so mark unsupported facts for verification.

        Confirmed fields:
        Scientific name: \(identity.scientificName)
        Trade name(s): \(identity.tradeNames.joined(separator: ", "))
        Ingredient components: \(identity.ingredients.map { "\($0.name) \($0.strengthText)" }.joined(separator: " + "))
        Marketed package strength: \(identity.marketedStrengthLabel.isEmpty ? identity.strength : identity.marketedStrengthLabel)
        Dosage form: \(identity.dosageForm)
        Route: \(identity.route)
        System/chapter: \(identity.system)

        Optional package facts recognized by Gemini or pasted leaflet details:
        \(packageText.prefix(2_000))

        Generate the most complete card possible for the confirmed medicine. Keep formulation-dependent claims tied to the confirmed strength, form, and route when those are present. Include exactly three concise Must-Know facts and up to four short flashcards. Set memorization.reviewQuestions to an empty array; Renlyst creates eight review questions locally after decoding.

        Output JSON only using this exact structure:
        \(PromptBuilder.cardJSONSchema)
        """
    }
}

enum DrugImportValidator {
    static func parse(jsonString: String, confirmedIdentity: UserConfirmedDrugIdentity, packet: TrustedDrugSourcePacket) throws -> ImportedDrugInfo {
        var info = try decodedInfo(jsonString)
        info.identity = applyingConfirmedIdentity(to: info.identity, confirmedIdentity: confirmedIdentity)
        info.sourceQuality.sourceName = packet.sourceName
        info.sourceQuality.sourceURL = packet.sourceURL
        var missing = info.sourceQuality.missingImportantFields
        let checks: [(String, String)] = [
            ("indications", packet.indicationsText), ("dosage", packet.dosageText), ("warnings", packet.warningsText),
            ("adverse reactions", packet.adverseReactionsText), ("pharmacokinetics", packet.pharmacokineticsText)
        ]
        for check in checks where check.1.trimmed.isEmpty && !missing.contains(check.0) { missing.append(check.0) }
        if info.identity.class.isEmpty && !missing.contains("drug class") { missing.append("drug class") }
        if packet.isTruncated { info.sourceQuality.needsReview = true; info.sourceQuality.notes = [info.sourceQuality.notes, "Trusted source packet was trimmed before AI formatting."].filter { !$0.trimmed.isEmpty }.joined(separator: " ") }
        info.sourceQuality.missingImportantFields = missing
        if !missing.isEmpty { info.sourceQuality.needsReview = true }
        ensureLearningContent(&info)
        return info
    }

    static func parseAIDraft(jsonString: String, confirmedIdentity: UserConfirmedDrugIdentity, packageText: String) throws -> ImportedDrugInfo {
        var info = try decodedInfo(jsonString)
        info.identity = applyingConfirmedIdentity(to: info.identity, confirmedIdentity: confirmedIdentity)
        info.sourceQuality = SourceQuality(
            sourceName: "Generated with AI",
            sourceURL: "",
            needsReview: true,
            missingImportantFields: info.sourceQuality.missingImportantFields,
            notes: "Generated from the confirmed drug identity. Verify clinical sections against a current label, guideline, or pharmacist before use. Every section remains editable before saving."
        )
        ensureLearningContent(&info)
        return info
    }

    private static func decodedInfo(_ jsonString: String) throws -> ImportedDrugInfo {
        let data = try DeepSeekJSONSanitizer.normalizedCardData(from: jsonString)
        guard var info = try? JSONDecoder().decode(ImportedDrugInfo.self, from: data) else { throw DrugImportError.invalidAIJSON }
        info.doseRegimens = info.doseRegimens?.filter { !$0.indication.trimmed.isEmpty }
        return info
    }

    private static func applyingConfirmedIdentity(to imported: ImportedIdentity, confirmedIdentity identity: UserConfirmedDrugIdentity) -> ImportedIdentity {
        ImportedIdentity(
            scientificName: identity.scientificName,
            tradeNames: identity.tradeNames,
            system: identity.system,
            class: imported.class.trimmed,
            dosageForm: identity.dosageForm,
            strength: identity.strength,
            route: identity.route,
            activeIngredients: identity.ingredients.isEmpty ? imported.activeIngredients : identity.ingredients,
            marketedStrengthLabel: identity.marketedStrengthLabel.trimmed.isEmpty ? imported.marketedStrengthLabel : identity.marketedStrengthLabel
        )
    }

    private static func ensureLearningContent(_ info: inout ImportedDrugInfo) {
        let name = info.identity.scientificName.trimmed
        let trade = info.identity.tradeNames.first?.trimmed ?? ""
        let facts = [
            !trade.isEmpty && !name.isEmpty ? "\(trade) = \(name)" : name,
            info.identity.class.trimmed,
            info.usesMechanism.mainUses.first?.trimmed ?? "",
            info.safety.warnings.items.first?.trimmed ?? "",
            info.counseling.simplePatientSentenceArabic.trimmed
        ].filter { !$0.isEmpty }
        for fact in facts where info.memorization.mustKnow.count < 3 && !info.memorization.mustKnow.contains(fact) {
            info.memorization.mustKnow.append(fact)
        }
        if info.memorization.flashcards.isEmpty {
            if !name.isEmpty { info.memorization.flashcards.append(Flashcard(question: "Scientific name?", answer: name)) }
            if !trade.isEmpty { info.memorization.flashcards.append(Flashcard(question: "Trade name?", answer: trade)) }
            if !info.identity.class.trimmed.isEmpty { info.memorization.flashcards.append(Flashcard(question: "Drug class?", answer: info.identity.class.trimmed)) }
        }
        info.memorization.reviewQuestions = LocalReviewQuestionBuilder.questions(for: info)
    }
}

enum DeepSeekJSONSanitizer {
    private static let optionalNumberKeys: Set<String> = [
        "timesPerDay", "minimumAgeMonths", "maximumAgeMonths", "minimumWeightKG", "maximumWeightKG",
        "fixedDoseMG", "amountPerKG", "amountPerSquareMeter", "dividedDoses", "intervalHours",
        "maximumSingleDoseMG", "maximumDailyDoseMG", "percentage", "strengthValue"
    ]
    private static let integerKeys: Set<String> = ["timesPerDay", "minimumAgeMonths", "maximumAgeMonths", "dividedDoses"]
    private static let stringArrayKeys: Set<String> = [
        "tradeNames", "mainUses", "mechanismKeywords", "items", "whatPatientMayFeelArabic", "whenToSeekHelpArabic",
        "common", "serious", "mustKnow", "choices", "sourceIDs", "metabolismEnzymes", "missingImportantFields"
    ]

    static func objectData(from content: String) throws -> Data {
        let bytes = Array(content.utf8)
        var start: Int?
        var depth = 0
        var isInsideString = false
        var isEscaped = false
        for (index, byte) in bytes.enumerated() {
            if start == nil {
                guard byte == 123 else { continue }
                start = index
                depth = 1
                continue
            }
            if isInsideString {
                if isEscaped { isEscaped = false }
                else if byte == 92 { isEscaped = true }
                else if byte == 34 { isInsideString = false }
                continue
            }
            if byte == 34 { isInsideString = true }
            else if byte == 123 { depth += 1 }
            else if byte == 125 {
                depth -= 1
                if depth == 0, let start { return Data(bytes[start...index]) }
            }
        }
        if let start, let repaired = repairedObjectData(from: Array(bytes[start...])) { return repaired }
        throw DrugImportError.invalidAIJSON
    }

    private static func repairedObjectData(from bytes: [UInt8]) -> Data? {
        var safeCommas: [Int] = []
        var isInsideString = false
        var isEscaped = false
        for (index, byte) in bytes.enumerated() {
            if isInsideString {
                if isEscaped { isEscaped = false }
                else if byte == 92 { isEscaped = true }
                else if byte == 34 { isInsideString = false }
            } else if byte == 34 {
                isInsideString = true
            } else if byte == 44 {
                safeCommas.append(index)
            }
        }
        let cutPoints = [bytes.count] + Array(safeCommas.reversed())
        for cut in cutPoints {
            guard cut > 0, let candidate = closedJSON(Array(bytes[..<cut])) else { continue }
            guard let object = try? JSONSerialization.jsonObject(with: candidate),
                  let dictionary = object as? [String: Any], !dictionary.isEmpty else { continue }
            return candidate
        }
        return nil
    }

    private static func closedJSON(_ prefix: [UInt8]) -> Data? {
        var json = prefix
        var stack: [UInt8] = []
        var isInsideString = false
        var isEscaped = false
        for byte in json {
            if isInsideString {
                if isEscaped { isEscaped = false }
                else if byte == 92 { isEscaped = true }
                else if byte == 34 { isInsideString = false }
                continue
            }
            if byte == 34 { isInsideString = true }
            else if byte == 123 || byte == 91 { stack.append(byte) }
            else if byte == 125 {
                guard stack.last == 123 else { return nil }
                stack.removeLast()
            } else if byte == 93 {
                guard stack.last == 91 else { return nil }
                stack.removeLast()
            }
        }
        if isInsideString {
            if isEscaped, json.last == 92 { json.removeLast() }
            json.append(34)
        }
        while json.last == 9 || json.last == 10 || json.last == 13 || json.last == 32 { json.removeLast() }
        if json.last == 58 { return nil }
        if json.last == 44 { json.removeLast() }
        for opener in stack.reversed() { json.append(opener == 123 ? 125 : 93) }
        return Data(json)
    }

    static func normalizedCardData(from content: String) throws -> Data {
        let object = try JSONSerialization.jsonObject(with: objectData(from: content))
        guard var actual = object as? [String: Any],
              let templateData = PromptBuilder.cardJSONSchema.data(using: .utf8),
              let template = try JSONSerialization.jsonObject(with: templateData) as? [String: Any] else {
            throw DrugImportError.invalidAIJSON
        }
        if var memorization = actual["memorization"] as? [String: Any] {
            memorization["reviewQuestions"] = []
            actual["memorization"] = memorization
        }
        let normalized = normalize(template: template, actual: actual, key: "")
        return try JSONSerialization.data(withJSONObject: normalized)
    }

    private static func normalize(template: Any, actual: Any, key: String) -> Any {
        if let template = template as? [String: Any] {
            let actual = actual as? [String: Any] ?? [:]
            var result = actual
            for (childKey, defaultValue) in template {
                guard let supplied = actual[childKey], !(supplied is NSNull) else {
                    result[childKey] = defaultValue is [Any] ? [] : defaultValue
                    continue
                }
                result[childKey] = normalize(template: defaultValue, actual: supplied, key: childKey)
            }
            return result
        }
        if let template = template as? [Any] {
            guard let actual = actual as? [Any] else { return [] }
            if stringArrayKeys.contains(key) {
                return actual.compactMap { stringValue($0) }.map(\.trimmed).filter { !$0.isEmpty }
            }
            guard let sample = template.first else { return actual }
            return actual.map { normalize(template: sample, actual: $0, key: key) }
        }
        if template is NSNull {
            if optionalNumberKeys.contains(key) { return numberValue(actual, integer: integerKeys.contains(key)) ?? NSNull() }
            if key == "sexRestriction" {
                guard let value = stringValue(actual), !value.trimmed.isEmpty else { return NSNull() }
                return normalizedEnum(value, key: key)
            }
            return actual
        }
        if isBoolean(template) {
            if let value = actual as? Bool { return value }
            return (stringValue(actual)?.lowercased() == "true")
        }
        if template is NSNumber { return numberValue(actual, integer: integerKeys.contains(key)) ?? template }
        if template is String { return normalizedEnum(stringValue(actual) ?? "", key: key) }
        return actual
    }

    private static func stringValue(_ value: Any) -> String? {
        if let value = value as? String { return value }
        if let value = value as? NSNumber { return value.stringValue }
        return nil
    }

    private static func isBoolean(_ value: Any) -> Bool {
        guard let number = value as? NSNumber else { return value is Bool }
        return CFGetTypeID(number) == CFBooleanGetTypeID()
    }

    private static func numberValue(_ value: Any, integer: Bool) -> NSNumber? {
        if let value = value as? NSNumber { return integer ? NSNumber(value: value.intValue) : NSNumber(value: value.doubleValue) }
        guard let text = value as? String, let number = Double(text.replacingOccurrences(of: ",", with: ".")) else { return nil }
        return integer ? NSNumber(value: Int(number)) : NSNumber(value: number)
    }

    private static func normalizedEnum(_ value: String, key: String) -> String {
        let compact = value.trimmed.lowercased().replacingOccurrences(of: "_", with: " ")
        switch key {
        case "population":
            if compact.contains("child") || compact.contains("pediatric") { return DosePopulation.pediatric.rawValue }
            if compact.contains("older") || compact.contains("geriatric") { return DosePopulation.geriatric.rawValue }
            if compact.contains("special") { return DosePopulation.special.rawValue }
            return DosePopulation.adult.rawValue
        case "formula":
            if compact.contains("kg/day") || compact.contains("kg per day") || compact.contains("per kg per day") { return DoseFormulaKind.mgPerKgPerDay.rawValue }
            if compact.contains("kg") { return DoseFormulaKind.mgPerKgPerDose.rawValue }
            if compact.contains("m2") || compact.contains("m²") || compact.contains("square") { return DoseFormulaKind.mgPerSquareMeter.rawValue }
            return DoseFormulaKind.fixed.rawValue
        case "sexRestriction":
            return compact.hasPrefix("f") ? PatientSexAtBirth.female.rawValue : PatientSexAtBirth.male.rawValue
        case "classification":
            if compact.contains("not a prodrug") || compact.contains("active drug") { return ProdrugClassification.activeDrug.rawValue }
            if compact.contains("prodrug") { return ProdrugClassification.prodrug.rawValue }
            if compact.contains("active") { return ProdrugClassification.activeDrug.rawValue }
            return ProdrugClassification.unknown.rawValue
        case "pathway", "dominantPathway":
            if compact.contains("kidney") || compact.contains("renal") || compact.contains("urine") { return EliminationPathway.renalUrine.rawValue }
            if compact.contains("bile") || compact.contains("fec") || compact.contains("hepatic") { return EliminationPathway.biliaryFecal.rawValue }
            if compact.contains("lung") || compact.contains("exhal") { return EliminationPathway.pulmonary.rawValue }
            if compact.contains("mixed") || compact.contains("multiple") { return EliminationPathway.mixed.rawValue }
            if compact == "other" { return EliminationPathway.other.rawValue }
            return EliminationPathway.unknown.rawValue
        default:
            return value
        }
    }
}

private enum LocalReviewQuestionBuilder {
    static func questions(for info: ImportedDrugInfo) -> [GeneratedReviewQuestionDTO] {
        let name = info.identity.scientificName.trimmed.isEmpty ? "this medicine" : info.identity.scientificName.trimmed
        let trade = info.identity.tradeNames.first?.trimmed ?? ""
        var result: [GeneratedReviewQuestionDTO] = []
        func typed(_ prompt: String, _ answer: String, type: QuestionType, field: String) {
            guard !answer.trimmed.isEmpty else { return }
            result.append(.init(prompt: prompt, choices: [], correctAnswer: answer, explanation: answer, questionType: type.rawValue, relatedField: field, difficulty: "medium"))
        }
        func truth(_ statement: String, explanation: String, type: QuestionType, field: String) {
            guard !explanation.trimmed.isEmpty else { return }
            result.append(.init(prompt: "True or false: \(statement)", choices: ["True", "False"], correctAnswer: "True", explanation: explanation, questionType: type.rawValue, relatedField: field, difficulty: "medium"))
        }
        typed("What is the scientific name of \(trade.isEmpty ? "this product" : trade)?", name == "this medicine" ? "" : name, type: .scientificName, field: "identity")
        typed("Name one trade product for \(name).", trade, type: .tradeName, field: "tradeNames")
        truth("\(name) belongs to \(info.identity.class).", explanation: info.identity.class, type: .drugClass, field: "class")
        if let use = info.usesMechanism.mainUses.first { truth("A recorded use of \(name) is \(use).", explanation: use, type: .use, field: "indications") }
        truth("The recorded mechanism for \(name) is: \(info.usesMechanism.simpleMechanismArabic)", explanation: info.usesMechanism.simpleMechanismArabic, type: .use, field: "mechanism")
        truth("The recorded half-life of \(name) is \(info.pharmacokinetics.halfLifeDisplay).", explanation: info.pharmacokinetics.halfLifeDisplay, type: .use, field: "halfLife")
        if let warning = info.safety.warnings.items.first { truth("An important warning for \(name) is \(warning).", explanation: warning, type: .warning, field: "warnings") }
        truth("Patient counseling for \(name) includes: \(info.counseling.simplePatientSentenceArabic)", explanation: info.counseling.simplePatientSentenceArabic, type: .counseling, field: "counseling")
        truth("The elimination summary for \(name) is: \(info.eliminationInfo?.summary ?? "")", explanation: info.eliminationInfo?.summary ?? "", type: .warning, field: "elimination")
        truth("The prodrug note for \(name) is: \(info.prodrugInfo?.explanation ?? "")", explanation: info.prodrugInfo?.explanation ?? "", type: .use, field: "prodrug")
        if result.isEmpty { return [] }
        let base = result
        var index = 0
        while result.count < 8 {
            var copy = base[index % base.count]
            copy.prompt = "Review: " + copy.prompt
            result.append(copy)
            index += 1
        }
        return Array(result.prefix(8))
    }
}

@MainActor
enum DrugImportApplier {
    static func defaultSelection(info: ImportedDrugInfo, drug: Drug?) -> ImportSelection {
        guard let drug else { return ImportSelection(sections: Set(ImportSection.allCases)) }
        var sections: Set<ImportSection> = [.sourceQuality]
        if drug.scientificName.trimmed.isEmpty && drug.tradeNames.isEmpty { sections.insert(.identity) }
        if drug.indications.isEmpty && drug.mechanism.trimmed.isEmpty { sections.insert(.usesMechanism) }
        if drug.halfLifeText.trimmed.isEmpty && drug.halfLifeBand == .unknown { sections.insert(.pharmacokinetics) }
        if drug.warnings.isEmpty && drug.contraindications.isEmpty { sections.insert(.safety) }
        if drug.counselingSentence.trimmed.isEmpty { sections.insert(.counseling) }
        if drug.arabicExplanation.trimmed.isEmpty { sections.insert(.arabicExplanation) }
        if drug.commonSideEffects.isEmpty { sections.insert(.adverseEffects) }
        if drug.mustKnow.isEmpty && drug.flashcards.isEmpty { sections.insert(.memorization) }
        return ImportSelection(sections: sections)
    }

    static func apply(_ info: ImportedDrugInfo, selection: ImportSelection, to drug: Drug, imageData: Data? = nil, thumbnailData: Data? = nil) {
        if selection.contains(.identity) {
            if selection.includes("identity.scientific") { drug.scientificName = info.identity.scientificName }
            if selection.includes("identity.trade") { drug.tradeNames = info.identity.tradeNames }
            if selection.includes("identity.system") { drug.chapterRaw = info.identity.system }
            if selection.includes("identity.class") { drug.drugClass = info.identity.class }
            if selection.includes("identity.form") { drug.dosageForms = [info.identity.dosageForm].filter { !$0.trimmed.isEmpty } }
            if selection.includes("identity.strength") { drug.strengths = [info.identity.strength].filter { !$0.trimmed.isEmpty } }
            if selection.includes("identity.route") { drug.routes = [info.identity.route].filter { !$0.trimmed.isEmpty } }
            drug.isUnknown = false
        }
        if selection.contains(.usesMechanism) {
            if selection.includes("uses.indications") { drug.indications = info.usesMechanism.mainUses }
            if selection.includes("uses.mechanism") { drug.mechanism = info.usesMechanism.simpleMechanismArabic; drug.arabicMechanism = info.usesMechanism.simpleMechanismArabic; drug.mechanismKeywords = info.usesMechanism.mechanismKeywords }
        }
        if selection.contains(.pharmacokinetics) {
            if selection.includes("pk.halfLife") { drug.halfLifeText = info.pharmacokinetics.halfLifeDisplay; drug.halfLifeBand = info.pharmacokinetics.halfLifeBand.drugBand }
            if selection.includes("pk.onset") { drug.onsetText = info.pharmacokinetics.onsetDisplay; drug.onsetBand = info.pharmacokinetics.onsetBand.drugBand }
            if selection.includes("pk.duration") { drug.durationText = info.pharmacokinetics.durationDisplay; drug.durationBand = info.pharmacokinetics.durationBand.drugBand }
            if selection.includes("pk.dosing") { drug.dosingFrequency = info.pharmacokinetics.dosingFrequency.drugFrequency; drug.timesPerDay = info.pharmacokinetics.timesPerDay }
            if selection.includes("pk.prodrug") { drug.prodrugStatus = info.pharmacokinetics.prodrugStatus.drugStatus }
            if selection.includes("pk.excretion") { drug.excretionRoute = info.pharmacokinetics.excretionRoute.drugRoute; drug.excretionNotes = [info.pharmacokinetics.metabolism, info.pharmacokinetics.excretionNotes].compactMap { $0?.trimmed }.filter { !$0.isEmpty }.joined(separator: "\n") }
            if selection.includes("pk.memory") { drug.pkMemoryLineArabic = info.pharmacokinetics.pkMemoryLineArabic }
            if let prodrugInfo = info.prodrugInfo { drug.prodrugInfo = prodrugInfo }
            if let eliminationInfo = info.eliminationInfo { drug.eliminationInfo = eliminationInfo }
        }
        if selection.contains(.safety) {
            if selection.includes("safety.contraindications") { drug.contraindications = info.safety.contraindications.items; drug.contraindicationSeverityRaw = info.safety.contraindications.severity.drugSeverity.rawValue }
            if selection.includes("safety.toxicity") { drug.toxicity = info.safety.toxicity.items.joined(separator: "\n"); drug.toxicitySeverityRaw = info.safety.toxicity.severity.drugSeverity.rawValue }
            if selection.includes("safety.warnings") { drug.warnings = info.safety.warnings.items; drug.warningSeverityRaw = info.safety.warnings.severity.drugSeverity.rawValue }
            if selection.includes("safety.interactions") { drug.interactions = info.safety.interactions.items; drug.interactionSeverityRaw = info.safety.interactions.severity.drugSeverity.rawValue }
            if selection.includes("safety.renal") { drug.renalCaution = info.safety.renalCaution.note; drug.renalSeverityRaw = info.safety.renalCaution.severity.drugSeverity.rawValue }
            if selection.includes("safety.hepatic") { drug.hepaticCaution = info.safety.hepaticCaution.note; drug.hepaticSeverityRaw = info.safety.hepaticCaution.severity.drugSeverity.rawValue }
            if selection.includes("safety.pregnancy") { drug.pregnancyCaution = info.safety.pregnancyCaution.simpleNoteArabic; drug.pregnancySeverityRaw = info.safety.pregnancyCaution.severity.drugSeverity.rawValue }
        }
        if selection.contains(.counseling) {
            if selection.includes("counseling.howTo") { drug.howToTake = info.counseling.howToTakeArabic; drug.counselingHowToTakeArabic = info.counseling.howToTakeArabic }
            if selection.includes("counseling.food") { drug.foodInstruction = info.counseling.foodInstructionArabic; drug.counselingFoodArabic = info.counseling.foodInstructionArabic }
            if selection.includes("counseling.sentence") { drug.counselingSentence = info.counseling.simplePatientSentenceArabic; drug.arabicCounseling = info.counseling.simplePatientSentenceArabic }
            if selection.includes("counseling.feelings") { drug.patientFeelingsArabic = info.counseling.whatPatientMayFeelArabic }
            if selection.includes("counseling.seekHelp") { drug.seekHelpArabic = info.counseling.whenToSeekHelpArabic }
            if selection.includes("counseling.missedDose") { drug.missedDoseArabic = info.counseling.missedDoseArabic }
        }
        if selection.contains(.arabicExplanation) {
            if selection.includes("arabic.explanation") { drug.arabicExplanation = info.arabicExplanation.shortExplanation }
            if selection.includes("arabic.story") { drug.arabicMemoryStory = info.arabicExplanation.memoryStory }
            if selection.includes("arabic.note") { drug.arabicImportantNote = info.arabicExplanation.importantNote }
        }
        if selection.contains(.adverseEffects) {
            if selection.includes("effects.common") { drug.commonSideEffects = info.adverseEffects.common }
            if selection.includes("effects.serious") { drug.seriousSideEffects = info.adverseEffects.serious }
        }
        if selection.contains(.identity), let groups = info.dosageFormGroups, !groups.isEmpty { drug.dosageFormGroups = groups }
        if selection.contains(.identity), let doses = info.clinicalDoses, !doses.isEmpty { drug.clinicalDoses = doses }
        if selection.contains(.safety), let interactions = info.interactionEntries, !interactions.isEmpty { drug.interactionEntries = interactions }
        if selection.contains(.adverseEffects), let effects = info.adverseEffectEntries, !effects.isEmpty { drug.adverseEffectEntries = effects }
        if selection.contains(.safety), let reproductive = info.reproductiveSafety,
           ![reproductive.pregnancy, reproductive.lactation, reproductive.pregnancyArabicNote, reproductive.lactationArabicNote].allSatisfy({ $0.trimmed.isEmpty }) {
            drug.reproductiveSafety = reproductive
        }
        if selection.contains(.pharmacokinetics), let pharmacology = info.pharmacologyProfile,
           !([pharmacology.mechanismOfAction] + pharmacology.absorption + pharmacology.distribution + pharmacology.metabolism + pharmacology.elimination).allSatisfy({ $0.trimmed.isEmpty }) {
            drug.pharmacologyProfile = pharmacology
        }
        if selection.contains(.memorization) {
            if selection.includes("memory.mustKnow") { drug.mustKnow = info.memorization.mustKnow }
            if selection.includes("memory.flashcards") { drug.flashcards = info.memorization.flashcards.map { "\($0.question)\t\($0.answer)" } }
            let reviewItems = (info.memorization.reviewQuestions ?? []).filter { item in
                selection.reviewQuestionPrompts?.contains(item.prompt) ?? true
            }
            if selection.includes("memory.reviewQuestions") { drug.generatedReviewQuestions = reviewItems.compactMap { item in
                let prompt = item.prompt.trimmed
                let answer = item.correctAnswer.trimmed
                guard !prompt.isEmpty, !answer.isEmpty else { return nil }
                var choices = item.choices.map(\.trimmed).filter { !$0.isEmpty }
                if !choices.contains(where: { $0.localizedCaseInsensitiveCompare(answer) == .orderedSame }) { choices.insert(answer, at: 0) }
                choices = choices.reduce(into: [String]()) { values, value in
                    if !values.contains(where: { $0.localizedCaseInsensitiveCompare(value) == .orderedSame }) { values.append(value) }
                }
                let questionType = QuestionType(rawValue: item.questionType) ?? .use
                let interaction: PracticeInteraction
                if questionType == .scientificName || questionType == .tradeName {
                    interaction = .textEntry
                    choices = []
                } else if Set(choices.map { $0.lowercased() }) == Set(["true", "false"]) {
                    interaction = .trueFalse
                } else {
                    guard choices.count >= 3 else { return nil }
                    interaction = .multipleChoice
                    choices = Array(choices.prefix(4))
                }
                return GeneratedReviewQuestion(
                    prompt: prompt,
                    choices: choices,
                    correctAnswer: answer,
                    explanation: item.explanation.trimmed,
                    questionType: questionType,
                    interaction: interaction,
                    relatedField: item.relatedField.trimmed,
                    difficulty: item.difficulty.trimmed.isEmpty ? "medium" : item.difficulty.trimmed
                )
            }; drug.reviewQuestionsNeedRegeneration = false }
            if selection.includes("memory.summary") { drug.oneLineSummaryArabic = info.memorization.oneLineSummaryArabic }
            if selection.includes("memory.flashcards") { drug.patientQuestions = info.memorization.flashcards.map(\.question) }
        }
        if let regimens = info.doseRegimens, !regimens.isEmpty { drug.doseRegimens = regimens }
        if selection.contains(.sourceQuality) || !selection.sections.isEmpty {
            drug.importedSourceName = info.sourceQuality.sourceName
            drug.sourceURL = info.sourceQuality.sourceURL
            drug.sourceNeedsReview = info.sourceQuality.needsReview
            drug.sourceMissingFields = info.sourceQuality.missingImportantFields
            drug.sourceQualityNotes = info.sourceQuality.notes
            drug.sourceUpdatedAt = .now
            let quality: DrugEvidenceQuality = info.sourceQuality.sourceName.localizedCaseInsensitiveContains("Altibbi") ? .altibbi : (info.sourceQuality.sourceName == "Generated with AI" ? .aiUnverified : .officialLabel)
            let sourceID = IngredientIdentity.normalize(info.sourceQuality.sourceURL.isEmpty ? info.sourceQuality.sourceName : info.sourceQuality.sourceURL)
            let values: [(String, String)] = [("identity", drug.scientificName), ("doses", drug.doseRegimensJSON), ("prodrug", drug.prodrugInfoJSON), ("elimination", drug.eliminationInfoJSON), ("safety", drug.warnings.joined(separator: "|"))]
            drug.fieldEvidence = values.filter { !$0.1.trimmed.isEmpty }.map { field, value in
                DrugFieldEvidence(fieldKey: field, sourceID: sourceID, sourceName: info.sourceQuality.sourceName, sourceURL: info.sourceQuality.sourceURL, quality: quality, retrievedAt: .now, valueFingerprint: String(value.hashValue))
            }
        }
        if let imageData { drug.imageData = imageData }
        if let thumbnailData { drug.thumbnailData = thumbnailData }
        DrugDataConsistencyNormalizer.normalize(drug)
        let structuredIngredients = info.identity.activeIngredients?.map(\.name).filter { !$0.trimmed.isEmpty } ?? []
        drug.activeIngredients = structuredIngredients.isEmpty
            ? drug.scientificName.components(separatedBy: "+").map(\.trimmed).filter { !$0.isEmpty }
            : structuredIngredients
        drug.canonicalIngredientKey = IngredientIdentity.canonicalKey(names: drug.activeIngredients, rxNormIDs: drug.rxNormConceptIDs)
        drug.recalculateConfidence()
    }
}

enum DrugDataConsistencyNormalizer {
    static func normalize(_ drug: Drug) {
        drug.routes = drug.routes.map { route in route.localizedCaseInsensitiveCompare("Orak") == .orderedSame ? "Oral" : route }
        if drug.halfLifeHours == nil, let value = normalizedValue(from: drug.halfLifeText, targetUnit: .hours) { drug.halfLifeHours = value }
        if drug.onsetMinutes == nil, let value = normalizedValue(from: drug.onsetText, targetUnit: .minutes) { drug.onsetMinutes = value }
        if drug.durationHours == nil, let value = normalizedValue(from: drug.durationText, targetUnit: .hours) { drug.durationHours = value }
        if let value = drug.halfLifeHours, drug.halfLifeBand == .unknown {
            drug.halfLifeBand = value < 6 ? .short : (value < 24 ? .medium : (value < 72 ? .long : .veryLong))
        }
        if let value = drug.onsetMinutes, drug.onsetBand == .unknown {
            drug.onsetBand = value <= 60 ? .fast : (value <= 240 ? .moderate : .slow)
        }
        if let value = drug.durationHours, drug.durationBand == .unknown {
            drug.durationBand = value < 8 ? .short : (value <= 24 ? .medium : .long)
        }
        if drug.timesPerDay == nil {
            drug.timesPerDay = switch drug.dosingFrequency { case .onceDaily: 1; case .twiceDaily: 2; case .threeTimesDaily: 3; case .fourTimesDaily: 4; default: nil }
        }
    }

    private enum Unit { case minutes, hours }
    private static func normalizedValue(from text: String, targetUnit: Unit) -> Double? {
        let pattern = #"\d+(?:\.\d+)?"#
        guard let regex = try? NSRegularExpression(pattern: pattern), !text.trimmed.isEmpty else { return nil }
        let range = NSRange(text.startIndex..., in: text)
        let numbers = regex.matches(in: text, range: range).compactMap { match -> Double? in
            guard let valueRange = Range(match.range, in: text) else { return nil }
            return Double(text[valueRange])
        }
        guard !numbers.isEmpty else { return nil }
        var value = numbers.prefix(2).reduce(0, +) / Double(min(numbers.count, 2))
        let lower = text.lowercased()
        switch targetUnit {
        case .minutes:
            if lower.contains("hour") || lower.contains(" hr") { value *= 60 }
            else if lower.contains("day") { value *= 1_440 }
        case .hours:
            if lower.contains("minute") || lower.contains(" min") { value /= 60 }
            else if lower.contains("day") { value *= 24 }
        }
        return value
    }
}

private extension PKBand {
    var drugBand: HalfLifeBand {
        switch self { case .unknown: .unknown; case .short: .short; case .medium: .medium; case .long: .long; case .veryLong: .veryLong }
    }
}

private extension ImportedOnsetBand {
    var drugBand: OnsetBand {
        switch self { case .unknown: .unknown; case .fast: .fast; case .moderate: .moderate; case .slow: .slow }
    }
}

private extension ImportedDurationBand {
    var drugBand: DurationBand {
        switch self { case .unknown: .unknown; case .short: .short; case .medium: .medium; case .long: .long }
    }
}

private extension ImportedDosingFrequency {
    var drugFrequency: DosingFrequency {
        switch self {
        case .unknown: .unknown
        case .onceDaily: .onceDaily
        case .twiceDaily: .twiceDaily
        case .threeTimesDaily: .threeTimesDaily
        case .fourTimesDaily: .fourTimesDaily
        case .PRN: .asNeeded
        case .other: .other
        }
    }
}

private extension ImportedProdrugStatus {
    var drugStatus: ProdrugStatus {
        switch self { case .unknown: .unknown; case .active: .active; case .prodrug: .prodrug }
    }
}

private extension ImportedExcretionRoute {
    var drugRoute: ExcretionRoute {
        switch self { case .unknown: .unknown; case .renal: .renal; case .hepatic: .hepatic; case .mixed: .mixed; case .other: .unknown }
    }
}

private extension Severity {
    var drugSeverity: SafetySeverity {
        switch self { case .unknown: .unknown; case .low: .low; case .medium: .medium; case .high: .high }
    }
}

actor MockDrugSourceProvider: DrugSourceProvider {
    let sourceName = "DailyMed"
    private let result = DrugSearchResult(id: "mock-label", displayName: "MOCK DRUG TABLET [DAILYMED TEST]", activeIngredient: "Mock Drug", dosageForm: "Tablet", sourceName: "DailyMed")

    func searchDrug(query: String) async throws -> [DrugSearchResult] {
        query.trimmed.isEmpty ? [] : [result]
    }

    func fetchDrugDetails(id: String) async throws -> TrustedDrugSourcePacket {
        TrustedDrugSourcePacket(
            sourceName: "DailyMed",
            sourceURL: "https://dailymed.nlm.nih.gov/dailymed/drugInfo.cfm?setid=mock-label",
            indicationsText: "Mock imported use.",
            dosageText: "Take once daily.",
            contraindicationsText: "Mock contraindication.",
            warningsText: "Mock warning.",
            adverseReactionsText: "Mock nausea.",
            interactionsText: "Mock interaction.",
            pharmacokineticsText: "Half-life is 4 hours.",
            pregnancyText: "Mock pregnancy caution.",
            dosageFormsText: "Tablet",
            routeText: "Oral",
            activeIngredientText: "Mock Drug",
            lastUpdatedText: "Jun 15, 2025",
            isTruncated: false
        )
    }
}

actor MockDeepSeekDrugImportService: DrugImportFormattingService {
    func format(packet: TrustedDrugSourcePacket, identity: UserConfirmedDrugIdentity) async throws -> ImportedDrugInfo {
        ImportedDrugInfo(
            identity: ImportedIdentity(scientificName: identity.scientificName, tradeNames: identity.tradeNames, system: identity.system, class: identity.drugClass, dosageForm: identity.dosageForm, strength: identity.strength, route: identity.route),
            usesMechanism: ImportedUsesMechanism(mainUses: ["Mock imported use"], simpleMechanismArabic: "\(identity.scientificName) mock mechanism بالعربي مع English terms.", mechanismKeywords: ["mock", "trusted packet"]),
            pharmacokinetics: ImportedPK(halfLifeDisplay: "Half-life is 4 hours", halfLifeBand: .short, onsetDisplay: "unknown", onsetBand: .unknown, durationDisplay: "unknown", durationBand: .unknown, dosingFrequency: .onceDaily, prodrugStatus: .active, excretionRoute: .renal, pkMemoryLineArabic: "Mock PK line بالعربي."),
            safety: ImportedSafety(
                contraindications: SafetyCategory(severity: .medium, items: ["Mock contraindication"]),
                toxicity: SafetyCategory(severity: .low, items: ["Mock toxicity"]),
                warnings: SafetyCategory(severity: .medium, items: ["Mock warning"]),
                interactions: SafetyCategory(severity: .medium, items: ["Mock interaction"]),
                renalCaution: SafetyNote(severity: .medium, note: "Mock renal caution"),
                hepaticCaution: SafetyNote(severity: .low, note: "Mock hepatic caution"),
                pregnancyCaution: PregnancySafetyNote(severity: .high, simpleNoteArabic: "راجع النشرة/الصيدلي المحلي.")
            ),
            counseling: ImportedCounseling(howToTakeArabic: "ينتاخذ حسب النشرة.", foodInstructionArabic: "check product leaflet/local pharmacist", simplePatientSentenceArabic: "هذا كارت تدريبي من مصدر موثوق.", whatPatientMayFeelArabic: ["غثيان خفيف"], whenToSeekHelpArabic: ["أعراض شديدة"], missedDoseArabic: "لا تضاعف الجرعة."),
            arabicExplanation: ImportedArabicExplanation(shortExplanation: "شرح مختصر للتدريب.", memoryStory: "قصة قصيرة للحفظ.", importantNote: "لا تعتمد على AI كمصدر طبي."),
            adverseEffects: ImportedAdverseEffects(common: ["Mock nausea"], serious: ["Mock serious effect"]),
            memorization: ImportedMemorization(mustKnow: ["\(identity.tradeNames.first ?? "") = \(identity.scientificName)", "Class = \(identity.drugClass)"], flashcards: [Flashcard(question: "Scientific name?", answer: identity.scientificName), Flashcard(question: "Class?", answer: identity.drugClass)], oneLineSummaryArabic: "ملخص سريع للحفظ."),
            sourceQuality: SourceQuality(sourceName: packet.sourceName, sourceURL: packet.sourceURL, needsReview: packet.isTruncated, missingImportantFields: [], notes: "Mock formatting.")
        )
    }
}

final class DeepSeekKeyStore: @unchecked Sendable {
    static let shared = DeepSeekKeyStore()
    private let service: String
    private let account: String
    private let fallbackDirectory: URL
    private let allowsKeychain: Bool
    private let allowsProtectedFile: Bool
    private let preferences: UserDefaults

    enum StorageLocation: String, Equatable, Sendable {
        case keychain
        case protectedFile
        case appPreferences

        var label: String {
            switch self {
            case .keychain: "iOS Keychain"
            case .protectedFile: "protected device storage"
            case .appPreferences: "app preferences"
            }
        }
    }

    enum KeyStoreError: LocalizedError, Equatable {
        case keychain(OSStatus)
        case readBackFailed

        var errorDescription: String? {
            switch self {
            case .keychain(let status):
                let message = SecCopyErrorMessageString(status, nil) as String? ?? "unknown Keychain error"
                return "Keychain error \(status): \(message)"
            case .readBackFailed:
                return "Keychain saved the key but could not read it back."
            }
        }
    }

    init(
        service: String = "com.renlyst.deepseek",
        account: String = "api-key",
        fallbackDirectory: URL? = nil,
        allowsKeychain: Bool = true,
        allowsProtectedFile: Bool = true,
        preferences: UserDefaults = .standard
    ) {
        self.service = service
        self.account = account
        self.fallbackDirectory = fallbackDirectory ?? FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        self.allowsKeychain = allowsKeychain
        self.allowsProtectedFile = allowsProtectedFile
        self.preferences = preferences
    }

    func apiKey() -> String? { try? storedKey()?.value }

    func savedKeyStatusDescription() -> String {
        do {
            guard let stored = try storedKey(), !stored.value.trimmed.isEmpty else { return "No DeepSeek key saved" }
            return "Saved key ••••\(stored.value.suffix(4)) via \(stored.location.label)"
        } catch {
            return "Saved key is unavailable: \(error.localizedDescription)"
        }
    }

    private func storedKey() throws -> (value: String, location: StorageLocation)? {
        var keychainError: Error?
        var protectedFileError: Error?
        if allowsKeychain {
            do {
                if let key = try storedAPIKey() { return (key, .keychain) }
            } catch {
                keychainError = error
            }
        }
        if allowsProtectedFile {
            do {
                if let key = try storedFallbackKey() { return (key, .protectedFile) }
            } catch {
                protectedFileError = error
            }
        }
        if let key = storedPreferencesKey() { return (key, .appPreferences) }
        if let keychainError { throw keychainError }
        if let protectedFileError { throw protectedFileError }
        return nil
    }

    private func storedAPIKey() throws -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        if status == errSecItemNotFound { return nil }
        guard status == errSecSuccess else { throw KeyStoreError.keychain(status) }
        guard let data = item as? Data else { throw KeyStoreError.readBackFailed }
        return String(data: data, encoding: .utf8)
    }

    @discardableResult
    func save(apiKey: String) throws -> StorageLocation {
        let apiKey = apiKey.normalizedAPIKey
        guard !apiKey.isEmpty else { throw DrugImportError.missingDeepSeekKey }
        if allowsKeychain {
            do {
                try saveToKeychain(apiKey)
                deleteFallback()
                return .keychain
            } catch {
                // Re-signed/sideloaded applications can lack a Keychain access group.
            }
        }
        if allowsProtectedFile {
            do {
                try saveToFallback(apiKey)
                guard try storedFallbackKey() == apiKey else { throw KeyStoreError.readBackFailed }
                deletePreferences()
                return .protectedFile
            } catch {
                // Some sideloaded installations do not permit protected-file writes.
            }
        }
        saveToPreferences(apiKey)
        guard storedPreferencesKey() == apiKey else { throw KeyStoreError.readBackFailed }
        return .appPreferences
    }

    private func saveToKeychain(_ apiKey: String) throws {
        let data = Data(apiKey.utf8)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        var add = query
        add[kSecValueData as String] = data
        add[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        let addStatus = SecItemAdd(add as CFDictionary, nil)
        if addStatus == errSecDuplicateItem {
            let update = [kSecValueData as String: data]
            let updateStatus = SecItemUpdate(query as CFDictionary, update as CFDictionary)
            guard updateStatus == errSecSuccess else { throw KeyStoreError.keychain(updateStatus) }
        } else if addStatus != errSecSuccess {
            throw KeyStoreError.keychain(addStatus)
        }
        guard try storedAPIKey() == apiKey else { throw KeyStoreError.readBackFailed }
    }

    func maskedKeyDescription() -> String? {
        guard let stored = try? storedKey(), !stored.value.trimmed.isEmpty else { return nil }
        return "Saved key ••••\(stored.value.suffix(4))"
    }

    func testConnection(session: URLSession = .shared) async throws -> String {
        guard let stored = try storedKey(), !stored.value.trimmed.isEmpty else { throw DrugImportError.missingDeepSeekKey }
        var request = URLRequest(url: URL(string: "https://api.deepseek.com/models")!)
        request.setValue("Bearer \(stored.value)", forHTTPHeaderField: "Authorization")
        let (_, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse else { throw DrugImportError.invalidResponse }
        guard (200..<300).contains(http.statusCode) else { throw DrugImportError.deepSeekHTTPStatus(http.statusCode) }
        return "DeepSeek connection is ready (\(stored.location.label))"
    }

    func delete() {
        deleteFallback()
        deletePreferences()
        guard allowsKeychain else { return }
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess && status != errSecItemNotFound {
            #if DEBUG
            print("DeepSeek key delete failed: \(status)")
            #endif
        }
    }

    private var fallbackURL: URL { fallbackDirectory.appendingPathComponent("deepseek-api-key.bin", isDirectory: false) }
    private var preferenceKey: String { "DeepSeekKeyStore.\(service).\(account).v1" }

    private func storedFallbackKey() throws -> String? {
        let url = fallbackURL
        guard FileManager.default.fileExists(atPath: url.path) else { return nil }
        guard let key = String(data: try Data(contentsOf: url), encoding: .utf8) else { throw KeyStoreError.readBackFailed }
        return key
    }

    private func saveToFallback(_ apiKey: String) throws {
        try FileManager.default.createDirectory(at: fallbackDirectory, withIntermediateDirectories: true)
        var url = fallbackURL
        try Data(apiKey.utf8).write(to: url, options: [.atomic, .completeFileProtection])
        var values = URLResourceValues()
        values.isExcludedFromBackup = true
        try url.setResourceValues(values)
    }

    private func deleteFallback() { try? FileManager.default.removeItem(at: fallbackURL) }

    private func storedPreferencesKey() -> String? {
        guard let key = preferences.string(forKey: preferenceKey), !key.trimmed.isEmpty else { return nil }
        return key
    }

    private func saveToPreferences(_ apiKey: String) { preferences.set(apiKey, forKey: preferenceKey) }
    private func deletePreferences() { preferences.removeObject(forKey: preferenceKey) }
}

final class GeminiKeyStore: @unchecked Sendable {
    static let shared = GeminiKeyStore()
    private let storage: DeepSeekKeyStore

    init(storage: DeepSeekKeyStore = DeepSeekKeyStore(
        service: "com.renlyst.gemini",
        account: "api-key",
        fallbackDirectory: FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("gemini", isDirectory: true)
    )) {
        self.storage = storage
    }

    func apiKey() -> String? { storage.apiKey() }

    func savedKeyStatusDescription() -> String {
        storage.maskedKeyDescription() ?? "No Gemini key saved"
    }

    @discardableResult
    func save(apiKey: String) throws -> DeepSeekKeyStore.StorageLocation {
        guard !apiKey.normalizedAPIKey.isEmpty else { throw DrugImportError.missingGeminiKey }
        return try storage.save(apiKey: apiKey)
    }

    func delete() { storage.delete() }

    func testConnection(session: URLSession = .shared) async throws -> String {
        guard let apiKey = apiKey(), !apiKey.trimmed.isEmpty else { throw DrugImportError.missingGeminiKey }
        var request = URLRequest(url: URL(string: "https://generativelanguage.googleapis.com/v1beta/models")!)
        request.setValue(apiKey, forHTTPHeaderField: "x-goog-api-key")
        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse else { throw DrugImportError.invalidResponse }
        guard (200..<300).contains(http.statusCode) else {
            throw DrugImportError.geminiHTTPStatus(http.statusCode, GeminiPackageVisionService.errorDetail(from: data))
        }
        return "Gemini 2.5 Flash connection is ready"
    }
}

private extension String {
    var nilIfEmpty: String? { isEmpty ? nil : self }
}
