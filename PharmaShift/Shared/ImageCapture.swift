import ImageIO
import Observation
import PhotosUI
import SwiftUI
import UIKit

struct DrugImagePayload {
    let imageData: Data
    let thumbnailData: Data
}

struct ImageDraft: Identifiable {
    let id = UUID()
    let image: UIImage
}

enum ImageFlowDestination: Identifiable {
    case camera
    case library
    case crop(ImageDraft)

    var id: String {
        switch self {
        case .camera: "camera"
        case .library: "library"
        case .crop(let draft): "crop-\(draft.id)"
        }
    }
}

enum ImagePipelineError: LocalizedError {
    case invalidImage
    case processingFailed

    var errorDescription: String? {
        switch self {
        case .invalidImage: "The selected file is not a supported image."
        case .processingFailed: "The photo could not be prepared. Please try another image."
        }
    }
}

enum ImageCompressor {
    static func image(from data: Data, maxDimension: CGFloat = 3_200) throws -> UIImage {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            throw ImagePipelineError.invalidImage
        }
        let options: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: Int(maxDimension),
            kCGImageSourceShouldCacheImmediately: false
        ]
        guard let cgImage = CGImageSourceCreateThumbnailAtIndex(source, 0, options as CFDictionary) else {
            throw ImagePipelineError.invalidImage
        }
        return UIImage(cgImage: cgImage, scale: 1, orientation: .up)
    }

    static func payload(from image: UIImage, maxDimension: CGFloat = 1_600, quality: CGFloat = 0.75) throws -> DrugImagePayload {
        let source = centerCropToCardAspect(normalized(image))
        guard let full = jpegData(from: source, maxDimension: maxDimension, quality: quality),
              let thumb = squareThumbnail(from: source, dimension: 256).jpegData(compressionQuality: 0.72) else {
            throw ImagePipelineError.processingFailed
        }
        return DrugImagePayload(imageData: full, thumbnailData: thumb)
    }

    static func jpegData(from data: Data, maxDimension: CGFloat = 1_600, quality: CGFloat = 0.75) -> Data? {
        guard let image = try? image(from: data, maxDimension: maxDimension) else { return nil }
        return jpegData(from: image, maxDimension: maxDimension, quality: quality)
    }

    static func jpegData(from image: UIImage, maxDimension: CGFloat = 1_600, quality: CGFloat = 0.75) -> Data? {
        let image = normalized(image)
        let longest = max(image.size.width, image.size.height)
        guard longest > 0 else { return nil }
        let scale = min(1, maxDimension / longest)
        let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        return UIGraphicsImageRenderer(size: size, format: format).image { _ in
            image.draw(in: CGRect(origin: .zero, size: size))
        }.jpegData(compressionQuality: quality)
    }

    static func cropped(_ image: UIImage, to rect: CGRect) -> UIImage {
        let image = normalized(image)
        let safeRect = rect.integral.intersection(CGRect(origin: .zero, size: image.size))
        guard safeRect.width > 0, safeRect.height > 0,
              let cgImage = image.cgImage?.cropping(to: safeRect) else { return image }
        return UIImage(cgImage: cgImage, scale: 1, orientation: .up)
    }

    static func rotatedClockwise(_ image: UIImage) -> UIImage {
        let image = normalized(image)
        let size = CGSize(width: image.size.height, height: image.size.width)
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        return UIGraphicsImageRenderer(size: size, format: format).image { context in
            context.cgContext.translateBy(x: size.width / 2, y: size.height / 2)
            context.cgContext.rotate(by: .pi / 2)
            image.draw(in: CGRect(x: -image.size.width / 2, y: -image.size.height / 2, width: image.size.width, height: image.size.height))
        }
    }

    private static func normalized(_ image: UIImage) -> UIImage {
        guard image.imageOrientation != .up else { return image }
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        return UIGraphicsImageRenderer(size: image.size, format: format).image { _ in
            image.draw(in: CGRect(origin: .zero, size: image.size))
        }
    }

    private static func squareThumbnail(from image: UIImage, dimension: CGFloat) -> UIImage {
        let side = min(image.size.width, image.size.height)
        let rect = CGRect(x: (image.size.width - side) / 2, y: (image.size.height - side) / 2, width: side, height: side)
        let square = cropped(image, to: rect)
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        return UIGraphicsImageRenderer(size: CGSize(width: dimension, height: dimension), format: format).image { _ in
            square.draw(in: CGRect(x: 0, y: 0, width: dimension, height: dimension))
        }
    }

    private static func centerCropToCardAspect(_ image: UIImage) -> UIImage {
        let targetAspect: CGFloat = 4.0 / 3.0
        let aspect = image.size.width / max(image.size.height, 1)
        let size = aspect > targetAspect
            ? CGSize(width: image.size.height * targetAspect, height: image.size.height)
            : CGSize(width: image.size.width, height: image.size.width / targetAspect)
        return cropped(image, to: CGRect(
            x: (image.size.width - size.width) / 2,
            y: (image.size.height - size.height) / 2,
            width: size.width,
            height: size.height
        ))
    }
}

