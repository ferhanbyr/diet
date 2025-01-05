import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class OnboardingViewModel: ObservableObject {
    enum OnboardingStep {
        case choice
        case gender
        case birthday
        case activity
        case completed
    }
    
    enum ThemeColor {
        case brokoli // Kilo verme
        case mango   // Kilo alma
        case elma    // Sağlıklı yaşam
        
        var primary: Color {
            switch self {
            case .brokoli: return Color("BrokoliKoyu")
            case .mango: return Color("MangoKoyu")
            case .elma: return Color("ElmaKoyu")
            }
        }
        
        var secondary: Color {
            switch self {
            case .brokoli: return Color("BrokoliAcik")
            case .mango: return Color("MangoAcik")
            case .elma: return Color("ElmaAcik")
            }
        }
        
        var image: String {
            switch self {
            case .brokoli: return "brokoli"
            case .mango: return "mango"
            case .elma: return "elma"
            }
        }
    }
    
    enum Gender {
        case male
        case female
    }
    
    // Published properties
    @Published var currentStep: OnboardingStep = .choice
    @Published var selectedTheme = ThemeColor.brokoli
    @Published var selectedGender: Gender = .male
    @Published var isGenderSelected = false
    @Published var birthDate = Date()
    @Published var activityLevel = ""
    @Published var height: String = ""
    @Published var weight: String = ""
    @Published var targetWeight: String = ""
    @Published var bmi: Double?
    
    var progressValue: Double {
        switch currentStep {
        case .choice: return 0.2
        case .gender: return 0.4
        case .birthday: return 0.6
        case .activity: return 0.8
        case .completed: return 1.0
        }
    }
    
    func nextStep() {
        switch currentStep {
        case .choice:
            currentStep = .gender
        case .gender:
            currentStep = .birthday
        case .birthday:
            currentStep = .activity
        case .activity:
            currentStep = .completed
        case .completed:
            break
        }
    }
    
    func setTheme(for choice: String) {
        switch choice {
        case "Kilo verme":
            selectedTheme = .brokoli
        case "Kilo alma":
            selectedTheme = .mango
        case "Sağlıklı yaşam":
            selectedTheme = .elma
        default:
            break
        }
    }
    
    func calculateBMI() {
        guard let heightValue = Double(height),
              let weightValue = Double(weight),
              heightValue > 0, weightValue > 0 else {
            bmi = nil
            return
        }
        
        let heightInMeters = heightValue / 100
        bmi = weightValue / (heightInMeters * heightInMeters)
    }
    
    func saveUserData() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let dietType = switch selectedTheme {
        case .brokoli: "Kilo verme"
        case .mango: "Kilo alma"
        case .elma: "Sağlıklı yaşam"
        }
        
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: Date())
        let age = ageComponents.year ?? 0
        
        let userData: [String: Any] = [
            "name": FirebaseManager.shared.auth.currentUser?.displayName ?? "Kullanıcı",
            "email": FirebaseManager.shared.auth.currentUser?.email ?? "",
            "gender": selectedGender == .male ? "male" : "female",
            "height": Int(height) ?? 0,
            "weight": Int(weight) ?? 0,
            "targetWeight": Int(targetWeight) ?? 0,
            "birthDate": birthDate,
            "age": age,
            "activityLevel": activityLevel,
            "dailyCalorieGoal": calculateDailyCalorieGoal(),
            "waterGoal": 2000, // Varsayılan su hedefi
            "dietType": dietType,
            "onboardingCompleted": true
        ]
        
        FirebaseManager.shared.db.collection("users").document(userId)
            .setData(userData, merge: true) { error in
                if let error = error {
                    print("Kullanıcı verisi kaydedilemedi: \(error.localizedDescription)")
                } else {
                    print("Kullanıcı verisi başarıyla kaydedildi")
                }
            }
    }
    
    private func calculateDailyCalorieGoal() -> Int {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: Date())
        let age = ageComponents.year ?? 25 // Varsayılan yaş
        
        guard let heightValue = Double(height),
              let weightValue = Double(weight) else {
            return 2000 // Varsayılan değer
        }
        
        // Harris-Benedict denklemi
        var bmr: Double
        if selectedGender == .male {
            bmr = 88.362 + (13.397 * weightValue) + (4.799 * heightValue) - (5.677 * Double(age))
        } else {
            bmr = 447.593 + (9.247 * weightValue) + (3.098 * heightValue) - (4.330 * Double(age))
        }
        
        // Aktivite seviyesine göre çarpan
        let activityMultiplier: Double
        switch activityLevel {
        case "Aktif":
            activityMultiplier = 1.725
        case "Az aktif":
            activityMultiplier = 1.375
        case "Aktif değil":
            activityMultiplier = 1.2
        default:
            activityMultiplier = 1.375
        }
        
        // Hedef bazlı kalori ayarlaması
        let baseCalories = Int(bmr * activityMultiplier)
        
        switch selectedTheme {
        case .brokoli: // Kilo verme
            return Int(Double(baseCalories) * 0.85) // %15 kalori açığı
        case .mango: // Kilo alma
            return Int(Double(baseCalories) * 1.15) // %15 kalori fazlası
        case .elma: // Sağlıklı yaşam
            return baseCalories
        }
    }
    
    func validateNumericInput(_ text: String) -> String {
        let filtered = text.filter { "0123456789".contains($0) }
        return String(filtered.prefix(3))
    }
    
    // Input validasyon fonksiyonları
    func setHeight(_ value: String) {
        height = validateNumericInput(value)
        calculateBMI()
    }
    
    func setWeight(_ value: String) {
        weight = validateNumericInput(value)
        calculateBMI()
    }
    
    func setTargetWeight(_ value: String) {
        targetWeight = validateNumericInput(value)
    }
} 