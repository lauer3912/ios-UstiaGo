import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack {
            UstiaTheme.bgPrimary.ignoresSafeArea()
            TabView(selection: $appState.selectedTab) {
                TodayView()
                    .tabItem {
                        Label(AppState.Tab.today.rawValue, systemImage: AppState.Tab.today.icon)
                    }
                    .tag(AppState.Tab.today)
                    .accessibilityIdentifier("tab_today")
                    .accessibilityLabel(AppState.Tab.today.rawValue)
                
                FocusView()
                    .tabItem {
                        Label(AppState.Tab.focus.rawValue, systemImage: AppState.Tab.focus.icon)
                    }
                    .tag(AppState.Tab.focus)
                    .accessibilityIdentifier("tab_focus")
                    .accessibilityLabel(AppState.Tab.focus.rawValue)
                
                InsightsView()
                    .tabItem {
                        Label(AppState.Tab.insights.rawValue, systemImage: AppState.Tab.insights.icon)
                    }
                    .tag(AppState.Tab.insights)
                    .accessibilityIdentifier("tab_insights")
                    .accessibilityLabel(AppState.Tab.insights.rawValue)
                
                WindDownView()
                    .tabItem {
                        Label(AppState.Tab.windDown.rawValue, systemImage: AppState.Tab.windDown.icon)
                    }
                    .tag(AppState.Tab.windDown)
                    .accessibilityIdentifier("tab_winddown")
                    .accessibilityLabel(AppState.Tab.windDown.rawValue)
                
                SettingsView()
                    .tabItem {
                        Label(AppState.Tab.settings.rawValue, systemImage: AppState.Tab.settings.icon)
                    }
                    .tag(AppState.Tab.settings)
                    .accessibilityIdentifier("tab_settings")
                    .accessibilityLabel(AppState.Tab.settings.rawValue)
            }
            .tint(UstiaTheme.accentPrimary)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
