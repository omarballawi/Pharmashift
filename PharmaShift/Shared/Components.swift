import ImageIO
import SwiftUI
import UIKit

struct OrbitMark: View {
    @Environment(AppTheme.self) private var theme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    let progress: Double

    var body: some View {
        GeometryReader { proxy in
            let side = min(proxy.size.width, proxy.size.height)
            ZStack {
                Circle()
                    .trim(from: 0.08, to: 0.84)
                    .stroke(theme.coral, style: StrokeStyle(lineWidth: side * 0.16, lineCap: .round))
                    .rotationEffect(.degrees(-32))
                Circle()
                    .trim(from: 0.42, to: 0.96)
                    .stroke(theme.aqua, style: StrokeStyle(lineWidth: side * 0.12, lineCap: .round))
                    .rotationEffect(.degrees(24))
                Circle()
                    .fill(theme.saffron)
                    .frame(width: side * 0.14, height: side * 0.14)
                    .offset(x: side * 0.28, y: -side * 0.18)
                Circle()
                    .trim(from: 0, to: min(max(progress, 0.04), 1))
                    .stroke(theme.ink.opacity(0.18), style: StrokeStyle(lineWidth: side * 0.025, lineCap: .round, dash: [4, 6]))
                    .rotationEffect(.degrees(-90))
            }
            .padding(side * 0.10)
            .animation(reduceMotion ? nil : RenlystMotion.state, value: progress)
        }
        .aspectRatio(1, contentMode: .fit)
        .accessibilityHidden(true)
    }
}

struct RenlystSurface<Content: View>: View {
    @Environment(AppTheme.self) private var theme
    private let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(16)
            .background(theme.surface, in: RoundedRectangle(cornerRadius: RenlystLayout.surfaceRadius, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: RenlystLayout.surfaceRadius, style: .continuous)
                    .stroke(theme.separator.opacity(0.35), lineWidth: 0.5)
            }
    }
}

struct RenlystSectionHeader: View {
    let title: String
    let subtitle: String?

    init(_ title: String, subtitle: String? = nil) {
        self.title = title
        self.subtitle = subtitle
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title).font(.title3.weight(.semibold))
            if let subtitle, !subtitle.trimmed.isEmpty {
                Text(subtitle).font(.subheadline).foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
    }
}

struct ProductPhoto: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    let data: Data?
    var size: CGFloat = 56
    var cacheKey: String?
    @State private var image: UIImage?

    private var requestID: String {
        ProductImagePipeline.requestID(data: data, cacheKey: cacheKey, maxDimension: size)
    }

    var body: some View {
        ZStack {
            if let image {
                Image(uiImage: image).resizable().scaledToFill()
            } else {
                Image(systemName: "shippingbox.fill")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.secondary.opacity(0.08))
            }
        }
        .frame(width: size, height: size)
        .clipShape(RoundedRectangle(cornerRadius: max(10, size * 0.22), style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: max(10, size * 0.22), style: .continuous)
                .stroke(Color(uiColor: .separator).opacity(0.3), lineWidth: 0.5)
        }
        .accessibilityHidden(true)
        .animation(reduceMotion ? nil : RenlystMotion.state, value: image != nil)
        .task(id: requestID) {
            image = await ProductImagePipeline.shared.image(
                from: data,
                cacheKey: cacheKey,
                maxDimension: size
            )
        }
    }
}

final class ProductImagePipeline: @unchecked Sendable {
    static let shared = ProductImagePipeline()

    private let cache = NSCache<NSString, UIImage>()

    private init() {
        cache.countLimit = 180
        cache.totalCostLimit = 72 * 1_024 * 1_024
    }

    static func requestID(data: Data?, cacheKey: String?, maxDimension: CGFloat) -> String {
        let fingerprint = data.map { "\($0.count)-\($0.prefix(12).base64EncodedString())" } ?? "empty"
        return "\(cacheKey ?? fingerprint)-\(Int(maxDimension.rounded(.up)))"
    }

