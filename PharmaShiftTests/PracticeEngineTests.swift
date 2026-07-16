import SwiftData
import XCTest
@testable import PharmaShift

@MainActor
final class PracticeEngineTests: XCTestCase {
    func testEveryModeProducesExactlyFiveQuestions() {
        let drugs = sampleDrugs()
        for mode in PracticeMode.allCases {
            let questions = PracticeGenerator.generate(mode: mode, drugs: drugs, chapter: mode == .systemSpecific ? .cardiovascular : nil)
            XCTAssertEqual(questions.count, 5, "Mode \(mode.rawValue)")
        }
    }

    func testNamePracticeUsesTextEntryWithoutBelievableDistractors() {
        let drug = sampleDrugs()[0]
        let questions = PracticeGenerator.generate(mode: .tradeToScientific, drugs: [drug])
        XCTAssertEqual(questions.count, 5)
        XCTAssertTrue(questions.allSatisfy { $0.interaction == .textEntry && $0.choices.isEmpty })
    }

    func testSmartFiveRampsDifficultyAndNeverCreatesTautologicalTrueFalse() {
        let questions = PracticeGenerator.generate(mode: .smartSession, drugs: sampleDrugs())
        XCTAssertEqual(questions.map(\.difficulty), [.foundation, .foundation, .application, .application, .challenge])
        XCTAssertFalse(questions.contains { $0.interaction == .trueFalse })
        XCTAssertTrue(questions.allSatisfy { !$0.prompt.lowercased().hasPrefix("true or false") })
    }

    func testClassAndWarningQuestionsUseActiveRecallInsteadOfAmbiguousDistractors() {
        let drugs = sampleDrugs()
        XCTAssertTrue(PracticeGenerator.generate(mode: .classExamples, drugs: drugs).allSatisfy { $0.interaction == .recall && $0.choices.isEmpty })
        XCTAssertTrue(PracticeGenerator.generate(mode: .drugWarning, drugs: drugs).allSatisfy { $0.interaction == .recall && $0.choices.isEmpty })
    }

    func testEveryMultipleChoiceQuestionIsShortUniqueAndHasOneCorrectAnswer() {
        let questions = PracticeMode.allCases.flatMap { mode in
            PracticeGenerator.generate(mode: mode, drugs: sampleDrugs(), chapter: mode == .systemSpecific ? .cardiovascular : nil)
        }
        for question in questions where question.interaction == .multipleChoice {
            XCTAssertTrue(QuestionQualityValidator.isValid(question), question.prompt)
            XCTAssertTrue(question.choices.allSatisfy { $0.count <= QuestionQualityValidator.maximumChoiceLength })
            XCTAssertEqual(question.choices.filter { $0.localizedCaseInsensitiveCompare(question.correctAnswer) == .orderedSame }.count, 1)
        }
    }

    func testValidatorRejectsDuplicateAndOverlongOptions() {
        let duplicate = PracticeQuestion(
            drugID: nil,
            drugName: "Test",
            prompt: "Which saved use belongs to Test?",
            correctAnswer: "Hypertension",
            choices: ["Hypertension", "hypertension", "Angina"],
            questionType: .use,
            interaction: .multipleChoice
        )
        XCTAssertFalse(QuestionQualityValidator.isValid(duplicate))

        var long = duplicate
        long.choices = ["Hypertension", String(repeating: "a", count: 65), "Angina"]
        XCTAssertFalse(QuestionQualityValidator.isValid(long))
    }

    func testPracticeQuestionDecodesOlderSavedPackWithoutNewMetadata() throws {
        let json = """
        {"id":"00000000-0000-0000-0000-000000000001","drugID":null,"drugName":"Test","prompt":"Recall the use","correctAnswer":"Answer","choices":[],"explanation":null,"questionType":"Use","interaction":"recall","imageData":null,"caseID":null}
        """.data(using: .utf8)!
        let decoded = try JSONDecoder().decode(PracticeQuestion.self, from: json)
        XCTAssertNil(decoded.difficulty)
        XCTAssertNil(decoded.learningObjective)
        XCTAssertNil(decoded.sourceField)
        XCTAssertNil(decoded.acceptedAnswers)
    }

    func testMemoryAnchorsAlwaysReturnThreeHonestSlots() {
        let drug = Drug(scientificName: "Test", indications: ["Use"], warnings: ["Warning"])
        let anchors = drug.memoryAnchors
        XCTAssertEqual(anchors.count, 3)
        XCTAssertEqual(anchors.compactMap(\.content), ["Use", "Warning"])
        XCTAssertNil(anchors.last?.content)
    }