struct CameraPicker: UIViewControllerRepresentable {
    @Environment(\.dismiss) private var dismiss
    let onImage: (UIImage) -> Void

    func makeCoordinator() -> Coordinator { Coordinator(parent: self) }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
        picker.allowsEditing = false
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraPicker
        init(parent: CameraPicker) { self.parent = parent }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage { parent.onImage(image) }
            parent.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) { parent.dismiss() }
    }
}

@MainActor
@Observable
final class CropViewportState {
    var zoomScale: CGFloat = 1
    var minimumZoomScale: CGFloat = 1
    var maximumZoomScale: CGFloat = 6
    var contentOffset: CGPoint = .zero
    var contentInset: UIEdgeInsets = .zero
    var viewportSize: CGSize = .zero
    var imageSize: CGSize = .zero
    var resetToken = 0
    var imageRevision = 0

    var cropRect: CGRect {
        guard zoomScale > 0, imageSize.width > 0, imageSize.height > 0 else {
            return CGRect(origin: .zero, size: imageSize)
        }
        let origin = CGPoint(
            x: max(0, (contentOffset.x + contentInset.left) / zoomScale),
            y: max(0, (contentOffset.y + contentInset.top) / zoomScale)
        )
        let proposed = CGRect(origin: origin, size: CGSize(width: viewportSize.width / zoomScale, height: viewportSize.height / zoomScale))
        let width = min(proposed.width, imageSize.width)
        let height = min(proposed.height, imageSize.height)
        return CGRect(
            x: min(proposed.minX, max(0, imageSize.width - width)),
            y: min(proposed.minY, max(0, imageSize.height - height)),
            width: width,
            height: height
        )
    }
}

struct NativeCropScrollView: UIViewRepresentable {
    let image: UIImage
    let state: CropViewportState

