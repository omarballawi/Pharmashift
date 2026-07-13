import SwiftData
import SwiftUI
import AVFoundation
import Speech

private enum DrugCardAnchor: String, CaseIterable, Identifiable {
    case identity = "Identity"
    case uses = "Uses"
    case pharmacology = "PK"
    case safety = "Safety"
    case counseling = "Counseling"
    case arabic = "Arabic"
    case notes = "Notes"
    case mastery = "Mastery"
    case review = "Review"

    var id: String { rawValue }
}

private enum DrugDetailSheet: String, Identifiable {
    case editor
    case review
    case mechanism
    case pkTimeline
    case safetySort
    case counselingBuilder
    case voiceCounseling
    case atomicNotes
    var id: String { rawValue }
}

private enum DrugCardPage: String, CaseIterable, Identifiable {
    case overview = "Overview"
    case learn = "Learn"
    case safety = "Safety"
    case counsel = "Counsel"
    case links = "Notes & Links"

    var id: String { rawValue }
    var icon: String {
        switch self {
        case .overview: "sparkles"
        case .learn: "book.pages.fill"
        case .safety: "shield.fill"
        case .counsel: "quote.bubble.fill"
        case .links: "point.3.connected.trianglepath.dotted"
        }
    }
}

struct DrugDetailView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(AppTheme.self) private var theme
    @Environment(ReviewScheduler.self) private var scheduler
    let drug: Drug
    @State private var sheet: DrugDetailSheet?
    @State private var expandedFields: Set<String> = []
    @State private var selectedPage: DrugCardPage = .overview

    var body: some View {
        VStack(spacing: 0) {
            pagePicker
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    pageContent
                }
                .padding()
            }
            .background(theme.background)
        }
        .navigationTitle("Drug Card")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { Button("Edit") { sheet = .editor } }
        .sheet(item: $sheet) { destination in
            NavigationStack {
                switch destination {
                case .editor: DrugEditorView(drug: drug)
                case .review: PracticeSessionView(initialDrug: drug)
                case .mechanism: MechanismBuilderView(drug: drug)
                case .pkTimeline: PKTimelineChallengeView(drug: drug)
                case .safetySort: SafetySortView(drug: drug)
                case .counselingBuilder: CounselingBuilderView(drug: drug)
                case .voiceCounseling: VoiceCounselingView(drug: drug)
                case .atomicNotes: AtomicNotesView(drug: drug)
                }
            }
        }
    }

    private var pagePicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 7) {
                ForEach(DrugCardPage.allCases) { page in
                    Button {
                        withAnimation(reduceMotion ? nil : .snappy) { selectedPage = page }
                    } label: {
                        Label(page.rawValue, systemImage: page.icon)
                            .font(.caption.weight(.semibold)).padding(.horizontal, 11).frame(minHeight: 38)
                            .background(selectedPage == page ? theme.tint : Color.secondary.opacity(0.10), in: Capsule())
                            .foregroundStyle(selectedPage == page ? .white : .primary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal).padding(.vertical, 8)
        }
        .background(.bar)
        .accessibilityLabel("Drug Card pages")
    }

    @ViewBuilder private var pageContent: some View {
        switch selectedPage {
        case .overview:
            hero
            mustKnowCard
            identityCard.accessibilityIdentifier("drugCard.identity")
            masteryCard
            actions
        case .learn:
            usesCard
            pharmacologyCard.accessibilityIdentifier("drugCard.pharmacology")
            interactiveLessonButton("Build the mechanism", icon: "arrow.down.square.fill", destination: .mechanism)
            interactiveLessonButton("Explore the PK timeline", icon: "waveform.path.ecg.rectangle.fill", destination: .pkTimeline)
        case .safety:
            safetyCard.accessibilityIdentifier("drugCard.safety")
            interactiveLessonButton("Sort safety statements", icon: "rectangle.3.group.bubble.fill", destination: .safetySort)
        case .counsel:
            counselingCard
            interactiveLessonButton("Build the counseling message", icon: "text.bubble.fill", destination: .counselingBuilder)
            interactiveLessonButton("Counsel this patient", icon: "waveform.badge.mic", destination: .voiceCounseling)
            arabicCard
            actions
        case .links:
            notesCard
            interactiveLessonButton("Add a linked note", icon: "note.text.badge.plus", destination: .atomicNotes)
            connectedKnowledgeCard
            provenanceDetails
        }
    }

    private func interactiveLessonButton(_ title: String, icon: String, destination: DrugDetailSheet) -> some View {
        Button { sheet = destination } label: {
            HStack {
                Image(systemName: icon).font(.title3).foregroundStyle(theme.tint)
                Text(title).font(.headline)
                Spacer()
                Image(systemName: "chevron.forward").font(.caption.bold()).foregroundStyle(.secondary)
            }
            .padding(15).frame(minHeight: 56)
            .background(theme.card, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    private var mustKnowCard: some View {
        card("3 things to remember", icon: "lightbulb.max.fill") {
            let facts = Array(drug.mustKnow.filter { !$0.trimmed.isEmpty }.prefix(3))
            if facts.isEmpty {
                Text("Add three must-know facts to make every review focused.").font(.subheadline).foregroundStyle(.secondary)
            } else {
                ForEach(Array(facts.enumerated()), id: \.offset) { index, fact in
                    HStack(alignment: .top, spacing: 10) {
                        Text("\(index + 1)").font(.caption.bold()).foregroundStyle(.white)
                            .frame(width: 25, height: 25).background(theme.tint, in: Circle())
                        Text(fact).font(.subheadline).frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        }
    }

    private var connectedKnowledgeCard: some View {
        card("Connected knowledge", icon: "point.3.connected.trianglepath.dotted") {
            value("System", drug.chapterRaw)
            value("Class", drug.drugClass)
            expandableValue("Uses", drug.indications.joined(separator: " • "))
            expandableValue("Warnings", drug.warnings.joined(separator: " • "))
            Text("Related drugs and backlinks will appear here as your library grows.")
                .font(.caption).foregroundStyle(.secondary)
        }
    }

    private var provenanceDetails: some View {
        card("Card history", icon: "clock.arrow.circlepath") {
            value("Created", drug.dateAdded.formatted(date: .abbreviated, time: .omitted))
            if let reviewed = drug.lastReviewed { value("Last reviewed", reviewed.formatted(date: .abbreviated, time: .shortened)) }
            value("Generated by", drug.importedSourceName.trimmed.isEmpty ? "Manual card" : drug.importedSourceName)
        }
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: 14) {
            DrugPhotoGalleryView(images: drug.packageImages, height: 220)
                .overlay(alignment: .topTrailing) {
                    if scheduler.isDue(drug) {
                        Label("Due", systemImage: "calendar.badge.clock")
                            .font(.caption.bold()).padding(8)
                            .background(.orange, in: Capsule()).foregroundStyle(.white).padding(10)
                    }
                }
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(drug.displayName).font(.largeTitle.bold())
                    if !drug.tradeNames.isEmpty {
                        Text(drug.tradeNames.joined(separator: ", ")).font(.title3).foregroundStyle(.secondary)
                    }
                }
                Spacer()
                MasteryBadge(drug: drug)
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 7) {
                    badge(drug.chapterRaw, icon: drug.chapter.icon, color: theme.colors(for: drug.chapter).first ?? theme.tint)
                    badge(drug.drugClass, icon: "square.grid.2x2.fill", color: .indigo)
                    if let form = drug.dosageForms.first { badge(form, icon: "pills.fill", color: .teal) }
                    if let strength = drug.strengths.first { badge(strength, icon: "gauge.with.dots.needle.33percent", color: .orange) }
                }
            }
            provenanceBadge
        }
    }

    @ViewBuilder private var provenanceBadge: some View {
        if drug.isImported, let url = URL(string: drug.sourceURL), !drug.sourceURL.isEmpty {
            Link(destination: url) {
                Label(provenanceText, systemImage: drug.sourceNeedsReview ? "exclamationmark.triangle.fill" : "checkmark.seal.fill")
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 9).padding(.vertical, 6)
                    .background(drug.sourceNeedsReview ? Color.orange.opacity(0.16) : theme.softTint, in: Capsule())
            }
            .accessibilityHint("Opens the official label")
        }
    }

    private var provenanceText: String {
        let provider = drug.importedSourceName.trimmed.isEmpty ? "DailyMed" : drug.importedSourceName
        guard let date = drug.sourceUpdatedAt else { return provider }
        return "\(provider) • \(date.formatted(date: .abbreviated, time: .omitted))"
    }

    private func jumpChips(_ proxy: ScrollViewProxy) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(DrugCardAnchor.allCases) { anchor in
                    Button(anchor.rawValue) {
                        withAnimation(reduceMotion ? nil : .snappy) { proxy.scrollTo(anchor, anchor: .top) }
                    }
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.capsule)
                }
            }
        }
        .accessibilityLabel("Jump to a Drug Card section")
    }

    private var identityCard: some View {
        card("Identity", icon: "pills.fill") {
            value("System / Chapter", drug.chapterRaw)
            value("Class", drug.drugClass)
            value("Dosage forms", drug.dosageForms.joined(separator: ", "))
            value("Strengths", drug.strengths.joined(separator: ", "))
            value("Routes", drug.routes.joined(separator: ", "))
            if drug.sourceNeedsReview {
                safetyValue("Source quality", text: [drug.trustedSourceWasTruncated ? "Trusted packet was trimmed before AI formatting." : "", drug.sourceQualityNotes, drug.sourceMissingFields.isEmpty ? "" : "Missing: \(drug.sourceMissingFields.joined(separator: ", "))"].filter { !$0.trimmed.isEmpty }.joined(separator: "\n"), severity: SafetySeverity.medium.rawValue)
            }
            value("Shelf", drug.shelfLocation)
        }
    }

    private var usesCard: some View {
        card("Uses & mechanism", icon: "cross.case.fill") {
            expandableValue("Indications / Uses", drug.indications.joined(separator: "\n"))
            expandableValue("Mechanism", drug.mechanism)
            if !drug.mechanismKeywords.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(drug.mechanismKeywords, id: \.self) { keyword in
                            Text(keyword).font(.caption.weight(.semibold))
                                .padding(.horizontal, 8).padding(.vertical, 5)
                                .background(.tint.opacity(0.12), in: Capsule())
                        }
                    }
                }
            }
            value("How to take", drug.howToTake)
            value("Food instructions", drug.foodInstruction)
        }
    }

    private var pharmacologyCard: some View {
        card("Pharmacokinetics", icon: "waveform.path.ecg") {
            PharmacologyMeter(title: "Half-life", icon: "clock.arrow.circlepath", scale: .halfLife, value: drug.halfLifeHours, fallback: drug.halfLifeBand.rawValue, detail: drug.halfLifeText)
            PharmacologyMeter(title: "Onset", icon: "hare.fill", scale: .onset, value: drug.onsetMinutes, fallback: drug.onsetBand.rawValue, detail: drug.onsetText)
            PharmacologyMeter(title: "Duration", icon: "timer", scale: .duration, value: drug.durationHours, fallback: drug.durationBand.rawValue, detail: drug.durationText)
            DosingFrequencyMeter(frequency: drug.dosingFrequency, timesPerDay: drug.timesPerDay)
            PharmacologyStatusCard(title: "Prodrug", value: drug.prodrugStatus.rawValue, detail: "", icon: "arrow.triangle.2.circlepath")
            PharmacologyStatusCard(title: "Excretion", value: drug.excretionRoute.rawValue, detail: drug.excretionNotes, icon: "drop.triangle.fill")
            arabicValue("PK memory line", drug.pkMemoryLineArabic)
        }
    }

    private var safetyCard: some View {
        card("Safety", icon: "shield.fill") {
            knowledgeCompletenessMap
            if !drug.safetyFlags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(drug.safetyFlags) { flag in
                            Text(flag.rawValue).font(.caption.weight(.semibold))
                                .padding(.horizontal, 8).padding(.vertical, 5)
                                .background(.orange.opacity(0.13), in: Capsule()).foregroundStyle(.orange)
                        }
                    }
                }
            }
            safetyValue("Contraindications", text: drug.contraindications.joined(separator: "\n"), severity: drug.contraindicationSeverityRaw)
            safetyValue("Toxicity", text: drug.toxicity, severity: drug.toxicitySeverityRaw)
            safetyValue("Warnings", text: drug.warnings.joined(separator: "\n"), severity: drug.warningSeverityRaw)
            safetyValue("Interactions", text: drug.interactions.joined(separator: "\n"), severity: drug.interactionSeverityRaw)
            safetyValue("Renal caution", text: drug.renalCaution, severity: drug.renalSeverityRaw)
            safetyValue("Hepatic caution", text: drug.hepaticCaution, severity: drug.hepaticSeverityRaw)
            safetyValue("Pregnancy caution", text: drug.pregnancyCaution, severity: drug.pregnancySeverityRaw)
        }
    }

    private var knowledgeCompletenessMap: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Knowledge completeness").font(.subheadline.bold())
            completenessRow("Identity", complete: !drug.scientificName.trimmed.isEmpty && !drug.drugClass.trimmed.isEmpty)
            completenessRow("Uses", complete: !drug.indications.isEmpty)
            completenessRow("PK", complete: !drug.halfLifeText.trimmed.isEmpty || drug.halfLifeHours != nil)
            completenessRow("Safety", complete: !drug.warnings.isEmpty || !drug.contraindications.isEmpty)
            completenessRow("Counseling", complete: !drug.counselingSentence.trimmed.isEmpty)
            completenessRow("Interactions", complete: !drug.interactions.isEmpty)
            completenessRow("Image recognition", complete: !drug.packageImages.isEmpty)
        }
        .padding(13).background(theme.tint.opacity(0.08), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private func completenessRow(_ label: String, complete: Bool) -> some View {
        HStack {
            Image(systemName: complete ? "checkmark.circle.fill" : "circle.dashed")
                .foregroundStyle(complete ? theme.tint : .secondary)
            Text(label).font(.caption.weight(.semibold))
            Spacer()
            Text(complete ? "Ready" : "Add info").font(.caption2).foregroundStyle(.secondary)
        }
    }

    private var counselingCard: some View {
        card("Counseling", icon: "quote.bubble.fill") {
            expandableValue("Counseling sentence", drug.counselingSentence)
            arabicValue("How to take", drug.counselingHowToTakeArabic)
            arabicValue("Food", drug.counselingFoodArabic)
            expandableValue("What patient may feel", drug.patientFeelingsArabic.joined(separator: "\n"))
            expandableValue("When to seek help", drug.seekHelpArabic.joined(separator: "\n"))
            arabicValue("Missed dose", drug.missedDoseArabic)
            expandableValue("Common adverse effects", drug.commonSideEffects.joined(separator: "\n"))
            expandableValue("Serious adverse effects", drug.seriousSideEffects.joined(separator: "\n"))
            expandableValue("Patient questions", drug.patientQuestions.joined(separator: "\n"))
        }
    }

    private var arabicCard: some View {
        card("Arabic explanations", icon: "character.book.closed.fill") {
            arabicValue("الشرح بالعربية", drug.arabicExplanation)
            arabicValue("آلية العمل بالعربية", drug.arabicMechanism)
            arabicValue("الإرشاد بالعربية", drug.arabicCounseling)
            arabicValue("ملاحظاتي بالعربية", drug.arabicPersonalNotes)
        }
    }

    private var notesCard: some View {
        card("Personal notes", icon: "note.text") {
            expandableValue("My notes", drug.notes)
            ForEach(drug.atomicNotes.prefix(4)) { note in
                VStack(alignment: .leading, spacing: 4) {
                    HStack { Text(note.kind.rawValue).font(.caption.bold()).foregroundStyle(theme.tint); Spacer(); Text(note.linkedField).font(.caption2).foregroundStyle(.secondary) }
                    Text(note.text).font(.subheadline)
                }
                .padding(10).background(.secondary.opacity(0.07), in: RoundedRectangle(cornerRadius: 12))
            }
        }
    }

    private var masteryCard: some View {
        card("Drug Mastery", icon: "sparkles") {
            HStack { Text("Six mastery checks").font(.subheadline); Spacer(); Text("\(drug.masteryCount)/6").font(.headline.monospacedDigit()) }
            ProgressView(value: Double(drug.masteryCount), total: 6).tint(drug.isMastered ? .green : theme.tint)
            VStack(spacing: 8) {
                ForEach(drug.memoryItems) { item in
                    HStack {
                        Text(item.field.rawValue).font(.caption.weight(.semibold))
                        Spacer()
                        Text(item.strengthLabel).font(.caption2.bold())
                            .foregroundStyle(memoryColor(item.strengthLabel))
                            .padding(.horizontal, 7).padding(.vertical, 4)
                            .background(memoryColor(item.strengthLabel).opacity(0.12), in: Capsule())
                    }
                }
            }
            expandableValue("Must know", drug.mustKnow.joined(separator: "\n"))
            if !flashcardPairs.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Flashcards").font(.caption.weight(.semibold)).foregroundStyle(.secondary)
                    ForEach(flashcardPairs, id: \.0) { pair in
                        VStack(alignment: .leading, spacing: 3) {
                            Text(pair.0).font(.subheadline.weight(.semibold))
                            Text(pair.1).font(.caption).foregroundStyle(.secondary)
                        }
                        .padding(10)
                        .background(.secondary.opacity(0.08), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                }
            }
            Text("Scientific • Trade • Class • Use • Warning • Counseling").font(.caption).foregroundStyle(.secondary)
        }
    }

    private var actions: some View {
        card("Review actions", icon: "brain.head.profile") {
            Button { sheet = .review } label: {
                Label("Start review / ابدأ المراجعة", systemImage: "brain.head.profile").frame(maxWidth: .infinity, minHeight: 48)
            }
            .buttonStyle(.borderedProminent).tint(theme.tint).disabled(drug.isUnknown)
            HStack {
                Button { drug.markSeen(); try? context.save() } label: { Label("Seen today", systemImage: "eye.fill") }
                Spacer()
                Button { drug.isConfusing.toggle(); try? context.save() } label: {
                    Label(drug.isConfusing ? "Clear weak mark" : "Mark confusing", systemImage: "exclamationmark.bubble")
                }
            }
            .font(.subheadline)
        }
    }

    private var safetyRadarValues: [(label: String, severity: SafetySeverity)] {
        [
            ("Contraindications", severity(drug.contraindicationSeverityRaw)),
            ("Toxicity", severity(drug.toxicitySeverityRaw)),
            ("Warnings", severity(drug.warningSeverityRaw)),
            ("Interactions", severity(drug.interactionSeverityRaw)),
            ("Renal", severity(drug.renalSeverityRaw)),
            ("Hepatic", severity(drug.hepaticSeverityRaw)),
            ("Pregnancy", severity(drug.pregnancySeverityRaw))
        ]
    }

    private var flashcardPairs: [(String, String)] {
        drug.flashcards.compactMap { raw in
            let parts = raw.components(separatedBy: "\t")
            guard parts.count >= 2 else { return nil }
            return (parts[0], parts.dropFirst().joined(separator: "\t"))
        }
    }

    private func card<Content: View>(_ title: String, icon: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Label(title, systemImage: icon).font(.title3.bold()).foregroundStyle(theme.tint)
            content()
        }
        .padding(16).frame(maxWidth: .infinity, alignment: .leading)
        .background(theme.card, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    private func badge(_ text: String, icon: String, color: Color) -> some View {
        Group {
            if !text.trimmed.isEmpty {
                Label(text, systemImage: icon).font(.caption.weight(.semibold))
                    .padding(.horizontal, 9).padding(.vertical, 6)
                    .background(color.opacity(0.14), in: Capsule()).foregroundStyle(color)
            }
        }
    }

    @ViewBuilder private func value(_ label: String, _ text: String) -> some View {
        if !text.trimmed.isEmpty {
            VStack(alignment: .leading, spacing: 4) {
                Text(label).font(.caption.weight(.semibold)).foregroundStyle(.secondary)
                Text(text).frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    @ViewBuilder private func expandableValue(_ label: String, _ text: String) -> some View {
        if !text.trimmed.isEmpty {
            let isExpanded = expandedFields.contains(label)
            VStack(alignment: .leading, spacing: 5) {
                Text(label).font(.caption.weight(.semibold)).foregroundStyle(.secondary)
                Text(text).lineLimit(isExpanded ? nil : 4).frame(maxWidth: .infinity, alignment: .leading)
                if text.count > 220 || text.split(separator: "\n").count > 4 {
                    Button(isExpanded ? "Show less" : "Show more") {
                        withAnimation(reduceMotion ? nil : .easeInOut) {
                            if isExpanded { expandedFields.remove(label) } else { expandedFields.insert(label) }
                        }
                    }
                    .font(.caption.weight(.semibold))
                }
            }
        }
    }

    @ViewBuilder private func arabicValue(_ label: String, _ text: String) -> some View {
        if !text.trimmed.isEmpty {
            VStack(alignment: .trailing, spacing: 4) {
                Text(label).font(.caption.weight(.semibold)).foregroundStyle(.secondary)
                Text(text).frame(maxWidth: .infinity, alignment: .trailing)
            }
            .environment(\.layoutDirection, .rightToLeft)
        }
    }

    @ViewBuilder private func safetyValue(_ title: String, text: String, severity: String) -> some View {
        if !text.trimmed.isEmpty || severity != SafetySeverity.unknown.rawValue {
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(title).font(.subheadline.bold())
                    Spacer()
                    Text(severity).font(.caption2.bold()).padding(.horizontal, 7).padding(.vertical, 4)
                        .background(severityColor(severity).opacity(0.16), in: Capsule()).foregroundStyle(severityColor(severity))
                }
                if !text.trimmed.isEmpty { Text(text).font(.subheadline) }
            }
            .padding(11).background(severityColor(severity).opacity(0.09), in: RoundedRectangle(cornerRadius: 14))
        }
    }

    private func severity(_ rawValue: String) -> SafetySeverity { SafetySeverity(rawValue: rawValue) ?? .unknown }
    private func memoryColor(_ label: String) -> Color {
        switch label { case "Strong": .green; case "Medium": .orange; case "Weak": .red; default: .secondary }
    }
    private func severityColor(_ rawValue: String) -> Color {
        switch severity(rawValue) { case .low: .green; case .medium: .orange; case .high: .red; case .unknown: .secondary }
    }
}

private struct MechanismBuilderView: View {
    @Environment(\.dismiss) private var dismiss
    let drug: Drug
    @State private var steps: [String] = []
    @State private var checked = false

    private var answer: [String] {
        let separators = CharacterSet(charactersIn: "→↓\n")
        let parsed = drug.mechanism.components(separatedBy: separators).map(\.trimmed).filter { !$0.isEmpty }
        return parsed.count > 1 ? parsed : drug.mechanismKeywords.filter { !$0.trimmed.isEmpty }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Arrange the mechanism").font(.largeTitle.bold())
                    Text("Move the steps from target to clinical effect.").foregroundStyle(.secondary)
                    ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                        HStack(spacing: 10) {
                            Text("\(index + 1)").font(.caption.bold()).frame(width: 28, height: 28).background(.tint.opacity(0.15), in: Circle())
                            Text(step).font(.subheadline).frame(maxWidth: .infinity, alignment: .leading)
                            VStack(spacing: 3) {
                                Button { move(index, by: -1) } label: { Image(systemName: "chevron.up") }.disabled(index == 0)
                                Button { move(index, by: 1) } label: { Image(systemName: "chevron.down") }.disabled(index + 1 == steps.count)
                            }
                        }
                        .padding(12).background(.background, in: RoundedRectangle(cornerRadius: 15))
                    }
                    if checked {
                        Label(steps == answer ? "Correct sequence" : "Almost—compare with the saved mechanism and try again.", systemImage: steps == answer ? "checkmark.seal.fill" : "arrow.clockwise")
                            .foregroundStyle(steps == answer ? .green : .orange).font(.subheadline.bold())
                    }
                    Button("Check sequence") { withAnimation(.snappy) { checked = true } }
                        .buttonStyle(.borderedProminent).frame(maxWidth: .infinity, minHeight: 48).disabled(steps.count < 2)
                    if answer.count < 2 { Text("Add mechanism steps or keywords to enable this builder.").foregroundStyle(.secondary) }
                }
                .padding()
            }
            .navigationTitle(drug.displayName).navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .confirmationAction) { Button("Done") { dismiss() } } }
            .onAppear { if steps.isEmpty { steps = answer.shuffled() } }
        }
    }

    private func move(_ index: Int, by offset: Int) {
        let destination = index + offset
        guard steps.indices.contains(destination) else { return }
        withAnimation(.snappy) { steps.swapAt(index, destination); checked = false }
    }
}

