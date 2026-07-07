import SwiftData
import SwiftUI

struct DrugEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    let drug: Drug
    @State private var errorMessage: String?

    var body: some View {
        Form {
            Section("Identity") {
                Toggle("Unknown drug", isOn: binding(\.isUnknown))
                TextField("Capture label", text: binding(\.captureLabel))
                TextField("Scientific name", text: binding(\.scientificName)).autocorrectionDisabled()
                linesField("Trade names — one per line", keyPath: \.tradeNames)
                Picker("Chapter", selection: chapterBinding) { ForEach(Chapter.allCases) { Text($0.rawValue).tag($0) } }
                TextField("Class", text: binding(\.drugClass))
                TextField("Shelf location", text: binding(\.shelfLocation))
            }

            Section("Products") {
                linesField("Dosage forms — one per line", keyPath: \.dosageForms)
                linesField("Strengths — one per line", keyPath: \.strengths)
            }

            Section("Learning card") {
                linesField("Indications — one per line", keyPath: \.indications)
                TextField("How to take", text: binding(\.howToTake), axis: .vertical).lineLimit(2...5)
                TextField("Food instruction", text: binding(\.foodInstruction), axis: .vertical).lineLimit(2...5)
                linesField("Common side effects — one per line", keyPath: \.commonSideEffects)
                linesField("Warnings — one per line", keyPath: \.warnings)
                TextField("Counseling sentence", text: binding(\.counselingSentence), axis: .vertical).lineLimit(2...6)
                linesField("Patient questions — one per line", keyPath: \.patientQuestions)
                TextField("My notes (Arabic or English)", text: binding(\.notes), axis: .vertical)
                    .lineLimit(3...8)
            }

            Section("Safety — urgent pharmacist check") {
                ForEach(SafetyFlag.allCases) { flag in
                    Toggle(flag.rawValue, isOn: safetyBinding(flag))
                }
            }

            Section("Mastery checks") {
                Toggle("Scientific name", isOn: masteryBinding(\.masteryScientificName))
                Toggle("Trade name", isOn: masteryBinding(\.masteryTradeName))
                Toggle("Class", isOn: masteryBinding(\.masteryClass))
                Toggle("Use", isOn: masteryBinding(\.masteryUse))
                Toggle("Warning", isOn: masteryBinding(\.masteryWarning))
                Toggle("Counseling", isOn: masteryBinding(\.masteryCounseling))
            }
        }
        .navigationTitle("Edit Drug")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) { Button("Cancel") { context.rollback(); dismiss() } }
            ToolbarItem(placement: .confirmationAction) { Button("Save") { save() } }
        }
        .alert("Could not save", isPresented: Binding(get: { errorMessage != nil }, set: { if !$0 { errorMessage = nil } })) {
            Button("OK") { errorMessage = nil }
        } message: { Text(errorMessage ?? "") }
    }

    private func binding(_ keyPath: ReferenceWritableKeyPath<Drug, String>) -> Binding<String> {
        Binding(get: { drug[keyPath: keyPath] }, set: { drug[keyPath: keyPath] = $0 })
    }

    private func binding(_ keyPath: ReferenceWritableKeyPath<Drug, Bool>) -> Binding<Bool> {
        Binding(get: { drug[keyPath: keyPath] }, set: { drug[keyPath: keyPath] = $0 })
    }

    private var chapterBinding: Binding<Chapter> {
        Binding(get: { drug.chapter }, set: { drug.chapter = $0 })
    }

    private func linesField(_ title: String, keyPath: ReferenceWritableKeyPath<Drug, [String]>) -> some View {
        TextField(title, text: Binding(
            get: { drug[keyPath: keyPath].joined(separator: "\n") },
            set: { drug[keyPath: keyPath] = $0.splitLines }
        ), axis: .vertical).lineLimit(2...7)
    }

    private func safetyBinding(_ flag: SafetyFlag) -> Binding<Bool> {
        Binding(
            get: { drug.safetyFlags.contains(flag) },
            set: { enabled in
                var values = drug.safetyFlags
                if enabled { if !values.contains(flag) { values.append(flag) } }
                else { values.removeAll { $0 == flag } }
                drug.safetyFlags = values
            }
        )
    }

    private func masteryBinding(_ keyPath: ReferenceWritableKeyPath<Drug, Bool>) -> Binding<Bool> {
        Binding(get: { drug[keyPath: keyPath] }, set: { value in
            drug[keyPath: keyPath] = value
            drug.recalculateConfidence()
        })
    }

    private func save() {
        if drug.isUnknown == false && drug.scientificName.trimmed.isEmpty && drug.tradeNames.isEmpty {
            errorMessage = "Add a scientific or trade name, or keep this card marked Unknown."
            return
        }
        if !drug.scientificName.trimmed.isEmpty || !drug.tradeNames.isEmpty { drug.isUnknown = false }
        drug.recalculateConfidence()
        do { try context.save(); dismiss() } catch { errorMessage = error.localizedDescription }
    }
}
