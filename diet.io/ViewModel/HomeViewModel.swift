import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    @Published var burnedCalories: Double = 0
    @Published var consumedCalories: Double = 0
    @Published var dailyGoal: Double = 2000
    
    @Published var totalProtein: Double = 0
    @Published var totalFat: Double = 0
    @Published var totalCarbs: Double = 0
    
    @Published var meals: [DietMeal] = []
    
    @Published var waterAmount: Double = 0
    let dailyWaterGoal: Double = 2000 // ml
    
    private let db = Firestore.firestore()
    
    // Besin değerleri için hedefler (günlük)
    let proteinGoal: Double = 60  // gram
    let fatGoal: Double = 70      // gram
    let carbsGoal: Double = 310   // gram
    
    @Published var userName: String = "Kullanıcı"
    
    var proteinProgress: Double {
        return min(totalProtein / proteinGoal, 1.0)
    }
    
    var fatProgress: Double {
        return min(totalFat / fatGoal, 1.0)
    }
    
    var carbsProgress: Double {
        return min(totalCarbs / carbsGoal, 1.0)
    }
    
    func addMeal(_ meal: DietMeal) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            withAnimation(.spring()) {
                self.meals.append(meal)
                self.consumedCalories += meal.calories
                self.totalProtein += meal.protein
                self.totalFat += meal.fat
                self.totalCarbs += meal.carbs
                
                // Değerleri güncellediğimizi bildiriyoruz
                self.objectWillChange.send()
            }
            
            // Firebase'e kaydet
            self.saveMealToFirestore(meal)
        }
    }
    
    private func saveMealToFirestore(_ meal: DietMeal) {
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else {
            print("No user ID found")
            return
        }
        
        let data: [String: Any] = [
            "name": meal.name,
            "calories": meal.calories,
            "protein": meal.protein,
            "fat": meal.fat,
            "carbs": meal.carbs,
            "mealType": meal.mealType.rawValue,
            "date": Timestamp(date: meal.date)
        ]
        
        print("Saving meal to Firestore: \(data)") // Debug için log ekleyelim
        
        db.collection("users").document(userId)
            .collection("meals")
            .document(meal.id)
            .setData(data) { error in
                if let error = error {
                    print("Error saving meal: \(error.localizedDescription)")
                } else {
                    print("Meal saved successfully")
                }
            }
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
                              let mealType = DietMeal.MealType(rawValue: mealTypeRaw),
                              let timestamp = document.data()["date"] as? Timestamp else {
                            return nil
                        }
                        
                        return DietMeal(
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
    
    // Su miktarını güncelle ve Firestore'a kaydet
    func updateWaterAmount(_ amount: Double) {
        waterAmount = amount
        saveWaterToFirestore()
    }
    
    // Su ekle ve Firestore'a kaydet
    func addWater(_ amount: Double) {
        waterAmount += amount
        saveWaterToFirestore()
    }
    
    // Su miktarını Firestore'a kaydet
    private func saveWaterToFirestore() {
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let today = dateFormatter.string(from: Date())
        
        let data: [String: Any] = [
            "amount": waterAmount,
            "date": Timestamp(),
            "userId": userId
        ]
        
        FirebaseManager.shared.db
            .collection("waterTracking")
            .document("\(userId)_\(today)")
            .setData(data) { error in
                if let error = error {
                    print("Error saving water amount: \(error.localizedDescription)")
                }
            }
    }
    
    // Günlük su miktarını Firestore'dan çek
    func fetchTodayWater() {
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let today = dateFormatter.string(from: Date())
        
        FirebaseManager.shared.db
            .collection("waterTracking")
            .document("\(userId)_\(today)")
            .getDocument { [weak self] document, error in
                if let error = error {
                    print("Error fetching water amount: \(error.localizedDescription)")
                    return
                }
                
                if let document = document, document.exists {
                    DispatchQueue.main.async {
                        self?.waterAmount = document.data()?["amount"] as? Double ?? 0
                    }
                } else {
                    // Bugün için kayıt yoksa 0 olarak ayarla
                    DispatchQueue.main.async {
                        self?.waterAmount = 0
                    }
                }
            }
    }
    
    func fetchProfile() {
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        FirebaseManager.shared.db.collection("users").document(userId).getDocument { [weak self] document, error in
            if let error = error {
                print("Error fetching profile: \(error.localizedDescription)")
                return
            }
            
            if let document = document, document.exists {
                let data = document.data()
                DispatchQueue.main.async {
                    self?.userName = data?["userName"] as? String ?? data?["name"] as? String ?? "Kullanıcı"
                }
            }
        }
    }
    
    @Published var weeklyStats: WeeklyStats?
    
    func fetchWeeklyStats() {
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        let calendar = Calendar.current
        let today = Date()
        guard let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)),
              let weekEnd = calendar.date(byAdding: .day, value: 7, to: weekStart) else { return }
        
        // Günlük istatistikleri koleksiyonundan verileri çek
        db.collection("users").document(userId)
            .collection("dailyStats")
            .whereField("date", isGreaterThanOrEqualTo: weekStart)
            .whereField("date", isLessThan: weekEnd)
            .getDocuments { [weak self] snapshot, error in
                if let error = error {
                    print("Error fetching weekly stats: \(error)")
                    return
                }
                
                var dailyStats: [DailyStats] = []
                
                // Geçmiş günlerin verilerini al
                snapshot?.documents.forEach { document in
                    if let stats = try? document.data(as: DailyStats.self) {
                        dailyStats.append(stats)
                    }
                }
                
                // Bugünün verilerini ekle
                if let currentStats = self?.getCurrentDayStats() {
                    // Eğer bugünün verisi zaten varsa güncelle, yoksa ekle
                    if let index = dailyStats.firstIndex(where: { calendar.isDate($0.date, inSameDayAs: today) }) {
                        dailyStats[index] = currentStats
                    } else {
                        dailyStats.append(currentStats)
                    }
                }
                
                // Tarihe göre sırala
                dailyStats.sort { $0.date < $1.date }
                
                // WeeklyStats'i güncelle
                DispatchQueue.main.async {
                    self?.weeklyStats = WeeklyStats(
                        id: UUID().uuidString,
                        weekStartDate: weekStart,
                        weekEndDate: weekEnd,
                        dailyStats: dailyStats
                    )
                }
            }
    }
    
    // Bugünün verilerini oluştur
    private func getCurrentDayStats() -> DailyStats {
        return DailyStats(
            id: UUID().uuidString,
            date: Date(),
            meals: meals,
            waterIntake: waterAmount,
            calorieGoal: dailyGoal
        )
    }
    
    // Günlük verileri kontrol et ve sıfırla
    func checkAndResetDailyStats() {
        let calendar = Calendar.current
        let now = Date()
        let lastResetKey = "lastStatsResetDate"
        
        // Son sıfırlama tarihini kontrol et
        if let lastReset = UserDefaults.standard.object(forKey: lastResetKey) as? Date {
            // Eğer son sıfırlama bugün değilse
            if !calendar.isDate(lastReset, inSameDayAs: now) {
                print("Yeni gün başlıyor, veriler kaydediliyor ve sıfırlanıyor...")
                
                // Önce mevcut günün verilerini kaydet
                saveDailyStats()
                
                // Tüm günlük verileri sıfırla
                DispatchQueue.main.async { [weak self] in
                    // Kalori verileri
                    self?.consumedCalories = 0
                    self?.burnedCalories = 0
                    
                    // Besin değerleri
                    self?.totalProtein = 0
                    self?.totalFat = 0
                    self?.totalCarbs = 0
                    
                    // Su takibi
                    self?.waterAmount = 0
                    
                    // Öğünler
                    self?.meals = []
                    
                    // Firebase'de günlük verileri sıfırla
                    self?.resetFirebaseDaily()
                    
                    // Sıfırlama tarihini güncelle
                    UserDefaults.standard.set(now, forKey: lastResetKey)
                    
                    // Haftalık istatistikleri güncelle
                    self?.fetchWeeklyStats()
                }
                
                print("Tüm veriler sıfırlandı")
            }
        } else {
            // İlk çalıştırma için tarihi kaydet
            UserDefaults.standard.set(now, forKey: lastResetKey)
        }
    }
    
    // Günlük verileri sıfırlamak için yeni fonksiyon
    func resetDailyStats() {
        let calendar = Calendar.current
        let now = Date()
        let lastResetKey = "lastStatsResetDate"
        
        // Son sıfırlama tarihini kontrol et
        if let lastReset = UserDefaults.standard.object(forKey: lastResetKey) as? Date {
            // Eğer son sıfırlama bugün değilse
            if !calendar.isDate(lastReset, inSameDayAs: now) {
                print("Yeni gün başlıyor, veriler kaydediliyor ve sıfırlanıyor...")
                
                // Önce mevcut günün verilerini kaydet
                saveDailyStats()
                
                // Tüm günlük verileri sıfırla
                DispatchQueue.main.async { [weak self] in
                    // Kalori verileri
                    self?.consumedCalories = 0
                    self?.burnedCalories = 0
                    
                    // Besin değerleri
                    self?.totalProtein = 0
                    self?.totalFat = 0
                    self?.totalCarbs = 0
                    
                    // Su takibi
                    self?.waterAmount = 0
                    
                    // Öğünler
                    self?.meals = []
                    
                    // Firebase'de günlük verileri sıfırla
                    self?.resetFirebaseDaily()
                    
                    // Sıfırlama tarihini güncelle
                    UserDefaults.standard.set(now, forKey: lastResetKey)
                    
                    // Haftalık istatistikleri güncelle
                    self?.fetchWeeklyStats()
                }
                
                print("Tüm veriler sıfırlandı")
            }
        } else {
            // İlk çalıştırma için tarihi kaydet
            UserDefaults.standard.set(now, forKey: lastResetKey)
        }
    }
    
    // Firebase'deki günlük verileri sıfırla
    private func resetFirebaseDaily() {
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let today = dateFormatter.string(from: Date())
        
        // Su verilerini sıfırla
        FirebaseManager.shared.db
            .collection("waterTracking")
            .document("\(userId)_\(today)")
            .setData([
                "amount": 0,
                "date": Timestamp(),
                "userId": userId
            ])
        
        // Günlük istatistikleri sıfırla
        let dailyStats = DailyStats(
            id: UUID().uuidString,
            date: Date(),
            meals: [],
            waterIntake: 0,
            calorieGoal: dailyGoal
        )
        
        do {
            try db.collection("users").document(userId)
                .collection("dailyStats")
                .document(dailyStats.id)
                .setData(from: dailyStats)
        } catch {
            print("Error resetting daily stats: \(error)")
        }
    }
    
    // Günlük verileri kaydetme fonksiyonunu güncelle
    func saveDailyStats() {
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        let dailyStats = DailyStats(
            id: UUID().uuidString,
            date: Date(),
            meals: meals,
            waterIntake: waterAmount,
            calorieGoal: dailyGoal
        )
        
        do {
            try db.collection("users").document(userId)
                .collection("dailyStats")
                .document(dailyStats.id)
                .setData(from: dailyStats)
        } catch {
            print("Error saving daily stats: \(error)")
        }
    }
    
    func deleteMeal(_ meal: DietMeal) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            withAnimation(.spring()) {
                if let index = self.meals.firstIndex(where: { $0.id == meal.id }) {
                    self.meals.remove(at: index)
                    self.consumedCalories -= meal.calories
                    self.totalProtein -= meal.protein
                    self.totalFat -= meal.fat
                    self.totalCarbs -= meal.carbs
                    
                    // Değerleri güncellediğimizi bildiriyoruz
                    self.objectWillChange.send()
                }
            }
            
            // Firebase'den sil
            guard let userId = FirebaseManager.shared.auth.currentUser?.uid else { return }
            self.db.collection("users").document(userId)
                .collection("meals")
                .document(meal.id)
                .delete() { error in
                    if let error = error {
                        print("Error deleting meal: \(error.localizedDescription)")
                    }
                }
        }
    }
    
    @Published var userProfile: UserProfile?
    
    func fetchUserData() {
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        db.collection("users").document(userId).getDocument { [weak self] document, error in
            if let document = document, document.exists,
               let profile = try? document.data(as: UserProfile.self) {
                DispatchQueue.main.async {
                    self?.userProfile = profile
                }
            }
        }
    }
} 
