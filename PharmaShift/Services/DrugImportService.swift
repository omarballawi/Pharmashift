import Foundation

protocol DrugInfoProvider: Sendable {
    func searchDrug(query: String) async throws -> [DrugSearchResult]
    func fetchDrugDetails(id: String) async throws -> ImportedDrugInfo
}

struct DrugSearchResult: Identifiable, Codable, Hashable, Sendable {
    var id: String { labelID }
    var genericName: String
    var brandNames: [String]
    var formulation: String
    var labelTitle: String
    var updateDate: Date?
    var labelID: String
}

enum ImportField: String, Codable, CaseIterable, Identifiable, Sendable {
    case scientificName = "Scientific name"
    case tradeNames = "Trade names"
    case dosageForms = "Dosage forms"
    case strengths = "Strengths"
    case indications = "Indications / uses"
    case howToTake = "Dosage & administration"
    case commonSideEffects = "Adverse reactions"
    case warnings = "Warnings"
    case mechanism = "Mechanism"
    case contraindications = "Contraindications"
    case interactions = "Interactions"
    case halfLifeText = "Pharmacokinetics"
    case halfLifeHours = "Numeric half-life"
    case onsetMinutes = "Numeric onset"
    case durationHours = "Numeric duration"
    case renalCaution = "Renal use"
    case hepaticCaution = "Hepatic use"
    case pregnancyCaution = "Pregnancy"
    case counselingSentence = "Patient counseling"

    var id: String { rawValue }
}

struct ImportSelection: Equatable, Sendable {
    var fields: Set<ImportField>
    func contains(_ field: ImportField) -> Bool { fields.contains(field) }
}

struct ImportedDrugInfo: Sendable {
    var scientificName: String?
    var tradeNames: [String]?
    var dosageForms: [String]?
    var strengths: [String]?
    var indications: [String]?
    var howToTake: String?
    var commonSideEffects: [String]?
    var warnings: [String]?
    var mechanism: String?
    var contraindications: [String]?
    var interactions: [String]?
    var halfLifeText: String?
    var halfLifeHours: Double?
    var onsetMinutes: Double?
    var durationHours: Double?
    var renalCaution: String?
    var hepaticCaution: String?
    var pregnancyCaution: String?
    var counselingSentence: String?
    var rawSectionText: [String: String]
    var sourceName: String
    var sourceURL: URL
    var sourceUpdatedAt: Date?

    func displayValue(for field: ImportField) -> String? {
        switch field {
        case .scientificName: scientificName
        case .tradeNames: tradeNames?.joined(separator: ", ")
        case .dosageForms: dosageForms?.joined(separator: ", ")
        case .strengths: strengths?.joined(separator: ", ")
        case .indications: indications?.joined(separator: "\n")
        case .howToTake: howToTake
        case .commonSideEffects: commonSideEffects?.joined(separator: "\n")
        case .warnings: warnings?.joined(separator: "\n")
        case .mechanism: mechanism
        case .contraindications: contraindications?.joined(separator: "\n")
        case .interactions: interactions?.joined(separator: "\n")
        case .halfLifeText: halfLifeText
        case .halfLifeHours: halfLifeHours.map { String(format: "%.2g hours", $0) }
        case .onsetMinutes: onsetMinutes.map { String(format: "%.2g minutes", $0) }
        case .durationHours: durationHours.map { String(format: "%.2g hours", $0) }
        case .renalCaution: renalCaution
        case .hepaticCaution: hepaticCaution
        case .pregnancyCaution: pregnancyCaution
        case .counselingSentence: counselingSentence
        }
    }
}

enum DrugImportError: LocalizedError {
    case invalidQuery
    case invalidResponse
    case parsingFailed

    var errorDescription: String? {
        switch self {
        case .invalidQuery: "Enter a scientific drug name first."
        case .invalidResponse: "DailyMed returned an unexpected response. Please try again."
        case .parsingFailed: "The official label could not be read."
        }
    }
}

enum DrugImportApplier {
    static func defaultSelection(info: ImportedDrugInfo, drug: Drug) -> ImportSelection {
        ImportSelection(fields: Set(ImportField.allCases.filter { field in
            guard info.displayValue(for: field)?.trimmed.isEmpty == false else { return false }
            return currentValue(for: field, drug: drug).trimmed.isEmpty
        }))
    }

