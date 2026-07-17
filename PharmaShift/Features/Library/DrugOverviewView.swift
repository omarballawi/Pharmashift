import PhotosUI
import SwiftData
import SwiftUI
import UIKit

enum DrugTopic: String, CaseIterable, Identifiable, Hashable {
    case brands = "Brands & packages"
    case uses = "Uses"
    case dosing = "Forms & dosing"
    case safety = "Safety"
    case pharmacology = "Pharmacology"
    case counseling = "Counseling & Arabic"
    case sources = "Sources, notes & mastery"

    var id: String { rawValue }
    var accessibilityIdentifier: String {
        switch self {
        case .brands: "drug.topic.brands"
        case .uses: "drug.topic.uses"
        case .dosing: "drug.topic.dosing"
        case .safety: "drug.topic.safety"
        case .pharmacology: "drug.topic.pharmacology"
        case .counseling: "drug.topic.counseling"
        case .sources: "drug.topic.sources"
        }
    }
    var icon: String {
        switch self {
        case .brands: "shippingbox.fill"
        case .uses: "cross.case.fill"
        case .dosing: "pills.fill"
        case .safety: "shield.lefthalf.filled"
        case .pharmacology: "atom"
        case .counseling: "quote.bubble.fill"
        case .sources: "checkmark.seal.fill"
        }
    }
}

private enum DrugOverviewSheet: String, Identifiable {
    case edit
    case delete
    var id: String { rawValue }
}

struct DrugDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Environment(AppTheme.self) private var theme
    let drug: Drug
    @State private var sheet: DrugOverviewSheet?

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: RenlystLayout.sectionSpacing) {
                DrugIdentityHeader(drug: drug)
                DrugSummarySurface(drug: drug)
                DrugTopicsList(drug: drug)
                if !drug.oneLineSummaryArabic.trimmed.isEmpty || !drug.arabicExplanation.trimmed.isEmpty {
                    ArabicSummarySurface(drug: drug)
                }
            }
            .padding(.horizontal, RenlystLayout.pageInset)
            .padding(.bottom, 28)
        }
        .background(theme.background)
        .navigationTitle(drug.displayName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button { sheet = .edit } label: { Label("Edit active drug", systemImage: "pencil") }
                    Button(role: .destructive) { sheet = .delete } label: { Label("Delete drug profile", systemImage: "trash") }
                } label: {
                    Label("More", systemImage: "ellipsis.circle")
                }
            }
        }
        .sheet(item: $sheet) { item in
            switch item {
            case .edit:
                NavigationStack { DrugEditorView(drug: drug) }
            case .delete:
                DrugDeletionSheet(drug: drug) { dismiss() }
            }
        }
        .task { await markSeen() }
        .accessibilityIdentifier("drug.overview")
    }

    private func markSeen() async {
        guard drug.lastSeenDate.map({ !Calendar.current.isDateInToday($0) }) ?? true else { return }
        try? await Task.sleep(for: .milliseconds(350))
        guard !Task.isCancelled else { return }
        drug.markSeen()
        try? context.save()
    }
}

private struct DrugIdentityHeader: View {
    @Environment(AppTheme.self) private var theme
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    let drug: Drug

