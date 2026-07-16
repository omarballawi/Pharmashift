import SwiftData
import SwiftUI

struct ShiftView: View {
    @Environment(\.modelContext) private var context
    @Environment(AppTheme.self) private var theme
    @Environment(ReviewScheduler.self) private var scheduler
    @Query(sort: \ShiftLog.startedAt, order: .reverse) private var shifts: [ShiftLog]
    @Query(sort: \Drug.dateAdded, order: .reverse) private var drugs: [Drug]
    @Query(sort: \ReviewLog.date, order: .reverse) private var reviews: [ReviewLog]
    @Query(sort: \EncounterNote.date, order: .reverse) private var encounters: [EncounterNote]
    @State private var focusChapter: Chapter = .other
    @State private var showsStart = false
    @State private var showsEncounter = false
    @State private var endingShift: ShiftLog?

    private var activeShift: ShiftLog? { shifts.first { !$0.isCompleted } }
    private var dueCount: Int { drugs.filter { !$0.isUnknown && scheduler.isDue($0) }.count }
    private var weakCount: Int { drugs.filter { $0.confidenceLevel == .weak || $0.isConfusing }.count }
    private func newDrugCount(since date: Date) -> Int { drugs.filter { $0.dateAdded >= date }.count }
    private func reviewCount(since date: Date) -> Int { reviews.filter { $0.date >= date }.count }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                if let activeShift {
                    ActiveShiftCard(
                        shift: activeShift,
                        newDrugCount: newDrugCount(since: activeShift.startedAt),
                        reviewCount: reviewCount(since: activeShift.startedAt)
                    )
                    HStack(spacing: 12) {
                        MetricCard(title: "Reviews due", value: "\(dueCount)", icon: "calendar.badge.clock")
                        MetricCard(title: "Weak drugs", value: "\(weakCount)", icon: "bolt.heart")
                    }
                    Button { showsEncounter = true } label: {
                        Label("Add supervised encounter note", systemImage: "note.text.badge.plus")
                            .frame(maxWidth: .infinity, minHeight: 48)
                    }
                    .buttonStyle(.bordered)
                    Button(role: .destructive) { endingShift = activeShift } label: {
                        Label("End shift", systemImage: "stop.circle.fill").frame(maxWidth: .infinity, minHeight: 48)
                    }
                    .buttonStyle(.borderedProminent)
                } else {
                    missionCard
                    Button { showsStart = true } label: {
                        Label("Start Shift", systemImage: "play.circle.fill").frame(maxWidth: .infinity, minHeight: 52)
                    }
                    .buttonStyle(.borderedProminent)
                    .accessibilityIdentifier("shift.start")
                }

                if !encounters.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Recent encounter notes").font(.headline)
                        ForEach(encounters.prefix(3)) { note in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(note.topic).font(.subheadline.weight(.semibold))
                                Text(note.whatILearned).font(.caption).foregroundStyle(.secondary).lineLimit(2)
                            }
                            .padding(12).frame(maxWidth: .infinity, alignment: .leading)
                            .background(.background, in: RoundedRectangle(cornerRadius: 14))
                        }
                    }
                }
            }
            .padding()
        }
        .background(theme.background)
        .navigationTitle("Today’s Shift")
        .sheet(isPresented: $showsStart) {
            NavigationStack {
                Form {
                    Section("Today’s focus") {
                        Picker("Chapter", selection: $focusChapter) { ForEach(Chapter.allCases) { Text($0.rawValue).tag($0) } }
                        LabeledContent("New drugs target", value: "10")
                        LabeledContent("Reviews due", value: "\(dueCount)")
                        LabeledContent("Weak drugs", value: "\(weakCount)")
                    }
                }
                .navigationTitle("Start Shift")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) { Button("Cancel") { showsStart = false } }
                    ToolbarItem(placement: .confirmationAction) { Button("Start") { startShift() } }
                }
            }
        }
        .sheet(isPresented: $showsEncounter) { NavigationStack { EncounterEditorView() } }
        .sheet(item: $endingShift) { shift in
            NavigationStack { EndShiftView(shift: shift, drugs: drugs, reviews: reviews) }
        }
    }

    private var missionCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Today’s training mission", systemImage: "scope").font(.title2.bold())
            Text("Capture 10 shelf drugs, understand the important points, review what is due, and finish with a short reflection.")
                .foregroundStyle(.secondary)
            Divider()
            LabeledContent("Focus chapter", value: focusChapter == .other ? "Choose when starting" : focusChapter.rawValue)
            LabeledContent("Reviews due", value: "\(dueCount)")
            LabeledContent("Weak drugs", value: "\(weakCount)")
            LabeledContent("Completed shifts", value: "\(shifts.filter(\.isCompleted).count)")
        }
        .padding(18)
        .background(.background, in: RoundedRectangle(cornerRadius: 20))
    }

    private func startShift() {
        context.insert(ShiftLog(chapterFocus: focusChapter))
        try? context.save()
        showsStart = false
    }
}