    static func apply(_ info: ImportedDrugInfo, selection: ImportSelection, to drug: Drug) {
        for field in selection.fields {
            switch field {
            case .scientificName: if let value = info.scientificName { drug.scientificName = value }
            case .tradeNames: if let value = info.tradeNames { drug.tradeNames = value }
            case .dosageForms: if let value = info.dosageForms { drug.dosageForms = value }
            case .strengths: if let value = info.strengths { drug.strengths = value }
            case .indications: if let value = info.indications { drug.indications = value }
            case .howToTake: if let value = info.howToTake { drug.howToTake = value }
            case .commonSideEffects: if let value = info.commonSideEffects { drug.commonSideEffects = value }
            case .warnings: if let value = info.warnings { drug.warnings = value }
            case .mechanism: if let value = info.mechanism { drug.mechanism = value }
            case .contraindications: if let value = info.contraindications { drug.contraindications = value }
            case .interactions: if let value = info.interactions { drug.interactions = value }
            case .halfLifeText: if let value = info.halfLifeText { drug.halfLifeText = value }
            case .halfLifeHours: if let value = info.halfLifeHours { drug.halfLifeHours = value }
            case .onsetMinutes: if let value = info.onsetMinutes { drug.onsetMinutes = value }
            case .durationHours: if let value = info.durationHours { drug.durationHours = value }
            case .renalCaution: if let value = info.renalCaution { drug.renalCaution = value }
            case .hepaticCaution: if let value = info.hepaticCaution { drug.hepaticCaution = value }
            case .pregnancyCaution: if let value = info.pregnancyCaution { drug.pregnancyCaution = value }
            case .counselingSentence: if let value = info.counselingSentence { drug.counselingSentence = value }
            }
        }
        if !selection.fields.isEmpty {
            drug.importedSourceName = info.sourceName
            drug.sourceURL = info.sourceURL.absoluteString
            drug.sourceUpdatedAt = info.sourceUpdatedAt
        }
    }

    static func currentValue(for field: ImportField, drug: Drug) -> String {
        switch field {
        case .scientificName: drug.scientificName
        case .tradeNames: drug.tradeNames.joined(separator: ", ")
        case .dosageForms: drug.dosageForms.joined(separator: ", ")
        case .strengths: drug.strengths.joined(separator: ", ")
        case .indications: drug.indications.joined(separator: "\n")
        case .howToTake: drug.howToTake
        case .commonSideEffects: drug.commonSideEffects.joined(separator: "\n")
        case .warnings: drug.warnings.joined(separator: "\n")
        case .mechanism: drug.mechanism
        case .contraindications: drug.contraindications.joined(separator: "\n")
        case .interactions: drug.interactions.joined(separator: "\n")
        case .halfLifeText: drug.halfLifeText
        case .halfLifeHours: drug.halfLifeHours.map { String($0) } ?? ""
        case .onsetMinutes: drug.onsetMinutes.map { String($0) } ?? ""
        case .durationHours: drug.durationHours.map { String($0) } ?? ""
        case .renalCaution: drug.renalCaution
        case .hepaticCaution: drug.hepaticCaution
        case .pregnancyCaution: drug.pregnancyCaution
        case .counselingSentence: drug.counselingSentence
        }
    }
}

enum ConservativeNumericExtractor {
    static func halfLifeHours(from text: String) -> Double? { extract(keyword: "half[- ]?life", from: text, outputUnit: .hours) }
    static func onsetMinutes(from text: String) -> Double? { extract(keyword: "onset", from: text, outputUnit: .minutes) }
    static func durationHours(from text: String) -> Double? { extract(keyword: "duration", from: text, outputUnit: .hours) }

    private enum OutputUnit { case minutes, hours }

