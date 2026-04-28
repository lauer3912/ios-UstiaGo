import XCTest

final class ScreenshotTests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["--uitesting"]
        app.launch()
        Thread.sleep(forTimeInterval: 3.0)  // Wait for app to fully stabilize
    }

    override func tearDownWithError() throws {
        app.terminate()
    }

    // MARK: - Screenshot helper

    private func capture(_ name: String) {
        let path = "/tmp/\(name).png"
        let data = app.windows.firstMatch.screenshot().pngRepresentation
        try? data.write(to: URL(fileURLWithPath: path))
        print("Captured: \(path) (\(data.count) bytes)")
    }

    // MARK: - Tab navigation - SOP §6.3 compliant
    // Uses button label matching which is the most reliable method

    private func tapTab(label: String) {
        // Primary: Use button with matching label
        let button = app.buttons[label]
        if button.exists && button.isHittable {
            button.tap()
            Thread.sleep(forTimeInterval: 2.0)
            return
        }

        // Fallback: Try identifier match
        if app.buttons[label].firstMatch.exists {
            app.buttons[label].firstMatch.tap()
            Thread.sleep(forTimeInterval: 2.0)
            return
        }

        // Last resort: coordinate tap based on tab bar position
        print("WARNING: Could not find tab button: \(label), using coordinate fallback")
        let win = app.windows.firstMatch
        let frame = win.frame
        let tabBarHeight: CGFloat = 83  // Standard iOS tab bar height
        let tabCount: CGFloat = 5
        let tabWidth = frame.width / tabCount
        let yCenter = frame.height - tabBarHeight / 2

        // Map label to tab index
        let tabMap: [String: Int] = [
            "Today": 0,
            "Focus": 1,
            "Insights": 2,
            "Wind Down": 3,
            "Settings": 4
        ]
        let tabIndex = tabMap[label] ?? 0
        let xCenter = tabWidth * (CGFloat(tabIndex) + 0.5)

        let coord = win.coordinate(withNormalizedOffset: .zero)
            .withOffset(CGVector(dx: xCenter, dy: yCenter))
        coord.tap()
        Thread.sleep(forTimeInterval: 2.0)
    }

    // MARK: - iPhone 6.9" (1320×2868 - iPhone 16 Pro Max)

    func testiPhone_69_01_Today() {
        capture("iPhone_69_portrait_01_Today")
    }

    func testiPhone_69_02_Focus() {
        tapTab(label: "Focus")
        capture("iPhone_69_portrait_02_Focus")
    }

    func testiPhone_69_03_Insights() {
        tapTab(label: "Insights")
        capture("iPhone_69_portrait_03_Insights")
    }

    func testiPhone_69_04_WindDown() {
        tapTab(label: "Wind Down")
        capture("iPhone_69_portrait_04_WindDown")
    }

    func testiPhone_69_05_Settings() {
        tapTab(label: "Settings")
        capture("iPhone_69_portrait_05_Settings")
    }

    // MARK: - iPhone 6.5" (1284×2778 - iPhone 14 Plus)

    func testiPhone_65_01_Today() {
        capture("iPhone_65_portrait_01_Today")
    }

    func testiPhone_65_02_Focus() {
        tapTab(label: "Focus")
        capture("iPhone_65_portrait_02_Focus")
    }

    func testiPhone_65_03_Insights() {
        tapTab(label: "Insights")
        capture("iPhone_65_portrait_03_Insights")
    }

    func testiPhone_65_04_WindDown() {
        tapTab(label: "Wind Down")
        capture("iPhone_65_portrait_04_WindDown")
    }

    func testiPhone_65_05_Settings() {
        tapTab(label: "Settings")
        capture("iPhone_65_portrait_05_Settings")
    }

    // MARK: - iPhone 6.3" (1206×2622 - iPhone 16 Pro)

    func testiPhone_63_01_Today() {
        capture("iPhone_63_portrait_01_Today")
    }

    func testiPhone_63_02_Focus() {
        tapTab(label: "Focus")
        capture("iPhone_63_portrait_02_Focus")
    }

    func testiPhone_63_03_Insights() {
        tapTab(label: "Insights")
        capture("iPhone_63_portrait_03_Insights")
    }

    func testiPhone_63_04_WindDown() {
        tapTab(label: "Wind Down")
        capture("iPhone_63_portrait_04_WindDown")
    }

    func testiPhone_63_05_Settings() {
        tapTab(label: "Settings")
        capture("iPhone_63_portrait_05_Settings")
    }

    // MARK: - iPad 13" (2048×2732 - iPad Pro 13" M4)

    func testiPad_13_01_Today() {
        capture("iPad_13_portrait_01_Today")
    }

    func testiPad_13_02_Focus() {
        tapTab(label: "Focus")
        capture("iPad_13_portrait_02_Focus")
    }

    func testiPad_13_03_Insights() {
        tapTab(label: "Insights")
        capture("iPad_13_portrait_03_Insights")
    }

    func testiPad_13_04_WindDown() {
        tapTab(label: "Wind Down")
        capture("iPad_13_portrait_04_WindDown")
    }

    func testiPad_13_05_Settings() {
        tapTab(label: "Settings")
        capture("iPad_13_portrait_05_Settings")
    }

    // MARK: - iPad 11" (1668×2388 - iPad Pro 11" M4)

    func testiPad_11_01_Today() {
        capture("iPad_11_portrait_01_Today")
    }

    func testiPad_11_02_Focus() {
        tapTab(label: "Focus")
        capture("iPad_11_portrait_02_Focus")
    }

    func testiPad_11_03_Insights() {
        tapTab(label: "Insights")
        capture("iPad_11_portrait_03_Insights")
    }

    func testiPad_11_04_WindDown() {
        tapTab(label: "Wind Down")
        capture("iPad_11_portrait_04_WindDown")
    }

    func testiPad_11_05_Settings() {
        tapTab(label: "Settings")
        capture("iPad_11_portrait_05_Settings")
    }
}