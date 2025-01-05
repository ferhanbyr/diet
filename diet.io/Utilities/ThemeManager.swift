import SwiftUI

class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    @Published var currentTheme: DietGoal = .maintenance
    
    private init() {}
    
    func updateTheme(for goal: DietGoal) {
        currentTheme = goal
    }
} 