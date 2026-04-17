import SwiftUI

struct WindDownView: View {
    @EnvironmentObject var appState: AppState
    @State private var windDownSession = WindDownSession()
    
    private var currentHour: Int {
        Calendar.current.component(.hour, from: Date())
    }
    
    private var windDownStart: Int {
        appState.settings.windDownStartHour
    }
    
    private var isWindDownTime: Bool {
        currentHour >= windDownStart
    }
    
    private var timeUntilWindDown: String {
        if isWindDownTime { return "Now" }
        let diff = windDownStart - currentHour
        return "\(diff)h"
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Image(systemName: "moon.stars.fill")
                        .font(.system(size: 40))
                        .foregroundColor(UstiaTheme.accentPrimary)
                    
                    Text("Wind Down")
                        .font(.clarityTitle)
                        .foregroundColor(UstiaTheme.textPrimary)
                    
                    Text("Prepare for restful sleep")
                        .font(.clarityCaption)
                        .foregroundColor(UstiaTheme.textTertiary)
                }
                .padding(.top, 8)
                
                // Wind Down Timer
                VStack(spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Starts at")
                                .font(.clarityCaption)
                                .foregroundColor(UstiaTheme.textTertiary)
                            Text("\(windDownStart):00")
                                .font(.clarityHeadline)
                                .foregroundColor(UstiaTheme.textPrimary)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 4) {
                            Text(timeUntilWindDown)
                                .font(.clarityHeadline)
                                .foregroundColor(isWindDownTime ? UstiaTheme.accentSecondary : UstiaTheme.textSecondary)
                            Text(isWindDownTime ? "Right now!" : "from now")
                                .font(.clarityCaption)
                                .foregroundColor(UstiaTheme.textTertiary)
                        }
                    }
                    
                    // Progress arc
                    ZStack {
                        Circle()
                            .stroke(UstiaTheme.surface, lineWidth: 8)
                            .frame(width: 120, height: 120)
                        
                        Circle()
                            .trim(from: 0, to: windDownProgress)
                            .stroke(
                                UstiaTheme.accentPrimary,
                                style: StrokeStyle(lineWidth: 8, lineCap: .round)
                            )
                            .frame(width: 120, height: 120)
                            .rotationEffect(.degrees(-90))
                        
                        VStack(spacing: 2) {
                            Image(systemName: isWindDownTime ? "moon.fill" : "sunset.fill")
                                .font(.system(size: 24))
                                .foregroundColor(isWindDownTime ? UstiaTheme.accentPrimary : UstiaTheme.accentWarm)
                            Text(isWindDownTime ? "ON" : "SOON")
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundColor(UstiaTheme.textTertiary)
                        }
                    }
                }
                .padding(20)
                .clarityCard()
                
                // Activities
                VStack(alignment: .leading, spacing: 16) {
                    Text("Tonight's Activities")
                        .font(.clarityHeadline)
                        .foregroundColor(UstiaTheme.textPrimary)
                    
                    ForEach(windDownSession.activities) { activity in
                        WindDownActivityRow(activity: activity) { completed in
                            if let idx = windDownSession.activities.firstIndex(where: { $0.id == activity.id }) {
                                windDownSession.activities[idx].completed = completed
                            }
                        }
                    }
                }
                
                // Tips
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "lightbulb.fill")
                            .foregroundColor(UstiaTheme.accentWarm)
                        Text("Sleep Tip")
                            .font(.claritySubheadline)
                            .foregroundColor(UstiaTheme.textSecondary)
                    }
                    
                    Text(sleepTip)
                        .font(.clarityBody)
                        .foregroundColor(UstiaTheme.textPrimary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(UstiaTheme.accentWarm.opacity(0.1))
                .cornerRadius(20)
                
                // Tomorrow's Preview
                VStack(alignment: .leading, spacing: 12) {
                    Text("Tomorrow's Focus")
                        .font(.claritySubheadline)
                        .foregroundColor(UstiaTheme.textSecondary)
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Goal")
                                .font(.clarityCaption)
                                .foregroundColor(UstiaTheme.textTertiary)
                            Text("\(appState.settings.dailyFocusGoal) minutes")
                                .font(.clarityHeadline)
                                .foregroundColor(UstiaTheme.accentPrimary)
                        }
                        Spacer()
                        Image(systemName: "target")
                            .font(.system(size: 28))
                            .foregroundColor(UstiaTheme.accentPrimary.opacity(0.5))
                    }
                }
                .padding(20)
                .background(UstiaTheme.bgSecondary)
                .cornerRadius(20)
                
                Spacer(minLength: 80)
            }
            .padding(.horizontal, 20)
        }
    }
    
    private var windDownProgress: Double {
        let start = Double(windDownStart - 3)
        let end = Double(windDownStart)
        let now = Double(currentHour)
        return max(0, min(1, (now - start) / (end - start)))
    }
    
    private var sleepTip: String {
        let tips = [
            "Keep your bedroom cool (65-68°F) for optimal sleep quality.",
            "Avoid screens 1 hour before bed — blue light suppresses melatonin.",
            "A consistent sleep schedule trains your body's internal clock.",
            "Caffeine has a half-life of 6 hours — no coffee after 2 PM.",
            "Light stretching before bed reduces cortisol and promotes relaxation.",
            "Journaling for 5 minutes clears your mind of tomorrow's worries."
        ]
        return tips.randomElement() ?? tips[0]
    }
}

// MARK: - Wind Down Activity Row

struct WindDownActivityRow: View {
    let activity: WindDownActivity
    let onToggle: (Bool) -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(activity.completed ? UstiaTheme.success.opacity(0.2) : UstiaTheme.surface)
                    .frame(width: 48, height: 48)
                
                Image(systemName: activity.type.icon)
                    .font(.system(size: 20))
                    .foregroundColor(activity.completed ? UstiaTheme.success : UstiaTheme.textSecondary)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(activity.type.rawValue)
                    .font(.claritySubheadline)
                    .foregroundColor(UstiaTheme.textPrimary)
                
                Text(activity.type.description)
                    .font(.clarityCaption)
                    .foregroundColor(UstiaTheme.textTertiary)
            }
            
            Spacer()
            
            Button {
                onToggle(!activity.completed)
            } label: {
                Image(systemName: activity.completed ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(activity.completed ? UstiaTheme.success : UstiaTheme.textTertiary)
            }
        }
        .padding(16)
        .background(UstiaTheme.bgSecondary)
        .cornerRadius(16)
    }
}

#Preview {
    WindDownView()
        .environmentObject(AppState())
        .preferredColorScheme(.dark)
}
