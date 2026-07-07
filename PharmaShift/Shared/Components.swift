import SwiftUI

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
                .font(.system(size: 42))
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
        guard let value else { return 0 }
        return width * CGFloat(scale.normalized(value))
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
