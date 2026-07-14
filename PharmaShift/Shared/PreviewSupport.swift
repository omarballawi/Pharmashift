import SwiftData
import SwiftUI

@MainActor
private enum PreviewData {
    static let container: ModelContainer = {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Drug.self, DrugProduct.self, DrugRelationship.self, ReviewLog.self, ShiftLog.self, EncounterNote.self, TrainingReport.self, LearningProfile.self, DailyActivity.self, configurations: configuration)
        let context = container.mainContext
        let known = Drug(
            scientificName: "Salbutamol",
            tradeNames: ["Ventolin"],
            chapter: .respiratory,
            drugClass: "SABA",
            dosageForms: ["Inhaler"],
            strengths: ["100 micrograms/dose"],
            indications: ["Relief of bronchospasm"],
            warnings: ["Worsening breathing needs immediate pharmacist assessment."],
            counselingSentence: "Ask the pharmacist to check inhaler technique.",
            nextReviewDate: .distantPast,
            notes: "مراجعة طريقة استخدام البخاخ",
            safetyFlags: [.children, .severeSymptoms]
        )
        let unknown = Drug(captureLabel: "Blue box — shelf 3", isUnknown: true)
        let shift = ShiftLog(chapterFocus: .respiratory)
        context.insert(known); context.insert(unknown); context.insert(shift)
        return container
    }()
}

#Preview("Empty app") {
    AppShell()
        .environment(AppTheme())
        .environment(ReviewScheduler())
        .modelContainer(for: [Drug.self, DrugProduct.self, DrugRelationship.self, ReviewLog.self, ShiftLog.self, EncounterNote.self, TrainingReport.self, LearningProfile.self, DailyActivity.self], inMemory: true)
}

#Preview("Active shift") {
    NavigationStack { ShiftView() }
        .environment(AppTheme())
        .environment(ReviewScheduler())
        .modelContainer(PreviewData.container)
}

#Preview("Library: due, unknown, Arabic note") {
    NavigationStack { LibraryView() }
        .environment(AppTheme())
        .environment(AppNavigation())
        .environment(ReviewScheduler())
        .modelContainer(PreviewData.container)
}

#Preview("Systems dashboard") {
    NavigationStack { HomeView() }
        .environment(AppTheme())
        .environment(AppNavigation())
        .environment(ReviewScheduler())
        .modelContainer(PreviewData.container)
}

#Preview("Safety drug card") {
    let drug = try! PreviewData.container.mainContext.fetch(FetchDescriptor<Drug>()).first { !$0.safetyFlags.isEmpty }!
    NavigationStack { DrugDetailView(drug: drug) }
        .environment(AppTheme())
        .environment(ReviewScheduler())
        .modelContainer(PreviewData.container)
}

#Preview("Report dashboard") {
    NavigationStack { ReportView() }
        .environment(AppTheme())
        .environment(ReviewScheduler())
        .modelContainer(PreviewData.container)
}