    private static func extract(keyword: String, from text: String, outputUnit: OutputUnit) -> Double? {
        let pattern = "(?i)\\b\(keyword)\\b[^.\\n]{0,80}?([0-9]+(?:\\.[0-9]+)?)\\s*(minutes?|mins?|hours?|hrs?|days?)\\b"
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return nil }
        let range = NSRange(text.startIndex..., in: text)
        let matches = regex.matches(in: text, range: range)
        var values: [Double] = []
        for match in matches {
            guard match.numberOfRanges == 3,
                  let numberRange = Range(match.range(at: 1), in: text),
                  let unitRange = Range(match.range(at: 2), in: text),
                  let number = Double(text[numberRange]) else { continue }
            let prefixStart = max(0, match.range.location)
            let prefixLength = max(0, match.range(at: 1).location - prefixStart)
            let prefix = (text as NSString).substring(with: NSRange(location: prefixStart, length: prefixLength))
            if prefix.range(of: "[0-9]\\s*(?:-|–|to)\\s*$", options: .regularExpression) != nil { continue }
            let minutes: Double
            let unit = text[unitRange].lowercased()
            if unit.hasPrefix("day") { minutes = number * 1_440 }
            else if unit.hasPrefix("hour") || unit.hasPrefix("hr") { minutes = number * 60 }
            else { minutes = number }
            values.append(minutes)
        }
        let unique = Set(values.map { Int(($0 * 1_000).rounded()) })
        guard values.count == 1, unique.count == 1, let minutes = values.first else { return nil }
        return outputUnit == .minutes ? minutes : minutes / 60
    }
}

actor MockDrugInfoProvider: DrugInfoProvider {
    let results: [DrugSearchResult]
    let details: [String: ImportedDrugInfo]

    init(results: [DrugSearchResult], details: [String: ImportedDrugInfo]) {
        self.results = results
        self.details = details
    }

    func searchDrug(query: String) async throws -> [DrugSearchResult] {
        let query = query.trimmed
        guard !query.isEmpty else { throw DrugImportError.invalidQuery }
        return results.filter { $0.genericName.localizedCaseInsensitiveContains(query) || $0.labelTitle.localizedCaseInsensitiveContains(query) }
    }

    func fetchDrugDetails(id: String) async throws -> ImportedDrugInfo {
        guard let value = details[id] else { throw DrugImportError.invalidResponse }
        return value
    }
}

enum DrugInfoProviderFactory {
    static func appDefault() -> any DrugInfoProvider {
        guard ProcessInfo.processInfo.arguments.contains("-mockDrugImport") else { return DailyMedProvider() }
        let result = DrugSearchResult(genericName: "Mock Drug", brandNames: ["Mock Brand"], formulation: "Tablet", labelTitle: "MOCK DRUG TABLET [DAILYMED TEST]", updateDate: Date(timeIntervalSince1970: 1_750_000_000), labelID: "mock-label")
        let alternate = DrugSearchResult(genericName: "Mock Drug", brandNames: ["Mock Brand XR"], formulation: "Extended Release Tablet", labelTitle: "MOCK DRUG EXTENDED RELEASE TABLET [DAILYMED TEST]", updateDate: result.updateDate, labelID: "mock-label-xr")
        let info = ImportedDrugInfo(
            scientificName: "Mock Drug", tradeNames: ["Mock Brand"], dosageForms: ["Tablet"], strengths: ["10 mg"],
            indications: ["Mock imported use"], howToTake: "Take once daily", commonSideEffects: ["Mock nausea"], warnings: ["Mock warning"],
            mechanism: "Mock mechanism", contraindications: ["Mock contraindication"], interactions: ["Mock interaction"],
            halfLifeText: "Half-life is 4 hours", halfLifeHours: 4, onsetMinutes: nil, durationHours: nil,
            renalCaution: "Mock renal caution", hepaticCaution: "Mock hepatic caution", pregnancyCaution: "Mock pregnancy caution",
            counselingSentence: "Mock counseling", rawSectionText: [:], sourceName: "DailyMed",
            sourceURL: URL(string: "https://dailymed.nlm.nih.gov/dailymed/drugInfo.cfm?setid=mock-label")!,
            sourceUpdatedAt: result.updateDate
        )
        return MockDrugInfoProvider(results: [result, alternate], details: [result.labelID: info, alternate.labelID: info])
    }
}

