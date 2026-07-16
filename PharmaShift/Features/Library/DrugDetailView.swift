import SwiftData
import SwiftUI
import PhotosUI

private enum DrugCardAnchor: String, CaseIterable, Identifiable {
    case identity = "Identity"
    case uses = "Uses"
    case pharmacology = "PK"
    case safety = "Safety"
    case counseling = "Counseling"
    case arabic = "Arabic"
    case notes = "Notes"
    case mastery = "Mastery"
    case review = "Review"

    var id: String { rawValue }
}

private enum DrugDetailSheet: String, Identifiable {
    case editor
    case review
    case atomicNotes
    case regenerateReview
    var id: String { rawValue }
}

private enum DrugCardPage: String, CaseIterable, Identifiable {
    case overview = "Overview"
    case brands = "Brands"
    case forms = "Dosage forms & strengths"
    case doses = "Dosing by indication"
    case uses = "Uses"
    case interactions = "Interactions"
    case adverse = "Adverse effects"
    case warnings = "Warnings & contraindications"
    case reproductive = "Pregnancy & lactation"
    case pharmacology = "Pharmacology"
    case counseling = "Counseling & Arabic notes"
    case notes = "Notes, links & mastery"

    var id: String { rawValue }
    var icon: String {
        switch self {
        case .overview: "sparkles"
        case .brands: "shippingbox.fill"
        case .forms: "pills.fill"
        case .doses: "list.number"
        case .uses: "cross.case.fill"
        case .interactions: "arrow.triangle.branch"
        case .adverse: "waveform.path.ecg"
        case .warnings: "shield.fill"
        case .reproductive: "figure.and.child.holdinghands"
        case .pharmacology: "atom"
        case .counseling: "quote.bubble.fill"
        case .notes: "point.3.connected.trianglepath.dotted"
        }
    }
}

