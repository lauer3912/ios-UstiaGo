import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Profile Header
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(ClarityTheme.gradientPrimary)
                            .frame(width: 80, height: 80)
                        Image(systemName: "brain.head.profile")
                            .font(.system(size: 36))
                            .foregroundColor(.white)
                    }
                    
                    Text("Clarity")
                        .font(.clarityTitle)
                        .foregroundColor(ClarityTheme.textPrimary)
                    
                    if !appState.isPremium {
                        Button {
                            appState.isPremium = true
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "crown.fill")
                                    .font(.system(size: 14))
                                Text("Upgrade to Premium")
                            }
                            .font(.claritySubheadline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(ClarityTheme.gradientPrimary)
                            .cornerRadius(20)
                        }
                    } else {
                        HStack(spacing: 6) {
                            Image(systemName: "crown.fill")
                                .foregroundColor(ClarityTheme.accentWarm)
                            Text("Premium Active")
                                .foregroundColor(ClarityTheme.accentWarm)
                        }
                        .font(.clarityCaption)
                    }
                }
                .padding(.top, 8)
                
                // Goals Section
                SettingsSection(title: "Goals") {
                    SettingsSliderRow(
                        icon: "rectangle.portrait",
                        iconColor: ClarityTheme.accentPrimary,
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
                        iconColor: ClarityTheme.accentSecondary,
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
                        iconColor: ClarityTheme.accentPrimary,
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
                        iconColor: ClarityTheme.accentWarm,
                        title: "Session Reminders",
                        subtitle: "Remind to start focus sessions",
                        value: $appState.settings.notificationsEnabled
                    )
                }
                
                // Data Section
                SettingsSection(title: "Data") {
                    SettingsActionRow(
                        icon: "square.and.arrow.up",
                        iconColor: ClarityTheme.accentSecondary,
                        title: "Export Data",
                        subtitle: "Download your focus history as CSV"
                    ) {
                        exportData()
                    }
                    
                    SettingsActionRow(
                        icon: "arrow.clockwise",
                        iconColor: ClarityTheme.textSecondary,
                        title: "Reset All Data",
                        subtitle: "Clear all sessions and achievements"
                    ) {
                        // Would show confirmation dialog
                    }
                }
                
                // About Section
                SettingsSection(title: "About") {
                    SettingsInfoRow(
                        icon: "info.circle",
                        iconColor: ClarityTheme.textSecondary,
                        title: "Version",
                        value: "1.0.0"
                    )
                    
                    SettingsActionRow(
                        icon: "doc.text",
                        iconColor: ClarityTheme.textSecondary,
                        title: "Privacy Policy",
                        subtitle: "Your data stays on your device"
                    ) {
                        // Open privacy policy
                    }
                    
                    SettingsActionRow(
                        icon: "envelope",
                        iconColor: ClarityTheme.textSecondary,
                        title: "Contact Support",
                        subtitle: "help@clarity.app"
                    ) {
                        // Open email
                    }
                }
                
                // Mac Companion
                SettingsSection(title: "Mac Companion") {
                    HStack(spacing: 16) {
                        Image(systemName: "laptopcomputer")
                            .font(.system(size: 24))
                            .foregroundColor(ClarityTheme.accentPrimary)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Connect Mac")
                                .font(.claritySubheadline)
                                .foregroundColor(ClarityTheme.textPrimary)
                            Text("Control focus blocking from your iPhone")
                                .font(.clarityCaption)
                                .foregroundColor(ClarityTheme.textTertiary)
                        }
                        
                        Spacer()
                        
                        Button {
                            // Initiate pairing
                        } label: {
                            Text("Connect")
                                .font(.clarityCaption)
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(ClarityTheme.accentPrimary)
                                .cornerRadius(12)
                        }
                    }
                    .padding(16)
                    .background(ClarityTheme.bgSecondary)
                    .cornerRadius(16)
                }
                
                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
        }
    }
    
    private func exportData() {
        // Generate CSV
        var csv = "Date,Mode,Duration (min),Completed\n"
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        
        for session in appState.sessions {
            csv += "\(formatter.string(from: session.startTime)),\(session.modeName),\(session.duration/60),\(session.completed)\n"
        }
        
        // Would save to Files app
        print("CSV Export:\n\(csv)")
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
                .foregroundColor(ClarityTheme.textSecondary)
            
            VStack(spacing: 0) {
                content
            }
            .background(ClarityTheme.bgSecondary)
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
                    .foregroundColor(ClarityTheme.textPrimary)
                Text(subtitle)
                    .font(.clarityCaption)
                    .foregroundColor(ClarityTheme.textTertiary)
            }
            
            Spacer()
            
            Toggle("", isOn: $value)
                .tint(ClarityTheme.accentPrimary)
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
                        .foregroundColor(ClarityTheme.textPrimary)
                    Text(subtitle)
                        .font(.clarityCaption)
                        .foregroundColor(ClarityTheme.textTertiary)
                }
                
                Spacer()
                
                Text("\(Int(value))\(unit)")
                    .font(.clarityMonoSmall)
                    .foregroundColor(ClarityTheme.accentPrimary)
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
                        .foregroundColor(ClarityTheme.textPrimary)
                    Text(subtitle)
                        .font(.clarityCaption)
                        .foregroundColor(ClarityTheme.textTertiary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(ClarityTheme.textTertiary)
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
                .foregroundColor(ClarityTheme.textPrimary)
            
            Spacer()
            
            Text(value)
                .font(.clarityCaption)
                .foregroundColor(ClarityTheme.textTertiary)
        }
        .padding(16)
    }
}

#Preview {
    SettingsView()
        .environmentObject(AppState())
        .preferredColorScheme(.dark)
}
