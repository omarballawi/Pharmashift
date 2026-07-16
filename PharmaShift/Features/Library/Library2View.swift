import SwiftData
import SwiftUI

private enum LibraryScope: String, CaseIterable, Identifiable {
    case all = "All"
    case due = "Due"
    case needsAttention = "Needs attention"
    case noPhoto = "No photo"

    var id: String { rawValue }
}

private enum LibrarySort: String, CaseIterable, Identifiable {
    case name = "Name"
    case recent = "Recently added"
    case due = "Review date"
    case mastery = "Mastery"

    var id: String { rawValue }
}

struct LibraryView: View {
    @Environment(AppNavigation.self) private var navigation
    @Environment(AppTheme.self) private var theme
    @Query private var drugs: [Drug]
    @State private var searchText = ""
    @State private var scope: LibraryScope = .all
    @State private var sort: LibrarySort = .name
    @State private var deletionRequest: Drug?

    private var filteredDrugs: [Drug] {
        drugs
            .filter(matchesScope)
            .filter { searchText.trimmed.isEmpty || DrugFilter(searchText: searchText).matches($0) }
            .sorted(by: sortDrugs)
    }

    var body: some View {
        List {
            Section {
                LibrarySummaryRow(
                    profileCount: drugs.filter { !$0.isUnknown }.count,
                    brandCount: drugs.reduce(0) { $0 + $1.products.count },
                    dueCount: drugs.filter { $0.nextReviewDate <= .now }.count
                )
            }

            Section(filteredDrugs.isEmpty ? "" : resultTitle) {
                ForEach(filteredDrugs) { drug in
                    NavigationLink { DrugDetailView(drug: drug) } label: {
                        LibraryDrugRow(drug: drug)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) { deletionRequest = drug } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                    .contextMenu {
                        Button(role: .destructive) { deletionRequest = drug } label: {
                            Label("Delete drug profile", systemImage: "trash")
                        }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(theme.background)
        .overlay {
            if filteredDrugs.isEmpty {
                RenlystEmptyState(
                    imageName: "LibraryEmpty",
                    title: emptyTitle,
                    message: emptyMessage,
                    actionTitle: drugs.isEmpty ? "Add your first drug" : nil,
                    action: drugs.isEmpty ? { navigation.presentAdd() } : nil
                )
                .background(theme.background)
            }
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Drug, brand, class, note, Arabic")
        .searchScopes($scope) {
            ForEach(LibraryScope.allCases) { Text($0.rawValue).tag($0) }
        }
        .navigationTitle("Library")
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                NavigationLink { LibraryToolsView() } label: {
                    Label("Tools", systemImage: "square.grid.2x2")
                }
                Menu {
                    Picker("Sort", selection: $sort) {
                        ForEach(LibrarySort.allCases) { Text($0.rawValue).tag($0) }
                    }
                } label: {
                    Label("Sort", systemImage: "arrow.up.arrow.down")
                }
                Button {
                    navigation.presentAdd()
                } label: {
                    Label("Add", systemImage: "plus")
                }
                .accessibilityIdentifier("library.add")
            }
        }
        .sheet(item: $deletionRequest) { drug in
            DrugDeletionSheet(drug: drug)
        }
        .onAppear(perform: consumeRequestedChapter)
        .onChange(of: navigation.libraryChapter) { _, _ in consumeRequestedChapter() }
        .accessibilityIdentifier("library.dashboard")
    }

    private var resultTitle: String { "\(filteredDrugs.count) profile\(filteredDrugs.count == 1 ? "" : "s")" }
    private var emptyTitle: String { drugs.isEmpty ? "Build your working library" : "No matching profiles" }
    private var emptyMessage: String {
        drugs.isEmpty
            ? "Add one active ingredient, then attach every local brand and package photo to the same trusted profile."
            : "Try a different search or choose another scope."
    }

    private func matchesScope(_ drug: Drug) -> Bool {
        switch scope {
        case .all: true
        case .due: drug.nextReviewDate <= .now
        case .needsAttention: drug.isUnknown || drug.isIncomplete || drug.sourceNeedsReview || drug.confidenceLevel == .weak
        case .noPhoto: drug.packageImages.isEmpty
        }
    }

    private func sortDrugs(_ lhs: Drug, _ rhs: Drug) -> Bool {
        switch sort {
        case .name: lhs.displayName.localizedCaseInsensitiveCompare(rhs.displayName) == .orderedAscending
        case .recent: lhs.dateAdded > rhs.dateAdded
        case .due: lhs.nextReviewDate < rhs.nextReviewDate
        case .mastery:
            lhs.masteryCount == rhs.masteryCount
                ? lhs.displayName.localizedCaseInsensitiveCompare(rhs.displayName) == .orderedAscending
                : lhs.masteryCount < rhs.masteryCount
        }
    }

    private func consumeRequestedChapter() {
        guard let chapter = navigation.libraryChapter else { return }
        searchText = chapter.rawValue
        scope = .all
        navigation.libraryChapter = nil
    }
}

private struct LibrarySummaryRow: View {
    @Environment(AppTheme.self) private var theme
    let profileCount: Int
    let brandCount: Int
    let dueCount: Int

    var body: some View {
        ViewThatFits(in: .horizontal) {
            HStack(spacing: 0) {
                summary(value: profileCount, label: "Drugs")
                Divider().frame(height: 34)
                summary(value: brandCount, label: "Brands")
                Divider().frame(height: 34)
                summary(value: dueCount, label: "Due")
            }
            VStack(spacing: 10) {
                summary(value: profileCount, label: "Drugs")
                summary(value: brandCount, label: "Brands")
                summary(value: dueCount, label: "Due")
            }
        }
        .padding(.vertical, 7)
        .accessibilityElement(children: .combine)
    }

    private func summary(value: Int, label: String) -> some View {
        VStack(spacing: 2) {
            Text(value.formatted()).font(.headline.monospacedDigit()).foregroundStyle(theme.ink)
            Text(label).font(.caption).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct LibraryDrugRow: View {
    @Environment(AppTheme.self) private var theme
    let drug: Drug

    var body: some View {
        HStack(spacing: 13) {
            ProductPhoto(data: drug.packageThumbnails.first, size: 58)
            VStack(alignment: .leading, spacing: 4) {
                Text(drug.displayName).font(.headline).lineLimit(1)
                Text(drug.effectiveTradeNames.prefix(2).joined(separator: " · "))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                HStack(spacing: 7) {
                    Label(drug.chapter.rawValue, systemImage: drug.chapter.icon)
                    Text("\(drug.masteryCount)/6")
                }
                .font(.caption)
                .foregroundStyle(drug.nextReviewDate <= .now ? theme.coral : .secondary)
            }
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(drug.displayName), \(drug.effectiveTradeNames.joined(separator: ", ")), mastery \(drug.masteryCount) of 6")
    }
}

struct DrugDeletionSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Environment(AppTheme.self) private var theme
    let drug: Drug
    let onDeleted: () -> Void
    @State private var policy: DrugDeletionHistoryPolicy = .keepHistory
    @State private var impact: DrugDeletionImpact?
    @State private var errorMessage: String?
    @State private var isDeleting = false

    init(drug: Drug, onDeleted: @escaping () -> Void = {}) {
        self.drug = drug
        self.onDeleted = onDeleted
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack(spacing: 13) {
                        ProductPhoto(data: drug.packageThumbnails.first, size: 60)
                        VStack(alignment: .leading, spacing: 3) {
                            Text(drug.displayName).font(.headline)
                            Text("Delete this entire active-drug profile").font(.subheadline).foregroundStyle(.secondary)
                        }
                    }
                }
                Section("Learning history") {
                    Picker("After deletion", selection: $policy) {
                        Text("Keep history").tag(DrugDeletionHistoryPolicy.keepHistory)
                        Text("Erase history").tag(DrugDeletionHistoryPolicy.eraseHistory)
                    }
                    .pickerStyle(.segmented)
                    Text(historyExplanation).font(.footnote).foregroundStyle(.secondary)
                }
                if let impact {
                    Section("What will change") {
                        LabeledContent("Brands removed", value: impact.brandCount.formatted())
                        LabeledContent("Relationships removed", value: impact.relationshipCount.formatted())
                        LabeledContent(policy == .keepHistory ? "Review snapshots kept" : "Reviews erased", value: impact.reviewCount.formatted())
                        LabeledContent(policy == .keepHistory ? "Encounter snapshots kept" : "Encounters erased", value: impact.encounterCount.formatted())
                    }
                } else {
                    Section("What will change") {
                        ProgressView("Calculating impact…")
                    }
                }
                Section {
                    Button(role: .destructive, action: deleteProfile) {
                        Label(isDeleting ? "Deleting…" : "Delete drug profile", systemImage: "trash")
                            .frame(maxWidth: .infinity, minHeight: 44)
                    }
                    .disabled(isDeleting || impact == nil)
                    .accessibilityIdentifier("drug.deleteConfirm")
                }
            }
            .scrollContentBackground(.hidden)
            .background(theme.background)
            .navigationTitle("Delete profile?")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
            }
            .task { loadImpact() }
            .alert("Couldn’t delete profile", isPresented: Binding(get: { errorMessage != nil }, set: { if !$0 { errorMessage = nil } })) {
                Button("OK", role: .cancel) {}
            } message: { Text(errorMessage ?? "") }
        }
    }

    private var historyExplanation: String {
        policy == .keepHistory
            ? "Recommended. Review and encounter entries remain as dated snapshots, but no longer link to a live profile."
            : "Review and encounter entries linked to this drug are permanently removed."
    }

    private func loadImpact() {
        do { impact = try DrugLibraryMutationService.impact(of: drug, context: context) }
        catch { errorMessage = error.localizedDescription }
    }

    private func deleteProfile() {
        isDeleting = true
        do {
            try DrugLibraryMutationService.delete(drug, historyPolicy: policy, context: context)
            onDeleted()
            dismiss()
        } catch {
            isDeleting = false
            errorMessage = error.localizedDescription
        }
    }
}

struct LibraryToolsView: View {
    @Environment(AppTheme.self) private var theme

    var body: some View {
        List {
            Section("Understand your library") {
                NavigationLink { LibraryKnowledgeMapView() } label: {
                    Label("Knowledge map", systemImage: "point.3.connected.trianglepath.dotted")
                }
                NavigationLink { LibraryCompareView() } label: {
                    Label("Compare two drugs", systemImage: "rectangle.split.2x1")
                }
                NavigationLink { ShelfQuestChaptersView() } label: {
                    Label("Shelf quest", systemImage: "shippingbox.and.arrow.backward")
                }
            }
            Section("Import & generation") {
                NavigationLink { DrugImportView() } label: {
                    Label("Trusted-source import", systemImage: "text.magnifyingglass")
                }
                NavigationLink { DrugImportView(startsInAIMode: true) } label: {
                    Label("Experimental AI profile", systemImage: "wand.and.stars")
                }
            }
            Section {
                Text("Manual brand entry is intentionally inside each drug profile so it can inherit the active ingredients without calling an AI service.")
                    .font(.footnote).foregroundStyle(.secondary)
            }
        }
        .scrollContentBackground(.hidden)
        .background(theme.background)
        .navigationTitle("Library tools")
    }
}

private struct ShelfQuestChaptersView: View {
    @Environment(AppTheme.self) private var theme

    var body: some View {
        List(Chapter.allCases) { chapter in
            NavigationLink { ShelfQuestView(chapter: chapter) } label: {
                Label(chapter.rawValue, systemImage: chapter.icon)
            }
        }
        .scrollContentBackground(.hidden)
        .background(theme.background)
        .navigationTitle("Shelf quest")
    }
}

private struct LibraryKnowledgeMapView: View {
    @Environment(AppTheme.self) private var theme
    @Query private var drugs: [Drug]

    var body: some View {
        List {
            ForEach(Chapter.allCases) { chapter in
                let chapterDrugs = drugs.filter { $0.chapter == chapter }
                if !chapterDrugs.isEmpty {
                    Section {
                        ForEach(chapterDrugs.sorted { $0.displayName < $1.displayName }) { drug in
                            NavigationLink { DrugDetailView(drug: drug) } label: {
                                HStack {
                                    ProductPhoto(data: drug.packageThumbnails.first, size: 42)
                                    Text(drug.displayName)
                                    Spacer()
                                    Text("\(drug.masteryCount)/6").font(.caption.monospacedDigit()).foregroundStyle(.secondary)
                                }
                            }
                        }
                    } header: {
                        Label(chapter.rawValue, systemImage: chapter.icon)
                    }
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(theme.background)
        .navigationTitle("Knowledge map")
    }
}

private struct LibraryCompareView: View {
    @Environment(AppTheme.self) private var theme
    @Query(sort: \Drug.scientificName) private var drugs: [Drug]
    @State private var firstID: UUID?
    @State private var secondID: UUID?

    private var first: Drug? { drugs.first { $0.id == firstID } }
    private var second: Drug? { drugs.first { $0.id == secondID } }

    var body: some View {
        Form {
            Section("Choose profiles") {
                drugPicker("First drug", selection: $firstID)
                drugPicker("Second drug", selection: $secondID)
            }
            if let first, let second {
                Section("Active ingredients") { comparisonRow(first.ingredientNames.joined(separator: " + "), second.ingredientNames.joined(separator: " + ")) }
                Section("Class") { comparisonRow(first.drugClass, second.drugClass) }
                Section("Main use") { comparisonRow(first.indications.first ?? "Not recorded", second.indications.first ?? "Not recorded") }
                Section("Key warning") { comparisonRow(first.warnings.first ?? "Not recorded", second.warnings.first ?? "Not recorded") }
            } else {
                Section { Text("Choose two profiles to compare their saved facts side by side.").foregroundStyle(.secondary) }
            }
        }
        .scrollContentBackground(.hidden)
        .background(theme.background)
        .navigationTitle("Compare")
    }

    private func drugPicker(_ title: String, selection: Binding<UUID?>) -> some View {
        Picker(title, selection: selection) {
            Text("Choose").tag(UUID?.none)
            ForEach(drugs) { Text($0.displayName).tag(Optional($0.id)) }
        }
    }

    private func comparisonRow(_ first: String, _ second: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text(first.trimmed.isEmpty ? "Not recorded" : first).frame(maxWidth: .infinity, alignment: .leading)
            Divider()
            Text(second.trimmed.isEmpty ? "Not recorded" : second).frame(maxWidth: .infinity, alignment: .leading)
        }
        .font(.subheadline)
    }
}
