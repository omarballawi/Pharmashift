import Foundation

struct ResolvedDrugIdentity: Codable, Equatable, Sendable {
    var scientificName: String
    var dosageForm: String
    var route: String
    var confidence: String
}

protocol DrugIdentityResolving: Sendable {
    func resolve(identity: UserConfirmedDrugIdentity, packageText: String) async throws -> ResolvedDrugIdentity
}

actor DeepSeekIdentityResolver: DrugIdentityResolving {
    func resolve(identity: UserConfirmedDrugIdentity, packageText: String) async throws -> ResolvedDrugIdentity {
        let prompt = """
        Return JSON only. Resolve a medicine identity from the confirmed names and package facts below. Return a scientificName only if you are confident. dosageForm and route may be empty. Do not provide dosing, treatment, or safety advice.
        {"scientificName":"","dosageForm":"","route":"","confidence":"low|medium|high"}
        Names: \(identity.tradeNames.joined(separator: ", ")) \(identity.scientificName)
        Package facts: \(packageText.prefix(1200))
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
    private var allowsAIRequests = true

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
        Return JSON only. Create exactly five short, ADHD-friendly pharmacy learning questions using only these local drug facts. Focus on weak/due drugs. Scientific name and Trade name questions require typed spelling and must have no choices. Every other question must be either four-option MCQ or True/False. Each question must reference sourceDrugID, have a short prompt, exact answer, choices when required, a one-sentence explanation, and questionType from Scientific name, Trade name, Class, Use, Warning, Counseling. Do not invent clinical facts, patient advice, doses, or cases.
        {"questions":[{"sourceDrugID":"UUID","prompt":"","answer":"","choices":[""],"explanation":"","questionType":"Use"}]}
        Library:\n\(snapshots)
        """
        let byID = Dictionary(uniqueKeysWithValues: candidates.map { ($0.id.uuidString, $0) })
        var questions: [PracticeQuestion] = []
        if allowsAIRequests {
            do {
                let data = try await DeepSeekJSONClient.complete(prompt: prompt, maxTokens: 1_100)
                let payload = try JSONDecoder().decode(AIPracticePayload.self, from: data)
                questions = payload.questions.compactMap { item -> PracticeQuestion? in
                    guard let drug = byID[item.sourceDrugID], !item.prompt.trimmed.isEmpty, !item.answer.trimmed.isEmpty else { return nil }
                    let questionType = QuestionType(rawValue: item.questionType) ?? .use
                    var choices = Array(Set((item.choices ?? [String]()).filter { !$0.trimmed.isEmpty })).sorted()
                    let interaction: PracticeInteraction
                    var prompt = item.prompt.trimmed
                    var answer = item.answer.trimmed
                    if questionType == .scientificName || questionType == .tradeName {
                        choices = []
                        interaction = .textEntry
                    } else if choices.count >= 2 && choices.contains(where: { $0.localizedCaseInsensitiveCompare(answer) == .orderedSame }) {
                        interaction = Set(choices.map { $0.lowercased() }) == Set(["true", "false"]) ? .trueFalse : .multipleChoice
                    } else {
                        prompt = "True or false: \(answer)"
                        answer = "True"
                        choices = ["True", "False"]
                        interaction = .trueFalse
                    }
                    return PracticeQuestion(drugID: drug.id, drugName: drug.displayName, prompt: prompt, correctAnswer: answer, choices: choices, explanation: item.explanation?.trimmed, questionType: questionType, interaction: interaction)
                }
            } catch {
                allowsAIRequests = false
            }
        }
        let local = PracticeGenerator.generate(mode: .smartSession, drugs: Array(candidates))
        appendUnique(local, to: &questions, limit: 5)
        guard !questions.isEmpty else { throw DrugImportError.invalidAIJSON }
        while questions.count < 5 { questions.append(questions[0]) }
        questions = Array(questions.prefix(5))
        let fingerprint = candidates.map { "\($0.id.uuidString):\($0.dateAdded.timeIntervalSince1970)" }.joined(separator: "|")
        return AIPracticePack(generatedAt: .now, libraryFingerprint: fingerprint, questions: questions)
    }

    func makeQuestionSet(for drug: Drug) async throws -> [GeneratedReviewQuestion] {
        let snapshot = "name=\(drug.displayName); trade=\(drug.effectiveTradeNames.joined(separator: ",")); class=\(drug.drugClass); uses=\(drug.indications.joined(separator: " | ")); mechanism=\(drug.mechanism); dose=\(drug.doseRegimens.map { "\($0.indication):\($0.formula.rawValue)" }.joined(separator: " | ")); PK=\(drug.halfLifeText),\(drug.prodrugInfo.explanation),\(drug.eliminationInfo.summary); warnings=\(drug.warnings.joined(separator: " | ")); interactions=\(drug.interactions.joined(separator: " | ")); counseling=\(drug.counselingSentence)"
        let prompt = """
        Return JSON only. Create exactly 8 concise pharmacy learning questions using only the supplied card. Cover identity, class/mechanism, use, standard dose concepts when present, PK, safety/interactions, and counseling. Scientific name and Trade name require typed spelling and no choices. Every other item must be True/False or four-option MCQ with one exact answer and plausible distractors. Do not invent missing facts.
        {"questions":[{"sourceDrugID":"\(drug.id.uuidString)","prompt":"","answer":"","choices":[""],"explanation":"","questionType":"Use"}]}
        Card: \(snapshot)
        """
        var questions: [GeneratedReviewQuestion] = []
        if allowsAIRequests {
            do {
                let data = try await DeepSeekJSONClient.complete(prompt: prompt, maxTokens: 1_800)
                let payload = try JSONDecoder().decode(AIPracticePayload.self, from: data)
                questions = payload.questions.compactMap { item -> GeneratedReviewQuestion? in
                    guard !item.prompt.trimmed.isEmpty, !item.answer.trimmed.isEmpty else { return nil }
                    let type = QuestionType(rawValue: item.questionType) ?? .use
                    var choices = unique(item.choices ?? [])
                    let interaction: PracticeInteraction
                    if type == .scientificName || type == .tradeName { choices = []; interaction = .textEntry }
                    else if Set(choices.map { $0.lowercased() }) == Set(["true", "false"]) { interaction = .trueFalse }
                    else if choices.count >= 2, choices.contains(where: { $0.localizedCaseInsensitiveCompare(item.answer) == .orderedSame }) {
                        choices = Array(choices.prefix(4))
                        interaction = .multipleChoice
                    } else {
                        choices = ["True", "False"]
                        interaction = .trueFalse
                    }
                    let answer = interaction == .trueFalse && !choices.contains(where: { $0.localizedCaseInsensitiveCompare(item.answer) == .orderedSame }) ? "True" : item.answer.trimmed
                    let prompt = answer == "True" && !item.prompt.lowercased().contains("true or false") ? "True or false: \(item.answer.trimmed)" : item.prompt.trimmed
                    return GeneratedReviewQuestion(prompt: prompt, choices: choices, correctAnswer: answer, explanation: item.explanation?.trimmed ?? item.answer.trimmed, questionType: type, interaction: interaction, relatedField: type.rawValue, difficulty: "medium")
                }
            } catch {
                allowsAIRequests = false
            }
        }
        let fallback = fallbackQuestionSet(for: drug)
        for item in fallback where questions.count < 8 && !questions.contains(where: { $0.prompt.localizedCaseInsensitiveCompare(item.prompt) == .orderedSame }) {
            questions.append(item)
        }
        while questions.count < 8, let item = fallback.first ?? questions.first {
            var copy = item
            copy.id = UUID()
            copy.prompt = "Review: " + copy.prompt
            questions.append(copy)
        }
        guard !questions.isEmpty else { throw DrugImportError.invalidAIJSON }
        return Array(questions.prefix(8))
    }

    private func appendUnique(_ incoming: [PracticeQuestion], to questions: inout [PracticeQuestion], limit: Int) {
        for item in incoming where questions.count < limit && !questions.contains(where: { $0.prompt.localizedCaseInsensitiveCompare(item.prompt) == .orderedSame }) {
            questions.append(item)
        }
    }

    private func fallbackQuestionSet(for drug: Drug) -> [GeneratedReviewQuestion] {
        let modes: [PracticeMode] = [.tradeToScientific, .scientificToTrade, .classExamples, .drugUse, .drugWarning, .counseling, .smartSession, .dueReview]
        return modes.compactMap { mode in
            guard let item = PracticeGenerator.generate(mode: mode, drugs: [drug]).first else { return nil }
            return GeneratedReviewQuestion(
                prompt: item.prompt,
                choices: item.choices,
                correctAnswer: item.correctAnswer,
                explanation: item.explanation ?? item.correctAnswer,
                questionType: item.questionType,
                interaction: item.interaction,
                relatedField: item.questionType.rawValue,
                difficulty: "medium"
            )
        }
    }

    private func unique(_ values: [String]) -> [String] {
        values.map(\.trimmed).filter { !$0.isEmpty }.reduce(into: []) { result, value in
            if !result.contains(where: { $0.localizedCaseInsensitiveCompare(value) == .orderedSame }) { result.append(value) }
        }
    }
}

