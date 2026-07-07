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

    func matches(_ drug: Drug, now: Date = .now, calendar: Calendar = .current) -> Bool {
        let haystack = [drug.scientificName, drug.tradeNames.joined(separator: " "), drug.chapterRaw, drug.drugClass, drug.shelfLocation, drug.captureLabel]
            .joined(separator: " ")
        let dueBoundary = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: now)) ?? now
        return (searchText.trimmed.isEmpty || haystack.localizedCaseInsensitiveContains(searchText.trimmed))
            && (chapter.isEmpty || drug.chapterRaw == chapter)
            && (confidence.isEmpty || drug.confidenceRaw == confidence)
            && (drugClass.trimmed.isEmpty || drug.drugClass.localizedCaseInsensitiveContains(drugClass.trimmed))
            && (shelf.trimmed.isEmpty || drug.shelfLocation.localizedCaseInsensitiveContains(shelf.trimmed))
            && (!unknownOnly || drug.isUnknown)
            && (!dueOnly || drug.nextReviewDate < dueBoundary)
            && (!masteredOnly || drug.isMastered)
    }
}