private struct ActiveShiftCard: View {
    let shift: ShiftLog
    let newDrugCount: Int
    let reviewCount: Int

    var body: some View {
        TimelineView(.periodic(from: .now, by: 60)) { timeline in
            ActiveShiftContent(
                shift: shift,
                newDrugCount: newDrugCount,
                reviewCount: reviewCount,
                currentDate: timeline.date
            )
        }
    }
}

private struct ShiftPhase: Identifiable {
    let title: String
    let startMinute: Double
    let duration: Int

    var id: String { title }
    var endMinute: Double { startMinute + Double(duration) }
}

private struct ActiveShiftContent: View {
    let shift: ShiftLog
    let newDrugCount: Int
    let reviewCount: Int
    let currentDate: Date

    private let phases: [ShiftPhase] = [
        ShiftPhase(title: "Capture shelf drugs", startMinute: 0, duration: 30),
        ShiftPhase(title: "Understand selected drugs", startMinute: 30, duration: 60),
        ShiftPhase(title: "Quiz and review", startMinute: 90, duration: 45),
        ShiftPhase(title: "Observe with pharmacist", startMinute: 135, duration: 30),
        ShiftPhase(title: "End-shift reflection", startMinute: 165, duration: 15)
    ]

    private var elapsedMinutes: Double {
        max(0, currentDate.timeIntervalSince(shift.startedAt) / 60)
    }

    private var progress: Double { min(1, elapsedMinutes / 180) }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            header
            ProgressView(value: progress).tint(.accentColor)
            counters
            if !shift.pharmacistQuestions.isEmpty {
                Label("\(shift.pharmacistQuestions.count) pharmacist questions recorded", systemImage: "questionmark.bubble")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            ForEach(phases) { phase in
                ShiftPhaseRow(phase: phase, elapsedMinutes: elapsedMinutes)
            }
        }
        .padding(18)
        .background(.background, in: RoundedRectangle(cornerRadius: 20))
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(shift.chapterFocus.rawValue).font(.title2.bold())
                Text("3-hour pharmacy mode • flexible guidance")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text("\(Int(progress * 100))%")
                .font(.headline.monospacedDigit())
        }
    }

    private var counters: some View {
        HStack {
            LabeledContent("New drugs", value: "\(newDrugCount)/10")
            Divider()
            LabeledContent("Reviews", value: "\(reviewCount)")
        }
    }
}

private struct ShiftPhaseRow: View {
    let phase: ShiftPhase
    let elapsedMinutes: Double

    private var isComplete: Bool { elapsedMinutes >= phase.endMinute }
    private var isCurrent: Bool { elapsedMinutes >= phase.startMinute && !isComplete }

    private var icon: String {
        if isComplete { return "checkmark.circle.fill" }
        if isCurrent { return "circle.inset.filled" }
        return "circle"
    }

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(isComplete || isCurrent ? Color.accentColor : Color.secondary)
            Text(phase.title)
            Spacer()
            Text("\(phase.duration) min")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

private struct EndShiftView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    let shift: ShiftLog
    let drugs: [Drug]
    let reviews: [ReviewLog]

