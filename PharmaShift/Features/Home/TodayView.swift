import SwiftData
import SwiftUI

struct HomeView: View {
    @Environment(AppNavigation.self) private var navigation
    @Environment(AppTheme.self) private var theme
    @Query(sort: \Drug.dateAdded, order: .reverse) private var drugs: [Drug]
    @Query(sort: \ShiftLog.startedAt, order: .reverse) private var shifts: [ShiftLog]
    @Query(sort: \DailyActivity.day, order: .reverse) private var activities: [DailyActivity]
    @Query private var profiles: [LearningProfile]
    @State private var showsShift = false

    private var knownDrugs: [Drug] { drugs.filter { !$0.isUnknown } }
    private var activeShift: ShiftLog? { shifts.first(where: { !$0.isCompleted }) }
    private var recommendation: FocusRecommendation {
        FocusModeEngine.recommendation(drugs: knownDrugs, activeShift: activeShift)
    }
    private var recentDrugs: [Drug] {
        Array(knownDrugs.sorted {
            ($0.lastSeenDate ?? $0.dateAdded) > ($1.lastSeenDate ?? $1.dateAdded)
        }.prefix(6))
    }

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: RenlystLayout.sectionSpacing) {
                TodayHero(
                    dateText: Date.now.formatted(.dateTime.weekday(.wide).month(.wide).day()),
                    streak: profiles.first?.currentStreak ?? 0
                )
                RecommendedActionCard(recommendation: recommendation, action: performRecommendation)
                WeeklyProgressSection(activities: Array(activities.prefix(7)))
                RecentStudySection(drugs: recentDrugs, addAction: { navigation.presentAdd() })
            }
            .padding(.horizontal, RenlystLayout.pageInset)
            .padding(.bottom, 28)
        }
        .background(theme.background)
        .navigationTitle("Today")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    navigation.presentAdd()
                } label: {
                    Label("Add", systemImage: "plus")
                }
                .accessibilityIdentifier("today.add")
            }
        }
        .navigationDestination(isPresented: $showsShift) { ShiftView() }
        .accessibilityIdentifier("today.dashboard")
    }

    private func performRecommendation() {
        switch recommendation.action {
        case .addDrug:
            navigation.presentAdd()
        case .reviewDue:
            navigation.startReview(mode: .dueReview)
        case .practiceWeak:
            navigation.startReview(mode: .weakDrug)
        case .finishShift:
            showsShift = true
        }
    }
}

private struct TodayHero: View {
    @Environment(AppTheme.self) private var theme
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    let dateText: String
    let streak: Int

    private var height: CGFloat { dynamicTypeSize.isAccessibilitySize ? 330 : 218 }

    var body: some View {
        ZStack(alignment: .leading) {
            Image("TodayOrbit")
                .resizable()
                .scaledToFill()
                .frame(height: height)
                .clipped()
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 8) {
                Text(dateText.uppercased())
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                Text("Make one fact\nstick today.")
                    .font(.system(.largeTitle, design: .serif, weight: .semibold))
                    .foregroundStyle(theme.ink)
                    .fixedSize(horizontal: false, vertical: true)
                Text("خطوة صغيرة اليوم، معرفة أقوى غداً")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .environment(\.layoutDirection, .rightToLeft)
                if streak > 0 {
                    Label("\(streak)-day rhythm", systemImage: "flame.fill")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(theme.saffron)
                }
            }
            .padding(20)
            .frame(maxWidth: dynamicTypeSize.isAccessibilitySize ? .infinity : 225, alignment: .leading)
        }
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: RenlystLayout.surfaceRadius, style: .continuous))
        .accessibilityElement(children: .combine)
    }
}

