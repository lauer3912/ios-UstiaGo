import XCTest

final class ProbeCoords: XCTestCase {
    
    private var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = true
        app = XCUIApplication()
        app.launch()
        Thread.sleep(forTimeInterval: 3)
    }
    
    func testProbeCoordinates() {
        let win = app.windows.firstMatch
        let frame = win.frame
        print("Window frame: \(frame)")
        
        // Try to find any buttons anywhere
        let allBtns = app.descendants(matching: .button)
        print("Total buttons found: \(allBtns.count)")
        
        // Try tabBars.buttons by string label
        let tabNames = ["Today", "Focus", "Insights", "Wind Down", "Settings"]
        for name in tabNames {
            let found = app.buttons[name].exists
            print("Button['\(name)'] exists: \(found)")
        }
        
        // Try collection views
        let colz = app.descendants(matching: .collectionView)
        print("Collection views: \(colz.count)")
        
        // Try other elements
        let imgs = app.descendants(matching: .image)
        print("Images: \(imgs.count)")
        
        // Try to find tab-like elements
        let tabs = app.descendants(matching: .tabGroup)
        print("Tab groups: \(tabs.count)")
        
        // Take screenshot
        let ss = XCTAttachment(screenshot: app.windows.firstMatch.screenshot())
        ss.name = "ProbeCoords"
        ss.lifetime = .keepAlways
        add(ss)
        
        let data = app.windows.firstMatch.screenshot().pngRepresentation
        try? data.write(to: URL(fileURLWithPath: "/tmp/ProbeCoords.png"))
        print("Screenshot saved")
    }
}
