import PhotosUI
import SwiftData
import SwiftUI
import UIKit

private enum ImportStage: Int, CaseIterable {
    case photo, confirm, source, preview, challenge

    var title: String {
        switch self {
        case .photo: "Photo + OCR"
        case .confirm: "Confirm"
        case .source: "Source"
        case .preview: "Preview"
        case .challenge: "Memory"
        }
    }

    var icon: String {
        switch self {
        case .photo: "camera.viewfinder"
        case .confirm: "checklist"
        case .source: "checkmark.seal"
        case .preview: "rectangle.and.text.magnifyingglass"
        case .challenge: "brain.head.profile"
        }
    }
}

struct DrugImportView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Environment(AppTheme.self) private var theme

    let drug: Drug?
    let providers: [any DrugSourceProvider]
    let aiService: any DrugImportFormattingService

    @State private var stage: ImportStage = .photo
    @State private var photoItems: [PhotosPickerItem] = []
    @State private var imageFlow: ImageFlowDestination?
    @State private var pendingCameraDraft: ImageDraft?
    @State private var imageData: Data?
    @State private var thumbnailData: Data?
    @State private var additionalImageData: [Data] = []
    @State private var additionalThumbnailData: [Data] = []
    @State private var ocrCandidate = OCRDrugCandidate(rawText: "")
    @State private var detectedText = ""
    @State private var identity: UserConfirmedDrugIdentity
    @State private var results: [DrugSearchResult] = []
    @State private var selectedResult: DrugSearchResult?
    @State private var selectedProviderName = ""
    @State private var trustedPacket: TrustedDrugSourcePacket?
    @State private var importedInfo: ImportedDrugInfo?
    @State private var selection = ImportSelection(sections: Set(ImportSection.allCases))
    @State private var isLoading = false
    @State private var message: String?
    @State private var savedDrug: Drug?
    @State private var opensSavedDrug = false
    @State private var retryCount = 0

    init(
        drug: Drug? = nil,
        providers: [any DrugSourceProvider] = DrugSourceProviderFactory.appDefault(),
        aiService: any DrugImportFormattingService = DrugSourceProviderFactory.aiDefault()
    ) {
        self.drug = drug
        self.providers = providers
        self.aiService = aiService
        _imageData = State(initialValue: drug?.imageData)
        _thumbnailData = State(initialValue: drug?.thumbnailData)
        _additionalImageData = State(initialValue: drug?.additionalImageData ?? [])
        _additionalThumbnailData = State(initialValue: drug?.additionalThumbnailData ?? [])
        _identity = State(initialValue: UserConfirmedDrugIdentity(
            scientificName: drug?.scientificName ?? "",
            tradeNames: drug?.tradeNames ?? [],
            strength: drug?.strengths.first ?? "",
            dosageForm: drug?.dosageForms.first ?? "",
            route: drug?.routes.first ?? "",
            system: drug?.chapterRaw ?? Chapter.other.rawValue,
            drugClass: drug?.drugClass ?? ""
        ))
    }

    var body: some View {
        VStack(spacing: 0) {
            stageHeader
            Divider()
            content
        }
        .navigationTitle("Trusted Import")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
        }
        .task(id: photoItemsLoadID) { await loadPhotoItems() }
        .photosPicker(isPresented: libraryPresentation, selection: $photoItems, maxSelectionCount: 8, matching: .images)
        .fullScreenCover(isPresented: cameraPresentation, onDismiss: presentPendingCameraDraft) {
            CameraPicker { pendingCameraDraft = ImageDraft(image: $0) }.ignoresSafeArea()
        }
        .fullScreenCover(item: cropPresentation) { draft in
            ImageEditorView(draft: draft) { payload in
                appendPhoto(payload)
                runOCR(from: payload.imageData)
            }
            .interactiveDismissDisabled()
        }
        .overlay {
            if isLoading {
                VStack(spacing: 10) {
                    ProgressView()
                    Text("Working from trusted source text...")
                        .font(.subheadline.weight(.semibold))
                }
                .padding()
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
        }
        .disabled(isLoading)
        .alert("PharmaShift", isPresented: Binding(get: { message != nil }, set: { if !$0 { message = nil } })) {
            Button("OK") { message = nil }
        } message: { Text(message ?? "") }
        .navigationDestination(isPresented: $opensSavedDrug) {
            if let savedDrug { DrugDetailView(drug: savedDrug) }
        }
    }

    @ViewBuilder private var content: some View {
        switch stage {
        case .photo: ImportFromPhotoView(
            images: currentImages,
            ocrCandidate: ocrCandidate,
            detectedText: $detectedText,
            onCamera: { beginImageFlow(.camera) },
            onLibrary: { beginImageFlow(.library) },
            onRemovePhoto: removePhoto,
            onUseCurrent: {
                prefillIdentityFromOCR()
                stage = .confirm
            }
        )
        case .confirm: ConfirmDrugIdentityView(identity: $identity, canContinue: identity.isComplete) {
            stage = .source
            searchTrustedSources()
        }
        case .source: ImportSourceSearchView(
            query: identity.scientificName,
            results: results,
            selectedID: selectedResult?.id,
            onSearch: searchTrustedSources,
            onChoose: loadSource
        )
        case .preview:
            if let importedInfo {
                ImportPreviewView(info: importedInfo, packet: trustedPacket, selection: $selection, onRetry: retryAI, onEdit: { stage = .confirm }, onSave: saveImport, onReject: { dismiss() })
            }
        case .challenge:
            if let savedDrug {
                ImportMemorizationChallengeView(drug: savedDrug) {
                    try? context.save()
                    opensSavedDrug = true
                }
            }
        }
    }

    private var stageHeader: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(ImportStage.allCases, id: \.self) { item in
                    Label(item.title, systemImage: item.icon)
                        .font(.caption.weight(.semibold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 7)
                        .background(item.rawValue <= stage.rawValue ? theme.tint.opacity(0.16) : Color.secondary.opacity(0.1), in: Capsule())
                        .foregroundStyle(item.rawValue <= stage.rawValue ? theme.tint : .secondary)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
        }
        .background(.bar)
    }

    private var cameraPresentation: Binding<Bool> {
        Binding(
            get: { if case .camera? = imageFlow { true } else { false } },
            set: { if !$0, case .camera? = imageFlow { imageFlow = nil } }
        )
    }

    private var libraryPresentation: Binding<Bool> {
        Binding(
            get: { if case .library? = imageFlow { true } else { false } },
            set: { if !$0, case .library? = imageFlow { imageFlow = nil } }
        )
    }

    private var cropPresentation: Binding<ImageDraft?> {
        Binding(
            get: { if case .crop(let draft)? = imageFlow { draft } else { nil } },
            set: { draft in
                if let draft { imageFlow = .crop(draft) } else { imageFlow = nil }
            }
        )
    }

    private func beginImageFlow(_ destination: ImageFlowDestination) {
        if case .camera = destination, !UIImagePickerController.isSourceTypeAvailable(.camera) {
            message = "Camera is unavailable on this device. Choose a photo from the library instead."
            return
        }
        imageFlow = destination
    }

    private func presentPendingCameraDraft() {
        guard let draft = pendingCameraDraft else { return }
        pendingCameraDraft = nil
        imageFlow = .crop(draft)
    }

    private var currentImages: [Data] { [imageData].compactMap { $0 } + additionalImageData }
    private var photoItemsLoadID: String { "\(photoItems.count)-\(photoItems.compactMap(\.itemIdentifier).joined(separator: "|"))" }

    private func appendPhoto(_ payload: DrugImagePayload) {
        if imageData == nil {
            imageData = payload.imageData
            thumbnailData = payload.thumbnailData
        } else {
            additionalImageData.append(payload.imageData)
            additionalThumbnailData.append(payload.thumbnailData)
        }
    }

    private func removePhoto(at index: Int) {
        if index == 0 {
            imageData = additionalImageData.first
            thumbnailData = additionalThumbnailData.first
            if !additionalImageData.isEmpty { additionalImageData.removeFirst() }
            if !additionalThumbnailData.isEmpty { additionalThumbnailData.removeFirst() }
        } else {
            let additionalIndex = index - 1
            if additionalImageData.indices.contains(additionalIndex) { additionalImageData.remove(at: additionalIndex) }
            if additionalThumbnailData.indices.contains(additionalIndex) { additionalThumbnailData.remove(at: additionalIndex) }
        }
    }

    private func loadPhotoItems() async {
        guard !photoItems.isEmpty else { return }
        do {
            var firstPayloadForOCR: DrugImagePayload?
            for item in photoItems {
                guard let data = try await item.loadTransferable(type: Data.self) else { continue }
                let image = try ImageCompressor.image(from: data)
                let payload = try ImageCompressor.payload(from: image)
                if firstPayloadForOCR == nil { firstPayloadForOCR = payload }
                await MainActor.run { appendPhoto(payload) }
            }
            await MainActor.run { photoItems = [] }
            if let firstPayloadForOCR { await MainActor.run { runOCR(from: firstPayloadForOCR.imageData) } }
        } catch {
            await MainActor.run { message = error.localizedDescription; photoItems = [] }
        }
    }

    private func runOCR(from data: Data) {
        guard let image = UIImage(data: data) else { return }
        isLoading = true
        Task {
            do {
                let candidate = try await OCRService().recognize(image: image)
                await MainActor.run {
                    ocrCandidate = candidate
                    detectedText = candidate.rawText
                    prefillIdentityFromOCR()
                    stage = .confirm
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    message = "OCR could not read this image. You can still type the fields manually."
                    stage = .confirm
                    isLoading = false
                }
            }
        }
    }

    private func prefillIdentityFromOCR() {
        if identity.scientificName.trimmed.isEmpty { identity.scientificName = ocrCandidate.possibleScientificName ?? "" }
        if identity.tradeNames.isEmpty, let trade = ocrCandidate.possibleTradeName { identity.tradeNames = [trade] }
        if identity.strength.trimmed.isEmpty { identity.strength = ocrCandidate.possibleStrength ?? "" }
        if identity.dosageForm.trimmed.isEmpty { identity.dosageForm = ocrCandidate.possibleDosageForm ?? "" }
    }

    private func searchTrustedSources() {
        guard identity.isComplete else { message = "Confirm all required identity fields before searching."; return }
        isLoading = true
        results = []
        Task {
            var collected: [DrugSearchResult] = []
            let queryCandidates = [identity.scientificName, identity.tradeNames.first ?? ""].filter { !$0.trimmed.isEmpty }
            for provider in providers {
                for query in queryCandidates where collected.filter({ $0.sourceName == provider.sourceName }).isEmpty {
                    if let found = try? await provider.searchDrug(query: query), !found.isEmpty {
                        collected.append(contentsOf: found)
                    }
                }
            }
            await MainActor.run {
                results = collected
                isLoading = false
                if collected.isEmpty { message = "No trusted source match found. Try another scientific or trade name." }
            }
        }
    }

    private func loadSource(_ result: DrugSearchResult) {
        selectedResult = result
        selectedProviderName = result.sourceName
        guard let provider = providers.first(where: { $0.sourceName == result.sourceName }) else { return }
        isLoading = true
        Task {
            do {
                let packet = try await provider.fetchDrugDetails(id: result.id)
                let info = try await formatWithRetry(packet: packet)
                await MainActor.run {
                    trustedPacket = packet
                    importedInfo = info
                    selection = DrugImportApplier.defaultSelection(info: info, drug: drug)
                    stage = .preview
                    isLoading = false
                }
            } catch {
                await MainActor.run { message = error.localizedDescription; isLoading = false }
            }
        }
    }

    private func formatWithRetry(packet: TrustedDrugSourcePacket) async throws -> ImportedDrugInfo {
        do { return try await aiService.format(packet: packet, identity: identity) }
        catch DrugImportError.invalidAIJSON where retryCount == 0 {
            retryCount += 1
            return try await aiService.format(packet: packet, identity: identity)
        } catch DrugImportError.aiReturnedEmpty where retryCount == 0 {
            retryCount += 1
            return try await aiService.format(packet: packet, identity: identity)
        }
    }

    private func retryAI() {
        guard let packet = trustedPacket else { return }
        isLoading = true
        retryCount = 0
        Task {
            do {
                let info = try await formatWithRetry(packet: packet)
                await MainActor.run { importedInfo = info; isLoading = false }
            } catch {
                await MainActor.run { message = error.localizedDescription; isLoading = false }
            }
        }
    }

    private func saveImport() {
        guard let importedInfo else { return }
        let target = drug ?? Drug(dateAdded: .now, nextReviewDate: .now)
        if drug == nil { context.insert(target) }
        DrugImportApplier.apply(importedInfo, selection: selection, to: target, imageData: imageData, thumbnailData: thumbnailData)
        target.additionalImageData = additionalImageData
        target.additionalThumbnailData = additionalThumbnailData
        target.trustedSourceWasTruncated = trustedPacket?.isTruncated == true
        do {
            try context.save()
            savedDrug = target
            stage = .challenge
        } catch {
            context.rollback()
            message = error.localizedDescription
        }
    }
}

