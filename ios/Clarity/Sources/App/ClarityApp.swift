import SwiftUI

@main
struct ClarityApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var soundManager = ClaritySoundManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .environmentObject(soundManager)
                .preferredColorScheme(.dark)
        }
    }
}
