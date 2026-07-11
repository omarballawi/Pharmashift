import SwiftData
import SwiftUI

struct ReportView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Drug.dateAdded) private var drugs: [Drug]
    @Query(sort: \ReviewLog.date) private var reviews: [ReviewLog]
    @Query(sort: \ShiftLog.date) private var shifts: [ShiftLog]
    @Query(sort: \EncounterNote.date) private var encounters: [EncounterNote]
    @Query(sort: \TrainingReport.updatedAt, order: .reverse) private var reports: [TrainingReport]
    @State private var periodStart = Calendar.current.date(byAdding: .month, value: -1, to: .now) ?? .now
    @State private var periodEnd = Date.now
    @State private var selectedReport: TrainingReport?

    private var mastered: [Drug] { drugs.filter(\.isMastered) }
    private var weak: [Drug] { drugs.filter { $0.confidenceLevel == .weak || $0.isConfusing } }
    private var completedShifts: [ShiftLog] { shifts.filter(\.isCompleted) }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    MetricCard(title: "Total drugs", value: "\(drugs.count)", icon: "pills.fill")
                    MetricCard(title: "Mastered", value: "\(mastered.count)", icon: "checkmark.seal.fill")
                    MetricCard(title: "Weak", value: "\(weak.count)", icon: "bolt.heart")
                    MetricCard(title: "Reviews", value: "\(reviews.count)", icon: "brain.head.profile")
                    MetricCard(title: "Shifts", value: "\(completedShifts.count)", icon: "clock.badge.checkmark")
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Weakness radar").font(.title3.bold())
                    Text("A lower axis means that mastery area needs more practice.").font(.caption).foregroundStyle(.secondary)
                    WeaknessRadarView(values: masteryValues)
                        .frame(height: 280)
                }
                .padding(16)
                .background(.background, in: RoundedRectangle(cornerRadius: 18))

                breakdown(title: "Drugs by chapter", values: drugs.map(\.chapterRaw))
                breakdown(title: "Drugs by class", values: drugs.map(\.drugClass).filter { !$0.isEmpty })

                VStack(alignment: .leading, spacing: 12) {
                    Text("Final training report").font(.title3.bold())
                    DatePicker("From", selection: $periodStart, displayedComponents: .date)
                    DatePicker("To", selection: $periodEnd, in: periodStart..., displayedComponents: .date)
                    Button { generateReport() } label: {
                        Label("Generate editable report", systemImage: "doc.badge.gearshape")
                            .frame(maxWidth: .infinity, minHeight: 48)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(periodEnd < periodStart)
                    if let latest = reports.first {
                        Button { selectedReport = latest } label: {
                            Label("Open latest report", systemImage: "doc.text")
                                .frame(maxWidth: .infinity, minHeight: 48)
                        }
                        .buttonStyle(.bordered)
                    }
                }
                .padding(16)
                .background(.background, in: RoundedRectangle(cornerRadius: 18))
            }
            .padding()
        }
        .navigationTitle("Report")
        .sheet(item: $selectedReport) { report in
            NavigationStack { ReportEditorView(report: report) }
        }
    }

    private var masteryValues: [Double] {
        guard !drugs.isEmpty else { return Array(repeating: 0, count: 6) }
        let checks: [[Bool]] = [
            drugs.map(\.masteryScientificName), drugs.map(\.masteryTradeName), drugs.map(\.masteryClass),
            drugs.map(\.masteryUse), drugs.map(\.masteryWarning), drugs.map(\.masteryCounseling)
        ]
        return checks.map { Double($0.filter { $0 }.count) / Double(drugs.count) }
    }

    private func breakdown(title: String, values: [String]) -> some View {
        let counts = Dictionary(grouping: values, by: { $0 }).mapValues(\.count).sorted { $0.value > $1.value }
        return VStack(alignment: .leading, spacing: 10) {
            Text(title).font(.title3.bold())
            if counts.isEmpty { Text("No data yet").foregroundStyle(.secondary) }
            ForEach(counts, id: \.key) { entry in
                HStack { Text(entry.key); Spacer(); Text("\(entry.value)").monospacedDigit().foregroundStyle(.secondary) }
                Divider()
            }
        }
        .padding(16)
        .background(.background, in: RoundedRectangle(cornerRadius: 18))
    }

    private func generateReport() {
        let report = TrainingReport(periodStart: periodStart, periodEnd: periodEnd)
        ReportBuilder.populate(report, drugs: drugs, reviews: reviews, shifts: shifts, encounters: encounters)
        context.insert(report)
        try? context.save()
        selectedReport = report
    }
}

