import PhotosUI
import SwiftData
import SwiftUI
import UIKit

struct CaptureView: View {
    enum SaveAction { case another, later, open }
    enum FocusField { case scientific, trade, unknownLabel }

    @Environment(\.modelContext) private var context
    @Environment(AppTheme.self) private var theme
    @State private var scientificName = ""
    @State private var tradeName = ""
    @State private var strength = ""
    @State private var dosageForm = ""
    @State private var chapter: Chapter = .other
    @State private var drugClass = ""
    @State private var shelfLocation = ""
    @State private var unknownLabel = ""
    @State private var isUnknown = false
    @State private var imageData: Data?
    @State private var thumbnailData: Data?
    @State private var additionalImageData: [Data] = []
    @State private var additionalThumbnailData: [Data] = []
    @State private var photoItems: [PhotosPickerItem] = []
    @State private var imageFlow: ImageFlowDestination?
    @State private var lastImageSource: ImageAcquisitionSource?
    @State private var pendingCameraDraft: ImageDraft?
    @State private var message: String?
    @State private var saveStatus = "Ready"
    @State private var isSaving = false
    @FocusState private var focus: FocusField?
    private let onOpenSavedDrug: (UUID) -> Void

    init(initialChapter: Chapter? = nil, onOpenSavedDrug: @escaping (UUID) -> Void) {
        _chapter = State(initialValue: initialChapter ?? .other)
        self.onOpenSavedDrug = onOpenSavedDrug
    }

    private var canSave: Bool {
        if isUnknown { return !unknownLabel.trimmed.isEmpty || imageData != nil || !additionalImageData.isEmpty || !tradeName.trimmed.isEmpty }
        return !scientificName.trimmed.isEmpty
    }

    var body: some View {
        Form {
            Section {
                Label("Start with the active ingredient", systemImage: "link")
                    .font(.headline)
                Text("Create the shared drug profile first. You can add local brands and package photos from its Brands screen without changing the clinical information.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Section {
                DrugPhotoGalleryView(images: currentImages, height: 150) { removePhoto(at: $0) }
                VStack(spacing: 10) {
                    Button { beginImageFlow(.camera) } label: { Label("Camera", systemImage: "camera.fill") }
                        .frame(maxWidth: .infinity, minHeight: 48)
                        .buttonStyle(.borderedProminent)
                        .accessibilityIdentifier("capture.camera")
                        .accessibilityValue(lastImageSource == .camera ? "Selected" : "Not selected")
                    Button { beginImageFlow(.library) } label: {
                        Label("Photo Library", systemImage: "photo.on.rectangle")
                    }
                    .frame(maxWidth: .infinity, minHeight: 48)
                    .buttonStyle(.bordered)
                    .accessibilityIdentifier("capture.photoLibrary")
                    .accessibilityValue(lastImageSource == .library ? "Selected" : "Not selected")
                }
                if !currentImages.isEmpty {
                    Button(role: .destructive) {
                        imageData = nil
                        thumbnailData = nil
                        additionalImageData = []
                        additionalThumbnailData = []
                        photoItems = []
                    } label: { Label("Remove photo", systemImage: "trash") }
                }
            }

            Section("Active drug") {
                Toggle("I do not know yet", isOn: $isUnknown)
                    .accessibilityIdentifier("capture.unknown")

                if isUnknown {
                    TextField("Short label, e.g. blue box on shelf 3", text: $unknownLabel)
                        .focused($focus, equals: .unknownLabel)
                }

                TextField("Active ingredient (scientific name)", text: $scientificName)
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled()
                    .focused($focus, equals: .scientific)
                    .accessibilityIdentifier("capture.scientificName")
                TextField("Trade name", text: $tradeName)
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled()
                    .focused($focus, equals: .trade)
                    .accessibilityIdentifier("capture.tradeName")
                TextField("Strength", text: $strength)
                TextField("Dosage form", text: $dosageForm)

                Picker("Chapter", selection: $chapter) {
                    ForEach(Chapter.allCases) { Text($0.rawValue).tag($0) }
                }

                TextField("Class", text: $drugClass)
                if !chapter.quickClasses.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(chapter.quickClasses, id: \.self) { value in
                                Button(value) { drugClass = value }
                                    .buttonStyle(.bordered)
                                    .controlSize(.small)
                            }
                        }
                    }
                }
                TextField("Shelf location", text: $shelfLocation)
            }

