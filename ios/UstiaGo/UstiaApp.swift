import SwiftUI

@main
struct UstiaApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var soundManager = UstiaSoundManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .environmentObject(soundManager)
                .preferredColorScheme(.dark)
        }
    }
}