private struct LegacyDrugDetailView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(AppTheme.self) private var theme
    @Environment(ReviewScheduler.self) private var scheduler
    @Query private var relationships: [DrugRelationship]
    @Query(sort: \Drug.scientificName) private var allDrugs: [Drug]
    let drug: Drug
    @State private var sheet: DrugDetailSheet?
    @State private var expandedFields: Set<String> = []
    @State private var selectedPage: DrugCardPage = .overview

    var body: some View {
        VStack(spacing: 0) {
            pagePicker
            TabView(selection: $selectedPage) {
                ForEach(DrugCardPage.allCases) { page in
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 16) {
                            pageContent(page)
                        }
                        .padding()
                    }
                    .background(theme.background)
                    .tag(page)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .background(theme.background)
        .navigationTitle("Drug Card")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { Button("Edit") { sheet = .editor } }
        .sheet(item: $sheet) { destination in
            NavigationStack {
                switch destination {
                case .editor: DrugEditorView(drug: drug)
                case .review: PracticeSessionView(initialDrug: drug)
                case .atomicNotes: AtomicNotesView(drug: drug)
                case .regenerateReview: DrugImportView(drug: drug, startsInAIMode: true)
                }
            }
        }
    }

    private var pagePicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 7) {
                ForEach(DrugCardPage.allCases) { page in
                    Button {
                        withAnimation(reduceMotion ? nil : .snappy) { selectedPage = page }
                    } label: {
                        Label(page.rawValue, systemImage: page.icon)
                            .font(.caption.weight(.semibold))
                            .padding(.horizontal, 11)
                            .frame(minHeight: 38)
                            .background(selectedPage == page ? theme.tint : Color.secondary.opacity(0.10), in: Capsule())
                            .foregroundStyle(selectedPage == page ? .white : .primary)
                    }
                    .buttonStyle(.plain)
                    .accessibilityIdentifier("drugProfile.tab.\(page.id)")
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .background(.bar)
        .accessibilityLabel("Drug profile tabs")
    }

    @ViewBuilder private func pageContent(_ page: DrugCardPage) -> some View {
        switch page {
        case .overview:
            hero
            mustKnowCard
            identityCard.accessibilityIdentifier("drugCard.identity")
            actions
        case .brands:
            brandsPageLink
        case .forms:
            dosageFormsAndStrengthsCard
        case .doses:
            clinicalDosingCard
            DoseRegimensView(drug: drug)
        case .uses:
            usesCard
        case .interactions:
            interactionListCard
        case .adverse:
            adverseEffectsListCard
        case .warnings:
            readableWarningsCard.accessibilityIdentifier("drugCard.safety")
        case .reproductive:
            reproductiveSafetyCard
        case .pharmacology:
            pharmacologyCard.accessibilityIdentifier("drugCard.pharmacology")
            detailedPharmacologyCard
        case .counseling:
            counselingCard
            arabicCard
        case .notes:
            notesCard
            interactiveLessonButton("Add a linked note", icon: "note.text.badge.plus", destination: .atomicNotes)
            connectedKnowledgeCard
            relationshipCard
            provenanceDetails
            masteryCard
        }
    }

    private var brandsPageLink: some View {
        NavigationLink {
            DrugBrandsView(drug: drug)
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "shippingbox.fill").foregroundStyle(theme.tint).frame(width: 24)
                VStack(alignment: .leading, spacing: 3) {
                    Text("Brands & package images").font(.headline).foregroundStyle(.primary)
                    Text(drug.products.isEmpty ? "Add and manage brand products" : "\(drug.products.count) saved product\(drug.products.count == 1 ? "" : "s")")
                        .font(.caption).foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.forward").font(.caption.bold()).foregroundStyle(.secondary)
            }
            .frame(minHeight: 52)
            .padding(.horizontal, 14)
            .background(theme.card, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("drugProfile.brandsPage")
    }

    private var dosageFormsAndStrengthsCard: some View {
        card("Dosage Forms & Strengths", icon: "pills.fill") {
            if drug.dosageFormGroups.isEmpty {
                Text("No structured dosage forms or strengths saved.").foregroundStyle(.secondary)
            } else {
                ForEach(drug.dosageFormGroups) { group in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(group.dosageForm.uppercased()).font(.subheadline.bold()).foregroundStyle(theme.tint)
                        ForEach(group.strengths) { item in
                            VStack(alignment: .leading, spacing: 2) {
                                Text(item.strength).font(.body.weight(.semibold))
                                if !item.tradeNames.isEmpty {
                                    Text(item.tradeNames.joined(separator: ", ")).font(.caption).foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 4)
                }
            }
        }
    }

    private var clinicalDosingCard: some View {
        card("Dosing by indication", icon: "list.number") {
            if drug.clinicalDoses.isEmpty {
                Text("No indication-specific clinical dosing saved.").foregroundStyle(.secondary)
            } else {
                ForEach(drug.clinicalDoses) { dose in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(dose.indication).font(.headline)
                        if !dose.population.trimmed.isEmpty { Text(dose.population.uppercased()).font(.caption.bold()).foregroundStyle(theme.tint) }
                        Text(dose.doseText).font(.body)
                        let details = [dose.route, dose.frequency, dose.duration].filter { !$0.trimmed.isEmpty }
                        if !details.isEmpty { Text(details.joined(separator: " • ")).font(.caption).foregroundStyle(.secondary) }
                        ForEach(dose.adjuncts, id: \.self) { Label($0, systemImage: "plus.circle") }
                        ForEach(dose.considerations, id: \.self) { Label($0, systemImage: "exclamationmark.circle") }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 8)
                    if dose.id != drug.clinicalDoses.last?.id { Divider() }
                }
            }
        }
    }

    private var interactionListCard: some View {
        card("Interactions", icon: "arrow.triangle.branch") {
            if drug.interactionEntries.isEmpty {
                Text("No structured interaction list saved.").foregroundStyle(.secondary)
            } else {
                ForEach(InteractionCategory.allCases) { category in
                    let entries = drug.interactionEntries.filter { $0.category == category }
                    if !entries.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("\(category.rawValue) (\(entries.count))").font(.headline).foregroundStyle(interactionColor(category))
                            ForEach(entries) { entry in
                                if let match = localDrug(named: entry.drugName) {
                                    NavigationLink { DrugDetailView(drug: match) } label: {
                                        interactionRow(entry, linked: true)
                                    }
                                    .buttonStyle(.plain)
                                } else {
                                    interactionRow(entry, linked: false)
                                }
                            }
                        }
                        .padding(.vertical, 5)
                    }
                }
            }
        }
    }

    private func interactionRow(_ entry: DrugInteractionEntry, linked: Bool) -> some View {
        HStack(alignment: .top, spacing: 10) {
            VStack(alignment: .leading, spacing: 3) {
                Text(entry.drugName).font(.body.weight(.semibold))
                if !entry.effect.trimmed.isEmpty { Text(entry.effect).font(.caption).foregroundStyle(.secondary) }
                if !entry.management.trimmed.isEmpty { Text(entry.management).font(.caption).foregroundStyle(.secondary) }
            }
            Spacer()
            if linked { Image(systemName: "arrow.up.right.circle.fill").foregroundStyle(theme.tint).accessibilityLabel("Open saved drug profile") }
        }
        .padding(.vertical, 4)
    }

    private var adverseEffectsListCard: some View {
        card("Adverse effects", icon: "waveform.path.ecg") {
            if drug.adverseEffectEntries.isEmpty {
                Text("No structured adverse-effect list saved.").foregroundStyle(.secondary)
            } else {
                ForEach(drug.adverseEffectEntries) { effect in
                    HStack(alignment: .firstTextBaseline) {
                        Text(effect.name)
                        Spacer()
                        Text(adverseIncidenceLabel(effect.incidence))
                            .font(.body.monospacedDigit().weight(.semibold))
                            .foregroundStyle(effect.incidence.trimmed.isEmpty ? .secondary : theme.tint)
                        if effect.isSerious { Image(systemName: "exclamationmark.triangle.fill").foregroundStyle(.red).accessibilityLabel("Serious") }
                    }
                    .padding(.vertical, 3)
                }
            }
        }
    }

    private func adverseIncidenceLabel(_ incidence: String) -> String {
        let value = incidence.trimmed
        guard !value.isEmpty else { return "Not established" }
        if value.contains("%") { return value }
        if Double(value.replacingOccurrences(of: ",", with: ".")) != nil { return "\(value)%" }
        return value
    }

    private var reproductiveSafetyCard: some View {
        card("Pregnancy & lactation", icon: "figure.and.child.holdinghands") {
            expandableValue("Pregnancy", drug.reproductiveSafety.pregnancy)
            arabicValue("ملاحظة الحمل", drug.reproductiveSafety.pregnancyArabicNote)
            Divider()
            expandableValue("Lactation", drug.reproductiveSafety.lactation)
            arabicValue("ملاحظة الرضاعة", drug.reproductiveSafety.lactationArabicNote)
        }
    }

    private var detailedPharmacologyCard: some View {
        card("Clinical pharmacology", icon: "atom") {
            expandableValue("Mechanism of action", drug.pharmacologyProfile.mechanismOfAction)
            expandableValue("Absorption", drug.pharmacologyProfile.absorption.joined(separator: "\n"))
            expandableValue("Distribution", drug.pharmacologyProfile.distribution.joined(separator: "\n"))
            expandableValue("Metabolism", drug.pharmacologyProfile.metabolism.joined(separator: "\n"))
            expandableValue("Elimination", drug.pharmacologyProfile.elimination.joined(separator: "\n"))
        }
    }

    private func localDrug(named name: String) -> Drug? {
        let needle = IngredientIdentity.normalize(name)
        guard !needle.isEmpty else { return nil }
        return allDrugs.first { candidate in
            candidate.id != drug.id && (candidate.ingredientNames + candidate.effectiveTradeNames).contains {
                IngredientIdentity.normalize($0) == needle
            }
        }
    }

    private func interactionColor(_ category: InteractionCategory) -> Color {
        switch category {
        case .contraindicated: .red
        case .seriousUseAlternative: .orange
        case .monitorClosely: .yellow
        case .minor: .blue
        case .unknown: .secondary
        }
    }

    private var relationshipCard: some View {
        card("Library interactions", icon: "link.badge.plus") {
            let linked = relationships.filter { $0.sourceDrug?.id == drug.id || $0.targetDrug?.id == drug.id }
            if linked.isEmpty {
                Text("No sourced library relationship has been found yet. Use Refresh links in the Library.").font(.subheadline).foregroundStyle(.secondary)
            } else {
                ForEach(linked) { relationship in
                    if let target = relationship.sourceDrug?.id == drug.id ? relationship.targetDrug : relationship.sourceDrug {
                        NavigationLink {
                            DrugDetailView(drug: target)
                        } label: {
                            VStack(alignment: .leading, spacing: 5) {
                                HStack { Text(target.displayName).font(.headline); Spacer(); Text(relationship.severity.rawValue).font(.caption.bold()) }
                                Text(relationship.summary).font(.subheadline).foregroundStyle(.secondary)
                            }
                            .padding(11).background(.secondary.opacity(0.07), in: RoundedRectangle(cornerRadius: 14))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    private func interactiveLessonButton(_ title: String, icon: String, destination: DrugDetailSheet) -> some View {
        Button { sheet = destination } label: {
            HStack {
                Image(systemName: icon).font(.title3).foregroundStyle(theme.tint)
                Text(title).font(.headline)
                Spacer()
                Image(systemName: "chevron.forward").font(.caption.bold()).foregroundStyle(.secondary)
            }
            .padding(15).frame(minHeight: 56)
            .background(theme.card, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    private var mustKnowCard: some View {
        card("3 things to remember", icon: "lightbulb.max.fill") {
            let facts = Array(drug.mustKnow.filter { !$0.trimmed.isEmpty }.prefix(3))
            if facts.isEmpty {
                Text("Add three must-know facts to make every review focused.").font(.subheadline).foregroundStyle(.secondary)
            } else {
                ForEach(Array(facts.enumerated()), id: \.offset) { index, fact in
                    HStack(alignment: .top, spacing: 10) {
                        Text("\(index + 1)").font(.caption.bold()).foregroundStyle(.white)
                            .frame(width: 25, height: 25).background(theme.tint, in: Circle())
                        Text(fact).font(.subheadline).frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        }
    }

    private var connectedKnowledgeCard: some View {
        card("Connected knowledge", icon: "point.3.connected.trianglepath.dotted") {
            LocalDrugGraphView(drug: drug)
        }
    }

    private var provenanceDetails: some View {
        card("Card history", icon: "clock.arrow.circlepath") {
            value("Created", drug.dateAdded.formatted(date: .abbreviated, time: .omitted))
            if let reviewed = drug.lastReviewed { value("Last reviewed", reviewed.formatted(date: .abbreviated, time: .shortened)) }
            value("Generated by", drug.importedSourceName.trimmed.isEmpty ? "Manual card" : drug.importedSourceName)
        }
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: 14) {
            DrugPhotoGalleryView(images: drug.packageImages, height: 220)
                .overlay(alignment: .topTrailing) {
                    if scheduler.isDue(drug) {
                        Label("Due", systemImage: "calendar.badge.clock")
                            .font(.caption.bold()).padding(8)
                            .background(.orange, in: Capsule()).foregroundStyle(.white).padding(10)
                    }
                }
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(drug.displayName).font(.largeTitle.bold())
                    if !drug.tradeNames.isEmpty {
                        Text(drug.tradeNames.joined(separator: ", ")).font(.title3).foregroundStyle(.secondary)
                    }
                }
                Spacer()
                MasteryBadge(drug: drug)
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 7) {
                    badge(drug.chapterRaw, icon: drug.chapter.icon, color: theme.colors(for: drug.chapter).first ?? theme.tint)
                    badge(drug.drugClass, icon: "square.grid.2x2.fill", color: .indigo)
                    if let form = drug.dosageForms.first { badge(form, icon: "pills.fill", color: .teal) }
                    if let strength = drug.strengths.first { badge(strength, icon: "gauge.with.dots.needle.33percent", color: .orange) }
                }
            }
            provenanceBadge
        }
    }

    @ViewBuilder private var provenanceBadge: some View {
        if drug.isImported, let url = URL(string: drug.sourceURL), !drug.sourceURL.isEmpty {
            Link(destination: url) {
                Label(provenanceText, systemImage: drug.sourceNeedsReview ? "exclamationmark.triangle.fill" : "checkmark.seal.fill")
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 9).padding(.vertical, 6)
                    .background(drug.sourceNeedsReview ? Color.orange.opacity(0.16) : theme.softTint, in: Capsule())
            }
            .accessibilityHint("Opens the official label")
        }
    }

    private var provenanceText: String {
        let provider = drug.importedSourceName.trimmed.isEmpty ? "DailyMed" : drug.importedSourceName
        guard let date = drug.sourceUpdatedAt else { return provider }
        return "\(provider) • \(date.formatted(date: .abbreviated, time: .omitted))"
    }

    private func jumpChips(_ proxy: ScrollViewProxy) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(DrugCardAnchor.allCases) { anchor in
                    Button(anchor.rawValue) {
                        withAnimation(reduceMotion ? nil : .snappy) { proxy.scrollTo(anchor, anchor: .top) }
                    }
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.capsule)
                }
            }
        }
        .accessibilityLabel("Jump to a Drug Card section")
    }

    private var identityCard: some View {
        card("Identity", icon: "pills.fill") {
            value("System / Chapter", drug.chapterRaw)
            value("Class", drug.drugClass)
            value("Dosage forms", drug.dosageForms.joined(separator: ", "))
            value("Strengths", drug.strengths.joined(separator: ", "))
            value("Routes", drug.routes.joined(separator: ", "))
            if drug.sourceNeedsReview {
                safetyValue("Source quality", text: [drug.trustedSourceWasTruncated ? "Trusted packet was trimmed before AI formatting." : "", drug.sourceQualityNotes, drug.sourceMissingFields.isEmpty ? "" : "Missing: \(drug.sourceMissingFields.joined(separator: ", "))"].filter { !$0.trimmed.isEmpty }.joined(separator: "\n"), severity: SafetySeverity.medium.rawValue)
            }
            value("Shelf", drug.shelfLocation)
        }
    }

    private var usesCard: some View {
        card("Uses & mechanism", icon: "cross.case.fill") {
            expandableValue("Indications / Uses", drug.indications.joined(separator: "\n"))
            expandableValue("Mechanism", drug.mechanism)
            if !drug.mechanismKeywords.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(drug.mechanismKeywords, id: \.self) { keyword in
                            Text(keyword).font(.caption.weight(.semibold))
                                .padding(.horizontal, 8).padding(.vertical, 5)
                                .background(.tint.opacity(0.12), in: Capsule())
                        }
                    }
                }
            }
            value("How to take", drug.howToTake)
            value("Food instructions", drug.foodInstruction)
        }
    }

    private var pharmacologyCard: some View {
        card("Pharmacokinetics", icon: "waveform.path.ecg") {
            PharmacologyMeter(title: "Half-life", icon: "clock.arrow.circlepath", scale: .halfLife, value: drug.halfLifeHours, fallback: drug.halfLifeBand.rawValue, detail: drug.halfLifeText)
            PharmacologyMeter(title: "Onset", icon: "hare.fill", scale: .onset, value: drug.onsetMinutes, fallback: drug.onsetBand.rawValue, detail: drug.onsetText)
            PharmacologyMeter(title: "Duration", icon: "timer", scale: .duration, value: drug.durationHours, fallback: drug.durationBand.rawValue, detail: drug.durationText)
            DosingFrequencyMeter(frequency: drug.dosingFrequency, timesPerDay: drug.timesPerDay)
            PharmacologyStatusCard(title: "Tablet/capsule status", value: drug.prodrugInfo.classification.rawValue, detail: [drug.prodrugInfo.administeredCompound, drug.prodrugInfo.activeCompound.trimmed.isEmpty ? "" : "Becomes: \(drug.prodrugInfo.activeCompound)", drug.prodrugInfo.activationPathway, drug.prodrugInfo.explanation].filter { !$0.trimmed.isEmpty }.joined(separator: "\n"), icon: "arrow.triangle.2.circlepath")
            PharmacologyStatusCard(title: "How the body removes it", value: drug.eliminationInfo.dominantPathway.rawValue, detail: [drug.eliminationInfo.summary, drug.eliminationInfo.routes.map { [$0.pathway.rawValue, $0.percentage.map { "\($0.formatted())%" } ?? "", $0.detail].filter { !$0.trimmed.isEmpty }.joined(separator: " — ") }.joined(separator: "\n")].filter { !$0.trimmed.isEmpty }.joined(separator: "\n"), icon: "drop.triangle.fill")
            arabicValue("PK memory line", drug.pkMemoryLineArabic)
        }
    }

    private var readableWarningsCard: some View {
        card("Warnings & contraindications", icon: "shield.fill") {
            if !drug.safetyFlags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(drug.safetyFlags) { flag in
                            Text(flag.rawValue).font(.caption.weight(.semibold))
                                .padding(.horizontal, 8).padding(.vertical, 5)
                                .background(.orange.opacity(0.13), in: Capsule()).foregroundStyle(.orange)
                        }
                    }
                }
            }
            warningGroup("Contraindications", items: drug.contraindications, severity: drug.contraindicationSeverityRaw, icon: "xmark.octagon.fill", tint: .red)
            warningGroup("Important warnings", items: drug.warnings, severity: drug.warningSeverityRaw, icon: "exclamationmark.triangle.fill", tint: .orange)
            warningGroup("Toxicity", items: drug.toxicity.splitLines, severity: drug.toxicitySeverityRaw, icon: "waveform.path.ecg", tint: .red)
            warningGroup("Kidney cautions", items: drug.renalCaution.splitLines, severity: drug.renalSeverityRaw, icon: "drop.fill", tint: .blue)
            warningGroup("Liver cautions", items: drug.hepaticCaution.splitLines, severity: drug.hepaticSeverityRaw, icon: "cross.vial.fill", tint: .orange)
            warningGroup("Pregnancy caution", items: drug.pregnancyCaution.splitLines, severity: drug.pregnancySeverityRaw, icon: "figure.and.child.holdinghands", tint: .purple)
        }
    }

    @ViewBuilder private func warningGroup(_ title: String, items: [String], severity: String, icon: String, tint: Color) -> some View {
        let visibleItems = items.map(\.trimmed).filter { !$0.isEmpty }
        VStack(alignment: .leading, spacing: 9) {
            HStack(spacing: 8) {
                Image(systemName: icon).foregroundStyle(tint)
                Text(title).font(.headline)
                Spacer()
                Text(severity).font(.caption2.bold())
                    .padding(.horizontal, 7).padding(.vertical, 4)
                    .background(tint.opacity(0.13), in: Capsule())
                    .foregroundStyle(tint)
            }
            if visibleItems.isEmpty {
                Text("Not found").font(.subheadline).foregroundStyle(.secondary)
            } else {
                ForEach(visibleItems, id: \.self) { item in
                    HStack(alignment: .top, spacing: 9) {
                        Circle().fill(tint).frame(width: 6, height: 6).padding(.top, 7)
                        Text(item).font(.subheadline).frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        }
        .padding(12)
        .background(tint.opacity(0.07), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    private var knowledgeCompletenessMap: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Knowledge completeness").font(.subheadline.bold())
            completenessRow("Identity", complete: !drug.scientificName.trimmed.isEmpty && !drug.drugClass.trimmed.isEmpty)
            completenessRow("Uses", complete: !drug.indications.isEmpty)
            completenessRow("PK", complete: !drug.halfLifeText.trimmed.isEmpty || drug.halfLifeHours != nil)
            completenessRow("Safety", complete: !drug.warnings.isEmpty || !drug.contraindications.isEmpty)
            completenessRow("Counseling", complete: !drug.counselingSentence.trimmed.isEmpty)
            completenessRow("Interactions", complete: !drug.interactions.isEmpty)
            completenessRow("Image recognition", complete: !drug.packageImages.isEmpty)
        }
        .padding(13).background(theme.tint.opacity(0.08), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private func completenessRow(_ label: String, complete: Bool) -> some View {
        HStack {
            Image(systemName: complete ? "checkmark.circle.fill" : "circle.dashed")
                .foregroundStyle(complete ? theme.tint : .secondary)
            Text(label).font(.caption.weight(.semibold))
            Spacer()
            Text(complete ? "Ready" : "Add info").font(.caption2).foregroundStyle(.secondary)
        }
    }

    private var counselingCard: some View {
        card("Counseling", icon: "quote.bubble.fill") {
            expandableValue("Counseling sentence", drug.counselingSentence)
            arabicValue("How to take", drug.counselingHowToTakeArabic)
            arabicValue("Food", drug.counselingFoodArabic)
            expandableValue("What patient may feel", drug.patientFeelingsArabic.joined(separator: "\n"))
            expandableValue("When to seek help", drug.seekHelpArabic.joined(separator: "\n"))
            arabicValue("Missed dose", drug.missedDoseArabic)
            expandableValue("Common adverse effects", drug.commonSideEffects.joined(separator: "\n"))
            expandableValue("Serious adverse effects", drug.seriousSideEffects.joined(separator: "\n"))
            expandableValue("Patient questions", drug.patientQuestions.joined(separator: "\n"))
        }
    }

    private var arabicCard: some View {
        card("Arabic explanations", icon: "character.book.closed.fill") {
            arabicValue("الشرح بالعربية", drug.arabicExplanation)
            arabicValue("آلية العمل بالعربية", drug.arabicMechanism)
            arabicValue("الإرشاد بالعربية", drug.arabicCounseling)
            arabicValue("ملاحظاتي بالعربية", drug.arabicPersonalNotes)
        }
    }

    private var notesCard: some View {
        card("Personal notes", icon: "note.text") {
            expandableValue("My notes", drug.notes)
            ForEach(drug.atomicNotes.prefix(4)) { note in
                VStack(alignment: .leading, spacing: 4) {
                    HStack { Text(note.kind.rawValue).font(.caption.bold()).foregroundStyle(theme.tint); Spacer(); Text(note.linkedField).font(.caption2).foregroundStyle(.secondary) }
                    Text(note.text).font(.subheadline)
                }
                .padding(10).background(.secondary.opacity(0.07), in: RoundedRectangle(cornerRadius: 12))
            }
        }
    }

    private var masteryCard: some View {
        card("Drug Mastery", icon: "sparkles") {
            HStack { Text("Six mastery checks").font(.subheadline); Spacer(); Text("\(drug.masteryCount)/6").font(.headline.monospacedDigit()) }
            ProgressView(value: Double(drug.masteryCount), total: 6).tint(drug.isMastered ? .green : theme.tint)
            VStack(spacing: 8) {
                ForEach(drug.memoryItems) { item in
                    HStack {
                        Text(item.field.rawValue).font(.caption.weight(.semibold))
                        Spacer()
                        Text(item.strengthLabel).font(.caption2.bold())
                            .foregroundStyle(memoryColor(item.strengthLabel))
                            .padding(.horizontal, 7).padding(.vertical, 4)
                            .background(memoryColor(item.strengthLabel).opacity(0.12), in: Capsule())
                    }
                }
            }
            expandableValue("Must know", drug.mustKnow.joined(separator: "\n"))
            if !flashcardPairs.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Flashcards").font(.caption.weight(.semibold)).foregroundStyle(.secondary)
                    ForEach(flashcardPairs, id: \.0) { pair in
                        VStack(alignment: .leading, spacing: 3) {
                            Text(pair.0).font(.subheadline.weight(.semibold))
                            Text(pair.1).font(.caption).foregroundStyle(.secondary)
                        }
                        .padding(10)
                        .background(.secondary.opacity(0.08), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                }
            }
            Text("Scientific • Trade • Class • Use • Warning • Counseling").font(.caption).foregroundStyle(.secondary)
        }
    }

    private var actions: some View {
        card("Review actions", icon: "brain.head.profile") {
            if drug.reviewQuestionsNeedRegeneration {
                Label("Questions need regeneration because linked card facts changed.", systemImage: "exclamationmark.arrow.triangle.2.circlepath")
                    .font(.caption).foregroundStyle(.orange)
                Button { sheet = .regenerateReview } label: { Label("Regenerate with AI", systemImage: "sparkles") }
                    .buttonStyle(.bordered)
            }
            Button { sheet = .review } label: {
                Label("Start review / ابدأ المراجعة", systemImage: "brain.head.profile").frame(maxWidth: .infinity, minHeight: 48)
            }
            .buttonStyle(.borderedProminent).tint(theme.tint).disabled(drug.isUnknown)
            HStack {
                Button { drug.markSeen(); try? context.save() } label: { Label("Seen today", systemImage: "eye.fill") }
                Spacer()
                Button { drug.isConfusing.toggle(); try? context.save() } label: {
                    Label(drug.isConfusing ? "Clear weak mark" : "Mark confusing", systemImage: "exclamationmark.bubble")
                }
            }
            .font(.subheadline)
        }
    }

    private var safetyRadarValues: [(label: String, severity: SafetySeverity)] {
        [
            ("Contraindications", severity(drug.contraindicationSeverityRaw)),
            ("Toxicity", severity(drug.toxicitySeverityRaw)),
            ("Warnings", severity(drug.warningSeverityRaw)),
            ("Interactions", severity(drug.interactionSeverityRaw)),
            ("Renal", severity(drug.renalSeverityRaw)),
            ("Hepatic", severity(drug.hepaticSeverityRaw)),
            ("Pregnancy", severity(drug.pregnancySeverityRaw))
        ]
    }

    private var flashcardPairs: [(String, String)] {
        drug.flashcards.compactMap { raw in
            let parts = raw.components(separatedBy: "\t")
            guard parts.count >= 2 else { return nil }
            return (parts[0], parts.dropFirst().joined(separator: "\t"))
        }
    }

    private func card<Content: View>(_ title: String, icon: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Label(title, systemImage: icon).font(.title3.bold()).foregroundStyle(theme.tint)
            content()
        }
        .padding(16).frame(maxWidth: .infinity, alignment: .leading)
        .background(theme.card, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    private func badge(_ text: String, icon: String, color: Color) -> some View {
        Group {
            if !text.trimmed.isEmpty {
                Label(text, systemImage: icon).font(.caption.weight(.semibold))
                    .padding(.horizontal, 9).padding(.vertical, 6)
                    .background(color.opacity(0.14), in: Capsule()).foregroundStyle(color)
            }
        }
    }

    @ViewBuilder private func value(_ label: String, _ text: String) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label).font(.caption.weight(.semibold)).foregroundStyle(.secondary)
            if text.trimmed.isEmpty {
                HStack { Text("Not found").foregroundStyle(.secondary); Spacer(); Button("Search this field") { sheet = .regenerateReview }.font(.caption.bold()) }
            } else { Text(text).frame(maxWidth: .infinity, alignment: .leading) }
        }
    }

    @ViewBuilder private func expandableValue(_ label: String, _ text: String) -> some View {
        if text.trimmed.isEmpty {
            HStack { VStack(alignment: .leading) { Text(label).font(.caption.weight(.semibold)).foregroundStyle(.secondary); Text("Not found").foregroundStyle(.secondary) }; Spacer(); Button("Search this field") { sheet = .regenerateReview }.font(.caption.bold()) }
        } else {
            let isExpanded = expandedFields.contains(label)
            VStack(alignment: .leading, spacing: 5) {
                Text(label).font(.caption.weight(.semibold)).foregroundStyle(.secondary)
                Text(text).lineLimit(isExpanded ? nil : 4).frame(maxWidth: .infinity, alignment: .leading)
                if text.count > 220 || text.split(separator: "\n").count > 4 {
                    Button(isExpanded ? "Show less" : "Show more") {
                        withAnimation(reduceMotion ? nil : .easeInOut) {
                            if isExpanded { expandedFields.remove(label) } else { expandedFields.insert(label) }
                        }
                    }
                    .font(.caption.weight(.semibold))
                }
            }
        }
    }

    @ViewBuilder private func arabicValue(_ label: String, _ text: String) -> some View {
        if text.trimmed.isEmpty {
            HStack { Text("Not found").foregroundStyle(.secondary); Spacer(); Text(label).font(.caption.weight(.semibold)); Button("Search") { sheet = .regenerateReview }.font(.caption.bold()) }
        } else {
            VStack(alignment: .trailing, spacing: 4) {
                Text(label).font(.caption.weight(.semibold)).foregroundStyle(.secondary)
                Text(text).frame(maxWidth: .infinity, alignment: .trailing)
            }
            .environment(\.layoutDirection, .rightToLeft)
        }
    }

    @ViewBuilder private func safetyValue(_ title: String, text: String, severity: String) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(title).font(.subheadline.bold())
                Spacer()
                Text(severity).font(.caption2.bold()).padding(.horizontal, 7).padding(.vertical, 4)
                    .background(severityColor(severity).opacity(0.16), in: Capsule()).foregroundStyle(severityColor(severity))
            }
            if text.trimmed.isEmpty { HStack { Text("Not found").font(.subheadline).foregroundStyle(.secondary); Spacer(); Button("Search this field") { sheet = .regenerateReview }.font(.caption.bold()) } }
            else { Text(text).font(.subheadline) }
        }
        .padding(11).background(severityColor(severity).opacity(0.09), in: RoundedRectangle(cornerRadius: 14))
    }

    private func severity(_ rawValue: String) -> SafetySeverity { SafetySeverity(rawValue: rawValue) ?? .unknown }
    private func memoryColor(_ label: String) -> Color {
        switch label { case "Strong": .green; case "Medium": .orange; case "Weak": .red; default: .secondary }
    }
    private func severityColor(_ rawValue: String) -> Color {
        switch severity(rawValue) { case .low: .green; case .medium: .orange; case .high: .red; case .unknown: .secondary }
    }
}