    var body: some View {
        Form {
            Section("Reflection") {
                TextField("What did I learn today?", text: binding(\.whatILearned), axis: .vertical).lineLimit(3...8)
                TextField("Which drugs confused me? One per line", text: linesBinding(\.confusingDrugs), axis: .vertical).lineLimit(2...6)
                TextField("What question did I ask the pharmacist? One per line", text: linesBinding(\.pharmacistQuestions), axis: .vertical).lineLimit(2...6)
                TextField("What should I review tomorrow?", text: binding(\.tomorrowReview), axis: .vertical).lineLimit(2...6)
                TextField("Other notes", text: binding(\.notes), axis: .vertical).lineLimit(2...6)
            }
            Section {
                Button("Complete Shift") { finish() }
                    .frame(maxWidth: .infinity, minHeight: 48)
                    .accessibilityIdentifier("shift.complete")
            }
        }
        .navigationTitle("End Shift")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Not yet") { dismiss() } } }
    }

    private func binding(_ keyPath: ReferenceWritableKeyPath<ShiftLog, String>) -> Binding<String> {
        Binding(get: { shift[keyPath: keyPath] }, set: { shift[keyPath: keyPath] = $0 })
    }

    private func linesBinding(_ keyPath: ReferenceWritableKeyPath<ShiftLog, [String]>) -> Binding<String> {
        Binding(get: { shift[keyPath: keyPath].joined(separator: "\n") }, set: { shift[keyPath: keyPath] = $0.splitLines })
    }

    private func finish() {
        let end = Date.now
        shift.newDrugsAdded = drugs.filter { $0.dateAdded >= shift.startedAt && $0.dateAdded <= end }.count
        shift.reviewsCompleted = reviews.filter { $0.date >= shift.startedAt && $0.date <= end }.count
        shift.finish(at: end)
        try? context.save()
        dismiss()
    }
}

struct EncounterEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Query(sort: \Drug.scientificName) private var drugs: [Drug]
    @State private var topic = ""
    @State private var relatedDrugID: UUID?
    @State private var whatHappened = ""
    @State private var whatILearned = ""
    @State private var pharmacistNote = ""
    @State private var privacyConfirmed = false
    @State private var errorMessage: String?

    private var selectedDrug: Drug? { drugs.first { $0.id == relatedDrugID } }
    private var combined: String { [topic, whatHappened, whatILearned, pharmacistNote].joined(separator: " ") }

    var body: some View {
        Form {
            Section {
                Label("Never enter a patient name, phone number, email, address, prescription number, or other identifying detail.", systemImage: "hand.raised.fill")
                    .foregroundStyle(.red)
            }
            Section("Educational encounter") {
                TextField("Topic", text: $topic)
                Picker("Related drug", selection: $relatedDrugID) {
                    Text("None").tag(UUID?.none)
                    ForEach(drugs) { Text($0.displayName).tag(Optional($0.id)) }
                }
                TextField("What happened (no patient details)", text: $whatHappened, axis: .vertical).lineLimit(3...7)
                TextField("What I learned", text: $whatILearned, axis: .vertical).lineLimit(3...7)
                TextField("Pharmacist note", text: $pharmacistNote, axis: .vertical).lineLimit(3...7)
                Toggle("I confirm this contains no patient-identifying data", isOn: $privacyConfirmed)
            }
        }
        .navigationTitle("Encounter Note")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
            ToolbarItem(placement: .confirmationAction) { Button("Save") { save() }.disabled(topic.trimmed.isEmpty || !privacyConfirmed) }
        }
        .alert("Cannot save", isPresented: Binding(get: { errorMessage != nil }, set: { if !$0 { errorMessage = nil } })) {
            Button("OK") { errorMessage = nil }
        } message: { Text(errorMessage ?? "") }
    }

    private func save() {
        guard !PrivacyValidator.containsObviousIdentifier(combined) else {
            errorMessage = "This looks like it may contain a phone number or email address. Remove identifying information before saving."
            return
        }
        context.insert(EncounterNote(topic: topic.trimmed, relatedDrug: selectedDrug, whatHappened: whatHappened.trimmed, whatILearned: whatILearned.trimmed, pharmacistNote: pharmacistNote.trimmed, privacyConfirmed: privacyConfirmed))
        do { try context.save(); dismiss() } catch { errorMessage = error.localizedDescription }
    }
}