    func makeCoordinator() -> Coordinator { Coordinator(state: state) }

    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.delegate = context.coordinator
        scrollView.backgroundColor = .black
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bouncesZoom = true
        scrollView.decelerationRate = .fast
        scrollView.addSubview(context.coordinator.imageView)
        let doubleTap = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.didDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)
        context.coordinator.scrollView = scrollView
        return scrollView
    }

    func updateUIView(_ scrollView: UIScrollView, context: Context) {
        context.coordinator.update(image: image, revision: state.imageRevision, viewport: scrollView.bounds.size)
        context.coordinator.applyExternalState()
    }

    @MainActor
    final class Coordinator: NSObject, UIScrollViewDelegate {
        let state: CropViewportState
        let imageView = UIImageView()
        weak var scrollView: UIScrollView?
        private var revision = -1
        private var viewport: CGSize = .zero
        private var handledResetToken = -1

        init(state: CropViewportState) {
            self.state = state
            imageView.contentMode = .scaleToFill
            imageView.isUserInteractionEnabled = true
        }

        func update(image: UIImage, revision: Int, viewport: CGSize) {
            guard viewport.width > 0, viewport.height > 0 else { return }
            if self.revision != revision || self.viewport != viewport {
                self.revision = revision
                self.viewport = viewport
                imageView.image = image
                imageView.frame = CGRect(origin: .zero, size: image.size)
                scrollView?.contentSize = image.size
                reset(animated: false)
            }
        }

        func applyExternalState() {
            guard let scrollView else { return }
            if handledResetToken != state.resetToken {
                handledResetToken = state.resetToken
                reset(animated: true)
            } else if abs(scrollView.zoomScale - state.zoomScale) > 0.001 {
                scrollView.setZoomScale(state.zoomScale, animated: false)
            }
        }

        private func reset(animated: Bool) {
            guard let scrollView, viewport.width > 0, viewport.height > 0,
                  imageView.bounds.width > 0, imageView.bounds.height > 0 else { return }
            let minimum = max(viewport.width / imageView.bounds.width, viewport.height / imageView.bounds.height)
            scrollView.minimumZoomScale = minimum
            scrollView.maximumZoomScale = max(minimum * 6, minimum + 0.01)
            scrollView.contentInset = .zero
            scrollView.setZoomScale(minimum, animated: animated)
            let scaledSize = CGSize(width: imageView.bounds.width * minimum, height: imageView.bounds.height * minimum)
            let offset = CGPoint(x: max(0, (scaledSize.width - viewport.width) / 2), y: max(0, (scaledSize.height - viewport.height) / 2))
            scrollView.setContentOffset(offset, animated: animated)
            publish(scrollView)
        }

        @objc func didDoubleTap(_ recognizer: UITapGestureRecognizer) {
            guard let scrollView else { return }
            if scrollView.zoomScale > scrollView.minimumZoomScale * 1.05 {
                reset(animated: true)
            } else {
                let target = min(scrollView.maximumZoomScale, scrollView.minimumZoomScale * 2)
                let point = recognizer.location(in: imageView)
                let size = CGSize(width: scrollView.bounds.width / target, height: scrollView.bounds.height / target)
                scrollView.zoom(to: CGRect(x: point.x - size.width / 2, y: point.y - size.height / 2, width: size.width, height: size.height), animated: true)
            }
        }

        func viewForZooming(in scrollView: UIScrollView) -> UIView? { imageView }
        func scrollViewDidZoom(_ scrollView: UIScrollView) { publish(scrollView) }
        func scrollViewDidScroll(_ scrollView: UIScrollView) { publish(scrollView) }

        private func publish(_ scrollView: UIScrollView) {
            state.zoomScale = scrollView.zoomScale
            state.minimumZoomScale = scrollView.minimumZoomScale
            state.maximumZoomScale = scrollView.maximumZoomScale
            state.contentOffset = scrollView.contentOffset
            state.contentInset = scrollView.contentInset
            state.viewportSize = scrollView.bounds.size
            state.imageSize = imageView.bounds.size
        }
    }
}

struct ImageEditorView: View {
    @Environment(\.dismiss) private var dismiss
    let draft: ImageDraft
    let onUse: (DrugImagePayload) -> Void
    @State private var image: UIImage
    @State private var cropState = CropViewportState()
    @State private var errorMessage: String?

