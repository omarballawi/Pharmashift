import Foundation
import SwiftData

struct BrandProductDraft: Equatable {
    var tradeName = ""
    var manufacturer = ""
    var marketedStrengthLabel = ""
    var ingredientComponents: [IngredientComponent] = []
    var dosageForm = ""
    var route = ""
    var country = ""
    var shelfLocation = ""
    var imageData: Data?
    var additionalImageData: [Data] = []
    var thumbnailData: Data?
    var additionalThumbnailData: [Data] = []

    var hasPhoto: Bool { imageData != nil || !additionalImageData.isEmpty }
}

enum DrugDeletionHistoryPolicy: String, CaseIterable, Identifiable {
    case keepHistory
    case eraseHistory

    var id: String { rawValue }
}

struct DrugDeletionImpact: Equatable {
    var brandCount: Int
    var relationshipCount: Int
    var reviewCount: Int
    var encounterCount: Int
}

enum DrugLibraryMutationError: LocalizedError, Equatable {
    case brandNameRequired
    case packagePhotoRequired
    case duplicateBrand

    var errorDescription: String? {
        switch self {
        case .brandNameRequired:
            "Enter the brand name printed on the package."
        case .packagePhotoRequired:
            "Add at least one package photo."
        case .duplicateBrand:
            "This brand and package strength are already in the profile."
        }
    }
}

@MainActor
enum DrugBrandService {
    static func draft(for drug: Drug) -> BrandProductDraft {
        BrandProductDraft(
            ingredientComponents: drug.ingredientNames.map { IngredientComponent(name: $0) },
            dosageForm: drug.dosageForms.first ?? "",
            route: drug.routes.first ?? "",
            shelfLocation: drug.shelfLocation
        )
    }

    static func draft(for product: DrugProduct, in drug: Drug) -> BrandProductDraft {
        BrandProductDraft(
            tradeName: product.tradeName,
            manufacturer: product.manufacturer,
            marketedStrengthLabel: product.marketedStrengthLabel,
            ingredientComponents: product.ingredientComponents.isEmpty
                ? drug.ingredientNames.map { IngredientComponent(name: $0) }
                : product.ingredientComponents,
            dosageForm: product.dosageForm,
            route: product.route,
            country: product.country,
            shelfLocation: product.shelfLocation,
            imageData: product.imageData,
            additionalImageData: product.additionalImageData,
            thumbnailData: product.thumbnailData,
            additionalThumbnailData: product.additionalThumbnailData
        )
    }

    @discardableResult
    static func add(_ draft: BrandProductDraft, to drug: Drug, context: ModelContext) throws -> DrugProduct {
        let tradeName = draft.tradeName.trimmed
        guard !tradeName.isEmpty else { throw DrugLibraryMutationError.brandNameRequired }
        guard draft.hasPhoto else { throw DrugLibraryMutationError.packagePhotoRequired }

        let marketedStrength = draft.marketedStrengthLabel.trimmed
        let ingredientKey = drug.canonicalIngredientKey.trimmed.isEmpty
            ? IngredientIdentity.canonicalKey(names: drug.ingredientNames, rxNormIDs: drug.rxNormConceptIDs)
            : drug.canonicalIngredientKey
        let productKey = IngredientIdentity.productKey(
            tradeName: tradeName,
            manufacturer: draft.manufacturer,
            strength: marketedStrength,
            dosageForm: draft.dosageForm,
            ingredientKey: ingredientKey
        )
        guard !drug.products.contains(where: { $0.productKey == productKey }) else {
            throw DrugLibraryMutationError.duplicateBrand
        }

        let product = DrugProduct(
            productKey: productKey,
            tradeName: tradeName,
            manufacturer: draft.manufacturer.trimmed,
            strength: marketedStrength,
            marketedStrengthLabel: marketedStrength,
            ingredientComponents: normalizedComponents(draft.ingredientComponents, for: drug),
            dosageForm: draft.dosageForm.trimmed,
            route: draft.route.trimmed,
            country: draft.country.trimmed,
            shelfLocation: draft.shelfLocation.trimmed,
            imageData: draft.imageData,
            additionalImageData: draft.additionalImageData,
            thumbnailData: draft.thumbnailData,
            additionalThumbnailData: draft.additionalThumbnailData,
            sourceName: "Manual brand entry",
            profile: drug
        )
        context.insert(product)
        drug.products.append(product)
        synchronizeCompatibilityCache(for: drug)
        invalidateDerivedPractice(for: drug)
        try context.save()
        return product
    }

    static func delete(_ product: DrugProduct, from drug: Drug, context: ModelContext) throws {
        drug.products.removeAll { $0.id == product.id }
        product.profile = nil
        context.delete(product)
        synchronizeCompatibilityCache(for: drug)
        invalidateDerivedPractice(for: drug)
        try context.save()
    }