private enum DrugBrandsSheet: String, Identifiable {
    case addProduct
    var id: String { rawValue }
}

private struct DrugBrandsView: View {
    @Environment(AppTheme.self) private var theme
    let drug: Drug
    @State private var sheet: DrugBrandsSheet?

    var body: some View {
        List {
            Section("Active ingredient profile") {
                LabeledContent("Canonical ingredient", value: drug.ingredientNames.joined(separator: " + "))
                Text("Each brand below keeps its own package images, manufacturer, component strengths, marketed strength, dosage form, country, shelf location, and leaflet.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Section("Brands & package images") {
                if drug.products.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("No brand products saved yet.").foregroundStyle(.secondary)
                        Button { sheet = .addProduct } label: {
                            Label("Add a brand or package", systemImage: "plus")
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding(.vertical, 8)
                } else {
                    ForEach(drug.products.sorted(by: { $0.tradeName < $1.tradeName })) { product in
                        NavigationLink {
                            ProductLeafletEditorView(product: product, drug: drug)
                        } label: {
                            HStack(spacing: 12) {
                                ProductPhoto(
                                    data: product.thumbnailData ?? product.imageData,
                                    size: 64,
                                    cacheKey: "legacy-product-\(product.id.uuidString)"
                                )
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(product.tradeName.trimmed.isEmpty ? "Unnamed product" : product.tradeName).font(.headline)
                                    let details = [product.manufacturer, product.marketedStrengthLabel, product.dosageForm].filter { !$0.trimmed.isEmpty }
                                    if !details.isEmpty { Text(details.joined(separator: " • ")).font(.caption).foregroundStyle(.secondary) }
                                    let components = product.ingredientComponents.map { [$0.name, $0.strengthText].filter { !$0.trimmed.isEmpty }.joined(separator: " ") }
                                    if !components.isEmpty { Text(components.joined(separator: " + ")).font(.caption2).foregroundStyle(.secondary) }
                                    Text(product.leafletText.trimmed.isEmpty ? "Leaflet not added" : "Leaflet saved")
                                        .font(.caption2)
                                        .foregroundStyle(product.leafletText.trimmed.isEmpty ? .orange : .green)
                                }
                            }
                            .padding(.vertical, 5)
                        }
                    }
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(theme.background)
        .navigationTitle("Brands")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button { sheet = .addProduct } label: { Label("Add brand", systemImage: "plus") }
        }
        .sheet(item: $sheet) { _ in
            NavigationStack { DrugImportView(drug: drug, startsInAIMode: true) }
        }
        .accessibilityIdentifier("drugBrands.page")
    }
}

struct DoseRegimensView: View {
    @Environment(AppTheme.self) private var theme
    let drug: Drug
    @State private var selectedRegimenID = ""
    @State private var ageYears = 5
    @State private var ageExtraMonths = 0
    @State private var sex: PatientSexAtBirth = .female
    @State private var measuredWeight = ""
    @State private var height = ""
    @State private var renalFunction = "Normal"
    @State private var hepaticFunction = "Normal"
    @State private var isPregnant = false
    @State private var result: DoseCalculationResult?
    @State private var errorMessage = ""

    private var selectedRegimen: DoseRegimen? {
        drug.doseRegimens.first(where: { $0.id == selectedRegimenID }) ?? drug.doseRegimens.first
    }
    private var ageMonths: Int { ageYears * 12 + ageExtraMonths }
    private var estimatedWeight: Double? { PediatricWeightReference.medianWeightKG(ageMonths: ageMonths, sex: sex) }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 12) {
                Label("Standard regimens", systemImage: "list.bullet.clipboard.fill").font(.title3.bold()).foregroundStyle(theme.tint)
                if drug.doseRegimens.isEmpty {
                    Text("Not found").foregroundStyle(.secondary)
                    Text("Refresh this card from Altibbi, an official label, or a pasted product leaflet to add indication- and age-specific regimens.").font(.caption).foregroundStyle(.secondary)
                } else {
                    ForEach(drug.doseRegimens) { regimen in
                        Button { selectedRegimenID = regimen.id; result = nil } label: {
                            VStack(alignment: .leading, spacing: 5) {
                                HStack { Text(regimen.indication).font(.headline); Spacer(); Text(regimen.population.rawValue).font(.caption.bold()) }
                                Text(regimenSummary(regimen)).font(.subheadline).foregroundStyle(.secondary)
                                if !regimen.durationText.trimmed.isEmpty { Text(regimen.durationText).font(.caption).foregroundStyle(.secondary) }
                            }
                            .padding(11).background(selectedRegimen?.id == regimen.id ? theme.softTint : Color.secondary.opacity(0.07), in: RoundedRectangle(cornerRadius: 14))
                        }.buttonStyle(.plain)
                    }
                }
            }
            .padding(16).background(theme.card, in: RoundedRectangle(cornerRadius: 20))

            VStack(alignment: .leading, spacing: 13) {
                Label("Educational dose calculator", systemImage: "function").font(.title3.bold()).foregroundStyle(theme.tint)
                Text("No patient details are saved. Always verify the current clinical reference and product.").font(.caption).foregroundStyle(.secondary)
                Stepper("Age: \(ageYears) years", value: $ageYears, in: 0...120)
                Stepper("Extra months: \(ageExtraMonths)", value: $ageExtraMonths, in: 0...11)
                Picker("Sex at birth", selection: $sex) { ForEach(PatientSexAtBirth.allCases) { Text($0.rawValue).tag($0) } }.pickerStyle(.segmented)
                TextField("Measured weight kg (optional through age 10)", text: $measuredWeight).keyboardType(.decimalPad)
                if measuredWeight.trimmed.isEmpty {
                    if let estimatedWeight {
                        LabeledContent("WHO median estimate", value: "\(estimatedWeight.formatted(.number.precision(.fractionLength(1)))) kg")
                        Link("WHO weight-for-age source", destination: URL(string: PediatricWeightReference.sourceURL)!).font(.caption)
                    } else {
                        Label("Enter a measured weight. WHO weight-for-age estimates stop after age 10.", systemImage: "exclamationmark.triangle.fill").font(.caption).foregroundStyle(.orange)
                    }
                }
                if selectedRegimen?.formula == .mgPerSquareMeter { TextField("Height cm", text: $height).keyboardType(.decimalPad) }
                Picker("Kidney function", selection: $renalFunction) { Text("Normal").tag("Normal"); Text("Reduced / unknown").tag("Reduced / unknown") }
                Picker("Liver function", selection: $hepaticFunction) { Text("Normal").tag("Normal"); Text("Reduced / unknown").tag("Reduced / unknown") }
                Toggle("Pregnant", isOn: $isPregnant).disabled(sex == .male)
                Button { calculate() } label: { Label("Calculate from selected regimen", systemImage: "equal.circle.fill").frame(maxWidth: .infinity, minHeight: 48) }
                    .buttonStyle(.borderedProminent).disabled(selectedRegimen == nil)
                if !errorMessage.isEmpty { Text(errorMessage).font(.subheadline).foregroundStyle(.orange) }
                if let result {
                    VStack(alignment: .leading, spacing: 7) {
                        Text("\(result.dosePerAdministrationMG.formatted(.number.precision(.fractionLength(0...2)))) mg per administration").font(.title3.bold())
                        Text("\(result.totalDailyDoseMG.formatted(.number.precision(.fractionLength(0...2)))) mg/day in \(result.administrationsPerDay) dose(s)").font(.headline)
                        Text(result.equation).font(.system(.caption, design: .monospaced)).textSelection(.enabled)
                        if result.appliedMaximum { Label("Maximum dose cap applied", systemImage: "arrow.down.to.line.compact").foregroundStyle(.orange) }
                        ForEach(result.cautions, id: \.self) { Label($0, systemImage: "exclamationmark.triangle").font(.caption) }
                    }.padding(12).background(theme.softTint, in: RoundedRectangle(cornerRadius: 14))
                }
            }
            .padding(16).background(theme.card, in: RoundedRectangle(cornerRadius: 20))
        }
    }

    private func calculate() {
        guard let regimen = selectedRegimen else { return }
        let measured = Double(measuredWeight.replacingOccurrences(of: ",", with: "."))
        let input = DosePatientInput(ageMonths: ageMonths, sexAtBirth: sex, measuredWeightKG: measured, estimatedWeightKG: measured == nil ? estimatedWeight : nil, heightCM: Double(height.replacingOccurrences(of: ",", with: ".")), renalFunction: renalFunction, hepaticFunction: hepaticFunction, isPregnant: isPregnant)
        do { result = try DoseCalculator.calculate(regimen: regimen, input: input); errorMessage = "" }
        catch { result = nil; errorMessage = error.localizedDescription }
    }

    private func regimenSummary(_ regimen: DoseRegimen) -> String {
        switch regimen.formula {
        case .fixed: return "\(regimen.fixedDoseMG?.formatted() ?? "—") mg • \(regimen.route)"
        case .mgPerKgPerDose: return "\(regimen.amountPerKG?.formatted() ?? "—") mg/kg/dose • \(regimen.dividedDoses ?? 1)× daily"
        case .mgPerKgPerDay: return "\(regimen.amountPerKG?.formatted() ?? "—") mg/kg/day ÷ \(regimen.dividedDoses ?? 1)"
        case .mgPerSquareMeter: return "\(regimen.amountPerSquareMeter?.formatted() ?? "—") mg/m²/dose"
        }
    }
}

