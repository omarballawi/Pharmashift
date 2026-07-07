import SwiftData
import SwiftUI

struct DrugDetailView: View {
    @Environment(\.modelContext) private var context
    @Environment(AppTheme.self) private var theme
    let drug: Drug
    @State private var showsEditor = false
    @State private var showsReview = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                DrugPhotoView(data: drug.imageData)

                VStack(alignment: .leading, spacing: 6) {
                    HStack(alignment: .firstTextBaseline) {
                        Text(drug.displayName).font(.largeTitle.bold())
                        Spacer()
                        MasteryBadge(drug: drug)
                    }
                    Text(drug.tradeNames.joined(separator: ", ")).font(.title3).foregroundStyle(.secondary)
                    if drug.isUnknown { Label("Unknown — complete this card later", systemImage: "questionmark.circle.fill").foregroundStyle(.orange) }
                    if drug.starterSeedID != nil {
                        Label(drug.verificationStatus.rawValue, systemImage: drug.verificationStatus == .pharmacistVerified ? "checkmark.seal.fill" : "exclamationmark.shield.fill")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(drug.verificationStatus == .pharmacistVerified ? .green : .orange)
                    }
                }

                UrgentSafetyNotice(flags: drug.safetyFlags)
                detailCard
                masteryCard
                reviewCard
                actionCard
            }
            .padding()
        }
        .navigationTitle("Drug Card")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { Button("Edit") { showsEditor = true } }
        .sheet(isPresented: $showsEditor) { NavigationStack { DrugEditorView(drug: drug) } }
        .sheet(isPresented: $showsReview) { NavigationStack { PracticeSessionView(initialDrug: drug) } }
    }

    private var detailCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            LabeledValue(label: "Chapter", value: drug.chapterRaw)
            LabeledValue(label: "Class", value: drug.drugClass)
            LabeledValue(label: "Dosage forms", value: drug.dosageForms.joined(separator: ", "))
            LabeledValue(label: "Strengths", value: drug.strengths.joined(separator: ", "))
            LabeledValue(label: "Indications", value: drug.indications.joined(separator: "\n"))
            LabeledValue(label: "How to take", value: drug.howToTake)
            LabeledValue(label: "Food instruction", value: drug.foodInstruction)
            LabeledValue(label: "Common side effects", value: drug.commonSideEffects.joined(separator: "\n"))
            LabeledValue(label: "Warnings", value: drug.warnings.joined(separator: "\n"))
            LabeledValue(label: "Counseling sentence", value: drug.counselingSentence)
            LabeledValue(label: "Patient questions", value: drug.patientQuestions.joined(separator: "\n"))
            LabeledValue(label: "Shelf", value: drug.shelfLocation)
            LabeledValue(label: "My notes", value: drug.notes)
            LabeledValue(label: "Source", value: drug.sourceNote)
        }
        .padding(16)
        .background(.background, in: RoundedRectangle(cornerRadius: 18))
    }

    private var masteryCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Drug Mastery").font(.headline)
            masteryRow("Scientific name", drug.masteryScientificName)
            masteryRow("Trade name", drug.masteryTradeName)
            masteryRow("Class", drug.masteryClass)
            masteryRow("Use", drug.masteryUse)
            masteryRow("Warning", drug.masteryWarning)
            masteryRow("Counseling", drug.masteryCounseling)
            if drug.isMastered { Label("Mastered", systemImage: "checkmark.seal.fill").foregroundStyle(.green).font(.headline) }
        }
        .padding(16)
        .background(theme.softTint, in: RoundedRectangle(cornerRadius: 18))
    }

    private func masteryRow(_ title: String, _ complete: Bool) -> some View {
        Label(title, systemImage: complete ? "checkmark.circle.fill" : "circle")
            .foregroundStyle(complete ? .green : .secondary)
    }

    private var reviewCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Review history").font(.headline)
            Text("Seen \(drug.timesSeen) times")
            Text("Last reviewed: \(drug.lastReviewed?.formatted(date: .abbreviated, time: .omitted) ?? "Not yet")")
            Text("Next review: \(drug.nextReviewDate.formatted(date: .abbreviated, time: .omitted))")
            Text("Confidence: \(drug.confidenceLevel.rawValue)")
        }
        .font(.subheadline)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(.background, in: RoundedRectangle(cornerRadius: 18))
    }

    private var actionCard: some View {
        VStack(spacing: 10) {
            Button { drug.markSeen(); try? context.save() } label: { Label("I saw it today", systemImage: "eye.fill") }
                .buttonStyle(.borderedProminent).tint(theme.tint).frame(maxWidth: .infinity, minHeight: 48)
            Button { showsReview = true } label: { Label("Start review", systemImage: "brain.head.profile") }
                .buttonStyle(.bordered).frame(maxWidth: .infinity, minHeight: 48).disabled(drug.isUnknown)
            Button { drug.isConfusing.toggle(); try? context.save() } label: {
                Label(drug.isConfusing ? "Remove confusing mark" : "Mark as confusing", systemImage: "exclamationmark.bubble")
            }
            .frame(maxWidth: .infinity, minHeight: 48)
            Button { drug.recalculateConfidence(); try? context.save() } label: {
                Label(drug.isMastered ? "Mastered" : "Complete all 6 checks to master", systemImage: "checkmark.seal")
            }
            .frame(maxWidth: .infinity, minHeight: 48)
            .disabled(!drug.isMastered)
        }
    }
}
