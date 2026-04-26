import XCTest

final class ScreenshotTests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["--uitesting"]
        app.launch()
        usleep(2000000)
    }

    override func tearDownWithError() throws {
        app.terminate()
    }

    private func ss(_ name: String) {
        let path = "/tmp/\(name).png"
        let data = app.windows.firstMatch.screenshot().pngRepresentation
        try? data.write(to: URL(fileURLWithPath: path))
    }

    private func openTab(_ label: String) {
        if app.buttons[label].firstMatch.waitForExistence(timeout: 5) {
            app.buttons[label].firstMatch.tap()
        }
        usleep(1500000)
    }

    // MARK: - iPhone 6.1" (1170×2532 - iPhone 16)

    func testiPhone_61_01_Today() {
        ss("iPhone_61_portrait_01_Today")
    }

    func testiPhone_61_02_Focus() {
        openTab("Focus")
        ss("iPhone_61_portrait_02_Focus")
    }

    func testiPhone_61_03_Insights() {
        openTab("Insights")
        ss("iPhone_61_portrait_03_Insights")
    }

    func testiPhone_61_04_WindDown() {
        openTab("Wind Down")
        ss("iPhone_61_portrait_04_WindDown")
    }

    func testiPhone_61_05_Settings() {
        openTab("Settings")
        ss("iPhone_61_portrait_05_Settings")
    }

    // MARK: - iPhone 6.5" (1284×2778 - iPhone 14 Plus)

    func testiPhone_65_01_Today() {
        ss("iPhone_65_portrait_01_Today")
    }

    func testiPhone_65_02_Focus() {
        openTab("Focus")
        ss("iPhone_65_portrait_02_Focus")
    }

    func testiPhone_65_03_Insights() {
        openTab("Insights")
        ss("iPhone_65_portrait_03_Insights")
    }

    func testiPhone_65_04_WindDown() {
        openTab("Wind Down")
        ss("iPhone_65_portrait_04_WindDown")
    }

    func testiPhone_65_05_Settings() {
        openTab("Settings")
        ss("iPhone_65_portrait_05_Settings")
    }

    // MARK: - iPhone 6.3" (1206×2622 - iPhone 16 Pro)

    func testiPhone_63_01_Today() {
        ss("iPhone_63_portrait_01_Today")
    }

    func testiPhone_63_02_Focus() {
        openTab("Focus")
        ss("iPhone_63_portrait_02_Focus")
    }

    func testiPhone_63_03_Insights() {
        openTab("Insights")
        ss("iPhone_63_portrait_03_Insights")
    }

    func testiPhone_63_04_WindDown() {
        openTab("Wind Down")
        ss("iPhone_63_portrait_04_WindDown")
    }

    func testiPhone_63_05_Settings() {
        openTab("Settings")
        ss("iPhone_63_portrait_05_Settings")
    }

    // MARK: - iPad 13" (2048×2732 - iPad Pro 13" M4)

    func testiPad_13_01_Today() {
        ss("iPad_13_portrait_01_Today")
    }

    func testiPad_13_02_Focus() {
        openTab("Focus")
        ss("iPad_13_portrait_02_Focus")
    }

    func testiPad_13_03_Insights() {
        openTab("Insights")
        ss("iPad_13_portrait_03_Insights")
    }

    func testiPad_13_04_WindDown() {
        openTab("Wind Down")
        ss("iPad_13_portrait_04_WindDown")
    }

    func testiPad_13_05_Settings() {
        openTab("Settings")
        ss("iPad_13_portrait_05_Settings")
    }

    // MARK: - iPad 11" (1668×2388 - iPad Pro 11" M4)

    func testiPad_11_01_Today() {
        ss("iPad_11_portrait_01_Today")
    }

    func testiPad_11_02_Focus() {
        openTab("Focus")
        ss("iPad_11_portrait_02_Focus")
    }

    func testiPad_11_03_Insights() {
        openTab("Insights")
        ss("iPad_11_portrait_03_Insights")
    }

    func testiPad_11_04_WindDown() {
        openTab("Wind Down")
        ss("iPad_11_portrait_04_WindDown")
    }

    func testiPad_11_05_Settings() {
        openTab("Settings")
        ss("iPad_11_portrait_05_Settings")
    }
}