    func image(from data: Data?, cacheKey: String?, maxDimension: CGFloat) async -> UIImage? {
        guard let data, !data.isEmpty else { return nil }
        let key = Self.requestID(data: data, cacheKey: cacheKey, maxDimension: maxDimension) as NSString
        if let cached = cache.object(forKey: key) { return cached }

        let pixelDimension = max(80, Int((maxDimension * 3).rounded(.up)))
        let decoded = await Task.detached(priority: .userInitiated) {
            Self.downsample(data: data, maxPixelDimension: pixelDimension)
        }.value

        if let decoded {
            let cost = (decoded.cgImage?.bytesPerRow ?? 0) * (decoded.cgImage?.height ?? 0)
            cache.setObject(decoded, forKey: key, cost: cost)
        }
        return decoded
    }

    private static func downsample(data: Data, maxPixelDimension: Int) -> UIImage? {
        let options = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let source = CGImageSourceCreateWithData(data as CFData, options) else { return nil }
        let thumbnailOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceThumbnailMaxPixelSize: maxPixelDimension
        ] as CFDictionary
        guard let cgImage = CGImageSourceCreateThumbnailAtIndex(source, 0, thumbnailOptions) else { return nil }
        return UIImage(cgImage: cgImage)
    }
}

struct RenlystPrimaryButtonStyle: ButtonStyle {
    @Environment(AppTheme.self) private var theme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .frame(maxWidth: .infinity, minHeight: RenlystLayout.controlHeight)
            .foregroundStyle(isEnabled ? Color.white : Color(uiColor: .secondaryLabel))
            .background(
                isEnabled ? (configuration.isPressed ? theme.inkSolid : theme.primaryAction) : theme.separator.opacity(0.24),
                in: RoundedRectangle(cornerRadius: RenlystLayout.compactRadius, style: .continuous)
            )
            .scaleEffect(configuration.isPressed && isEnabled && !reduceMotion ? 0.985 : 1)
            .animation(reduceMotion ? nil : RenlystMotion.press, value: configuration.isPressed)
    }
}

struct RenlystTileButtonStyle: ButtonStyle {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed && !reduceMotion ? 0.975 : 1)
            .opacity(configuration.isPressed ? 0.88 : 1)
            .animation(reduceMotion ? nil : RenlystMotion.press, value: configuration.isPressed)
    }
}

struct RenlystEmptyState: View {
    let imageName: String
    let title: String
    let message: String
    let actionTitle: String?
    let action: (() -> Void)?

    init(imageName: String, title: String, message: String, actionTitle: String? = nil, action: (() -> Void)? = nil) {
        self.imageName = imageName
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
    }

    var body: some View {
        VStack(spacing: 14) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 220, maxHeight: 220)
                .clipShape(RoundedRectangle(cornerRadius: RenlystLayout.surfaceRadius, style: .continuous))
                .accessibilityHidden(true)
            Text(title).font(.title2.weight(.semibold)).multilineTextAlignment(.center)
            Text(message).font(.body).foregroundStyle(.secondary).multilineTextAlignment(.center)
            if let actionTitle, let action {
                Button(actionTitle, action: action)
                    .buttonStyle(RenlystPrimaryButtonStyle())
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, RenlystLayout.pageInset)
        .padding(.vertical, 20)
    }
}

struct MasteryBadge: View {
    let drug: Drug

    var body: some View {
        Text("\(drug.masteryCount)/6")
            .font(.caption.monospacedDigit().weight(.bold))
            .foregroundStyle(drug.isMastered ? .green : .secondary)
            .padding(.horizontal, 9)
            .padding(.vertical, 5)
            .background(.thinMaterial, in: Capsule())
            .accessibilityLabel("Mastery \(drug.masteryCount) of 6")
    }
}

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.largeTitle)
                .foregroundStyle(.secondary)
            Text(title).font(.title3.bold())
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, minHeight: 240)
        .padding()
    }
}

struct LabeledValue: View {
    let label: String
    let value: String