            Section {
                Button { save(.open) } label: {
                    Label("Save and open card", systemImage: "rectangle.portrait.and.arrow.right")
                        .frame(maxWidth: .infinity, minHeight: RenlystLayout.controlHeight)
                        .contentShape(Rectangle())
                }
                .buttonStyle(RenlystPrimaryButtonStyle())
                .disabled(!canSave || isSaving)
                .accessibilityIdentifier("capture.saveOpen")
                .accessibilityValue(saveStatus)
                .simultaneousGesture(
                    TapGesture().onEnded {
                        guard canSave, !isSaving else { return }
                        save(.open)
                    }
                )
                Button("Save and review later") { save(.later) }
                    .frame(maxWidth: .infinity, minHeight: 48)
                    .disabled(!canSave || isSaving)
                Button("Add another") { save(.another) }
                    .frame(maxWidth: .infinity, minHeight: 48)
                    .disabled(!canSave || isSaving)
            }
        }
        .accessibilityIdentifier("capture.screen")
        .navigationTitle("Add active drug")
        .navigationBarTitleDisplayMode(.inline)
        .scrollDismissesKeyboard(.interactively)
        .scrollContentBackground(.hidden)
        .background(theme.background)
        .task(id: photoItemsLoadID) { await loadPhotoItems() }
        .photosPicker(isPresented: libraryPresentation, selection: $photoItems, maxSelectionCount: 8, matching: .images)
        .fullScreenCover(isPresented: cameraPresentation, onDismiss: presentPendingCameraDraft) {
            CameraPicker { pendingCameraDraft = ImageDraft(image: $0) }
                .ignoresSafeArea()
        }
        .fullScreenCover(item: cropPresentation) { draft in
            ImageEditorView(draft: draft) { payload in
                appendPhoto(payload)
            }
            .interactiveDismissDisabled()
        }
        .alert("Renlyst", isPresented: Binding(get: { message != nil }, set: { if !$0 { message = nil } })) {
            Button("OK") { message = nil }
        } message: { Text(message ?? "") }
        .onChange(of: isUnknown) { _, value in focus = value ? .unknownLabel : .scientific }
    }

    private func save(_ action: SaveAction) {
        guard !isSaving else { return }
        isSaving = true
        saveStatus = "Saving"
        let now = Date.now
        let drug = Drug(
            scientificName: scientificName.trimmed,
            tradeNames: tradeName.trimmed.isEmpty ? [] : [tradeName.trimmed],
            chapter: chapter,
            drugClass: drugClass.trimmed,
            dosageForms: dosageForm.trimmed.isEmpty ? [] : [dosageForm.trimmed],
            strengths: strength.trimmed.isEmpty ? [] : [strength.trimmed],
            shelfLocation: shelfLocation.trimmed,
            imageData: tradeName.trimmed.isEmpty ? imageData : nil,
            timesSeen: 1,
            dateAdded: now,
            lastSeenDate: now,
            nextReviewDate: now,
            captureLabel: unknownLabel.trimmed,
            isUnknown: isUnknown
        )
        drug.thumbnailData = tradeName.trimmed.isEmpty ? thumbnailData : nil
        drug.additionalImageData = tradeName.trimmed.isEmpty ? additionalImageData : []
        drug.additionalThumbnailData = tradeName.trimmed.isEmpty ? additionalThumbnailData : []
        if !scientificName.trimmed.isEmpty { drug.activeIngredients = [scientificName.trimmed] }
        drug.canonicalIngredientKey = IngredientIdentity.canonicalKey(names: drug.ingredientNames)
        context.insert(drug)
        if !tradeName.trimmed.isEmpty {
            let product = DrugProduct(
                productKey: IngredientIdentity.productKey(
                    tradeName: tradeName.trimmed,
                    manufacturer: "",
                    strength: strength.trimmed,
                    dosageForm: dosageForm.trimmed,
                    ingredientKey: drug.canonicalIngredientKey
                ),
                tradeName: tradeName.trimmed,
                strength: strength.trimmed,
                marketedStrengthLabel: strength.trimmed,
                ingredientComponents: drug.ingredientNames.map { IngredientComponent(name: $0, displayStrength: strength.trimmed) },
                dosageForm: dosageForm.trimmed,
                shelfLocation: shelfLocation.trimmed,
                imageData: imageData,
                additionalImageData: additionalImageData,
                thumbnailData: thumbnailData,
                additionalThumbnailData: additionalThumbnailData,
                sourceName: "Manual capture",
                profile: drug
            )
            context.insert(product)
            drug.products.append(product)
            DrugBrandService.synchronizeCompatibilityCache(for: drug)
        }
        do {
            try context.save()
            saveStatus = "Saved"
            switch action {
            case .open:
                onOpenSavedDrug(drug.id)
            case .another:
                reset()
                message = "Saved. Ready for another drug."
            case .later:
                reset()
                message = "Saved to your library and review queue."
            }
        } catch {
            isSaving = false
            saveStatus = "Failed"
            message = "Could not save this drug. \(error.localizedDescription)"
        }
    }

    private func reset() {
        scientificName = ""; tradeName = ""; strength = ""; dosageForm = ""
        chapter = .other; drugClass = ""; shelfLocation = ""; unknownLabel = ""
        isUnknown = false; imageData = nil; thumbnailData = nil; additionalImageData = []; additionalThumbnailData = []; photoItems = []
        isSaving = false
        saveStatus = "Ready"
        focus = .scientific
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
        } catch {
            await MainActor.run { message = error.localizedDescription; photoItems = [] }
        }
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
        switch destination {
        case .camera: lastImageSource = .camera
        case .library: lastImageSource = .library
        case .crop: break
        }
        imageFlow = destination
    }

    private func presentPendingCameraDraft() {
        guard let draft = pendingCameraDraft else { return }
        pendingCameraDraft = nil
        imageFlow = .crop(draft)
    }
}
