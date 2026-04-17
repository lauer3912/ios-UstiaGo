import SwiftUI

struct InsightsView: View {
    @EnvironmentObject var appState: AppState
    
    private var weeklyData: [DayData] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return (0..<7).compactMap { offset in
            guard let date = calendar.date(byAdding: .day, value: -offset, to: today) else { return nil }
            let sessions = appState.sessions.filter {
                calendar.isDate($0.startTime, inSameDayAs: date)
            }
            let focusMinutes = sessions.reduce(0) { $0 + $1.duration } / 60
            return DayData(date: date, focusMinutes: focusMinutes)
        }.reversed()
    }
    
    private var bestDay: DayData? {
        weeklyData.max(by: { $0.focusMinutes < $1.focusMinutes })
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Weekly Overview
                VStack(alignment: .leading, spacing: 16) {
                    Text("This Week")
                        .font(.clarityHeadline)
                        .foregroundColor(UstiaTheme.textPrimary)
                    
                    WeeklyBarChart(data: weeklyData)
                }
                
                // Best Day
                if let best = bestDay, best.focusMinutes > 0 {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Best Day")
                                .font(.clarityCaption)
                                .foregroundColor(UstiaTheme.textTertiary)
                            Text("\(best.focusMinutes) min")
                                .font(.clarityTitle)
                                .foregroundColor(UstiaTheme.accentSecondary)
                            Text(best.date.formatted(.dateTime.weekday(.wide)))
                                .font(.clarityCaption)
                                .foregroundColor(UstiaTheme.textSecondary)
                        }
                        Spacer()
                        Image(systemName: "trophy.fill")
                            .font(.system(size: 32))
                            .foregroundColor(UstiaTheme.accentWarm)
                    }
                    .padding(20)
                    .background(LinearGradient(colors: [UstiaTheme.accentSecondary.opacity(0.15), UstiaTheme.bgSecondary], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .cornerRadius(20)
                }
                
                // AI Insight Card
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "lightbulb.fill")
                            .foregroundColor(UstiaTheme.accentWarm)
                        Text("Insight")
                            .font(.claritySubheadline)
                            .foregroundColor(UstiaTheme.textSecondary)
                    }
                    
                    let totalMinutes = weeklyData.reduce(0) { $0 + $1.focusMinutes }
                    let avgMinutes = weeklyData.isEmpty ? 0 : totalMinutes / weeklyData.count
                    let totalSessions = appState.sessions.count
                    
                    Text(insightMessage(avgMinutes: avgMinutes, totalSessions: totalSessions))
                        .font(.clarityBody)
                        .foregroundColor(UstiaTheme.textPrimary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(UstiaTheme.accentWarm.opacity(0.1))
                .cornerRadius(20)
                
                // Focus Score
                let score = calculateFocusScore()
                VStack(alignment: .leading, spacing: 16) {
                    Text("Focus Score")
                        .font(.clarityHeadline)
                        .foregroundColor(UstiaTheme.textPrimary)
                    
                    HStack {
                        ZStack {
                            Circle()
                                .stroke(UstiaTheme.surface, lineWidth: 8)
                                .frame(width: 80, height: 80)
                            
                            Circle()
                                .trim(from: 0, to: Double(score) / 100.0)
                                .stroke(
                                    scoreColor(score),
                                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                                )
                                .frame(width: 80, height: 80)
                                .rotationEffect(.degrees(-90))
                            
                            Text("\(score)")
                                .font(.clarityTitle)
                                .foregroundColor(UstiaTheme.textPrimary)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(scoreLabel(score))
                                .font(.claritySubheadline)
                                .foregroundColor(scoreColor(score))
                            Text(scoreDescription(score))
                                .font(.clarityCaption)
                                .foregroundColor(UstiaTheme.textTertiary)
                        }
                        .padding(.leading, 8)
                        
                        Spacer()
                    }
                }
                .padding(20)
                .background(UstiaTheme.bgSecondary)
                .cornerRadius(20)
                
                // All Achievements
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Achievements")
                            .font(.clarityHeadline)
                            .foregroundColor(UstiaTheme.textPrimary)
                        Spacer()
                        let unlocked = appState.achievements.filter { $0.isUnlocked }.count
                        Text("\(unlocked)/\(appState.achievements.count)")
                            .font(.clarityCaption)
                            .foregroundColor(UstiaTheme.textTertiary)
                    }
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 12) {
                        ForEach(appState.achievements) { achievement in
                            AchievementCell(achievement: achievement)
                        }
                    }
                }
                
                Spacer(minLength: 80)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
        }
    }
    
    private func insightMessage(avgMinutes: Int, totalSessions: Int) -> String {
        if totalSessions == 0 {
            return "Start your first focus session to get personalized insights about your productivity patterns."
        } else if avgMinutes < 20 {
            return "You're averaging \(avgMinutes) minutes of focus per day this week. Try adding one more 25-minute session to build consistency."
        } else if avgMinutes < 60 {
            return "Great momentum! \(avgMinutes) minutes average shows you're building a solid habit. Your best days had 2-3 sessions each."
        } else {
            return "Impressive focus this week — \(avgMinutes) minutes per day on average. You're in the top 20% of Clarity users. Consider a rest day to avoid burnout."
        }
    }
    
    private func calculateFocusScore() -> Int {
        let totalSessions = appState.sessions.filter { $0.completed }.count
        let totalMinutes = appState.sessions.reduce(0) { $0 + $1.duration } / 60
        let streak = appState.currentStreak
        
        var score = 0
        score += min(30, totalSessions * 3)      // up to 30 for session count
        score += min(40, totalMinutes / 2)         // up to 40 for total minutes
        score += min(30, streak * 5)              // up to 30 for streak
        return min(100, score)
    }
    
    private func scoreColor(_ score: Int) -> Color {
        switch score {
        case 0..<40: return UstiaTheme.destructive
        case 40..<70: return UstiaTheme.accentWarm
        default: return UstiaTheme.success
        }
    }
    
    private func scoreLabel(_ score: Int) -> String {
        switch score {
        case 0..<40: return "Building"
        case 40..<70: return "Consistent"
        default: return "Excellent"
        }
    }
    
    private func scoreDescription(_ score: Int) -> String {
        switch score {
        case 0..<40: return "Keep building your habit"
        case 40..<70: return "You're on the right track"
        default: return "Outstanding focus!"
        }
    }
}

