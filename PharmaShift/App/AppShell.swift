import SwiftUI

enum AppTab: String, CaseIterable, Identifiable {
    case shift = "Shift"
    case capture = "Capture"
    case library = "Library"
    case practice = "Practice"
    case report = "Report"

    var id: String { rawValue }
    var icon: String {
        switch self {
        case .shift: "clock.badge.checkmark"
        case .capture: "plus.circle.fill"
        case .library: "books.vertical.fill"
        case .practice: "brain.head.profile"
        case .report: "chart.bar.doc.horizontal"
        }
    }
}

struct AppShell: View {
    @Environment(AppTheme.self) private var theme
    @State private var selection: AppTab = .shift

    var body: some View {
        VStack(spacing: 0) {
            SafetyBanner()
            TabView(selection: $selection) {
                NavigationStack { ShiftView() }
                    .tabItem { Label(AppTab.shift.rawValue, systemImage: AppTab.shift.icon) }
                    .tag(AppTab.shift)

                NavigationStack { CaptureView() }
                    .tabItem { Label(AppTab.capture.rawValue, systemImage: AppTab.capture.icon) }
                    .tag(AppTab.capture)

                NavigationStack { LibraryView() }
                    .tabItem { Label(AppTab.library.rawValue, systemImage: AppTab.library.icon) }
                    .tag(AppTab.library)

                NavigationStack { PracticeView() }
                    .tabItem { Label(AppTab.practice.rawValue, systemImage: AppTab.practice.icon) }
                    .tag(AppTab.practice)

                NavigationStack { ReportView() }
                    .tabItem { Label(AppTab.report.rawValue, systemImage: AppTab.report.icon) }
                    .tag(AppTab.report)
            }
            .tint(theme.tint)
        }
        .environment(\.layoutDirection, .leftToRight)
    }
}
