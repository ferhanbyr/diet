import UserNotifications
import SwiftUI

class NotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()
    @Published var settings: UNNotificationSettings?
    
    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if let error = error {
                print("Bildirim izni hatası: \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleNotification(for medicineType: MedicineType, at time: Date, isDaily: Bool = true) {
        let content = UNMutableNotificationContent()
        content.title = medicineType.title
        content.body = medicineType.reminderMessage
        content.sound = .default
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: time)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: isDaily)
        let request = UNNotificationRequest(
            identifier: medicineType.notificationId,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Bildirim oluşturma hatası: \(error.localizedDescription)")
            }
        }
    }
    
    func removeNotification(for medicineType: MedicineType) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: [medicineType.notificationId]
        )
    }
}

enum MedicineType: String {
    case medicine = "medicine"
    case vitaminB12 = "vitaminB12"
    
    var title: String {
        switch self {
        case .medicine:
            return "İlaç Hatırlatıcısı"
        case .vitaminB12:
            return "B12 Vitamini Hatırlatıcısı"
        }
    }
    
    var reminderMessage: String {
        switch self {
        case .medicine:
            return "İlacınızı alma vakti geldi!"
        case .vitaminB12:
            return "B12 vitamininizi alma vakti geldi!"
        }
    }
    
    var notificationId: String {
        return "reminder_\(self.rawValue)"
    }
} 