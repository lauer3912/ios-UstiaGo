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
                .onAppear {
                    // Request notification authorization on first launch
                    if UserDefaults.standard.bool(forKey: "notifications_requested") == false {
                        UstiaNotificationService.shared.requestAuthorization { granted in
                            UserDefaults.standard.set(true, forKey: "notifications_requested")
                            print("Notifications authorized: \(granted)")
                        }
                    }
                }
        }
    }
}
