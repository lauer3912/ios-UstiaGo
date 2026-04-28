import XCTest
@testable import UstiaGo

final class UstiaGoTests: XCTestCase {

    // MARK: - FocusMode Tests

    func testFocusModeDefaultCount() {
        XCTAssertEqual(FocusMode.default.count, 3)
    }

    func testFocusModeProperties() {
        let mode = FocusMode.default[0]
        XCTAssertFalse(mode.name.isEmpty)
        XCTAssertGreaterThan(mode.workDuration, 0)
        XCTAssertGreaterThanOrEqual(mode.breakDuration, 0)
        XCTAssertFalse(mode.colorHex.isEmpty)
        XCTAssertFalse(mode.icon.isEmpty)
    }

    func testFocusModeDeepWork() {
        let deepWork = FocusMode.default.first { $0.name == "Deep Work" }
        XCTAssertNotNil(deepWork)
        XCTAssertEqual(deepWork?.workDuration, 50 * 60)
        XCTAssertEqual(deepWork?.breakDuration, 10 * 60)
    }

    func testFocusModeClassic() {
        let classic = FocusMode.default.first { $0.name == "Classic" }
        XCTAssertNotNil(classic)
        XCTAssertEqual(classic?.workDuration, 25 * 60)
        XCTAssertEqual(classic?.breakDuration, 5 * 60)
    }

    func testFocusModeFlow() {
        let flow = FocusMode.default.first { $0.name == "Flow" }
        XCTAssertNotNil(flow)
        XCTAssertEqual(flow?.workDuration, 90 * 60)
        XCTAssertEqual(flow?.breakDuration, 20 * 60)
    }

    // MARK: - FocusSession Tests

    func testFocusSessionCreation() {
        let mode = FocusMode.default[0]
        let session = FocusSession(mode: mode)
        XCTAssertNotEqual(session.id, UUID())
        XCTAssertEqual(session.modeName, mode.name)
        XCTAssertEqual(session.modeColorHex, mode.colorHex)
        XCTAssertEqual(session.targetDuration, mode.workDuration)
        XCTAssertEqual(session.duration, 0)
        XCTAssertFalse(session.completed)
        XCTAssertNil(session.endTime)
        XCTAssertTrue(session.isActive)
    }

    func testFocusSessionIsActive() {
        let mode = FocusMode.default[0]
        var session = FocusSession(mode: mode)
        XCTAssertTrue(session.isActive)
        session.endTime = Date()
        XCTAssertFalse(session.isActive)
    }

    // MARK: - DailySummary Tests

    func testDailySummaryInit() {
        let summary = DailySummary(date: Date())
        XCTAssertNotEqual(summary.id, UUID())
        XCTAssertEqual(summary.focusMinutes, 0)
        XCTAssertEqual(summary.sessionsCompleted, 0)
        XCTAssertFalse(summary.goalMet)
        XCTAssertTrue(summary.topApps.isEmpty)
    }

    // MARK: - AppSettings Tests

    func testAppSettingsDefaultValues() {
        let settings = AppSettings()
        XCTAssertEqual(settings.dailyScreenGoal, 120)
        XCTAssertEqual(settings.dailyFocusGoal, 60)
        XCTAssertTrue(settings.notificationsEnabled)
        XCTAssertEqual(settings.windDownStartHour, 21)
        XCTAssertEqual(settings.windDownDuration, 60)
        XCTAssertTrue(settings.soundEnabled)
        XCTAssertNil(settings.defaultModeId)
    }

    // MARK: - Achievement Tests

    func testAchievementLibraryCount() {
        XCTAssertEqual(AchievementLibrary.all.count, 12)
    }

    func testAchievementNotUnlockedByDefault() {
        for achievement in AchievementLibrary.all {
            XCTAssertNil(achievement.unlockedAt)
            XCTAssertFalse(achievement.isUnlocked)
            XCTAssertEqual(achievement.progress, 0)
        }
    }

    func testAchievementCategories() {
        let categories = Set(AchievementLibrary.all.map { $0.category })
        XCTAssertTrue(categories.contains(.consistency))
        XCTAssertTrue(categories.contains(.volume))
        XCTAssertTrue(categories.contains(.variety))
        XCTAssertTrue(categories.contains(.milestones))
    }

    // MARK: - WindDownActivityType Tests

    func testWindDownActivityTypeCount() {
        XCTAssertEqual(WindDownActivityType.allCases.count, 5)
    }

    func testWindDownActivityTypeIcons() {
        for activity in WindDownActivityType.allCases {
            XCTAssertFalse(activity.icon.isEmpty)
        }
    }

    // MARK: - WindDownSession Tests

    func testWindDownSessionInit() {
        let session = WindDownSession()
        XCTAssertNotEqual(session.id, UUID())
        XCTAssertFalse(session.completed)
        // Should have 4 activities (all except .none)
        XCTAssertEqual(session.activities.count, 4)
    }

    func testWindDownActivityInit() {
        let activity = WindDownActivity(type: .reading)
        XCTAssertNotEqual(activity.id, UUID())
        XCTAssertEqual(activity.type, .reading)
        XCTAssertFalse(activity.completed)
    }

    // MARK: - AppState Tests

    func testAppStateDefaultValues() {
        let state = AppState()
        XCTAssertEqual(state.selectedTab, .today)
        XCTAssertFalse(state.isPremium)
        XCTAssertEqual(state.currentStreak, 0)
        XCTAssertNotNil(state.todaySummary)
        XCTAssertEqual(state.focusModes.count, 3)
        XCTAssertNil(state.currentSession)
        XCTAssertTrue(state.sessions.isEmpty)
        XCTAssertEqual(state.achievements.count, 12)
    }

    func testAppStateTabEnum() {
        XCTAssertEqual(AppState.Tab.allCases.count, 5)
        XCTAssertEqual(AppState.Tab.today.rawValue, "Today")
        XCTAssertEqual(AppState.Tab.focus.rawValue, "Focus")
        XCTAssertEqual(AppState.Tab.insights.rawValue, "Insights")
        XCTAssertEqual(AppState.Tab.windDown.rawValue, "Wind Down")
        XCTAssertEqual(AppState.Tab.settings.rawValue, "Settings")
    }

    func testAppStateTabIcons() {
        XCTAssertEqual(AppState.Tab.today.icon, "house.fill")
        XCTAssertEqual(AppState.Tab.focus.icon, "timer")
        XCTAssertEqual(AppState.Tab.insights.icon, "chart.bar.fill")
        XCTAssertEqual(AppState.Tab.windDown.icon, "moon.fill")
        XCTAssertEqual(AppState.Tab.settings.icon, "gearshape.fill")
    }
}