    var body: some View {
        ViewThatFits(in: .horizontal) {
            HStack(alignment: .center, spacing: 17) {
                ProductPhoto(data: drug.packageThumbnails.first, size: 96, cacheKey: "drug-\(drug.id.uuidString)-hero")
                DrugIdentityText(drug: drug)
                Spacer(minLength: 0)
            }
            VStack(alignment: .leading, spacing: 15) {
                ProductPhoto(data: drug.packageThumbnails.first, size: 88, cacheKey: "drug-\(drug.id.uuidString)-hero")
                DrugIdentityText(drug: drug)
            }
        }
        .padding(18)
        .background(theme.inkSolid, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(alignment: .topTrailing) {
            OrbitMark(progress: Double(drug.masteryCount) / 6)
                .frame(width: 66, height: 66)
                .padding(12)
                .opacity(dynamicTypeSize.isAccessibilitySize ? 0 : 0.34)
                .allowsHitTesting(false)
        }
        .accessibilityElement(children: .combine)
    }
}

private struct DrugIdentityText: View {
    @Environment(AppTheme.self) private var theme
    let drug: Drug

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(drug.displayName)
                .font(.system(.title, design: .serif, weight: .semibold))
                .foregroundStyle(.white)
            Text(drug.ingredientNames.joined(separator: " + "))
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.white.opacity(0.72))
            if !drug.effectiveTradeNames.isEmpty {
                Text(drug.effectiveTradeNames.prefix(3).joined(separator: "  ·  "))
                    .font(.subheadline)
                    .foregroundStyle(theme.saffron)
            }
            ViewThatFits(in: .horizontal) {
                HStack(spacing: 7) {
                    Label(drug.chapter.rawValue, systemImage: drug.chapter.icon)
                    Text("\(drug.masteryCount)/6 connected")
                }
                VStack(alignment: .leading, spacing: 4) {
                    Label(drug.chapter.rawValue, systemImage: drug.chapter.icon)
                    Text("\(drug.masteryCount)/6 connected")
                }
            }
            .font(.caption.weight(.medium))
            .foregroundStyle(.white.opacity(0.7))
            .padding(.top, 2)
        }
    }
}

private struct DrugSummarySurface: View {
    @Environment(AppTheme.self) private var theme
    let drug: Drug

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Three memory anchors").font(.title3.weight(.semibold))
                    Text("The fastest path back to this drug").font(.subheadline).foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "point.3.connected.trianglepath.dotted")
                    .foregroundStyle(theme.coral)
                    .accessibilityHidden(true)
            }

            VStack(spacing: 0) {
                ForEach(Array(drug.memoryAnchors.enumerated()), id: \.element.id) { index, anchor in
                    MemoryAnchorRow(number: index + 1, anchor: anchor)
                    if index < 2 { Divider().padding(.leading, 56) }
                }
            }
            .background(theme.surface, in: RoundedRectangle(cornerRadius: RenlystLayout.surfaceRadius, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: RenlystLayout.surfaceRadius, style: .continuous)
                    .stroke(theme.separator.opacity(0.3), lineWidth: 0.5)
            }
        }
    }
}

private struct MemoryAnchorRow: View {
    @Environment(AppTheme.self) private var theme
    let number: Int
    let anchor: MemoryAnchor

