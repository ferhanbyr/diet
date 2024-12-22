import Foundation

struct Meal: Identifiable, Codable {
    let id: String
    let name: String
    let calories: Double
    let protein: Double
    let fat: Double
    let carbs: Double
    let mealType: MealType
    let date: Date
    
    enum MealType: String, Codable {
        case breakfast = "breakfast"
        case lunch = "lunch"
        case dinner = "dinner"
        case snack = "snack"
        
        var title: String {
            switch self {
            case .breakfast: return "Kahvaltı"
            case .lunch: return "Öğle yemeği"
            case .dinner: return "Akşam yemeği"
            case .snack: return "Atıştırma"
            }
        }
    }
} 