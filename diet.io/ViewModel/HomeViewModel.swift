import SwiftUI
import FirebaseFirestore
import Foundation

class HomeViewModel: ObservableObject {
    @Published var burnedCalories: Double = 0
    @Published var consumedCalories: Double = 0
    @Published var dailyGoal: Double = 2000
    
    @Published var totalProtein: Double = 0
    @Published var totalFat: Double = 0
    @Published var totalCarbs: Double = 0
    
    @Published var meals: [Meal] = []
    
    @Published var waterAmount: Double = 0
    let dailyWaterGoal: Double = 2000 // ml
    
    private let db = Firestore.firestore()
    
    // Besin değerleri için hedefler (günlük)
    let proteinGoal: Double = 60  // gram
    let fatGoal: Double = 70      // gram
    let carbsGoal: Double = 310   // gram
    
    var proteinProgress: Double {
        return min(totalProtein / proteinGoal, 1.0)
    }
    
    var fatProgress: Double {
        return min(totalFat / fatGoal, 1.0)
    }
    
    var carbsProgress: Double {
        return min(totalCarbs / carbsGoal, 1.0)
    }
    
    func addMeal(_ meal: Meal) {
        meals.append(meal)
        consumedCalories += meal.calories
        totalProtein += meal.protein
        totalFat += meal.fat
        totalCarbs += meal.carbs
        
        saveMealToFirestore(meal)
    }
    
    private func saveMealToFirestore(_ meal: Meal) {
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        let data: [String: Any] = [
            "name": meal.name,
            "calories": meal.calories,
            "protein": meal.protein,
            "fat": meal.fat,
            "carbs": meal.carbs,
            "mealType": meal.mealType.rawValue,
            "date": Timestamp(date: meal.date)
        ]
        
        db.collection("users").document(userId)
            .collection("meals")
            .document(meal.id)
            .setData(data)
    }
    
    func fetchTodayMeals() {
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        db.collection("users").document(userId)
            .collection("meals")
            .whereField("date", isGreaterThanOrEqualTo: Timestamp(date: startOfDay))
            .whereField("date", isLessThan: Timestamp(date: endOfDay))
            .getDocuments { [weak self] snapshot, error in
                if let documents = snapshot?.documents {
                    self?.meals = documents.compactMap { document in
                        guard let name = document.data()["name"] as? String,
                              let calories = document.data()["calories"] as? Double,
                              let protein = document.data()["protein"] as? Double,
                              let fat = document.data()["fat"] as? Double,
                              let carbs = document.data()["carbs"] as? Double,
                              let mealTypeRaw = document.data()["mealType"] as? String,
                              let mealType = Meal.MealType(rawValue: mealTypeRaw),
                              let timestamp = document.data()["date"] as? Timestamp else {
                            return nil
                        }
                        
                        return Meal(
                            id: document.documentID,
                            name: name,
                            calories: calories,
                            protein: protein,
                            fat: fat,
                            carbs: carbs,
                            mealType: mealType,
                            date: timestamp.dateValue()
                        )
                    }
                    
                    self?.updateTotals()
                }
            }
    }
    
    private func updateTotals() {
        consumedCalories = meals.reduce(0) { $0 + $1.calories }
        totalProtein = meals.reduce(0) { $0 + $1.protein }
        totalFat = meals.reduce(0) { $0 + $1.fat }
        totalCarbs = meals.reduce(0) { $0 + $1.carbs }
    }
    
    // Günlük kalori verilerini çekmek için yeni fonksiyon
    func fetchTodayCalories() {
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        
        db.collection("users").document(userId)
            .collection("dailyStats")
            .document(startOfDay.formatted(date: .numeric, time: .omitted))
            .getDocument { [weak self] document, error in
                if let document = document, document.exists,
                   let data = document.data() {
                    DispatchQueue.main.async {
                        self?.burnedCalories = data["burnedCalories"] as? Double ?? 0
                        self?.consumedCalories = data["consumedCalories"] as? Double ?? 0
                        self?.dailyGoal = data["dailyGoal"] as? Double ?? 2000
                    }
                }
            }
        
        // Aynı zamanda yemekleri de çek
        fetchTodayMeals()
    }
    
    func addWater(_ amount: Double) {
        waterAmount += amount
        saveWaterAmount()
        WaterReminderManager.shared.scheduleNextReminder()
    }
    
    private func saveWaterAmount() {
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        let data: [String: Any] = [
            "waterAmount": waterAmount,
            "date": Timestamp()
        ]
        
        db.collection("users").document(userId)
            .collection("waterTracking")
            .document(getTodayString())
            .setData(data, merge: true)
    }
    
    func fetchTodayWater() {
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        db.collection("users").document(userId)
            .collection("waterTracking")
            .document(getTodayString())
            .getDocument { [weak self] document, error in
                if let document = document, document.exists,
                   let data = document.data() {
                    DispatchQueue.main.async {
                        self?.waterAmount = data["waterAmount"] as? Double ?? 0
                    }
                }
            }
    }
    
    private func getTodayString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
} 