    var body: some View {
        HStack(alignment: .top, spacing: 13) {
            Text(number.formatted())
                .font(.subheadline.monospacedDigit().weight(.bold))
                .foregroundStyle(anchor.content == nil ? Color(uiColor: .secondaryLabel) : Color.white)
                .frame(width: 34, height: 34)
                .background(anchor.content == nil ? theme.separator.opacity(0.18) : anchorColor, in: Circle())
            VStack(alignment: .leading, spacing: 4) {
                Text(anchor.title)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)
                Text(anchor.content ?? "Add this anchor when you next review the profile.")
                    .font(.body)
                    .foregroundStyle(anchor.content == nil ? .secondary : .primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 13)
        .accessibilityElement(children: .combine)
    }

    private var anchorColor: Color {
        switch anchor.kind {
        case .safety: theme.coral
        case .mechanism, .counseling: theme.aqua
        case .mustKnow, .use: theme.inkSolid
        case .empty: .secondary
        }
    }
}

private struct DrugTopicsList: View {
    @Environment(AppTheme.self) private var theme
    let drug: Drug

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            RenlystSectionHeader("Build the full picture", subtitle: "Each topic is one focused layer")
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 145), spacing: 12)], spacing: 12) {
                ForEach(DrugTopic.allCases) { topic in
                    NavigationLink(value: AppRoute.drugTopic(drug.id, topic)) {
                        VStack(alignment: .leading, spacing: 12) {
                            Image(systemName: topic.icon)
                                .font(.title3.weight(.semibold))
                                .foregroundStyle(topic == .brands ? theme.coral : theme.aqua)
                                .frame(width: 42, height: 42)
                                .background((topic == .brands ? theme.softTint : theme.softAqua), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                            VStack(alignment: .leading, spacing: 2) {
                                Text(topic.rawValue).font(.headline)
                                Text(detail(for: topic))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(2)
                            }
                            Spacer()
                            HStack {
                                Text("Open").font(.caption.weight(.semibold)).foregroundStyle(.secondary)
                                Spacer()
                                Image(systemName: "arrow.up.right").font(.caption.weight(.bold)).foregroundStyle(.tertiary)
                            }
                        }
                        .padding(14)
                        .frame(maxWidth: .infinity, minHeight: 148, alignment: .leading)
                        .background(theme.surface, in: RoundedRectangle(cornerRadius: RenlystLayout.surfaceRadius, style: .continuous))
                        .overlay {
                            RoundedRectangle(cornerRadius: RenlystLayout.surfaceRadius, style: .continuous)
                                .stroke(theme.separator.opacity(0.3), lineWidth: 0.5)
                        }
                    }
                    .buttonStyle(RenlystTileButtonStyle())
                    .accessibilityIdentifier(topic.accessibilityIdentifier)
                    .accessibilityHint(detail(for: topic))
                }
            }
        }
    }

    private func detail(for topic: DrugTopic) -> String {
        switch topic {
        case .brands: "\(drug.products.count) package profile\(drug.products.count == 1 ? "" : "s")"
        case .uses: "\(drug.indications.count) saved indication\(drug.indications.count == 1 ? "" : "s")"
        case .dosing: "Forms, strengths, regimens, calculator"
        case .safety: "Warnings, effects, interactions"
        case .pharmacology: "Mechanism and ADME"
        case .counseling: "Patient language and Arabic notes"
        case .sources: "Verification, linked notes, progress"
        }
    }
}

private struct ArabicSummarySurface: View {
    @Environment(AppTheme.self) private var theme
    let drug: Drug

    var body: some View {
        RenlystSurface {
            VStack(alignment: .trailing, spacing: 8) {
                Label("الخلاصة", systemImage: "text.quote").font(.headline).foregroundStyle(theme.aqua)
                Text(drug.oneLineSummaryArabic.trimmed.isEmpty ? drug.arabicExplanation : drug.oneLineSummaryArabic)
                    .font(.body)
                    .multilineTextAlignment(.trailing)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .environment(\.layoutDirection, .rightToLeft)
        }
    }
}

struct DrugTopicView: View {
    let drug: Drug
    let topic: DrugTopic

