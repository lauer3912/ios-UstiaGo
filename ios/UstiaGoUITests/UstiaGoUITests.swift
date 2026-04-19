import XCTest

final class UstiaGoUITests: XCTestCase {
    
    private var app: XCUIApplication!
    private let screenshotDir = "/tmp/UstiaGoScreenshots"
    // Tab bar button labels match the tabItem Label text
    private let tabLabels = ["Today", "Focus", "Insights", "Wind Down", "Settings"]
    
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
        
        // Tap each tab by button label
        for index in 1..<tabLabels.count {
            let btn = app.buttons[tabLabels[index]].firstMatch
            if btn.exists && btn.isHittable {
                btn.tap()
                Thread.sleep(forTimeInterval: 2)
                takeScreenshot(named: "Screen\(index + 1)_\(tabLabels[index])")
            } else {
                print("Button '\(tabLabels[index])' not hittable, trying coordinate fallback")
                // Coordinate fallback
                let win = app.windows.firstMatch
                let frame = win.frame
                let tabBarH: CGFloat = 83
                let yCenter = frame.height - tabBarH / 2
                let tabW = frame.width / 5
                let xCenter = tabW * (CGFloat(index) + 0.5)
                let coord = win.coordinate(withNormalizedOffset: .zero)
                    .withOffset(CGVector(dx: xCenter, dy: yCenter))
                coord.tap()
                Thread.sleep(forTimeInterval: 2)
                takeScreenshot(named: "Screen\(index + 1)_\(tabLabels[index])")
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