private struct ProductLeafletEditorView: View {
    @Environment(\.modelContext) private var context
    let product: DrugProduct
    let drug: Drug
    @State private var tradeName: String
    @State private var manufacturer: String
    @State private var marketedStrengthLabel: String
    @State private var dosageForm: String
    @State private var route: String
    @State private var country: String
    @State private var ingredientComponents: [IngredientComponent]
    @State private var leafletText: String
    @State private var imageData: Data?
    @State private var thumbnailData: Data?
    @State private var additionalImageData: [Data]
    @State private var additionalThumbnailData: [Data]
    @State private var photoItems: [PhotosPickerItem] = []
    @State private var imageFlow: ImageFlowDestination?
    @State private var pendingCameraDraft: ImageDraft?
    @State private var message: String?

    init(product: DrugProduct, drug: Drug) {
        self.product = product; self.drug = drug
        _tradeName = State(initialValue: product.tradeName)
        _manufacturer = State(initialValue: product.manufacturer)
        _marketedStrengthLabel = State(initialValue: product.marketedStrengthLabel)
        _dosageForm = State(initialValue: product.dosageForm)
        _route = State(initialValue: product.route)
        _country = State(initialValue: product.country)
        _ingredientComponents = State(initialValue: product.ingredientComponents)
        _leafletText = State(initialValue: product.leafletText)
        _imageData = State(initialValue: product.imageData)
        _thumbnailData = State(initialValue: product.thumbnailData)
        _additionalImageData = State(initialValue: product.additionalImageData)
        _additionalThumbnailData = State(initialValue: product.additionalThumbnailData)
    }