    var body: some View {
        Group {
            switch topic {
            case .brands: DrugBrandsScreen(drug: drug)
            case .uses: DrugUsesScreen(drug: drug)
            case .dosing: DrugDosingScreen(drug: drug)
            case .safety: DrugSafetyScreen(drug: drug)
            case .pharmacology: DrugPharmacologyScreen(drug: drug)
            case .counseling: DrugCounselingScreen(drug: drug)
            case .sources: DrugSourcesScreen(drug: drug)
            }
        }
        .navigationTitle(topic.rawValue)
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct DrugBrandsScreen: View {
    @Environment(\.modelContext) private var context
    @Environment(AppTheme.self) private var theme
    let drug: Drug
    @State private var showsAddBrand = false
    @State private var deletionProduct: DrugProduct?
    @State private var errorMessage: String?

    private var products: [DrugProduct] { drug.products.sorted { $0.dateAdded > $1.dateAdded } }

    var body: some View {
        List {
            Section("Inherited active ingredients") {
                ForEach(drug.ingredientNames, id: \.self) { name in
                    Label(name, systemImage: "link")
                }
                Text("Brand entries can change product strengths and package details, but not these ingredient names or the clinical profile.")
                    .font(.footnote).foregroundStyle(.secondary)
            }
            if products.isEmpty {
                Section {
                    VStack(spacing: 12) {
                        Image("AddBrandIntro").resizable().scaledToFit().frame(maxHeight: 210).clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous)).accessibilityHidden(true)
                        Text("Add the first local brand").font(.title3.weight(.semibold))
                        Text("Enter the printed brand name and add a package photo. No AI request is made.")
                            .font(.subheadline).foregroundStyle(.secondary).multilineTextAlignment(.center)
                        Button("Add brand") { showsAddBrand = true }
                            .buttonStyle(RenlystPrimaryButtonStyle())
                    }
                    .padding(.vertical, 8)
                }
            } else {
                Section("Packages") {
                    ForEach(products) { product in
                        NavigationLink { BrandProductForm(drug: drug, product: product) } label: {
                            BrandProductRow(product: product)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) { deletionProduct = product } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(theme.background)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button { showsAddBrand = true } label: { Label("Add brand", systemImage: "plus") }
                    .accessibilityIdentifier("brands.add")
            }
        }
        .sheet(isPresented: $showsAddBrand) {
            NavigationStack { BrandProductForm(drug: drug) }
        }
        .confirmationDialog(
            "Delete this brand?",
            isPresented: Binding(get: { deletionProduct != nil }, set: { if !$0 { deletionProduct = nil } }),
            titleVisibility: .visible,
            presenting: deletionProduct
        ) { product in
            Button("Delete \(product.tradeName)", role: .destructive) { delete(product) }
            Button("Cancel", role: .cancel) {}
        } message: { product in
            Text("The \(drug.displayName) active-drug profile and its other brands will stay in the library.")
        }
        .alert("Couldn’t delete brand", isPresented: Binding(get: { errorMessage != nil }, set: { if !$0 { errorMessage = nil } })) {
            Button("OK", role: .cancel) {}
        } message: { Text(errorMessage ?? "") }
        .accessibilityIdentifier("brands.screen")
    }

    private func delete(_ product: DrugProduct) {
        do { try DrugBrandService.delete(product, from: drug, context: context) }
        catch { errorMessage = error.localizedDescription }
        deletionProduct = nil
    }
}

private struct BrandProductRow: View {
    let product: DrugProduct

    var body: some View {
        HStack(spacing: 12) {
            ProductPhoto(data: product.packageThumbnails.first, size: 56, cacheKey: "product-\(product.id.uuidString)-row")
            VStack(alignment: .leading, spacing: 3) {
                Text(product.tradeName).font(.headline)
                Text([product.marketedStrengthLabel, product.dosageForm].filter { !$0.trimmed.isEmpty }.joined(separator: " · "))
                    .font(.subheadline).foregroundStyle(.secondary)
                if !product.manufacturer.trimmed.isEmpty {
                    Text(product.manufacturer).font(.caption).foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 3)
        .accessibilityElement(children: .combine)
    }
}

@MainActor
struct BrandProductForm: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Environment(AppTheme.self) private var theme
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    let drug: Drug
    let product: DrugProduct?
    @State private var draft: BrandProductDraft
    @State private var photoItems: [PhotosPickerItem] = []
    @State private var imageFlow: ImageFlowDestination?
    @State private var pendingCameraDraft: ImageDraft?
    @State private var errorMessage: String?
    @State private var isSaving = false
    @FocusState private var brandFieldFocused: Bool

    init(drug: Drug, product: DrugProduct? = nil) {
        self.drug = drug
        self.product = product
        _draft = State(initialValue: product.map { DrugBrandService.draft(for: $0, in: drug) } ?? DrugBrandService.draft(for: drug))
    }

    private var currentImages: [Data] { [draft.imageData].compactMap { $0 } + draft.additionalImageData }
    private var canSave: Bool {
        !draft.tradeName.trimmed.isEmpty && (product != nil || draft.hasPhoto) && !isSaving
    }

    var body: some View {
        Form {
            if product == nil, currentImages.isEmpty {
                Section {
                    Image("AddBrandIntro")
                        .resizable().scaledToFit().frame(maxHeight: 190)
                        .clipShape(RoundedRectangle(cornerRadius: RenlystLayout.surfaceRadius, style: .continuous))
                        .accessibilityHidden(true)
                    Text("This creates a product only. It does not call Gemini, DeepSeek, OpenRouter, or any network service.")
                        .font(.footnote).foregroundStyle(.secondary)
                }
            }
            Section("Required") {
                TextField("Brand name on package", text: $draft.tradeName)
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled()
                    .focused($brandFieldFocused)
                    .accessibilityIdentifier("brand.name")
                DrugPhotoGalleryView(images: currentImages, height: 150, onRemove: removePhoto)
                Group {
                    if dynamicTypeSize.isAccessibilitySize {
                        VStack(alignment: .leading, spacing: 10) { photoActions }
                    } else {
                        HStack { photoActions }
                    }
                }
                if product == nil, !draft.hasPhoto {
                    Label("At least one package photo is required", systemImage: "exclamationmark.circle")
                        .font(.footnote).foregroundStyle(theme.coral)
                }
            }
            Section("Active ingredient strengths") {
                ForEach(draft.ingredientComponents.indices, id: \.self) { index in
                    LabeledContent {
                        TextField("e.g. 500 mg", text: $draft.ingredientComponents[index].displayStrength)
                            .multilineTextAlignment(.trailing)
                    } label: {
                        Text(draft.ingredientComponents[index].name)
                    }
                }
                Text("Ingredient names are inherited from \(drug.displayName) and cannot be changed here.")
                    .font(.footnote).foregroundStyle(.secondary)
            }
            Section("Product details") {
                TextField("Marketed total strength", text: $draft.marketedStrengthLabel)
                TextField("Manufacturer", text: $draft.manufacturer)
                TextField("Dosage form", text: $draft.dosageForm)
                TextField("Route", text: $draft.route)
                TextField("Country / market", text: $draft.country)
                TextField("Shelf location", text: $draft.shelfLocation)
            }
        }
        .scrollContentBackground(.hidden)
        .background(theme.background)
        .navigationTitle(product == nil ? "Add brand" : "Edit brand")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if product == nil {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button(isSaving ? "Saving…" : "Save", action: save)
                    .disabled(!canSave)
                    .accessibilityIdentifier("brand.save")
            }
        }
        .task(id: photoItems.compactMap(\.itemIdentifier).joined(separator: "|")) { await loadPhotoItems() }
        .fullScreenCover(isPresented: cameraPresentation, onDismiss: presentPendingCameraDraft) {
            CameraPicker { pendingCameraDraft = ImageDraft(image: $0) }.ignoresSafeArea()
        }
        .fullScreenCover(item: cropPresentation) { draft in
            ImageEditorView(draft: draft) { appendPhoto($0) }.interactiveDismissDisabled()
        }
        .alert("Couldn’t save brand", isPresented: Binding(get: { errorMessage != nil }, set: { if !$0 { errorMessage = nil } })) {
            Button("OK", role: .cancel) {}
        } message: { Text(errorMessage ?? "") }
        .onAppear { if product == nil { brandFieldFocused = true } }
    }

    private func save() {
        guard canSave else { return }
        isSaving = true
        do {
            if let product { try DrugBrandService.update(product, with: draft, in: drug, context: context) }
            else { try DrugBrandService.add(draft, to: drug, context: context) }
            dismiss()
        } catch {
            isSaving = false
            errorMessage = error.localizedDescription
        }
    }

    private func appendPhoto(_ payload: DrugImagePayload) {
        if draft.imageData == nil {
            draft.imageData = payload.imageData
            draft.thumbnailData = payload.thumbnailData
        } else {
            draft.additionalImageData.append(payload.imageData)
            draft.additionalThumbnailData.append(payload.thumbnailData)
        }
    }

    private func removePhoto(at index: Int) {
        if index == 0 {
            draft.imageData = draft.additionalImageData.first
            draft.thumbnailData = draft.additionalThumbnailData.first
            if !draft.additionalImageData.isEmpty { draft.additionalImageData.removeFirst() }
            if !draft.additionalThumbnailData.isEmpty { draft.additionalThumbnailData.removeFirst() }
        } else {
            let offset = index - 1
            if draft.additionalImageData.indices.contains(offset) { draft.additionalImageData.remove(at: offset) }
            if draft.additionalThumbnailData.indices.contains(offset) { draft.additionalThumbnailData.remove(at: offset) }
        }
    }

    private func loadPhotoItems() async {
        guard !photoItems.isEmpty else { return }
        do {
            for item in photoItems {
                guard let data = try await item.loadTransferable(type: Data.self) else { continue }
                let image = try ImageCompressor.image(from: data)
                let payload = try ImageCompressor.payload(from: image)
                appendPhoto(payload)
            }
            photoItems = []
        } catch {
            errorMessage = error.localizedDescription
            photoItems = []
        }
    }

    private func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            errorMessage = "Camera is unavailable on this device. Choose a photo from the library instead."
            return
        }
        imageFlow = .camera
    }

