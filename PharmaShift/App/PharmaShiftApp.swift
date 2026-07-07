import SwiftData
import SwiftUI

@main
struct PharmaShiftApp: App {
    @State private var theme = AppTheme()

    var body: some Scene {
        WindowGroup {
            AppShell()
                .environment(theme)
                .environment(ReviewScheduler())
        }
        .modelContainer(for: [Drug.self, ReviewLog.self, ShiftLog.self, EncounterNote.self, TrainingReport.self, LearningProfile.self, DailyActivity.self])
    }
}
