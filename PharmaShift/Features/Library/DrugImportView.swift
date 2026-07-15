import PhotosUI
import SwiftData
import SwiftUI
import UIKit

private enum ImportStage: Int, CaseIterable {
    case photo, confirm, source, preview, challenge

    var title: String {
        switch self {
        case .photo: "Package AI"
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

private enum ImportMode {
    case trusted
    case aiDraft
}

struct DrugImportView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Environment(AppTheme.self) private var theme

    let drug: Drug?
    let providers: [any DrugSourceProvider]
    let aiService: any DrugImportFormattingService
    let packageRecognizer: any DrugPackageRecognizing
    let startsInAIMode: Bool

    @State private var stage: ImportStage = .photo
    @State private var photoItems: [PhotosPickerItem] = []
    @State private var imageFlow: ImageFlowDestination?
    @State private var pendingCameraDraft: ImageDraft?
    @State private var imageData: Data?
    @State private var thumbnailData: Data?
    @State private var additionalImageData: [Data] = []
    @State private var additionalThumbnailData: [Data] = []
    @State private var packageRecognition = PackageRecognitionResult.empty
    @State private var detectedText = ""
    @State private var identity: UserConfirmedDrugIdentity
    @State private var results: [DrugSearchResult] = []
    @State private var selectedResult: DrugSearchResult?
    @State private var selectedProviderName = ""
    @State private var trustedPacket: TrustedDrugSourcePacket?
    @State private var importedInfo: ImportedDrugInfo?
    @State private var selection = ImportSelection(sections: Set(ImportSection.allCases))
    @State private var isLoading = false
    @State private var loadingMessage = ""
    @State private var message: String?
    @State private var savedDrug: Drug?
    @State private var opensSavedDrug = false
    @State private var resolvedIdentity: ResolvedDrugIdentity?
    @State private var importMode: ImportMode = .trusted
    private let identityResolver: any DrugIdentityResolving = DeepSeekIdentityResolver()
    private let fastGatherService: any FastDrugGatheringService

    init(
        drug: Drug? = nil,
        providers: [any DrugSourceProvider] = DrugSourceProviderFactory.appDefault(),
        aiService: any DrugImportFormattingService = DrugSourceProviderFactory.aiDefault(),
        packageRecognizer: any DrugPackageRecognizing = ProcessInfo.processInfo.arguments.contains("-mockDrugImport") ? MockGeminiPackageVisionService() : GeminiPackageVisionService(),
        fastGatherService: any FastDrugGatheringService = ProcessInfo.processInfo.arguments.contains("-mockDrugImport") ? MockFastDrugGatherService() : DeepSeekFastDrugGatherService(),
        startsInAIMode: Bool = false,
        initialLeafletText: String = ""
    ) {
        self.drug = drug
        self.providers = providers
        self.aiService = aiService
        self.packageRecognizer = packageRecognizer
        self.fastGatherService = fastGatherService
        self.startsInAIMode = startsInAIMode
        let skipsPhotoInTests = ProcessInfo.processInfo.arguments.contains("-mockDrugImportSkipPhoto")
        _stage = State(initialValue: startsInAIMode || skipsPhotoInTests ? .confirm : .photo)
        _importMode = State(initialValue: startsInAIMode ? .aiDraft : .trusted)
        _imageData = State(initialValue: drug?.imageData)
        _thumbnailData = State(initialValue: drug?.thumbnailData)
        _additionalImageData = State(initialValue: drug?.additionalImageData ?? [])
        _additionalThumbnailData = State(initialValue: drug?.additionalThumbnailData ?? [])
        _detectedText = State(initialValue: initialLeafletText)
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
        .navigationTitle(startsInAIMode ? "Generate with AI" : "Trusted Import")
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
                recognizePackage()
            }
            .interactiveDismissDisabled()
        }
        .overlay {
            if isLoading {
                VStack(spacing: 10) {
                    ProgressView()
                    Text(loadingMessage.isEmpty ? (startsInAIMode ? "Building your complete learning card..." : "Working from trusted source text...") : loadingMessage)
                        .font(.subheadline.weight(.semibold))
                        .multilineTextAlignment(.center)
                }
                .padding()
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
        }
        .disabled(isLoading)
        .alert("Renlyst", isPresented: Binding(get: { message != nil }, set: { if !$0 { message = nil } })) {
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
            recognition: packageRecognition,
            detectedText: $detectedText,
            onCamera: { beginImageFlow(.camera) },
            onLibrary: { beginImageFlow(.library) },
            onRemovePhoto: removePhoto,
            onUseCurrent: {
                prefillIdentityFromRecognition()
                stage = .confirm
            }
        )
        case .confirm: ConfirmDrugIdentityView(
            identity: $identity,
            canContinue: identity.isComplete,
            actionTitle: startsInAIMode ? "Generate complete card" : "Search trusted sources",
            actionIcon: startsInAIMode ? "sparkles.rectangle.stack.fill" : "checkmark.seal.fill",
            isAIMode: startsInAIMode,
            hasImages: !currentImages.isEmpty,
            onAddPhoto: { stage = .photo }
        ) {
            if startsInAIMode {
                fastGather()
            } else {
                stage = .source
                searchTrustedSources()
            }
        }
        case .source: ImportSourceSearchView(
            query: identity.scientificName,
            results: results,
            selectedID: selectedResult?.id,
            onSearch: searchTrustedSources,
            onChoose: loadSource,
            resolvedIdentity: resolvedIdentity,
            onAcceptResolvedIdentity: acceptResolvedIdentity,
            packageText: $detectedText,
            onFastGather: fastGather
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
                ForEach(visibleStages, id: \.self) { item in
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

    private var visibleStages: [ImportStage] {
        startsInAIMode ? [.photo, .confirm, .preview, .challenge] : ImportStage.allCases
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
            for item in photoItems {
                guard let data = try await item.loadTransferable(type: Data.self) else { continue }
                let image = try ImageCompressor.image(from: data)
                let payload = try ImageCompressor.payload(from: image)
                await MainActor.run { appendPhoto(payload) }
            }
            await MainActor.run { photoItems = [] }
            await MainActor.run { recognizePackage() }
        } catch {
            await MainActor.run { message = error.localizedDescription; photoItems = [] }
        }
    }

    private func recognizePackage() {
        let images = currentImages
        guard !images.isEmpty else { return }
        isLoading = true
        loadingMessage = "Gemini 2.5 Flash is identifying the package and ingredient strengths..."
        Task {
            do {
                let recognition = try await packageRecognizer.recognize(images: images)
                await MainActor.run {
                    packageRecognition = recognition
                    if detectedText.trimmed.isEmpty { detectedText = recognition.packageEvidenceText }
                    prefillIdentityFromRecognition()
                    stage = .confirm
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    message = error.localizedDescription
                    stage = .confirm
                    isLoading = false
                }
            }
        }
    }

    private func prefillIdentityFromRecognition() {
        if identity.scientificName.trimmed.isEmpty { identity.scientificName = packageRecognition.scientificName }
        if identity.tradeNames.isEmpty, !packageRecognition.tradeName.trimmed.isEmpty { identity.tradeNames = [packageRecognition.tradeName] }
        if identity.strength.trimmed.isEmpty { identity.strength = packageRecognition.marketedStrengthLabel }
        if identity.dosageForm.trimmed.isEmpty { identity.dosageForm = packageRecognition.dosageForm }
        if identity.route.trimmed.isEmpty { identity.route = packageRecognition.route }
        identity.ingredients = packageRecognition.ingredients
        identity.marketedStrengthLabel = packageRecognition.marketedStrengthLabel
    }

    private func searchTrustedSources() {
        guard identity.isComplete else { message = "Confirm all required identity fields before searching."; return }
        isLoading = true
        results = []
        Task {
            var collected: [DrugSearchResult] = []
            let queryCandidates = identity.ingredients.map(\.name) + [identity.scientificName] + identity.tradeNames
            let usableQueries = queryCandidates.filter { !$0.trimmed.isEmpty }
            for provider in providers {
                for query in usableQueries where collected.filter({ $0.sourceName == provider.sourceName }).isEmpty {
                    if let found = try? await provider.searchDrug(query: query), !found.isEmpty {
                        collected.append(contentsOf: found)
                    }
                }
            }
            if collected.isEmpty {
                do {
                    let resolution = try await identityResolver.resolve(identity: identity, packageText: detectedText)
                    await MainActor.run { resolvedIdentity = resolution; isLoading = false }
                    return
                } catch {
                    await MainActor.run { message = error.localizedDescription; isLoading = false }
                    return
                }
            }
            await MainActor.run {
                results = DrugSearchRanker.ranked(collected, identity: identity)
                isLoading = false
                if collected.isEmpty { message = "No trusted source match found. Try another scientific or trade name." }
            }
        }
    }

    private func acceptResolvedIdentity(_ resolution: ResolvedDrugIdentity) {
        identity.scientificName = resolution.scientificName
        if identity.dosageForm.trimmed.isEmpty { identity.dosageForm = resolution.dosageForm }
        if identity.route.trimmed.isEmpty { identity.route = resolution.route }
        resolvedIdentity = nil
        searchTrustedSources()
    }

    private func loadSource(_ result: DrugSearchResult) {
        importMode = .trusted
        selectedResult = result
        selectedProviderName = result.sourceName
        guard let provider = providers.first(where: { $0.sourceName == result.sourceName }) else { return }
        isLoading = true
        loadingMessage = "Reading the selected source, then generating five focused clinical sections..."
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
        try await aiService.format(packet: packet, identity: identity)
    }

    private func retryAI() {
        isLoading = true
        loadingMessage = "Retrying the focused clinical section requests..."
        Task {
            do {
                let info: ImportedDrugInfo
                switch importMode {
                case .trusted:
                    guard let packet = trustedPacket else { throw DrugImportError.invalidResponse }
                    info = try await formatWithRetry(packet: packet)
                case .aiDraft:
                    info = try await fastGatherService.gather(identity: identity, packageText: detectedText)
                }
                await MainActor.run { importedInfo = info; isLoading = false }
            } catch {
                await MainActor.run { message = error.localizedDescription; isLoading = false }
            }
        }
    }

    private func fastGather() {
        guard identity.isComplete else { message = "Confirm the drug name before creating an AI draft."; return }
        isLoading = true
        loadingMessage = "Checking trusted sources in parallel (maximum 8 seconds)..."
        importMode = .aiDraft
        Task {
            do {
                let packets = await gatherTrustedPackets()
                await MainActor.run {
                    loadingMessage = packets.isEmpty
                        ? "Generating five focused sections from the confirmed drug..."
                        : "Generating five focused sections from trusted evidence..."
                }
                let packet = mergedPacket(packets, leafletText: detectedText)
                let info = packets.isEmpty
                    ? try await fastGatherService.gather(identity: identity, packageText: detectedText)
                    : try await formatWithRetry(packet: packet)
                await MainActor.run {
                    trustedPacket = packets.isEmpty ? nil : packet
                    importedInfo = info
                    selection = DrugImportApplier.defaultSelection(info: info, drug: drug)
                    importMode = packets.isEmpty ? .aiDraft : .trusted
                    stage = .preview
                    isLoading = false
                }
            } catch {
                await MainActor.run { message = error.localizedDescription; isLoading = false }
            }
        }
    }

    private func gatherTrustedPackets() async -> [TrustedDrugSourcePacket] {
        let queries = (identity.ingredients.map(\.name) + [identity.scientificName] + identity.tradeNames).filter { !$0.trimmed.isEmpty }
        let packets = await withTaskGroup(of: TrustedDrugSourcePacket?.self, returning: [TrustedDrugSourcePacket].self) { group in
            for provider in providers {
                group.addTask { await Self.firstPacket(from: provider, queries: queries) }
            }
            var values: [TrustedDrugSourcePacket] = []
            for await packet in group {
                if let packet { values.append(packet) }
            }
            return values
        }
        let priority = ["Altibbi": 0, "DailyMed": 1, "RxNorm": 2, "openFDA": 3]
        return packets.sorted { priority[$0.sourceName, default: 9] < priority[$1.sourceName, default: 9] }
    }

    private static func firstPacket(from provider: any DrugSourceProvider, queries: [String]) async -> TrustedDrugSourcePacket? {
        await withTaskGroup(of: TrustedDrugSourcePacket?.self, returning: TrustedDrugSourcePacket?.self) { group in
            group.addTask {
                for query in queries {
                    guard !Task.isCancelled else { return nil }
                    if let results = try? await provider.searchDrug(query: query),
                       let result = results.first,
                       let packet = try? await provider.fetchDrugDetails(id: result.id) {
                        return packet
                    }
                }
                return nil
            }
            group.addTask {
                try? await Task.sleep(for: .seconds(8))
                return nil
            }
            let first = await group.next() ?? nil
            group.cancelAll()
            return first
        }
    }

    private func mergedPacket(_ packets: [TrustedDrugSourcePacket], leafletText: String) -> TrustedDrugSourcePacket {
        func joined(_ value: (TrustedDrugSourcePacket) -> String, limit: Int = 2_800) -> String {
            let sourced = packets.compactMap { packet -> String? in
                let text = value(packet).trimmed
                guard !text.isEmpty else { return nil }
                return "[\(packet.sourceName)] \(text)"
            }.joined(separator: "\n\n")
            return TrustedDrugSourcePacketExtractor.compact(sourced, limit: limit)
        }
        let primary = packets.first(where: { $0.sourceName == "Altibbi" }) ?? packets.first
        return TrustedDrugSourcePacket(
            sourceName: packets.map(\.sourceName).joined(separator: " + "), sourceURL: primary?.sourceURL ?? "",
            indicationsText: joined(\.indicationsText), dosageText: joined(\.dosageText), contraindicationsText: joined(\.contraindicationsText),
            warningsText: joined(\.warningsText), adverseReactionsText: joined(\.adverseReactionsText), interactionsText: joined(\.interactionsText, limit: 12_000),
            pharmacokineticsText: joined(\.pharmacokineticsText), pregnancyText: joined(\.pregnancyText), dosageFormsText: joined(\.dosageFormsText),
            routeText: joined(\.routeText), activeIngredientText: joined(\.activeIngredientText), lastUpdatedText: nil,
            isTruncated: packets.contains(where: \.isTruncated), leafletText: String(leafletText.prefix(4_000))
        )
    }

    private func saveImport() {
        guard let importedInfo else { return }
        let components = importedInfo.identity.activeIngredients ?? identity.ingredients
        let ingredientNames = components.map(\.name).filter { !$0.trimmed.isEmpty }
        let ingredientKey = IngredientIdentity.canonicalKey(names: ingredientNames.isEmpty ? [importedInfo.identity.scientificName] : ingredientNames)
        let existing = (try? context.fetch(FetchDescriptor<Drug>()))?.first { $0.canonicalIngredientKey == ingredientKey || IngredientIdentity.canonicalKey(names: $0.ingredientNames) == ingredientKey }
        let target = drug ?? existing ?? Drug(dateAdded: .now, nextReviewDate: .now)
        if drug == nil && existing == nil { context.insert(target) }
        DrugImportApplier.apply(importedInfo, selection: selection, to: target, imageData: imageData, thumbnailData: thumbnailData)
        target.additionalImageData = additionalImageData
        target.additionalThumbnailData = additionalThumbnailData
        target.trustedSourceWasTruncated = importMode == .trusted && trustedPacket?.isTruncated == true
        let tradeName = importedInfo.identity.tradeNames.first ?? target.firstTradeName
        let productKey = IngredientIdentity.productKey(tradeName: tradeName, manufacturer: "", strength: importedInfo.identity.strength, dosageForm: importedInfo.identity.dosageForm, ingredientKey: target.canonicalIngredientKey)
        if !target.products.contains(where: { $0.productKey == productKey }) {
            let product = DrugProduct(productKey: productKey, tradeName: tradeName, manufacturer: packageRecognition.manufacturer, strength: importedInfo.identity.strength, marketedStrengthLabel: importedInfo.identity.marketedStrengthLabel ?? identity.marketedStrengthLabel, ingredientComponents: components, dosageForm: importedInfo.identity.dosageForm, route: importedInfo.identity.route, country: packageRecognition.country, imageData: imageData, additionalImageData: additionalImageData, thumbnailData: thumbnailData, additionalThumbnailData: additionalThumbnailData, leafletText: detectedText, leafletUpdatedAt: detectedText.trimmed.isEmpty ? nil : .now, sourceName: importedInfo.sourceQuality.sourceName, sourceURL: importedInfo.sourceQuality.sourceURL, profile: target)
            context.insert(product)
            target.products.append(product)
        }
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
    let recognition: PackageRecognitionResult
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
                Text("Package photos are sent to Gemini 2.5 Flash for semantic medicine-package recognition. They are not sent to DeepSeek.")
            }
            Section("Recognized package") {
                if recognition.confidence > 0 {
                    LabeledContent("Confidence", value: recognition.confidence.formatted(.percent.precision(.fractionLength(0))))
                }
                TextEditor(text: $detectedText)
                    .frame(minHeight: 100)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                candidateRow("Ingredients", recognition.scientificName)
                ForEach(recognition.ingredients) { component in
                    candidateRow(component.name, component.strengthText)
                }
                candidateRow("Trade", recognition.tradeName)
                candidateRow("Marketed strength", recognition.marketedStrengthLabel)
                candidateRow("Form", recognition.dosageForm)
                candidateRow("Manufacturer", recognition.manufacturer)
                ForEach(recognition.ambiguities, id: \.self) { ambiguity in
                    Label(ambiguity, systemImage: "questionmark.circle")
                        .foregroundStyle(.secondary)
                }
            }
            Section {
                Button { onUseCurrent() } label: {
                    Label("Confirm identity fields", systemImage: "arrow.right.circle.fill").frame(maxWidth: .infinity, minHeight: 48)
                }
                .buttonStyle(.borderedProminent)
                .accessibilityIdentifier("trustedImport.confirmIdentity")
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
    let actionTitle: String
    let actionIcon: String
    let isAIMode: Bool
    let hasImages: Bool
    let onAddPhoto: () -> Void
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
                    .accessibilityIdentifier("trustedImport.scientificName")
                TextField("Trade name(s), one per line", text: tradeNamesText, axis: .vertical)
                    .lineLimit(2...5)
                TextField("Marketed package strength (optional)", text: $identity.strength)
                TextField("Dosage form (optional)", text: $identity.dosageForm)
                TextField("Route (optional)", text: $identity.route)
                Picker("System / Chapter", selection: $identity.system) {
                    ForEach(Chapter.allCases) { Text($0.rawValue).tag($0.rawValue) }
                }
            } header: {
                Text(isAIMode ? "Tell AI which drug to build" : "Name required before import")
            } footer: {
                Text(isAIMode
                     ? "Enter a scientific or trade name. No source is required; AI will build the complete card and you choose what to save."
                     : "Form and route help rank a product. Class is derived from the selected trusted source and stays editable later.")
            }
            Section {
                ForEach(identity.ingredients.indices, id: \.self) { index in
                    VStack(alignment: .leading, spacing: 8) {
                        TextField("Active ingredient", text: $identity.ingredients[index].name)
                        TextField("Component strength (for example 24 mg)", text: $identity.ingredients[index].displayStrength)
                        TextField("Salt form (optional)", text: $identity.ingredients[index].saltForm)
                    }
                    .swipeActions {
                        Button(role: .destructive) { identity.ingredients.remove(at: index) } label: {
                            Label("Remove", systemImage: "trash")
                        }
                    }
                }
                Button {
                    identity.ingredients.append(IngredientComponent(name: ""))
                } label: {
                    Label("Add active ingredient", systemImage: "plus.circle")
                }
                TextField("Printed total / marketed strength", text: $identity.marketedStrengthLabel)
            } header: {
                Text("Combination ingredients")
            } footer: {
                Text("Keep each ingredient strength separate. A printed total such as 50 mg stays a product label, not a clinical dose.")
            }
            if isAIMode {
                Section("Package image (optional)") {
                    Button(action: onAddPhoto) {
                        Label(hasImages ? "Change package photos" : "Add a package photo", systemImage: hasImages ? "photo.stack.fill" : "camera.fill")
                    }
                    if hasImages { Label("Photo attached to this trade product", systemImage: "checkmark.circle.fill").foregroundStyle(.green) }
                }
            }
            Section {
                Button {
                    let componentNames = identity.ingredients.map(\.name).filter { !$0.trimmed.isEmpty }
                    if !componentNames.isEmpty { identity.scientificName = componentNames.joined(separator: " + ") }
                    if identity.marketedStrengthLabel.trimmed.isEmpty { identity.marketedStrengthLabel = identity.strength }
                    if identity.strength.trimmed.isEmpty { identity.strength = identity.marketedStrengthLabel }
                    onContinue()
                } label: {
                    Label(actionTitle, systemImage: actionIcon).frame(maxWidth: .infinity, minHeight: 48)
                }
                .buttonStyle(.borderedProminent)
                .disabled(!canContinue)
                .accessibilityIdentifier("trustedImport.continue")
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
    let resolvedIdentity: ResolvedDrugIdentity?
    let onAcceptResolvedIdentity: (ResolvedDrugIdentity) -> Void
    @Binding var packageText: String
    let onFastGather: () -> Void

    var body: some View {
        List {
            Section {
                LabeledContent("Confirmed query", value: query)
                Button(action: onSearch) { Label("Search again", systemImage: "magnifyingglass") }
                    .accessibilityIdentifier("trustedImport.search")
            } footer: {
                Text("Source priority: your confirmed name, RxNorm normalization, DailyMed labels, then openFDA fallback. Iraqi local trade names may not match perfectly.")
            }
            Section {
                Text("Paste the package or leaflet details below. Renlyst will use these details plus the confirmed fields to create a full AI draft without contacting the trusted-source providers.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                TextEditor(text: $packageText)
                    .frame(minHeight: 130)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                Button(action: onFastGather) {
                    Label("Create AI draft from package details", systemImage: "sparkles")
                        .frame(maxWidth: .infinity, minHeight: 48)
                }
                .buttonStyle(.borderedProminent)
                .accessibilityIdentifier("fastGatherButton")
            } header: {
                Text("Fast AI Gather — review required")
            } footer: {
                Text("Every result is marked AI-generated and needs verification against the product leaflet or a pharmacist before use.")
            }
            Section(header: Text("Trusted source matches")) {
                if let resolvedIdentity {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Local trade-name match", systemImage: "sparkle.magnifyingglass")
                            .font(.headline)
                        Text("DeepSeek suggests \(resolvedIdentity.scientificName) (\(resolvedIdentity.confidence) confidence). Confirm this ingredient before trusted-source search.")
                            .font(.subheadline).foregroundStyle(.secondary)
                        Button("Use \(resolvedIdentity.scientificName)") { onAcceptResolvedIdentity(resolvedIdentity) }
                            .buttonStyle(.borderedProminent)
                    }
                }
                if results.isEmpty {
                    Text(resolvedIdentity == nil ? "No results yet." : "Confirm the suggestion to continue.").foregroundStyle(.secondary)
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
                        .accessibilityIdentifier("trustedImport.result.\(result.id)")
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
                if info.sourceQuality.sourceName == "Generated with AI" {
                    Label("Generated with AI", systemImage: "sparkles")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.tint)
                }
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
            sectionToggle(.usesMechanism) {
                fieldToggle("uses.indications", "Main uses", info.usesMechanism.mainUses.joined(separator: " • "))
                fieldToggle("uses.mechanism", "Mechanism", info.usesMechanism.simpleMechanismArabic)
                chips(info.usesMechanism.mechanismKeywords)
            }
            sectionToggle(.pharmacokinetics) { pkPreview }
            sectionToggle(.safety) { safetyPreview }
            sectionToggle(.counseling) { counselingPreview }
            sectionToggle(.arabicExplanation) {
                fieldToggle("arabic.explanation", "Explanation", info.arabicExplanation.shortExplanation)
                fieldToggle("arabic.story", "Memory story", info.arabicExplanation.memoryStory)
                fieldToggle("arabic.note", "Important note", info.arabicExplanation.importantNote)
            }
            sectionToggle(.adverseEffects) {
                fieldToggle("effects.common", "Common", info.adverseEffects.common.joined(separator: " • "))
                fieldToggle("effects.serious", "Serious", info.adverseEffects.serious.joined(separator: " • "))
                if let effects = info.adverseEffectEntries {
                    previewList("Structured adverse effects", effects.map { [$0.name, $0.incidence].filter { !$0.trimmed.isEmpty }.joined(separator: " ") })
                }
            }
            sectionToggle(.memorization) {
                fieldToggle("memory.mustKnow", "Must know", info.memorization.mustKnow.joined(separator: " • "))
                fieldToggle("memory.flashcards", "Flashcards", info.memorization.flashcards.map { "\($0.question): \($0.answer)" }.joined(separator: " • "))
                reviewQuestions
                fieldToggle("memory.summary", "Summary", info.memorization.oneLineSummaryArabic)
            }
            Section {
                Button(action: onSave) { Label("Save selected sections", systemImage: "square.and.arrow.down.fill").frame(maxWidth: .infinity, minHeight: 48) }
                    .buttonStyle(.borderedProminent)
                    .disabled(selection.sections.isEmpty)
                    .accessibilityIdentifier("trustedImport.saveSelected")
                Button(action: {
                    selection.sections = Set(ImportSection.allCases)
                    selection.excludedFieldKeys = []
                    selection.reviewQuestionPrompts = nil
                    onSave()
                }) { Label("Save all", systemImage: "checkmark.circle.fill").frame(maxWidth: .infinity, minHeight: 44) }
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
            fieldToggle("identity.scientific", "Scientific", info.identity.scientificName)
            fieldToggle("identity.trade", "Trade", info.identity.tradeNames.joined(separator: ", "))
            fieldToggle("identity.system", "System", info.identity.system)
            fieldToggle("identity.class", "Class", info.identity.class)
            fieldToggle("identity.strength", "Strength", info.identity.strength)
            fieldToggle("identity.form", "Form", info.identity.dosageForm)
            fieldToggle("identity.route", "Route", info.identity.route)
            if let components = info.identity.activeIngredients {
                previewList("Ingredient components", components.map { "\($0.name) \($0.strengthText)" })
            }
            if let marketed = info.identity.marketedStrengthLabel { fieldToggle("identity.strength", "Marketed strength", marketed) }
            if let groups = info.dosageFormGroups {
                previewList("Dosage forms & strengths", groups.map { "\($0.dosageForm): \($0.strengths.map(\.strength).joined(separator: ", "))" })
            }
            if let doses = info.clinicalDoses {
                previewList("Dosing by indication", doses.map { "\($0.indication): \($0.doseText)" })
            }
        }
    }

    private var pkPreview: some View {
        VStack(alignment: .leading, spacing: 8) {
            fieldToggle("pk.halfLife", "Half-life", "\(info.pharmacokinetics.halfLifeDisplay) (\(info.pharmacokinetics.halfLifeBand.rawValue))")
            fieldToggle("pk.onset", "Onset", "\(info.pharmacokinetics.onsetDisplay) (\(info.pharmacokinetics.onsetBand.rawValue))")
            fieldToggle("pk.duration", "Duration", "\(info.pharmacokinetics.durationDisplay) (\(info.pharmacokinetics.durationBand.rawValue))")
            fieldToggle("pk.dosing", "Dosing", info.pharmacokinetics.dosingFrequency.rawValue)
            fieldToggle("pk.prodrug", "Prodrug", info.pharmacokinetics.prodrugStatus.rawValue)
            fieldToggle("pk.excretion", "Metabolism & excretion", [info.pharmacokinetics.metabolism, info.pharmacokinetics.excretionRoute.rawValue, info.pharmacokinetics.excretionNotes].compactMap { $0 }.joined(separator: " • "))
            fieldToggle("pk.memory", "PK memory line", info.pharmacokinetics.pkMemoryLineArabic)
            if let profile = info.pharmacologyProfile {
                previewList("Clinical pharmacology", [profile.mechanismOfAction] + profile.absorption + profile.distribution + profile.metabolism + profile.elimination)
            }
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
            if let interactions = info.interactionEntries {
                previewList("Categorized interactions", interactions.map { "\($0.category.rawValue): \($0.drugName)" })
            }
            if let reproductive = info.reproductiveSafety {
                previewList("Pregnancy & lactation", [reproductive.pregnancy, reproductive.lactation, reproductive.pregnancyArabicNote, reproductive.lactationArabicNote])
            }
        }
    }

    private var counselingPreview: some View {
        VStack(alignment: .leading, spacing: 8) {
            fieldToggle("counseling.howTo", "How to take", info.counseling.howToTakeArabic)
            fieldToggle("counseling.food", "Food", info.counseling.foodInstructionArabic)
            fieldToggle("counseling.sentence", "Patient sentence", info.counseling.simplePatientSentenceArabic)
            fieldToggle("counseling.feelings", "May feel", info.counseling.whatPatientMayFeelArabic.joined(separator: " • "))
            fieldToggle("counseling.seekHelp", "Seek help", info.counseling.whenToSeekHelpArabic.joined(separator: " • "))
            fieldToggle("counseling.missedDose", "Missed dose", info.counseling.missedDoseArabic)
        }
    }

    private func fieldToggle(_ key: String, _ label: String, _ value: String) -> some View {
        Toggle(isOn: Binding(
            get: { selection.includes(key) },
            set: { enabled in if enabled { selection.excludedFieldKeys.remove(key) } else { selection.excludedFieldKeys.insert(key) } }
        )) {
            VStack(alignment: .leading, spacing: 2) {
                Text(label).font(.caption.weight(.semibold))
                Text(value.trimmed.isEmpty ? "Unknown" : value).font(.caption2).foregroundStyle(.secondary).lineLimit(3)
            }
        }
        .accessibilityIdentifier("import.field.\(key)")
    }

    private func safetyLine(_ title: String, _ severity: Severity, _ items: [String]) -> some View {
        fieldToggle("safety.\(title.lowercased())", title, "\(severity.rawValue) • \(items.joined(separator: " • "))")
    }

    private func safetyNote(_ title: String, _ severity: Severity, _ note: String) -> some View {
        fieldToggle("safety.\(title.lowercased())", title, "\(severity.rawValue) • \(note)")
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

    private var reviewQuestions: some View {
        VStack(alignment: .leading, spacing: 9) {
            Text("Drug Review Pack").font(.caption.weight(.semibold)).foregroundStyle(.secondary)
            ForEach(info.memorization.reviewQuestions ?? [], id: \.prompt) { question in
                Toggle(isOn: Binding(
                    get: { selection.reviewQuestionPrompts?.contains(question.prompt) ?? true },
                    set: { enabled in
                        var prompts = selection.reviewQuestionPrompts ?? Set((info.memorization.reviewQuestions ?? []).map(\.prompt))
                        if enabled { prompts.insert(question.prompt) } else { prompts.remove(question.prompt) }
                        selection.reviewQuestionPrompts = prompts
                    }
                )) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(question.prompt).font(.caption.weight(.semibold))
                        Text(question.choices.joined(separator: " • ")).font(.caption2).foregroundStyle(.secondary).lineLimit(2)
                    }
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

    var body: some View {
        Form {
            Section {
                Label("Your card is ready", systemImage: "checkmark.seal.fill")
                    .font(.headline)
                Text("Lock in the new card with its AI-generated review pack. Questions use quick choices except drug-name spelling.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Section("Review pack") {
                LabeledContent("Questions", value: "\(drug.generatedReviewQuestions.count)")
                LabeledContent("Must-know facts", value: "\(drug.mustKnow.count)")
                NavigationLink { PracticeSessionView(initialDrug: drug) } label: {
                    Label("Start quick review", systemImage: "play.fill")
                }
            }
            Section {
                Button("Open Drug Card") {
                    onDone()
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity, minHeight: 48)
            }
        }
        .accessibilityIdentifier("trustedImport.challenge")
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
