import Foundation

enum ReportBuilder {
    static func populate(
        _ report: TrainingReport,
        drugs: [Drug],
        reviews: [ReviewLog],
        shifts: [ShiftLog],
        encounters: [EncounterNote],
        calendar: Calendar = .current
    ) {
        let endExclusive = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: report.periodEnd)) ?? report.periodEnd
        let inPeriod: (Date) -> Bool = { $0 >= calendar.startOfDay(for: report.periodStart) && $0 < endExclusive }
        let periodShifts = shifts.filter { inPeriod($0.date) && $0.isCompleted }
        let periodReviews = reviews.filter { inPeriod($0.date) }
        let periodEncounters = encounters.filter { inPeriod($0.date) }
        let periodDrugs = drugs.filter { inPeriod($0.dateAdded) }

        report.trainingSummary = "Completed \(periodShifts.count) shifts, added \(periodDrugs.count) drugs, and completed \(periodReviews.count) reviews."
        report.skillsLearned = uniqueLines(periodShifts.map(\.whatILearned) + periodEncounters.map(\.whatILearned))
        report.categoriesStudied = groupedCounts(drugs.map(\.chapterRaw))
        report.dosageFormsSeen = uniqueLines(drugs.flatMap(\.dosageForms))
        report.counselingPoints = uniqueLines(drugs.map(\.counselingSentence))
        report.pharmacistQuestions = uniqueLines(periodShifts.flatMap(\.pharmacistQuestions))
        report.challenges = uniqueLines(periodShifts.flatMap(\.confusingDrugs) + periodShifts.map(\.notes))
        report.notesAndRecommendations = uniqueLines(periodShifts.map(\.tomorrowReview))
        report.masteredDrugs = masteredByChapter(drugs.filter(\.isMastered))
        report.generatedAt = .now
        report.updatedAt = .now
    }

    static func text(for report: TrainingReport) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return """
        PHARMASHIFT — FINAL TRAINING REPORT
        Period: \(formatter.string(from: report.periodStart)) – \(formatter.string(from: report.periodEnd))

        TRAINING PERIOD SUMMARY
        \(report.trainingSummary)

        SKILLS LEARNED
        \(report.skillsLearned)

        DRUG CATEGORIES STUDIED
        \(report.categoriesStudied)

        COMMON DOSAGE FORMS SEEN
        \(report.dosageFormsSeen)

        IMPORTANT COUNSELING POINTS LEARNED
        \(report.counselingPoints)

        PHARMACIST QUESTIONS ASKED
        \(report.pharmacistQuestions)

        CHALLENGES FACED
        \(report.challenges)

        NOTES AND RECOMMENDATIONS
        \(report.notesAndRecommendations)

        MASTERED DRUGS BY CHAPTER
        \(report.masteredDrugs)
        """
    }

    private static func uniqueLines(_ values: [String]) -> String {
        let values = values.flatMap(\.splitLines)
        var seen = Set<String>()
        let unique = values.filter { seen.insert($0.localizedLowercase).inserted }
        return unique.isEmpty ? "No entries recorded." : unique.map { "• \($0)" }.joined(separator: "\n")
    }

    private static func groupedCounts(_ values: [String]) -> String {
        let counts = Dictionary(grouping: values.filter { !$0.isEmpty }, by: { $0 }).mapValues(\.count)
        return counts.sorted { $0.key < $1.key }.map { "• \($0.key): \($0.value)" }.joined(separator: "\n")
    }

    private static func masteredByChapter(_ drugs: [Drug]) -> String {
        guard !drugs.isEmpty else { return "No drugs have reached 6/6 mastery yet." }
        return Dictionary(grouping: drugs, by: \.chapterRaw)
            .sorted { $0.key < $1.key }
            .map { chapter, drugs in
                "\(chapter)\n" + drugs.sorted { $0.displayName < $1.displayName }.map { "• \($0.displayName)" }.joined(separator: "\n")
            }
            .joined(separator: "\n\n")
    }
}
