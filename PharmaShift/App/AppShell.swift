import Observation
import SwiftData
import SwiftUI

enum AppTab: String, CaseIterable, Identifiable {
    case home = "Home"
    case library = "Library"
    case capture = "Add"
    case practice = "Practice"
    case more = "More"

    var id: String { rawValue }
    var icon: String {
        switch self {
        case .home: "sparkles"
        case .library: "books.vertical.fill"
        case .capture: "plus.circle.fill"
        case .practice: "brain.head.profile"
        case .more: "ellipsis.circle.fill"
        }
    }
}

@MainActor
@Observable
final class AppNavigation {
    var selection: AppTab = .home
    var captureChapter: Chapter?
    var libraryChapter: Chapter?
    var reviewChapter: Chapter?
    var requestedPracticeMode: PracticeMode?

    func openCapture(chapter: Chapter? = nil) {
        captureChapter = chapter
        selection = .capture
    }

    func openLibrary(chapter: Chapter? = nil) {
        libraryChapter = chapter
        selection = .library
    }

    func startReview(chapter: Chapter? = nil, mode: PracticeMode? = nil) {
        reviewChapter = chapter
        requestedPracticeMode = mode ?? (chapter == nil ? .tradeToScientific : .systemSpecific)
        selection = .practice
    }
}

struct AppShell: View {
    @Environment(AppTheme.self) private var theme
    @State private var navigation = AppNavigation()

    var body: some View {
        @Bindable var bindableNavigation = navigation
        TabView(selection: $bindableNavigation.selection) {
            NavigationStack { HomeView() }
                .tabItem { Label(AppTab.home.rawValue, systemImage: AppTab.home.icon) }
                .tag(AppTab.home)

            NavigationStack { LibraryView() }
                .tabItem { Label(AppTab.library.rawValue, systemImage: AppTab.library.icon) }
                .tag(AppTab.library)

            NavigationStack { CaptureView() }
                .tabItem { Label(AppTab.capture.rawValue, systemImage: AppTab.capture.icon) }
                .tag(AppTab.capture)

            NavigationStack { PracticeView() }
                .tabItem { Label(AppTab.practice.rawValue, systemImage: AppTab.practice.icon) }
                .tag(AppTab.practice)

            NavigationStack { MoreView() }
                .tabItem { Label(AppTab.more.rawValue, systemImage: AppTab.more.icon) }
                .tag(AppTab.more)
        }
        .tint(theme.tint)
        .environment(navigation)
    }
}

private struct MoreView: View {
    var body: some View {
        List {
            Section("Training / التدريب") {
                NavigationLink { ShiftView() } label: {
                    Label("Daily Shift / الوردية اليومية", systemImage: "clock.badge.checkmark")
                }
                NavigationLink { ReportView() } label: {
                    Label("Training Report / تقرير التدريب", systemImage: "chart.bar.doc.horizontal")
                }
            }
            Section("App") {
                NavigationLink { BackupDataView() } label: {
                    Label("Backup & Data", systemImage: "externaldrive.fill")
                }
                NavigationLink { LearningSettingsView() } label: {
                    Label("Practice preferences", systemImage: "slider.horizontal.3")
                }
                NavigationLink { AboutView() } label: {
                    Label("About & Safety / حول التطبيق", systemImage: "info.circle.fill")
                }
            }
        }
        .navigationTitle("More / المزيد")
        .accessibilityIdentifier("more.dashboard")
    }
}

private struct LearningSettingsView: View {
    @Environment(\.modelContext) private var context
    @Query private var profiles: [LearningProfile]
    @State private var deepSeekKey = ""
    @State private var keyStatus = DeepSeekKeyStore.shared.savedKeyStatusDescription()
    @State private var checkingConnection = false
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
                Text("For standalone generation, DeepSeek receives the drug identity and optional package text you entered. Trusted import sends compact source text, and AI practice sends compact saved facts. Drug photos stay on device.")
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
        .accessibilityIdentifier("deepSeek.settings")
        .onAppear { refreshKeyStatus() }
        .alert("DeepSeek key", isPresented: $showsKeyStatus) {
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
    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Private, offline training companion", systemImage: "lock.shield.fill")
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
        .navigationTitle("About / حول التطبيق")
    }
}
