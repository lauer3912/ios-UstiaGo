import XCTest

/// Guided Tour UI Test — 用于录屏引导操作
/// 模拟用户首次使用的完整引导流程
final class GuidedTourTests: XCTestCase {

    private var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = true
        app = XCUIApplication()
        app.launchArguments = ["--uitesting"]
        app.launch()
    }

    override func tearDown() {
        app.terminate()
        super.tearDown()
    }

    private func slowTap(_ element: XCUIElement, delay: TimeInterval = 1.0) {
        guard element.exists && element.isHittable else {
            print("Element not hittable: \(element.identifier)")
            return
        }
        element.tap()
        Thread.sleep(forTimeInterval: delay)
    }

    private func swipeUp(duration: TimeInterval = 1.0) {
        let win = app.windows.firstMatch
        let center = win.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.6))
        let end = win.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.3))
        center.press(forDuration: 0.2, thenDragTo: end)
        Thread.sleep(forTimeInterval: duration)
    }

    private func swipeDown(duration: TimeInterval = 1.0) {
        let win = app.windows.firstMatch
        let start = win.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.3))
        let end = win.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.6))
        start.press(forDuration: 0.2, thenDragTo: end)
        Thread.sleep(forTimeInterval: duration)
    }

    // MARK: - Guided Tour Steps

    func testGuidedTour() {
        // Step 1: Today tab
        capture("Step_01_Today")
        slowTap(app.buttons["Today"])

        // Step 2: Focus tab
        capture("Step_02_Focus")
        slowTap(app.buttons["Focus"])

        // Step 3: Swipe in Focus view
        swipeUp()
        capture("Step_03_Focus_Scrolled")
        swipeDown()

        // Step 4: Insights tab
        capture("Step_04_Insights")
        slowTap(app.buttons["Insights"])
        swipeUp()
        capture("Step_05_Insights_Scrolled")

        // Step 5: Wind Down tab
        capture("Step_06_WindDown")
        slowTap(app.buttons["Wind Down"])
        swipeUp()
        capture("Step_07_WindDown_Scrolled")

        // Step 6: Settings tab
        capture("Step_08_Settings")
        slowTap(app.buttons["Settings"])

        // Step 7: Scroll Settings
        swipeUp()
        capture("Step_09_Settings_Scrolled")
        swipeDown()

        // Step 8: Back to Today
        slowTap(app.buttons["Today"])

        // Step 9: Long press gesture
        capture("Step_10_LongPress")
        let win = app.windows.firstMatch
        let center = win.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
        center.press(forDuration: 2.0)
        Thread.sleep(forTimeInterval: 1.0)

        // Final: Screenshot
        capture("Step_11_Final")
    }

    private func capture(_ name: String) {
        let attachment = XCTAttachment(screenshot: app.windows.firstMatch.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
        print("Captured: \(name)")
    }
}