    init(draft: ImageDraft, onUse: @escaping (DrugImagePayload) -> Void) {
        self.draft = draft
        self.onUse = onUse
        _image = State(initialValue: draft.image)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    Text("Pan, pinch, or double-tap to frame the package.")
                        .font(.subheadline).foregroundStyle(.secondary)
                    cropCanvas
                    cropControls
                    previewSection
                }
                .padding()
            }
            .navigationTitle("Prepare Photo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) { Button("Use Photo") { finish() }.fontWeight(.semibold) }
            }
            .alert("Photo error", isPresented: Binding(get: { errorMessage != nil }, set: { if !$0 { errorMessage = nil } })) {
                Button("OK") { errorMessage = nil }
            } message: { Text(errorMessage ?? "") }
        }
        .interactiveDismissDisabled()
    }

    private var cropCanvas: some View {
        NativeCropScrollView(image: image, state: cropState)
            .accessibilityIdentifier("imageCrop.viewport")
            .aspectRatio(4.0 / 3.0, contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay { CropGrid().stroke(.white.opacity(0.72), lineWidth: 0.8).allowsHitTesting(false) }
            .overlay { RoundedRectangle(cornerRadius: 18).stroke(.white.opacity(0.9), lineWidth: 2).allowsHitTesting(false) }
            .accessibilityLabel("Interactive four by three photo crop")
            .accessibilityHint("Pinch or use the zoom controls, drag to position, and double-tap to reset")
    }

    private var cropControls: some View {
        VStack(spacing: 10) {
            HStack {
                Button { setZoom(cropState.zoomScale / 1.25) } label: { Image(systemName: "minus.magnifyingglass") }
                Slider(value: Binding(get: { cropState.zoomScale }, set: { cropState.zoomScale = $0 }), in: cropState.minimumZoomScale...max(cropState.minimumZoomScale + 0.01, cropState.maximumZoomScale))
                    .accessibilityLabel("Crop zoom")
                Button { setZoom(cropState.zoomScale * 1.25) } label: { Image(systemName: "plus.magnifyingglass") }
            }
            HStack {
                Button { rotate() } label: { Label("Rotate 90°", systemImage: "rotate.right") }
                Spacer()
                Button { cropState.resetToken += 1 } label: { Label("Reset", systemImage: "arrow.counterclockwise") }
            }
            .buttonStyle(.bordered)
        }
    }

    private var previewSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Save previews").font(.headline)
            HStack(alignment: .top, spacing: 14) {
                Image(uiImage: previewImage).resizable().scaledToFill()
                    .frame(maxWidth: .infinity).aspectRatio(4.0 / 3.0, contentMode: .fit)
                    .clipped().clipShape(RoundedRectangle(cornerRadius: 14))
                    .accessibilityLabel("Drug Card image preview")
                VStack(spacing: 6) {
                    Image(uiImage: previewImage).resizable().scaledToFill()
                        .frame(width: 76, height: 76).clipped().clipShape(RoundedRectangle(cornerRadius: 14))
                    Text("Library").font(.caption2).foregroundStyle(.secondary)
                }
            }
        }
    }

    private var previewImage: UIImage { ImageCompressor.cropped(image, to: cropState.cropRect) }

    private func setZoom(_ value: CGFloat) {
        cropState.zoomScale = min(max(value, cropState.minimumZoomScale), cropState.maximumZoomScale)
        UISelectionFeedbackGenerator().selectionChanged()
    }

    private func rotate() {
        image = ImageCompressor.rotatedClockwise(image)
        cropState.imageRevision += 1
        cropState.resetToken += 1
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    private func finish() {
        do {
            onUse(try ImageCompressor.payload(from: previewImage))
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

private struct CropGrid: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        for fraction in [1.0 / 3.0, 2.0 / 3.0] {
            path.move(to: CGPoint(x: rect.width * fraction, y: 0))
            path.addLine(to: CGPoint(x: rect.width * fraction, y: rect.height))
            path.move(to: CGPoint(x: 0, y: rect.height * fraction))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height * fraction))
        }
        return path
    }
}

struct DrugPhotoView: View {
    let data: Data?
    var height: CGFloat = 180

    var body: some View {
        Group {
            if let data, let image = UIImage(data: data) {
                Image(uiImage: image).resizable().scaledToFill()
            } else {
                ZStack {
                    LinearGradient(colors: [.teal.opacity(0.18), .blue.opacity(0.12)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    VStack(spacing: 8) {
                        Image(systemName: "pills.fill").font(.system(size: 42))
                        Text("Add a package photo").font(.caption.weight(.semibold))
                    }
                    .foregroundStyle(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity).frame(height: height).clipped()
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

struct DrugThumbnailView: View {
    let drug: Drug
    var size: CGFloat = 64

    var body: some View {
        Group {
            if let data = drug.thumbnailData ?? drug.imageData, let image = UIImage(data: data) {
                Image(uiImage: image).resizable().scaledToFill()
            } else {
                ZStack {
                    LinearGradient(colors: [.teal.opacity(0.18), .blue.opacity(0.14)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    Image(systemName: drug.chapter.icon).foregroundStyle(.teal)
                }
            }
        }
        .frame(width: size, height: size).clipped()
        .clipShape(RoundedRectangle(cornerRadius: size * 0.24, style: .continuous))
    }
}
