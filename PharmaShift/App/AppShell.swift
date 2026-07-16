import Observation
import SwiftData
import SwiftUI

enum AppTab: String, CaseIterable, Identifiable {
    case today = "Today"
    case library = "Library"
    case practice = "Practice"
    case you = "You"

    var id: String { rawValue }
    var icon: String {
        switch self {
        case .today: "sun.max.fill"
        case .library: "books.vertical.fill"
        case .practice: "brain.head.profile.fill"
        case .you: "person.crop.circle.fill"
        }
    }
}

enum AppRoute: Hashable {
    case drug(UUID)
    case drugTopic(UUID, DrugTopic)
}

enum AppSheet: Identifiable {
    case addHub
    case capture(Chapter?)

    var id: String {
        switch self {
        case .addHub: "add-hub"
        case .capture(let chapter): "capture-\(chapter?.rawValue ?? "all")"
        }
    }
}

@MainActor
@Observable
final class AppNavigation {
    var selection: AppTab = .today
    var todayPath: [AppRoute] = []
    var libraryPath: [AppRoute] = []
    var practicePath: [AppRoute] = []
    var youPath: [AppRoute] = []
    var presentedSheet: AppSheet?
    var libraryChapter: Chapter?
    var reviewChapter: Chapter?
    var requestedPracticeMode: PracticeMode?

    func openCapture(chapter: Chapter? = nil) {
        presentedSheet = .capture(chapter)
    }

    func presentAdd() {
        presentedSheet = .addHub
    }

    func openLibrary(chapter: Chapter? = nil) {
        libraryChapter = chapter
        selection = .library
    }

    func openDrugAfterCapture(_ id: UUID) {
        let destinationTab = selection
        presentedSheet = nil
        Task { @MainActor [weak self] in
            try? await Task.sleep(for: .milliseconds(220))
            guard let self else { return }
            let route = AppRoute.drug(id)
            switch destinationTab {
            case .today: todayPath.append(route)
            case .library: libraryPath.append(route)
            case .practice: practicePath.append(route)
            case .you: youPath.append(route)
            }
        }
    }

    func startReview(chapter: Chapter? = nil, mode: PracticeMode? = nil) {
        reviewChapter = chapter
        requestedPracticeMode = mode ?? (chapter == nil ? .tradeToScientific : .systemSpecific)
        selection = .practice
    }
}

struct AppShell: View {
    @Environment(\.modelContext) private var context
    @Environment(AppTheme.self) private var theme
    @State private var navigation = AppNavigation()

    var body: some View {
        @Bindable var bindableNavigation = navigation
        TabView(selection: $bindableNavigation.selection) {
            NavigationStack(path: $bindableNavigation.todayPath) {
                HomeView().withAppDestinations()
            }
                .tabItem { Label(AppTab.today.rawValue, systemImage: AppTab.today.icon) }
                .tag(AppTab.today)

            NavigationStack(path: $bindableNavigation.libraryPath) {
                LibraryView().withAppDestinations()
            }
                .tabItem { Label(AppTab.library.rawValue, systemImage: AppTab.library.icon) }
                .tag(AppTab.library)

            NavigationStack(path: $bindableNavigation.practicePath) {
                PracticeView().withAppDestinations()
            }
                .tabItem { Label(AppTab.practice.rawValue, systemImage: AppTab.practice.icon) }
                .tag(AppTab.practice)

            NavigationStack(path: $bindableNavigation.youPath) {
                YouView().withAppDestinations()
            }
                .tabItem { Label(AppTab.you.rawValue, systemImage: AppTab.you.icon) }
                .tag(AppTab.you)
        }
        .tint(theme.tint)
        .environment(navigation)
        .sheet(item: $bindableNavigation.presentedSheet) { sheet in
            switch sheet {
            case .addHub:
                NavigationStack {
                    AddHubView { id in navigation.openDrugAfterCapture(id) }
                }
                    .presentationDetents([.large])
            case .capture(let chapter):
                CaptureSheetView(initialChapter: chapter) { id in navigation.openDrugAfterCapture(id) }
            }
        }
        .task {
            try? DrugLibraryMigrationService.runIfNeeded(context: context)
        }
    }
}