private struct ImportFromPhotoView: View {
    let images: [Data]
    let ocrCandidate: OCRDrugCandidate
    @Binding var detectedText: String
    let onCamera: () -> Void
    let onLibrary: () -> Void
    let onRemovePhoto: (Int) -> Void
    let onUseCurrent: () -> Void

    var body: some View {
        List {
            Section {
                DrugPhotoGalleryView(images: images, height: 160, onRemove: onRemovePhoto)
                VStack(spacing: 10) {
                    Button(action: onCamera) { Label("Take photo", systemImage: "camera.fill") }
                        .frame(maxWidth: .infinity, minHeight: 48)
                        .buttonStyle(.borderedProminent)
                    Button(action: onLibrary) { Label("Choose photo", systemImage: "photo.on.rectangle") }
                        .frame(maxWidth: .infinity, minHeight: 48)
                        .buttonStyle(.bordered)
                }
            } footer: {
                Text("OCR runs locally with iOS Vision. The image is not sent to DeepSeek.")
            }
            Section("Detected text") {
                TextEditor(text: $detectedText)
                    .frame(minHeight: 160)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                candidateRow("Scientific", ocrCandidate.possibleScientificName)
                candidateRow("Trade", ocrCandidate.possibleTradeName)
                candidateRow("Strength", ocrCandidate.possibleStrength)
                candidateRow("Form", ocrCandidate.possibleDosageForm)
            }
            Section {
                Button { onUseCurrent() } label: {
                    Label("Confirm identity fields", systemImage: "arrow.right.circle.fill").frame(maxWidth: .infinity, minHeight: 48)
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .accessibilityIdentifier("trustedImport.photo")
    }

    @ViewBuilder private func candidateRow(_ label: String, _ value: String?) -> some View {
        if let value, !value.trimmed.isEmpty { LabeledContent(label, value: value) }
    }
}

private struct ConfirmDrugIdentityView: View {
    @Binding var identity: UserConfirmedDrugIdentity
    let canContinue: Bool
    let onContinue: () -> Void

    private var tradeNamesText: Binding<String> {
        Binding(get: { identity.tradeNames.joined(separator: "\n") }, set: { identity.tradeNames = $0.splitLines })
    }

    var body: some View {
        Form {
            Section {
                TextField("Scientific name", text: $identity.scientificName)
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled()
                TextField("Trade name(s), one per line", text: tradeNamesText, axis: .vertical)
                    .lineLimit(2...5)
                TextField("Strength", text: $identity.strength)
                TextField("Dosage form", text: $identity.dosageForm)
                TextField("Route", text: $identity.route)
                Picker("System / Chapter", selection: $identity.system) {
                    ForEach(Chapter.allCases) { Text($0.rawValue).tag($0.rawValue) }
                }
                TextField("Class", text: $identity.drugClass)
            } header: {
                Text("Required before import")
            } footer: {
                Text("These fields override the AI output because they are your memorization checkpoint.")
            }
            Section {
                Button(action: onContinue) {
                    Label("Search trusted sources", systemImage: "checkmark.seal.fill").frame(maxWidth: .infinity, minHeight: 48)
                }
                .buttonStyle(.borderedProminent)
                .disabled(!canContinue)
            }
        }
        .accessibilityIdentifier("trustedImport.confirm")
    }
}

private struct ImportSourceSearchView: View {
    let query: String
    let results: [DrugSearchResult]
    let selectedID: String?
    let onSearch: () -> Void
    let onChoose: (DrugSearchResult) -> Void

    var body: some View {
        List {
            Section {
                LabeledContent("Confirmed query", value: query)
                Button(action: onSearch) { Label("Search again", systemImage: "magnifyingglass") }
            } footer: {
                Text("Source priority: your confirmed name, RxNorm normalization, DailyMed labels, then openFDA fallback. Iraqi local trade names may not match perfectly.")
            }
            Section(header: Text("Trusted source matches")) {
                if results.isEmpty {
                    Text("No results yet.").foregroundStyle(.secondary)
                } else {
                    ForEach(results) { result in
                        Button { onChoose(result) } label: {
                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: result.sourceName == "DailyMed" ? "checkmark.seal.fill" : "doc.text.magnifyingglass")
                                    .foregroundStyle(result.sourceName == "DailyMed" ? Color.green : Color.accentColor)
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(result.displayName).font(.headline).foregroundStyle(.primary)
                                    if let active = result.activeIngredient { Text(active).font(.subheadline).foregroundStyle(.secondary) }
                                    HStack {
                                        Text(result.sourceName).font(.caption.weight(.semibold))
                                        if let form = result.dosageForm { Text(form).font(.caption) }
                                    }
                                    .foregroundStyle(.secondary)
                                }
                                Spacer()
                                if selectedID == result.id { Image(systemName: "checkmark.circle.fill").foregroundStyle(.green) }
                            }
                        }
                    }
                }
            }
        }
        .accessibilityIdentifier("trustedImport.source")
    }
}

