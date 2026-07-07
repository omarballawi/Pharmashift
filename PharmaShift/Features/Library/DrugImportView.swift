import SwiftUI

struct DrugImportView: View {
    @Environment(\.dismiss) private var dismiss
    let drug: Drug
    let provider: any DrugInfoProvider
    @State private var query: String
    @State private var results: [DrugSearchResult] = []
    @State private var selectedResult: DrugSearchResult?
    @State private var importedInfo: ImportedDrugInfo?
    @State private var selection = ImportSelection(fields: [])
    @State private var isLoading = false
    @State private var errorMessage: String?

    init(drug: Drug, provider: any DrugInfoProvider) {
        self.drug = drug
        self.provider = provider
        _query = State(initialValue: drug.scientificName)
    }

    var body: some View {
        Group {
            if let importedInfo { preview(importedInfo) }
            else { searchContent }
        }
        .navigationTitle("Import from DailyMed")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } } }
        .overlay {
            if isLoading {
                Label("Loading official label…", systemImage: "hourglass")
                    .padding()
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 14))
                    .accessibilityIdentifier("import.loading")
            }
        }
        .disabled(isLoading)
        .alert("Import error", isPresented: Binding(get: { errorMessage != nil }, set: { if !$0 { errorMessage = nil } })) {
            Button("OK") { errorMessage = nil }
        } message: { Text(errorMessage ?? "") }
    }

    private var searchContent: some View {
        List {
            Section {
                TextField("Scientific name", text: $query)
                    .textInputAutocapitalization(.never).autocorrectionDisabled()
                    .accessibilityIdentifier("import.query")
                Button { search() } label: { Label("Search DailyMed", systemImage: "magnifyingglass") }
                    .buttonStyle(.borderedProminent).disabled(query.trimmed.isEmpty)
                    .accessibilityIdentifier("import.search")
            } footer: {
                Text("Searches official U.S. labels. Imported values remain editable and do not replace photos, mastery, personal notes, or Arabic fields.")
            }
            if results.isEmpty {
                Section { Text("Enter a scientific name to find current label formulations.").foregroundStyle(.secondary) }
            } else {
                Section("Choose a formulation") {
                    ForEach(results) { result in
                        Button { load(result) } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(result.genericName).font(.headline).foregroundStyle(.primary)
                                Text(result.labelTitle).font(.caption).foregroundStyle(.secondary).lineLimit(2)
                                HStack {
                                    if !result.formulation.isEmpty { Text(result.formulation) }
                                    if let date = result.updateDate { Text(date.formatted(date: .abbreviated, time: .omitted)) }
                                }
                                .font(.caption2).foregroundStyle(.secondary)
                            }
                        }
                        .accessibilityIdentifier("import.result.\(result.labelID)")
                    }
                }
            }
        }
        .accessibilityIdentifier("import.searchScreen")
    }

    private func preview(_ info: ImportedDrugInfo) -> some View {
        List {
            if let selectedResult {
                Section("Official label") {
                    Text(selectedResult.labelTitle).font(.subheadline.weight(.semibold))
                    Link(destination: info.sourceURL) { Label("Open DailyMed label", systemImage: "link") }
                }
            }
            Section("Select fields to apply") {
                ForEach(ImportField.allCases.filter { info.displayValue(for: $0)?.trimmed.isEmpty == false }) { field in
                    Toggle(isOn: fieldBinding(field)) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(field.rawValue).font(.subheadline.weight(.semibold))
                            let current = DrugImportApplier.currentValue(for: field, drug: drug)
                            if !current.trimmed.isEmpty {
                                Text("Current: \(current)").font(.caption).foregroundStyle(.secondary).lineLimit(2)
                            }
                            Text("DailyMed: \(info.displayValue(for: field) ?? "")").font(.caption).lineLimit(4)
                        }
                    }
                    .accessibilityIdentifier("import.field.\(field.id)")
                }
            }
            Section {
                Button { apply(info) } label: {
                    Label("Apply selected fields", systemImage: "checkmark.circle.fill").frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent).disabled(selection.fields.isEmpty)
                .accessibilityIdentifier("import.apply")
            } footer: {
                Text("Existing values are never selected automatically. Uncertain or missing PK measurements remain unknown.")
            }
        }
        .accessibilityIdentifier("import.preview")
    }

    private func fieldBinding(_ field: ImportField) -> Binding<Bool> {
        Binding(
            get: { selection.fields.contains(field) },
            set: { enabled in
                if enabled { selection.fields.insert(field) } else { selection.fields.remove(field) }
            }
        )
    }

    private func search() {
        isLoading = true
        Task {
            do {
                let found = try await provider.searchDrug(query: query)
                await MainActor.run {
                    results = found
                    isLoading = false
                    let normalized = query.trimmed.folding(options: [.caseInsensitive, .diacriticInsensitive], locale: .current)
                    let exact = found.filter { $0.genericName.trimmed.folding(options: [.caseInsensitive, .diacriticInsensitive], locale: .current) == normalized }
                    if exact.count == 1 { load(exact[0]) }
                }
            } catch {
                await MainActor.run { errorMessage = error.localizedDescription; isLoading = false }
            }
        }
    }

    private func load(_ result: DrugSearchResult) {
        selectedResult = result
        isLoading = true
        Task {
            do {
                let info = try await provider.fetchDrugDetails(id: result.labelID)
                await MainActor.run {
                    importedInfo = info
                    selection = DrugImportApplier.defaultSelection(info: info, drug: drug)
                    isLoading = false
                }
            } catch {
                await MainActor.run { errorMessage = error.localizedDescription; isLoading = false }
            }
        }
    }

    private func apply(_ info: ImportedDrugInfo) {
        DrugImportApplier.apply(info, selection: selection, to: drug)
        dismiss()
    }
}