    var body: some View {
        Form {
            Section("Brand product") {
                TextField("Trade name", text: $tradeName)
                TextField("Manufacturer", text: $manufacturer)
                TextField("Marketed / printed strength", text: $marketedStrengthLabel)
                TextField("Dosage form", text: $dosageForm)
                TextField("Route", text: $route)
                TextField("Country", text: $country)
            }
            Section {
                ForEach(ingredientComponents.indices, id: \.self) { index in
                    VStack(alignment: .leading, spacing: 8) {
                        TextField("Active ingredient", text: $ingredientComponents[index].name)
                        TextField("Component strength", text: $ingredientComponents[index].displayStrength)
                        TextField("Salt form (optional)", text: $ingredientComponents[index].saltForm)
                    }
                    .swipeActions {
                        Button(role: .destructive) { ingredientComponents.remove(at: index) } label: { Label("Remove", systemImage: "trash") }
                    }
                }
                Button { ingredientComponents.append(IngredientComponent(name: "")) } label: {
                    Label("Add active ingredient", systemImage: "plus.circle")
                }
            } header: {
                Text("Ingredient components")
            } footer: {
                Text("The printed total stays separate from each ingredient strength.")
            }
            Section("Package images") {
                DrugPhotoGalleryView(images: currentImages, height: 190, onRemove: removePhoto)
                Button { beginImageFlow(.camera) } label: { Label("Take another photo", systemImage: "camera.fill") }
                Button { beginImageFlow(.library) } label: { Label("Add from photo library", systemImage: "photo.on.rectangle") }
            }
            Section("Paste leaflet") {
                TextEditor(text: $leafletText).frame(minHeight: 260)
                Button("Save brand product") { save() }.buttonStyle(.borderedProminent)
            }
            Section {
                NavigationLink { DrugImportView(drug: drug, startsInAIMode: true, initialLeafletText: leafletText) } label: {
                    Label("Update ingredient profile with this leaflet", systemImage: "sparkles")
                }
            } footer: { Text("The leaflet is product-specific. You review every proposed profile change before saving.") }
        }
        .navigationTitle(tradeName.trimmed.isEmpty ? "Brand product" : tradeName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { ToolbarItem(placement: .confirmationAction) { Button("Save") { save() }.disabled(tradeName.trimmed.isEmpty) } }
        .task(id: photoItems.count) { await loadPhotoItems() }
        .photosPicker(isPresented: libraryPresentation, selection: $photoItems, maxSelectionCount: 8, matching: .images)
        .fullScreenCover(isPresented: cameraPresentation, onDismiss: presentPendingCameraDraft) {
            CameraPicker { pendingCameraDraft = ImageDraft(image: $0) }.ignoresSafeArea()
        }
        .fullScreenCover(item: cropPresentation) { draft in
            ImageEditorView(draft: draft) { appendPhoto($0) }.interactiveDismissDisabled()
        }
        .alert("Brand product", isPresented: Binding(get: { message != nil }, set: { if !$0 { message = nil } })) {
            Button("OK") { message = nil }
        } message: { Text(message ?? "") }
    }

    private var currentImages: [Data] { [imageData].compactMap { $0 } + additionalImageData }
    private var cameraPresentation: Binding<Bool> { Binding(get: { if case .camera? = imageFlow { true } else { false } }, set: { if !$0 { imageFlow = nil } }) }
    private var libraryPresentation: Binding<Bool> { Binding(get: { if case .library? = imageFlow { true } else { false } }, set: { if !$0 { imageFlow = nil } }) }
    private var cropPresentation: Binding<ImageDraft?> {
        Binding(
            get: { if case .crop(let draft)? = imageFlow { draft } else { nil } },
            set: { draft in imageFlow = draft.map { .crop($0) } }
        )
    }

    private func beginImageFlow(_ destination: ImageFlowDestination) {
        if case .camera = destination, !UIImagePickerController.isSourceTypeAvailable(.camera) {
            message = "Camera is unavailable. Choose a photo from the library instead."
        } else { imageFlow = destination }
    }
    private func presentPendingCameraDraft() { if let draft = pendingCameraDraft { pendingCameraDraft = nil; imageFlow = .crop(draft) } }
    private func appendPhoto(_ payload: DrugImagePayload) {
        if imageData == nil { imageData = payload.imageData; thumbnailData = payload.thumbnailData }
        else { additionalImageData.append(payload.imageData); additionalThumbnailData.append(payload.thumbnailData) }
    }
    private func removePhoto(at index: Int) {
        if index == 0 {
            imageData = additionalImageData.first; thumbnailData = additionalThumbnailData.first
            if !additionalImageData.isEmpty { additionalImageData.removeFirst() }
            if !additionalThumbnailData.isEmpty { additionalThumbnailData.removeFirst() }
        } else {
            let item = index - 1
            if additionalImageData.indices.contains(item) { additionalImageData.remove(at: item) }
            if additionalThumbnailData.indices.contains(item) { additionalThumbnailData.remove(at: item) }
        }
    }
    private func loadPhotoItems() async {
        guard !photoItems.isEmpty else { return }
        do {
            for item in photoItems {
                guard let data = try await item.loadTransferable(type: Data.self) else { continue }
                let payload = try ImageCompressor.payload(from: ImageCompressor.image(from: data))
                await MainActor.run { appendPhoto(payload) }
            }
            await MainActor.run { photoItems = [] }
        } catch { await MainActor.run { message = error.localizedDescription; photoItems = [] } }
    }
    private func save() {
        let cleanComponents = ingredientComponents.filter { !$0.name.trimmed.isEmpty }
        product.tradeName = tradeName.trimmed
        product.manufacturer = manufacturer.trimmed
        product.marketedStrengthLabel = marketedStrengthLabel.trimmed
        product.strength = marketedStrengthLabel.trimmed
        product.ingredientComponents = cleanComponents
        product.dosageForm = dosageForm.trimmed
        product.route = route.trimmed
        product.country = country.trimmed
        product.imageData = imageData
        product.thumbnailData = thumbnailData
        product.additionalImageData = additionalImageData
        product.additionalThumbnailData = additionalThumbnailData
        product.leafletText = leafletText
        product.leafletUpdatedAt = leafletText.trimmed.isEmpty ? nil : .now
        product.productKey = IngredientIdentity.productKey(tradeName: product.tradeName, manufacturer: product.manufacturer, strength: product.marketedStrengthLabel, dosageForm: product.dosageForm, ingredientKey: drug.canonicalIngredientKey)
        drug.tradeNames = Array(Set((drug.tradeNames + [product.tradeName]).filter { !$0.trimmed.isEmpty })).sorted()
        do { try context.save(); message = "Brand product saved." }
        catch { context.rollback(); message = error.localizedDescription }
    }
}

struct LocalDrugGraphView: View {
    @Environment(AppTheme.self) private var theme
    @Query(sort: \Drug.scientificName) private var allDrugs: [Drug]
    let drug: Drug

