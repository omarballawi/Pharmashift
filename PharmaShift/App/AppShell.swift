import Observation
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

    func openCapture(chapter: Chapter? = nil) {
        captureChapter = chapter
        selection = .capture
    }

    func openLibrary(chapter: Chapter? = nil) {
        libraryChapter = chapter
        selection = .library
    }

    func startReview(chapter: Chapter? = nil) {
        reviewChapter = chapter
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
                NavigationLink { AboutView() } label: {
                    Label("About & Safety / حول التطبيق", systemImage: "info.circle.fill")
                }
            }
        }
        .navigationTitle("More / المزيد")
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
