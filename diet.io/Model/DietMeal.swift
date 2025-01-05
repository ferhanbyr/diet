import Foundation

struct DietMeal: Identifiable, Codable {
    let id: String
    let name: String
    let calories: Double
    let protein: Double
    let fat: Double
    let carbs: Double
    let mealType: MealType
    let date: Date
    
    enum MealType: String, Codable, CaseIterable {
        case breakfast = "Kahvaltı"
        case lunch = "Öğle Yemeği"
        case dinner = "Akşam Yemeği"
        case snack = "Atıştırmalık"
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case calories
        case protein
        case fat
        case carbs
        case mealType
        case date
    }
    
    init(id: String = UUID().uuidString,
         name: String,
         calories: Double,
         protein: Double,
         fat: Double,
         carbs: Double,
         mealType: MealType,
         date: Date = Date()) {
        self.id = id
        self.name = name
        self.calories = calories
        self.protein = protein
        self.fat = fat
        self.carbs = carbs
        self.mealType = mealType
        self.date = date
    }
} 