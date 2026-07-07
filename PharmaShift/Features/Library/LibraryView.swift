import SwiftData
import SwiftUI

struct LibraryView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Drug.dateAdded, order: .reverse) private var drugs: [Drug]
    @State private var searchText = ""
    @State private var showsFilters = false
    @State private var chapterFilter = ""
    @State private var confidenceFilter = ""
    @State private var classFilter = ""
    @State private var shelfFilter = ""
    @State private var unknownOnly = false
    @State private var dueOnly = false
    @State private var masteredOnly = false
    @State private var message: String?
    @State private var asksVerification = false

    private var filteredDrugs: [Drug] {
        let filter = DrugFilter(
            searchText: searchText,
            chapter: chapterFilter,
            confidence: confidenceFilter,
            drugClass: classFilter,
            shelf: shelfFilter,
            unknownOnly: unknownOnly,
            dueOnly: dueOnly,
            masteredOnly: masteredOnly
        )
        return drugs.filter { filter.matches($0) }
    }

    var body: some View {
        Group {
            if drugs.isEmpty {
                EmptyStateView(icon: "books.vertical", title: "Your library is empty", message: "Capture a shelf drug or import the optional starter pack.")
            } else if filteredDrugs.isEmpty {
                EmptyStateView(icon: "line.3.horizontal.decrease.circle", title: "No matching drugs", message: "Try clearing search or filters.")
            } else {
                List(filteredDrugs) { drug in
                    NavigationLink {
                        DrugDetailView(drug: drug)
                    } label: {
                        DrugRow(drug: drug)
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Library")
        .searchable(text: $searchText, prompt: "Name, class, chapter, shelf")
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button { showsFilters = true } label: {
                    Label("Filters", systemImage: activeFilterCount == 0 ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
                }
                Menu {
                    Button("Import 12 example drugs") { importStarterPack() }
                    Button("Confirm pharmacist verification") { asksVerification = true }
                } label: { Label("Starter pack", systemImage: "shippingbox") }
            }
        }
        .sheet(isPresented: $showsFilters) {
            NavigationStack {
                LibraryFilterView(
                    chapter: $chapterFilter,
                    confidence: $confidenceFilter,
                    drugClass: $classFilter,
                    shelf: $shelfFilter,
                    unknownOnly: $unknownOnly,
                    dueOnly: $dueOnly,
                    masteredOnly: $masteredOnly
                )
            }
        }
        .confirmationDialog("Only confirm after a pharmacist has checked every imported example and its local trade name.", isPresented: $asksVerification, titleVisibility: .visible) {
            Button("A pharmacist verified the starter pack") { markVerified() }
            Button("Cancel", role: .cancel) {}
        }
        .alert("Starter pack", isPresented: Binding(get: { message != nil }, set: { if !$0 { message = nil } })) {
            Button("OK") { message = nil }
        } message: { Text(message ?? "") }
    }

    private var activeFilterCount: Int {
        [!chapterFilter.isEmpty, !confidenceFilter.isEmpty, !classFilter.isEmpty, !shelfFilter.isEmpty, unknownOnly, dueOnly, masteredOnly].filter { $0 }.count
    }

    private func importStarterPack() {
        do {
            let count = try StarterContent.importIfNeeded(into: context)
            message = count == 0 ? "The starter pack is already imported." : "Imported \(count) examples. They remain unverified until a pharmacist confirms them."
        } catch { message = error.localizedDescription }
    }

    private func markVerified() {
        do {
            try StarterContent.markImportedContentVerified(in: context)
            message = "Imported examples are now marked pharmacist verified."
        } catch { message = error.localizedDescription }
    }
}

private struct DrugRow: View {
    let drug: Drug

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(drug.displayName).font(.headline)
                    if drug.isUnknown { Image(systemName: "questionmark.circle.fill").foregroundStyle(.orange) }
                    if drug.isConfusing { Image(systemName: "exclamationmark.bubble.fill").foregroundStyle(.orange) }
                }
                Text(drug.firstTradeName).font(.subheadline).foregroundStyle(.secondary)
                Text([drug.chapterRaw, drug.drugClass].filter { !$0.isEmpty }.joined(separator: " • "))
                    .font(.caption).foregroundStyle(.secondary).lineLimit(1)
            }
            Spacer()
            MasteryBadge(drug: drug)
        }
        .padding(.vertical, 6)
        .contentShape(Rectangle())
    }
}

private struct LibraryFilterView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var chapter: String
    @Binding var confidence: String
    @Binding var drugClass: String
    @Binding var shelf: String
    @Binding var unknownOnly: Bool
    @Binding var dueOnly: Bool
    @Binding var masteredOnly: Bool

    var body: some View {
        Form {
            Section("Classification") {
                Picker("Chapter", selection: $chapter) {
                    Text("Any chapter").tag("")
                    ForEach(Chapter.allCases) { Text($0.rawValue).tag($0.rawValue) }
                }
                Picker("Confidence", selection: $confidence) {
                    Text("Any confidence").tag("")
                    ForEach(ConfidenceLevel.allCases) { Text($0.rawValue).tag($0.rawValue) }
                }
                TextField("Class contains", text: $drugClass)
                TextField("Shelf contains", text: $shelf)
            }
            Section("Status") {
                Toggle("Unknown drugs", isOn: $unknownOnly)
                Toggle("Due for review", isOn: $dueOnly)
                Toggle("Mastered drugs", isOn: $masteredOnly)
            }
            Section {
                Button("Clear all") {
                    chapter = ""; confidence = ""; drugClass = ""; shelf = ""
                    unknownOnly = false; dueOnly = false; masteredOnly = false
                }
            }
        }
        .navigationTitle("Filters")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { ToolbarItem(placement: .confirmationAction) { Button("Done") { dismiss() } } }
    }
}
