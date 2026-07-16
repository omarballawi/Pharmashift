import SwiftData
import SwiftUI

struct SystemDashboardMetrics {
    let chapter: Chapter
    let drugs: [Drug]
    let dueCount: Int

    var masteredCount: Int { drugs.filter(\.isMastered).count }
    var weakCount: Int { drugs.filter { $0.confidenceLevel == .weak || $0.isConfusing }.count }
    var masteryProgress: Double {
        let required = drugs.count * 6
        guard required > 0 else { return 0 }
        return min(1, Double(drugs.reduce(0) { $0 + $1.masteryCount }) / Double(required))
    }
}

struct ShelfQuestView: View {
    @Environment(AppNavigation.self) private var navigation
    @Environment(AppTheme.self) private var theme
    @Query(sort: \Drug.dateAdded, order: .reverse) private var drugs: [Drug]
    let chapter: Chapter

    private var targets: [String] {
        switch chapter {
        case .cardiovascular: ["ACE inhibitor", "ARB", "Beta blocker", "Calcium channel blocker"]
        case .respiratory: ["SABA", "LABA", "Inhaled corticosteroid", "Antihistamine"]
        case .endocrine: ["Biguanide", "Sulfonylurea", "Insulin", "Thyroid medicine"]
        default: ["First package", "Different dosage form", "Safety warning", "Counseling example"]
        }
    }

    private func matched(_ target: String) -> Drug? {
        drugs.first {
            $0.chapter == chapter
                && [$0.drugClass, $0.displayName, $0.notes]
                    .joined(separator: " ")
                    .localizedCaseInsensitiveContains(target)
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: RenlystLayout.sectionSpacing) {
                VStack(alignment: .leading, spacing: 8) {
                    OrbitMark(symbol: chapter.icon, tint: theme.aqua)
                    Text("Today’s Shelf Quest")
                        .font(.largeTitle.bold())
                    Text("Find real packages, capture them, then connect what is easiest to confuse.")
                        .foregroundStyle(.secondary)
                }

                VStack(spacing: 12) {
                    ForEach(targets, id: \.self) { target in
                        let foundDrug = matched(target)
                        RenlystSurface {
                            HStack(spacing: 12) {
                                Image(systemName: foundDrug == nil ? "square" : "checkmark.square.fill")
                                    .foregroundStyle(foundDrug == nil ? .secondary : theme.aqua)
                                    .font(.title3)
                                    .accessibilityHidden(true)
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(target).font(.headline)
                                    if let foundDrug {
                                        Text(foundDrug.displayName)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                Spacer()
                                if foundDrug == nil {
                                    Button {
                                        navigation.openCapture(chapter: chapter)
                                    } label: {
                                        Image(systemName: "camera.fill")
                                            .frame(width: 44, height: 44)
                                    }
                                    .buttonStyle(.bordered)
                                    .accessibilityLabel("Capture \(target)")
                                }
                            }
                        }
                    }
                }

                RenlystSurface {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Connect the shelf").font(.headline)
                        Text("Which two packages are easiest to confuse? Open Compare in Library and record one meaningful difference.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Button {
                            navigation.openLibrary(chapter: chapter)
                        } label: {
                            Label("Open Library", systemImage: "square.split.2x1")
                                .frame(maxWidth: .infinity, minHeight: RenlystLayout.controlHeight)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(theme.secondaryAction)
                    }
                }
            }
            .padding(.horizontal, RenlystLayout.pageInset)
            .padding(.vertical, 20)
        }
        .background(theme.background)
        .navigationTitle("Shelf Quest")
        .navigationBarTitleDisplayMode(.inline)
    }
}
