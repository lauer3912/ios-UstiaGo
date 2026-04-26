import XCTest
@testable import UstiaGo

final class UstiaGoTests: XCTestCase {

    func testTimerDurationPresets() {
        XCTAssertEqual(AppState.TimerPreset.allCases.count, 5)
        XCTAssertEqual(AppState.TimerPreset.short.duration, 15 * 60)
        XCTAssertEqual(AppState.TimerPreset.medium.duration, 25 * 60)
        XCTAssertEqual(AppState.TimerPreset.long.duration, 45 * 60)
    }

    func testFocusSessionCreation() {
        let session = FocusSession(
            id: UUID(),
            startTime: Date(),
            endTime: Date().addingTimeInterval(25 * 60),
            duration: 25 * 60,
            completed: true
        )
        XCTAssertEqual(session.duration, 25 * 60)
        XCTAssertTrue(session.completed)
    }

    func testThemeMode() {
        XCTAssertEqual(AppTheme.allCases.count, 2)
        XCTAssertEqual(AppTheme.dark.name, "Dark")
        XCTAssertEqual(AppTheme.light.name, "Light")
    }

    func testSoundType() {
        XCTAssertEqual(SoundType.allCases.count, 5)
        XCTAssertEqual(SoundType.rain.description, "Rain")
        XCTAssertEqual(SoundType.forest.description, "Forest")
    }

    func testAppStateDefaultValues() {
        let state = AppState()
        XCTAssertEqual(state.timerDuration, 25 * 60)
        XCTAssertEqual(state.timerPreset, .medium)
        XCTAssertFalse(state.isTimerRunning)
        XCTAssertEqual(state.focusStreak, 0)
    }

    func testWindDownDuration() {
        XCTAssertEqual(WindDownDuration.allCases.count, 3)
        XCTAssertEqual(WindDownDuration.short.duration, 5 * 60)
        XCTAssertEqual(WindDownDuration.medium.duration, 10 * 60)
        XCTAssertEqual(WindDownDuration.long.duration, 15 * 60)
    }
}