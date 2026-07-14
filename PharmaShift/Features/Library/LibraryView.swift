import SwiftData
import SwiftUI

private enum LibrarySection: String, CaseIterable, Identifiable {
    case cards = "Cards"
    case graph = "Graph"
    case compare = "Compare"
    var id: String { rawValue }
}

struct LibraryView: View {
    @Environment(\.modelContext) private var context
    @Environment(AppNavigation.self) private var navigation
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
    @State private var weakOnly = false
    @State private var incompleteOnly = false
    @State private var missingImageOnly = false
    @State private var importedOnly = false
    @State private var message: String?
    @State private var asksVerification = false
    @State private var section: LibrarySection = .cards
    @State private var isRefreshingLinks = false

    private var filteredDrugs: [Drug] {
        let filter = DrugFilter(
            searchText: searchText,
            chapter: chapterFilter,
            confidence: confidenceFilter,
            drugClass: classFilter,
            shelf: shelfFilter,
            unknownOnly: unknownOnly,
            dueOnly: dueOnly,
            masteredOnly: masteredOnly,
            weakOnly: weakOnly,
            incompleteOnly: incompleteOnly,
            missingImageOnly: missingImageOnly,
            importedOnly: importedOnly
        )
        return drugs.filter { filter.matches($0) }
    }

    var body: some View {
        VStack(spacing: 0) {
            Picker("Library view", selection: $section) {
                ForEach(LibrarySection.allCases) { Text($0.rawValue).tag($0) }
            }
            .pickerStyle(.segmented).padding(.horizontal).padding(.bottom, 8)

            Group {
                switch section {
                case .cards:
                    if drugs.isEmpty {
                        EmptyStateView(icon: "books.vertical", title: "Your library is empty", message: "Capture a shelf drug or import the optional starter pack.")
                    } else if filteredDrugs.isEmpty {
                        EmptyStateView(icon: "line.3.horizontal.decrease.circle", title: "No matching drugs", message: "Try clearing search or filters.")
                    } else {
                        List(filteredDrugs) { drug in
                            NavigationLink { DrugDetailView(drug: drug) } label: { DrugRow(drug: drug) }
                        }
                        .listStyle(.plain)
                    }
                case .graph:
                    KnowledgeGraphView(drugs: filteredDrugs)
                case .compare:
                    CompareCanvasView(drugs: drugs.filter { !$0.isUnknown })
                }
            }
        }
        .navigationTitle("Library")
        .searchable(text: $searchText, prompt: "Name, class, system, notes, Arabic")
        .task(id: drugs.count) { backfillThumbnails() }
        .onAppear { applyRequestedChapter() }
        .onChange(of: navigation.libraryChapter) { _, _ in applyRequestedChapter() }
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button { refreshLinks() } label: {
                    Label(isRefreshingLinks ? "Refreshing links" : "Refresh drug links", systemImage: "arrow.triangle.2.circlepath")
                }
                .disabled(isRefreshingLinks || drugs.count < 2)
                Button { showsFilters = true } label: {
                    Label("Filters", systemImage: activeFilterCount == 0 ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
                }
                Menu {
                    Button("Import 12 example drugs") { importStarterPack() }
                    Button("Confirm pharmacist verification") { asksVerification = true }
                } label: { Label("Starter pack", systemImage: "shippingbox") }
            }
        }
        .onChange(of: section) { _, newValue in
            if newValue != .cards { showsFilters = false }
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
                    masteredOnly: $masteredOnly,
                    weakOnly: $weakOnly,
                    incompleteOnly: $incompleteOnly,
                    missingImageOnly: $missingImageOnly,
                    importedOnly: $importedOnly
                )
            }
        }
        .confirmationDialog("Only confirm after a pharmacist has checked every imported example and its local trade name.", isPresented: $asksVerification, titleVisibility: .visible) {
            Button("A pharmacist verified the starter pack") { markVerified() }
            Button("Cancel", role: .cancel) {}
        }
        .alert("Library", isPresented: Binding(get: { message != nil }, set: { if !$0 { message = nil } })) {
            Button("OK") { message = nil }
        } message: { Text(message ?? "") }
    }

    private var activeFilterCount: Int {
        [!chapterFilter.isEmpty, !confidenceFilter.isEmpty, !classFilter.isEmpty, !shelfFilter.isEmpty, unknownOnly, dueOnly, masteredOnly, weakOnly, incompleteOnly, missingImageOnly, importedOnly].filter { $0 }.count
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

    private func refreshLinks() {
        isRefreshingLinks = true
        Task {
            do {
                let count = try await DrugRelationshipRefreshService.refresh(drugs: drugs, context: context)
                await MainActor.run { message = count == 0 ? "No sourced interactions between saved ingredients were found." : "Updated \(count) sourced drug link(s)."; isRefreshingLinks = false }
            } catch {
                await MainActor.run { message = error.localizedDescription; isRefreshingLinks = false }
            }
        }
    }

    private func applyRequestedChapter() {
        guard let chapter = navigation.libraryChapter else { return }
        chapterFilter = chapter.rawValue
        navigation.libraryChapter = nil
    }

    private func backfillThumbnails() {
        var changed = false
        for drug in drugs where drug.thumbnailData == nil {
            guard let data = drug.imageData,
                  let image = try? ImageCompressor.image(from: data),
                  let payload = try? ImageCompressor.payload(from: image) else { continue }
            drug.thumbnailData = payload.thumbnailData
            changed = true
        }
        if changed { try? context.save() }
    }
}

