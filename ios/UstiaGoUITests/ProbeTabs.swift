import XCTest

final class ProbeTabs: XCTestCase {
    
    private var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = true
        app = XCUIApplication()
        app.launch()
        Thread.sleep(forTimeInterval: 3)
    }
    
    func testProbeTabBars() {
        let tabBar = app.tabBars.firstMatch
        print("=== TAB BAR INFO ===")
        print("Exists: \(tabBar.exists)")
        print("Buttons count: \(tabBar.buttons.count)")
        
        for i in 0..<tabBar.buttons.count {
            let btn = tabBar.buttons.element(boundBy: i)
            print("Button[\(i)]: label='\(btn.label)' identifier='\(btn.identifier)' exists=\(btn.exists)")
        }
        
        print("=== ALL TAB BAR BUTTONS (by identifier) ===")
        for btn in app.tabBars.buttons.allElementsBoundByIndex {
            print("  label='\(btn.label)' identifier='\(btn.identifier)'")
        }
        
        // Take a screenshot for reference
        let ss = XCTAttachment(screenshot: app.windows.firstMatch.screenshot())
        ss.name = "Probe_iPad"
        ss.lifetime = .keepAlways
        add(ss)
        
        let data = app.windows.firstMatch.screenshot().pngRepresentation
        try? data.write(to: URL(fileURLWithPath: "/tmp/Probe_iPad.png"))
    }
}