private struct RecommendedActionCard: View {
    @Environment(AppTheme.self) private var theme
    let recommendation: FocusRecommendation
    let action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 13) {
                Image(systemName: recommendation.icon)
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(theme.coral)
                    .frame(width: 46, height: 46)
                    .background(theme.softTint, in: RoundedRectangle(cornerRadius: 13, style: .continuous))
                VStack(alignment: .leading, spacing: 4) {
                    Text("Recommended next").font(.caption.weight(.semibold)).foregroundStyle(.secondary)
                    Text(recommendation.title).font(.title3.weight(.semibold))
                    Text(recommendation.subtitle).font(.subheadline).foregroundStyle(.secondary)
                }
            }
            Button(action: action) {
                Label(actionTitle, systemImage: "arrow.right")
            }
            .buttonStyle(RenlystPrimaryButtonStyle())
            .accessibilityIdentifier("today.recommendedAction")
        }
        .padding(18)
        .background(theme.surface, in: RoundedRectangle(cornerRadius: RenlystLayout.surfaceRadius, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: RenlystLayout.surfaceRadius, style: .continuous)
                .stroke(theme.separator.opacity(0.3), lineWidth: 0.5)
        }
    }

    private var actionTitle: String {
        switch recommendation.action {
        case .addDrug: "Add a drug"
        case .reviewDue: "Start review"
        case .practiceWeak: "Start practice"
        case .finishShift: "Finish reflection"
        }
    }
}

private struct WeeklyProgressSection: View {
    @Environment(AppTheme.self) private var theme
    let activities: [DailyActivity]

    private var completed: Int { activities.filter { $0.missionCompleted }.count }

    var body: some View {
        VStack(alignment: .leading, spacing: 13) {
            RenlystSectionHeader("This week", subtitle: "\(completed) of 7 daily learning moments")
            HStack(alignment: .bottom, spacing: 8) {
                ForEach(0..<7, id: \.self) { index in
                    let activity = activity(forDaysAgo: 6 - index)
                    VStack(spacing: 7) {
                        Capsule()
                            .fill(activity?.missionCompleted == true ? theme.aqua : theme.separator.opacity(0.25))
                            .frame(height: activity?.missionCompleted == true ? 44 : 18)
                        Text(dayLabel(daysAgo: 6 - index))
                            .font(.caption2.weight(.medium))
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(height: 72, alignment: .bottom)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Completed \(completed) of 7 daily learning moments this week")
        }
    }

    private func activity(forDaysAgo days: Int) -> DailyActivity? {
        guard let date = Calendar.current.date(byAdding: .day, value: -days, to: .now) else { return nil }
        return activities.first { Calendar.current.isDate($0.day, inSameDayAs: date) }
    }

    private func dayLabel(daysAgo days: Int) -> String {
        guard let date = Calendar.current.date(byAdding: .day, value: -days, to: .now) else { return "" }
        return date.formatted(.dateTime.weekday(.narrow))
    }
}

private struct RecentStudySection: View {
    @Environment(AppTheme.self) private var theme
    let drugs: [Drug]
    let addAction: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            RenlystSectionHeader("Recently studied", subtitle: "Return to a profile without searching")
            if drugs.isEmpty {
                Button(action: addAction) {
                    HStack(spacing: 13) {
                        ProductPhoto(data: nil)
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Your shelf starts here").font(.headline)
                            Text("Add one active drug to begin.").font(.subheadline).foregroundStyle(.secondary)
                        }
                        Spacer()
                        Image(systemName: "arrow.right").foregroundStyle(theme.coral)
                    }
                    .padding(14)
                    .background(theme.surface, in: RoundedRectangle(cornerRadius: RenlystLayout.surfaceRadius, style: .continuous))
                }
                .buttonStyle(.plain)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 12) {
                        ForEach(drugs) { drug in
                            NavigationLink(value: AppRoute.drug(drug.id)) {
                                VStack(alignment: .leading, spacing: 9) {
                                    ProductPhoto(data: drug.packageThumbnails.first, size: 92, cacheKey: "drug-\(drug.id.uuidString)-recent")
                                    Text(drug.displayName).font(.headline).lineLimit(1)
                                    Text(drug.firstTradeName).font(.caption).foregroundStyle(.secondary).lineLimit(1)
                                }
                                .frame(width: 118, alignment: .leading)
                                .padding(12)
                                .background(theme.surface, in: RoundedRectangle(cornerRadius: RenlystLayout.surfaceRadius, style: .continuous))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
    }
}
