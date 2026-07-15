import PhotosUI
import SwiftData
import SwiftUI
import UIKit

private enum DrugEditorSection: String, CaseIterable, Identifiable {
    case basics = "Basics"
    case uses = "Uses"
    case pk = "PK"
    case safety = "Safety"
    case counseling = "Counseling"
    case notes = "My Notes"
    var id: String { rawValue }
}

struct DrugEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    let drug: Drug
    let providers: [any DrugSourceProvider]
    let aiService: any DrugImportFormattingService
    @State private var selectedSection: DrugEditorSection = .basics
    @State private var photoItems: [PhotosPickerItem] = []
    @State private var imageFlow: ImageFlowDestination?
    @State private var lastImageSource: ImageAcquisitionSource?
    @State private var pendingCameraDraft: ImageDraft?
    @State private var errorMessage: String?
    @State private var showsImport = false
    @State private var initialReviewFingerprint = ""

    init(
        drug: Drug,
        providers: [any DrugSourceProvider] = DrugSourceProviderFactory.appDefault(),
        aiService: any DrugImportFormattingService = DrugSourceProviderFactory.aiDefault()
    ) {
        self.drug = drug
        self.providers = providers
        self.aiService = aiService
    }

    var body: some View {
        VStack(spacing: 0) {
            sectionPicker
            Form { editorContent }
        }
        .navigationTitle("Edit Drug / تعديل الدواء")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) { Button("Cancel") { context.rollback(); dismiss() } }
            ToolbarItem(placement: .confirmationAction) { Button("Save") { save() }.fontWeight(.semibold) }
        }
        .task(id: photoItemsLoadID) { await loadPhotos() }
        .onAppear { if initialReviewFingerprint.isEmpty { initialReviewFingerprint = drug.reviewContentFingerprint } }
        .photosPicker(isPresented: libraryPresentation, selection: $photoItems, maxSelectionCount: 8, matching: .images)
        .fullScreenCover(isPresented: cameraPresentation, onDismiss: presentPendingCameraDraft) {
            CameraPicker { pendingCameraDraft = ImageDraft(image: $0) }.ignoresSafeArea()
        }
        .fullScreenCover(item: cropPresentation) { draft in
            ImageEditorView(draft: draft) { payload in
                appendPhoto(payload)
            }
            .interactiveDismissDisabled()
        }
        .sheet(isPresented: $showsImport) {
            NavigationStack { DrugImportView(drug: drug, providers: providers, aiService: aiService) }
        }
        .alert("Could not save", isPresented: Binding(get: { errorMessage != nil }, set: { if !$0 { errorMessage = nil } })) {
            Button("OK") { errorMessage = nil }
        } message: { Text(errorMessage ?? "") }
    }

    private var sectionPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(DrugEditorSection.allCases) { section in
                    Button(section.rawValue) { selectedSection = section }
                        .buttonStyle(.borderedProminent)
                        .tint(selectedSection == section ? .accentColor : Color.secondary.opacity(0.16))
                        .foregroundStyle(selectedSection == section ? .white : .primary)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
        }
        .background(.bar)
    }

    @ViewBuilder
    private var editorContent: some View {
        switch selectedSection {
        case .basics: basics
        case .uses: uses
        case .pk: pk
        case .safety: safety
        case .counseling: counseling
        case .notes: notes
        }
    }

    private var basics: some View {
        Group {
            Section("Photo / الصورة") {
                DrugPhotoGalleryView(images: drug.packageImages, height: 150) { removePhoto(at: $0) }
                VStack(spacing: 10) {
                    Button { beginImageFlow(.camera) } label: { Label("Camera", systemImage: "camera.fill") }
                        .frame(maxWidth: .infinity, minHeight: 48)
                        .buttonStyle(.borderedProminent)
                        .accessibilityIdentifier("drugEditor.camera")
                        .accessibilityValue(lastImageSource == .camera ? "Selected" : "Not selected")
                    Button { beginImageFlow(.library) } label: {
                        Label("Photo Library", systemImage: "photo.on.rectangle")
                    }
                    .frame(maxWidth: .infinity, minHeight: 48)
                    .buttonStyle(.bordered)
                    .accessibilityIdentifier("drugEditor.photoLibrary")
                    .accessibilityValue(lastImageSource == .library ? "Selected" : "Not selected")
                }
                if !drug.packageImages.isEmpty {
                    Button(role: .destructive) {
                        drug.imageData = nil
                        drug.thumbnailData = nil
                        drug.additionalImageData = []
                        drug.additionalThumbnailData = []
                    } label: { Label("Remove photo", systemImage: "trash") }
                }
            }
            Section("Identity / الهوية") {
                Button { showsImport = true } label: {
                    Label("AI package scan + trusted import", systemImage: "camera.viewfinder")
                }
                .accessibilityIdentifier("drugEditor.import")
                Toggle("Unknown drug", isOn: binding(\.isUnknown))
                TextField("Capture label", text: binding(\.captureLabel))
                TextField("Scientific name", text: binding(\.scientificName)).autocorrectionDisabled()
                linesField("Trade names — one per line", keyPath: \.tradeNames)
                Picker("System / Chapter", selection: chapterBinding) { ForEach(Chapter.allCases) { Text($0.rawValue).tag($0) } }
                TextField("Class", text: binding(\.drugClass))
                linesField("Dosage forms — one per line", keyPath: \.dosageForms)
                linesField("Strengths — one per line", keyPath: \.strengths)
                linesField("Routes — one per line", keyPath: \.routes)
                TextField("Shelf location", text: binding(\.shelfLocation))
            }
        }
    }

    private var uses: some View {
        Group {
            Section("Clinical learning") {
                linesField("Indications / Uses — one per line", keyPath: \.indications)
                TextField("Mechanism", text: binding(\.mechanism), axis: .vertical).lineLimit(3...8)
                TextField("How to take", text: binding(\.howToTake), axis: .vertical).lineLimit(2...6)
                TextField("Food instructions", text: binding(\.foodInstruction), axis: .vertical).lineLimit(2...6)
                Picker("Dosing frequency", selection: dosingFrequencyBinding) {
                    ForEach(DosingFrequency.allCases) { Text($0.rawValue).tag($0) }
                }
                TextField("Times per day (optional)", text: timesPerDayBinding)
                    .keyboardType(.numberPad)
            }
            Section("Arabic / العربية") {
                arabicField("الشرح بالعربية", keyPath: \.arabicExplanation)
                arabicField("شرح آلية العمل بالعربية", keyPath: \.arabicMechanism)
            }
        }
    }

    private var pk: some View {
        Group {
            Section("Half-life") {
                numericControl(keyPath: \.halfLifeHours, scale: .halfLife)
                Picker("Band", selection: halfLifeBinding) { ForEach(HalfLifeBand.allCases) { Text($0.rawValue).tag($0) } }
                TextField("Exact value or note", text: binding(\.halfLifeText))
            }
            Section("Onset & duration") {
                numericControl(keyPath: \.onsetMinutes, scale: .onset)
                Picker("Onset", selection: onsetBinding) { ForEach(OnsetBand.allCases) { Text($0.rawValue).tag($0) } }
                TextField("Onset note", text: binding(\.onsetText))
                numericControl(keyPath: \.durationHours, scale: .duration)
                Picker("Duration", selection: durationBinding) { ForEach(DurationBand.allCases) { Text($0.rawValue).tag($0) } }
                TextField("Duration note", text: binding(\.durationText))
            }
            Section("Disposition") {
                Picker("Prodrug", selection: prodrugBinding) { ForEach(ProdrugStatus.allCases) { Text($0.rawValue).tag($0) } }
                Picker("Excretion", selection: excretionBinding) { ForEach(ExcretionRoute.allCases) { Text($0.rawValue).tag($0) } }
                TextField("Excretion notes", text: binding(\.excretionNotes), axis: .vertical).lineLimit(2...5)
            }
        }
    }

    private var safety: some View {
        Group {
            safetySection("Contraindications", lines: \.contraindications, severity: contraindicationSeverityBinding)
            safetyTextSection("Toxicity", text: \.toxicity, severity: toxicitySeverityBinding)
            safetySection("Warnings", lines: \.warnings, severity: warningSeverityBinding)
            safetySection("Interactions", lines: \.interactions, severity: interactionSeverityBinding)
            safetyTextSection("Renal caution", text: \.renalCaution, severity: renalSeverityBinding)
            safetyTextSection("Hepatic caution", text: \.hepaticCaution, severity: hepaticSeverityBinding)
            safetyTextSection("Pregnancy caution", text: \.pregnancyCaution, severity: pregnancySeverityBinding)
            Section("Legacy safety flags") {
                ForEach(SafetyFlag.allCases) { flag in Toggle(flag.rawValue, isOn: safetyFlagBinding(flag)) }
            }
        }
    }

    private var counseling: some View {
        Group {
            Section("Counseling") {
                TextField("Counseling sentence", text: binding(\.counselingSentence), axis: .vertical).lineLimit(3...8)
                arabicField("جملة الإرشاد بالعربية", keyPath: \.arabicCounseling)
                linesField("Patient questions — one per line", keyPath: \.patientQuestions)
            }
            Section("Adverse effects") {
                linesField("Adverse effects — one per line", keyPath: \.commonSideEffects)
            }
        }
    }

    private var notes: some View {
        Group {
            Section("Personal notes") {
                TextField("My notes (English or mixed)", text: binding(\.notes), axis: .vertical).lineLimit(4...12)
                arabicField("ملاحظاتي بالعربية", keyPath: \.arabicPersonalNotes)
            }
            Section("Mastery checks") {
                Toggle("Scientific name", isOn: masteryBinding(\.masteryScientificName))
                Toggle("Trade name", isOn: masteryBinding(\.masteryTradeName))
                Toggle("Class", isOn: masteryBinding(\.masteryClass))
                Toggle("Use", isOn: masteryBinding(\.masteryUse))
                Toggle("Warning", isOn: masteryBinding(\.masteryWarning))
                Toggle("Counseling", isOn: masteryBinding(\.masteryCounseling))
            }
        }
    }

    private func safetySection(_ title: String, lines: ReferenceWritableKeyPath<Drug, [String]>, severity: Binding<SafetySeverity>) -> some View {
        Section(title) {
            Picker("Severity", selection: severity) { ForEach(SafetySeverity.allCases) { Text($0.rawValue).tag($0) } }
            linesField("One item per line", keyPath: lines)
        }
    }

    private func safetyTextSection(_ title: String, text: ReferenceWritableKeyPath<Drug, String>, severity: Binding<SafetySeverity>) -> some View {
        Section(title) {
            Picker("Severity", selection: severity) { ForEach(SafetySeverity.allCases) { Text($0.rawValue).tag($0) } }
            TextField("Notes", text: binding(text), axis: .vertical).lineLimit(2...6)
        }
    }

    private func binding(_ keyPath: ReferenceWritableKeyPath<Drug, String>) -> Binding<String> {
        Binding(get: { drug[keyPath: keyPath] }, set: { drug[keyPath: keyPath] = $0 })
    }
    private func binding(_ keyPath: ReferenceWritableKeyPath<Drug, Bool>) -> Binding<Bool> {
        Binding(get: { drug[keyPath: keyPath] }, set: { drug[keyPath: keyPath] = $0 })
    }
    private var timesPerDayBinding: Binding<String> {
        Binding(
            get: { drug.timesPerDay.map(String.init) ?? "" },
            set: { drug.timesPerDay = Int($0.filter { $0.isNumber }) }
        )
    }

    private func optionalDoubleBinding(_ keyPath: ReferenceWritableKeyPath<Drug, Double?>) -> Binding<String> {
        Binding(
            get: { drug[keyPath: keyPath].map { String(format: "%g", $0) } ?? "" },
            set: { value in
                drug[keyPath: keyPath] = Double(value.replacingOccurrences(of: ",", with: "."))
            }
        )
    }

    private func normalizedBinding(_ keyPath: ReferenceWritableKeyPath<Drug, Double?>, scale: PharmacologyScale) -> Binding<Double> {
        Binding(
            get: { drug[keyPath: keyPath].map(scale.normalized) ?? 0.5 },
            set: { drug[keyPath: keyPath] = scale.value(at: $0) }
        )
    }

    private func numericControl(keyPath: ReferenceWritableKeyPath<Drug, Double?>, scale: PharmacologyScale) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                TextField("Numeric value", text: optionalDoubleBinding(keyPath)).keyboardType(.decimalPad)
                Text(scale.unit).foregroundStyle(.secondary)
            }
            Slider(value: normalizedBinding(keyPath, scale: scale), in: 0...1) { editing in
                if !editing { UISelectionFeedbackGenerator().selectionChanged() }
            }
            .disabled(drug[keyPath: keyPath] == nil)
            HStack {
                Text(scale.formatted(scale.bounds.lowerBound))
                Spacer()
                if let value = drug[keyPath: keyPath] { Text(scale.formatted(value)).fontWeight(.semibold) }
                Spacer()
                Text(scale.formatted(scale.bounds.upperBound))
            }
            .font(.caption2).foregroundStyle(.secondary)
            Button(drug[keyPath: keyPath] == nil ? "Set numeric value" : "Clear numeric value") {
                drug[keyPath: keyPath] = drug[keyPath: keyPath] == nil ? scale.value(at: 0.5) : nil
            }
            .font(.caption.weight(.semibold))
        }
    }
    private var chapterBinding: Binding<Chapter> { Binding(get: { drug.chapter }, set: { drug.chapter = $0 }) }
    private var halfLifeBinding: Binding<HalfLifeBand> { Binding(get: { drug.halfLifeBand }, set: { drug.halfLifeBand = $0 }) }
    private var onsetBinding: Binding<OnsetBand> { Binding(get: { drug.onsetBand }, set: { drug.onsetBand = $0 }) }
    private var durationBinding: Binding<DurationBand> { Binding(get: { drug.durationBand }, set: { drug.durationBand = $0 }) }
    private var dosingFrequencyBinding: Binding<DosingFrequency> { Binding(get: { drug.dosingFrequency }, set: { drug.dosingFrequency = $0 }) }
    private var prodrugBinding: Binding<ProdrugStatus> { Binding(get: { drug.prodrugStatus }, set: { drug.prodrugStatus = $0 }) }
    private var excretionBinding: Binding<ExcretionRoute> { Binding(get: { drug.excretionRoute }, set: { drug.excretionRoute = $0 }) }
    private var contraindicationSeverityBinding: Binding<SafetySeverity> { severityBinding(\.contraindicationSeverityRaw) }
    private var toxicitySeverityBinding: Binding<SafetySeverity> { severityBinding(\.toxicitySeverityRaw) }
    private var warningSeverityBinding: Binding<SafetySeverity> { severityBinding(\.warningSeverityRaw) }
    private var interactionSeverityBinding: Binding<SafetySeverity> { severityBinding(\.interactionSeverityRaw) }
    private var renalSeverityBinding: Binding<SafetySeverity> { severityBinding(\.renalSeverityRaw) }
    private var hepaticSeverityBinding: Binding<SafetySeverity> { severityBinding(\.hepaticSeverityRaw) }
    private var pregnancySeverityBinding: Binding<SafetySeverity> { severityBinding(\.pregnancySeverityRaw) }

    private func severityBinding(_ keyPath: ReferenceWritableKeyPath<Drug, String>) -> Binding<SafetySeverity> {
        Binding(get: { SafetySeverity(rawValue: drug[keyPath: keyPath]) ?? .unknown }, set: { drug[keyPath: keyPath] = $0.rawValue })
    }

    private func linesField(_ title: String, keyPath: ReferenceWritableKeyPath<Drug, [String]>) -> some View {
        TextField(title, text: Binding(get: { drug[keyPath: keyPath].joined(separator: "\n") }, set: { drug[keyPath: keyPath] = $0.splitLines }), axis: .vertical)
            .lineLimit(2...8)
    }

    private func arabicField(_ title: String, keyPath: ReferenceWritableKeyPath<Drug, String>) -> some View {
        TextField(title, text: binding(keyPath), axis: .vertical)
            .lineLimit(3...10)
            .multilineTextAlignment(.trailing)
            .environment(\.layoutDirection, .rightToLeft)
    }

    private func safetyFlagBinding(_ flag: SafetyFlag) -> Binding<Bool> {
        Binding(get: { drug.safetyFlags.contains(flag) }, set: { enabled in
            var values = drug.safetyFlags
            if enabled { if !values.contains(flag) { values.append(flag) } } else { values.removeAll { $0 == flag } }
            drug.safetyFlags = values
        })
    }

    private func masteryBinding(_ keyPath: ReferenceWritableKeyPath<Drug, Bool>) -> Binding<Bool> {
        Binding(get: { drug[keyPath: keyPath] }, set: { drug[keyPath: keyPath] = $0; drug.recalculateConfidence() })
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

    private var photoItemsLoadID: String { "\(photoItems.count)-\(photoItems.compactMap(\.itemIdentifier).joined(separator: "|"))" }

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
            errorMessage = "Camera is unavailable on this device. Choose a photo from the library instead."
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

    private func appendPhoto(_ payload: DrugImagePayload) {
        if drug.imageData == nil {
            drug.imageData = payload.imageData
            drug.thumbnailData = payload.thumbnailData
        } else {
            drug.additionalImageData.append(payload.imageData)
            drug.additionalThumbnailData.append(payload.thumbnailData)
        }
    }

    private func removePhoto(at index: Int) {
        if index == 0 {
            drug.imageData = drug.additionalImageData.first
            drug.thumbnailData = drug.additionalThumbnailData.first
            if !drug.additionalImageData.isEmpty { drug.additionalImageData.removeFirst() }
            if !drug.additionalThumbnailData.isEmpty { drug.additionalThumbnailData.removeFirst() }
        } else {
            let additionalIndex = index - 1
            if drug.additionalImageData.indices.contains(additionalIndex) { drug.additionalImageData.remove(at: additionalIndex) }
            if drug.additionalThumbnailData.indices.contains(additionalIndex) { drug.additionalThumbnailData.remove(at: additionalIndex) }
        }
    }

    private func loadPhotos() async {
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
            await MainActor.run { errorMessage = error.localizedDescription; photoItems = [] }
        }
    }

    private func save() {
        if !drug.isUnknown && drug.scientificName.trimmed.isEmpty && drug.tradeNames.isEmpty {
            errorMessage = "Add a scientific or trade name, or keep this card marked Unknown."
            return
        }
        if !drug.scientificName.trimmed.isEmpty || !drug.tradeNames.isEmpty { drug.isUnknown = false }
        drug.recalculateConfidence()
        if !drug.generatedReviewQuestions.isEmpty && drug.reviewContentFingerprint != initialReviewFingerprint {
            drug.reviewQuestionsNeedRegeneration = true
        }
        do { try context.save(); dismiss() } catch { errorMessage = error.localizedDescription }
    }
}
