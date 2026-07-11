import SwiftData
import SwiftUI

struct SystemDashboardMetrics {
    let chapter: Chapter
    let drugs: [Drug]
    let dueCount: Int

    var masteredCount: Int { drugs.filter(\.isMastered).count }
    var weakCount: Int { drugs.filter { $0.confidenceLevel == .weak || $0.isConfusing }.count }
    var masteryProgress: Double {
        guard !drugs.isEmpty else { return 0 }
        return Double(drugs.reduce(0) { $0 + $1.masteryCount }) / Double(drugs.count * 6)
    }
    var lastAdded: Drug? { drugs.max { $0.dateAdded < $1.dateAdded } }
}

struct HomeView: View {
    @Environment(AppTheme.self) private var theme
    @Environment(AppNavigation.self) private var navigation
    @Environment(ReviewScheduler.self) private var scheduler
    @Query(sort: \Drug.dateAdded, order: .reverse) private var drugs: [Drug]
    @Query(sort: \ShiftLog.startedAt, order: .reverse) private var shifts: [ShiftLog]
    @Query private var profiles: [LearningProfile]
    @Query(sort: \DailyActivity.day, order: .reverse) private var activities: [DailyActivity]
    @State private var showsShift = false

    private let trainingChapters: [Chapter] = [
        .cardiovascular, .respiratory, .endocrine, .musculoskeletal, .eye, .earNoseOropharynx
    ]
    private let shelfChapters: [Chapter] = [
        .otc, .antibiotics, .gastrointestinal, .dermatology, .vitaminsSupplements, .other
    ]

    private var activeShift: ShiftLog? { shifts.first { !$0.isCompleted } }
    private var totalDue: Int { drugs.filter { !$0.isUnknown && scheduler.isDue($0) }.count }
    private var totalWeak: Int { drugs.filter { $0.confidenceLevel == .weak || $0.isConfusing }.count }
    private var focus: FocusRecommendation { FocusModeEngine.recommendation(drugs: drugs, activeShift: activeShift) }

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 22) {
                hero
                dailyMission
                if (profiles.first?.weakDrugRemindersEnabled ?? true) && totalWeak > 0 {
                    Label("\(totalWeak) weak drug\(totalWeak == 1 ? "" : "s") ready for a future Focus step", systemImage: "bell.badge")
                        .font(.caption).foregroundStyle(.secondary).padding(.horizontal, 4)
                }
                sectionHeader("Training Book", arabic: "كتاب التدريب", icon: "book.closed.fill")
                chapterGrid(trainingChapters)
                sectionHeader("Pharmacy Shelf", arabic: "أقسام الصيدلية", icon: "shippingbox.fill")
                chapterGrid(shelfChapters)
            }
            .padding(.horizontal)
            .padding(.bottom, 28)
        }
        .background(theme.background)
        .navigationTitle("Renlyst")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showsShift) { ShiftView() }
        .accessibilityIdentifier("home.dashboard")
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Ready for one good step?")
                        .font(.title2.bold())
                    Text("جاهز لخطوة صغيرة اليوم؟")
                        .font(.headline)
                        .opacity(0.9)
                }
                Spacer()
                Image(systemName: "cross.case.fill")
                    .font(.system(size: 34))
            }
            HStack(spacing: 10) {
                heroMetric(value: "\(drugs.count)", title: "Drugs")
                Divider().overlay(.white.opacity(0.35)).frame(height: 34)
                heroMetric(value: "\(totalDue)", title: "Due")
                Divider().overlay(.white.opacity(0.35)).frame(height: 34)
                heroMetric(value: "\(totalWeak)", title: "Weak")
            }
            VStack(alignment: .leading, spacing: 5) {
                Text("Focus Mode").font(.caption.weight(.bold)).textCase(.uppercase).opacity(0.85)
                Text(focus.title).font(.title3.bold())
                Text(focus.subtitle).font(.subheadline).opacity(0.9)
            }
            Button { performFocusAction() } label: {
                Label(focus.title, systemImage: focus.icon).font(.headline).frame(maxWidth: .infinity, minHeight: 48)
            }
            .buttonStyle(.borderedProminent)
            .tint(.white)
            .foregroundStyle(theme.tint)
            .accessibilityIdentifier("home.focus.\(focus.action.rawValue)")
        }
        .foregroundStyle(.white)
        .padding(20)
        .background(
            LinearGradient(colors: [theme.tint, Color(red: 0.02, green: 0.31, blue: 0.48)], startPoint: .topLeading, endPoint: .bottomTrailing),
            in: RoundedRectangle(cornerRadius: 26, style: .continuous)
        )
    }

    private var dailyMission: some View {
        let completed = activities.first.map { Calendar.current.isDateInToday($0.day) && $0.missionCompleted } ?? false
        return HStack(spacing: 12) {
            Image(systemName: completed ? "checkmark.circle.fill" : "circle.dashed").font(.title2).foregroundStyle(completed ? .green : theme.tint)
            VStack(alignment: .leading, spacing: 2) {
                Text(completed ? "Daily mission complete" : "Daily mission").font(.headline)
                Text(completed ? "Five thoughtful questions—done." : "Complete one five-question practice session.").font(.caption).foregroundStyle(.secondary)
            }
        }
        .padding(14).frame(maxWidth: .infinity, alignment: .leading)
        .background(theme.card, in: RoundedRectangle(cornerRadius: 16))
    }

    private func performFocusAction() {
        switch focus.action {
        case .addDrug: navigation.openCapture()
        case .reviewDue: navigation.startReview(mode: .dueReview)
        case .practiceWeak: navigation.startReview(mode: .weakDrug)
        case .finishShift: showsShift = true
        }
    }

    private func heroMetric(value: String, title: String) -> some View {
        VStack(spacing: 2) {
            Text(value).font(.title2.bold()).monospacedDigit()
            Text(title).font(.caption)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
    }

    private var shiftCard: some View {
        NavigationLink {
            ShiftView()
        } label: {
            HStack(spacing: 14) {
                Image(systemName: activeShift == nil ? "play.circle.fill" : "clock.badge.checkmark.fill")
                    .font(.system(size: 34))
                    .foregroundStyle(theme.tint)
                VStack(alignment: .leading, spacing: 4) {
                    Text(activeShift == nil ? "Start daily shift" : "Continue daily shift")
                        .font(.headline)
                    Text(activeShift == nil ? "ابدأ وردية التدريب" : "أكمل وردية التدريب")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.forward").foregroundStyle(.tertiary)
            }
            .padding(16)
            .background(theme.card, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    private func sectionHeader(_ title: String, arabic: String, icon: String) -> some View {
        HStack {
            Label(title, systemImage: icon).font(.title3.bold())
            Spacer()
            Text(arabic).font(.subheadline.weight(.semibold)).foregroundStyle(.secondary)
        }
    }

    private func chapterGrid(_ chapters: [Chapter]) -> some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 320), spacing: 14)], spacing: 14) {
            ForEach(chapters) { chapter in
                SystemDashboardCard(metrics: metrics(for: chapter))
            }
        }
    }

    private func metrics(for chapter: Chapter) -> SystemDashboardMetrics {
        let chapterDrugs = drugs.filter { $0.chapter == chapter }
        return SystemDashboardMetrics(
            chapter: chapter,
            drugs: chapterDrugs,
            dueCount: chapterDrugs.filter { !$0.isUnknown && scheduler.isDue($0) }.count
        )
    }
}

