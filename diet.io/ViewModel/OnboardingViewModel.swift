import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class OnboardingViewModel: ObservableObject {
    @Published var currentStep: OnboardingStep = .choice
    @Published var selectedTheme: ThemeColor = .broccoli
    
    // Kullanıcı verileri
    @Published var selectedGender: Gender?
    @Published var height: String = ""
    @Published var weight: String = ""
    @Published var targetWeight: String = ""
    @Published var birthDay: String = ""
    @Published var birthMonth: String = ""
    @Published var birthYear: String = ""
    @Published var activityLevel: String = ""
    @Published var bmi: Double?
    
    var progressValue: Double {
        switch currentStep {
        case .choice: return 0.2
        case .gender: return 0.4
        case .weightGoal: return 0.6
        case .birthday: return 0.8
        case .activity: return 1.0
        }
    }
    
    // Seçili buton için yeni özellik
    @Published var isGenderSelected = false
    
    enum OnboardingStep {
        case choice
        case gender
        case weightGoal
        case birthday
        case activity
    }
    
    enum ThemeColor {
        case broccoli // Kilo verme
        case mango    // Kilo alma
        case apple    // Sağlıklı yaşam
        
        var primary: Color {
            switch self {
            case .broccoli: return Color("BrokoliKoyu")
            case .mango: return Color("MangoKoyu")
            case .apple: return Color("ElmaKoyu")
            }
        }
        
        var secondary: Color {
            switch self {
            case .broccoli: return Color("BrokoliAcik")
            case .mango: return Color("MangoAcik")
            case .apple: return Color("ElmaAcik")
            }
        }
        
        var image: String {
            switch self {
            case .broccoli: return "brokoli"
            case .mango: return "mango"
            case .apple: return "elma"
            }
        }
    }
    
    enum Gender {
        case male
        case female
    }
    
    func nextStep() {
        switch currentStep {
        case .choice:
            currentStep = .gender
        case .gender:
            currentStep = .weightGoal
        case .weightGoal:
            currentStep = .birthday
        case .birthday:
            currentStep = .activity
        case .activity:
            saveUserData()
        }
    }
    
    func setTheme(for choice: String) {
        switch choice {
        case "Kilo verme":
            selectedTheme = .broccoli
        case "Kilo alma":
            selectedTheme = .mango
        case "Sağlıklı yaşam":
            selectedTheme = .apple
        default:
            break
        }
    }
    
    func calculateBMI() {
        guard let heightValue = Double(height), let weightValue = Double(weight),
              heightValue > 0, weightValue > 0 else {
            bmi = nil
            return
        }
        
        let heightInMeters = heightValue / 100
        bmi = weightValue / (heightInMeters * heightInMeters)
    }
    
    func saveUserData() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let userData: [String: Any] = [
            "height": height,
            "weight": weight,
            "targetWeight": targetWeight,
            "gender": selectedGender == .male ? "male" : "female",
            "birthDate": "\(birthDay)/\(birthMonth)/\(birthYear)",
            "activityLevel": activityLevel,
            "bmi": bmi ?? 0,
            "dietType": selectedTheme == .broccoli ? "weightLoss" :
                       selectedTheme == .mango ? "weightGain" : "healthyLife"
        ]
        
        let db = Firestore.firestore()
        db.collection("users").document(userId).setData(userData) { error in
            if let error = error {
                print("Error saving user data: \(error.localizedDescription)")
            } else {
                print("User data saved successfully")
                // Burada ana sayfaya yönlendirme yapılabilir
            }
        }
    }
    
    func validateNumericInput(_ text: String) -> String {
        let filtered = text.filter { "0123456789".contains($0) }
        return String(filtered.prefix(3)) // Maksimum 3 karakter
    }
    
    // Boy, kilo ve hedef kilo için setter'lar
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
    
    // Doğum tarihi için setter'lar
    func setBirthDay(_ value: String) {
        birthDay = String(validateNumericInput(value).prefix(2))
    }
    
    func setBirthMonth(_ value: String) {
        birthMonth = String(validateNumericInput(value).prefix(2))
    }
    
    func setBirthYear(_ value: String) {
        birthYear = String(validateNumericInput(value).prefix(4))
    }
} 