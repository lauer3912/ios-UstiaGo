import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack {
            ClarityTheme.bgPrimary.ignoresSafeArea()
            TabView(selection: $appState.selectedTab) {
                TodayView()
                    .tabItem {
                        Label(AppState.Tab.today.rawValue, systemImage: AppState.Tab.today.icon)
                    }
                    .tag(AppState.Tab.today)
                
                FocusView()
                    .tabItem {
                        Label(AppState.Tab.focus.rawValue, systemImage: AppState.Tab.focus.icon)
                    }
                    .tag(AppState.Tab.focus)
                
                InsightsView()
                    .tabItem {
                        Label(AppState.Tab.insights.rawValue, systemImage: AppState.Tab.insights.icon)
                    }
                    .tag(AppState.Tab.insights)
                
                WindDownView()
                    .tabItem {
                        Label(AppState.Tab.windDown.rawValue, systemImage: AppState.Tab.windDown.icon)
                    }
                    .tag(AppState.Tab.windDown)
                
                SettingsView()
                    .tabItem {
                        Label(AppState.Tab.settings.rawValue, systemImage: AppState.Tab.settings.icon)
                    }
                    .tag(AppState.Tab.settings)
            }
            .tint(ClarityTheme.accentPrimary)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
