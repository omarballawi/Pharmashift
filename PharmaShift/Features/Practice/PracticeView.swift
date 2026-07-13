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
    @State private var aiPack: AIPracticePack? = AIPracticePackStore.load()
    @State private var isRefreshingAIPack = false
    @State private var aiPackMessage: String?
    @State private var showsAllModes = false

    private var available: [Drug] { drugs.filter { !$0.isUnknown } }
    private var due: [Drug] { available.filter { scheduler.isDue($0) } }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                practiceSummary
                if available.isEmpty {
                    EmptyStateView(icon: "brain.head.profile", title: "Nothing to practice yet", message: "Capture a known drug or import the optional starter pack.")
                } else {
                    smartSessionCard
                    quickPractice
                    learningTools
                    DisclosureGroup("Choose a mode", isExpanded: $showsAllModes) { allModesGrid.padding(.top, 12) }
                        .font(.headline)
                }
                aiPracticePack
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

    private var smartSessionCard: some View {
        Button { select(.smartSession) } label: {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Label("Recommended for you", systemImage: "sparkles").font(.caption.bold()).foregroundStyle(.cyan)
                    Spacer()
                    Text("6 min").font(.caption.monospacedDigit()).foregroundStyle(.white.opacity(0.7))
                }
                Text("Start Smart Session").font(.title2.bold()).foregroundStyle(.white)
                Text("A calm mix of due reviews, weak facts, images, safety, and counseling.")
                    .font(.subheadline).foregroundStyle(.white.opacity(0.78)).multilineTextAlignment(.leading)
                HStack(spacing: 16) {
                    Label("\(due.count) due", systemImage: "clock.fill")
                    Label("\(available.filter(\.isConfusing).count) weak", systemImage: "bolt.fill")
                    Spacer()
                    Image(systemName: "arrow.right.circle.fill").font(.title2)
                }
                .font(.caption.bold()).foregroundStyle(.white)
            }
            .padding(18).frame(maxWidth: .infinity, alignment: .leading)
            .background(
                LinearGradient(colors: [Color(red: 0.04, green: 0.31, blue: 0.35), Color(red: 0.25, green: 0.14, blue: 0.47)], startPoint: .topLeading, endPoint: .bottomTrailing),
                in: RoundedRectangle(cornerRadius: 24, style: .continuous)
            )
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("practice.smartSession")
    }

    private var quickPractice: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Quick practice").font(.headline)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 9) {
                    ForEach([PracticeMode.imageQuiz, .tradeToScientific, .counseling, .casePractice], id: \.self) { mode in
                        Button { select(mode) } label: {
                            Label(mode.rawValue, systemImage: mode.icon)
                                .font(.subheadline.weight(.semibold)).padding(.horizontal, 13).frame(minHeight: 44)
                                .background(.background, in: Capsule())
                        }
                        .buttonStyle(.plain)
                        .accessibilityIdentifier("practice.mode.\(mode.rawValue)")
                    }
                }
            }
        }
    }

    private var allModesGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
            ForEach(PracticeMode.allCases.filter { ![.dueReview, .smartSession, .imageQuiz, .tradeToScientific, .counseling, .casePractice].contains($0) }) { mode in
                Button { select(mode) } label: {
                    VStack(alignment: .leading, spacing: 8) {
                        Image(systemName: mode.icon).font(.title3).foregroundStyle(.tint)
                        Text(mode.rawValue).font(.subheadline.bold()).multilineTextAlignment(.leading)
                        Text(mode.detail).font(.caption2).foregroundStyle(.secondary).lineLimit(3).multilineTextAlignment(.leading)
                    }
                    .frame(maxWidth: .infinity, minHeight: 112, alignment: .leading)
                    .padding(12).background(.background, in: RoundedRectangle(cornerRadius: 16))
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier("practice.mode.\(mode.rawValue)")
            }
        }
    }

    private var learningTools: some View {
        HStack(spacing: 10) {
            NavigationLink { DailyRefreshView() } label: {
                learningTool("Daily Refresh", "clock.arrow.circlepath", "Old notes + due facts", .teal)
            }
            NavigationLink { MistakeVaultView() } label: {
                learningTool("Mistake Vault", "archivebox.fill", "Replay weak answers", .orange)
            }
        }
        .buttonStyle(.plain)
    }

    private func learningTool(_ title: String, _ icon: String, _ subtitle: String, _ color: Color) -> some View {
        VStack(alignment: .leading, spacing: 7) {
            Image(systemName: icon).foregroundStyle(color)
            Text(title).font(.subheadline.bold())
            Text(subtitle).font(.caption2).foregroundStyle(.secondary).lineLimit(2)
        }
        .frame(maxWidth: .infinity, minHeight: 96, alignment: .leading).padding(12)
        .background(.background, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var aiPracticePack: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                Label("AI Practice Pack", systemImage: "sparkles")
                    .font(.headline)
                Spacer()
                if let aiPack { Text(aiPack.generatedAt, style: .relative).font(.caption).foregroundStyle(.secondary) }
            }
            Text(aiPack == nil ? "Create one short, focused five-question pack from your weak and due drug cards." : "Your saved pack stays ready offline until you refresh it.")
                .font(.subheadline).foregroundStyle(.secondary)
            if let aiPack {
                NavigationLink {
                    PracticeSessionView(questions: aiPack.questions, title: "AI Practice Pack")
                } label: {
                    Label("Start saved pack", systemImage: "play.fill").frame(maxWidth: .infinity, minHeight: 44)
                }
                .buttonStyle(.borderedProminent)
            }
            Button {
                refreshAIPack()
            } label: {
                Label(isRefreshingAIPack ? "Creating questions" : "Refresh five questions", systemImage: "arrow.clockwise")
                    .frame(maxWidth: .infinity, minHeight: 44)
            }
            .buttonStyle(.bordered)
            .disabled(isRefreshingAIPack || available.isEmpty)
            if let aiPackMessage { Text(aiPackMessage).font(.caption).foregroundStyle(.secondary) }
        }
        .padding(14)
        .background(.background, in: RoundedRectangle(cornerRadius: 18))
        .accessibilityIdentifier("practice.aiPack")
    }

    private func refreshAIPack() {
        isRefreshingAIPack = true
        aiPackMessage = nil
        Task {
            do {
                let pack = try await DeepSeekPracticeService().makePack(from: available)
                AIPracticePackStore.save(pack)
                await MainActor.run { aiPack = pack; aiPackMessage = "Five questions saved for offline practice."; isRefreshingAIPack = false }
            } catch {
                await MainActor.run { aiPackMessage = error.localizedDescription; isRefreshingAIPack = false }
            }
        }
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

private struct DailyRefreshView: View {
    @Environment(ReviewScheduler.self) private var scheduler
    @Query(sort: \Drug.lastReviewed) private var drugs: [Drug]
    @Query(sort: \EncounterNote.date, order: .reverse) private var notes: [EncounterNote]

    private var refreshDrugs: [Drug] {
        Array(drugs.filter { scheduler.isDue($0) || $0.isConfusing }.prefix(5))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text("Your Daily Refresh").font(.largeTitle.bold())
                Text("A small feed of knowledge that deserves another look.").foregroundStyle(.secondary)
                ForEach(refreshDrugs) { drug in
                    NavigationLink { DrugDetailView(drug: drug) } label: {
                        HStack(spacing: 12) {
                            DrugThumbnailView(drug: drug, size: 60)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(drug.displayName).font(.headline)
                                Text(drug.mustKnow.first ?? drug.warnings.first ?? "Review this card today")
                                    .font(.caption).foregroundStyle(.secondary).lineLimit(2)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .padding(13).background(.background, in: RoundedRectangle(cornerRadius: 18))
                    }
                    .buttonStyle(.plain)
                }
                if let note = notes.first(where: { !$0.combinedText.trimmed.isEmpty }) {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Resurfaced note", systemImage: "note.text").font(.headline).foregroundStyle(.tint)
                        Text(note.whatILearned.trimmed.isEmpty ? note.combinedText : note.whatILearned).lineLimit(5)
                        Text(note.date, style: .relative).font(.caption).foregroundStyle(.secondary)
                    }
                    .padding(15).background(.tint.opacity(0.08), in: RoundedRectangle(cornerRadius: 18))
                }
                if let drug = drugs.first(where: { !$0.atomicNotes.isEmpty }), let note = drug.atomicNotes.first {
                    NavigationLink { DrugDetailView(drug: drug) } label: {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("From your \(note.kind.rawValue.lowercased())", systemImage: "link.circle.fill").font(.headline).foregroundStyle(.tint)
                            Text(note.text).foregroundStyle(.primary)
                            Text("\(drug.displayName) • \(note.linkedField)").font(.caption).foregroundStyle(.secondary)
                        }
                        .padding(15).frame(maxWidth: .infinity, alignment: .leading)
                        .background(.tint.opacity(0.08), in: RoundedRectangle(cornerRadius: 18))
                    }.buttonStyle(.plain)
                }
                if refreshDrugs.isEmpty && notes.isEmpty {
                    EmptyStateView(icon: "checkmark.seal.fill", title: "All refreshed", message: "Complete a few cards and notes; Renlyst will resurface them here later.")
                }
            }
            .padding()
        }
        .navigationTitle("Refresh")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct MistakeVaultView: View {
    @Query(sort: \ReviewLog.date, order: .reverse) private var logs: [ReviewLog]

    private var mistakes: [ReviewLog] { logs.filter { !$0.wasCorrect } }
    private var biggestWeakness: String? {
        Dictionary(grouping: mistakes, by: \.questionTypeRaw).max { $0.value.count < $1.value.count }?.key
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                if let biggestWeakness {
                    VStack(alignment: .leading, spacing: 7) {
                        Label("Biggest weakness", systemImage: "bolt.fill").font(.caption.bold()).foregroundStyle(.orange)
                        Text(biggestWeakness).font(.title2.bold())
                        Text("\(mistakes.filter { $0.questionTypeRaw == biggestWeakness }.count) misses recorded")
                            .font(.caption).foregroundStyle(.secondary)
                    }
                    .padding(16).frame(maxWidth: .infinity, alignment: .leading)
                    .background(.orange.opacity(0.10), in: RoundedRectangle(cornerRadius: 20))
                    NavigationLink { PracticeSessionView(mode: .weakDrug) } label: {
                        Label("Replay weak facts", systemImage: "play.fill").frame(maxWidth: .infinity, minHeight: 48)
                    }
                    .buttonStyle(.borderedProminent)
                }
                ForEach(mistakes.prefix(20)) { log in
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Text(log.drugNameSnapshot).font(.headline)
                            Spacer()
                            Text(log.questionTypeRaw).font(.caption2.bold()).foregroundStyle(.orange)
                        }
                        Text("Needs another pass").font(.subheadline).foregroundStyle(.secondary)
                        Text(log.date, style: .relative).font(.caption2).foregroundStyle(.secondary)
                    }
                    .padding(13).background(.background, in: RoundedRectangle(cornerRadius: 16))
                }
                if mistakes.isEmpty {
                    EmptyStateView(icon: "archivebox.fill", title: "Vault is empty", message: "Missed facts will collect here automatically and return in weak-topic sessions.")
                }
            }
            .padding()
        }
        .navigationTitle("Mistake Vault")
        .navigationBarTitleDisplayMode(.inline)
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
    let providedQuestions: [PracticeQuestion]?
    let customTitle: String?
    @State private var questions: [PracticeQuestion] = []
    @State private var index = 0
    @State private var selectedChoice: String?
    @State private var typedResponse = ""
    @State private var answerRevealed = false
    @State private var hasAnswered = false
    @State private var answers: [PracticeAnswer] = []
    @State private var result: PracticeSessionResult?

    init(initialDrug: Drug? = nil, mode: PracticeMode = .tradeToScientific, chapter: Chapter? = nil, questions: [PracticeQuestion]? = nil, title: String? = nil) {
        self.initialDrug = initialDrug; self.mode = mode; self.chapter = chapter; self.providedQuestions = questions; self.customTitle = title
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
                    switch question.interaction {
                    case .multipleChoice, .trueFalse:
                        multipleChoice(question)
                    case .textEntry:
                        textEntry(question)
                    case .recall:
                        recall(question)
                    }
                } else {
                    EmptyStateView(icon: "tray", title: "No eligible questions", message: mode == .imageQuiz ? "Add package photos before starting Image Quiz." : "Add more complete Drug Cards for this mode.")
                }
            }
            .padding()
        }
        .navigationTitle(customTitle ?? mode.rawValue)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Close") { dismiss() } } }
        .onAppear { prepare() }
        .accessibilityIdentifier("practice.session")
    }

    private var progress: some View {
        VStack(alignment: .leading, spacing: 7) {
            HStack {
                Text("Question \(index + 1) of \(max(questions.count, 1))").font(.caption.weight(.semibold))
                Spacer()
                Text("\(Int(Double(index) / Double(max(questions.count, 1)) * 100))%")
                    .font(.caption.monospacedDigit())
            }
            ProgressView(value: Double(index), total: Double(max(questions.count, 1))).tint(.accentColor)
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

    private func textEntry(_ question: PracticeQuestion) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            TextField("Type the drug name", text: $typedResponse)
                .textInputAutocapitalization(.words)
                .autocorrectionDisabled()
                .submitLabel(.done)
                .padding(13)
                .background(.background, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(.secondary.opacity(0.2))
                }
                .disabled(hasAnswered)
                .accessibilityIdentifier("practice.textEntry")
            if hasAnswered {
                feedback(question)
                nextButton
            } else {
                Button {
                    submitText(question)
                } label: {
                    Label("Check spelling", systemImage: "textformat.abc.dottedunderline")
                        .frame(maxWidth: .infinity, minHeight: 48)
                }
                .buttonStyle(.borderedProminent)
                .disabled(typedResponse.trimmed.isEmpty)
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
        Button(index + 1 >= questions.count ? "Complete session" : "Next question") { advance() }
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
        UINotificationFeedbackGenerator().notificationOccurred(rating == .correct ? .success : .error)
        record(rating: rating, response: choice, question: question)
    }

    private func submitRecall(_ rating: ReviewRating, question: PracticeQuestion) {
        guard !hasAnswered else { return }
        record(rating: rating, response: rating.rawValue, question: question)
    }

    private func submitText(_ question: PracticeQuestion) {
        guard !hasAnswered else { return }
        let response = normalizedName(typedResponse)
        let accepted = [question.correctAnswer]
            .flatMap { $0.components(separatedBy: ",") }
            .map { normalizedName($0) }
        let rating: ReviewRating = accepted.contains(response) ? .correct : .wrong
        UINotificationFeedbackGenerator().notificationOccurred(rating == .correct ? .success : .error)
        record(rating: rating, response: typedResponse.trimmed, question: question)
    }

    private func normalizedName(_ value: String) -> String {
        value.folding(options: [.caseInsensitive, .diacriticInsensitive], locale: .current)
            .replacingOccurrences(of: "-", with: " ")
            .split(whereSeparator: \.isWhitespace)
            .joined(separator: " ")
            .lowercased()
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
        if index + 1 >= questions.count {
            let value = PracticeSessionResult(modeRaw: customTitle ?? mode.rawValue, answers: answers)
            result = value
            try? LearningProgressService.record(result: value, context: context)
            if !reduceMotion { UINotificationFeedbackGenerator().notificationOccurred(.success) }
        } else {
            index += 1; selectedChoice = nil; typedResponse = ""; answerRevealed = false; hasAnswered = false
        }
    }

    private func prepare() {
        guard questions.isEmpty else { return }
        if let initialDrug, !initialDrug.generatedReviewQuestions.isEmpty, providedQuestions == nil {
            questions = PracticeGenerator.generatedReview(for: initialDrug)
        } else {
            questions = providedQuestions ?? PracticeGenerator.generate(mode: mode, drugs: initialDrug.map { [$0] } ?? allDrugs, chapter: chapter)
        }
    }

    private func restart() {
        index = 0; selectedChoice = nil; typedResponse = ""; answerRevealed = false; hasAnswered = false; answers = []; result = nil
        if let initialDrug, !initialDrug.generatedReviewQuestions.isEmpty, providedQuestions == nil {
            questions = PracticeGenerator.generatedReview(for: initialDrug)
        } else {
            questions = providedQuestions ?? PracticeGenerator.generate(mode: mode, drugs: initialDrug.map { [$0] } ?? allDrugs, chapter: chapter)
        }
    }
}
