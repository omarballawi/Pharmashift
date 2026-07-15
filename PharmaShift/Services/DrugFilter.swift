import Foundation

struct DrugFilter {
    var searchText = ""
    var chapter = ""
    var confidence = ""
    var drugClass = ""
    var shelf = ""
    var unknownOnly = false
    var dueOnly = false
    var masteredOnly = false
    var weakOnly = false
    var incompleteOnly = false
    var missingImageOnly = false
    var importedOnly = false

    func matches(_ drug: Drug, now: Date = .now, calendar: Calendar = .current) -> Bool {
        let haystack = [
            drug.scientificName, drug.ingredientNames.joined(separator: " "), drug.effectiveTradeNames.joined(separator: " "), drug.chapterRaw, drug.chapter.arabicName,
            drug.drugClass, drug.shelfLocation, drug.captureLabel, drug.notes, drug.arabicPersonalNotes,
            drug.arabicExplanation, drug.arabicMechanism, drug.counselingSentence, drug.arabicCounseling,
            drug.indications.joined(separator: " "), drug.importedSourceName,
            drug.products.flatMap { product in
                [product.tradeName, product.manufacturer, product.strength, product.marketedStrengthLabel, product.dosageForm, product.route]
                    + product.ingredientComponents.flatMap { [$0.name, $0.saltForm, $0.strengthText] }
            }.joined(separator: " ")
        ]
            .joined(separator: " ")
        let searchTerms = searchText.trimmed.split(whereSeparator: \.isWhitespace)
        let searchMatches = searchTerms.isEmpty || searchTerms.allSatisfy { term in
            haystack.localizedCaseInsensitiveContains(String(term))
        }
        let dueBoundary = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: now)) ?? now
        return searchMatches
            && (chapter.isEmpty || drug.chapterRaw == chapter)
            && (confidence.isEmpty || drug.confidenceRaw == confidence)
            && (drugClass.trimmed.isEmpty || drug.drugClass.localizedCaseInsensitiveContains(drugClass.trimmed))
            && (shelf.trimmed.isEmpty || drug.shelfLocation.localizedCaseInsensitiveContains(shelf.trimmed))
            && (!unknownOnly || drug.isUnknown)
            && (!dueOnly || drug.nextReviewDate < dueBoundary)
            && (!masteredOnly || drug.isMastered)
            && (!weakOnly || drug.confidenceLevel == .weak || drug.isConfusing)
            && (!incompleteOnly || drug.isIncomplete)
            && (!missingImageOnly || drug.packageImages.isEmpty)
            && (!importedOnly || drug.isImported)
    }
}