private struct ImportPreviewView: View {
    let info: ImportedDrugInfo
    let packet: TrustedDrugSourcePacket?
    @Binding var selection: ImportSelection
    let onRetry: () -> Void
    let onEdit: () -> Void
    let onSave: () -> Void
    let onReject: () -> Void

    var body: some View {
        List {
            Section("Source quality") {
                HStack {
                    Label(info.sourceQuality.sourceName, systemImage: info.sourceQuality.needsReview ? "exclamationmark.triangle.fill" : "checkmark.seal.fill")
                        .foregroundStyle(info.sourceQuality.needsReview ? .orange : .green)
                    Spacer()
                    if packet?.isTruncated == true { Text("Trimmed").font(.caption.bold()).foregroundStyle(.orange) }
                }
                if !info.sourceQuality.notes.trimmed.isEmpty { Text(info.sourceQuality.notes).font(.caption).foregroundStyle(.secondary) }
                if !info.sourceQuality.missingImportantFields.isEmpty {
                    Text("Missing: \(info.sourceQuality.missingImportantFields.joined(separator: ", "))")
                        .font(.caption)
                        .foregroundStyle(.orange)
                }
            }
            sectionToggle(.identity) { identityPreview }
            sectionToggle(.usesMechanism) { previewList("Main uses", info.usesMechanism.mainUses); arabicText(info.usesMechanism.simpleMechanismArabic); chips(info.usesMechanism.mechanismKeywords) }
            sectionToggle(.pharmacokinetics) { pkPreview }
            sectionToggle(.safety) { safetyPreview }
            sectionToggle(.counseling) { counselingPreview }
            sectionToggle(.arabicExplanation) { arabicText(info.arabicExplanation.shortExplanation); arabicText(info.arabicExplanation.memoryStory); arabicText(info.arabicExplanation.importantNote) }
            sectionToggle(.adverseEffects) { previewList("Common", info.adverseEffects.common); previewList("Serious", info.adverseEffects.serious) }
            sectionToggle(.memorization) { previewList("Must know", info.memorization.mustKnow); flashcards(info.memorization.flashcards); arabicText(info.memorization.oneLineSummaryArabic) }
            Section {
                Button(action: onSave) { Label("Save selected sections", systemImage: "square.and.arrow.down.fill").frame(maxWidth: .infinity, minHeight: 48) }
                    .buttonStyle(.borderedProminent)
                    .disabled(selection.sections.isEmpty)
                Button(action: { selection.sections = Set(ImportSection.allCases); onSave() }) { Label("Save all", systemImage: "checkmark.circle.fill").frame(maxWidth: .infinity, minHeight: 44) }
                Button(action: onEdit) { Label("Edit before saving", systemImage: "pencil") }
                Button(action: onRetry) { Label("Retry AI formatting", systemImage: "arrow.clockwise") }
                Button(role: .destructive, action: onReject) { Label("Reject import", systemImage: "xmark.circle") }
            }
        }
        .accessibilityIdentifier("trustedImport.preview")
    }