private struct PKTimelineChallengeView: View {
    @Environment(\.dismiss) private var dismiss
    let drug: Drug
    @State private var onsetPosition = 0.35
    @State private var halfLifePosition = 0.55
    @State private var durationPosition = 0.65
    @State private var checked = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    Text("PK Timeline").font(.largeTitle.bold())
                    Text("Place each marker. The scale is logarithmic so minutes and days stay usable together.").foregroundStyle(.secondary)
                    timelineRow("Onset", icon: "hare.fill", scale: .onset, position: $onsetPosition, answer: drug.onsetMinutes)
                    timelineRow("Half-life", icon: "clock.arrow.circlepath", scale: .halfLife, position: $halfLifePosition, answer: drug.halfLifeHours)
                    timelineRow("Duration", icon: "timer", scale: .duration, position: $durationPosition, answer: drug.durationHours)
                    Button("Check timeline") { withAnimation(.snappy) { checked = true } }
                        .buttonStyle(.borderedProminent).frame(maxWidth: .infinity, minHeight: 48)
                    if checked {
                        VStack(alignment: .leading, spacing: 7) {
                            result("Onset", position: onsetPosition, answer: drug.onsetMinutes, scale: .onset)
                            result("Half-life", position: halfLifePosition, answer: drug.halfLifeHours, scale: .halfLife)
                            result("Duration", position: durationPosition, answer: drug.durationHours, scale: .duration)
                        }
                        .padding(14).background(.tint.opacity(0.08), in: RoundedRectangle(cornerRadius: 16))
                    }
                }
                .padding()
            }
            .navigationTitle(drug.displayName).navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .confirmationAction) { Button("Done") { dismiss() } } }
        }
    }

    private func timelineRow(_ title: String, icon: String, scale: PharmacologyScale, position: Binding<Double>, answer: Double?) -> some View {
        VStack(alignment: .leading, spacing: 9) {
            HStack { Label(title, systemImage: icon).font(.headline); Spacer(); Text(scale.formatted(scale.value(at: position.wrappedValue))).font(.caption.monospacedDigit()) }
            Slider(value: position, in: 0...1).tint(.accentColor).disabled(answer == nil)
            HStack { Text(scale.formatted(scale.bounds.lowerBound)); Spacer(); Text(scale.formatted(scale.bounds.upperBound)) }.font(.caption2).foregroundStyle(.secondary)
            if answer == nil { Text("No normalized value saved yet.").font(.caption).foregroundStyle(.secondary) }
        }
        .padding(14).background(.background, in: RoundedRectangle(cornerRadius: 16))
    }

    private func result(_ title: String, position: Double, answer: Double?, scale: PharmacologyScale) -> some View {
        guard let answer else { return AnyView(Label("\(title): add a normalized value", systemImage: "questionmark.circle").foregroundStyle(.secondary)) }
        let guess = scale.value(at: position)
        let close = max(guess, answer) / max(min(guess, answer), 0.01) <= 2
        return AnyView(Label("\(title): \(scale.formatted(answer))", systemImage: close ? "checkmark.circle.fill" : "arrow.left.arrow.right.circle").foregroundStyle(close ? .green : .orange))
    }
}

