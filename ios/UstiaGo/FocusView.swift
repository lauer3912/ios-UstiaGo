import SwiftUI

struct FocusView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedMode: FocusMode?
    @State private var isTimerActive = false
    @State private var isBreakTime = false
    @State private var remainingSeconds = 0
    @State private var totalSeconds = 0
    @State private var timer: Timer?
    @State private var showingModeSelector = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                if appState.currentSession == nil && !isTimerActive {
                    // Mode selection
                    VStack(spacing: 16) {
                        Text("Choose Your Mode")
                            .font(.clarityHeadline)
                            .foregroundColor(UstiaTheme.textPrimary)
                        
                        ForEach(appState.focusModes) { mode in
                            FocusModeRow(mode: mode, selected: selectedMode?.id == mode.id) {
                                selectedMode = mode
                            }
                        }
                        
                        Button {
                            if let mode = selectedMode ?? appState.focusModes.first {
                                startSession(mode: mode)
                            }
                        } label: {
                            HStack {
                                Image(systemName: "play.fill")
                                Text("Start Focus")
                            }
                            .frame(maxWidth: .infinity)
                            .clarityButton(isPrimary: true)
                        }
                        .disabled(selectedMode == nil && appState.focusModes.isEmpty)
                        .opacity(selectedMode == nil && appState.focusModes.isEmpty ? 0.5 : 1)
                    }
                } else {
                    // Timer Active
                    TimerActiveView(
                        modeName: appState.currentSession?.modeName ?? selectedMode?.name ?? "",
                        modeColorHex: appState.currentSession?.modeColorHex ?? selectedMode?.colorHex ?? "#7C6AFF",
                        remainingSeconds: remainingSeconds,
                        totalSeconds: totalSeconds,
                        isBreak: isBreakTime,
                        onPause: pauseTimer,
                        onStop: stopTimer
                    )
                }
                
                // Sound Selector
                VStack(alignment: .leading, spacing: 12) {
                    Text("Ambient Sound")
                        .font(.claritySubheadline)
                        .foregroundColor(UstiaTheme.textSecondary)
                    
                    AmbientSoundGrid()
                }
                
                // Recent Sessions
                VStack(alignment: .leading, spacing: 12) {
                    Text("Recent Sessions")
                        .font(.claritySubheadline)
                        .foregroundColor(UstiaTheme.textSecondary)
                    
                    let recentSessions = appState.sessions
                        .sorted { $0.startTime > $1.startTime }
                        .prefix(5)
                    
                    if recentSessions.isEmpty {
                        Text("No sessions yet. Start your first one!")
                            .font(.clarityCaption)
                            .foregroundColor(UstiaTheme.textTertiary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                    } else {
                        ForEach(Array(recentSessions)) { session in
                            SessionRow(session: session)
                        }
                    }
                }
                
                Spacer(minLength: 80)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
        }
        .onAppear {
            if let first = appState.focusModes.first {
                selectedMode = first
            }
        }
    }
    
    private func startSession(mode: FocusMode) {
        appState.startSession(mode: mode)
        isBreakTime = false
        totalSeconds = mode.workDuration
        remainingSeconds = mode.workDuration
        isTimerActive = true
        runTimer()
    }
    
    private func runTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if remainingSeconds > 0 {
                remainingSeconds -= 1
            } else {
                if !isBreakTime {
                    // Work session ended
                    let mode = appState.focusModes.first { $0.name == (appState.currentSession?.modeName ?? "") }
                    isBreakTime = true
                    totalSeconds = mode?.breakDuration ?? 5 * 60
                    remainingSeconds = totalSeconds
                } else {
                    // Break ended - complete
                    completeSession()
                }
            }
        }
    }
    
    private func pauseTimer() {
        timer?.invalidate()
    }
    
    private func stopTimer() {
        timer?.invalidate()
        appState.endSession(completed: false)
        isTimerActive = false
        isBreakTime = false
        appState.currentSession = nil
    }
    
    private func completeSession() {
        timer?.invalidate()
        appState.endSession(completed: true)
        isTimerActive = false
        isBreakTime = false
    }
}

// MARK: - Focus Mode Row

