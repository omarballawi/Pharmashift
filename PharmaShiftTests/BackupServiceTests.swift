import SwiftData
import XCTest
@testable import PharmaShift

@MainActor
final class BackupServiceTests: XCTestCase {
    func testCompleteBackupRoundTripPreservesRelationshipsImagesAndArabic() throws {
        let source = try makeContainer()
        let context = source.mainContext
        let drug = Drug(scientificName: "Metformin", tradeNames: ["Glucophage"], chapter: .endocrine, imageData: Data([1, 2, 3]))
        drug.thumbnailData = Data([4, 5])
        drug.additionalImageData = [Data([6, 7, 8]), Data([9, 10, 11])]
        drug.additionalThumbnailData = [Data([12]), Data([13])]
        drug.arabicExplanation = "يستخدم لعلاج السكري"
        drug.notes = "ملاحظة شخصية"
        drug.halfLifeHours = 6.2
        drug.masteryScientificName = true
        drug.generatedReviewQuestions = [
            GeneratedReviewQuestion(prompt: "What class is metformin?", choices: ["Biguanide", "Sulfonylurea", "DPP-4 inhibitor", "GLP-1 agonist"], correctAnswer: "Biguanide", explanation: "Metformin is a biguanide.", questionType: .drugClass, relatedField: "class")
        ]
        drug.atomicNotes = [AtomicDrugNote(kindRaw: AtomicNoteKind.memoryTrick.rawValue, text: "Remember the biguanide link", linkedField: "Class")]
        drug.reviewQuestionsNeedRegeneration = true
        let review = ReviewLog(drug: drug, drugNameSnapshot: drug.displayName, questionType: .use, rating: .correct, scoreBefore: 1, scoreAfter: 2)
        let shift = ShiftLog(chapterFocus: .endocrine)
        shift.whatILearned = "تعلمت اليوم"
        let encounter = EncounterNote(topic: "Counseling", relatedDrug: drug, whatILearned: "تعليم عربي", privacyConfirmed: true)
        let report = TrainingReport(periodStart: .now.addingTimeInterval(-86_400), periodEnd: .now)
        report.trainingSummary = "ملخص التدريب"
        let profile = LearningProfile(currentStreak: 3, longestStreak: 5, completedSessions: 7, badges: ["First Five"])
        let activity = DailyActivity(day: .now, sessionsCompleted: 1, questionsAnswered: 5, correctAnswers: 4, missionCompleted: true)
        context.insert(drug); context.insert(review); context.insert(shift); context.insert(encounter); context.insert(report); context.insert(profile); context.insert(activity)
        try context.save()

        let encoded = try BackupService.encode(BackupService.makeBackup(context: context, includesImages: true))
        let decoded = try BackupService.decode(encoded)
        XCTAssertTrue(decoded.includesImages)

        let destination = try makeContainer()
        let summary = try BackupService.restore(decoded, mode: .replace, context: destination.mainContext)
        XCTAssertEqual(summary.counts, decoded.counts)
        let restoredDrug = try XCTUnwrap(destination.mainContext.fetch(FetchDescriptor<Drug>()).first)
        XCTAssertEqual(restoredDrug.id, drug.id)
        XCTAssertEqual(restoredDrug.imageData, Data([1, 2, 3]))
        XCTAssertEqual(restoredDrug.thumbnailData, Data([4, 5]))
        XCTAssertEqual(restoredDrug.additionalImageData, [Data([6, 7, 8]), Data([9, 10, 11])])
        XCTAssertEqual(restoredDrug.additionalThumbnailData, [Data([12]), Data([13])])
        XCTAssertEqual(restoredDrug.arabicExplanation, "يستخدم لعلاج السكري")
        XCTAssertEqual(restoredDrug.notes, "ملاحظة شخصية")
        XCTAssertEqual(restoredDrug.halfLifeHours, 6.2)
        XCTAssertTrue(restoredDrug.masteryScientificName)
        XCTAssertEqual(restoredDrug.generatedReviewQuestions, drug.generatedReviewQuestions)
        XCTAssertEqual(restoredDrug.atomicNotes, drug.atomicNotes)
        XCTAssertTrue(restoredDrug.reviewQuestionsNeedRegeneration)
        XCTAssertEqual(try XCTUnwrap(destination.mainContext.fetch(FetchDescriptor<ReviewLog>()).first).drug?.id, drug.id)
        XCTAssertEqual(try XCTUnwrap(destination.mainContext.fetch(FetchDescriptor<EncounterNote>()).first).relatedDrug?.id, drug.id)
        XCTAssertEqual(try XCTUnwrap(destination.mainContext.fetch(FetchDescriptor<ShiftLog>()).first).whatILearned, "تعلمت اليوم")
        XCTAssertEqual(try XCTUnwrap(destination.mainContext.fetch(FetchDescriptor<TrainingReport>()).first).trainingSummary, "ملخص التدريب")
        XCTAssertEqual(try XCTUnwrap(destination.mainContext.fetch(FetchDescriptor<LearningProfile>()).first).currentStreak, 3)
        XCTAssertTrue(try XCTUnwrap(destination.mainContext.fetch(FetchDescriptor<DailyActivity>()).first).missionCompleted)
    }

