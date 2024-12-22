import Foundation
import UserNotifications

class WaterReminderManager {
    static let shared = WaterReminderManager()
    
    private let reminderInterval: TimeInterval = 2 * 60 * 60 // 2 saat
    
    func scheduleNextReminder() {
        let content = UNMutableNotificationContent()
        content.title = "Su İçme Vakti! 💧"
        content.body = "Sağlıklı kalmak için su içmeyi unutma!"
        content.sound = .default
        
        // Bir sonraki hatırlatma için trigger
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: reminderInterval,
            repeats: false
        )
        
        let request = UNNotificationRequest(
            identifier: "water_reminder",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Su hatırlatıcısı oluşturma hatası: \(error.localizedDescription)")
            }
        }
    }
    
    func cancelReminders() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: ["water_reminder"]
        )
    }
} 