actor DailyMedProvider: DrugInfoProvider {
    private let session: URLSession
    private var resultCache: [String: DrugSearchResult] = [:]

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
        try validate(response)
        let payload = try JSONDecoder().decode(DailyMedSearchPayload.self, from: data)
        let results = payload.data.map { item in
            let parsed = Self.parseTitle(item.title)
            return DrugSearchResult(genericName: parsed.generic, brandNames: parsed.brands, formulation: parsed.formulation, labelTitle: item.title, updateDate: Self.dateFormatter.date(from: item.publishedDate), labelID: item.setid)
        }
        for result in results { resultCache[result.labelID] = result }
        return results
    }

    func fetchDrugDetails(id: String) async throws -> ImportedDrugInfo {
        guard let url = URL(string: "https://dailymed.nlm.nih.gov/dailymed/services/v2/spls/\(id).xml") else { throw DrugImportError.invalidResponse }
        let (data, response) = try await session.data(from: url)
        try validate(response)
        let metadata = resultCache[id]
        return try SPLParser.parse(data: data, labelID: id, metadata: metadata)
    }

    private func validate(_ response: URLResponse) throws {
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else { throw DrugImportError.invalidResponse }
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter(); formatter.locale = Locale(identifier: "en_US_POSIX"); formatter.dateFormat = "MMM dd, yyyy"; return formatter
    }()

    private static func parseTitle(_ title: String) -> (generic: String, brands: [String], formulation: String) {
        let ownerStart = title.lastIndex(of: "[")
        let withoutOwner = ownerStart.map { String(title[..<$0]) } ?? title
        let formWords = ["TABLET", "CAPSULE", "INJECTION", "SOLUTION", "SUSPENSION", "CREAM", "OINTMENT", "GEL", "SPRAY", "PATCH", "POWDER", "AEROSOL", "LOTION", "DROPS"]
        let upper = withoutOwner.uppercased()
        let form = formWords.first(where: { upper.contains(" \($0)") }) ?? ""
        let generic: String
        if let formRange = form.isEmpty ? nil : upper.range(of: " \(form)") { generic = String(withoutOwner[..<formRange.lowerBound]).trimmed }
        else { generic = withoutOwner.trimmed }
        return (generic.capitalized, [], form.capitalized)
    }
}

private struct DailyMedSearchPayload: Decodable {
    struct Item: Decodable {
        var publishedDate: String
        var title: String
        var setid: String
        enum CodingKeys: String, CodingKey { case publishedDate = "published_date", title, setid }
    }
    var data: [Item]
}

enum SPLParser {
    static let sectionCodes: [String: ImportField] = [
        "34067-9": .indications, "34068-7": .howToTake, "34070-3": .contraindications,
        "43685-7": .warnings, "34071-1": .warnings, "34084-4": .commonSideEffects,
        "34073-7": .interactions, "43679-0": .mechanism, "43682-4": .halfLifeText,
        "88828-9": .renalCaution, "88829-5": .hepaticCaution, "42228-7": .pregnancyCaution,
        "88436-1": .counselingSentence
    ]

    static func parse(data: Data, labelID: String, metadata: DrugSearchResult? = nil) throws -> ImportedDrugInfo {
        let delegate = SPLXMLDelegate()
        let parser = XMLParser(data: data)
        parser.delegate = delegate
        guard parser.parse() else { throw parser.parserError ?? DrugImportError.parsingFailed }
        let sections = delegate.sections.mapValues(normalize)
        let pk = sections["43682-4"]
        let allText = sections.values.joined(separator: "\n")
        let officialURL = URL(string: "https://dailymed.nlm.nih.gov/dailymed/drugInfo.cfm?setid=\(labelID)")!
        let genericName = delegate.genericNames.first ?? metadata?.genericName
        let brands = delegate.brandNames.filter { brand in
            guard let genericName else { return true }
            return brand.caseInsensitiveCompare(genericName) != .orderedSame
        }
        return ImportedDrugInfo(
            scientificName: genericName,
            tradeNames: brands.nilIfEmpty,
            dosageForms: delegate.forms.nilIfEmpty,
            strengths: delegate.strengths.nilIfEmpty,
            indications: sections["34067-9"].map { [$0] },
            howToTake: sections["34068-7"],
            commonSideEffects: sections["34084-4"].map { [$0] },
            warnings: combined(sections, codes: ["43685-7", "34071-1"]).map { [$0] },
            mechanism: sections["43679-0"],
            contraindications: sections["34070-3"].map { [$0] },
            interactions: sections["34073-7"].map { [$0] },
            halfLifeText: pk,
            halfLifeHours: pk.flatMap(ConservativeNumericExtractor.halfLifeHours),
            onsetMinutes: ConservativeNumericExtractor.onsetMinutes(from: allText),
            durationHours: ConservativeNumericExtractor.durationHours(from: allText),
            renalCaution: sections["88828-9"],
            hepaticCaution: sections["88829-5"],
            pregnancyCaution: sections["42228-7"],
            counselingSentence: sections["88436-1"],
            rawSectionText: sections,
            sourceName: "DailyMed",
            sourceURL: officialURL,
            sourceUpdatedAt: metadata?.updateDate
        )
    }