private struct DrugRow: View {
    @Environment(ReviewScheduler.self) private var scheduler
    let drug: Drug

    var body: some View {
        HStack(spacing: 12) {
            DrugThumbnailView(drug: drug, size: 68)
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(drug.displayName).font(.headline)
                    if drug.isUnknown { Image(systemName: "questionmark.circle.fill").foregroundStyle(.orange) }
                    if drug.isConfusing { Image(systemName: "exclamationmark.bubble.fill").foregroundStyle(.orange) }
                }
                Text(drug.firstTradeName).font(.subheadline).foregroundStyle(.secondary)
                Text([drug.chapterRaw, drug.drugClass].filter { !$0.isEmpty }.joined(separator: " • "))
                    .font(.caption).foregroundStyle(.secondary).lineLimit(1)
                HStack(spacing: 5) {
                    if let form = drug.dosageForms.first { miniBadge(form) }
                    if let strength = drug.strengths.first { miniBadge(strength) }
                    if scheduler.isDue(drug) { Image(systemName: "calendar.badge.clock").foregroundStyle(.orange) }
                }
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 6) {
                MasteryBadge(drug: drug)
                Text(drug.confidenceLevel.rawValue)
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(drug.isMastered ? .green : .secondary)
            }
        }
        .padding(.vertical, 6)
        .contentShape(Rectangle())
    }

    private func miniBadge(_ value: String) -> some View {
        Text(value)
            .font(.caption2.weight(.semibold))
            .lineLimit(1)
            .padding(.horizontal, 6)
            .padding(.vertical, 3)
            .background(.secondary.opacity(0.1), in: Capsule())
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
    @Binding var weakOnly: Bool
    @Binding var incompleteOnly: Bool
    @Binding var missingImageOnly: Bool
    @Binding var importedOnly: Bool

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
                Toggle("Weak or confusing", isOn: $weakOnly)
                Toggle("Unknown or incomplete", isOn: $incompleteOnly)
                Toggle("Missing photo", isOn: $missingImageOnly)
                Toggle("Imported source", isOn: $importedOnly)
            }
            Section {
                Button("Clear all") {
                    chapter = ""; confidence = ""; drugClass = ""; shelf = ""
                    unknownOnly = false; dueOnly = false; masteredOnly = false
                    weakOnly = false; incompleteOnly = false; missingImageOnly = false; importedOnly = false
                }
            }
        }
        .navigationTitle("Filters")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { ToolbarItem(placement: .confirmationAction) { Button("Done") { dismiss() } } }
    }
}

private struct KnowledgeGraphView: View {
    @Environment(AppTheme.self) private var theme
    let drugs: [Drug]
    @State private var selectedChapter: Chapter?

    private var visibleDrugs: [Drug] {
        Array(drugs.filter { selectedChapter == nil || $0.chapter == selectedChapter }.prefix(12))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text("Knowledge Graph").font(.title2.bold())
                Text("See how drugs connect through systems and classes. Tap any node to open its card.")
                    .font(.subheadline).foregroundStyle(.secondary)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 7) {
                        graphFilter("All", chapter: nil)
                        ForEach(Chapter.allCases.filter { chapter in drugs.contains { $0.chapter == chapter } }) { chapter in
                            graphFilter(chapter.rawValue, chapter: chapter)
                        }
                    }
                }
                if visibleDrugs.isEmpty {
                    EmptyStateView(icon: "point.3.connected.trianglepath.dotted", title: "No connections yet", message: "Add drug cards to grow your knowledge graph.")
                } else {
                    GeometryReader { proxy in
                        let center = CGPoint(x: proxy.size.width / 2, y: proxy.size.height / 2)
                        ZStack {
                            Canvas { context, _ in
                                for index in visibleDrugs.indices {
                                    var path = Path()
                                    path.move(to: center)
                                    path.addLine(to: position(index, count: visibleDrugs.count, size: proxy.size))
                                    context.stroke(path, with: .color(theme.tint.opacity(0.26)), lineWidth: 1.5)
                                }
                            }
                            Text(selectedChapter?.rawValue ?? "My Library")
                                .font(.caption.bold()).foregroundStyle(.white).lineLimit(2).multilineTextAlignment(.center)
                                .frame(width: 90, height: 90).background(theme.crystalGradient, in: Circle())
                                .position(center)
                            ForEach(Array(visibleDrugs.enumerated()), id: \.element.id) { index, drug in
                                NavigationLink { DrugDetailView(drug: drug) } label: {
                                    VStack(spacing: 3) {
                                        Image(systemName: drug.chapter.icon).font(.caption)
                                        Text(drug.displayName).font(.caption2.bold()).lineLimit(2).multilineTextAlignment(.center)
                                    }
                                    .foregroundStyle(.primary).frame(width: 88).frame(minHeight: 58)
                                    .padding(.vertical, 6).background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                                    .overlay(RoundedRectangle(cornerRadius: 16).stroke((theme.colors(for: drug.chapter).first ?? theme.tint).opacity(0.35)))
                                }
                                .buttonStyle(.plain)
                                .position(position(index, count: visibleDrugs.count, size: proxy.size))
                            }
                        }
                    }
                    .frame(height: 510)
                    .accessibilityElement(children: .contain)
                    .accessibilityLabel("Local knowledge graph with \(visibleDrugs.count) drug nodes")
                }
                Text("Showing up to 12 nearby nodes for clarity.").font(.caption).foregroundStyle(.secondary)
            }
            .padding()
        }
    }

    private func graphFilter(_ label: String, chapter: Chapter?) -> some View {
        Button { withAnimation(.snappy) { selectedChapter = chapter } } label: {
            Text(label).font(.caption.weight(.semibold)).padding(.horizontal, 11).frame(minHeight: 38)
                .background(selectedChapter == chapter ? theme.tint : Color.secondary.opacity(0.10), in: Capsule())
                .foregroundStyle(selectedChapter == chapter ? .white : .primary)
        }
        .buttonStyle(.plain)
    }

    private func position(_ index: Int, count: Int, size: CGSize) -> CGPoint {
        let angle = (Double(index) / Double(max(count, 1))) * .pi * 2 - .pi / 2
        let xRadius = max(105, size.width / 2 - 52)
        let yRadius = max(150, size.height / 2 - 48)
        return CGPoint(x: size.width / 2 + CGFloat(cos(angle)) * xRadius, y: size.height / 2 + CGFloat(sin(angle)) * yRadius)
    }
}