    private func sectionToggle<Content: View>(_ section: ImportSection, @ViewBuilder content: () -> Content) -> some View {
        Section {
            Toggle(section.rawValue, isOn: Binding(
                get: { selection.sections.contains(section) },
                set: { enabled in if enabled { selection.sections.insert(section) } else { selection.sections.remove(section) } }
            ))
            content()
        }
    }

    private var identityPreview: some View {
        VStack(alignment: .leading, spacing: 6) {
            LabeledContent("Scientific", value: info.identity.scientificName)
            LabeledContent("Trade", value: info.identity.tradeNames.joined(separator: ", "))
            LabeledContent("Class", value: info.identity.class)
            LabeledContent("Strength", value: info.identity.strength)
            LabeledContent("Form", value: info.identity.dosageForm)
            LabeledContent("Route", value: info.identity.route)
        }
    }

    private var pkPreview: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Half-life: \(info.pharmacokinetics.halfLifeDisplay) (\(info.pharmacokinetics.halfLifeBand.rawValue))")
            Text("Onset: \(info.pharmacokinetics.onsetDisplay) (\(info.pharmacokinetics.onsetBand.rawValue))")
            Text("Duration: \(info.pharmacokinetics.durationDisplay) (\(info.pharmacokinetics.durationBand.rawValue))")
            Text("Dosing: \(info.pharmacokinetics.dosingFrequency.rawValue)")
            arabicText(info.pharmacokinetics.pkMemoryLineArabic)
        }
        .font(.subheadline)
    }

    private var safetyPreview: some View {
        VStack(alignment: .leading, spacing: 8) {
            safetyLine("Contraindications", info.safety.contraindications.severity, info.safety.contraindications.items)
            safetyLine("Toxicity", info.safety.toxicity.severity, info.safety.toxicity.items)
            safetyLine("Warnings", info.safety.warnings.severity, info.safety.warnings.items)
            safetyLine("Interactions", info.safety.interactions.severity, info.safety.interactions.items)
            safetyNote("Renal", info.safety.renalCaution.severity, info.safety.renalCaution.note)
            safetyNote("Hepatic", info.safety.hepaticCaution.severity, info.safety.hepaticCaution.note)
            safetyNote("Pregnancy", info.safety.pregnancyCaution.severity, info.safety.pregnancyCaution.simpleNoteArabic)
        }
    }

    private var counselingPreview: some View {
        VStack(alignment: .leading, spacing: 8) {
            arabicText(info.counseling.howToTakeArabic)
            arabicText(info.counseling.foodInstructionArabic)
            arabicText(info.counseling.simplePatientSentenceArabic)
            previewList("May feel", info.counseling.whatPatientMayFeelArabic)
            previewList("Seek help", info.counseling.whenToSeekHelpArabic)
            arabicText(info.counseling.missedDoseArabic)
        }
    }

    private func safetyLine(_ title: String, _ severity: Severity, _ items: [String]) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            severityBadge(title, severity)
            ForEach(items, id: \.self) { Text($0).font(.caption) }
        }
    }

    private func safetyNote(_ title: String, _ severity: Severity, _ note: String) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            severityBadge(title, severity)
            if !note.trimmed.isEmpty { Text(note).font(.caption) }
        }
    }

    private func severityBadge(_ title: String, _ severity: Severity) -> some View {
        Text("\(title): \(severity.rawValue)")
            .font(.caption.weight(.bold))
            .padding(.horizontal, 7)
            .padding(.vertical, 4)
            .background(severityColor(severity).opacity(0.15), in: Capsule())
            .foregroundStyle(severityColor(severity))
    }

    private func previewList(_ title: String, _ values: [String]) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title).font(.caption.weight(.semibold)).foregroundStyle(.secondary)
            ForEach(values.filter { !$0.trimmed.isEmpty }, id: \.self) { Text("• \($0)").font(.caption) }
        }
    }

    private func chips(_ values: [String]) -> some View {
        FlowChips(values: values)
    }

    private func flashcards(_ cards: [Flashcard]) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            ForEach(cards) { card in
                VStack(alignment: .leading, spacing: 2) {
                    Text(card.question).font(.caption.weight(.bold))
                    Text(card.answer).font(.caption).foregroundStyle(.secondary)
                }
            }
        }
    }

    private func arabicText(_ value: String) -> some View {
        Group {
            if !value.trimmed.isEmpty {
                Text(value)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .environment(\.layoutDirection, .rightToLeft)
            }
        }
    }

    private func severityColor(_ severity: Severity) -> Color {
        switch severity { case .unknown: .secondary; case .low: .green; case .medium: .orange; case .high: .red }
    }
}

