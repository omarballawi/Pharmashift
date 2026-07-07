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
    static func image(from data: Data) throws -> UIImage {
        guard let image = UIImage(data: data) else { throw ImagePipelineError.invalidImage }
        return normalized(image)
    }

    static func payload(from image: UIImage, maxDimension: CGFloat = 1600, quality: CGFloat = 0.75) throws -> DrugImagePayload {
        let source = normalized(image)
        guard let full = jpegData(from: source, maxDimension: maxDimension, quality: quality),
              let thumb = squareThumbnail(from: source, dimension: 256).jpegData(compressionQuality: 0.72) else {
            throw ImagePipelineError.processingFailed
        }
        return DrugImagePayload(imageData: full, thumbnailData: thumb)
    }

    static func jpegData(from data: Data, maxDimension: CGFloat = 1600, quality: CGFloat = 0.75) -> Data? {
        guard let image = UIImage(data: data) else { return nil }
        return jpegData(from: image, maxDimension: maxDimension, quality: quality)
    }

    static func jpegData(from image: UIImage, maxDimension: CGFloat = 1600, quality: CGFloat = 0.75) -> Data? {
        let image = normalized(image)
        let longest = max(image.size.width, image.size.height)
        guard longest > 0 else { return nil }
        let scale = min(1, maxDimension / longest)
        let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        return renderer.image { _ in image.draw(in: CGRect(origin: .zero, size: size)) }
            .jpegData(compressionQuality: quality)
    }

    static func crop(_ image: UIImage, zoom: CGFloat, offset: CGSize, viewport: CGSize) -> UIImage {
        let image = normalized(image)
        let targetAspect: CGFloat = 4.0 / 3.0
        let imageAspect = image.size.width / image.size.height
        let baseSize: CGSize = imageAspect > targetAspect
            ? CGSize(width: image.size.height * targetAspect, height: image.size.height)
            : CGSize(width: image.size.width, height: image.size.width / targetAspect)
        let safeZoom = max(1, zoom)
        let cropSize = CGSize(width: baseSize.width / safeZoom, height: baseSize.height / safeZoom)
        let xMovement = viewport.width > 0 ? offset.width / viewport.width * baseSize.width / safeZoom : 0
        let yMovement = viewport.height > 0 ? offset.height / viewport.height * baseSize.height / safeZoom : 0
        let unclamped = CGPoint(
            x: (image.size.width - cropSize.width) / 2 - xMovement,
            y: (image.size.height - cropSize.height) / 2 - yMovement
        )
        let origin = CGPoint(
            x: min(max(0, unclamped.x), image.size.width - cropSize.width),
            y: min(max(0, unclamped.y), image.size.height - cropSize.height)
        )
        guard let cgImage = image.cgImage?.cropping(to: CGRect(origin: origin, size: cropSize)) else { return image }
        return UIImage(cgImage: cgImage, scale: 1, orientation: .up)
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
        guard let cropped = image.cgImage?.cropping(to: rect) else { return image }
        let square = UIImage(cgImage: cropped)
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        return UIGraphicsImageRenderer(size: CGSize(width: dimension, height: dimension), format: format).image { _ in
            square.draw(in: CGRect(x: 0, y: 0, width: dimension, height: dimension))
        }
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

struct ImageEditorView: View {
    @Environment(\.dismiss) private var dismiss
    let draft: ImageDraft
    let onUse: (DrugImagePayload) -> Void
    @State private var zoom: CGFloat = 1
    @State private var settledZoom: CGFloat = 1
    @State private var offset: CGSize = .zero
    @State private var settledOffset: CGSize = .zero
    @State private var viewport: CGSize = CGSize(width: 340, height: 255)
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Crop & preview / قصّ ومعاينة")
                        .font(.title2.bold())
                    cropCanvas
                    Text("Pinch to zoom and drag to position the package.")
                        .font(.caption).foregroundStyle(.secondary)
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
    }

    private var cropCanvas: some View {
        GeometryReader { proxy in
            Image(uiImage: draft.image)
                .resizable()
                .scaledToFill()
                .scaleEffect(zoom)
                .offset(offset)
                .frame(width: proxy.size.width, height: proxy.size.height)
                .clipped()
                .overlay {
                    RoundedRectangle(cornerRadius: 20).stroke(.white.opacity(0.9), lineWidth: 2)
                }
                .contentShape(Rectangle())
                .gesture(
                    MagnificationGesture()
                        .onChanged { value in zoom = min(4, max(1, settledZoom * value)) }
                        .onEnded { _ in settledZoom = zoom }
                )
                .simultaneousGesture(
                    DragGesture()
                        .onChanged { value in offset = CGSize(width: settledOffset.width + value.translation.width, height: settledOffset.height + value.translation.height) }
                        .onEnded { _ in settledOffset = offset }
                )
                .onAppear { viewport = proxy.size }
                .onChange(of: proxy.size) { _, value in viewport = value }
        }
        .aspectRatio(4.0 / 3.0, contentMode: .fit)
        .background(Color.black)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .accessibilityLabel("Interactive photo crop")
    }

    private var previewSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Live previews / المعاينات").font(.headline)
            HStack(alignment: .top, spacing: 14) {
                preview(width: 210, height: 118, radius: 16)
                VStack(spacing: 6) {
                    preview(width: 74, height: 74, radius: 14)
                    Text("Library").font(.caption2).foregroundStyle(.secondary)
                }
            }
        }
    }

    private func preview(width: CGFloat, height: CGFloat, radius: CGFloat) -> some View {
        Image(uiImage: draft.image)
            .resizable()
            .scaledToFill()
            .scaleEffect(zoom)
            .offset(x: offset.width * width / max(viewport.width, 1), y: offset.height * height / max(viewport.height, 1))
            .frame(width: width, height: height)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: radius))
    }

    private func finish() {
        do {
            let cropped = ImageCompressor.crop(draft.image, zoom: zoom, offset: offset, viewport: viewport)
            onUse(try ImageCompressor.payload(from: cropped))
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
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
        .frame(maxWidth: .infinity)
        .frame(height: height)
        .clipped()
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
        .frame(width: size, height: size)
        .clipped()
        .clipShape(RoundedRectangle(cornerRadius: size * 0.24, style: .continuous))
    }
}
