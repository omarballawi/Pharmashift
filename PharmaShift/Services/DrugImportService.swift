import Foundation
import ImageIO
import Security
import UIKit
import Vision

struct OCRDrugCandidate: Codable, Equatable, Sendable {
    var rawText: String
    var possibleScientificName: String?
    var possibleTradeName: String?
    var possibleStrength: String?
    var possibleDosageForm: String?
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

    var isComplete: Bool {
        !scientificName.trimmed.isEmpty && !tradeNames.joined().trimmed.isEmpty && !strength.trimmed.isEmpty
            && !dosageForm.trimmed.isEmpty && !route.trimmed.isEmpty && !system.trimmed.isEmpty && !drugClass.trimmed.isEmpty
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
}

struct ImportedIdentity: Codable, Equatable, Sendable {
    var scientificName: String
    var tradeNames: [String]
    var system: String
    var `class`: String
    var dosageForm: String
    var strength: String
    var route: String
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
    func contains(_ section: ImportSection) -> Bool { sections.contains(section) }
}

enum DrugImportError: LocalizedError, Equatable {
    case invalidQuery
    case invalidResponse
    case parsingFailed
    case missingDeepSeekKey
    case invalidAIJSON
    case aiReturnedEmpty

    var errorDescription: String? {
        switch self {
        case .invalidQuery: "Enter a confirmed drug name first."
        case .invalidResponse: "The trusted source returned an unexpected response. Please try again."
        case .parsingFailed: "The trusted source label could not be read."
        case .missingDeepSeekKey: "Add your DeepSeek API key in Settings before using AI formatting."
        case .invalidAIJSON: "DeepSeek did not return valid JSON. Retry formatting from the same trusted source packet."
        case .aiReturnedEmpty: "DeepSeek returned an empty response. Retry formatting from the same trusted source packet."
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
        return [RxNormProvider(), DailyMedProvider(), OpenFDALabelProvider()]
    }

    static func aiDefault() -> any DrugImportFormattingService {
        if ProcessInfo.processInfo.arguments.contains("-mockDrugImport") {
            return MockDeepSeekDrugImportService()
        }
        return DeepSeekDrugImportService()
    }
}

actor OCRService {
    func recognize(image: UIImage) async throws -> OCRDrugCandidate {
        guard let cgImage = image.cgImage else { throw ImagePipelineError.invalidImage }
        let request = VNRecognizeTextRequest()
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        request.recognitionLanguages = ["en-US", "ar"]
        let handler = VNImageRequestHandler(cgImage: cgImage, orientation: CGImagePropertyOrientation(image.imageOrientation), options: [:])
        try handler.perform([request])
        let lines = request.results?.compactMap { $0.topCandidates(1).first?.string } ?? []
        return Self.candidate(from: lines)
    }

    static func candidate(from lines: [String]) -> OCRDrugCandidate {
        let cleaned = lines.map { $0.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression).trimmed }.filter { !$0.isEmpty }
        let rawText = cleaned.joined(separator: "\n")
        let strength = cleaned.first { $0.range(of: #"(?i)\b\d+(?:\.\d+)?\s*(mg|mcg|g|ml|iu|%)\b"#, options: .regularExpression) != nil }
        let forms = ["tablet", "capsule", "injection", "solution", "suspension", "cream", "ointment", "gel", "spray", "drops", "syrup", "patch"]
        let dosageForm = cleaned.first { line in forms.contains { line.localizedCaseInsensitiveContains($0) } }
        let nameCandidates = cleaned.filter { line in
            line.count >= 3 && line.range(of: #"\d"#, options: .regularExpression) == nil && !forms.contains(where: { line.localizedCaseInsensitiveContains($0) })
        }
        return OCRDrugCandidate(
            rawText: rawText,
            possibleScientificName: nameCandidates.dropFirst().first ?? nameCandidates.first,
            possibleTradeName: nameCandidates.first,
            possibleStrength: strength,
            possibleDosageForm: dosageForm
        )
    }
}

private extension CGImagePropertyOrientation {
    init(_ orientation: UIImage.Orientation) {
        switch orientation {
        case .up: self = .up
        case .down: self = .down
        case .left: self = .left
        case .right: self = .right
        case .upMirrored: self = .upMirrored
        case .downMirrored: self = .downMirrored
        case .leftMirrored: self = .leftMirrored
        case .rightMirrored: self = .rightMirrored
        @unknown default: self = .up
        }
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
        func trim(_ keys: [String]) -> String {
            let joined = keys.compactMap { sections[$0] }.filter { !$0.trimmed.isEmpty }.joined(separator: "\n\n")
            let value = compact(joined, limit: sectionLimit)
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
            interactionsText: trim(["interactions", "34073-7", "drug_interactions"]),
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

actor DeepSeekDrugImportService: DrugImportFormattingService {
    static let model = "deepseek-v4-flash"
    private let session: URLSession
    private let keyStore: DeepSeekKeyStore

    init(session: URLSession = .shared, keyStore: DeepSeekKeyStore = .shared) {
        self.session = session
        self.keyStore = keyStore
    }

    func format(packet: TrustedDrugSourcePacket, identity: UserConfirmedDrugIdentity) async throws -> ImportedDrugInfo {
        let apiKey = keyStore.apiKey() ?? ProcessInfo.processInfo.environment["DEEPSEEK_API_KEY"]
        guard let apiKey, !apiKey.trimmed.isEmpty else { throw DrugImportError.missingDeepSeekKey }
        let request = try Self.makeRequest(apiKey: apiKey, packet: packet, identity: identity)
        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else { throw DrugImportError.invalidResponse }
        let payload = try JSONDecoder().decode(DeepSeekResponse.self, from: data)
        guard let content = payload.choices.first?.message.content, !content.trimmed.isEmpty else { throw DrugImportError.aiReturnedEmpty }
        return try DrugImportValidator.parse(jsonString: content, confirmedIdentity: identity, packet: packet)
    }

    static func makeRequest(apiKey: String, packet: TrustedDrugSourcePacket, identity: UserConfirmedDrugIdentity) throws -> URLRequest {
        var request = URLRequest(url: URL(string: "https://api.deepseek.com/chat/completions")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = try JSONEncoder().encode(DeepSeekRequest(
            model: model,
            messages: [
                .init(role: "system", content: PromptBuilder.systemPrompt),
                .init(role: "user", content: PromptBuilder.userPrompt(identity: identity, packet: packet))
            ],
            thinking: .init(type: "disabled"),
            responseFormat: .init(type: "json_object"),
            temperature: 0,
            maxTokens: 4_500,
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
    struct Choice: Decodable { struct Message: Decodable { var content: String? }; var message: Message }
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
        Scientific name: \(identity.scientificName)
        Trade name(s): \(identity.tradeNames.joined(separator: ", "))
        Strength: \(identity.strength)
        Dosage form: \(identity.dosageForm)
        Route: \(identity.route)
        System/chapter: \(identity.system)
        Class: \(identity.drugClass)

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

        Task:
        Fill my app sections using Arabic explanations with English medical terms.

        Output JSON only using this exact structure:
        {
          "identity": {"scientificName": "", "tradeNames": [], "system": "", "class": "", "dosageForm": "", "strength": "", "route": ""},
          "usesMechanism": {"mainUses": [], "simpleMechanismArabic": "", "mechanismKeywords": []},
          "pharmacokinetics": {"halfLifeDisplay": "", "halfLifeBand": "unknown", "onsetDisplay": "", "onsetBand": "unknown", "durationDisplay": "", "durationBand": "unknown", "dosingFrequency": "unknown", "prodrugStatus": "unknown", "excretionRoute": "unknown", "pkMemoryLineArabic": ""},
          "safety": {"contraindications": {"severity": "unknown", "items": []}, "toxicity": {"severity": "unknown", "items": []}, "warnings": {"severity": "unknown", "items": []}, "interactions": {"severity": "unknown", "items": []}, "renalCaution": {"severity": "unknown", "note": ""}, "hepaticCaution": {"severity": "unknown", "note": ""}, "pregnancyCaution": {"severity": "unknown", "simpleNoteArabic": ""}},
          "counseling": {"howToTakeArabic": "", "foodInstructionArabic": "", "simplePatientSentenceArabic": "", "whatPatientMayFeelArabic": [], "whenToSeekHelpArabic": [], "missedDoseArabic": ""},
          "arabicExplanation": {"shortExplanation": "", "memoryStory": "", "importantNote": ""},
          "adverseEffects": {"common": [], "serious": []},
          "memorization": {"mustKnow": [], "flashcards": [{"question": "", "answer": ""}], "oneLineSummaryArabic": ""},
          "sourceQuality": {"sourceName": "", "sourceURL": "", "needsReview": true, "missingImportantFields": [], "notes": ""}
        }
        """
    }
}

enum DrugImportValidator {
    static func parse(jsonString: String, confirmedIdentity: UserConfirmedDrugIdentity, packet: TrustedDrugSourcePacket) throws -> ImportedDrugInfo {
        let trimmed = jsonString.trimmed
        guard trimmed.first == "{", trimmed.last == "}" else { throw DrugImportError.invalidAIJSON }
        guard let data = trimmed.data(using: .utf8) else { throw DrugImportError.invalidAIJSON }
        var info: ImportedDrugInfo
        do { info = try JSONDecoder().decode(ImportedDrugInfo.self, from: data) }
        catch { throw DrugImportError.invalidAIJSON }
        info.identity = ImportedIdentity(
            scientificName: confirmedIdentity.scientificName,
            tradeNames: confirmedIdentity.tradeNames,
            system: confirmedIdentity.system,
            class: confirmedIdentity.drugClass,
            dosageForm: confirmedIdentity.dosageForm,
            strength: confirmedIdentity.strength,
            route: confirmedIdentity.route
        )
        info.sourceQuality.sourceName = packet.sourceName
        info.sourceQuality.sourceURL = packet.sourceURL
        var missing = info.sourceQuality.missingImportantFields
        let checks: [(String, String)] = [
            ("indications", packet.indicationsText), ("dosage", packet.dosageText), ("warnings", packet.warningsText),
            ("adverse reactions", packet.adverseReactionsText), ("pharmacokinetics", packet.pharmacokineticsText)
        ]
        for check in checks where check.1.trimmed.isEmpty && !missing.contains(check.0) { missing.append(check.0) }
        if packet.isTruncated { info.sourceQuality.needsReview = true; info.sourceQuality.notes = [info.sourceQuality.notes, "Trusted source packet was trimmed before AI formatting."].filter { !$0.trimmed.isEmpty }.joined(separator: " ") }
        info.sourceQuality.missingImportantFields = missing
        if !missing.isEmpty { info.sourceQuality.needsReview = true }
        return info
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
            drug.scientificName = info.identity.scientificName
            drug.tradeNames = info.identity.tradeNames
            drug.chapterRaw = info.identity.system
            drug.drugClass = info.identity.class
            drug.dosageForms = [info.identity.dosageForm].filter { !$0.trimmed.isEmpty }
            drug.strengths = [info.identity.strength].filter { !$0.trimmed.isEmpty }
            drug.routes = [info.identity.route].filter { !$0.trimmed.isEmpty }
            drug.isUnknown = false
        }
        if selection.contains(.usesMechanism) {
            drug.indications = info.usesMechanism.mainUses
            drug.mechanism = info.usesMechanism.simpleMechanismArabic
            drug.arabicMechanism = info.usesMechanism.simpleMechanismArabic
            drug.mechanismKeywords = info.usesMechanism.mechanismKeywords
        }
        if selection.contains(.pharmacokinetics) {
            drug.halfLifeText = info.pharmacokinetics.halfLifeDisplay
            drug.halfLifeBand = info.pharmacokinetics.halfLifeBand.drugBand
            drug.onsetText = info.pharmacokinetics.onsetDisplay
            drug.onsetBand = info.pharmacokinetics.onsetBand.drugBand
            drug.durationText = info.pharmacokinetics.durationDisplay
            drug.durationBand = info.pharmacokinetics.durationBand.drugBand
            drug.dosingFrequency = info.pharmacokinetics.dosingFrequency.drugFrequency
            drug.prodrugStatus = info.pharmacokinetics.prodrugStatus.drugStatus
            drug.excretionRoute = info.pharmacokinetics.excretionRoute.drugRoute
            drug.pkMemoryLineArabic = info.pharmacokinetics.pkMemoryLineArabic
        }
        if selection.contains(.safety) {
            drug.contraindications = info.safety.contraindications.items
            drug.contraindicationSeverityRaw = info.safety.contraindications.severity.drugSeverity.rawValue
            drug.toxicity = info.safety.toxicity.items.joined(separator: "\n")
            drug.toxicitySeverityRaw = info.safety.toxicity.severity.drugSeverity.rawValue
            drug.warnings = info.safety.warnings.items
            drug.warningSeverityRaw = info.safety.warnings.severity.drugSeverity.rawValue
            drug.interactions = info.safety.interactions.items
            drug.interactionSeverityRaw = info.safety.interactions.severity.drugSeverity.rawValue
            drug.renalCaution = info.safety.renalCaution.note
            drug.renalSeverityRaw = info.safety.renalCaution.severity.drugSeverity.rawValue
            drug.hepaticCaution = info.safety.hepaticCaution.note
            drug.hepaticSeverityRaw = info.safety.hepaticCaution.severity.drugSeverity.rawValue
            drug.pregnancyCaution = info.safety.pregnancyCaution.simpleNoteArabic
            drug.pregnancySeverityRaw = info.safety.pregnancyCaution.severity.drugSeverity.rawValue
        }
        if selection.contains(.counseling) {
            drug.howToTake = info.counseling.howToTakeArabic
            drug.foodInstruction = info.counseling.foodInstructionArabic
            drug.counselingSentence = info.counseling.simplePatientSentenceArabic
            drug.arabicCounseling = info.counseling.simplePatientSentenceArabic
            drug.counselingHowToTakeArabic = info.counseling.howToTakeArabic
            drug.counselingFoodArabic = info.counseling.foodInstructionArabic
            drug.patientFeelingsArabic = info.counseling.whatPatientMayFeelArabic
            drug.seekHelpArabic = info.counseling.whenToSeekHelpArabic
            drug.missedDoseArabic = info.counseling.missedDoseArabic
        }
        if selection.contains(.arabicExplanation) {
            drug.arabicExplanation = info.arabicExplanation.shortExplanation
            drug.arabicMemoryStory = info.arabicExplanation.memoryStory
            drug.arabicImportantNote = info.arabicExplanation.importantNote
        }
        if selection.contains(.adverseEffects) {
            drug.commonSideEffects = info.adverseEffects.common
            drug.seriousSideEffects = info.adverseEffects.serious
        }
        if selection.contains(.memorization) {
            drug.mustKnow = info.memorization.mustKnow
            drug.flashcards = info.memorization.flashcards.map { "\($0.question)\t\($0.answer)" }
            drug.oneLineSummaryArabic = info.memorization.oneLineSummaryArabic
            drug.patientQuestions = info.memorization.flashcards.map(\.question)
        }
        if selection.contains(.sourceQuality) || !selection.sections.isEmpty {
            drug.importedSourceName = info.sourceQuality.sourceName
            drug.sourceURL = info.sourceQuality.sourceURL
            drug.sourceNeedsReview = info.sourceQuality.needsReview
            drug.sourceMissingFields = info.sourceQuality.missingImportantFields
            drug.sourceQualityNotes = info.sourceQuality.notes
        }
        if let imageData { drug.imageData = imageData }
        if let thumbnailData { drug.thumbnailData = thumbnailData }
        drug.recalculateConfidence()
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
    private let service = "com.pharmashift.deepseek"
    private let account = "api-key"

    func apiKey() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var item: CFTypeRef?
        guard SecItemCopyMatching(query as CFDictionary, &item) == errSecSuccess,
              let data = item as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }

    func save(apiKey: String) throws {
        let data = Data(apiKey.utf8)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        let update: [String: Any] = [kSecValueData as String: data]
        let status = SecItemUpdate(query as CFDictionary, update as CFDictionary)
        if status == errSecItemNotFound {
            var add = query
            add[kSecValueData as String] = data
            let addStatus = SecItemAdd(add as CFDictionary, nil)
            guard addStatus == errSecSuccess else { throw DrugImportError.invalidResponse }
        } else if status != errSecSuccess {
            throw DrugImportError.invalidResponse
        }
    }

    func delete() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        SecItemDelete(query as CFDictionary)
    }
}

private extension String {
    var nilIfEmpty: String? { isEmpty ? nil : self }
}