    func testSystemPracticeUsesOnlyRequestedChapter() {
        let drugs = sampleDrugs()
        let allowed = Set(drugs.filter { $0.chapter == .cardiovascular }.map(\.id))
        let questions = PracticeGenerator.generate(mode: .systemSpecific, drugs: drugs, chapter: .cardiovascular)
        XCTAssertEqual(questions.count, 5)
        XCTAssertTrue(questions.allSatisfy { $0.drugID.map(allowed.contains) == true })
    }

    func testLearningStreakHandlesSameDayConsecutiveDayAndGap() throws {
        let container = try makeContainer()
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 3_600 * 3)!
        let day = Date(timeIntervalSince1970: 1_750_000_000)
        let result = PracticeSessionResult(modeRaw: PracticeMode.drugUse.rawValue, answers: fiveAnswers(correct: 4))
        var profile = try LearningProgressService.record(result: result, context: container.mainContext, now: day, calendar: calendar)
        XCTAssertEqual(profile.currentStreak, 1)
        profile = try LearningProgressService.record(result: result, context: container.mainContext, now: day.addingTimeInterval(3_600), calendar: calendar)
        XCTAssertEqual(profile.currentStreak, 1)
        let next = calendar.date(byAdding: .day, value: 1, to: day)!
        profile = try LearningProgressService.record(result: result, context: container.mainContext, now: next, calendar: calendar)
        XCTAssertEqual(profile.currentStreak, 2)
        let gap = calendar.date(byAdding: .day, value: 3, to: next)!
        profile = try LearningProgressService.record(result: result, context: container.mainContext, now: gap, calendar: calendar)
        XCTAssertEqual(profile.currentStreak, 1)
        XCTAssertEqual(profile.longestStreak, 2)
        XCTAssertTrue(profile.badges.contains("First Five"))
        XCTAssertEqual(try container.mainContext.fetchCount(FetchDescriptor<DailyActivity>()), 3)
    }

    func testFocusModeReturnsOnePriorityAction() {
        XCTAssertEqual(FocusModeEngine.recommendation(drugs: [], activeShift: nil).action, .addDrug)
        let due = Drug(scientificName: "Due", nextReviewDate: .distantPast)
        XCTAssertEqual(FocusModeEngine.recommendation(drugs: [due], activeShift: ShiftLog()).action, .reviewDue)
        due.nextReviewDate = .distantFuture
        due.masteryScientificName = true; due.masteryTradeName = true; due.masteryClass = true
        due.masteryUse = true; due.masteryWarning = true; due.masteryCounseling = true; due.recalculateConfidence()
        let weakDrug = Drug(scientificName: "Weak", nextReviewDate: .distantFuture)
        XCTAssertEqual(FocusModeEngine.recommendation(drugs: [due, weakDrug], activeShift: ShiftLog()).action, .practiceWeak)
        weakDrug.masteryScientificName = true; weakDrug.masteryTradeName = true; weakDrug.masteryClass = true
        weakDrug.masteryUse = true; weakDrug.masteryWarning = true; weakDrug.masteryCounseling = true; weakDrug.recalculateConfidence()
        XCTAssertEqual(FocusModeEngine.recommendation(drugs: [due, weakDrug], activeShift: ShiftLog()).action, .finishShift)
    }

    private func sampleDrugs() -> [Drug] {
        (0..<4).map { index in
            let drug = Drug(scientificName: "Scientific \(index)", tradeNames: ["Trade \(index)"], chapter: index < 2 ? .cardiovascular : .respiratory,
                            drugClass: "Class \(index)", indications: ["Use \(index)"], warnings: ["Warning \(index)"],
                            counselingSentence: "Counseling \(index)", imageData: Data([UInt8(index + 1)]), nextReviewDate: .distantPast)
            return drug
        }
    }

    private func fiveAnswers(correct: Int) -> [PracticeAnswer] {
        (0..<5).map { PracticeAnswer(questionID: UUID(), response: "Answer", rating: $0 < correct ? .correct : .wrong) }
    }

    private func makeContainer() throws -> ModelContainer {
        try ModelContainer(for: Drug.self, DrugProduct.self, DrugRelationship.self, ReviewLog.self, ShiftLog.self, EncounterNote.self, TrainingReport.self, LearningProfile.self, DailyActivity.self,
                           configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    }
}
