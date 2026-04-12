import SwiftUI

struct TodayView: View {
    @EnvironmentObject var appState: AppState
    
    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good morning"
        case 12..<17: return "Good afternoon"
        case 17..<21: return "Good evening"
        default: return "Good night"
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Greeting
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(greeting)
                            .font(.clarityTitle)
                            .foregroundColor(ClarityTheme.textSecondary)
                        Text("Ready to focus?")
                            .font(.clarityCaption)
                            .foregroundColor(ClarityTheme.textTertiary)
                    }
                    Spacer()
                    // Streak badge
                    HStack(spacing: 6) {
                        Image(systemName: "flame.fill")
                            .foregroundColor(ClarityTheme.accentWarm)
                        Text("\(appState.currentStreak)")
                            .font(.claritySubheadline)
                            .foregroundColor(ClarityTheme.accentWarm)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(ClarityTheme.accentWarm.opacity(0.15))
                    .cornerRadius(20)
                }
                
                // Screen Time Ring
                ScreenTimeRing(
                    screenMinutes: appState.todaySummary.totalScreenTime,
                    goalMinutes: appState.settings.dailyScreenGoal,
                    focusMinutes: appState.todaySummary.focusMinutes,
                    focusGoal: appState.settings.dailyFocusGoal
                )
                
                // Quick Start Focus
                VStack(alignment: .leading, spacing: 12) {
                    Text("Quick Start")
                        .font(.claritySubheadline)
                        .foregroundColor(ClarityTheme.textSecondary)
                    
                    HStack(spacing: 12) {
                        ForEach(appState.focusModes.prefix(3)) { mode in
                            FocusModeCard(mode: mode) {
                                appState.startSession(mode: mode)
                                appState.selectedTab = .focus
                            }
                        }
                    }
                }
                
                // Today's Stats
                HStack(spacing: 12) {
                    StatCard(
                        icon: "checkmark.circle.fill",
                        value: "\(appState.todaySummary.sessionsCompleted)",
                        label: "Sessions",
                        color: ClarityTheme.success
                    )
                    StatCard(
                        icon: "clock.fill",
                        value: "\(appState.todaySummary.focusMinutes)m",
                        label: "Focus Time",
                        color: ClarityTheme.accentPrimary
                    )
                    StatCard(
                        icon: "timer",
                        value: formatDuration(appState.todaySummary.longestSession),
                        label: "Longest",
                        color: ClarityTheme.accentSecondary
                    )
                }
                
                // Top Apps (stubbed)
                VStack(alignment: .leading, spacing: 12) {
                    Text("Top Apps Today")
                        .font(.claritySubheadline)
                        .foregroundColor(ClarityTheme.textSecondary)
                    
                    if appState.todaySummary.topApps.isEmpty {
                        HStack {
                            Spacer()
                            VStack(spacing: 8) {
                                Image(systemName: "chart.bar.dotted")
                                    .font(.system(size: 32))
                                    .foregroundColor(ClarityTheme.textTertiary)
                                Text("No data yet")
                                    .font(.clarityCaption)
                                    .foregroundColor(ClarityTheme.textTertiary)
                                Text("Screen time tracking unlocks\nwith iOS Screen Time permission")
                                    .font(.clarityCaption)
                                    .foregroundColor(ClarityTheme.textTertiary)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.vertical, 24)
                            Spacer()
                        }
                        .clarityCard()
                    }
                }
                
                // Achievements Preview
                let unlockedCount = appState.achievements.filter { $0.isUnlocked }.count
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Achievements")
                            .font(.claritySubheadline)
                            .foregroundColor(ClarityTheme.textSecondary)
                        Spacer()
                        Text("\(unlockedCount)/\(appState.achievements.count)")
                            .font(.clarityCaption)
                            .foregroundColor(ClarityTheme.textTertiary)
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(appState.achievements.prefix(6)) { achievement in
                                AchievementBadge(achievement: achievement)
                            }
                        }
                    }
                }
                
                Spacer(minLength: 80)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
        }
    }
    
    private func formatDuration(_ seconds: Int) -> String {
        if seconds < 60 { return "\(seconds)s" }
        let minutes = seconds / 60
        if minutes < 60 { return "\(minutes)m" }
        return "\(minutes/60)h \(minutes%60)m"
    }
}

