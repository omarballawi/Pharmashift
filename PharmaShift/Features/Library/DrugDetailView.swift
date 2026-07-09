import SwiftData
import SwiftUI

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
    var id: String { rawValue }
}

struct DrugDetailView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(AppTheme.self) private var theme
    @Environment(ReviewScheduler.self) private var scheduler
    let drug: Drug
    @State private var sheet: DrugDetailSheet?
    @State private var expandedFields: Set<String> = []

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    hero
                    jumpChips(proxy)
                    identityCard.id(DrugCardAnchor.identity).accessibilityIdentifier("drugCard.identity")
                    usesCard.id(DrugCardAnchor.uses)
                    pharmacologyCard.id(DrugCardAnchor.pharmacology).accessibilityIdentifier("drugCard.pharmacology")
                    safetyCard.id(DrugCardAnchor.safety).accessibilityIdentifier("drugCard.safety")
                    counselingCard.id(DrugCardAnchor.counseling)
                    arabicCard.id(DrugCardAnchor.arabic)
                    notesCard.id(DrugCardAnchor.notes)
                    masteryCard.id(DrugCardAnchor.mastery)
                    actions.id(DrugCardAnchor.review)
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
                }
            }
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
            SafetyRadar(values: safetyRadarValues)
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
        card("Personal notes", icon: "note.text") { expandableValue("My notes", drug.notes) }
    }

    private var masteryCard: some View {
        card("Drug Mastery", icon: "sparkles") {
            HStack { Text("Six mastery checks").font(.subheadline); Spacer(); Text("\(drug.masteryCount)/6").font(.headline.monospacedDigit()) }
            ProgressView(value: Double(drug.masteryCount), total: 6).tint(drug.isMastered ? .green : theme.tint)
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
    private func severityColor(_ rawValue: String) -> Color {
        switch severity(rawValue) { case .low: .green; case .medium: .orange; case .high: .red; case .unknown: .secondary }
    }
}
