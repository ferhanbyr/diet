import Foundation

enum DietGoal: String, Codable, CaseIterable {
    case weightLoss = "Kilo Verme"
    case weightGain = "Kilo Alma"
    case maintenance = "Kilo Koruma"
    
    var themeColor: String {
        switch self {
        case .weightLoss: return "ElmaAcik"
        case .weightGain: return "BrokoliAcik"
        case .maintenance: return "MangoAcik"
        }
    }
    
    var themeDarkColor: String {
        switch self {
        case .weightLoss: return "ElmaKoyu"
        case .weightGain: return "BrokoliKoyu"
        case .maintenance: return "MangoKoyu"
        }
    }
    
    var icon: String {
        switch self {
        case .weightLoss: return "arrow.down.circle.fill"
        case .weightGain: return "arrow.up.circle.fill"
        case .maintenance: return "equal.circle.fill"
        }
    }
}

struct UserProfile: Codable {
    var id: String
    var name: String
    var age: Int
    var height: Double
    var weight: Double
    var targetWeight: Double
    var dietGoal: DietGoal
    var activityLevel: ActivityLevel
    var gender: Gender
    var dailyCalorieGoal: Double
    
    var bmi: Double {
        let heightInMeters = height / 100
        return weight / (heightInMeters * heightInMeters)
    }
}

enum ActivityLevel: String, Codable, CaseIterable {
    case sedentary = "Hareketsiz"
    case lightlyActive = "Az Hareketli"
    case moderatelyActive = "Orta Hareketli"
    case veryActive = "Çok Hareketli"
    case extremelyActive = "Aşırı Hareketli"
    
    var multiplier: Double {
        switch self {
        case .sedentary: return 1.2
        case .lightlyActive: return 1.375
        case .moderatelyActive: return 1.55
        case .veryActive: return 1.725
        case .extremelyActive: return 1.9
        }
    }
}

enum Gender: String, Codable {
    case male = "Erkek"
    case female = "Kadın"
} 