    private static func normalize(_ text: String) -> String {
        text.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression).trimmed
    }

    private static func combined(_ sections: [String: String], codes: [String]) -> String? {
        codes.compactMap { sections[$0] }.filter { !$0.isEmpty }.joined(separator: "\n\n").nilIfEmpty
    }
}

private final class SPLXMLDelegate: NSObject, XMLParserDelegate {
    var sections: [String: String] = [:]
    var genericNames: [String] = []
    var brandNames: [String] = []
    var forms: [String] = []
    var strengths: [String] = []
    private var sectionStack: [String?] = []
    private var currentSectionCode: String?
    private var captureTextDepth = 0
    private var textBuffer = ""
    private var genericDepth = 0
    private var materialDepth = 0
    private var captureNameKind: NameKind?
    private var valueBuffer = ""
    private enum NameKind { case generic, brand }

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
        let name = elementName.lowercased()
        if name == "section" { sectionStack.append(currentSectionCode); currentSectionCode = nil }
        if name == "code", !sectionStack.isEmpty, let code = attributeDict["code"], SPLParser.sectionCodes[code] != nil { currentSectionCode = code }
        if name == "text", !sectionStack.isEmpty { captureTextDepth += 1; if captureTextDepth == 1 { textBuffer = "" } }
        if captureTextDepth > 0, name == "br" || name == "paragraph" || name == "item" { textBuffer += "\n" }
        if name == "genericmedicine" { genericDepth += 1 }
        if name == "manufacturedmaterial" { materialDepth += 1 }
        if name == "name", genericDepth > 0 { captureNameKind = .generic; valueBuffer = "" }
        else if name == "name", materialDepth > 0, genericDepth == 0 { captureNameKind = .brand; valueBuffer = "" }
        if name == "formcode", let value = attributeDict["displayName"] { appendUnique(value, to: &forms) }
        if name == "strength", let value = attributeDict["value"] { appendUnique(value, to: &strengths) }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if captureTextDepth > 0 { textBuffer += string }
        if captureNameKind != nil { valueBuffer += string }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        let name = elementName.lowercased()
        if name == "text", captureTextDepth > 0 {
            captureTextDepth -= 1
            if captureTextDepth == 0, let code = currentSectionCode { sections[code, default: ""] += " " + textBuffer }
        }
        if name == "name", let kind = captureNameKind {
            let value = valueBuffer.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression).trimmed
            if !value.isEmpty { if kind == .generic { appendUnique(value, to: &genericNames) } else { appendUnique(value, to: &brandNames) } }
            captureNameKind = nil
        }
        if name == "genericmedicine" { genericDepth = max(0, genericDepth - 1) }
        if name == "manufacturedmaterial" { materialDepth = max(0, materialDepth - 1) }
        if name == "section" { currentSectionCode = sectionStack.popLast() ?? nil }
    }

    private func appendUnique(_ value: String, to values: inout [String]) {
        if !values.contains(where: { $0.caseInsensitiveCompare(value) == .orderedSame }) { values.append(value) }
    }
}

private extension Array {
    var nilIfEmpty: Self? { isEmpty ? nil : self }
}

private extension String {
    var nilIfEmpty: String? { isEmpty ? nil : self }
}
