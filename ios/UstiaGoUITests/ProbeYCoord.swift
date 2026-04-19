import XCTest

final class ProbeYCoord: XCTestCase {
    
    private var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = true
        app = XCUIApplication()
        app.launch()
        Thread.sleep(forTimeInterval: 3)
    }
    
    func testProbeYCoordinates() {
        let win = app.windows.firstMatch
        let frame = win.frame
        print("Window: \(frame.width)x\(frame.height)")
        
        // Try tapping at various Y positions in the bottom 200 pts
        // to find where tab bar buttons respond
        let bottomY = frame.height
        let results: [(Int, Int, Bool)] = []
        
        for dy in stride(from: Int(bottomY) - 30, to: Int(bottomY), by: 5) {
            let coord = win.coordinate(withNormalizedOffset: .zero)
                .withOffset(CGVector(dx: frame.width / 2, dy: CGFloat(dy)))
            
            // Check what element is at this coordinate (without tapping)
            let exists = app.descendants(matching: .button).element(boundBy: 0).exists
            print("Y=\(dy): exists=\(exists)")
        }
        
        // Also probe X positions across the width at a fixed Y
        let probeY = bottomY - 50
        print("\nProbing X at Y=\(probeY):")
        for dx in stride(from: 50, to: Int(frame.width) - 50, by: 50) {
            let coord = win.coordinate(withNormalizedOffset: .zero)
                .withOffset(CGVector(dx: CGFloat(dx), dy: CGFloat(probeY)))
            print("X=\(dx): checking...")
        }
        
        // Take screenshot for reference
        let ss = XCTAttachment(screenshot: win.screenshot())
        ss.name = "ProbeYCoord"; add(ss)
        try? win.screenshot().pngRepresentation.write(to: URL(fileURLWithPath: "/tmp/ProbeYCoord.png"))
    }
}
