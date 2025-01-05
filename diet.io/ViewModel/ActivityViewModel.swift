import Foundation

class ActivityViewModel: ObservableObject {
    @Published var activities: [Activity] = []
    @Published var selectedActivity: Activity?
    @Published var duration: Int = 30
    
    // Örnek aktiviteler
    init() {
        activities = [
            Activity(name: "Yürüyüş", caloriesPerHour: 280, icon: "figure.walk"),
            Activity(name: "Koşu", caloriesPerHour: 600, icon: "figure.run"),
            Activity(name: "Bisiklet", caloriesPerHour: 450, icon: "bicycle"),
            Activity(name: "Yüzme", caloriesPerHour: 500, icon: "figure.pool.swim"),
            Activity(name: "Yoga", caloriesPerHour: 200, icon: "figure.mind.and.body"),
            Activity(name: "Dans", caloriesPerHour: 400, icon: "music.note")
        ]
    }
}

struct Activity: Identifiable {
    let id = UUID()
    let name: String
    let caloriesPerHour: Int
    let icon: String
} 