private struct SafetySortView: View {
    struct Item: Identifiable { let id = UUID(); let text: String; let category: String }
    let drug: Drug
    @Environment(\.dismiss) private var dismiss
    @State private var index = 0
    @State private var result: String?
    @State private var score = 0
    private let categories = ["Common effect", "Serious warning", "Contraindication", "Interaction"]
    private var items: [Item] {
        [drug.commonSideEffects.first.map { Item(text: $0, category: categories[0]) }, drug.warnings.first.map { Item(text: $0, category: categories[1]) }, drug.contraindications.first.map { Item(text: $0, category: categories[2]) }, drug.interactions.first.map { Item(text: $0, category: categories[3]) }].compactMap { $0 }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 18) {
                if items.indices.contains(index) {
                    Text("Safety Sort").font(.largeTitle.bold())
                    Text(items[index].text).font(.title3.bold()).multilineTextAlignment(.center).padding().frame(maxWidth: .infinity, minHeight: 150).background(.orange.opacity(0.09), in: RoundedRectangle(cornerRadius: 22))
                    ForEach(categories, id: \.self) { category in
                        Button { choose(category) } label: { Text(category).frame(maxWidth: .infinity, minHeight: 46) }.buttonStyle(.bordered).disabled(result != nil)
                    }
                    if let result {
                        Label(result, systemImage: result == "Correct" ? "checkmark.circle.fill" : "xmark.circle.fill").foregroundStyle(result == "Correct" ? .green : .orange)
                        Button(index + 1 == items.count ? "See result" : "Next") { index += 1; self.result = nil }.buttonStyle(.borderedProminent)
                    }
                } else if items.isEmpty {
                    EmptyStateView(icon: "shield.slash", title: "Add safety facts", message: "Save at least one effect, warning, contraindication, or interaction to start.")
                } else {
                    Image(systemName: "checkmark.seal.fill").font(.system(size: 58)).foregroundStyle(.green)
                    Text("\(score) of \(items.count) sorted correctly").font(.title2.bold())
                    Button("Try again") { index = 0; score = 0 }.buttonStyle(.borderedProminent)
                }
                Spacer()
            }
            .padding().navigationTitle(drug.displayName).navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .confirmationAction) { Button("Done") { dismiss() } } }
        }
    }

    private func choose(_ category: String) { let correct = category == items[index].category; result = correct ? "Correct" : "Belongs in \(items[index].category)"; if correct { score += 1 } }
}

