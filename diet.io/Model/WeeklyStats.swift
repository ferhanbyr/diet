import Foundation

struct WeeklyStats: Codable, Identifiable {
    let id: String
    let weekStartDate: Date
    let weekEndDate: Date
    var dailyStats: [DailyStats]
    
    var averageCalories: Double {
        dailyStats.map { $0.totalCalories }.reduce(0, +) / Double(dailyStats.count)
    }
    
    var averageWater: Double {
        dailyStats.map { $0.waterIntake }.reduce(0, +) / Double(dailyStats.count)
    }
    
    var totalProtein: Double {
        dailyStats.map { $0.totalProtein }.reduce(0, +)
    }
    
    var totalCarbs: Double {
        dailyStats.map { $0.totalCarbs }.reduce(0, +)
    }
    
    var totalFat: Double {
        dailyStats.map { $0.totalFat }.reduce(0, +)
    }
    
    var calorieProgress: Double {
        guard let userGoal = dailyStats.first?.calorieGoal, userGoal > 0 else { return 0 }
        return (averageCalories / userGoal) * 100
    }
}

struct DailyStats: Codable, Identifiable {
    let id: String
    let date: Date
    let meals: [DietMeal]
    let waterIntake: Double
    let calorieGoal: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case date
        case meals
        case waterIntake
        case calorieGoal
    }
    
    init(id: String, date: Date, meals: [DietMeal], waterIntake: Double, calorieGoal: Double) {
        self.id = id
        self.date = date
        self.meals = meals
        self.waterIntake = waterIntake
        self.calorieGoal = calorieGoal
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        date = try container.decode(Date.self, forKey: .date)
        meals = try container.decode([DietMeal].self, forKey: .meals)
        waterIntake = try container.decode(Double.self, forKey: .waterIntake)
        calorieGoal = try container.decode(Double.self, forKey: .calorieGoal)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(date, forKey: .date)
        try container.encode(meals, forKey: .meals)
        try container.encode(waterIntake, forKey: .waterIntake)
        try container.encode(calorieGoal, forKey: .calorieGoal)
    }
    
    var totalCalories: Double {
        meals.map { $0.calories }.reduce(0, +)
    }
    
    var totalProtein: Double {
        meals.map { $0.protein }.reduce(0, +)
    }
    
    var totalCarbs: Double {
        meals.map { $0.carbs }.reduce(0, +)
    }
    
    var totalFat: Double {
        meals.map { $0.fat }.reduce(0, +)
    }
} 