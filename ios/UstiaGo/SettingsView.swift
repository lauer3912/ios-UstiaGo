import SwiftUI
import UserNotifications

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @State private var showResetAlert = false
    @State private var showExportSheet = false
    @State private var exportedCSV: String = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Profile Header
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(UstiaTheme.gradientPrimary)
                            .frame(width: 80, height: 80)
                        Image(systemName: "brain.head.profile")
                            .font(.system(size: 36))
                            .foregroundColor(.white)
                    }
                    
                    Text("Clarity")
                        .font(.clarityTitle)
                        .foregroundColor(UstiaTheme.textPrimary)
                    
                    // Premium badge shown only when active
                    if appState.isPremium {
                        HStack(spacing: 6) {
                            Image(systemName: "crown.fill")
                                .foregroundColor(UstiaTheme.accentWarm)
                            Text("Premium Active")
                                .foregroundColor(UstiaTheme.accentWarm)
                        }
                        .font(.clarityCaption)
                    }
                }
                .padding(.top, 8)
                
                // Goals Section
                SettingsSection(title: "Goals") {
                    SettingsSliderRow(
                        icon: "rectangle.portrait",
                        iconColor: UstiaTheme.accentPrimary,
                        title: "Daily Screen Goal",
                        subtitle: "Target screen time per day",
                        value: Binding(
                            get: { Double(appState.settings.dailyScreenGoal) },
                            set: { appState.settings.dailyScreenGoal = Int($0) }
                        ),
                        range: 30...480,
                        step: 30,
                        unit: "min"
                    )
                    
                    SettingsSliderRow(
                        icon: "brain.head.profile",
                        iconColor: UstiaTheme.accentSecondary,
                        title: "Daily Focus Goal",
                        subtitle: "Target focus time per day",
                        value: Binding(
                            get: { Double(appState.settings.dailyFocusGoal) },
                            set: { appState.settings.dailyFocusGoal = Int($0) }
                        ),
                        range: 15...180,
                        step: 15,
                        unit: "min"
                    )
                }
                
                // Wind Down Section
                SettingsSection(title: "Wind Down") {
                    SettingsSliderRow(
                        icon: "moon.fill",
                        iconColor: UstiaTheme.accentPrimary,
                        title: "Start Time",
                        subtitle: "When wind down begins",
                        value: Binding(
                            get: { Double(appState.settings.windDownStartHour) },
                            set: { appState.settings.windDownStartHour = Int($0) }
                        ),
                        range: 18...23,
                        step: 1,
                        unit: ":00"
                    )
                }
                
                // Notifications Section
                SettingsSection(title: "Notifications") {
                    SettingsToggleRow(
                        icon: "bell.fill",
                        iconColor: UstiaTheme.accentWarm,
                        title: "Session Reminders",
                        subtitle: "Remind to start focus sessions",
                        value: $appState.settings.notificationsEnabled
                    )
                    .onChange(of: appState.settings.notificationsEnabled) { _, newValue in
                        if newValue {
                            requestNotificationPermission()
                        }
                    }
                }
                
                // Data Section
                SettingsSection(title: "Data") {
                    SettingsActionRow(
                        icon: "square.and.arrow.up",
                        iconColor: UstiaTheme.accentSecondary,
                        title: "Export Data",
                        subtitle: "Download your focus history as CSV"
                    ) {
                        exportData()
                    }
                    
                    SettingsActionRow(
                        icon: "arrow.clockwise",
                        iconColor: UstiaTheme.textSecondary,
                        title: "Reset All Data",
                        subtitle: "Clear all sessions and achievements"
                    ) {
                        showResetAlert = true
                    }
                }
                
                // About Section
                SettingsSection(title: "About") {
                    SettingsInfoRow(
                        icon: "info.circle",
                        iconColor: UstiaTheme.textSecondary,
                        title: "Version",
                        value: "1.0.0"
                    )
                    
                    SettingsActionRow(
                        icon: "doc.text",
                        iconColor: UstiaTheme.textSecondary,
                        title: "Privacy Policy",
                        subtitle: "lauer3912.github.io/ios-UstiaGo"
                    ) {
                        if let url = URL(string: "https://lauer3912.github.io/ios-UstiaGo/docs/PrivacyPolicy.html") {
                            UIApplication.shared.open(url)
                        }
                    }
                    
                    SettingsActionRow(
                        icon: "envelope",
                        iconColor: UstiaTheme.textSecondary,
                        title: "Contact Support",
                        subtitle: "lauer3912@qq.com"
                    ) {
                        if let url = URL(string: "mailto:lauer3912@qq.com?subject=UstiaGo%20Support") {
                            UIApplication.shared.open(url)
                        }
                    }
                }
                
                // Health Data Section
                SettingsSection(title: "Health Data") {
                    HStack(spacing: 16) {
                        Image(systemName: "heart.text.square.fill")
                            .font(.system(size: 20))
                            .foregroundColor(UstiaTheme.accentPrimary)
                            .frame(width: 32)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("HealthKit Integration")
                                .font(.claritySubheadline)
                                .foregroundColor(UstiaTheme.textPrimary)
                            Text("UstiaGo reads and writes focus activity data to Apple Health to help track your overall wellness.")
                                .font(.clarityCaption)
                                .foregroundColor(UstiaTheme.textTertiary)
                        }
                    }
                    .padding(16)
                }
                

            }
            .padding(.horizontal, 20)
        }
        .alert("Reset All Data?", isPresented: $showResetAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                appState.resetAllData()
            }
        } message: {
            Text("This will permanently delete all your sessions, achievements, and settings. This action cannot be undone.")
        }
        .sheet(isPresented: $showExportSheet) {
            ExportDataSheet(csv: exportedCSV)
        }
    }
    
    private func exportData() {
        var csv = "Date,Mode,Duration (min),Completed\n"
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        
        for session in appState.sessions {
            csv += "\(formatter.string(from: session.startTime)),\(session.modeName),\(session.duration/60),\(session.completed)\n"
        }
        
        exportedCSV = csv.isEmpty ? "No sessions to export." : csv
        showExportSheet = true
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            if !granted {
                DispatchQueue.main.async {
                    appState.settings.notificationsEnabled = false
                }
            }
        }
    }
}