private struct CounselingBuilderView: View {
    @Environment(\.dismiss) private var dismiss
    let drug: Drug
    @State private var selected: Set<String> = []
    @State private var checked = false
    private var correct: [String] { [drug.howToTake, drug.foodInstruction, drug.counselingSentence, drug.missedDoseArabic].map(\.trimmed).filter { !$0.isEmpty } }
    private var choices: [String] { Array((correct + ["Stop as soon as you feel better", "Double the next dose if one is missed"]).prefix(6)) }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    Text("Counseling Builder").font(.largeTitle.bold())
                    Text("Choose every statement that belongs in a clear patient explanation.").foregroundStyle(.secondary)
                    ForEach(choices, id: \.self) { choice in
                        Button { if selected.contains(choice) { selected.remove(choice) } else { selected.insert(choice) }; checked = false } label: {
                            HStack { Image(systemName: selected.contains(choice) ? "checkmark.circle.fill" : "circle"); Text(choice).multilineTextAlignment(.leading); Spacer() }
                                .padding(13).frame(maxWidth: .infinity, minHeight: 48, alignment: .leading).background(.background, in: RoundedRectangle(cornerRadius: 15))
                        }.buttonStyle(.plain)
                    }
                    Button("Check message") { checked = true }.buttonStyle(.borderedProminent).frame(maxWidth: .infinity, minHeight: 48)
                    if checked {
                        let missed = correct.filter { !selected.contains($0) }
                        Label(missed.isEmpty ? "You covered every saved point." : "Missed: \(missed.joined(separator: " • "))", systemImage: missed.isEmpty ? "checkmark.seal.fill" : "exclamationmark.bubble.fill")
                            .foregroundStyle(missed.isEmpty ? .green : .orange).font(.subheadline)
                    }
                }.padding()
            }
            .navigationTitle(drug.displayName).navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .confirmationAction) { Button("Done") { dismiss() } } }
        }
    }
}

