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
