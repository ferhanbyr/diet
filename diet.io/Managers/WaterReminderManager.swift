import Foundation
import UserNotifications

class WaterReminderManager {
    static let shared = WaterReminderManager()
    
    private init() {}
    
    func scheduleReminders() {
        // Mevcut hatırlatıcıları temizle
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        // Yeni hatırlatıcılar ekle
        let content = UNMutableNotificationContent()
        content.title = "Su İçme Zamanı"
        content.body = "Su içmeyi unutmayın!"
        content.sound = .default
        
        let interval = UserDefaults.standard.integer(forKey: "waterReminderInterval") * 60
        let validInterval = max(interval, 60) // Minimum 60 saniye kontrolü
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(validInterval), repeats: true)
        
        let request = UNNotificationRequest(identifier: "waterReminder", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    func updateSettings(isEnabled: Bool, interval: Int) {
        UserDefaults.standard.set(isEnabled, forKey: "waterReminderEnabled")
        UserDefaults.standard.set(interval, forKey: "waterReminderInterval")
        
        if isEnabled {
            scheduleReminders()
        } else {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        }
    }
} 