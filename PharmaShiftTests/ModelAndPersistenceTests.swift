import SwiftData
import UIKit
import XCTest
@testable import PharmaShift

@MainActor
final class ModelAndPersistenceTests: XCTestCase {
    func testAPIKeyNormalizationRemovesPastedWhitespace() {
        XCTAssertEqual("  sk-test\n\t123  ".normalizedAPIKey, "sk-test123")
    }

    func testClasslessDrugCanBecomeMasteredWithoutAClassQuestion() {
        let drug = Drug(scientificName: "Omeprazole", tradeNames: ["Gasec"], dosageForms: ["Capsule"])
        drug.masteryScientificName = true
        drug.masteryTradeName = true
        drug.masteryUse = true
        drug.masteryWarning = true
        drug.masteryCounseling = true
        drug.recalculateConfidence()
        XCTAssertTrue(drug.isMastered)
        XCTAssertEqual(drug.confidenceLevel, .mastered)
        XCTAssertFalse(drug.isIncomplete)
    }

    func testMasteryRequiresAllSixChecks() {
        let drug = Drug(scientificName: "Test", drugClass: "Test class")
        drug.masteryScientificName = true
        drug.masteryTradeName = true
        drug.masteryClass = true
        drug.masteryUse = true
        drug.masteryWarning = true
        drug.recalculateConfidence()
        XCTAssertEqual(drug.masteryCount, 5)
        XCTAssertFalse(drug.isMastered)
        XCTAssertEqual(drug.confidenceLevel, .strong)

        drug.masteryCounseling = true
        drug.recalculateConfidence()
        XCTAssertTrue(drug.isMastered)
        XCTAssertEqual(drug.confidenceLevel, .mastered)
    }

    func testSeenCountOnlyIncrementsOncePerDay() {
        let calendar = Calendar(identifier: .gregorian)
        let day = Date(timeIntervalSince1970: 1_750_000_000)
        let drug = Drug(scientificName: "Test", timesSeen: 0, lastSeenDate: nil)
        drug.markSeen(on: day, calendar: calendar)
        drug.markSeen(on: day.addingTimeInterval(60), calendar: calendar)
        XCTAssertEqual(drug.timesSeen, 1)
    }

