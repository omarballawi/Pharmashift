import SwiftData
import SwiftUI

enum PracticeMode: String, CaseIterable, Identifiable {
    case nameFlip = "Name Flip"
    case drugClass = "Class Trainer"
    case use = "Use Trainer"
    case warning = "Warning Trainer"
    case counseling = "Counseling Trainer"
    case cases = "Case Practice"

    var id: String { rawValue }
    var icon: String {
        switch self {
        case .nameFlip: "arrow.left.arrow.right"
        case .drugClass: "square.grid.2x2"
        case .use: "cross.vial"
        case .warning: "exclamationmark.triangle"
        case .counseling: "quote.bubble"
        case .cases: "person.text.rectangle"
        }
    }
    var detail: String {
        switch self {
        case .nameFlip: "Trade ↔ scientific names"
        case .drugClass: "Recall drug classes"
        case .use: "Recall main indications"
        case .warning: "Recall important warnings"
        case .counseling: "Write a simple counseling sentence"
        case .cases: "Educational situations only"
        }
    }
}

struct PracticeView: View {
    @Environment(ReviewScheduler.self) private var scheduler
    @Query(sort: \Drug.nextReviewDate) private var drugs: [Drug]
    @Query private var reviews: [ReviewLog]
    @State private var selectedMode: PracticeMode?

    private var available: [Drug] { drugs.filter { !$0.isUnknown } }
    private var due: [Drug] { available.filter { scheduler.isDue($0) } }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                HStack(spacing: 12) {
                    MetricCard(title: "Due now", value: "\(due.count)", icon: "calendar.badge.clock")
                    MetricCard(title: "Reviews", value: "\(reviews.count)", icon: "checkmark.circle")
                }

