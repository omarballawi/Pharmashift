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
    @State private var showsShelfQuest = false

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
        .navigationDestination(isPresented: $showsShelfQuest) { ShelfQuestView(chapter: currentChapter) }
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
            Button { showsShelfQuest = true } label: {
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

private struct ShelfQuestView: View {
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
        drugs.first { $0.chapter == chapter && [$0.drugClass, $0.displayName, $0.notes].joined(separator: " ").localizedCaseInsensitiveContains(target) }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 7) {
                    Label("Today’s Shelf Quest", systemImage: "shippingbox.fill").font(.largeTitle.bold())
                    Text("Find real packages, capture them, then connect what is easiest to confuse.").foregroundStyle(.secondary)
                }
                ForEach(targets, id: \.self) { target in
                    HStack(spacing: 12) {
                        Image(systemName: matched(target) == nil ? "square" : "checkmark.square.fill").foregroundStyle(matched(target) == nil ? .secondary : theme.tint).font(.title3)
                        VStack(alignment: .leading) { Text(target).font(.headline); if let drug = matched(target) { Text(drug.displayName).font(.caption).foregroundStyle(.secondary) } }
                        Spacer()
                        if matched(target) == nil { Button { navigation.openCapture(chapter: chapter) } label: { Image(systemName: "camera.fill").frame(width: 44, height: 44) }.buttonStyle(.bordered) }
                    }
                    .padding(14).background(theme.card, in: RoundedRectangle(cornerRadius: 17))
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text("Connect the shelf").font(.headline)
                    Text("Which two packages are easiest to confuse? Open Compare Canvas in Library and record one difference as an atomic note.").font(.subheadline).foregroundStyle(.secondary)
                    Button { navigation.openLibrary(chapter: chapter) } label: { Label("Open Library", systemImage: "square.split.2x1").frame(maxWidth: .infinity, minHeight: 46) }.buttonStyle(.borderedProminent)
                }.padding(16).background(theme.softTint, in: RoundedRectangle(cornerRadius: 20))
            }.padding()
        }
        .background(theme.background).navigationTitle("Shelf Quest").navigationBarTitleDisplayMode(.inline)
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
        NavigationLink { SystemPathView(chapter: metrics.chapter) } label: {
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

private struct SystemPathView: View {
    @Environment(AppTheme.self) private var theme
    @Query(sort: \Drug.drugClass) private var allDrugs: [Drug]
    let chapter: Chapter

    private var drugs: [Drug] { allDrugs.filter { !$0.isUnknown && $0.chapter == chapter } }
    private var classes: [(name: String, drugs: [Drug])] {
        Dictionary(grouping: drugs, by: { $0.drugClass.trimmed.isEmpty ? "Foundations" : $0.drugClass })
            .map { ($0.key, $0.value) }
            .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }
    private var systemProgress: Double {
        guard !drugs.isEmpty else { return 0 }
        return Double(drugs.reduce(0) { $0 + $1.masteryCount }) / Double(drugs.count * 6)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 10) {
                    Label("\(chapter.rawValue) Path", systemImage: chapter.icon).font(.largeTitle.bold())
                    Text("Recognize → Understand → Safety → Counsel → Apply").font(.subheadline).foregroundStyle(.white.opacity(0.76))
                    ProgressView(value: systemProgress).tint(theme.crystalCyan)
                    Text("\(Int(systemProgress * 100))% crystal illuminated").font(.caption.bold()).foregroundStyle(theme.crystalCyan)
                }
                .foregroundStyle(.white).padding(20).frame(maxWidth: .infinity, alignment: .leading)
                .background(theme.crystalGradient, in: RoundedRectangle(cornerRadius: 26, style: .continuous))

                if classes.isEmpty {
                    EmptyStateView(icon: chapter.icon, title: "Start this path", message: "Capture a \(chapter.rawValue.lowercased()) drug and its first class lesson will appear here.")
                } else {
                    ForEach(Array(classes.enumerated()), id: \.offset) { index, group in
                        classLesson(index + 1, group: group)
                    }
                    NavigationLink { PracticeSessionView(mode: .systemSpecific, chapter: chapter) } label: {
                        HStack {
                            Image(systemName: "flag.checkered.circle.fill").font(.title2)
                            VStack(alignment: .leading) { Text("System Checkpoint").font(.headline); Text("Mixed application challenge").font(.caption).foregroundStyle(.secondary) }
                            Spacer(); Image(systemName: "chevron.forward")
                        }
                        .padding(16).background(theme.card, in: RoundedRectangle(cornerRadius: 20))
                    }.buttonStyle(.plain)
                }
            }.padding()
        }
        .background(theme.background).navigationTitle(chapter.rawValue).navigationBarTitleDisplayMode(.inline)
    }

    private func classLesson(_ number: Int, group: (name: String, drugs: [Drug])) -> some View {
        let total = max(1, group.drugs.count * 6)
        let completed = group.drugs.reduce(0) { $0 + $1.masteryCount }
        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("\(number)").font(.caption.bold()).foregroundStyle(.white).frame(width: 30, height: 30)
                    .background(theme.colors(for: chapter).last ?? theme.tint, in: Circle())
                VStack(alignment: .leading, spacing: 2) { Text(group.name).font(.headline); Text("\(group.drugs.count) drug\(group.drugs.count == 1 ? "" : "s")").font(.caption).foregroundStyle(.secondary) }
                Spacer(); Text("\(completed)/\(total)").font(.caption.bold().monospacedDigit()).foregroundStyle(.secondary)
            }
            ProgressView(value: Double(completed), total: Double(total)).tint(theme.colors(for: chapter).last ?? theme.tint)
            HStack(spacing: 5) {
                stage("Recognize", ready: group.drugs.contains { $0.masteryScientificName || $0.masteryTradeName })
                stage("Understand", ready: group.drugs.contains { $0.masteryClass || $0.masteryUse })
                stage("Safety", ready: group.drugs.contains { $0.masteryWarning })
                stage("Counsel", ready: group.drugs.contains { $0.masteryCounseling })
                stage("Apply", ready: group.drugs.contains { $0.correctStreak >= 2 })
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) { ForEach(group.drugs) { drug in NavigationLink { DrugDetailView(drug: drug) } label: { Text(drug.displayName).font(.caption.bold()).padding(.horizontal, 10).frame(minHeight: 38).background(.secondary.opacity(0.09), in: Capsule()) }.buttonStyle(.plain) } }
            }
        }
        .padding(16).background(theme.card, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    private func stage(_ title: String, ready: Bool) -> some View {
        VStack(spacing: 3) { Image(systemName: ready ? "diamond.fill" : "diamond"); Text(title).font(.system(size: 8, weight: .semibold)).lineLimit(1).minimumScaleFactor(0.7) }
            .foregroundStyle(ready ? theme.tint : .secondary).frame(maxWidth: .infinity)
    }
}