private extension View {
    func withAppDestinations() -> some View {
        navigationDestination(for: AppRoute.self) { route in
            DrugRouteDestination(route: route)
        }
    }
}

private struct DrugRouteDestination: View {
    @Environment(AppTheme.self) private var theme
    @Query private var drugs: [Drug]
    let route: AppRoute

    init(route: AppRoute) {
        self.route = route
        let drugID: UUID = switch route {
        case .drug(let id), .drugTopic(let id, _): id
        }
        _drugs = Query(filter: #Predicate<Drug> { $0.id == drugID })
    }

    private var drugID: UUID {
        switch route {
        case .drug(let id), .drugTopic(let id, _): id
        }
    }

    var body: some View {
        Group {
            if let drug = drugs.first(where: { $0.id == drugID }) {
                switch route {
                case .drug:
                    DrugDetailView(drug: drug)
                case .drugTopic(_, let topic):
                    DrugTopicView(drug: drug, topic: topic)
                }
            } else {
                ContentUnavailableView(
                    "Drug no longer available",
                    systemImage: "pills",
                    description: Text("This profile may have been deleted from the library.")
                )
                .background(theme.background)
            }
        }
    }
}

private struct AddHubView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AppTheme.self) private var theme
    let onOpenSavedDrug: (UUID) -> Void

    var body: some View {
        List {
            Section {
                NavigationLink {
                    CaptureView { id in
                        dismiss()
                        onOpenSavedDrug(id)
                    }
                } label: {
                    AddRouteRow(
                        icon: "plus.viewfinder",
                        title: "Add an active drug",
                        detail: "Fast manual capture for a new profile",
                        tint: theme.coral
                    )
                }
                .accessibilityIdentifier("addHub.manualDrug")
            }

            Section("Optional smart tools") {
                NavigationLink {
                    DrugImportView()
                } label: {
                    AddRouteRow(
                        icon: "text.magnifyingglass",
                        title: "Trusted-source import",
                        detail: "Review source facts before saving",
                        tint: theme.aqua
                    )
                }
                .accessibilityIdentifier("addHub.trustedImport")
                NavigationLink {
                    DrugImportView(startsInAIMode: true)
                } label: {
                    AddRouteRow(
                        icon: "wand.and.stars",
                        title: "Generate a full profile",
                        detail: "Experimental AI workflow with field review",
                        tint: theme.ink
                    )
                }
                .accessibilityIdentifier("addHub.aiGenerator")
            }

            Section {
                Text("To add a brand for an active ingredient you already know, open that drug and choose Brands. The active drug facts stay unchanged.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .scrollContentBackground(.hidden)
        .background(theme.background)
        .navigationTitle("Add to Renlyst")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Close") { dismiss() }
            }
        }
    }
}

private struct CaptureSheetView: View {
    @Environment(\.dismiss) private var dismiss
    let initialChapter: Chapter?
    let onOpenSavedDrug: (UUID) -> Void

    var body: some View {
        NavigationStack {
            CaptureView(initialChapter: initialChapter) { id in
                dismiss()
                onOpenSavedDrug(id)
            }
        }
        .presentationDetents([.large])
    }
}

private struct AddRouteRow: View {
    let icon: String
    let title: String
    let detail: String
    let tint: Color

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.title3.weight(.semibold))
                .foregroundStyle(tint)
                .frame(width: 42, height: 42)
                .background(tint.opacity(0.11), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            VStack(alignment: .leading, spacing: 3) {
                Text(title).font(.headline)
                Text(detail).font(.subheadline).foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 5)
    }
}

private struct YouView: View {
    @Environment(AppTheme.self) private var theme
    @Query private var profiles: [LearningProfile]

    private var profile: LearningProfile? { profiles.first }
    private var progress: Double { min(Double(profile?.completedQuestions ?? 0) / 100, 1) }
    private var summary: String {
        let streak = profile?.currentStreak ?? 0
        let sessions = profile?.completedSessions ?? 0
        return "\(streak)-day streak · \(sessions) sessions completed"
    }

