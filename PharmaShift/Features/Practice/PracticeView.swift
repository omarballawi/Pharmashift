import SwiftData
import SwiftUI
import UIKit

struct PracticeView: View {
    @Environment(ReviewScheduler.self) private var scheduler
    @Environment(AppNavigation.self) private var navigation
    @Query(sort: \Drug.nextReviewDate) private var drugs: [Drug]
    @Query private var profiles: [LearningProfile]
    @State private var selectedMode: PracticeMode?
    @State private var selectedChapter: Chapter?
    @State private var choosesSystem = false

    private var available: [Drug] { drugs.filter { !$0.isUnknown } }
    private var due: [Drug] { available.filter { scheduler.isDue($0) } }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                practiceSummary
                if available.isEmpty {
                    EmptyStateView(icon: "brain.head.profile", title: "Nothing to practice yet", message: "Capture a known drug or import the optional starter pack.")
                } else {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(PracticeMode.allCases.filter { $0 != .dueReview }) { mode in
                            Button { select(mode) } label: {
                                VStack(alignment: .leading, spacing: 10) {
                                    Image(systemName: mode.icon).font(.title2)
                                    Text(mode.rawValue).font(.headline).multilineTextAlignment(.leading)
                                    Text(mode.detail).font(.caption).foregroundStyle(.secondary).multilineTextAlignment(.leading)
                                }
                                .frame(maxWidth: .infinity, minHeight: 126, alignment: .leading)
                                .padding(14).background(.background, in: RoundedRectangle(cornerRadius: 18))
                            }
                            .buttonStyle(.plain)
                            .accessibilityIdentifier("practice.mode.\(mode.rawValue)")
                        }
                    }
                }
                if let profile = profiles.first, !profile.badges.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Badges", systemImage: "medal.fill").font(.headline)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack { ForEach(profile.badges, id: \.self) { Text($0).font(.caption.weight(.semibold)).padding(8).background(.orange.opacity(0.13), in: Capsule()) } }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Practice")
        .sheet(item: $selectedMode, onDismiss: { selectedChapter = nil }) { mode in
            NavigationStack { PracticeSessionView(mode: mode, chapter: selectedChapter) }
        }
        .confirmationDialog("Choose a system", isPresented: $choosesSystem, titleVisibility: .visible) {
            ForEach(Chapter.allCases) { chapter in
                Button(chapter.rawValue) { selectedChapter = chapter; selectedMode = .systemSpecific }
            }
            Button("Cancel", role: .cancel) {}
        }
        .onAppear { openRequestedReview() }
        .onChange(of: navigation.reviewChapter) { _, _ in openRequestedReview() }
        .onChange(of: navigation.requestedPracticeMode) { _, _ in openRequestedReview() }
    }

    private var practiceSummary: some View {
        HStack(spacing: 12) {
            summaryItem("Due", value: due.count, icon: "calendar.badge.clock")
            Divider().frame(height: 38)
            summaryItem("Streak", value: profiles.first?.currentStreak ?? 0, icon: "flame.fill")
            Divider().frame(height: 38)
            summaryItem("Sessions", value: profiles.first?.completedSessions ?? 0, icon: "checkmark.circle")
        }
        .padding(14).background(.background, in: RoundedRectangle(cornerRadius: 18))
    }

    private func summaryItem(_ title: String, value: Int, icon: String) -> some View {
        VStack(spacing: 4) {
            Label("\(value)", systemImage: icon).font(.headline.monospacedDigit()).labelStyle(.titleAndIcon)
            Text(title).font(.caption).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    private func select(_ mode: PracticeMode) {
        if mode == .systemSpecific { choosesSystem = true } else { selectedMode = mode }
    }

    private func openRequestedReview() {
        if let chapter = navigation.reviewChapter {
            selectedChapter = chapter
            navigation.reviewChapter = nil
        }
        guard let mode = navigation.requestedPracticeMode else { return }
        navigation.requestedPracticeMode = nil
        selectedMode = mode
    }
}

struct PracticeSessionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(ReviewScheduler.self) private var scheduler
    @Query(sort: \Drug.nextReviewDate) private var allDrugs: [Drug]
    let initialDrug: Drug?
    let mode: PracticeMode
    let chapter: Chapter?
    @State private var questions: [PracticeQuestion] = []
    @State private var index = 0
    @State private var selectedChoice: String?
    @State private var answerRevealed = false
    @State private var hasAnswered = false
    @State private var answers: [PracticeAnswer] = []
    @State private var result: PracticeSessionResult?

    init(initialDrug: Drug? = nil, mode: PracticeMode = .tradeToScientific, chapter: Chapter? = nil) {
        self.initialDrug = initialDrug; self.mode = mode; self.chapter = chapter
    }

    private var question: PracticeQuestion? { questions.indices.contains(index) ? questions[index] : nil }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                if let result { completion(result) }
                else if let question {
                    progress
                    if let data = question.imageData { DrugPhotoView(data: data, height: 210) }
                    Text(question.prompt).font(.title2.bold()).frame(maxWidth: .infinity, alignment: .leading)
                    if question.interaction == .multipleChoice { multipleChoice(question) }
                    else { recall(question) }
                } else {
                    EmptyStateView(icon: "tray", title: "No eligible questions", message: mode == .imageQuiz ? "Add package photos before starting Image Quiz." : "Add more complete Drug Cards for this mode.")
                }
            }
            .padding()
        }
        .navigationTitle(mode.rawValue)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Close") { dismiss() } } }
        .onAppear { prepare() }
        .accessibilityIdentifier("practice.session")
    }

    private var progress: some View {
        VStack(alignment: .leading, spacing: 7) {
            HStack { Text("Question \(index + 1) of 5").font(.caption.weight(.semibold)); Spacer(); Text("\(Int(Double(index) / 5 * 100))%") .font(.caption.monospacedDigit()) }
            ProgressView(value: Double(index), total: 5).tint(.accentColor)
        }
        .accessibilityIdentifier("practice.progress")
    }

    private func multipleChoice(_ question: PracticeQuestion) -> some View {
        VStack(spacing: 10) {
            ForEach(question.choices, id: \.self) { choice in
                Button { submitChoice(choice, question: question) } label: {
                    HStack {
                        Text(choice).multilineTextAlignment(.leading)
                        Spacer()
                        if hasAnswered, choice == question.correctAnswer { Image(systemName: "checkmark.circle.fill").foregroundStyle(.green) }
                        else if hasAnswered, choice == selectedChoice { Image(systemName: "xmark.circle.fill").foregroundStyle(.red) }
                    }
                    .frame(maxWidth: .infinity, minHeight: 48, alignment: .leading)
                }
                .buttonStyle(.bordered).disabled(hasAnswered)
            }
            if hasAnswered {
                feedback(question)
                nextButton
            }
        }
    }

    private func recall(_ question: PracticeQuestion) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            if answerRevealed {
                feedback(question)
                Text("How did you do?").font(.headline)
                ForEach(ReviewRating.allCases) { rating in
                    Button { submitRecall(rating, question: question) } label: { Text(rating.rawValue).frame(maxWidth: .infinity, minHeight: 46) }
                        .buttonStyle(.bordered)
                        .tint(rating == .correct ? .green : (rating == .wrong ? .red : .orange))
                        .disabled(hasAnswered)
                }
                if hasAnswered { nextButton }
            } else {
                Button("Reveal answer") { withAnimation(reduceMotion ? nil : .easeInOut) { answerRevealed = true } }
                    .buttonStyle(.borderedProminent).frame(maxWidth: .infinity, minHeight: 48)
                    .accessibilityIdentifier("practice.reveal")
            }
        }
    }

    private func feedback(_ question: PracticeQuestion) -> some View {
        let isCorrect = hasAnswered && answers.last?.isCorrect == true
        return VStack(alignment: .leading, spacing: 5) {
            Text(isCorrect ? "Correct" : "Expected answer")
                .font(.caption.weight(.semibold)).foregroundStyle(isCorrect ? .green : .secondary)
            Text(question.correctAnswer)
            if let explanation = question.explanation, explanation != question.correctAnswer { Text(explanation).font(.caption).foregroundStyle(.secondary) }
        }
        .padding(14).frame(maxWidth: .infinity, alignment: .leading)
        .background((isCorrect ? Color.green : Color.orange).opacity(0.09), in: RoundedRectangle(cornerRadius: 14))
    }

    private var nextButton: some View {
        Button(index == 4 ? "Complete session" : "Next question") { advance() }
            .buttonStyle(.borderedProminent).frame(maxWidth: .infinity, minHeight: 48)
            .accessibilityIdentifier("practice.next")
    }

    private func completion(_ result: PracticeSessionResult) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Image(systemName: "checkmark.seal.fill").font(.system(size: 52)).foregroundStyle(.green)
            Text("Session complete").font(.largeTitle.bold())
            Text("\(result.correctCount) of \(result.questionCount) correct").font(.title3)
            if !wrongAnswers.isEmpty {
                Text("Review wrong answers").font(.headline)
                ForEach(Array(wrongAnswers.enumerated()), id: \.offset) { _, item in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.question.prompt).font(.subheadline.weight(.semibold))
                        Text("Your answer: \(item.answer.response)").font(.caption).foregroundStyle(.red)
                        Text("Correct: \(item.question.correctAnswer)").font(.caption).foregroundStyle(.secondary)
                    }
                    .padding(12).background(.red.opacity(0.06), in: RoundedRectangle(cornerRadius: 12))
                }
            }
            Button("Restart five questions") { restart() }.buttonStyle(.bordered).frame(maxWidth: .infinity, minHeight: 46)
            Button("Done") { dismiss() }.buttonStyle(.borderedProminent).frame(maxWidth: .infinity, minHeight: 48)
        }
        .accessibilityIdentifier("practice.complete")
    }

    private var wrongAnswers: [(answer: PracticeAnswer, question: PracticeQuestion)] {
        answers.filter { !$0.isCorrect }.compactMap { answer in questions.first(where: { $0.id == answer.questionID }).map { (answer, $0) } }
    }

    private func submitChoice(_ choice: String, question: PracticeQuestion) {
        guard !hasAnswered else { return }
        selectedChoice = choice
        let rating: ReviewRating = choice == question.correctAnswer ? .correct : .wrong
        record(rating: rating, response: choice, question: question)
    }

    private func submitRecall(_ rating: ReviewRating, question: PracticeQuestion) {
        guard !hasAnswered else { return }
        record(rating: rating, response: rating.rawValue, question: question)
    }

    private func record(rating: ReviewRating, response: String, question: PracticeQuestion) {
        hasAnswered = true
        answers.append(PracticeAnswer(questionID: question.id, response: response, rating: rating))
        if let id = question.drugID, let drug = allDrugs.first(where: { $0.id == id }) {
            context.insert(scheduler.apply(rating: rating, questionType: question.questionType, to: drug, caseID: question.caseID))
        } else {
            context.insert(ReviewLog(drug: nil, drugNameSnapshot: question.drugName, questionType: question.questionType, rating: rating, scoreBefore: 0, scoreAfter: 0, caseID: question.caseID))
        }
        try? context.save()
        if rating == .correct { UINotificationFeedbackGenerator().notificationOccurred(.success) }
        else { UINotificationFeedbackGenerator().notificationOccurred(.warning) }
    }

    private func advance() {
        guard hasAnswered else { return }
        if index + 1 >= PracticeGenerator.questionCount {
            let value = PracticeSessionResult(modeRaw: mode.rawValue, answers: answers)
            result = value
            try? LearningProgressService.record(result: value, context: context)
            if !reduceMotion { UINotificationFeedbackGenerator().notificationOccurred(.success) }
        } else {
            index += 1; selectedChoice = nil; answerRevealed = false; hasAnswered = false
        }
    }

    private func prepare() {
        guard questions.isEmpty else { return }
        questions = PracticeGenerator.generate(mode: mode, drugs: initialDrug.map { [$0] } ?? allDrugs, chapter: chapter)
    }

    private func restart() {
        index = 0; selectedChoice = nil; answerRevealed = false; hasAnswered = false; answers = []; result = nil
        questions = PracticeGenerator.generate(mode: mode, drugs: initialDrug.map { [$0] } ?? allDrugs, chapter: chapter)
    }
}
