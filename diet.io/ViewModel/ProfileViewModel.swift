import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class ProfileViewModel: ObservableObject {
    @Published var userProfile: UserProfile?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let db = Firestore.firestore()
    
    func fetchProfile() {
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        isLoading = true
        
        db.collection("users").document(userId).getDocument { [weak self] document, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    return
                }
                
                if let document = document, document.exists,
                   let profile = try? document.data(as: UserProfile.self) {
                    self?.userProfile = profile
                }
            }
        }
    }
    
    func updateProfile(_ profile: UserProfile) {
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        isLoading = true
        
        do {
            try db.collection("users").document(userId).setData(from: profile) { [weak self] error in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    if let error = error {
                        self?.errorMessage = error.localizedDescription
                    } else {
                        self?.userProfile = profile
                        ThemeManager.shared.updateTheme(for: profile.dietGoal)
                    }
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.isLoading = false
                self.errorMessage = error.localizedDescription
            }
        }
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
