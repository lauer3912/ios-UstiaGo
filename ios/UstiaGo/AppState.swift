import SwiftUI
import Combine

class AppState: ObservableObject {
    // MARK: - Published State
    @Published var selectedTab: Tab = .today
    @Published var isPremium: Bool = false
    @Published var currentStreak: Int = 0
    @Published var todaySummary: DailySummary
    @Published var focusModes: [FocusMode] = FocusMode.default
    @Published var currentSession: FocusSession?
    @Published var sessions: [FocusSession] = []
    @Published var achievements: [Achievement] = AchievementLibrary.all
    @Published var settings: AppSettings
    
    // MARK: - Tab Enum
    enum Tab: String, CaseIterable {
        case today = "Today"
        case focus = "Focus"
        case insights = "Insights"
        case windDown = "Wind Down"
        case settings = "Settings"
        
        var icon: String {
            switch self {
            case .today: return "house.fill"
            case .focus: return "timer"
            case .insights: return "chart.bar.fill"
            case .windDown: return "moon.fill"
            case .settings: return "gearshape.fill"
            }
        }
    }
    
    // MARK: - Init
    init() {
        self.todaySummary = DailySummary(date: Date())
        self.settings = AppSettings()
        load()
    }
    
    // MARK: - Persistence
    func save() {
        if let encoded = try? JSONEncoder().encode(sessions) {
            UserDefaults.standard.set(encoded, forKey: "clarity_sessions")
        }
        if let encoded = try? JSONEncoder().encode(focusModes) {
            UserDefaults.standard.set(encoded, forKey: "clarity_focus_modes")
        }
        if let encoded = try? JSONEncoder().encode(achievements) {
            UserDefaults.standard.set(encoded, forKey: "clarity_achievements")
        }
        if let encoded = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(encoded, forKey: "clarity_settings")
        }
        UserDefaults.standard.set(currentStreak, forKey: "clarity_streak")
    }
    
    func load() {
        if let data = UserDefaults.standard.data(forKey: "clarity_sessions"),
           let decoded = try? JSONDecoder().decode([FocusSession].self, from: data) {
            self.sessions = decoded
        }
        if let data = UserDefaults.standard.data(forKey: "clarity_focus_modes"),
           let decoded = try? JSONDecoder().decode([FocusMode].self, from: data) {
            self.focusModes = decoded
        }
        if let data = UserDefaults.standard.data(forKey: "clarity_achievements"),
           let decoded = try? JSONDecoder().decode([Achievement].self, from: data) {
            self.achievements = decoded
        }
        if let data = UserDefaults.standard.data(forKey: "clarity_settings"),
           let decoded = try? JSONDecoder().decode(AppSettings.self, from: data) {
            self.settings = decoded
        }
        self.currentStreak = UserDefaults.standard.integer(forKey: "clarity_streak")
        rebuildTodaySummary()
    }
    
    func rebuildTodaySummary() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        let todaySessions = sessions.filter {
            calendar.isDate($0.startTime, inSameDayAs: today)
        }
        
        let completedToday = todaySessions.filter { $0.completed }
        let totalFocusSeconds = todaySessions.reduce(0) { $0 + $1.duration }
        let longestSession = todaySessions.map { $0.duration }.max() ?? 0
        
        todaySummary.focusMinutes = totalFocusSeconds / 60
        todaySummary.sessionsCompleted = completedToday.count
        todaySummary.longestSession = longestSession
        todaySummary.goalMet = todaySummary.focusMinutes >= settings.dailyFocusGoal
    }
    
    // MARK: - Focus Session Management
    func startSession(mode: FocusMode) {
        currentSession = FocusSession(mode: mode)
    }
    
    func endSession(completed: Bool) {
        guard var session = currentSession else { return }
        session.endTime = Date()
        session.duration = Int(Date().timeIntervalSince(session.startTime))
        session.completed = completed
        sessions.append(session)
        rebuildTodaySummary()
        updateAchievements()
        save()
        currentSession = nil
    }
    
    // MARK: - Achievements
    func updateAchievements() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let completedSessions = sessions.filter { $0.completed }
        
        // First session
        if let idx = achievements.firstIndex(where: { $0.id == "first_session" && !$0.isUnlocked }) {
            achievements[idx].unlockedAt = Date()
        }
        
        // Session count
        let totalSessions = completedSessions.count
        for (count, id) in [(10, "sessions_10"), (100, "sessions_100")] {
            if let idx = achievements.firstIndex(where: { $0.id == id && !$0.isUnlocked }) {
                if totalSessions >= count {
                    achievements[idx].unlockedAt = Date()
                }
                achievements[idx].progress = min(1.0, Double(totalSessions) / Double(count))
            }
        }
        
        // Hours accumulated
        let totalHours = completedSessions.reduce(0) { $0 + $1.duration } / 3600
        for (hours, id) in [(10, "hours_10"), (50, "hours_50")] {
            if let idx = achievements.firstIndex(where: { $0.id == id && !$0.isUnlocked }) {
                if totalHours >= hours {
                    achievements[idx].unlockedAt = Date()
                }
                achievements[idx].progress = min(1.0, Double(totalHours) / Double(hours))
            }
        }
        
        // Streak
        currentStreak = calculateStreak()
        for (days, id) in [(3, "streak_3"), (7, "streak_7"), (30, "streak_30")] {
            if let idx = achievements.firstIndex(where: { $0.id == id && !$0.isUnlocked }) {
                if currentStreak >= days {
                    achievements[idx].unlockedAt = Date()
                }
                achievements[idx].progress = min(1.0, Double(currentStreak) / Double(days))
            }
        }
        
        // Deep work (50+ min)
        if let idx = achievements.firstIndex(where: { $0.id == "deep_work" && !$0.isUnlocked }) {
            if completedSessions.contains(where: { $0.duration >= 50 * 60 }) {
                achievements[idx].unlockedAt = Date()
            }
        }
        
        // Early bird / Night owl
        let hour = calendar.component(.hour, from: Date())
        if hour < 8, let idx = achievements.firstIndex(where: { $0.id == "morning_bird" && !$0.isUnlocked }) {
            achievements[idx].unlockedAt = Date()
        }
        if hour >= 22, let idx = achievements.firstIndex(where: { $0.id == "night_owl" && !$0.isUnlocked }) {
            achievements[idx].unlockedAt = Date()
        }
    }
    
    func calculateStreak() -> Int {
        let calendar = Calendar.current
        var streak = 0
        var date = calendar.startOfDay(for: Date())
        
        while true {
            let hasSession = sessions.contains {
                calendar.isDate($0.startTime, inSameDayAs: date) && $0.completed
            }
            if hasSession {
                streak += 1
                date = calendar.date(byAdding: .day, value: -1, to: date) ?? date
            } else {
                break
            }
        }
        return streak
    }
}

// MARK: - App Settings

struct AppSettings: Codable {
    var dailyScreenGoal: Int = 120         // minutes
    var dailyFocusGoal: Int = 60          // minutes
    var notificationsEnabled: Bool = true
    var windDownStartHour: Int = 21       // 9 PM
    var windDownDuration: Int = 60       // minutes
    var soundEnabled: Bool = true
    var defaultModeId: UUID? = nil
}
