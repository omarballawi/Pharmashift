import SwiftData
import SwiftUI

struct SystemDashboardMetrics {
    let chapter: Chapter
    let drugs: [Drug]
    let dueCount: Int

    var masteredCount: Int { drugs.filter(\.isMastered).count }
    var weakCount: Int { drugs.filter { $0.confidenceLevel == .weak || $0.isConfusing }.count }
    var masteryProgress: Double {
        let required = drugs.reduce(0) { $0 + $1.requiredMasteryCount }
        guard required > 0 else { return 0 }
        return min(1, Double(drugs.reduce(0) { $0 + $1.masteryCount }) / Double(required))
    }
}

struct HomeView: View {
    @Environment(AppTheme.self) private var theme
    @Environment(AppNavigation.self) private var navigation
    @Environment(ReviewScheduler.self) private var scheduler
    @Query(sort: \Drug.dateAdded, order: .reverse) private var drugs: [Drug]
    @Query(sort: \ShiftLog.startedAt, order: .reverse) private var shifts: [ShiftLog]
    @Query(sort: \EncounterNote.date, order: .reverse) private var encounterNotes: [EncounterNote]
    @Query private var profiles: [LearningProfile]
    @Query(sort: \DailyActivity.day, order: .reverse) private var activities: [DailyActivity]
    @State private var showsShift = false

    private let primaryChapters: [Chapter] = [
        .cardiovascular, .respiratory, .endocrine, .musculoskeletal, .eye, .earNoseOropharynx
    ]

