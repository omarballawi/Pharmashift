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
    }
}

private struct LearningSettingsView: View {
    @Environment(\.modelContext) private var context
    @Query private var profiles: [LearningProfile]

    var body: some View {
        Form {
            Section("In-app reminders") {
                Toggle("Show weak-drug reminders", isOn: reminderBinding)
                Text("This reminder appears only inside PharmaShift and never requests notification permission.")
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
                    Text("PharmaShift is for personal pharmacy learning. Confirm clinical decisions and dispensing with your supervising pharmacist.")
                    Text("PharmaShift للتعلّم الشخصي أثناء التدريب. أكّد القرارات السريرية وصرف الأدوية مع الصيدلي المشرف.")
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