private struct AtomicNotesView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    let drug: Drug
    @State private var kind: AtomicNoteKind = .memoryTrick
    @State private var linkedField = "General"
    @State private var noteText = ""
    @State private var contextText = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("New atomic note") {
                    Picker("Type", selection: $kind) { ForEach(AtomicNoteKind.allCases) { Text($0.rawValue).tag($0) } }
                    Picker("Linked field", selection: $linkedField) {
                        ForEach(["General", "Identity", "Uses", "Mechanism", "PK", "Safety", "Counseling", "Shelf"], id: \.self) { Text($0).tag($0) }
                    }
                    TextField("One small, specific note", text: $noteText, axis: .vertical).lineLimit(2...5)
                    TextField("Context or shift (optional)", text: $contextText)
                    Button { save() } label: { Label("Save linked note", systemImage: "link.badge.plus").frame(maxWidth: .infinity, minHeight: 44) }
                        .buttonStyle(.borderedProminent).disabled(noteText.trimmed.isEmpty)
                }
                Section("Linked to \(drug.displayName)") {
                    if drug.atomicNotes.isEmpty { Text("No atomic notes yet.").foregroundStyle(.secondary) }
                    ForEach(drug.atomicNotes) { note in
                        VStack(alignment: .leading, spacing: 5) {
                            HStack { Text(note.kind.rawValue).font(.caption.bold()); Spacer(); Text(note.linkedField).font(.caption2).foregroundStyle(.secondary) }
                            Text(note.text)
                            if !note.context.trimmed.isEmpty { Text(note.context).font(.caption).foregroundStyle(.secondary) }
                        }
                        .swipeActions { Button("Delete", role: .destructive) { remove(note) } }
                    }
                }
            }
            .navigationTitle("Atomic Notes").navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .confirmationAction) { Button("Done") { dismiss() } } }
        }
    }

    private func save() {
        var notes = drug.atomicNotes
        notes.insert(AtomicDrugNote(kindRaw: kind.rawValue, text: noteText.trimmed, linkedField: linkedField, context: contextText.trimmed), at: 0)
        drug.atomicNotes = notes; try? context.save(); noteText = ""; contextText = ""
    }
    private func remove(_ note: AtomicDrugNote) { drug.atomicNotes = drug.atomicNotes.filter { $0.id != note.id }; try? context.save() }
}