    func testStarterImportIsIdempotent() throws {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Drug.self, DrugProduct.self, DrugRelationship.self, ReviewLog.self, ShiftLog.self, EncounterNote.self, TrainingReport.self, LearningProfile.self, DailyActivity.self, configurations: configuration)
        let first = try StarterContent.importIfNeeded(into: container.mainContext)
        let second = try StarterContent.importIfNeeded(into: container.mainContext)
        XCTAssertEqual(first, 12)
        XCTAssertEqual(second, 0)
        XCTAssertEqual(try container.mainContext.fetchCount(FetchDescriptor<Drug>()), 12)
    }

    func testPrivacyValidatorFindsPhoneAndEmail() {
        XCTAssertTrue(PrivacyValidator.containsObviousIdentifier("Call 07701234567"))
        XCTAssertTrue(PrivacyValidator.containsObviousIdentifier("student@example.com"))
        XCTAssertFalse(PrivacyValidator.containsObviousIdentifier("Observed inhaler counseling under supervision"))
    }

    func testCombinedDrugFilters() {
        let drug = Drug(scientificName: "Salbutamol", tradeNames: ["Ventolin"], chapter: .respiratory, drugClass: "SABA", shelfLocation: "A3", nextReviewDate: .distantPast)
        let matching = DrugFilter(searchText: "vent", chapter: Chapter.respiratory.rawValue, drugClass: "saba", shelf: "a3", dueOnly: true)
        XCTAssertTrue(matching.matches(drug))
        var rejected = matching
        rejected.chapter = Chapter.endocrine.rawValue
        XCTAssertFalse(rejected.matches(drug))
    }

    func testCombinationAndBrandProductMetadataAreSearchable() {
        let drug = Drug(scientificName: "Sacubitril + Valsartan", tradeNames: ["Savesto"], chapter: .cardiovascular)
        drug.activeIngredients = ["Sacubitril", "Valsartan"]
        drug.canonicalIngredientKey = IngredientIdentity.canonicalKey(names: drug.activeIngredients)
        let product = DrugProduct(
            productKey: "savesto-50",
            tradeName: "Savesto",
            manufacturer: "Local manufacturer",
            strength: "50 mg",
            marketedStrengthLabel: "50 mg",
            ingredientComponents: [IngredientComponent(name: "Sacubitril", displayStrength: "24 mg"), IngredientComponent(name: "Valsartan", displayStrength: "26 mg")],
            dosageForm: "Tablet",
            profile: drug
        )
        drug.products = [product]
        XCTAssertTrue(DrugFilter(searchText: "sacubitril").matches(drug))
        XCTAssertTrue(DrugFilter(searchText: "26 mg").matches(drug))
        XCTAssertTrue(DrugFilter(searchText: "Savesto 50 mg").matches(drug))
    }

    func testArabicSearchAndFutureReadyDefaults() {
        let drug = Drug(scientificName: "Enalapril", chapter: .cardiovascular)
        drug.arabicExplanation = "يستخدم لعلاج ارتفاع ضغط الدم"
        drug.arabicCounseling = "خذ الدواء في نفس الوقت يومياً"

        XCTAssertTrue(DrugFilter(searchText: "ضغط الدم").matches(drug))
        XCTAssertEqual(drug.halfLifeBand, .unknown)
        XCTAssertEqual(drug.prodrugStatus, .unknown)
        XCTAssertEqual(drug.excretionRoute, .unknown)
        XCTAssertFalse(drug.isImported)
        XCTAssertTrue(drug.isIncomplete)
    }

    func testExpandedLibraryFilters() {
        let drug = Drug(scientificName: "Test", chapter: .respiratory, imageData: nil, isConfusing: true)
        drug.importedSourceName = "DailyMed"
        let filter = DrugFilter(weakOnly: true, incompleteOnly: true, missingImageOnly: true, importedOnly: true)
        XCTAssertTrue(filter.matches(drug))
    }

    func testSystemDashboardMetricsUsesAllSixMasteryChecks() {
        let first = Drug(scientificName: "A", chapter: .cardiovascular)
        first.masteryScientificName = true
        first.masteryTradeName = true
        first.masteryClass = true
        let second = Drug(scientificName: "B", chapter: .cardiovascular)
        second.masteryScientificName = true
        second.masteryTradeName = true
        second.masteryClass = true
        second.masteryUse = true
        second.masteryWarning = true
        second.masteryCounseling = true
        second.recalculateConfidence()

        let metrics = SystemDashboardMetrics(chapter: .cardiovascular, drugs: [first, second], dueCount: 1)
        XCTAssertEqual(metrics.masteredCount, 1)
        XCTAssertEqual(metrics.masteryProgress, 0.75, accuracy: 0.001)
        XCTAssertEqual(metrics.dueCount, 1)
    }

    func testImagePipelineCreatesCompressedCardAndThumbnail() throws {
        let image = UIGraphicsImageRenderer(size: CGSize(width: 2400, height: 1800)).image { context in
            UIColor.systemTeal.setFill()
            context.cgContext.fill(CGRect(x: 0, y: 0, width: 2400, height: 1800))
        }
        let payload = try ImageCompressor.payload(from: image)
        let full = try XCTUnwrap(UIImage(data: payload.imageData))
        let thumbnail = try XCTUnwrap(UIImage(data: payload.thumbnailData))
        XCTAssertLessThanOrEqual(max(full.size.width, full.size.height), 1600)
        XCTAssertEqual(full.size.width / full.size.height, 4.0 / 3.0, accuracy: 0.01)
        XCTAssertEqual(thumbnail.size.width, 256)
        XCTAssertEqual(thumbnail.size.height, 256)
    }

    func testPharmacologyLogarithmicMappingAndClamping() {
        for scale in PharmacologyScale.allCases {
            XCTAssertEqual(scale.normalized(scale.bounds.lowerBound), 0, accuracy: 0.0001)
            XCTAssertEqual(scale.normalized(scale.bounds.upperBound), 1, accuracy: 0.0001)
            XCTAssertEqual(scale.normalized(scale.bounds.lowerBound / 10), 0, accuracy: 0.0001)
            XCTAssertEqual(scale.normalized(scale.bounds.upperBound * 10), 1, accuracy: 0.0001)
            XCTAssertEqual(scale.value(at: 0.5), sqrt(scale.bounds.lowerBound * scale.bounds.upperBound), accuracy: 0.001)
        }
    }

    func testImageIODownsamplingBeforeEditing() throws {
        let image = UIGraphicsImageRenderer(size: CGSize(width: 4_800, height: 3_600)).image { context in
            UIColor.systemBlue.setFill()
            context.cgContext.fill(CGRect(x: 0, y: 0, width: 4_800, height: 3_600))
        }
        let data = try XCTUnwrap(image.jpegData(compressionQuality: 0.9))
        let decoded = try ImageCompressor.image(from: data, maxDimension: 1_200)
        XCTAssertLessThanOrEqual(max(decoded.size.width, decoded.size.height), 1_200)
    }

    func testFutureReadyFieldsPersist() throws {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Drug.self, DrugProduct.self, DrugRelationship.self, ReviewLog.self, ShiftLog.self, EncounterNote.self, TrainingReport.self, LearningProfile.self, DailyActivity.self, configurations: configuration)
        let drug = Drug(scientificName: "Ramipril", chapter: .cardiovascular)
        drug.mechanism = "ACE inhibition"
        drug.halfLifeBand = .long
        drug.halfLifeHours = 35
        drug.onsetMinutes = 30
        drug.durationHours = 12
        drug.arabicExplanation = "دواء لتدريب البطاقة"
        drug.sourceURL = "https://example.test/ramipril"
        drug.importedSourceName = "Mock provider"
        drug.mechanismKeywords = ["ACE inhibition"]
        drug.pkMemoryLineArabic = "PK memory"
        drug.mustKnow = ["Ramipril = ACE inhibitor"]
        drug.flashcards = ["Class?\tACE inhibitor"]
        drug.sourceNeedsReview = true
        drug.sourceMissingFields = ["local leaflet"]
        drug.additionalImageData = [Data([1, 2, 3])]
        drug.additionalThumbnailData = [Data([4])]
        container.mainContext.insert(drug)
        try container.mainContext.save()

        let saved = try XCTUnwrap(container.mainContext.fetch(FetchDescriptor<Drug>()).first)
        XCTAssertEqual(saved.mechanism, "ACE inhibition")
        XCTAssertEqual(saved.halfLifeBand, .long)
        XCTAssertEqual(saved.halfLifeHours, 35)
        XCTAssertEqual(saved.onsetMinutes, 30)
        XCTAssertEqual(saved.durationHours, 12)
        XCTAssertEqual(saved.arabicExplanation, "دواء لتدريب البطاقة")
        XCTAssertTrue(saved.isImported)
        XCTAssertEqual(saved.mechanismKeywords, ["ACE inhibition"])
        XCTAssertEqual(saved.pkMemoryLineArabic, "PK memory")
        XCTAssertEqual(saved.mustKnow, ["Ramipril = ACE inhibitor"])
        XCTAssertEqual(saved.flashcards, ["Class?\tACE inhibitor"])
        XCTAssertTrue(saved.sourceNeedsReview)
        XCTAssertEqual(saved.sourceMissingFields, ["local leaflet"])
        XCTAssertEqual(saved.additionalImageData, [Data([1, 2, 3])])
        XCTAssertEqual(saved.additionalThumbnailData, [Data([4])])
    }

    func testIncompleteShiftRestoresAndDeletedDrugLeavesReviewSnapshot() throws {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Drug.self, DrugProduct.self, DrugRelationship.self, ReviewLog.self, ShiftLog.self, EncounterNote.self, TrainingReport.self, LearningProfile.self, DailyActivity.self, configurations: configuration)
        let context = container.mainContext
        let drug = Drug(scientificName: "Test Drug")
        let log = ReviewLog(drug: drug, drugNameSnapshot: drug.displayName, questionType: .use, rating: .correct, scoreBefore: 0, scoreAfter: 1)
        let shift = ShiftLog(chapterFocus: .other)
        context.insert(drug); context.insert(log); context.insert(shift)
        try context.save()

        XCTAssertEqual(try context.fetch(FetchDescriptor<ShiftLog>()).filter { !$0.isCompleted }.count, 1)
        context.delete(drug)
        try context.save()
        let verificationContext = ModelContext(container)
        let retainedLog = try XCTUnwrap(verificationContext.fetch(FetchDescriptor<ReviewLog>()).first)
        XCTAssertEqual(retainedLog.drugNameSnapshot, "Test Drug")
        XCTAssertEqual(try verificationContext.fetchCount(FetchDescriptor<Drug>()), 0)
    }

    func testIngredientIdentityDeduplicatesBrandAndCaseButKeepsCombinationsDistinct() {
        XCTAssertEqual(IngredientIdentity.canonicalKey(names: ["Omeprazole"]), IngredientIdentity.canonicalKey(names: ["  OMEPRAZOLE "]))
        XCTAssertNotEqual(IngredientIdentity.canonicalKey(names: ["Amoxicillin"]), IngredientIdentity.canonicalKey(names: ["Amoxicillin", "Clavulanate"]))
        XCTAssertEqual(IngredientIdentity.canonicalKey(names: ["anything"], rxNormIDs: ["7646"]), "rxcui:7646")
    }

    func testWHOWeightReferenceStopsAfterTenAndDoseCalculatorShowsEquation() throws {
        XCTAssertEqual(try XCTUnwrap(PediatricWeightReference.medianWeightKG(ageMonths: 60, sex: .female)), 18.2193, accuracy: 0.0001)
        XCTAssertNil(PediatricWeightReference.medianWeightKG(ageMonths: 121, sex: .male))
        let regimen = DoseRegimen(indication: "Example infection", population: .pediatric, formula: .mgPerKgPerDay, amountPerKG: 30, dividedDoses: 3, maximumDailyDoseMG: 1_000)
        let input = DosePatientInput(ageMonths: 60, sexAtBirth: .female, measuredWeightKG: nil, estimatedWeightKG: 18.2193, heightCM: nil, renalFunction: "Normal", hepaticFunction: "Normal", isPregnant: false)
        let result = try DoseCalculator.calculate(regimen: regimen, input: input)
        XCTAssertEqual(result.dosePerAdministrationMG, 182.193, accuracy: 0.001)
        XCTAssertEqual(result.totalDailyDoseMG, 546.579, accuracy: 0.001)
        XCTAssertTrue(result.equation.contains("30 mg/kg/day"))
        XCTAssertTrue(result.usedEstimatedWeight)
    }

    func testDoseCalculatorRequiresMeasuredWeightWhenRegimenSaysSo() {
        let regimen = DoseRegimen(indication: "Narrow therapeutic index", population: .pediatric, formula: .mgPerKgPerDose, amountPerKG: 2, requiresMeasuredWeight: true)
        let input = DosePatientInput(ageMonths: 24, sexAtBirth: .male, measuredWeightKG: nil, estimatedWeightKG: 12, heightCM: nil, renalFunction: "Normal", hepaticFunction: "Normal", isPregnant: false)
        XCTAssertThrowsError(try DoseCalculator.calculate(regimen: regimen, input: input)) { XCTAssertEqual($0 as? DoseCalculatorError, .weightRequired) }
    }

    func testManualBrandAddPreservesActiveDrugKnowledgeAndRequiresPhoto() throws {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Drug.self, DrugProduct.self, DrugRelationship.self, ReviewLog.self, ShiftLog.self, EncounterNote.self, TrainingReport.self, LearningProfile.self, DailyActivity.self, configurations: configuration)
        let context = container.mainContext
        let drug = Drug(scientificName: "Amoxicillin + Clavulanate", chapter: .antibiotics)
        drug.activeIngredients = ["Amoxicillin", "Clavulanate"]
        drug.canonicalIngredientKey = IngredientIdentity.canonicalKey(names: drug.activeIngredients)
        drug.mechanism = "Cell-wall inhibition plus beta-lactamase inhibition"
        drug.warnings = ["Check penicillin allergy"]
        context.insert(drug)

        var missingPhoto = DrugBrandService.draft(for: drug)
        missingPhoto.tradeName = "Augmentin"
        XCTAssertThrowsError(try DrugBrandService.add(missingPhoto, to: drug, context: context)) {
            XCTAssertEqual($0 as? DrugLibraryMutationError, .packagePhotoRequired)
        }

        var draft = missingPhoto
        draft.manufacturer = "GSK"
        draft.marketedStrengthLabel = "625 mg"
        draft.ingredientComponents = [
            IngredientComponent(name: "Amoxicillin", displayStrength: "500 mg"),
            IngredientComponent(name: "Clavulanate", displayStrength: "125 mg")
        ]
        draft.dosageForm = "Tablet"
        draft.imageData = Data([1, 2, 3])
        let product = try DrugBrandService.add(draft, to: drug, context: context)

        XCTAssertEqual(product.tradeName, "Augmentin")
        XCTAssertEqual(product.ingredientComponents.map(\.displayStrength), ["500 mg", "125 mg"])
        XCTAssertEqual(drug.effectiveTradeNames, ["Augmentin"])
        XCTAssertEqual(drug.mechanism, "Cell-wall inhibition plus beta-lactamase inhibition")
        XCTAssertEqual(drug.warnings, ["Check penicillin allergy"])
        XCTAssertEqual(drug.activeIngredients, ["Amoxicillin", "Clavulanate"])
    }

    func testDeletingBrandLeavesProfileAndInvalidatesPracticePack() throws {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Drug.self, DrugProduct.self, DrugRelationship.self, ReviewLog.self, ShiftLog.self, EncounterNote.self, TrainingReport.self, LearningProfile.self, DailyActivity.self, configurations: configuration)
        let context = container.mainContext
        let drug = Drug(scientificName: "Omeprazole")
        drug.activeIngredients = ["Omeprazole"]
        drug.canonicalIngredientKey = IngredientIdentity.canonicalKey(names: drug.activeIngredients)
        context.insert(drug)
        var draft = DrugBrandService.draft(for: drug)
        draft.tradeName = "Gasec"
        draft.imageData = Data([9])
        let product = try DrugBrandService.add(draft, to: drug, context: context)
        AIPracticePackStore.save(AIPracticePack(generatedAt: .now, libraryFingerprint: "before-delete", questions: []))

        try DrugBrandService.delete(product, from: drug, context: context)

        XCTAssertEqual(try context.fetchCount(FetchDescriptor<Drug>()), 1)
        XCTAssertEqual(try context.fetchCount(FetchDescriptor<DrugProduct>()), 0)
        XCTAssertTrue(drug.effectiveTradeNames.isEmpty)
        XCTAssertNil(AIPracticePackStore.load())
    }

    func testLegacyTradeNamesBackfillToProductsIdempotently() throws {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Drug.self, DrugProduct.self, DrugRelationship.self, ReviewLog.self, ShiftLog.self, EncounterNote.self, TrainingReport.self, LearningProfile.self, DailyActivity.self, configurations: configuration)
        let context = container.mainContext
        let drug = Drug(scientificName: "Cetirizine", tradeNames: ["Zyrtec", "Cetrin"], dosageForms: ["Tablet"], strengths: ["10 mg"])
        context.insert(drug)
        try context.save()

        try DrugLibraryMigrationService.runIfNeeded(context: context)
        try DrugLibraryMigrationService.runIfNeeded(context: context)

        let products = try context.fetch(FetchDescriptor<DrugProduct>()).filter { $0.profile?.id == drug.id }
        XCTAssertEqual(Set(products.map(\.tradeName)), Set(["Zyrtec", "Cetrin"]))
        XCTAssertEqual(products.count, 2)
        XCTAssertEqual(Set(drug.effectiveTradeNames), Set(["Zyrtec", "Cetrin"]))
    }

    func testProfileDeletionKeepsOrErasesLearningHistoryByPolicy() throws {
        func makeContainer() throws -> ModelContainer {
            try ModelContainer(for: Drug.self, DrugProduct.self, DrugRelationship.self, ReviewLog.self, ShiftLog.self, EncounterNote.self, TrainingReport.self, LearningProfile.self, DailyActivity.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        }

        let keepContainer = try makeContainer()
        let keepContext = keepContainer.mainContext
        let keptDrug = Drug(scientificName: "Metformin")
        let otherDrug = Drug(scientificName: "Cimetidine")
        let relationship = DrugRelationship(relationshipKey: "metformin-cimetidine", kind: .interaction, summary: "Example", sourceDrug: keptDrug, targetDrug: otherDrug)
        let review = ReviewLog(drug: keptDrug, drugNameSnapshot: keptDrug.displayName, questionType: .use, rating: .correct, scoreBefore: 1, scoreAfter: 2)
        let encounter = EncounterNote(topic: "Counseling", relatedDrug: keptDrug)
        keepContext.insert(keptDrug); keepContext.insert(otherDrug); keepContext.insert(relationship); keepContext.insert(review); keepContext.insert(encounter)
        try keepContext.save()
        XCTAssertEqual(try DrugLibraryMutationService.impact(of: keptDrug, context: keepContext), DrugDeletionImpact(brandCount: 0, relationshipCount: 1, reviewCount: 1, encounterCount: 1))

        try DrugLibraryMutationService.delete(keptDrug, historyPolicy: .keepHistory, context: keepContext)

        XCTAssertEqual(try keepContext.fetchCount(FetchDescriptor<Drug>()), 1)
        XCTAssertEqual(try keepContext.fetchCount(FetchDescriptor<DrugRelationship>()), 0)
        XCTAssertEqual(try keepContext.fetchCount(FetchDescriptor<ReviewLog>()), 1)
        XCTAssertEqual(try keepContext.fetchCount(FetchDescriptor<EncounterNote>()), 1)
        XCTAssertNil(try XCTUnwrap(keepContext.fetch(FetchDescriptor<ReviewLog>()).first).drug)
        XCTAssertEqual(try XCTUnwrap(keepContext.fetch(FetchDescriptor<ReviewLog>()).first).drugNameSnapshot, "Metformin")
        XCTAssertNil(try XCTUnwrap(keepContext.fetch(FetchDescriptor<EncounterNote>()).first).relatedDrug)

        let eraseContainer = try makeContainer()
        let eraseContext = eraseContainer.mainContext
        let erasedDrug = Drug(scientificName: "Warfarin")
        eraseContext.insert(erasedDrug)
        eraseContext.insert(ReviewLog(drug: erasedDrug, drugNameSnapshot: erasedDrug.displayName, questionType: .warning, rating: .wrong, scoreBefore: 1, scoreAfter: 0))
        eraseContext.insert(EncounterNote(topic: "Interaction", relatedDrug: erasedDrug))
        try eraseContext.save()

        try DrugLibraryMutationService.delete(erasedDrug, historyPolicy: .eraseHistory, context: eraseContext)

        XCTAssertEqual(try eraseContext.fetchCount(FetchDescriptor<Drug>()), 0)
        XCTAssertEqual(try eraseContext.fetchCount(FetchDescriptor<ReviewLog>()), 0)
        XCTAssertEqual(try eraseContext.fetchCount(FetchDescriptor<EncounterNote>()), 0)
    }
}