struct WeaknessRadarView: View {
    let values: [Double]
    private let labels = ["Scientific", "Trade", "Class", "Use", "Warning", "Counsel"]

    var body: some View {
        Canvas { context, size in
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            let radius = min(size.width, size.height) * 0.34
            func point(index: Int, scale: Double) -> CGPoint {
                let angle = -Double.pi / 2 + Double(index) * 2 * Double.pi / 6
                return CGPoint(x: center.x + cos(angle) * radius * scale, y: center.y + sin(angle) * radius * scale)
            }

            for level in 1...4 {
                var grid = Path()
                for index in 0..<6 {
                    let p = point(index: index, scale: Double(level) / 4)
                    index == 0 ? grid.move(to: p) : grid.addLine(to: p)
                }
                grid.closeSubpath()
                context.stroke(grid, with: .color(.secondary.opacity(0.22)), lineWidth: 1)
            }

            for index in 0..<6 {
                var spoke = Path()
                spoke.move(to: center)
                spoke.addLine(to: point(index: index, scale: 1))
                context.stroke(spoke, with: .color(.secondary.opacity(0.22)), lineWidth: 1)
            }

            var data = Path()
            for index in 0..<6 {
                let value = values.indices.contains(index) ? values[index] : 0
                let p = point(index: index, scale: value)
                index == 0 ? data.move(to: p) : data.addLine(to: p)
            }
            data.closeSubpath()
            context.fill(data, with: .color(.teal.opacity(0.25)))
            context.stroke(data, with: .color(.teal), lineWidth: 3)

            for index in 0..<6 {
                let p = point(index: index, scale: 1.25)
                let text = context.resolve(Text(labels[index]).font(.caption2.weight(.semibold)))
                context.draw(text, at: p, anchor: .center)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Mastery radar: " + zip(labels, values).map { pair in "\(pair.0) \(Int(pair.1 * 100)) percent" }.joined(separator: ", "))
    }
}

private struct ReportEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    let report: TrainingReport

    var body: some View {
        Form {
            Section("Training period") {
                DatePicker("From", selection: dateBinding(\.periodStart), displayedComponents: .date)
                DatePicker("To", selection: dateBinding(\.periodEnd), displayedComponents: .date)
            }
            reportSection("Training period summary", \.trainingSummary)
            reportSection("Skills learned", \.skillsLearned)
            reportSection("Drug categories studied", \.categoriesStudied)
            reportSection("Common dosage forms seen", \.dosageFormsSeen)
            reportSection("Important counseling points", \.counselingPoints)
            reportSection("Pharmacist questions asked", \.pharmacistQuestions)
            reportSection("Challenges faced", \.challenges)
            reportSection("Notes and recommendations", \.notesAndRecommendations)
            reportSection("Mastered drugs by chapter", \.masteredDrugs)
            Section {
                ShareLink(item: ReportFile(text: ReportBuilder.text(for: report)), preview: SharePreview("Renlyst Training Report")) {
                    Label("Export UTF-8 text file", systemImage: "square.and.arrow.up")
                        .frame(maxWidth: .infinity, minHeight: 48)
                }
            }
        }
        .navigationTitle("Training Report")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { ToolbarItem(placement: .confirmationAction) { Button("Done") { saveAndDismiss() } } }
    }

    private func reportSection(_ title: String, _ keyPath: ReferenceWritableKeyPath<TrainingReport, String>) -> some View {
        Section(title) {
            TextEditor(text: Binding(get: { report[keyPath: keyPath] }, set: { report[keyPath: keyPath] = $0; report.updatedAt = .now }))
                .frame(minHeight: 110)
        }
    }

    private func dateBinding(_ keyPath: ReferenceWritableKeyPath<TrainingReport, Date>) -> Binding<Date> {
        Binding(get: { report[keyPath: keyPath] }, set: { report[keyPath: keyPath] = $0; report.updatedAt = .now })
    }

    private func saveAndDismiss() { try? context.save(); dismiss() }
}
