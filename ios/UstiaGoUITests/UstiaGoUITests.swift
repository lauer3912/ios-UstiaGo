import XCTest

final class UstiaGoUITests: XCTestCase {
    
    private var app: XCUIApplication!
    private let screenshotDir = "/tmp/UstiaGoScreenshots"
    private let tabNames = ["Today", "Focus", "Insights", "Wind Down", "Settings"]
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        
        app = XCUIApplication()
        
        // Create screenshot directory
        try? FileManager.default.createDirectory(atPath: screenshotDir, withIntermediateDirectories: true)
        
        app.launch()
        sleep(2)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testScreenshotAllTabs() {
        // Screenshot initial screen (Today)
        takeScreenshot(named: "Screen1_Today")
        
        // Tap each tab by index (0-4)
        let tabBar = app.tabBars.firstMatch
        let tabCount = tabBar.buttons.count
        print("Found \(tabCount) tab buttons")
        
        for index in 1..<tabCount {
            if tabBar.buttons.element(boundBy: index).exists {
                tabBar.buttons.element(boundBy: index).tap()
                sleep(1)
                let screenName = tabNames.indices.contains(index) ? tabNames[index] : "Tab\(index)"
                takeScreenshot(named: "Screen\(index + 1)_\(screenName)")
            }
        }
    }
    
    private func takeScreenshot(named name: String) {
        let screenshot = XCTAttachment(screenshot: app.windows.firstMatch.screenshot())
        screenshot.name = name
        screenshot.lifetime = .keepAlways
        add(screenshot)
        
        // Save to file
        let screenshotData = app.windows.firstMatch.screenshot().pngRepresentation
        let filePath = "\(screenshotDir)/\(name).png"
        try? screenshotData.write(to: URL(fileURLWithPath: filePath))
        print("Saved screenshot: \(name)")
    }
}