    var body: some View {
        if !value.trimmed.isEmpty {
            VStack(alignment: .leading, spacing: 4) {
                Text(label).font(.caption.weight(.semibold)).foregroundStyle(.secondary)
                Text(value).frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

struct MetricCard: View {
    let title: String
    let value: String
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon).foregroundStyle(.tint)
            Text(value).font(.title2.bold()).monospacedDigit()
            Text(title).font(.caption).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(.background, in: RoundedRectangle(cornerRadius: 16))
    }
}

enum PharmacologyScale: String, CaseIterable {
    case halfLife
    case onset
    case duration

    var bounds: ClosedRange<Double> {
        switch self {
        case .halfLife, .duration: 0.25...168
        case .onset: 1...1_440
        }
    }

    var unit: String { self == .onset ? "min" : "hr" }

    func normalized(_ value: Double) -> Double {
        let clamped = min(max(value, bounds.lowerBound), bounds.upperBound)
        let lower = log(bounds.lowerBound)
        return (log(clamped) - lower) / (log(bounds.upperBound) - lower)
    }

    func value(at normalized: Double) -> Double {
        let position = min(max(normalized, 0), 1)
        let lower = log(bounds.lowerBound)
        return exp(lower + position * (log(bounds.upperBound) - lower))
    }

    func formatted(_ value: Double) -> String {
        if self == .onset {
            return value >= 60 ? String(format: "%.1f hr", value / 60) : String(format: "%.0f min", value)
        }
        if value < 1 { return String(format: "%.0f min", value * 60) }
        if value >= 48 { return String(format: "%.1f days", value / 24) }
        return String(format: "%.1f hr", value)
    }
}

struct PharmacologyMeter: View {
    let title: String
    let icon: String
    let scale: PharmacologyScale
    let value: Double?
    let fallback: String
    let detail: String

    private var displayValue: String {
        if let value { return scale.formatted(value) }
        return fallback.trimmed.isEmpty ? "Unknown" : fallback
    }

    private var normalizedFallback: Double {
        let normalized = fallback.lowercased()
        if normalized.contains("very") { return 1 }
        if normalized.contains("long") || normalized.contains("slow") { return 0.82 }
        if normalized.contains("medium") || normalized.contains("moderate") { return 0.5 }
        if normalized.contains("short") || normalized.contains("fast") { return 0.22 }
        return 0
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 9) {
            HStack {
                Label(title, systemImage: icon).font(.subheadline.weight(.semibold))
                Spacer()
                Text(displayValue).font(.subheadline.monospacedDigit().weight(.bold))
            }
            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    Capsule().fill(.secondary.opacity(0.16)).frame(height: 8)
                    Capsule().fill(.tint).frame(width: markerX(in: proxy.size.width), height: 8)
                    Circle().fill(.tint).frame(width: 18, height: 18)
                        .offset(x: max(0, markerX(in: proxy.size.width) - 9))
                }
            }
            .frame(height: 18)
            HStack {
                Text(scale.formatted(scale.bounds.lowerBound))
                Spacer()
                Text(scale.formatted(scale.bounds.upperBound))
            }
            .font(.caption2).foregroundStyle(.secondary)
            if !detail.trimmed.isEmpty {
                Text(detail).font(.caption).foregroundStyle(.secondary)
            }
        }
        .padding(14)
        .background(.background, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(title), \(displayValue)\(detail.trimmed.isEmpty ? "" : ", \(detail)")")
    }

    private func markerX(in width: CGFloat) -> CGFloat {
        if let value { return width * CGFloat(scale.normalized(value)) }
        return width * CGFloat(normalizedFallback)
    }
}

