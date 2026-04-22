import Foundation

// MARK: - Focus Mode

struct FocusMode: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var workDuration: Int  // seconds
    var breakDuration: Int // seconds
    var colorHex: String
    var icon: String
    
    static let `default`: [FocusMode] = [
        FocusMode(id: UUID(), name: "Deep Work", workDuration: 50*60, breakDuration: 10*60, colorHex: "#7C6AFF", icon: "brain.head.profile"),
        FocusMode(id: UUID(), name: "Classic", workDuration: 25*60, breakDuration: 5*60, colorHex: "#5EEAD4", icon: "timer"),
        FocusMode(id: UUID(), name: "Flow", workDuration: 90*60, breakDuration: 20*60, colorHex: "#F59E0B", icon: "wind")
    ]
}

// MARK: - Focus Session

struct FocusSession: Identifiable, Codable {
    let id: UUID
    let startTime: Date
    var endTime: Date?
    var duration: Int         // seconds
    var targetDuration: Int   // seconds
    var modeName: String
    var modeColorHex: String
    var completed: Bool
    var blockedCount: Int
    var soundType: String
    
    var isActive: Bool { endTime == nil }
    
    init(mode: FocusMode) {
        self.id = UUID()
        self.startTime = Date()
        self.endTime = nil
        self.duration = 0
        self.targetDuration = mode.workDuration
        self.modeName = mode.name
        self.modeColorHex = mode.colorHex
        self.completed = false
        self.blockedCount = 0
        self.soundType = "none"
    }
}

// MARK: - Daily Summary

struct DailySummary: Identifiable, Codable {
    let id: UUID
    let date: Date
    var totalScreenTime: Int   // minutes
    var focusMinutes: Int
    var sessionsCompleted: Int
    var longestSession: Int    // seconds
    var goalMet: Bool
    var topApps: [AppUsageEntry]
    
    init(date: Date) {
        self.id = UUID()
        self.date = date
        self.totalScreenTime = 0
        self.focusMinutes = 0
        self.sessionsCompleted = 0
        self.longestSession = 0
        self.goalMet = false
        self.topApps = []
    }
}

// MARK: - App Usage

struct AppUsageEntry: Identifiable, Codable {
    let id: UUID
    let appName: String
    let bundleId: String
    let minutes: Int
    
    init(appName: String, bundleId: String, minutes: Int) {
        self.id = UUID()
        self.appName = appName
        self.bundleId = bundleId
        self.minutes = minutes
    }
}

// MARK: - Wind Down Activity

enum WindDownActivityType: String, Codable, CaseIterable {
    case reading = "Reading"
    case journaling = "Journaling"
    case stretching = "Stretching"
    case meditation = "Meditation"
    case none = "Skip"
    
    var icon: String {
        switch self {
        case .reading: return "book.fill"
        case .journaling: return "pencil.line"
        case .stretching: return "figure.flexibility"
        case .meditation: return "brain.head.profile"
        case .none: return "moon.fill"
        }
    }
    
    var description: String {
        switch self {
        case .reading: return "Read a book or article"
        case .journaling: return "Write down your thoughts"
        case .stretching: return "5-minute gentle stretch"
        case .meditation: return "Guided breathwork"
        case .none: return "Skip tonight"
        }
    }
}

struct WindDownActivity: Identifiable, Codable {
    let id: UUID
    let type: WindDownActivityType
    var completed: Bool
    
    init(type: WindDownActivityType) {
        self.id = UUID()
        self.type = type
        self.completed = false
    }
}

struct WindDownSession: Identifiable, Codable {
    let id: UUID
    let startTime: Date
    var activities: [WindDownActivity]
    var completed: Bool
    
    init() {
        self.id = UUID()
        self.startTime = Date()
        self.activities = WindDownActivityType.allCases
            .filter { $0 != .none }
            .map { WindDownActivity(type: $0) }
        self.completed = false
    }
}

// MARK: - Achievement

struct Achievement: Identifiable, Codable {
    let id: String
    let name: String
    let description: String
    let icon: String
    let category: AchievementCategory
    var unlockedAt: Date?
    var progress: Double  // 0.0 to 1.0
    
    var isUnlocked: Bool { unlockedAt != nil }
}

enum AchievementCategory: String, Codable {
    case consistency = "Consistency"
    case volume = "Volume"
    case variety = "Variety"
    case milestones = "Milestones"
}

struct AchievementLibrary {
    static let all: [Achievement] = [
        Achievement(id: "first_session", name: "First Focus", description: "Complete your first focus session", icon: "star.fill", category: .milestones, progress: 0),
        Achievement(id: "streak_3", name: "3-Day Streak", description: "Focus 3 days in a row", icon: "flame.fill", category: .consistency, progress: 0),
        Achievement(id: "streak_7", name: "Week Warrior", description: "Focus 7 days in a row", icon: "flame.fill", category: .consistency, progress: 0),
        Achievement(id: "streak_30", name: "Monthly Master", description: "Focus 30 days in a row", icon: "flame.fill", category: .consistency, progress: 0),
        Achievement(id: "sessions_10", name: "Getting Started", description: "Complete 10 sessions", icon: "10.circle.fill", category: .volume, progress: 0),
        Achievement(id: "sessions_100", name: "Centurion", description: "Complete 100 sessions", icon: "100.circle.fill", category: .volume, progress: 0),
        Achievement(id: "hours_10", name: "10 Hours", description: "Accumulate 10 focus hours", icon: "clock.fill", category: .volume, progress: 0),
        Achievement(id: "hours_50", name: "50 Hours", description: "Accumulate 50 focus hours", icon: "clock.fill", category: .volume, progress: 0),
        Achievement(id: "all_modes", name: "Explorer", description: "Try all focus modes", icon: "map.fill", category: .variety, progress: 0),
        Achievement(id: "deep_work", name: "Deep Diver", description: "Complete a 50+ minute session", icon: "water.waves", category: .milestones, progress: 0),
        Achievement(id: "morning_bird", name: "Early Bird", description: "Start a session before 8 AM", icon: "sunrise.fill", category: .variety, progress: 0),
        Achievement(id: "night_owl", name: "Night Owl", description: "Complete a session after 10 PM", icon: "moon.stars.fill", category: .variety, progress: 0),
    ]
}
