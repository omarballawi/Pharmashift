import PhotosUI
import SwiftData
import SwiftUI
import UIKit

struct CaptureView: View {
    enum SaveAction { case another, later, open }
    enum FocusField { case scientific, trade, unknownLabel }

    @Environment(\.modelContext) private var context
    @Environment(AppTheme.self) private var theme
    @Environment(AppNavigation.self) private var navigation
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
    @State private var photoItem: PhotosPickerItem?
    @State private var imageFlow: ImageFlowDestination?
    @State private var pendingCameraDraft: ImageDraft?
    @State private var message: String?
    @State private var savedDrug: Drug?
    @State private var opensSavedDrug = false
    @FocusState private var focus: FocusField?

    private var canSave: Bool {
        if isUnknown { return !unknownLabel.trimmed.isEmpty || imageData != nil || !tradeName.trimmed.isEmpty }
        return !scientificName.trimmed.isEmpty || !tradeName.trimmed.isEmpty
    }

    var body: some View {
        Form {
            Section {
                DrugPhotoView(data: imageData, height: 170)
                HStack {
                    Button { beginImageFlow(.camera) } label: { Label("Camera", systemImage: "camera.fill") }
                        .frame(minHeight: 48)
                        .accessibilityIdentifier("capture.camera")
                    Spacer()
                    Button { beginImageFlow(.library) } label: {
                        Label("Photo Library", systemImage: "photo.on.rectangle")
                    }
                    .frame(minHeight: 48)
                    .accessibilityIdentifier("capture.photoLibrary")
                }
                if imageData != nil {
                    Button(role: .destructive) {
                        imageData = nil
                        thumbnailData = nil
                        photoItem = nil
                    } label: { Label("Remove photo", systemImage: "trash") }
                }
            }

            Section("Fast details") {
                Toggle("I do not know yet", isOn: $isUnknown)
                    .accessibilityIdentifier("capture.unknown")

                if isUnknown {
                    TextField("Short label, e.g. blue box on shelf 3", text: $unknownLabel)
                        .focused($focus, equals: .unknownLabel)
                }

                TextField("Scientific name", text: $scientificName)
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
                Button { save(.open) } label: { Label("Save and open card", systemImage: "rectangle.portrait.and.arrow.right") }
                    .buttonStyle(.borderedProminent)
                    .tint(theme.tint)
                    .frame(maxWidth: .infinity, minHeight: 48)
                    .disabled(!canSave)
                    .accessibilityIdentifier("capture.saveOpen")
                Button("Save and review later") { save(.later) }
                    .frame(maxWidth: .infinity, minHeight: 48)
                    .disabled(!canSave)
                Button("Add another") { save(.another) }
                    .frame(maxWidth: .infinity, minHeight: 48)
                    .disabled(!canSave)
            }
        }
        .navigationTitle("Capture")
        .scrollDismissesKeyboard(.interactively)
        .background(theme.background)
        .task(id: photoItem) {
            guard let photoItem else { return }
            do {
                guard let data = try await photoItem.loadTransferable(type: Data.self) else {
                    throw ImagePipelineError.invalidImage
                }
                imageFlow = .crop(ImageDraft(image: try ImageCompressor.image(from: data)))
                self.photoItem = nil
            } catch {
                message = error.localizedDescription
            }
        }
        .photosPicker(isPresented: libraryPresentation, selection: $photoItem, matching: .images)
        .fullScreenCover(isPresented: cameraPresentation, onDismiss: presentPendingCameraDraft) {
            CameraPicker { pendingCameraDraft = ImageDraft(image: $0) }
                .ignoresSafeArea()
        }
        .fullScreenCover(item: cropPresentation) { draft in
            ImageEditorView(draft: draft) { payload in
                imageData = payload.imageData
                thumbnailData = payload.thumbnailData
            }
            .interactiveDismissDisabled()
        }
        .alert("PharmaShift", isPresented: Binding(get: { message != nil }, set: { if !$0 { message = nil } })) {
            Button("OK") { message = nil }
        } message: { Text(message ?? "") }
        .navigationDestination(isPresented: $opensSavedDrug) {
            if let savedDrug { DrugDetailView(drug: savedDrug) }
        }
        .onAppear { focus = isUnknown ? .unknownLabel : .scientific }
        .onAppear {
            if let requested = navigation.captureChapter {
                chapter = requested
                navigation.captureChapter = nil
            }
        }
        .onChange(of: navigation.captureChapter) { _, requested in
            guard let requested else { return }
            chapter = requested
            navigation.captureChapter = nil
        }
        .onChange(of: isUnknown) { _, value in focus = value ? .unknownLabel : .scientific }
    }

    private func save(_ action: SaveAction) {
        guard canSave else { return }
        let now = Date.now
        let drug = Drug(
            scientificName: scientificName.trimmed,
            tradeNames: tradeName.trimmed.isEmpty ? [] : [tradeName.trimmed],
            chapter: chapter,
            drugClass: drugClass.trimmed,
            dosageForms: dosageForm.trimmed.isEmpty ? [] : [dosageForm.trimmed],
            strengths: strength.trimmed.isEmpty ? [] : [strength.trimmed],
            shelfLocation: shelfLocation.trimmed,
            imageData: imageData,
            timesSeen: 1,
            dateAdded: now,
            lastSeenDate: now,
            nextReviewDate: now,
            captureLabel: unknownLabel.trimmed,
            isUnknown: isUnknown
        )
        drug.thumbnailData = thumbnailData
        context.insert(drug)
        do {
            try context.save()
            savedDrug = drug
            switch action {
            case .open:
                opensSavedDrug = true
            case .another:
                reset()
                message = "Saved. Ready for another drug."
            case .later:
                reset()
                message = "Saved to your library and review queue."
            }
        } catch {
            message = "Could not save this drug. \(error.localizedDescription)"
        }
    }

    private func reset() {
        scientificName = ""; tradeName = ""; strength = ""; dosageForm = ""
        chapter = .other; drugClass = ""; shelfLocation = ""; unknownLabel = ""
        isUnknown = false; imageData = nil; thumbnailData = nil; photoItem = nil
        focus = .scientific
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
}