    @ViewBuilder
    private var photoActions: some View {
        Button(action: openCamera) { Label("Camera", systemImage: "camera.fill") }
            .buttonStyle(.borderedProminent)
        PhotosPicker(selection: $photoItems, maxSelectionCount: 8, matching: .images) {
            Label("Photo library", systemImage: "photo.on.rectangle")
        }
        .buttonStyle(.bordered)
    }

    private var cameraPresentation: Binding<Bool> {
        Binding(
            get: { if case .camera? = imageFlow { true } else { false } },
            set: { if !$0, case .camera? = imageFlow { imageFlow = nil } }
        )
    }

    private var cropPresentation: Binding<ImageDraft?> {
        Binding(
            get: { if case .crop(let draft)? = imageFlow { draft } else { nil } },
            set: { draft in
                if let draft { imageFlow = .crop(draft) }
                else { imageFlow = nil }
            }
        )
    }

    private func presentPendingCameraDraft() {
        guard let draft = pendingCameraDraft else { return }
        pendingCameraDraft = nil
        imageFlow = .crop(draft)
    }
}

private struct DrugUsesScreen: View {
    @Environment(AppTheme.self) private var theme
    let drug: Drug

    var body: some View {
        List {
            Section("Indications") {
                if drug.indications.isEmpty { Text("No indications recorded.").foregroundStyle(.secondary) }
                ForEach(drug.indications, id: \.self) { Label($0, systemImage: "cross.case") }
            }
            if !drug.patientQuestions.isEmpty {
                Section("Questions to understand") {
                    ForEach(drug.patientQuestions, id: \.self) { Label($0, systemImage: "questionmark.bubble") }
                }
            }
        }
        .scrollContentBackground(.hidden).background(theme.background)
    }
}

private struct DrugDosingScreen: View {
    @Environment(AppTheme.self) private var theme
    let drug: Drug