struct FocusModeRow: View {
    let mode: FocusMode
    let selected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color(hex: mode.colorHex).opacity(0.2))
                        .frame(width: 48, height: 48)
                    Image(systemName: mode.icon)
                        .foregroundColor(Color(hex: mode.colorHex))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(mode.name)
                        .font(.claritySubheadline)
                        .foregroundColor(UstiaTheme.textPrimary)
                    Text("\(mode.workDuration/60) min work • \(mode.breakDuration/60) min break")
                        .font(.clarityCaption)
                        .foregroundColor(UstiaTheme.textTertiary)
                }
                
                Spacer()
                
                if selected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color(hex: mode.colorHex))
                }
            }
            .padding(16)
            .background(selected ? Color(hex: mode.colorHex).opacity(0.1) : UstiaTheme.bgSecondary)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(selected ? Color(hex: mode.colorHex).opacity(0.5) : Color.clear, lineWidth: 1)
            )
        }
    }
}

// MARK: - Timer Active View

struct TimerActiveView: View {
    let modeName: String
    let modeColorHex: String
    let remainingSeconds: Int
    let totalSeconds: Int
    let isBreak: Bool
    let onPause: () -> Void
    let onStop: () -> Void
    
    private var progress: Double {
        guard totalSeconds > 0 else { return 0 }
        return 1.0 - (Double(remainingSeconds) / Double(totalSeconds))
    }
    
    private var minutes: Int { remainingSeconds / 60 }
    private var seconds: Int { remainingSeconds % 60 }
    
    var body: some View {
        VStack(spacing: 24) {
            Text(isBreak ? "Break Time" : modeName)
                .font(.clarityHeadline)
                .foregroundColor(isBreak ? UstiaTheme.accentSecondary : Color(hex: modeColorHex))
            
            ZStack {
                Circle()
                    .stroke(UstiaTheme.surface, lineWidth: 12)
                
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        isBreak ? UstiaTheme.accentSecondary : Color(hex: modeColorHex),
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 1), value: progress)
                
                VStack(spacing: 4) {
                    Text(String(format: "%02d:%02d", minutes, seconds))
                        .font(.clarityMono)
                        .foregroundColor(UstiaTheme.textPrimary)
                        .contentTransition(.numericText())
                    
                    Text(isBreak ? "Relax" : "Stay focused")
                        .font(.clarityCaption)
                        .foregroundColor(UstiaTheme.textTertiary)
                }
            }
            .frame(width: 220, height: 220)
            
            HStack(spacing: 24) {
                Button(action: onStop) {
                    Image(systemName: "stop.fill")
                        .font(.system(size: 24))
                        .foregroundColor(UstiaTheme.destructive)
                        .frame(width: 56, height: 56)
                        .background(UstiaTheme.destructive.opacity(0.15))
                        .clipShape(Circle())
                }
                
                Button(action: onPause) {
                    Image(systemName: "pause.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .frame(width: 72, height: 72)
                        .background(UstiaTheme.accentPrimary)
                        .clipShape(Circle())
                }
            }
        }
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity)
        .clarityCard()
    }
}

// MARK: - Session Row

struct SessionRow: View {
    let session: FocusSession
    
    private var dateFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateStyle = .short
        f.timeStyle = .short
        return f
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color(hex: session.modeColorHex).opacity(0.2))
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: session.completed ? "checkmark" : "xmark")
                        .foregroundColor(Color(hex: session.modeColorHex))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(session.modeName)
                    .font(.claritySubheadline)
                    .foregroundColor(UstiaTheme.textPrimary)
                Text(dateFormatter.string(from: session.startTime))
                    .font(.clarityCaption)
                    .foregroundColor(UstiaTheme.textTertiary)
            }
            
            Spacer()
            
            Text("\(session.duration / 60)m")
                .font(.clarityMonoSmall)
                .foregroundColor(UstiaTheme.textSecondary)
        }
        .padding(12)
        .background(UstiaTheme.bgSecondary)
        .cornerRadius(12)
    }
}

// MARK: - Ambient Sound Grid

struct AmbientSoundGrid: View {
    @StateObject private var soundManager = UstiaSoundManager.shared
    
    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 12) {
            ForEach(UstiaSoundType.allCases, id: \.rawValue) { sound in
                Button {
                    if sound == .none {
                        soundManager.stop()
                    } else {
                        soundManager.play(sound: sound)
                    }
                } label: {
                    VStack(spacing: 6) {
                        Image(systemName: sound.icon)
                            .font(.system(size: 20))
                        Text(sound.displayName)
                            .font(.system(size: 10, weight: .medium))
                    }
                    .foregroundColor(soundManager.currentSound == sound ? UstiaTheme.accentPrimary : UstiaTheme.textSecondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(soundManager.currentSound == sound ? UstiaTheme.accentPrimary.opacity(0.15) : UstiaTheme.bgSecondary)
                    .cornerRadius(12)
                }
            }
        }
    }
}

#Preview {
    FocusView()
        .environmentObject(AppState())
        .preferredColorScheme(.dark)
}