    private var nodes: [(label: String, icon: String, color: Color)] {
        [
            (drug.chapterRaw, drug.chapter.icon, theme.colors(for: drug.chapter).first ?? theme.tint),
            (drug.drugClass.trimmed.isEmpty ? "Class unknown" : drug.drugClass, "square.grid.2x2.fill", .indigo),
            (drug.indications.first ?? "Use unknown", "cross.case.fill", .green),
            (drug.warnings.first ?? "Warning unknown", "exclamationmark.triangle.fill", .orange),
            ("\(related.count) related drugs", "pills.fill", .teal)
        ]
    }
    private var related: [Drug] { allDrugs.filter { $0.id != drug.id && !$0.drugClass.trimmed.isEmpty && $0.drugClass.localizedCaseInsensitiveCompare(drug.drugClass) == .orderedSame } }

    var body: some View {
        GeometryReader { proxy in
            let center = CGPoint(x: proxy.size.width / 2, y: proxy.size.height / 2)
            ZStack {
                Canvas { context, _ in
                    for index in nodes.indices {
                        let target = position(index, size: proxy.size)
                        var path = Path(); path.move(to: center); path.addLine(to: target)
                        context.stroke(path, with: .color(theme.tint.opacity(0.25)), lineWidth: 1.5)
                    }
                }
                ZStack {
                    OrbitMark(progress: Double(drug.masteryCount) / 6)
                    Text(drug.displayName)
                        .font(.caption.weight(.bold))
                        .foregroundStyle(theme.ink)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .frame(width: 62)
                }
                .frame(width: 96, height: 96)
                .position(center)
                ForEach(Array(nodes.enumerated()), id: \.offset) { index, node in
                    VStack(spacing: 3) { Image(systemName: node.icon); Text(node.label).font(.caption2.weight(.semibold)).lineLimit(2).multilineTextAlignment(.center) }
                        .foregroundStyle(node.color).frame(width: 84).frame(minHeight: 48).padding(.vertical, 5)
                        .background(node.color.opacity(0.10), in: RoundedRectangle(cornerRadius: 13)).position(position(index, size: proxy.size))
                }
            }
        }
        .frame(height: 300).accessibilityElement(children: .ignore)
        .accessibilityLabel(nodes.map { "\($0.label) linked to \(drug.displayName)" }.joined(separator: "; "))
        if !related.isEmpty {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack { ForEach(related.prefix(6)) { value in NavigationLink { DrugDetailView(drug: value) } label: { Text(value.displayName).font(.caption.bold()).padding(.horizontal, 10).frame(minHeight: 38).background(.teal.opacity(0.10), in: Capsule()) }.buttonStyle(.plain) } }
            }
        }
    }
    private func position(_ index: Int, size: CGSize) -> CGPoint {
        let angle = Double(index) / Double(max(nodes.count, 1)) * .pi * 2 - .pi / 2
        return CGPoint(x: size.width / 2 + CGFloat(cos(angle)) * max(90, size.width / 2 - 48), y: size.height / 2 + CGFloat(sin(angle)) * max(92, size.height / 2 - 40))
    }
}