    var body: some View {
        List {
            Section("Forms & strengths") {
                if drug.dosageFormGroups.isEmpty { Text("No structured forms recorded.").foregroundStyle(.secondary) }
                ForEach(drug.dosageFormGroups) { group in
                    VStack(alignment: .leading, spacing: 5) {
                        Text(group.dosageForm).font(.headline)
                        Text(group.strengths.map(\.strength).joined(separator: " · ")).font(.subheadline).foregroundStyle(.secondary)
                    }
                }
            }
            Section("Clinical dose notes") {
                if drug.clinicalDoses.isEmpty { Text("No indication-specific dose entries recorded.").foregroundStyle(.secondary) }
                ForEach(drug.clinicalDoses) { dose in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(dose.indication).font(.headline)
                        Text([dose.population, dose.doseText, dose.frequency, dose.duration].filter { !$0.trimmed.isEmpty }.joined(separator: " · "))
                            .font(.subheadline).foregroundStyle(.secondary)
                    }
                }
            }
            Section {
                NavigationLink { DoseRegimensView(drug: drug) } label: {
                    Label("Educational dose calculator", systemImage: "function")
                }
                Text("Calculations are educational and require verification against the current clinical reference and patient context.")
                    .font(.footnote).foregroundStyle(.secondary)
            }
        }
        .scrollContentBackground(.hidden).background(theme.background)
    }
}

