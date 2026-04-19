import XCTest

final class UstiaGoUITests: XCTestCase {
    
    private var app: XCUIApplication!
    private let screenshotDir = "/tmp/UstiaGoScreenshots"
    private let tabNames = ["Today", "Focus", "Insights", "Wind Down", "Settings"]
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = true
        
        app = XCUIApplication()
        try? FileManager.default.createDirectory(atPath: screenshotDir, withIntermediateDirectories: true)
        
        app.launch()
        Thread.sleep(forTimeInterval: 3)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testScreenshotAllTabs() {
        // Screenshot initial screen (Today)
        takeScreenshot(named: "Screen1_Today")
        
        // Tap each tab by label (use firstMatch to avoid duplicate matches)
        for index in 1..<tabNames.count {
            let tabName = tabNames[index]
            // Use .firstMatch to avoid "multiple matching elements" error
            // when a button label appears both in tab bar and inside a view
            let tabButton = app.buttons[tabName].firstMatch
            
            if tabButton.exists && tabButton.isHittable {
                tabButton.tap()
                Thread.sleep(forTimeInterval: 2)
                let safeName = tabName.replacingOccurrences(of: " ", with: "_")
                takeScreenshot(named: "Screen\(index + 1)_\(safeName)")
            } else {
                print("Tab '\(tabName)' not found or not hittable, skipping")
            }
        }
    }
    
    private func takeScreenshot(named name: String) {
        Thread.sleep(forTimeInterval: 1)
        
        let screenshot = XCTAttachment(screenshot: app.windows.firstMatch.screenshot())
        screenshot.name = name
        screenshot.lifetime = .keepAlways
        add(screenshot)
        
        let screenshotData = app.windows.firstMatch.screenshot().pngRepresentation
        let filePath = "\(screenshotDir)/\(name).png"
        try? screenshotData.write(to: URL(fileURLWithPath: filePath))
        print("Saved: \(name) (\(screenshotData.count) bytes)")
    }
}
