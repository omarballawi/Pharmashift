import SwiftData
import SwiftUI

struct PracticeView: View {
    @Environment(AppNavigation.self) private var navigation
    @Environment(AppTheme.self) private var theme
    @Environment(ReviewScheduler.self) private var scheduler
    @Query(sort: \Drug.nextReviewDate) private var drugs: [Drug]
    @Query private var profiles: [LearningProfile]
    @State private var selectedMode: PracticeMode?
    @State private var selectedChapter: Chapter?
    @State private var choosesSystem = false

    private var available: [Drug] { drugs.filter { !$0.isUnknown } }
    private var due: [Drug] { available.filter { scheduler.isDue($0) } }
    private var weak: [Drug] { available.filter { $0.confidenceLevel == .weak || $0.isConfusing || !$0.isMastered } }

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: RenlystLayout.sectionSpacing) {
                PracticeSummary(due: due.count, streak: profiles.first?.currentStreak ?? 0, sessions: profiles.first?.completedSessions ?? 0)
                if available.isEmpty {
                    RenlystEmptyState(
                        imageName: "LibraryEmpty",
                        title: "Nothing to practice yet",
                        message: "Add one known drug. Renlyst will turn its saved facts into a five-question session.",
                        actionTitle: "Add a drug",
                        action: { navigation.presentAdd() }
                    )
                } else {
                    RecommendedPracticeCard(dueCount: due.count, weakCount: weak.count) { selectedMode = .smartSession }
                    QuickPracticeSection(select: select)
                    PracticeToolsSection()
                }
            }
            .padding(.horizontal, RenlystLayout.pageInset)
            .padding(.bottom, 28)
        }
        .background(theme.background)
        .navigationTitle("Practice")
        .sheet(item: $selectedMode, onDismiss: { selectedChapter = nil }) { mode in
            NavigationStack { PracticeSessionView(mode: mode, chapter: selectedChapter) }
        }
        .confirmationDialog("Choose a system", isPresented: $choosesSystem, titleVisibility: .visible) {
            ForEach(Chapter.allCases) { chapter in
                Button(chapter.rawValue) {
                    selectedChapter = chapter
                    selectedMode = .systemSpecific
                }
            }
            Button("Cancel", role: .cancel) {}
        }
        .onAppear(perform: openRequestedReview)
        .onChange(of: navigation.reviewChapter) { _, _ in openRequestedReview() }
        .onChange(of: navigation.requestedPracticeMode) { _, _ in openRequestedReview() }
        .accessibilityIdentifier("practice.dashboard")
    }

    private func select(_ mode: PracticeMode) {
        if mode == .systemSpecific { choosesSystem = true }
        else { selectedMode = mode }
    }

    private func openRequestedReview() {
        if let chapter = navigation.reviewChapter {
            selectedChapter = chapter
            navigation.reviewChapter = nil
        }
        guard let mode = navigation.requestedPracticeMode else { return }
        navigation.requestedPracticeMode = nil
        selectedMode = mode
    }
}

private struct PracticeSummary: View {
    @Environment(AppTheme.self) private var theme
    let due: Int
    let streak: Int
    let sessions: Int

    var body: some View {
        ViewThatFits(in: .horizontal) {
            HStack(spacing: 0) {
                item("Due", value: due, icon: "calendar.badge.clock")
                Divider().frame(height: 36)
                item("Streak", value: streak, icon: "flame.fill")
                Divider().frame(height: 36)
                item("Sessions", value: sessions, icon: "checkmark.circle")
            }
            VStack(spacing: 10) {
                item("Due", value: due, icon: "calendar.badge.clock")
                item("Streak", value: streak, icon: "flame.fill")
                item("Sessions", value: sessions, icon: "checkmark.circle")
            }
        }
        .padding(.vertical, 14)
        .background(theme.surface, in: RoundedRectangle(cornerRadius: RenlystLayout.surfaceRadius, style: .continuous))
        .accessibilityElement(children: .combine)
    }

    private func item(_ label: String, value: Int, icon: String) -> some View {
        VStack(spacing: 4) {
            Label(value.formatted(), systemImage: icon).font(.headline.monospacedDigit()).foregroundStyle(theme.ink)
            Text(label).font(.caption).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct RecommendedPracticeCard: View {
    @Environment(AppTheme.self) private var theme
    let dueCount: Int
    let weakCount: Int
    let action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("RECOMMENDED").font(.caption.weight(.bold)).foregroundStyle(theme.aqua)
                    Text("Smart five").font(.title2.weight(.semibold))
                    Text("A short mix of due facts, weak recall, package recognition, safety, and counseling.")
                        .font(.subheadline).foregroundStyle(.secondary)
                }
                Spacer()
                OrbitMark(progress: 0.72).frame(width: 72, height: 72)
            }
            HStack(spacing: 14) {
                Label("\(dueCount) due", systemImage: "clock")
                Label("\(weakCount) weak", systemImage: "bolt.heart")
            }
            .font(.caption.weight(.semibold)).foregroundStyle(.secondary)
            Button(action: action) { Label("Start five questions", systemImage: "play.fill") }
                .buttonStyle(RenlystPrimaryButtonStyle())
                .accessibilityIdentifier("practice.smartSession")
        }
        .padding(18)
        .background(theme.surface, in: RoundedRectangle(cornerRadius: RenlystLayout.surfaceRadius, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: RenlystLayout.surfaceRadius, style: .continuous)
                .stroke(theme.separator.opacity(0.3), lineWidth: 0.5)
        }
    }
}