@MainActor
private final class CounselingSpeechRecognizer: ObservableObject {
    @Published var transcript = ""
    @Published var isRecording = false
    @Published var errorMessage: String?
    private let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "ar-IQ"))
    private let audioEngine = AVAudioEngine()
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?

    func toggle() { isRecording ? stop() : requestAccessAndStart() }
    func requestAccessAndStart() {
        SFSpeechRecognizer.requestAuthorization { status in
            DispatchQueue.main.async {
                guard status == .authorized else { self.errorMessage = "Speech recognition permission is required for voice practice."; return }
                AVAudioApplication.requestRecordPermission { allowed in
                    DispatchQueue.main.async {
                        if allowed { self.start() }
                        else { self.errorMessage = "Microphone permission is required for voice practice." }
                    }
                }
            }
        }
    }
    func start() {
        do {
            transcript = ""; errorMessage = nil
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.record, mode: .measurement, options: .duckOthers)
            try session.setActive(true, options: .notifyOthersOnDeactivation)
            let request = SFSpeechAudioBufferRecognitionRequest(); request.shouldReportPartialResults = true; self.request = request
            let node = audioEngine.inputNode; let format = node.outputFormat(forBus: 0)
            node.removeTap(onBus: 0)
            node.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, _ in request.append(buffer) }
            audioEngine.prepare(); try audioEngine.start(); isRecording = true
            task = recognizer?.recognitionTask(with: request) { [weak self] result, error in
                DispatchQueue.main.async {
                    if let result { self?.transcript = result.bestTranscription.formattedString }
                    if error != nil || result?.isFinal == true { self?.stop() }
                }
            }
        } catch { errorMessage = error.localizedDescription; stop() }
    }
    func stop() { if audioEngine.isRunning { audioEngine.stop(); audioEngine.inputNode.removeTap(onBus: 0) }; request?.endAudio(); task?.cancel(); isRecording = false }
}

