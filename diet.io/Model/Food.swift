import Foundation

// API yanıtının ana yapısı
struct FoodResponse: Codable {
    let success: Bool
    let result: [Food]
}

// Yemek modeli
struct Food: Identifiable, Codable {
    var id = UUID()
    let name: String
    let kalori: String
    let weight: String
    
    // API'den gelen alanları bizim modelimize eşleştiriyoruz
    enum CodingKeys: String, CodingKey {
        case name
        case kalori = "kcal"
        case weight
    }
    
    // Özel decoder ekleyelim
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // name ve kalori alanlarını decode et
        name = try container.decode(String.self, forKey: .name)
        kalori = try container.decode(String.self, forKey: .kalori)
        weight = try container.decode(String.self, forKey: .weight)
        
        // UUID oluştur
        id = UUID()
    }
    
    // Debug için
    func printDetails() {
        print("Food: \(name), Kalori: \(kalori), Porsiyon: \(weight)")
    }
} 