    var body: some View {
        List {
            Section {
                HStack(spacing: 16) {
                    OrbitMark(progress: progress)
                        .frame(width: 72, height: 72)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Your learning rhythm")
                            .font(.system(.title2, design: .serif, weight: .semibold))
                            .foregroundStyle(.white)
                        Text(summary)
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.7))
                    }
                }
                .padding(18)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(theme.inkSolid, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
                .accessibilityElement(children: .combine)
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
            Section("Training") {
                NavigationLink { ShiftView() } label: {
                    Label("Daily shift", systemImage: "clock.badge.checkmark")
                }
                NavigationLink { ReportView() } label: {
                    Label("Training report", systemImage: "chart.bar.doc.horizontal")
                }
            }
            Section("Library & data") {
                NavigationLink { CommandPaletteView() } label: {
                    Label("Quick search", systemImage: "command.circle.fill")
                }
                NavigationLink { BackupDataView() } label: {
                    Label("Backup & data", systemImage: "externaldrive.fill")
                }
            }
            Section("App") {
                NavigationLink { LearningSettingsView() } label: {
                    Label("Preferences & AI", systemImage: "slider.horizontal.3")
                }
                NavigationLink { AboutView() } label: {
                    Label("About & safety", systemImage: "info.circle.fill")
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(theme.background)
        .navigationTitle("You")
        .accessibilityIdentifier("you.dashboard")
    }
}

private struct CommandPaletteView: View {
    @Environment(AppNavigation.self) private var navigation
    @Query(sort: \Drug.scientificName) private var drugs: [Drug]
    @State private var query = ""

    private var results: [Drug] {
        guard !query.trimmed.isEmpty else { return Array(drugs.prefix(8)) }
        return drugs.filter { [$0.displayName, $0.effectiveTradeNames.joined(separator: " "), $0.drugClass, $0.chapterRaw, $0.notes, $0.arabicExplanation].joined(separator: " ").localizedCaseInsensitiveContains(query) }
    }

    var body: some View {
        List {
            Section("Actions") {
                Button { navigation.openCapture() } label: { Label("Capture a drug", systemImage: "camera.fill") }
                Button { navigation.startReview(mode: .smartSession) } label: { Label("Start Smart Session", systemImage: "sparkles") }
                Button { navigation.openLibrary() } label: { Label("Open Library", systemImage: "books.vertical.fill") }
            }
            Section(query.trimmed.isEmpty ? "Recent cards" : "Results") {
                ForEach(results) { drug in NavigationLink(value: AppRoute.drug(drug.id)) { VStack(alignment: .leading) { Text(drug.displayName); Text([drug.firstTradeName, drug.drugClass].filter { !$0.trimmed.isEmpty }.joined(separator: " • ")).font(.caption).foregroundStyle(.secondary) } } }
                if results.isEmpty { Text("No matching drug or note.").foregroundStyle(.secondary) }
            }
        }
        .searchable(text: $query, placement: .navigationBarDrawer(displayMode: .always), prompt: "Drug, class, system, note, Arabic")
        .navigationTitle("Quick Search")
    }
}

private struct LearningSettingsView: View {
    @Environment(\.modelContext) private var context
    @Environment(AppTheme.self) private var theme
    @Query private var profiles: [LearningProfile]
    @State private var deepSeekKey = ""
    @State private var keyStatus = DeepSeekKeyStore.shared.savedKeyStatusDescription()
    @State private var openRouterKey = ""
    @State private var openRouterModel = OpenRouterKeyStore.shared.modelID()
    @State private var openRouterStatus = OpenRouterKeyStore.shared.savedKeyStatusDescription()
    @State private var checkingConnection = false
    @State private var checkingOpenRouterConnection = false
    @State private var showsKeyStatus = false

    var body: some View {
        Form {
            Section("DeepSeek formatting") {
                SecureField("DeepSeek API key", text: $deepSeekKey)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .textContentType(.password)
                    .accessibilityIdentifier("deepSeek.keyField")
                PasteButton(payloadType: String.self) { strings in
                    deepSeekKey = strings.first?.normalizedAPIKey ?? ""
                }
                .buttonStyle(.bordered)
                Button { saveDeepSeekKey() } label: {
                    Label("Save key", systemImage: "key.fill")
                        .frame(maxWidth: .infinity, minHeight: 44)
                }
                .buttonStyle(.borderedProminent)
                .disabled(deepSeekKey.normalizedAPIKey.isEmpty)
                .accessibilityIdentifier("deepSeek.saveKey")
                Button(role: .destructive) { clearDeepSeekKey() } label: {
                    Label("Clear saved key", systemImage: "trash")
                        .frame(maxWidth: .infinity, minHeight: 44)
                }
                .buttonStyle(.bordered)
                .accessibilityIdentifier("deepSeek.clearKey")
                Button {
                    checkConnection()
                } label: {
                    Label(checkingConnection ? "Checking connection" : "Check connection", systemImage: "network")
                }
                .disabled(checkingConnection)
                .accessibilityIdentifier("deepSeek.checkConnection")
                Text(keyStatus)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .accessibilityIdentifier("deepSeek.keyStatus")
                LabeledContent("App build", value: appBuild)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("For standalone generation, DeepSeek receives the confirmed drug identity and optional package facts. Trusted import sends compact source text, and AI practice sends compact saved facts. DeepSeek does not receive drug photos.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Section("OpenRouter package recognition") {
                SecureField("OpenRouter API key", text: $openRouterKey)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .textContentType(.password)
                    .accessibilityIdentifier("openRouter.keyField")
                PasteButton(payloadType: String.self) { strings in
                    openRouterKey = strings.first?.normalizedAPIKey ?? ""
                }
                .buttonStyle(.bordered)
                TextField("Vision model slug", text: $openRouterModel)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .accessibilityIdentifier("openRouter.modelField")
                Text("Default: \(OpenRouterPackageVisionService.defaultModel). Replace it with any OpenRouter model slug that supports image input and structured output.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Button { saveOpenRouterConfiguration() } label: {
                    Label("Save OpenRouter configuration", systemImage: "key.fill")
                        .frame(maxWidth: .infinity, minHeight: 44)
                }
                .buttonStyle(.borderedProminent)
                .disabled(openRouterModel.trimmed.isEmpty || (openRouterKey.normalizedAPIKey.isEmpty && OpenRouterKeyStore.shared.apiKey() == nil))
                Button(role: .destructive) { clearOpenRouterKey() } label: {
                    Label("Clear OpenRouter key", systemImage: "trash")
                        .frame(maxWidth: .infinity, minHeight: 44)
                }
                .buttonStyle(.bordered)
                Button { checkOpenRouterConnection() } label: {
                    Label(checkingOpenRouterConnection ? "Checking OpenRouter" : "Check OpenRouter connection", systemImage: "network")
                }
                .disabled(checkingOpenRouterConnection)
                Text(openRouterStatus)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("Medicine package photos are sent through OpenRouter to the selected vision model to identify visible product facts and component strengths. Clinical profile generation remains with DeepSeek.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Section("In-app reminders") {
                Toggle("Show weak-drug reminders", isOn: reminderBinding)
                Text("This reminder appears only inside Renlyst and never requests notification permission.")
                    .font(.caption).foregroundStyle(.secondary)
            }
            if let profile = profiles.first {
                Section("Learning progress") {
                    LabeledContent("Current streak", value: "\(profile.currentStreak) days")
                    LabeledContent("Longest streak", value: "\(profile.longestStreak) days")
                    LabeledContent("Completed sessions", value: "\(profile.completedSessions)")
                }
            }
        }
        .navigationTitle("Practice Preferences")
        .scrollContentBackground(.hidden)
        .background(theme.background)
        .accessibilityIdentifier("deepSeek.settings")
        .onAppear { refreshKeyStatus() }
        .alert("AI key", isPresented: $showsKeyStatus) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(keyStatus)
        }
    }

    private func saveDeepSeekKey() {
        do {
            let location = try DeepSeekKeyStore.shared.save(apiKey: deepSeekKey)
            guard DeepSeekKeyStore.shared.apiKey() == deepSeekKey.normalizedAPIKey else { throw DeepSeekKeyStore.KeyStoreError.readBackFailed }
            keyStatus = "Saved key ••••\(deepSeekKey.normalizedAPIKey.suffix(4)) via \(location.label)"
            showsKeyStatus = true
        } catch {
            keyStatus = "Could not save key: \(error.localizedDescription)"
            showsKeyStatus = true
        }
    }

    private func clearDeepSeekKey() {
        DeepSeekKeyStore.shared.delete()
        deepSeekKey = ""
        keyStatus = "No DeepSeek key saved"
        showsKeyStatus = true
    }

    private func checkConnection() {
        checkingConnection = true
        Task {
            do {
                let status = try await DeepSeekKeyStore.shared.testConnection()
                await MainActor.run { keyStatus = status; checkingConnection = false; showsKeyStatus = true }
            } catch {
                await MainActor.run { keyStatus = "Connection check failed: \(error.localizedDescription)"; checkingConnection = false; showsKeyStatus = true }
            }
        }
    }

    private func refreshKeyStatus() {
        keyStatus = DeepSeekKeyStore.shared.savedKeyStatusDescription()
        openRouterStatus = OpenRouterKeyStore.shared.savedKeyStatusDescription()
        openRouterModel = OpenRouterKeyStore.shared.modelID()
    }

    private func saveOpenRouterConfiguration() {
        do {
            OpenRouterKeyStore.shared.saveModelID(openRouterModel)
            openRouterModel = OpenRouterKeyStore.shared.modelID()
            if !openRouterKey.normalizedAPIKey.isEmpty {
                let location = try OpenRouterKeyStore.shared.save(apiKey: openRouterKey)
                guard OpenRouterKeyStore.shared.apiKey() == openRouterKey.normalizedAPIKey else { throw DeepSeekKeyStore.KeyStoreError.readBackFailed }
                openRouterStatus = "Saved key ••••\(openRouterKey.normalizedAPIKey.suffix(4)) via \(location.label) • \(openRouterModel)"
            } else {
                openRouterStatus = "Saved model • \(openRouterModel)"
            }
        } catch {
            openRouterStatus = "Could not save OpenRouter configuration: \(error.localizedDescription)"
        }
        keyStatus = openRouterStatus
        showsKeyStatus = true
    }

    private func clearOpenRouterKey() {
        OpenRouterKeyStore.shared.delete()
        openRouterKey = ""
        openRouterStatus = "No OpenRouter key saved • model \(OpenRouterKeyStore.shared.modelID())"
        keyStatus = openRouterStatus
        showsKeyStatus = true
    }

    private func checkOpenRouterConnection() {
        OpenRouterKeyStore.shared.saveModelID(openRouterModel)
        openRouterModel = OpenRouterKeyStore.shared.modelID()
        checkingOpenRouterConnection = true
        Task {
            do {
                let status = try await OpenRouterKeyStore.shared.testConnection()
                await MainActor.run { openRouterStatus = status; keyStatus = status; checkingOpenRouterConnection = false; showsKeyStatus = true }
            } catch {
                await MainActor.run { openRouterStatus = "OpenRouter connection failed: \(error.localizedDescription)"; keyStatus = openRouterStatus; checkingOpenRouterConnection = false; showsKeyStatus = true }
            }
        }
    }

    private var appBuild: String {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "—"
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "—"
        return "\(version) (\(build))"
    }

    private var reminderBinding: Binding<Bool> {
        Binding(
            get: { profiles.first?.weakDrugRemindersEnabled ?? true },
            set: { enabled in
                do {
                    let profile = try LearningProgressService.profile(in: context)
                    profile.weakDrugRemindersEnabled = enabled
                    try context.save()
                } catch { }
            }
        )
    }
}

private struct AboutView: View {
    @Environment(AppTheme.self) private var theme

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Offline-first training companion", systemImage: "lock.shield.fill")
                        .font(.headline)
                    Text("Renlyst is for personal pharmacy learning. Confirm clinical decisions and dispensing with your supervising pharmacist.")
                    Text("Renlyst للتعلّم الشخصي أثناء التدريب. أكّد القرارات السريرية وصرف الأدوية مع الصيدلي المشرف.")
                        .environment(\.layoutDirection, .rightToLeft)
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.vertical, 6)
            }
        }
        .scrollContentBackground(.hidden)
        .background(theme.background)
        .navigationTitle("About / حول التطبيق")
    }
}
