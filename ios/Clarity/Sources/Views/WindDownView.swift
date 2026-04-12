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
                        .foregroundColor(ClarityTheme.accentPrimary)
                    
                    Text("Wind Down")
                        .font(.clarityTitle)
                        .foregroundColor(ClarityTheme.textPrimary)
                    
                    Text("Prepare for restful sleep")
                        .font(.clarityCaption)
                        .foregroundColor(ClarityTheme.textTertiary)
                }
                .padding(.top, 8)
                
                // Wind Down Timer
                VStack(spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Starts at")
                                .font(.clarityCaption)
                                .foregroundColor(ClarityTheme.textTertiary)
                            Text("\(windDownStart):00")
                                .font(.clarityHeadline)
                                .foregroundColor(ClarityTheme.textPrimary)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 4) {
                            Text(timeUntilWindDown)
                                .font(.clarityHeadline)
                                .foregroundColor(isWindDownTime ? ClarityTheme.accentSecondary : ClarityTheme.textSecondary)
                            Text(isWindDownTime ? "Right now!" : "from now")
                                .font(.clarityCaption)
                                .foregroundColor(ClarityTheme.textTertiary)
                        }
                    }
                    
                    // Progress arc
                    ZStack {
                        Circle()
                            .stroke(ClarityTheme.surface, lineWidth: 8)
                            .frame(width: 120, height: 120)
                        
                        Circle()
                            .trim(from: 0, to: windDownProgress)
                            .stroke(
                                ClarityTheme.accentPrimary,
                                style: StrokeStyle(lineWidth: 8, lineCap: .round)
                            )
                            .frame(width: 120, height: 120)
                            .rotationEffect(.degrees(-90))
                        
                        VStack(spacing: 2) {
                            Image(systemName: isWindDownTime ? "moon.fill" : "sunset.fill")
                                .font(.system(size: 24))
                                .foregroundColor(isWindDownTime ? ClarityTheme.accentPrimary : ClarityTheme.accentWarm)
                            Text(isWindDownTime ? "ON" : "SOON")
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundColor(ClarityTheme.textTertiary)
                        }
                    }
                }
                .padding(20)
                .clarityCard()
                
                // Activities
                VStack(alignment: .leading, spacing: 16) {
                    Text("Tonight's Activities")
                        .font(.clarityHeadline)
                        .foregroundColor(ClarityTheme.textPrimary)
                    
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
                            .foregroundColor(ClarityTheme.accentWarm)
                        Text("Sleep Tip")
                            .font(.claritySubheadline)
                            .foregroundColor(ClarityTheme.textSecondary)
                    }
                    
                    Text(sleepTip)
                        .font(.clarityBody)
                        .foregroundColor(ClarityTheme.textPrimary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(ClarityTheme.accentWarm.opacity(0.1))
                .cornerRadius(20)
                
                // Tomorrow's Preview
                VStack(alignment: .leading, spacing: 12) {
                    Text("Tomorrow's Focus")
                        .font(.claritySubheadline)
                        .foregroundColor(ClarityTheme.textSecondary)
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Goal")
                                .font(.clarityCaption)
                                .foregroundColor(ClarityTheme.textTertiary)
                            Text("\(appState.settings.dailyFocusGoal) minutes")
                                .font(.clarityHeadline)
                                .foregroundColor(ClarityTheme.accentPrimary)
                        }
                        Spacer()
                        Image(systemName: "target")
                            .font(.system(size: 28))
                            .foregroundColor(ClarityTheme.accentPrimary.opacity(0.5))
                    }
                }
                .padding(20)
                .background(ClarityTheme.bgSecondary)
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
                    .fill(activity.completed ? ClarityTheme.success.opacity(0.2) : ClarityTheme.surface)
                    .frame(width: 48, height: 48)
                
                Image(systemName: activity.type.icon)
                    .font(.system(size: 20))
                    .foregroundColor(activity.completed ? ClarityTheme.success : ClarityTheme.textSecondary)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(activity.type.rawValue)
                    .font(.claritySubheadline)
                    .foregroundColor(ClarityTheme.textPrimary)
                
                Text(activity.type.description)
                    .font(.clarityCaption)
                    .foregroundColor(ClarityTheme.textTertiary)
            }
            
            Spacer()
            
            Button {
                onToggle(!activity.completed)
            } label: {
                Image(systemName: activity.completed ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(activity.completed ? ClarityTheme.success : ClarityTheme.textTertiary)
            }
        }
        .padding(16)
        .background(ClarityTheme.bgSecondary)
        .cornerRadius(16)
    }
}

#Preview {
    WindDownView()
        .environmentObject(AppState())
        .preferredColorScheme(.dark)
}