// MARK: - Settings Section

struct SettingsSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.claritySubheadline)
                .foregroundColor(UstiaTheme.textSecondary)
            
            VStack(spacing: 0) {
                content
            }
            .background(UstiaTheme.bgSecondary)
            .cornerRadius(16)
        }
    }
}

// MARK: - Settings Row Types

struct SettingsToggleRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    @Binding var value: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(iconColor)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.claritySubheadline)
                    .foregroundColor(UstiaTheme.textPrimary)
                Text(subtitle)
                    .font(.clarityCaption)
                    .foregroundColor(UstiaTheme.textTertiary)
            }
            
            Spacer()
            
            Toggle("", isOn: $value)
                .tint(UstiaTheme.accentPrimary)
                .labelsHidden()
        }
        .padding(16)
    }
}

struct SettingsSliderRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double
    let unit: String
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(iconColor)
                    .frame(width: 32)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.claritySubheadline)
                        .foregroundColor(UstiaTheme.textPrimary)
                    Text(subtitle)
                        .font(.clarityCaption)
                        .foregroundColor(UstiaTheme.textTertiary)
                }
                
                Spacer()
                
                Text("\(Int(value))\(unit)")
                    .font(.clarityMonoSmall)
                    .foregroundColor(UstiaTheme.accentPrimary)
            }
            
            Slider(value: $value, in: range, step: step)
                .tint(iconColor)
        }
        .padding(16)
    }
}

struct SettingsActionRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(iconColor)
                    .frame(width: 32)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.claritySubheadline)
                        .foregroundColor(UstiaTheme.textPrimary)
                    Text(subtitle)
                        .font(.clarityCaption)
                        .foregroundColor(UstiaTheme.textTertiary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(UstiaTheme.textTertiary)
            }
            .padding(16)
        }
    }
}

struct SettingsInfoRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(iconColor)
                .frame(width: 32)
            
            Text(title)
                .font(.claritySubheadline)
                .foregroundColor(UstiaTheme.textPrimary)
            
            Spacer()
            
            Text(value)
                .font(.clarityCaption)
                .foregroundColor(UstiaTheme.textTertiary)
        }
        .padding(16)
    }
}

struct ExportDataSheet: View {
    let csv: String
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Focus History Export")
                    .font(.clarityHeadline)
                    .foregroundColor(UstiaTheme.textPrimary)
                
                ScrollView {
                    Text(csv)
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(UstiaTheme.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                }
                .background(UstiaTheme.bgSecondary)
                .cornerRadius(12)
                
                ShareLink(item: csv) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        Text("Share CSV")
                    }
                    .frame(maxWidth: .infinity)
                    .clarityButton(isPrimary: true)
                }
                
                Button("Close") {
                    dismiss()
                }
                .foregroundColor(UstiaTheme.textSecondary)
            }
            .padding(20)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}

#Preview {
    SettingsView()
        .environmentObject(AppState())
        .preferredColorScheme(.dark)
}
