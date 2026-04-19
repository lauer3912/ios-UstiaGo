import XCTest

final class UstiaGoUITests: XCTestCase {
    
    private var app: XCUIApplication!
    private let screenshotDir = "/tmp/UstiaGoScreenshots"
    private let tabNames = ["Today", "Focus", "Insights", "Wind_Down", "Settings"]
    // Tab centers as fraction of screen width (x) and height (y)
    // iPhone: 430x932 pts -> tab bar ~83pts at bottom, center ~889pts
    // iPad: 1032x1376 pts -> tab bar ~83pts at bottom, center ~1335pts
    // Using normalized coordinates (0-1) from top-left corner
    private let tabXPositions: [CGFloat] = [0.1, 0.3, 0.5, 0.7, 0.9]
    private let tabYPosition: CGFloat = 0.96  // Near bottom of screen
    
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
        
        // Tap each tab by coordinate
        for index in 1..<tabNames.count {
            let x = tabXPositions[index]
            let window = app.windows.firstMatch
            let frame = window.frame
            
            // Calculate tap point as fraction of window size
            let xOffset = frame.width * x
            let yOffset = frame.height * tabYPosition
            
            let coord = window.coordinate(withNormalizedOffset: .zero)
                .withOffset(CGVector(dx: xOffset, dy: yOffset))
            
            coord.tap()
            Thread.sleep(forTimeInterval: 2)
            takeScreenshot(named: "Screen\(index + 1)_\(tabNames[index])")
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