private struct ImportMemorizationChallengeView: View {
    let drug: Drug
    let onDone: () -> Void
    @State private var scientific = ""
    @State private var drugClass = ""
    @State private var warning = ""
    @State private var graded = false

    private var scientificOK: Bool { scientific.trimmed.localizedCaseInsensitiveCompare(drug.scientificName.trimmed) == .orderedSame }
    private var classOK: Bool { drugClass.trimmed.localizedCaseInsensitiveCompare(drug.drugClass.trimmed) == .orderedSame }
    private var warningOK: Bool {
        guard let expected = drug.warnings.first?.trimmed, !expected.isEmpty else { return false }
        return warning.localizedCaseInsensitiveContains(expected) || expected.localizedCaseInsensitiveContains(warning.trimmed)
    }

    var body: some View {
        Form {
            Section {
                Label("Quick memory challenge", systemImage: "brain.head.profile")
                    .font(.headline)
                Text("Three tiny checks before this card joins your shelf memory.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Section("Answer from memory") {
                TextField("What is the scientific name?", text: $scientific)
                TextField("What is the class?", text: $drugClass)
                TextField("What is the main warning?", text: $warning, axis: .vertical).lineLimit(2...4)
            }
            if graded {
                Section("Result") {
                    resultRow("Scientific name", scientificOK)
                    resultRow("Class", classOK)
                    resultRow("Main warning", warningOK)
                    Text(drug.isConfusing ? "Marked weak/confusing for extra practice." : "Nice. Mastery increased.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            Section {
                Button(graded ? "Open Drug Card" : "Check answers") {
                    if graded { onDone() } else { grade() }
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity, minHeight: 48)
            }
        }
        .accessibilityIdentifier("trustedImport.challenge")
    }

    private func resultRow(_ title: String, _ correct: Bool) -> some View {
        Label(title, systemImage: correct ? "checkmark.circle.fill" : "xmark.circle.fill")
            .foregroundStyle(correct ? .green : .orange)
    }

    private func grade() {
        drug.masteryScientificName = scientificOK
        drug.masteryClass = classOK
        drug.masteryWarning = warningOK
        drug.isConfusing = !(scientificOK && classOK && warningOK)
        drug.recalculateConfidence()
        graded = true
    }
}

private struct FlowChips: View {
    let values: [String]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                ForEach(values.filter { !$0.trimmed.isEmpty }, id: \.self) { value in
                    Text(value)
                        .font(.caption.weight(.semibold))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 5)
                        .background(.tint.opacity(0.13), in: Capsule())
                }
            }
        }
    }
}