private struct QuickPracticeSection: View {
    @Environment(AppTheme.self) private var theme
    let select: (PracticeMode) -> Void
    private let modes: [PracticeMode] = [.imageQuiz, .tradeToScientific, .counseling, .casePractice]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            RenlystSectionHeader("Quick practice", subtitle: "Choose the kind of recall you need")
            VStack(spacing: 0) {
                ForEach(Array(modes.enumerated()), id: \.offset) { index, mode in
                    Button { select(mode) } label: {
                        HStack(spacing: 13) {
                            Image(systemName: mode.icon)
                                .foregroundStyle(theme.aqua)
                                .frame(width: 36, height: 36)
                                .background(theme.softAqua, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                            VStack(alignment: .leading, spacing: 2) {
                                Text(mode.rawValue).font(.headline)
                                Text(mode.detail).font(.caption).foregroundStyle(.secondary).lineLimit(1)
                            }
                            Spacer()
                            Image(systemName: "play.fill").font(.caption).foregroundStyle(theme.coral)
                        }
                        .padding(.horizontal, 14)
                        .frame(minHeight: 60)
                    }
                    .buttonStyle(.plain)
                    .accessibilityIdentifier("practice.mode.\(mode.rawValue)")
                    if index < modes.count - 1 { Divider().padding(.leading, 63) }
                }
            }
            .background(theme.surface, in: RoundedRectangle(cornerRadius: RenlystLayout.surfaceRadius, style: .continuous))
        }
    }
}

private struct PracticeToolsSection: View {
    @Environment(AppTheme.self) private var theme

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            RenlystSectionHeader("More practice", subtitle: "Special sessions and maintenance tools")
            VStack(spacing: 0) {
                tool("All modes", icon: "square.grid.2x2") { PracticeModesView() }
                Divider().padding(.leading, 58)
                tool("Daily refresh", icon: "arrow.clockwise") { DailyRefreshView() }
                Divider().padding(.leading, 58)
                tool("Mistake vault", icon: "archivebox.fill") { MistakeVaultView() }
                Divider().padding(.leading, 58)
                tool("AI practice pack", icon: "wand.and.stars") { AIPracticePackView() }
            }
            .background(theme.surface, in: RoundedRectangle(cornerRadius: RenlystLayout.surfaceRadius, style: .continuous))
        }
    }

    private func tool<Destination: View>(_ title: String, icon: String, @ViewBuilder destination: () -> Destination) -> some View {
        NavigationLink(destination: destination()) {
            HStack(spacing: 13) {
                Image(systemName: icon).foregroundStyle(theme.aqua).frame(width: 32, height: 32)
                Text(title).font(.headline)
                Spacer()
            }
            .padding(.horizontal, 14)
            .frame(minHeight: 54)
        }
        .buttonStyle(.plain)
    }
}

private struct PracticeModesView: View {
    @Environment(AppTheme.self) private var theme

    var body: some View {
        List {
            Section("Five-question sessions") {
                ForEach(PracticeMode.allCases.filter { $0 != .systemSpecific }) { mode in
                    NavigationLink { PracticeSessionView(mode: mode) } label: {
                        VStack(alignment: .leading, spacing: 3) {
                            Label(mode.rawValue, systemImage: mode.icon).font(.headline)
                            Text(mode.detail).font(.caption).foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 3)
                    }
                }
            }
            Section("By system") {
                ForEach(Chapter.allCases) { chapter in
                    NavigationLink { PracticeSessionView(mode: .systemSpecific, chapter: chapter) } label: {
                        Label(chapter.rawValue, systemImage: chapter.icon)
                    }
                }
            }
        }
        .scrollContentBackground(.hidden).background(theme.background)
        .navigationTitle("Practice modes")
    }
}

private struct AIPracticePackView: View {
    @Environment(AppTheme.self) private var theme
    @Query private var drugs: [Drug]
    @State private var pack: AIPracticePack? = AIPracticePackStore.load()
    @State private var isRefreshing = false
    @State private var status = ""

    private var available: [Drug] { drugs.filter { !$0.isUnknown } }

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Optional AI question writer", systemImage: "wand.and.stars").font(.headline)
                    Text("The generated five-question pack is cached on this device and stays available offline until the library changes or you refresh it.")
                        .font(.subheadline).foregroundStyle(.secondary)
                }
                .padding(.vertical, 5)
            }
            if let pack {
                Section("Saved pack") {
                    NavigationLink { PracticeSessionView(questions: pack.questions, title: "AI Practice Pack") } label: {
                        Label("Start five questions", systemImage: "play.fill")
                    }
                    LabeledContent("Created", value: pack.generatedAt.formatted(date: .abbreviated, time: .shortened))
                }
            }
            Section {
                Button(action: refresh) {
                    Group {
                        if isRefreshing {
                            HStack { ProgressView(); Text("Creating questions…") }
                        } else {
                            Label("Refresh five questions", systemImage: "arrow.clockwise")
                        }
                    }
                    .frame(maxWidth: .infinity, minHeight: 44)
                }
                .disabled(isRefreshing || available.isEmpty)
                if !status.isEmpty { Text(status).font(.footnote).foregroundStyle(.secondary) }
            }
        }
        .scrollContentBackground(.hidden).background(theme.background)
        .navigationTitle("AI practice pack")
    }

    private func refresh() {
        isRefreshing = true
        status = ""
        Task {
            do {
                let newPack = try await DeepSeekPracticeService().makePack(from: available)
                AIPracticePackStore.save(newPack)
                await MainActor.run {
                    pack = newPack
                    status = "Five questions saved for offline practice."
                    isRefreshing = false
                }
            } catch {
                await MainActor.run {
                    status = error.localizedDescription
                    isRefreshing = false
                }
            }
        }
    }
}