private struct CompareCanvasView: View {
    let drugs: [Drug]
    @State private var firstID: UUID?
    @State private var secondID: UUID?

    private var first: Drug? { drugs.first { $0.id == firstID } }
    private var second: Drug? { drugs.first { $0.id == secondID } }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Compare Canvas").font(.title2.bold())
                Text("Place two drugs side by side and compare the facts that matter in practice.")
                    .font(.subheadline).foregroundStyle(.secondary)
                HStack(spacing: 10) {
                    drugPicker("First drug", selection: $firstID)
                    Image(systemName: "arrow.left.arrow.right").foregroundStyle(.secondary)
                    drugPicker("Second drug", selection: $secondID)
                }
                if let first, let second {
                    VStack(spacing: 0) {
                        compareHeader(first, second)
                        compareRow("Class", first.drugClass, second.drugClass)
                        compareRow("System", first.chapterRaw, second.chapterRaw)
                        compareRow("Main use", first.indications.first ?? "Unknown", second.indications.first ?? "Unknown")
                        compareRow("Mechanism", first.mechanism, second.mechanism)
                        compareRow("Dosing", first.dosingFrequency.rawValue, second.dosingFrequency.rawValue)
                        compareRow("Half-life", first.halfLifeText, second.halfLifeText)
                        compareRow("Main warning", first.warnings.first ?? "Unknown", second.warnings.first ?? "Unknown")
                        compareRow("Counsel", first.counselingSentence, second.counselingSentence)
                        compareRow("Excretion", first.excretionRoute.rawValue, second.excretionRoute.rawValue)
                    }
                    .background(.background, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                } else {
                    EmptyStateView(icon: "square.split.2x1", title: "Choose two drugs", message: "The comparison will build itself from your saved cards.")
                }
            }
            .padding()
        }
        .onAppear {
            if firstID == nil { firstID = drugs.first?.id }
            if secondID == nil { secondID = drugs.dropFirst().first?.id }
        }
    }

    private func drugPicker(_ title: String, selection: Binding<UUID?>) -> some View {
        Picker(title, selection: selection) {
            Text(title).tag(UUID?.none)
            ForEach(drugs) { Text($0.displayName).tag(Optional($0.id)) }
        }
        .pickerStyle(.menu).frame(maxWidth: .infinity).padding(8)
        .background(.background, in: RoundedRectangle(cornerRadius: 14))
    }

    private func compareHeader(_ first: Drug, _ second: Drug) -> some View {
        HStack(spacing: 0) {
            Text(first.displayName).frame(maxWidth: .infinity)
            Divider()
            Text(second.displayName).frame(maxWidth: .infinity)
        }
        .font(.headline).padding().background(.tint.opacity(0.10))
    }

    private func compareRow(_ label: String, _ left: String, _ right: String) -> some View {
        VStack(spacing: 8) {
            Text(label.uppercased()).font(.caption2.bold()).foregroundStyle(.secondary)
            HStack(alignment: .top, spacing: 0) {
                Text(left.trimmed.isEmpty ? "Unknown" : left).frame(maxWidth: .infinity, alignment: .topLeading).padding(.trailing, 8)
                Divider()
                Text(right.trimmed.isEmpty ? "Unknown" : right).frame(maxWidth: .infinity, alignment: .topLeading).padding(.leading, 8)
            }
            .font(.caption)
        }
        .padding(12).overlay(alignment: .bottom) { Divider() }
    }
}
