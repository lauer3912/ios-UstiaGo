import Foundation
import UserNotifications

class UstiaNotificationService {
    static let shared = UstiaNotificationService()

    private init() {}

    // MARK: - Authorization

    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Notification authorization error: \(error)")
            }
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }

    func checkAuthorizationStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus)
            }
        }
    }

    // MARK: - Session Notifications

    /// Schedule notification when a focus session completes
    func scheduleSessionCompletedNotification(session: FocusSession) {
        let content = UNMutableNotificationContent()
        
        if session.completed {
            content.title = "Focus Session Complete! 🎉"
            content.body = "\(session.modeName) - \(session.duration / 60) minutes completed"
            content.sound = .default
        } else {
            content.title = "Focus Session Ended"
            content.body = "You completed \(session.duration / 60) minutes. Keep going tomorrow!"
            content.sound = .default
        }
        
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "session_\(session.id.uuidString)",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling session notification: \(error)")
            }
        }
    }

    // MARK: - Achievement Notifications

    func scheduleAchievementNotification(achievement: Achievement) {
        let content = UNMutableNotificationContent()
        content.title = "Achievement Unlocked! 🏆"
        content.body = achievement.name
        content.sound = .default
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "achievement_\(achievement.id)",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling achievement notification: \(error)")
            }
        }
    }

    // MARK: - Streak Notifications

    func scheduleStreakNotification(streak: Int) {
        let content = UNMutableNotificationContent()
        content.title = "🔥 \(streak) Day Streak!"
        content.body = "You're on fire! Keep the momentum going."
        content.sound = .default
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "streak_\(streak)",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling streak notification: \(error)")
            }
        }
    }

    // MARK: - Clear

    func clearAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}