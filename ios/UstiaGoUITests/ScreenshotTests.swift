import XCTest

final class ScreenshotTests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["--uitesting"]
        app.launch()
        Thread.sleep(forTimeInterval: 2.0)  // Wait for app to fully stabilize
    }

    override func tearDownWithError() throws {
        app.terminate()
    }

    // MARK: - Screenshot helper

    private func capture(_ name: String) {
        let path = "/tmp/\(name).png"
        let data = app.windows.firstMatch.screenshot().pngRepresentation
        try? data.write(to: URL(fileURLWithPath: path))
    }

    // MARK: - Tab navigation using accessibilityIdentifier (SOP §6.3)

    private func tapTab(identifier: String) {
        let predicate = NSPredicate(format: "identifier == %@", identifier)
        let button = app.buttons.matching(predicate).firstMatch
        if button.exists {
            button.tap()
            Thread.sleep(forTimeInterval: 2.0)  // Wait for page to render
        } else {
            print("WARNING: Could not find tab button: \(identifier)")
        }
    }

    // MARK: - iPhone 6.9" (1320×2868 - iPhone 16 Pro Max)

    func testiPhone_69_01_Today() {
        capture("iPhone_69_portrait_01_Today")
    }

    func testiPhone_69_02_Focus() {
        tapTab(identifier: "tab_focus")
        capture("iPhone_69_portrait_02_Focus")
    }

    func testiPhone_69_03_Insights() {
        tapTab(identifier: "tab_insights")
        capture("iPhone_69_portrait_03_Insights")
    }

    func testiPhone_69_04_WindDown() {
        tapTab(identifier: "tab_winddown")
        capture("iPhone_69_portrait_04_WindDown")
    }

    func testiPhone_69_05_Settings() {
        tapTab(identifier: "tab_settings")
        capture("iPhone_69_portrait_05_Settings")
    }

    // MARK: - iPhone 6.5" (1284×2778 - iPhone 14 Plus)

    func testiPhone_65_01_Today() {
        capture("iPhone_65_portrait_01_Today")
    }

    func testiPhone_65_02_Focus() {
        tapTab(identifier: "tab_focus")
        capture("iPhone_65_portrait_02_Focus")
    }

    func testiPhone_65_03_Insights() {
        tapTab(identifier: "tab_insights")
        capture("iPhone_65_portrait_03_Insights")
    }

    func testiPhone_65_04_WindDown() {
        tapTab(identifier: "tab_winddown")
        capture("iPhone_65_portrait_04_WindDown")
    }

    func testiPhone_65_05_Settings() {
        tapTab(identifier: "tab_settings")
        capture("iPhone_65_portrait_05_Settings")
    }

    // MARK: - iPhone 6.3" (1206×2622 - iPhone 16 Pro)

    func testiPhone_63_01_Today() {
        capture("iPhone_63_portrait_01_Today")
    }

    func testiPhone_63_02_Focus() {
        tapTab(identifier: "tab_focus")
        capture("iPhone_63_portrait_02_Focus")
    }

    func testiPhone_63_03_Insights() {
        tapTab(identifier: "tab_insights")
        capture("iPhone_63_portrait_03_Insights")
    }

    func testiPhone_63_04_WindDown() {
        tapTab(identifier: "tab_winddown")
        capture("iPhone_63_portrait_04_WindDown")
    }

    func testiPhone_63_05_Settings() {
        tapTab(identifier: "tab_settings")
        capture("iPhone_63_portrait_05_Settings")
    }

    // MARK: - iPad 13" (2048×2732 - iPad Pro 13" M4)

    func testiPad_13_01_Today() {
        capture("iPad_13_portrait_01_Today")
    }

    func testiPad_13_02_Focus() {
        tapTab(identifier: "tab_focus")
        capture("iPad_13_portrait_02_Focus")
    }

    func testiPad_13_03_Insights() {
        tapTab(identifier: "tab_insights")
        capture("iPad_13_portrait_03_Insights")
    }

    func testiPad_13_04_WindDown() {
        tapTab(identifier: "tab_winddown")
        capture("iPad_13_portrait_04_WindDown")
    }

    func testiPad_13_05_Settings() {
        tapTab(identifier: "tab_settings")
        capture("iPad_13_portrait_05_Settings")
    }

    // MARK: - iPad 11" (1668×2388 - iPad Pro 11" M4)

    func testiPad_11_01_Today() {
        capture("iPad_11_portrait_01_Today")
    }

    func testiPad_11_02_Focus() {
        tapTab(identifier: "tab_focus")
        capture("iPad_11_portrait_02_Focus")
    }

    func testiPad_11_03_Insights() {
        tapTab(identifier: "tab_insights")
        capture("iPad_11_portrait_03_Insights")
    }

    func testiPad_11_04_WindDown() {
        tapTab(identifier: "tab_winddown")
        capture("iPad_11_portrait_04_WindDown")
    }

    func testiPad_11_05_Settings() {
        tapTab(identifier: "tab_settings")
        capture("iPad_11_portrait_05_Settings")
    }
}