                if available.isEmpty {
                    EmptyStateView(icon: "brain.head.profile", title: "Nothing to practice yet", message: "Capture a known drug or import the optional starter pack.")
                } else {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(PracticeMode.allCases) { mode in
                            Button { selectedMode = mode } label: {
                                VStack(alignment: .leading, spacing: 10) {
                                    Image(systemName: mode.icon).font(.title2)
                                    Text(mode.rawValue).font(.headline).multilineTextAlignment(.leading)
                                    Text(mode.detail).font(.caption).foregroundStyle(.secondary).multilineTextAlignment(.leading)
                                }
                                .frame(maxWidth: .infinity, minHeight: 118, alignment: .leading)
                                .padding(14)
                                .background(.background, in: RoundedRectangle(cornerRadius: 18))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Practice")
        .sheet(item: $selectedMode) { mode in
            NavigationStack { PracticeSessionView(mode: mode) }
        }
    }
}

struct PracticeSessionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Environment(ReviewScheduler.self) private var scheduler
    @Query(sort: \Drug.nextReviewDate) private var allDrugs: [Drug]
    let initialDrug: Drug?
    let mode: PracticeMode
    @State private var index = 0
    @State private var answerRevealed = false
    @State private var counselingText = ""
    @State private var completed = false
    @State private var sessionDrugs: [Drug] = []

    init(initialDrug: Drug? = nil, mode: PracticeMode = .nameFlip) {
        self.initialDrug = initialDrug
        self.mode = mode
    }

    private var drug: Drug? { sessionDrugs.indices.contains(index) ? sessionDrugs[index] : nil }
    private var practiceCase: PracticeCase { StarterContent.cases[index % StarterContent.cases.count] }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if completed {
                    ContentUnavailableView("Session complete", systemImage: "checkmark.seal.fill", description: Text("Your next review dates are updated."))
                    Button("Done") { dismiss() }.buttonStyle(.borderedProminent).frame(maxWidth: .infinity, minHeight: 48)
                } else if mode == .cases {
                    caseCard
                } else if let drug {
                    UrgentSafetyNotice(flags: drug.safetyFlags)
                    Text("Card \(index + 1) of \(sessionDrugs.count)").font(.caption).foregroundStyle(.secondary)
                    Text(question(for: drug)).font(.title2.bold()).frame(maxWidth: .infinity, alignment: .leading)
                    if mode == .counseling {
                        TextField("Write or speak a simple counseling sentence", text: $counselingText, axis: .vertical)
                            .lineLimit(4...8).textFieldStyle(.roundedBorder)
                    }
                    answerArea(answer: answer(for: drug))
                } else {
                    EmptyStateView(icon: "tray", title: "No eligible drugs", message: "Unknown drugs stay out of practice until you identify them.")
                }
            }
            .padding()
        }
        .navigationTitle(mode.rawValue)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Close") { dismiss() } } }
        .onAppear { prepareSessionIfNeeded() }
    }

    private var caseCard: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Case \(index + 1) of \(StarterContent.cases.count)").font(.caption).foregroundStyle(.secondary)
            Text(practiceCase.prompt).font(.title2.bold())
            UrgentSafetyNotice(flags: [.severeSymptoms])
            answerArea(answer: practiceCase.expectedIdea)
        }
    }

    @ViewBuilder
    private func answerArea(answer: String) -> some View {
        if answerRevealed {
            VStack(alignment: .leading, spacing: 8) {
                Text("Expected idea").font(.caption.weight(.semibold)).foregroundStyle(.secondary)
                Text(answer).font(.body)
                Text("Confirm with the pharmacist.").font(.headline).foregroundStyle(.red)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.green.opacity(0.08), in: RoundedRectangle(cornerRadius: 16))

            Text("How did you do?").font(.headline)
            ForEach(ReviewRating.allCases) { rating in
                if rating == .correct {
                    ratingButton(rating).buttonStyle(.borderedProminent)
                } else {
                    ratingButton(rating).buttonStyle(.bordered).tint(rating == .wrong ? .red : .accentColor)
                }
            }
        } else {
            Button("Reveal expected idea") { answerRevealed = true }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity, minHeight: 48)
                .accessibilityIdentifier("practice.reveal")
        }
    }

    private func ratingButton(_ rating: ReviewRating) -> some View {
        Button { grade(rating) } label: {
            Text(rating.rawValue).frame(maxWidth: .infinity, minHeight: 48)
        }
        .accessibilityIdentifier("practice.rating.\(rating.rawValue)")
    }

    private func question(for drug: Drug) -> String {
        switch resolvedQuestionType {
        case .scientificName: "What is the scientific name for \(drug.firstTradeName)?"
        case .tradeName: "Name a trade name for \(drug.scientificName)."
        case .drugClass: "What class is \(drug.displayName)?"
        case .use: "What is \(drug.displayName) used for?"
        case .warning: "What is the most important warning for \(drug.displayName)?"
        case .counseling: "Write a simple patient counseling sentence for \(drug.displayName)."
        case .casePractice: ""
        }
    }

    private func answer(for drug: Drug) -> String {
        switch resolvedQuestionType {
        case .scientificName: drug.scientificName.isEmpty ? "Complete the scientific name on this card." : drug.scientificName
        case .tradeName: drug.tradeNames.isEmpty ? "No trade name recorded yet." : drug.tradeNames.joined(separator: ", ")
        case .drugClass: drug.drugClass.isEmpty ? "Complete the class on this card." : drug.drugClass
        case .use: drug.indications.isEmpty ? "Complete the indication with the pharmacist." : drug.indications.joined(separator: "; ")
        case .warning: drug.warnings.isEmpty ? "Complete the warning with the pharmacist." : drug.warnings.joined(separator: "; ")
        case .counseling: drug.counselingSentence.isEmpty ? "Draft and verify a counseling sentence with the pharmacist." : drug.counselingSentence
        case .casePractice: ""
        }
    }

    private var resolvedQuestionType: QuestionType {
        switch mode {
        case .nameFlip: index.isMultiple(of: 2) ? .scientificName : .tradeName
        case .drugClass: .drugClass
        case .use: .use
        case .warning: .warning
        case .counseling: .counseling
        case .cases: .casePractice
        }
    }

    private func grade(_ rating: ReviewRating) {
        if mode == .cases {
            let related = allDrugs.first { $0.scientificName.localizedCaseInsensitiveCompare(practiceCase.relatedScientificName) == .orderedSame }
            if let related {
                let log = scheduler.apply(rating: rating, questionType: .casePractice, to: related, caseID: practiceCase.id)
                context.insert(log)
            } else {
                context.insert(ReviewLog(drug: nil, drugNameSnapshot: practiceCase.relatedScientificName, questionType: .casePractice, rating: rating, scoreBefore: 0, scoreAfter: 0, caseID: practiceCase.id))
            }
        } else if let drug {
            context.insert(scheduler.apply(rating: rating, questionType: resolvedQuestionType, to: drug))
        }
        try? context.save()
        answerRevealed = false
        counselingText = ""
        index += 1
        let count = mode == .cases ? StarterContent.cases.count : sessionDrugs.count
        if index >= count { completed = true }
    }

    private func prepareSessionIfNeeded() {
        guard sessionDrugs.isEmpty, mode != .cases else { return }
        if let initialDrug {
            sessionDrugs = [initialDrug]
            return
        }
        let available = allDrugs.filter { !$0.isUnknown }
        let due = available.filter { scheduler.isDue($0) }
        sessionDrugs = Array((due.isEmpty ? available : due).prefix(20))
    }
}