struct AtomicNotesView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    let drug: Drug
    @State private var kind: AtomicNoteKind = .memoryTrick
    @State private var linkedField = "General"
    @State private var noteText = ""
    @State private var contextText = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("New atomic note") {
                    Picker("Type", selection: $kind) { ForEach(AtomicNoteKind.allCases) { Text($0.rawValue).tag($0) } }
                    Picker("Linked field", selection: $linkedField) {
                        ForEach(["General", "Identity", "Uses", "Mechanism", "PK", "Safety", "Counseling", "Shelf"], id: \.self) { Text($0).tag($0) }
                    }
                    TextField("One small, specific note", text: $noteText, axis: .vertical).lineLimit(2...5)
                    TextField("Context or shift (optional)", text: $contextText)
                    Button { save() } label: { Label("Save linked note", systemImage: "link.badge.plus").frame(maxWidth: .infinity, minHeight: 44) }
                        .buttonStyle(.borderedProminent).disabled(noteText.trimmed.isEmpty)
                }
                Section("Linked to \(drug.displayName)") {
                    if drug.atomicNotes.isEmpty { Text("No atomic notes yet.").foregroundStyle(.secondary) }
                    ForEach(drug.atomicNotes) { note in
                        VStack(alignment: .leading, spacing: 5) {
                            HStack { Text(note.kind.rawValue).font(.caption.bold()); Spacer(); Text(note.linkedField).font(.caption2).foregroundStyle(.secondary) }
                            Text(note.text)
                            if !note.context.trimmed.isEmpty { Text(note.context).font(.caption).foregroundStyle(.secondary) }
                        }
                        .swipeActions { Button("Delete", role: .destructive) { remove(note) } }
                    }
                }
            }
            .navigationTitle("Atomic Notes").navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .confirmationAction) { Button("Done") { dismiss() } } }
        }
    }

    private func save() {
        var notes = drug.atomicNotes
        notes.insert(AtomicDrugNote(kindRaw: kind.rawValue, text: noteText.trimmed, linkedField: linkedField, context: contextText.trimmed), at: 0)
        drug.atomicNotes = notes; try? context.save(); noteText = ""; contextText = ""
    }
    private func remove(_ note: AtomicDrugNote) { drug.atomicNotes = drug.atomicNotes.filter { $0.id != note.id }; try? context.save() }
}
