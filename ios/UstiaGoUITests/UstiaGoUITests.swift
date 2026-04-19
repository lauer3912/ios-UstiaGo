import XCTest

final class UstiaGoUITests: XCTestCase {
    
    private var app: XCUIApplication!
    private let screenshotDir = "/tmp/UstiaGoScreenshots"
    private let tabNames = ["Today", "Focus", "Insights", "Wind Down", "Settings"]
    
    override func setUp() {
        super.setUp()
        // Allow test to continue even if one step fails
        continueAfterFailure = true
        
        app = XCUIApplication()
        try? FileManager.default.createDirectory(atPath: screenshotDir, withIntermediateDirectories: true)
        
        app.launch()
        // Wait for app to fully settle
        Thread.sleep(forTimeInterval: 3)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testScreenshotAllTabs() {
        // Screenshot initial screen (Today) -- screen 0
        takeScreenshot(named: "Screen1_Today")
        
        // Tap each tab by label
        for index in 1..<tabNames.count {
            let tabName = tabNames[index]
            // Try to find the tab button by label (more reliable than index on iPad)
            let tabButton = app.tabBars.buttons[tabName]
            
            if tabButton.exists {
                tabButton.tap()
                Thread.sleep(forTimeInterval: 2)  // Wait for screen to settle
                let screenName = tabNames.indices.contains(index) ? tabNames[index] : "Tab\(index)"
                takeScreenshot(named: "Screen\(index + 1)_\(screenName)")
            } else {
                print("Tab '\(tabName)' not found, skipping")
            }
        }
    }
    
    private func takeScreenshot(named name: String) {
        // Ensure window is settled
        Thread.sleep(forTimeInterval: 1)
        
        let screenshot = XCTAttachment(screenshot: app.windows.firstMatch.screenshot())
        screenshot.name = name
        screenshot.lifetime = .keepAlways
        add(screenshot)
        
        // Save to file
        let screenshotData = app.windows.firstMatch.screenshot().pngRepresentation
        let filePath = "\(screenshotDir)/\(name).png"
        try? screenshotData.write(to: URL(fileURLWithPath: filePath))
        print("Saved screenshot: \(name) (\(screenshotData.count) bytes)")
    }
}
