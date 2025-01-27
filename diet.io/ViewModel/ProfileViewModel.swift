import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class ProfileViewModel: ObservableObject {
    @Published var userProfile: UserProfile?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let db = Firestore.firestore()
    
    func fetchProfile() {
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid,
              let userEmail = FirebaseManager.shared.auth.currentUser?.email else { return }
        isLoading = true
        
        db.collection("users").document(userId).getDocument { [weak self] document, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    print("Firestore okuma hatası: \(error.localizedDescription)")
                    return
                }
                
                if let document = document, document.exists {
                    do {
                        let data = document.data() ?? [:]
                        let profile = UserProfile(
                            id: data["id"] as? String ?? "",
                            name: data["name"] as? String ?? "",
                            email: data["email"] as? String ?? userEmail,
                            age: data["age"] as? Int ?? 0,
                            height: data["height"] as? Double ?? 0,
                            weight: data["weight"] as? Double ?? 0,
                            targetWeight: data["targetWeight"] as? Double ?? 0,
                            dietGoal: DietGoal(rawValue: data["dietGoal"] as? String ?? "") ?? .maintenance,
                            activityLevel: ActivityLevel(rawValue: data["activityLevel"] as? String ?? "") ?? .sedentary,
                            gender: Gender(rawValue: data["gender"] as? String ?? "") ?? .male,
                            dailyCalorieGoal: data["dailyCalorieGoal"] as? Double ?? 0
                        )
                        self?.userProfile = profile
                        print("Profil başarıyla yüklendi")
                    } catch {
                        self?.errorMessage = error.localizedDescription
                        print("Profil dönüştürme hatası: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func updateProfile(_ profile: UserProfile) {
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        isLoading = true
        
        var updatedProfile = calculateBMIAndCalories(for: profile)
        updatedProfile.email = FirebaseManager.shared.auth.currentUser?.email ?? ""
        
        let profileData: [String: Any] = [
            "id": updatedProfile.id,
            "name": updatedProfile.name,
            "email": updatedProfile.email,
            "age": updatedProfile.age,
            "height": updatedProfile.height,
            "weight": updatedProfile.weight,
            "targetWeight": updatedProfile.targetWeight,
            "dietGoal": updatedProfile.dietGoal.rawValue,
            "activityLevel": updatedProfile.activityLevel.rawValue,
            "gender": updatedProfile.gender.rawValue,
            "dailyCalorieGoal": updatedProfile.dailyCalorieGoal,
            "bmiValue": updatedProfile.bmiValue
        ]
        
        db.collection("users").document(userId).setData(profileData) { [weak self] error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    print("Firestore kayıt hatası: \(error.localizedDescription)")
                } else {
                    self?.userProfile = updatedProfile
                    ThemeManager.shared.updateTheme(for: updatedProfile.dietGoal)
                    print("Profil başarıyla güncellendi")
                }
            }
        }
    }
    
    private func calculateBMIAndCalories(for profile: UserProfile) -> UserProfile {
        var updatedProfile = profile
        
        // BMI hesaplama
        let heightInMeters = profile.height / 100
        updatedProfile.bmiValue = profile.weight / (heightInMeters * heightInMeters)
        
        // Günlük kalori hesaplama
        updatedProfile.dailyCalorieGoal = calculateDailyCalories(for: profile)
        
        return updatedProfile
    }
    
    func calculateDailyCalories(for profile: UserProfile) -> Double {
        let bmr: Double
        if profile.gender == .male {
            bmr = 88.362 + (13.397 * profile.weight) + (4.799 * profile.height) - (5.677 * Double(profile.age))
        } else {
            bmr = 447.593 + (9.247 * profile.weight) + (3.098 * profile.height) - (4.330 * Double(profile.age))
        }
        
        let dailyCalories = bmr * profile.activityLevel.multiplier
        
        switch profile.dietGoal {
        case .weightLoss:
            return dailyCalories - 500
        case .weightGain:
            return dailyCalories + 500
        case .maintenance:
            return dailyCalories
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            // Kullanıcı bilgilerini temizle
            UserDefaults.standard.removeObject(forKey: "userId")
            // Diğer kullanıcı verilerini temizle
            UserDefaults.standard.synchronize()
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
} 
