import XCTest

final class UstiaGoUITests: XCTestCase {
    
    private var app: XCUIApplication!
    private let screenshotDir = "/tmp/UstiaGoScreenshots"
    
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
        let win = app.windows.firstMatch
        let frame = win.frame
        print("Window frame: \(frame.width)x\(frame.height)")
        
        // Screenshot initial screen (Today)
        takeScreenshot(named: "Screen1_Today")
        
        // Tab bar is at bottom of screen
        // For iPad (1032x1376): tab bar height ~83pts, centered at y=1335
        // For iPhone (430x932): tab bar height ~83pts, centered at y=889
        // 5 tabs evenly distributed
        let tabBarHeight: CGFloat = 83
        let tabBarY = frame.height - tabBarHeight
        let tabBarCenterY = tabBarY + tabBarHeight / 2
        let tabWidth = frame.width / 5
        
        print("Tab bar: y=\(tabBarY), centerY=\(tabBarCenterY), tabWidth=\(tabWidth)")
        
        for index in 1..<5 {
            let tabCenterX = tabWidth * (CGFloat(index) + 0.5)
            let coord = win.coordinate(withNormalizedOffset: .zero)
                .withOffset(CGVector(dx: tabCenterX, dy: tabBarCenterY))
            
            print("Tapping tab[\(index)] at (\(tabCenterX), \(tabBarCenterY))")
            coord.tap()
            Thread.sleep(forTimeInterval: 2)
            takeScreenshot(named: "Screen\(index + 1)_Tab\(index)")
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
