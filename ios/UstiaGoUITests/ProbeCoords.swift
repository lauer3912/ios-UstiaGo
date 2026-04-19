import XCTest

final class ProbeTabs2: XCTestCase {
    
    private var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = true
        app = XCUIApplication()
        app.launch()
        Thread.sleep(forTimeInterval: 3)
    }
    
    func testProbeTabPositions() {
        let win = app.windows.firstMatch
        let frame = win.frame
        print("Window: \(frame.width)x\(frame.height)")
        
        // Take screenshot first
        let ss = XCTAttachment(screenshot: win.screenshot())
        ss.name = "ProbeTabs2"; ss.lifetime = .keepAlways; add(ss)
        try? win.screenshot().pngRepresentation.write(to: URL(fileURLWithPath: "/tmp/ProbeTabs2.png"))
        
        // Try to find and tap each tab by accessibility
        let tabNames = ["Today", "Focus", "Insights", "Wind Down", "Settings"]
        for (i, name) in tabNames.enumerated() {
            let btn = app.buttons[name].firstMatch
            print("Tab[\(i)]='\(name)': exists=\(btn.exists), hittable=\(btn.isHittable)")
            if btn.exists {
                // Try tap and see what happens
                let coord = btn.coordinate(withNormalizedOffset: .zero)
                print("  coordinate: \(coord)")
            }
        }
        
        // Also try via tab bars
        let tabBar = app.tabBars.firstMatch
        print("TabBar exists: \(tabBar.exists)")
        print("TabBar buttons: \(tabBar.buttons.count)")
    }
}