// MARK: - Screen Time Ring

struct ScreenTimeRing: View {
    let screenMinutes: Int
    let goalMinutes: Int
    let focusMinutes: Int
    let focusGoal: Int
    
    private var screenProgress: Double {
        min(1.0, Double(screenMinutes) / Double(goalMinutes))
    }
    
    private var focusProgress: Double {
        min(1.0, Double(focusMinutes) / Double(focusGoal))
    }
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                // Outer ring - Screen Time
                Circle()
                    .stroke(ClarityTheme.surface, lineWidth: 16)
                
                Circle()
                    .trim(from: 0, to: screenProgress)
                    .stroke(
                        ClarityTheme.accentPrimary.opacity(0.3),
                        style: StrokeStyle(lineWidth: 16, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.easeOut(duration: 0.8), value: screenProgress)
                
                // Inner ring - Focus
                Circle()
                    .stroke(ClarityTheme.surface, lineWidth: 10)
                    .padding(16)
                
                Circle()
                    .trim(from: 0, to: focusProgress)
                    .stroke(
                        ClarityTheme.accentSecondary,
                        style: StrokeStyle(lineWidth: 10, lineCap: .round)
                    )
                    .padding(16)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeOut(duration: 0.8), value: focusProgress)
                
                // Center text
                VStack(spacing: 4) {
                    Text("\(screenMinutes)")
                        .font(.clarityMono)
                        .foregroundColor(ClarityTheme.textPrimary)
                    Text("of \(goalMinutes) min")
                        .font(.clarityCaption)
                        .foregroundColor(ClarityTheme.textTertiary)
                    Divider()
                        .frame(width: 60)
                        .padding(.vertical, 4)
                    Text("\(focusMinutes)m focused")
                        .font(.clarityCaption)
                        .foregroundColor(ClarityTheme.accentSecondary)
                }
            }
            .frame(width: 200, height: 200)
            
            HStack(spacing: 24) {
                Label("Screen Time", systemImage: "rectangle.portrait")
                    .font(.clarityCaption)
                    .foregroundColor(ClarityTheme.textSecondary)
                Label("Focus Time", systemImage: "brain.head.profile")
                    .font(.clarityCaption)
                    .foregroundColor(ClarityTheme.accentSecondary)
            }
        }
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .clarityCard()
    }
}

// MARK: - Focus Mode Card

struct FocusModeCard: View {
    let mode: FocusMode
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: mode.icon)
                    .font(.system(size: 24))
                    .foregroundColor(Color(hex: mode.colorHex))
                
                Text(mode.name)
                    .font(.clarityCaption)
                    .foregroundColor(ClarityTheme.textPrimary)
                
                Text("\(mode.workDuration/60)m")
                    .font(.clarityMonoSmall)
                    .foregroundColor(ClarityTheme.textTertiary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(ClarityTheme.bgSecondary)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(hex: mode.colorHex).opacity(0.3), lineWidth: 1)
            )
        }
    }
}

// MARK: - Stat Card

struct StatCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
            
            Text(value)
                .font(.clarityHeadline)
                .foregroundColor(ClarityTheme.textPrimary)
            
            Text(label)
                .font(.clarityCaption)
                .foregroundColor(ClarityTheme.textTertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .clarityCard()
    }
}

// MARK: - Achievement Badge

struct AchievementBadge: View {
    let achievement: Achievement
    
    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(achievement.isUnlocked ? ClarityTheme.accentPrimary.opacity(0.2) : ClarityTheme.surface)
                    .frame(width: 50, height: 50)
                
                Image(systemName: achievement.icon)
                    .font(.system(size: 20))
                    .foregroundColor(achievement.isUnlocked ? ClarityTheme.accentPrimary : ClarityTheme.textTertiary)
            }
            
            Text(achievement.name)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(achievement.isUnlocked ? ClarityTheme.textPrimary : ClarityTheme.textTertiary)
                .lineLimit(1)
        }
        .frame(width: 70)
    }
}

#Preview {
    TodayView()
        .environmentObject(AppState())
        .preferredColorScheme(.dark)
}
