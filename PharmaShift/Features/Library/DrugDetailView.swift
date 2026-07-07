import SwiftData
import SwiftUI

private enum DrugCardSection: String, CaseIterable, Identifiable {
    case basics = "Basics"
    case uses = "Uses"
    case pk = "PK Visuals"
    case safety = "Safety"
    case counseling = "Counseling"
    case notes = "My Notes"
    case source = "Source"
    var id: String { rawValue }
}

struct DrugDetailView: View {
    @Environment(\.modelContext) private var context
    @Environment(AppTheme.self) private var theme
    @Environment(ReviewScheduler.self) private var scheduler
    let drug: Drug
    @State private var selectedSection: DrugCardSection = .basics
    @State private var showsEditor = false
    @State private var showsReview = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                hero
                sectionPicker
                sectionContent
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(theme.card, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                masteryCard
                actions
            }
            .padding()
        }
        .background(theme.background)
        .navigationTitle("Drug Card")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { Button("Edit") { showsEditor = true } }
        .sheet(isPresented: $showsEditor) { NavigationStack { DrugEditorView(drug: drug) } }
        .sheet(isPresented: $showsReview) { NavigationStack { PracticeSessionView(initialDrug: drug) } }
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: 14) {
            DrugPhotoView(data: drug.imageData, height: 230)
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
                    badge(drug.confidenceLevel.rawValue, icon: "bolt.fill", color: drug.isMastered ? .green : .secondary)
                }
            }
        }
    }

    private func badge(_ text: String, icon: String, color: Color) -> some View {
        Group {
            if !text.trimmed.isEmpty {
                Label(text, systemImage: icon)
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 9).padding(.vertical, 6)
                    .background(color.opacity(0.14), in: Capsule()).foregroundStyle(color)
            }
        }
    }

    private var sectionPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(DrugCardSection.allCases) { section in
                    Button(section.rawValue) { withAnimation(.snappy) { selectedSection = section } }
                        .buttonStyle(.borderedProminent)
                        .tint(selectedSection == section ? theme.tint : Color.secondary.opacity(0.14))
                        .foregroundStyle(selectedSection == section ? .white : .primary)
                }
            }
        }
    }

    @ViewBuilder
    private var sectionContent: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text(selectedSection.rawValue).font(.title3.bold())
                Spacer()
                Image(systemName: sectionIcon).foregroundStyle(theme.tint)
            }
            switch selectedSection {
            case .basics:
                value("System / Chapter", drug.chapterRaw)
                value("Class", drug.drugClass)
                value("Dosage forms", drug.dosageForms.joined(separator: ", "))
                value("Strengths", drug.strengths.joined(separator: ", "))
                value("Routes", drug.routes.joined(separator: ", "))
                value("Shelf", drug.shelfLocation)
            case .uses:
                value("Indications / Uses", drug.indications.joined(separator: "\n"))
                value("Mechanism", drug.mechanism)
                arabicValue("الشرح بالعربية", drug.arabicExplanation)
                arabicValue("آلية العمل بالعربية", drug.arabicMechanism)
                value("How to take", drug.howToTake)
                value("Food instructions", drug.foodInstruction)
                value("Dosing frequency", drug.dosingFrequency.rawValue)
            case .pk:
                visualValue("Half-life", value: drug.halfLifeBand.rawValue, detail: drug.halfLifeText, icon: "clock.arrow.circlepath")
                visualValue("Onset", value: drug.onsetBand.rawValue, detail: drug.onsetText, icon: "hare.fill")
                visualValue("Duration", value: drug.durationBand.rawValue, detail: drug.durationText, icon: "timer")
                visualValue("Prodrug", value: drug.prodrugStatus.rawValue, detail: "", icon: "arrow.triangle.2.circlepath")
                visualValue("Excretion", value: drug.excretionRoute.rawValue, detail: drug.excretionNotes, icon: "drop.triangle.fill")
            case .safety:
                if !drug.safetyFlags.isEmpty {
                    VStack(alignment: .leading, spacing: 7) {
                        Text("Safety flags").font(.subheadline.bold())
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 6) {
                                ForEach(drug.safetyFlags) { flag in
                                    Text(flag.rawValue)
                                        .font(.caption.weight(.semibold))
                                        .padding(.horizontal, 8).padding(.vertical, 5)
                                        .background(.orange.opacity(0.13), in: Capsule())
                                        .foregroundStyle(.orange)
                                }
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
            case .counseling:
                value("Counseling sentence", drug.counselingSentence)
                arabicValue("الإرشاد بالعربية", drug.arabicCounseling)
                value("Adverse effects", drug.commonSideEffects.joined(separator: "\n"))
                value("Patient questions", drug.patientQuestions.joined(separator: "\n"))
            case .notes:
                value("My notes", drug.notes)
                arabicValue("ملاحظاتي بالعربية", drug.arabicPersonalNotes)
            case .source:
                value("Imported source", drug.importedSourceName)
                value("Source notes", drug.sourceNote)
                if let url = URL(string: drug.sourceURL), !drug.sourceURL.isEmpty {
                    Link(destination: url) { Label("Open source", systemImage: "link") }
                }
            }
        }
    }

    private var sectionIcon: String {
        switch selectedSection {
        case .basics: "pills.fill"
        case .uses: "cross.case.fill"
        case .pk: "waveform.path.ecg"
        case .safety: "shield.fill"
        case .counseling: "quote.bubble.fill"
        case .notes: "note.text"
        case .source: "link"
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

    @ViewBuilder private func arabicValue(_ label: String, _ text: String) -> some View {
        if !text.trimmed.isEmpty {
            VStack(alignment: .trailing, spacing: 4) {
                Text(label).font(.caption.weight(.semibold)).foregroundStyle(.secondary)
                Text(text).frame(maxWidth: .infinity, alignment: .trailing)
            }
            .environment(\.layoutDirection, .rightToLeft)
        }
    }

    private func visualValue(_ title: String, value: String, detail: String, icon: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon).font(.title3).foregroundStyle(theme.tint).frame(width: 34, height: 34).background(theme.softTint, in: Circle())
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.caption).foregroundStyle(.secondary)
                Text(value).font(.subheadline.weight(.semibold))
                if !detail.trimmed.isEmpty { Text(detail).font(.caption).foregroundStyle(.secondary) }
            }
            Spacer()
        }
    }

    @ViewBuilder private func safetyValue(_ title: String, text: String, severity: String) -> some View {
        if !text.trimmed.isEmpty || severity != SafetySeverity.unknown.rawValue {
            VStack(alignment: .leading, spacing: 5) {
                HStack { Text(title).font(.subheadline.bold()); Spacer(); severityBadge(severity) }
                if !text.trimmed.isEmpty { Text(text).font(.subheadline) }
            }
            .padding(11)
            .background(severityColor(severity).opacity(0.09), in: RoundedRectangle(cornerRadius: 14))
        }
    }

    private func severityBadge(_ severity: String) -> some View {
        Text(severity).font(.caption2.bold()).padding(.horizontal, 7).padding(.vertical, 4).background(severityColor(severity).opacity(0.16), in: Capsule()).foregroundStyle(severityColor(severity))
    }

    private func severityColor(_ severity: String) -> Color {
        switch SafetySeverity(rawValue: severity) ?? .unknown {
        case .low: .green
        case .medium: .orange
        case .high: .red
        case .unknown: .secondary
        }
    }

    private var masteryCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("Drug Mastery", systemImage: "sparkles").font(.headline)
                Spacer()
                Text("\(drug.masteryCount)/6").font(.headline.monospacedDigit())
            }
            ProgressView(value: Double(drug.masteryCount), total: 6).tint(drug.isMastered ? .green : theme.tint)
            Text("Scientific • Trade • Class • Use • Warning • Counseling")
                .font(.caption).foregroundStyle(.secondary)
        }
        .padding(16)
        .background(theme.softTint, in: RoundedRectangle(cornerRadius: 20))
    }

    private var actions: some View {
        VStack(spacing: 10) {
            Button { showsReview = true } label: {
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
}