private struct DrugSafetyScreen: View {
    @Environment(AppTheme.self) private var theme
    @Query(sort: \Drug.scientificName) private var allDrugs: [Drug]
    let drug: Drug

    var body: some View {
        List {
            stringSection("Warnings", values: drug.warnings, icon: "exclamationmark.triangle")
            stringSection("Contraindications", values: drug.contraindications, icon: "hand.raised")
            Section("Adverse effects") {
                if drug.adverseEffectEntries.isEmpty { Text("No adverse effects recorded.").foregroundStyle(.secondary) }
                ForEach(drug.adverseEffectEntries) { effect in
                    HStack(alignment: .top) {
                        Image(systemName: effect.isSerious ? "exclamationmark.octagon.fill" : "circle.fill")
                            .foregroundStyle(effect.isSerious ? .red : theme.aqua)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(effect.name)
                            if !effect.incidence.trimmed.isEmpty { Text(effect.incidence).font(.caption).foregroundStyle(.secondary) }
                        }
                    }
                }
            }
            Section("Interactions") {
                if drug.interactionEntries.isEmpty { Text("No structured interactions recorded.").foregroundStyle(.secondary) }
                ForEach(drug.interactionEntries) { interaction in
                    if let match = allDrugs.first(where: { $0.displayName.localizedCaseInsensitiveCompare(interaction.drugName) == .orderedSame || $0.effectiveTradeNames.contains(where: { $0.localizedCaseInsensitiveCompare(interaction.drugName) == .orderedSame }) }) {
                        NavigationLink { DrugDetailView(drug: match) } label: { interactionRow(interaction) }
                    } else { interactionRow(interaction) }
                }
            }
            Section("Pregnancy & lactation") {
                LabeledValue(label: "Pregnancy", value: drug.reproductiveSafety.pregnancy)
                LabeledValue(label: "Lactation", value: drug.reproductiveSafety.lactation)
            }
        }
        .scrollContentBackground(.hidden).background(theme.background)
    }

    @ViewBuilder
    private func stringSection(_ title: String, values: [String], icon: String) -> some View {
        Section(title) {
            if values.isEmpty { Text("None recorded.").foregroundStyle(.secondary) }
            ForEach(values, id: \.self) { Label($0, systemImage: icon) }
        }
    }

    private func interactionRow(_ interaction: DrugInteractionEntry) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(interaction.drugName).font(.headline)
            Text([interaction.category.rawValue, interaction.effect, interaction.management].filter { !$0.trimmed.isEmpty }.joined(separator: " · "))
                .font(.subheadline).foregroundStyle(.secondary)
        }
    }
}