struct PharmacologyStatusCard: View {
    let title: String
    let value: String
    let detail: String
    let icon: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title3).foregroundStyle(.tint)
                .frame(width: 38, height: 38).background(.tint.opacity(0.12), in: Circle())
            VStack(alignment: .leading, spacing: 3) {
                Text(title).font(.caption).foregroundStyle(.secondary)
                Text(value).font(.subheadline.weight(.semibold))
                if !detail.trimmed.isEmpty { Text(detail).font(.caption).foregroundStyle(.secondary) }
            }
            Spacer()
        }
        .padding(14)
        .background(.background, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

struct DosingFrequencyMeter: View {
    let frequency: DosingFrequency
    let timesPerDay: Int?

    private let labels = ["1×", "2×", "3×", "4×", "PRN"]
    private var selectedIndex: Int? {
        switch frequency {
        case .onceDaily: return 0
        case .twiceDaily: return 1
        case .threeTimesDaily: return 2
        case .fourTimesDaily: return 3
        case .asNeeded: return 4
        case .other: return nil
        case .unknown:
            guard let timesPerDay, (1...4).contains(timesPerDay) else { return nil }
            return timesPerDay - 1
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 9) {
            Label("Dosing", systemImage: "calendar.badge.clock").font(.subheadline.weight(.semibold))
            HStack(spacing: 6) {
                ForEach(labels.indices, id: \.self) { index in
                    Text(labels[index]).font(.caption.monospacedDigit().weight(.semibold))
                        .frame(maxWidth: .infinity).padding(.vertical, 7)
                        .background(selectedIndex == index ? Color.accentColor : Color.secondary.opacity(0.12), in: Capsule())
                        .foregroundStyle(selectedIndex == index ? .white : .primary)
                }
            }
            Text(frequency.rawValue).font(.caption).foregroundStyle(.secondary)
        }
        .padding(14).background(.background, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Dosing frequency, \(frequency.rawValue)")
    }
}

struct SafetyRadar: View {
    let values: [(label: String, severity: SafetySeverity)]

    var body: some View {
        VStack(spacing: 12) {
            Canvas { context, size in
                let center = CGPoint(x: size.width / 2, y: size.height / 2)
                let radius = min(size.width, size.height) * 0.38
                for level in 1...3 {
                    context.stroke(polygon(center: center, radius: radius * CGFloat(level) / 3, count: values.count), with: .color(.secondary.opacity(0.18)))
                }
                for index in values.indices {
                    var spoke = Path()
                    spoke.move(to: center)
                    spoke.addLine(to: point(index: index, count: values.count, center: center, radius: radius))
                    context.stroke(spoke, with: .color(.secondary.opacity(0.18)))
                }
                var data = Path()
                for (index, value) in values.enumerated() {
                    let amount = CGFloat(severityValue(value.severity)) / 3
                    let target = point(index: index, count: values.count, center: center, radius: radius * amount)
                    if index == 0 { data.move(to: target) } else { data.addLine(to: target) }
                }
                data.closeSubpath()
                context.fill(data, with: .color(.orange.opacity(0.22)))
                context.stroke(data, with: .color(.orange), lineWidth: 2)
            }
            .frame(height: 210)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 105), alignment: .leading)], alignment: .leading, spacing: 7) {
                ForEach(Array(values.enumerated()), id: \.offset) { _, item in
                    HStack(spacing: 5) {
                        Circle().fill(color(item.severity)).frame(width: 7, height: 7)
                        Text("\(item.label): \(item.severity.rawValue)").font(.caption2)
                    }
                }
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(values.map { "\($0.label), \($0.severity.rawValue)" }.joined(separator: "; "))
    }

    private func polygon(center: CGPoint, radius: CGFloat, count: Int) -> Path {
        var path = Path()
        for index in 0..<count {
            let target = point(index: index, count: count, center: center, radius: radius)
            if index == 0 { path.move(to: target) } else { path.addLine(to: target) }
        }
        path.closeSubpath()
        return path
    }

    private func point(index: Int, count: Int, center: CGPoint, radius: CGFloat) -> CGPoint {
        let angle = Double(index) / Double(max(count, 1)) * .pi * 2 - .pi / 2
        return CGPoint(x: center.x + CGFloat(cos(angle)) * radius, y: center.y + CGFloat(sin(angle)) * radius)
    }

    private func severityValue(_ severity: SafetySeverity) -> Int {
        switch severity { case .unknown: 0; case .low: 1; case .medium: 2; case .high: 3 }
    }

    private func color(_ severity: SafetySeverity) -> Color {
        switch severity { case .unknown: .secondary; case .low: .green; case .medium: .orange; case .high: .red }
    }
}