private struct AIPracticePayload: Decodable {
    var questions: [AIPracticeQuestion]
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        questions = (try? container.decodeIfPresent([AIPracticeQuestion].self, forKey: .questions)) ?? []
    }
    private enum CodingKeys: String, CodingKey { case questions }
}

private struct AIPracticeQuestion: Decodable {
    var sourceDrugID: String
    var prompt: String
    var answer: String
    var choices: [String]?
    var explanation: String?
    var questionType: String

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sourceDrugID = (try? container.decodeIfPresent(String.self, forKey: .sourceDrugID)) ?? ""
        prompt = (try? container.decodeIfPresent(String.self, forKey: .prompt)) ?? ""
        answer = (try? container.decodeIfPresent(String.self, forKey: .answer)) ?? ""
        choices = try? container.decodeIfPresent([String].self, forKey: .choices)
        explanation = try? container.decodeIfPresent(String.self, forKey: .explanation)
        questionType = (try? container.decodeIfPresent(String.self, forKey: .questionType)) ?? QuestionType.use.rawValue
    }

    private enum CodingKeys: String, CodingKey { case sourceDrugID, prompt, answer, choices, explanation, questionType }
}

private enum DeepSeekJSONClient {
    static func complete(prompt: String, maxTokens: Int) async throws -> Data {
        guard let key = DeepSeekKeyStore.shared.apiKey(), !key.trimmed.isEmpty else { throw DrugImportError.missingDeepSeekKey }
        var request = URLRequest(url: URL(string: "https://api.deepseek.com/chat/completions")!)
        request.httpMethod = "POST"
        request.timeoutInterval = 20
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(key)", forHTTPHeaderField: "Authorization")
        request.httpBody = try JSONSerialization.data(withJSONObject: ["model": "deepseek-v4-flash", "messages": [["role": "system", "content": "Return valid JSON only."], ["role": "user", "content": prompt]], "thinking": ["type": "disabled"], "response_format": ["type": "json_object"], "temperature": 0, "max_tokens": maxTokens, "stream": false])
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else { throw DrugImportError.invalidResponse }
        let responseBody = try JSONDecoder().decode(DeepSeekContentResponse.self, from: data)
        guard let content = responseBody.choices.first?.message.content, !content.trimmed.isEmpty else { throw DrugImportError.aiReturnedEmpty }
        do { return try DeepSeekJSONSanitizer.objectData(from: content) }
        catch DrugImportError.invalidAIJSON where responseBody.choices.first?.finishReason == "length" { throw DrugImportError.aiResponseTruncated }
    }
}

private struct DeepSeekContentResponse: Decodable {
    struct Choice: Decodable {
        struct Message: Decodable { var content: String? }
        var message: Message
        var finishReason: String?
        enum CodingKeys: String, CodingKey { case message; case finishReason = "finish_reason" }
    }
    var choices: [Choice]
}