    static func update(_ product: DrugProduct, with draft: BrandProductDraft, in drug: Drug, context: ModelContext) throws {
        let tradeName = draft.tradeName.trimmed
        guard !tradeName.isEmpty else { throw DrugLibraryMutationError.brandNameRequired }
        let marketedStrength = draft.marketedStrengthLabel.trimmed
        let ingredientKey = drug.canonicalIngredientKey.trimmed.isEmpty
            ? IngredientIdentity.canonicalKey(names: drug.ingredientNames, rxNormIDs: drug.rxNormConceptIDs)
            : drug.canonicalIngredientKey
        let productKey = IngredientIdentity.productKey(
            tradeName: tradeName,
            manufacturer: draft.manufacturer,
            strength: marketedStrength,
            dosageForm: draft.dosageForm,
            ingredientKey: ingredientKey
        )
        guard !drug.products.contains(where: { $0.id != product.id && $0.productKey == productKey }) else {
            throw DrugLibraryMutationError.duplicateBrand
        }

        product.productKey = productKey
        product.tradeName = tradeName
        product.manufacturer = draft.manufacturer.trimmed
        product.strength = marketedStrength
        product.marketedStrengthLabel = marketedStrength
        product.ingredientComponents = normalizedComponents(draft.ingredientComponents, for: drug)
        product.dosageForm = draft.dosageForm.trimmed
        product.route = draft.route.trimmed
        product.country = draft.country.trimmed
        product.shelfLocation = draft.shelfLocation.trimmed
        product.imageData = draft.imageData
        product.additionalImageData = draft.additionalImageData
        product.thumbnailData = draft.thumbnailData
        product.additionalThumbnailData = draft.additionalThumbnailData
        synchronizeCompatibilityCache(for: drug)
        invalidateDerivedPractice(for: drug)
        try context.save()
    }

    static func synchronizeCompatibilityCache(for drug: Drug) {
        var values: [String] = []
        for product in drug.products.sorted(by: { $0.dateAdded < $1.dateAdded }) {
            let name = product.tradeName.trimmed
            guard !name.isEmpty, !values.contains(where: { $0.localizedCaseInsensitiveCompare(name) == .orderedSame }) else { continue }
            values.append(name)
        }
        drug.tradeNames = values
    }

    private static func normalizedComponents(_ components: [IngredientComponent], for drug: Drug) -> [IngredientComponent] {
        let strengths = components.reduce(into: [String: String]()) { values, component in
            values[IngredientIdentity.normalize(component.name)] = component.displayStrength.trimmed
        }
        return drug.ingredientNames.map { name in
            IngredientComponent(name: name, displayStrength: strengths[IngredientIdentity.normalize(name)] ?? "")
        }
    }

    private static func invalidateDerivedPractice(for drug: Drug) {
        if !drug.generatedReviewQuestions.isEmpty {
            drug.reviewQuestionsNeedRegeneration = true
        }
        AIPracticePackStore.clear()
    }
}

@MainActor
enum DrugLibraryMutationService {
    static func impact(of drug: Drug, context: ModelContext) throws -> DrugDeletionImpact {
        let drugID = drug.id
        let relationships = try context.fetch(FetchDescriptor<DrugRelationship>()).filter {
            $0.sourceDrug?.id == drugID || $0.targetDrug?.id == drugID
        }
        let reviews = try context.fetch(FetchDescriptor<ReviewLog>()).filter { $0.drug?.id == drugID }
        let encounters = try context.fetch(FetchDescriptor<EncounterNote>()).filter { $0.relatedDrug?.id == drugID }
        return DrugDeletionImpact(
            brandCount: drug.products.count,
            relationshipCount: relationships.count,
            reviewCount: reviews.count,
            encounterCount: encounters.count
        )
    }

    static func delete(_ drug: Drug, historyPolicy: DrugDeletionHistoryPolicy, context: ModelContext) throws {
        let drugID = drug.id
        let nameSnapshot = drug.displayName
        let relationships = try context.fetch(FetchDescriptor<DrugRelationship>()).filter {
            $0.sourceDrug?.id == drugID || $0.targetDrug?.id == drugID
        }
        let reviews = try context.fetch(FetchDescriptor<ReviewLog>()).filter { $0.drug?.id == drugID }
        let encounters = try context.fetch(FetchDescriptor<EncounterNote>()).filter { $0.relatedDrug?.id == drugID }

        for relationship in relationships { context.delete(relationship) }
        switch historyPolicy {
        case .keepHistory:
            for review in reviews {
                if review.drugNameSnapshot.trimmed.isEmpty { review.drugNameSnapshot = nameSnapshot }
                review.drug = nil
            }
            for encounter in encounters {
                if encounter.relatedDrugNameSnapshot.trimmed.isEmpty { encounter.relatedDrugNameSnapshot = nameSnapshot }
                encounter.relatedDrug = nil
            }
        case .eraseHistory:
            for review in reviews { context.delete(review) }
            for encounter in encounters { context.delete(encounter) }
        }

        context.delete(drug)
        AIPracticePackStore.clear()
        try context.save()
    }
}