private struct SystemDashboardCard: View {
    @Environment(AppTheme.self) private var theme
    @Environment(AppNavigation.self) private var navigation
    let metrics: SystemDashboardMetrics

    private var colors: [Color] { theme.colors(for: metrics.chapter) }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                Image(systemName: metrics.chapter.icon)
                    .font(.title2.bold())
                    .frame(width: 44, height: 44)
                    .background(.white.opacity(0.18), in: RoundedRectangle(cornerRadius: 14))
                VStack(alignment: .leading, spacing: 2) {
                    Text(metrics.chapter.rawValue).font(.headline)
                    Text(metrics.chapter.arabicName).font(.caption.weight(.semibold)).opacity(0.9)
                }
                Spacer()
                Text("\(Int(metrics.masteryProgress * 100))%")
                    .font(.title3.bold()).monospacedDigit()
            }

            ProgressView(value: metrics.masteryProgress)
                .tint(.white)

            HStack(spacing: 8) {
                stat("Drugs", metrics.drugs.count)
                stat("Mastered", metrics.masteredCount)
                stat("Due", metrics.dueCount)
                stat("Weak", metrics.weakCount)
            }

            Text("Last added: \(metrics.lastAdded?.displayName ?? "No drugs yet")")
                .font(.caption)
                .lineLimit(1)
                .opacity(0.9)

            HStack(spacing: 10) {
                Button {
                    navigation.openCapture(chapter: metrics.chapter)
                } label: {
                    Label("Add", systemImage: "plus")
                        .frame(maxWidth: .infinity, minHeight: 38)
                }
                Button {
                    navigation.startReview(chapter: metrics.chapter)
                } label: {
                    Label("Review", systemImage: "brain.head.profile")
                        .frame(maxWidth: .infinity, minHeight: 38)
                }
            }
            .font(.subheadline.weight(.semibold))
            .buttonStyle(.borderedProminent)
            .tint(.white)
            .foregroundStyle(colors.last ?? .black)
        }
        .foregroundStyle(.white)
        .padding(17)
        .background(LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing), in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .contentShape(RoundedRectangle(cornerRadius: 24))
        .onTapGesture { navigation.openLibrary(chapter: metrics.chapter) }
        .accessibilityIdentifier("home.system.\(metrics.chapter.rawValue)")
    }

    private func stat(_ title: String, _ value: Int) -> some View {
        VStack(spacing: 2) {
            Text("\(value)").font(.headline).monospacedDigit()
            Text(title).font(.caption2).lineLimit(1).minimumScaleFactor(0.75)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 7)
        .background(.black.opacity(0.12), in: RoundedRectangle(cornerRadius: 10))
    }
}