    func testMergeIsIdempotentAndLightweightBackupPreservesLocalImages() throws {
        let source = try makeContainer()
        let id = UUID()
        let sourceDrug = Drug(id: id, scientificName: "Updated name", imageData: Data([1]))
        source.mainContext.insert(sourceDrug)
        try source.mainContext.save()
        let backup = try BackupService.makeBackup(context: source.mainContext, includesImages: false)

        let destination = try makeContainer()
        let local = Drug(id: id, scientificName: "Old name", imageData: Data([9, 9]))
        destination.mainContext.insert(local)
        try destination.mainContext.save()
        _ = try BackupService.restore(backup, mode: .merge, context: destination.mainContext)
        _ = try BackupService.restore(backup, mode: .merge, context: destination.mainContext)

        let drugs = try destination.mainContext.fetch(FetchDescriptor<Drug>())
        XCTAssertEqual(drugs.count, 1)
        XCTAssertEqual(drugs[0].scientificName, "Updated name")
        XCTAssertEqual(drugs[0].imageData, Data([9, 9]))
    }

    func testReplaceRemovesRecordsNotPresentInBackup() throws {
        let source = try makeContainer()
        source.mainContext.insert(Drug(scientificName: "Only backup drug"))
        try source.mainContext.save()
        let backup = try BackupService.makeBackup(context: source.mainContext, includesImages: false)

        let destination = try makeContainer()
        destination.mainContext.insert(Drug(scientificName: "Delete me"))
        destination.mainContext.insert(ShiftLog())
        try destination.mainContext.save()
        _ = try BackupService.restore(backup, mode: .replace, context: destination.mainContext)
        XCTAssertEqual(try destination.mainContext.fetch(FetchDescriptor<Drug>()).map(\.scientificName), ["Only backup drug"])
        XCTAssertEqual(try destination.mainContext.fetchCount(FetchDescriptor<ShiftLog>()), 0)
    }

    func testMalformedAndNewerBackupsFailBeforeRestore() throws {
        XCTAssertThrowsError(try BackupService.decode(Data("not json".utf8))) { XCTAssertEqual($0 as? BackupError, .malformed) }
        let container = try makeContainer()
        var backup = try BackupService.makeBackup(context: container.mainContext, includesImages: false)
        backup.schemaVersion = PharmaShiftBackup.currentSchemaVersion + 1
        let data = try BackupService.encode(backup)
        XCTAssertThrowsError(try BackupService.decode(data)) { XCTAssertEqual($0 as? BackupError, .newerVersion(PharmaShiftBackup.currentSchemaVersion + 1)) }
    }

    func testCSVAndTrainingTextAreUTF8AndPreserveArabic() throws {
        let container = try makeContainer()
        let drug = Drug(scientificName: "Test, Drug")
        drug.arabicExplanation = "شرح عربي"
        let report = TrainingReport(periodStart: .now, periodEnd: .now)
        report.trainingSummary = "ملخص عربي"
        container.mainContext.insert(drug); container.mainContext.insert(report)
        try container.mainContext.save()
        let csv = try XCTUnwrap(String(data: BackupService.drugCSV(context: container.mainContext), encoding: .utf8))
        let text = try XCTUnwrap(String(data: BackupService.trainingReportText(context: container.mainContext), encoding: .utf8))
        XCTAssertTrue(csv.contains("\"Test, Drug\""))
        XCTAssertTrue(csv.contains("شرح عربي"))
        XCTAssertTrue(text.contains("ملخص عربي"))
    }

    private func makeContainer() throws -> ModelContainer {
        try ModelContainer(
            for: Drug.self, ReviewLog.self, ShiftLog.self, EncounterNote.self, TrainingReport.self, LearningProfile.self, DailyActivity.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
    }
}