// MARK: - Day Data

struct DayData: Identifiable {
    let id = UUID()
    let date: Date
    let focusMinutes: Int
    
    var dayInitial: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return String(formatter.string(from: date).prefix(1))
    }
}

// MARK: - Weekly Bar Chart

struct WeeklyBarChart: View {
    let data: [DayData]
    
    private var maxMinutes: Int {
        max(data.map { $0.focusMinutes }.max() ?? 60, 60)
    }
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            ForEach(data) { day in
                VStack(spacing: 6) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(day.focusMinutes > 0 ? UstiaTheme.accentPrimary : UstiaTheme.surface)
                        .frame(width: 36, height: CGFloat(day.focusMinutes) / CGFloat(maxMinutes) * 100 + 4)
                    
                    Text(day.dayInitial)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(UstiaTheme.textTertiary)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(height: 140)
        .padding(20)
        .background(UstiaTheme.bgSecondary)
        .cornerRadius(20)
    }
}

// MARK: - Achievement Cell

struct AchievementCell: View {
    let achievement: Achievement
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(achievement.isUnlocked ? UstiaTheme.accentPrimary.opacity(0.2) : UstiaTheme.surface)
                    .frame(width: 56, height: 56)
                
                if achievement.isUnlocked {
                    Image(systemName: achievement.icon)
                        .font(.system(size: 22))
                        .foregroundColor(UstiaTheme.accentPrimary)
                } else {
                    Image(systemName: achievement.icon)
                        .font(.system(size: 22))
                        .foregroundColor(UstiaTheme.textTertiary)
                        .opacity(0.4)
                }
            }
            
            Text(achievement.name)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(achievement.isUnlocked ? UstiaTheme.textPrimary : UstiaTheme.textTertiary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    InsightsView()
        .environmentObject(AppState())
        .preferredColorScheme(.dark)
}