    private var knownDrugs: [Drug] { drugs.filter { !$0.isUnknown } }
    private var activeShift: ShiftLog? { shifts.first { !$0.isCompleted } }
    private var totalDue: Int { knownDrugs.filter { scheduler.isDue($0) }.count }
    private var weakDrugs: [Drug] {
        knownDrugs.filter { $0.confidenceLevel == .weak || $0.isConfusing || !$0.isMastered }
            .sorted { $0.masteryCount < $1.masteryCount }
    }
    private var focus: FocusRecommendation { FocusModeEngine.recommendation(drugs: drugs, activeShift: activeShift) }
    private var profile: LearningProfile? { profiles.first }
    private var todayComplete: Bool {
        activities.first.map { Calendar.current.isDateInToday($0.day) && $0.missionCompleted } ?? false
    }
    private var crystalProgress: Double {
        let required = knownDrugs.reduce(0) { $0 + $1.requiredMasteryCount }
        guard required > 0 else { return 0 }
        return min(1, Double(knownDrugs.reduce(0) { $0 + $1.masteryCount }) / Double(required))
    }
    private var currentChapter: Chapter {
        weakDrugs.first?.chapter ?? knownDrugs.first?.chapter ?? .cardiovascular
    }

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 22) {
                greeting
                if knownDrugs.isEmpty { onboardingIllustration }
                missionCard
                learningSignals
                currentPathCard
                shelfQuestCard
                sectionTitle("System paths", subtitle: "Your learning map", icon: "point.topleft.down.to.point.bottomright.curvepath")
                ForEach(primaryChapters) { chapter in
                    SystemPathRow(metrics: metrics(for: chapter))
                }
                shiftReflection
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 30)
        }
        .background(theme.background)
        .navigationTitle("Renlyst")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showsShift) { ShiftView() }
        .accessibilityIdentifier("home.dashboard")
    }

    private var onboardingIllustration: some View {
        ZStack(alignment: .bottomLeading) {
            Image("CrystalLearning")
                .resizable().scaledToFill().frame(height: 210).clipped()
            LinearGradient(colors: [.clear, theme.crystalInk.opacity(0.94)], startPoint: .center, endPoint: .bottom)
            VStack(alignment: .leading, spacing: 4) {
                Text("Build knowledge that comes back").font(.title3.bold())
                Text("Capture one drug, learn three facts, then use them.").font(.caption).foregroundStyle(.white.opacity(0.78))
            }
            .foregroundStyle(.white).padding(16)
        }
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("A crystal knowledge network representing your learning journey")
    }

    private var greeting: some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 3) {
                Text(greetingText)
                    .font(.largeTitle.bold())
                Text("One focused loop. Then you are done.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 5) {
                Label("\(profile?.currentStreak ?? 0) day", systemImage: "flame.fill")
                    .foregroundStyle(.orange)
                Label("\(Int(crystalProgress * 100))%", systemImage: "diamond.fill")
                    .foregroundStyle(theme.crystalCyan)
            }
            .font(.caption.weight(.bold))
            .monospacedDigit()
        }
        .padding(.top, 8)
    }

    private var missionCard: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(todayComplete ? "MISSION COMPLETE" : "TODAY’S MISSION")
                        .font(.caption.weight(.heavy))
                        .tracking(1.1)
                        .foregroundStyle(.white.opacity(0.72))
                    Text(todayComplete ? "Crystal restored" : "6 minutes")
                        .font(.system(.largeTitle, design: .rounded, weight: .bold))
                    Text(todayComplete ? "Come back tomorrow for the next loop." : "A smart mix built from what needs attention now.")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.78))
                }
                Spacer()
                ZStack {
                    Circle().fill(.white.opacity(0.10)).frame(width: 62, height: 62)
                    Image(systemName: todayComplete ? "checkmark.seal.fill" : "sparkles")
                        .font(.system(size: 28, weight: .semibold))
                }
            }

            HStack(spacing: 0) {
                missionMetric("Due", value: totalDue)
                Divider().overlay(.white.opacity(0.18)).frame(height: 34)
                missionMetric("Weak", value: weakDrugs.count)
                Divider().overlay(.white.opacity(0.18)).frame(height: 34)
                missionMetric("Activities", value: knownDrugs.isEmpty ? 0 : 7)
            }

            Button {
                if knownDrugs.isEmpty { navigation.openCapture() }
                else { navigation.startReview(mode: .smartSession) }
            } label: {
                HStack {
                    Text(knownDrugs.isEmpty ? "Capture your first drug" : "Continue")
                    Spacer()
                    Image(systemName: "arrow.right")
                }
                .font(.headline)
                .frame(maxWidth: .infinity, minHeight: 50)
                .padding(.horizontal, 4)
            }
            .buttonStyle(.borderedProminent)
            .tint(.white)
            .foregroundStyle(theme.crystalInk)
            .accessibilityIdentifier("home.focus.\(focus.action.rawValue)")
        }
        .foregroundStyle(.white)
        .padding(20)
        .background(theme.crystalGradient, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
        .shadow(color: theme.crystalViolet.opacity(0.18), radius: 22, y: 12)
    }

    private func missionMetric(_ title: String, value: Int) -> some View {
        VStack(spacing: 2) {
            Text("\(value)").font(.title3.bold()).monospacedDigit()
            Text(title).font(.caption2).foregroundStyle(.white.opacity(0.68))
        }
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder private var learningSignals: some View {
        if let weak = weakDrugs.first {
            Button { navigation.startReview(mode: .weakDrug) } label: {
                SignalRow(
                    icon: "bolt.heart.fill",
                    eyebrow: "WEAK TODAY",
                    title: weak.displayName,
                    detail: weakField(for: weak),
                    tint: .orange
                )
            }
            .buttonStyle(.plain)
        }
        if let note = encounterNotes.first {
            SignalRow(
                icon: "arrow.counterclockwise.circle.fill",
                eyebrow: "RESURFACED",
                title: note.topic.trimmed.isEmpty ? note.relatedDrugNameSnapshot : note.topic,
                detail: note.whatILearned.trimmed.isEmpty ? note.pharmacistNote : note.whatILearned,
                tint: theme.tint
            )
        }
    }

    private var currentPathCard: some View {
        let chapterDrugs = knownDrugs.filter { $0.chapter == currentChapter }
        let progress = metrics(for: currentChapter).masteryProgress
        return VStack(alignment: .leading, spacing: 13) {
            HStack {
                Label("Current path", systemImage: currentChapter.icon).font(.headline)
                Spacer()
                Text("\(Int(progress * 100))%")
                    .font(.headline.monospacedDigit())
                    .foregroundStyle(theme.tint)
            }
            Text(currentChapter.rawValue)
                .font(.title2.bold())
            Text(nextClass(in: chapterDrugs))
                .font(.subheadline)
                .foregroundStyle(.secondary)
            ProgressView(value: progress)
                .tint(theme.tint)
            HStack(spacing: 8) {
                ForEach(["Recognize", "Understand", "Safety", "Counsel", "Apply"], id: \.self) { stage in
                    Text(stage)
                        .font(.caption2.weight(.semibold))
                        .lineLimit(1)
                        .minimumScaleFactor(0.72)
                        .frame(maxWidth: .infinity)
                }
            }
            .foregroundStyle(.secondary)
        }
        .padding(18)
        .background(theme.card, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        .onTapGesture { navigation.openLibrary(chapter: currentChapter) }
    }

    private var shelfQuestCard: some View {
        HStack(spacing: 14) {
            Image(systemName: "shippingbox.and.arrow.backward.fill")
                .font(.title2)
                .foregroundStyle(theme.tint)
                .frame(width: 48, height: 48)
                .background(theme.softTint, in: RoundedRectangle(cornerRadius: 15, style: .continuous))
            VStack(alignment: .leading, spacing: 4) {
                Text("Shelf Quest").font(.headline)
                Text("Find one \(nextClass(in: knownDrugs.filter { $0.chapter == currentChapter }).lowercased()) package today.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Button { navigation.openCapture(chapter: currentChapter) } label: {
                Image(systemName: "camera.fill").frame(width: 44, height: 44)
            }
            .buttonStyle(.bordered)
            .accessibilityLabel("Start Shelf Quest capture")
        }
        .padding(16)
        .background(theme.card, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    private var shiftReflection: some View {
        Button { showsShift = true } label: {
            HStack {
                Label(activeShift == nil ? "Start daily pharmacy note" : "Finish today’s pharmacy note", systemImage: "note.text.badge.plus")
                Spacer()
                Image(systemName: "chevron.forward")
            }
            .font(.subheadline.weight(.semibold))
            .frame(minHeight: 44)
        }
        .buttonStyle(.plain)
        .foregroundStyle(theme.tint)
    }

    private func sectionTitle(_ title: String, subtitle: String, icon: String) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Label(title, systemImage: icon).font(.title2.bold())
            Spacer()
            Text(subtitle).font(.caption).foregroundStyle(.secondary)
        }
        .padding(.top, 4)
    }

    private func metrics(for chapter: Chapter) -> SystemDashboardMetrics {
        let chapterDrugs = knownDrugs.filter { $0.chapter == chapter }
        return SystemDashboardMetrics(
            chapter: chapter,
            drugs: chapterDrugs,
            dueCount: chapterDrugs.filter { scheduler.isDue($0) }.count
        )
    }

    private func nextClass(in values: [Drug]) -> String {
        values.first(where: { !$0.isMastered && !$0.drugClass.trimmed.isEmpty })?.drugClass
            ?? values.first(where: { !$0.drugClass.trimmed.isEmpty })?.drugClass
            ?? "Foundations"
    }

    private func weakField(for drug: Drug) -> String {
        if !drug.masteryScientificName { return "Scientific name" }
        if !drug.masteryTradeName { return "Trade name" }
        if !drug.masteryClass { return "Class" }
        if !drug.masteryUse { return "Main use" }
        if !drug.masteryWarning { return "Safety warning" }
        return "Counseling"
    }

    private var greetingText: String {
        switch Calendar.current.component(.hour, from: .now) {
        case 5..<12: "Good morning"
        case 12..<18: "Good afternoon"
        default: "Good evening"
        }
    }
}

private struct SignalRow: View {
    let icon: String
    let eyebrow: String
    let title: String
    let detail: String
    let tint: Color

    var body: some View {
        HStack(spacing: 13) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(tint)
                .frame(width: 44, height: 44)
                .background(tint.opacity(0.11), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            VStack(alignment: .leading, spacing: 3) {
                Text(eyebrow).font(.caption2.weight(.bold)).tracking(0.8).foregroundStyle(.secondary)
                Text(title).font(.headline).foregroundStyle(.primary)
                if !detail.trimmed.isEmpty {
                    Text(detail).font(.caption).foregroundStyle(.secondary).lineLimit(2)
                }
            }
            Spacer()
            Image(systemName: "chevron.forward").font(.caption.bold()).foregroundStyle(.tertiary)
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }
}

private struct SystemPathRow: View {
    @Environment(AppTheme.self) private var theme
    @Environment(AppNavigation.self) private var navigation
    let metrics: SystemDashboardMetrics

    var body: some View {
        Button { navigation.openLibrary(chapter: metrics.chapter) } label: {
            HStack(spacing: 14) {
                Image(systemName: metrics.chapter.icon)
                    .font(.title3.bold())
                    .foregroundStyle(.white)
                    .frame(width: 48, height: 48)
                    .background(theme.colors(for: metrics.chapter).last ?? theme.tint, in: RoundedRectangle(cornerRadius: 15, style: .continuous))
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(metrics.chapter.rawValue).font(.headline)
                        Spacer()
                        Text("\(Int(metrics.masteryProgress * 100))%")
                            .font(.caption.bold().monospacedDigit())
                            .foregroundStyle(.secondary)
                    }
                    ProgressView(value: metrics.masteryProgress)
                        .tint(theme.colors(for: metrics.chapter).last ?? theme.tint)
                    Text("\(metrics.drugs.count) drugs · \(metrics.dueCount) due · \(metrics.weakCount) weak")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(15)
            .background(theme.card, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("home.system.\(metrics.chapter.rawValue)")
    }
}