private struct VoiceCounselingView: View {
    @Environment(\.dismiss) private var dismiss
    let drug: Drug
    @StateObject private var speech = CounselingSpeechRecognizer()
    private var points: [String] { [drug.counselingHowToTakeArabic, drug.counselingFoodArabic, drug.counselingSentence, drug.missedDoseArabic] .map(\.trimmed).filter { !$0.isEmpty } }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Counsel this patient").font(.largeTitle.bold())
                    Text("Speak naturally in Iraqi Arabic or English. Renlyst checks coverage, not accent or grammar.").foregroundStyle(.secondary)
                    VStack(alignment: .leading, spacing: 7) { ForEach(points, id: \.self) { Label(shortPrompt($0), systemImage: "circle") } }.font(.subheadline)
                    Button { speech.toggle() } label: {
                        Label(speech.isRecording ? "Stop recording" : "Start counseling", systemImage: speech.isRecording ? "stop.circle.fill" : "mic.circle.fill").frame(maxWidth: .infinity, minHeight: 54)
                    }.buttonStyle(.borderedProminent).tint(speech.isRecording ? .red : .accentColor)
                    if !speech.transcript.isEmpty {
                        Text(speech.transcript).padding(14).frame(maxWidth: .infinity, alignment: .leading).background(.background, in: RoundedRectangle(cornerRadius: 16))
                        Text("You covered \(coveredCount)/\(points.count) saved points.").font(.title3.bold())
                        ForEach(points.filter { !isCovered($0) }, id: \.self) { Label("Missed: \($0)", systemImage: "exclamationmark.bubble.fill").font(.caption).foregroundStyle(.orange) }
                    }
                    if let error = speech.errorMessage { Text(error).font(.caption).foregroundStyle(.red) }
                }.padding()
            }
            .navigationTitle(drug.displayName).navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .confirmationAction) { Button("Done") { speech.stop(); dismiss() } } }
        }
    }
    private var coveredCount: Int { points.filter(isCovered).count }
    private func isCovered(_ point: String) -> Bool {
        let words = point.lowercased().components(separatedBy: .alphanumerics.inverted).filter { $0.count > 3 }
        let transcript = speech.transcript.lowercased()
        return words.prefix(6).contains { transcript.contains($0) }
    }
    private func shortPrompt(_ point: String) -> String { point.count > 80 ? String(point.prefix(77)) + "…" : point }
}