private struct DrugPharmacologyScreen: View {
    @Environment(AppTheme.self) private var theme
    let drug: Drug

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 14) {
                RenlystSectionHeader("Mechanism", subtitle: drug.drugClass)
                RenlystSurface { Text(drug.mechanism.trimmed.isEmpty ? "No mechanism recorded." : drug.mechanism).foregroundStyle(drug.mechanism.trimmed.isEmpty ? .secondary : .primary) }
                PharmacologyMeter(title: "Onset", icon: "bolt.fill", scale: .onset, value: drug.onsetMinutes, fallback: drug.onsetText, detail: drug.onsetBand.rawValue)
                PharmacologyMeter(title: "Half-life", icon: "hourglass", scale: .halfLife, value: drug.halfLifeHours, fallback: drug.halfLifeText, detail: drug.halfLifeBand.rawValue)
                PharmacologyMeter(title: "Duration", icon: "clock", scale: .duration, value: drug.durationHours, fallback: drug.durationText, detail: drug.durationBand.rawValue)
                adme("Absorption", drug.pharmacologyProfile.absorption)
                adme("Distribution", drug.pharmacologyProfile.distribution)
                adme("Metabolism", drug.pharmacologyProfile.metabolism)
                adme("Elimination", drug.pharmacologyProfile.elimination)
            }
            .padding(RenlystLayout.pageInset)
        }
        .background(theme.background)
    }

    @ViewBuilder
    private func adme(_ title: String, _ values: [String]) -> some View {
        if !values.isEmpty {
            RenlystSurface {
                VStack(alignment: .leading, spacing: 7) {
                    Text(title).font(.headline)
                    ForEach(values, id: \.self) { Text($0).font(.subheadline).foregroundStyle(.secondary) }
                }
            }
        }
    }
}

private struct DrugCounselingScreen: View {
    @Environment(AppTheme.self) private var theme
    let drug: Drug

    var body: some View {
        List {
            Section("Counseling") {
                LabeledValue(label: "Core sentence", value: drug.counselingSentence)
                LabeledValue(label: "How to take", value: drug.howToTake)
                LabeledValue(label: "Food", value: drug.foodInstruction)
            }
            Section("Arabic learning notes") {
                arabic("الشرح", drug.arabicExplanation)
                arabic("آلية العمل", drug.arabicMechanism)
                arabic("الإرشاد", drug.arabicCounseling)
                arabic("ملاحظة مهمة", drug.arabicImportantNote)
                arabic("ملاحظاتي", drug.arabicPersonalNotes)
            }
        }
        .scrollContentBackground(.hidden).background(theme.background)
    }

    @ViewBuilder
    private func arabic(_ label: String, _ value: String) -> some View {
        if !value.trimmed.isEmpty {
            VStack(alignment: .trailing, spacing: 4) {
                Text(label).font(.caption.weight(.semibold)).foregroundStyle(theme.aqua)
                Text(value).frame(maxWidth: .infinity, alignment: .trailing)
            }
            .environment(\.layoutDirection, .rightToLeft)
        }
    }
}

private struct DrugSourcesScreen: View {
    @Environment(AppTheme.self) private var theme
    let drug: Drug
    @State private var showsAtomicNotes = false

    var body: some View {
        List {
            Section("Verification") {
                LabeledContent("Status", value: drug.verificationStatus.rawValue)
                LabeledContent("Source", value: drug.importedSourceName.trimmed.isEmpty ? "Personal entry" : drug.importedSourceName)
                if let date = drug.sourceUpdatedAt { LabeledContent("Updated", value: date.formatted(date: .abbreviated, time: .omitted)) }
                if !drug.sourceURL.trimmed.isEmpty, let url = URL(string: drug.sourceURL) {
                    Link(destination: url) { Label("Open source", systemImage: "safari") }
                }
            }
            Section("Learning") {
                LabeledContent("Mastery", value: "\(drug.masteryCount) of 6")
                ProgressView(value: Double(drug.masteryCount), total: 6).tint(theme.aqua)
                LabeledValue(label: "Notes", value: drug.notes)
            }
            Section("Tools") {
                NavigationLink { LocalDrugGraphView(drug: drug) } label: { Label("Local knowledge graph", systemImage: "point.3.connected.trianglepath.dotted") }
                Button { showsAtomicNotes = true } label: { Label("Atomic linked notes", systemImage: "note.text.badge.plus") }
            }
        }
        .scrollContentBackground(.hidden).background(theme.background)
        .sheet(isPresented: $showsAtomicNotes) { AtomicNotesView(drug: drug) }
    }
}
