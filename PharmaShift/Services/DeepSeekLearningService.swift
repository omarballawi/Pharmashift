import Foundation

struct ResolvedDrugIdentity: Codable, Equatable, Sendable {
    var scientificName: String
    var dosageForm: String
    var route: String
    var confidence: String
}

protocol DrugIdentityResolving: Sendable {
    func resolve(identity: UserConfirmedDrugIdentity, ocrText: String) async throws -> ResolvedDrugIdentity
}

actor DeepSeekIdentityResolver: DrugIdentityResolving {
    func resolve(identity: UserConfirmedDrugIdentity, ocrText: String) async throws -> ResolvedDrugIdentity {
        let prompt = """
        Return JSON only. Identify a medicine package from the names and OCR text below. Return a scientificName only if you are confident. dosageForm and route may be empty. Do not provide dosing, treatment, or safety advice.
        {"scientificName":"","dosageForm":"","route":"","confidence":"low|medium|high"}
        Names: \(identity.tradeNames.joined(separator: ", ")) \(identity.scientificName)
        OCR: \(ocrText.prefix(1200))
        """
        let data = try await DeepSeekJSONClient.complete(prompt: prompt, maxTokens: 220)
        let result = try JSONDecoder().decode(ResolvedDrugIdentity.self, from: data)
        guard !result.scientificName.trimmed.isEmpty, result.confidence.lowercased() != "low" else { throw DrugImportError.unresolvedLocalBrand }
        return result
    }
}

struct AIPracticePack: Codable, Equatable {
    var generatedAt: Date
    var libraryFingerprint: String
    var questions: [PracticeQuestion]
}

enum AIPracticePackStore {
    private static let key = "ai-practice-pack-v1"
    static func load() -> AIPracticePack? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(AIPracticePack.self, from: data)
    }
    static func save(_ pack: AIPracticePack) {
        if let data = try? JSONEncoder().encode(pack) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}

actor DeepSeekPracticeService {
    func makePack(from drugs: [Drug]) async throws -> AIPracticePack {
        let candidates = drugs.filter { !$0.isUnknown }
            .sorted {
                let leftPriority = $0.confidenceLevel == .weak ? 0 : 1
                let rightPriority = $1.confidenceLevel == .weak ? 0 : 1
                if leftPriority != rightPriority { return leftPriority < rightPriority }
                return $0.nextReviewDate < $1.nextReviewDate
            }
            .prefix(8)
        guard !candidates.isEmpty else { throw DrugImportError.invalidQuery }
        let snapshots = candidates.map { drug in
            "id=\(drug.id.uuidString); name=\(drug.displayName); trade=\(drug.tradeNames.joined(separator: ",")); class=\(drug.drugClass); use=\(drug.indications.prefix(2).joined(separator: " | ")); warning=\(drug.warnings.prefix(2).joined(separator: " | ")); counsel=\(drug.counselingSentence); cards=\(drug.flashcards.prefix(2).joined(separator: " | "))"
        }.joined(separator: "\n")
        let prompt = """
        Return JSON only. Create exactly five short, ADHD-friendly pharmacy learning questions using only these local drug facts. Focus on weak/due drugs. Each question must reference sourceDrugID, have a short prompt, exact answer, optional 3-4 choices with the answer included, a one-sentence explanation, and questionType from Scientific name, Trade name, Class, Use, Warning, Counseling. Do not invent clinical facts, patient advice, doses, or cases.
        {"questions":[{"sourceDrugID":"UUID","prompt":"","answer":"","choices":[""],"explanation":"","questionType":"Use"}]}
        Library:\n\(snapshots)
        """
        let data = try await DeepSeekJSONClient.complete(prompt: prompt, maxTokens: 1_100)
        let payload = try JSONDecoder().decode(AIPracticePayload.self, from: data)
        let byID = Dictionary(uniqueKeysWithValues: candidates.map { ($0.id.uuidString, $0) })
        let questions = try payload.questions.map { item -> PracticeQuestion in
            guard let drug = byID[item.sourceDrugID], !item.prompt.trimmed.isEmpty, !item.answer.trimmed.isEmpty else { throw DrugImportError.invalidAIJSON }
            let choices = Array(Set((item.choices ?? [String]()).filter { !$0.trimmed.isEmpty })).sorted()
            let interaction: PracticeInteraction = choices.count >= 2 && choices.contains(where: { $0.localizedCaseInsensitiveCompare(item.answer) == .orderedSame }) ? .multipleChoice : .recall
            return PracticeQuestion(drugID: drug.id, drugName: drug.displayName, prompt: item.prompt.trimmed, correctAnswer: item.answer.trimmed, choices: interaction == .multipleChoice ? choices : [], explanation: item.explanation?.trimmed, questionType: QuestionType(rawValue: item.questionType) ?? .use, interaction: interaction)
        }
        guard questions.count == 5 else { throw DrugImportError.invalidAIJSON }
        let fingerprint = candidates.map { "\($0.id.uuidString):\($0.dateAdded.timeIntervalSince1970)" }.joined(separator: "|")
        return AIPracticePack(generatedAt: .now, libraryFingerprint: fingerprint, questions: questions)
    }
}

private struct AIPracticePayload: Decodable { var questions: [AIPracticeQuestion] }
private struct AIPracticeQuestion: Decodable { var sourceDrugID: String; var prompt: String; var answer: String; var choices: [String]?; var explanation: String?; var questionType: String }

private enum DeepSeekJSONClient {
    static func complete(prompt: String, maxTokens: Int) async throws -> Data {
        guard let key = DeepSeekKeyStore.shared.apiKey(), !key.trimmed.isEmpty else { throw DrugImportError.missingDeepSeekKey }
        var request = URLRequest(url: URL(string: "https://api.deepseek.com/chat/completions")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(key)", forHTTPHeaderField: "Authorization")
        request.httpBody = try JSONSerialization.data(withJSONObject: ["model": "deepseek-v4-flash", "messages": [["role": "system", "content": "Return valid JSON only."], ["role": "user", "content": prompt]], "thinking": ["type": "disabled"], "response_format": ["type": "json_object"], "temperature": 0, "max_tokens": maxTokens, "stream": false])
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else { throw DrugImportError.invalidResponse }
        let responseBody = try JSONDecoder().decode(DeepSeekContentResponse.self, from: data)
        guard let content = responseBody.choices.first?.message.content, let contentData = content.data(using: .utf8) else { throw DrugImportError.aiReturnedEmpty }
        return contentData
    }
}

private struct DeepSeekContentResponse: Decodable {
    struct Choice: Decodable { struct Message: Decodable { var content: String? }; var message: Message }
    var choices: [Choice]
}
