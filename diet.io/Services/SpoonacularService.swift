import Foundation

enum APIError: Error, LocalizedError {
    case serverError(message: String)
    case decodingError(String)
    case invalidURL
    case networkError(String)
    
    var errorDescription: String? {
        switch self {
        case .serverError(let message): return message
        case .decodingError(let message): return message
        case .invalidURL: return "Geçersiz URL"
        case .networkError(let message): return message
        }
    }
}

// API Response Models
struct APIResponse: Codable {
    let status: String
    let message: String
    let messageTR: String
    let systemTime: Int
    let endpoint: String
    let rowCount: Int
    let creditUsed: Int
    let data: [RecipeListItem]?
}

// Liste görünümü için basit model
struct RecipeListItem: Codable, Identifiable {
    let id: String
    let yemekAdi: String
    let gorsel: String
    let sure: String
    let kisiSayisi: String
    
    enum CodingKeys: String, CodingKey {
        case id = "yemek_id"
        case yemekAdi = "yemek_adi"
        case gorsel
        case sure = "pisirme_suresi"
        case kisiSayisi = "kisi_sayisi"
    }
}

// Detay görünümü için detaylı model
struct RecipeDetail: Codable, Identifiable {
    let id: String
    let yemekAdi: String
    let aciklama: String
    let gorsel: String
    let hazirlamaSuresi: String
    let pisirmeSuresi: String
    let kisiSayisi: String
    let zorluk: String
    let malzemeler: [String]
    let yapilis: [String]
    
    enum CodingKeys: String, CodingKey {
        case id = "yemek_id"
        case yemekAdi = "yemek_adi"
        case aciklama
        case gorsel
        case hazirlamaSuresi = "hazirlama_suresi"
        case pisirmeSuresi = "pisirme_suresi"
        case kisiSayisi = "kisi_sayisi"
        case zorluk
        case malzemeler
        case yapilis
    }
}

// View Model extensions
extension RecipeListItem {
    var displayTitle: String { yemekAdi }
    var displayImage: String { gorsel }
    var displayTime: String { "\(sure) dk" }
    var displayServings: String { kisiSayisi }
}

extension RecipeDetail {
    var displayTitle: String { yemekAdi }
    var displayImage: String { gorsel }
    var displayTime: String { "\(Int(hazirlamaSuresi) ?? 0 + Int(pisirmeSuresi)! ?? 0) dk" }
    var displayServings: String { kisiSayisi }
    var ingredientList: [String] { malzemeler }
    var instructionList: [String] { yapilis }
}

class SpoonacularService {
    static let shared = SpoonacularService()
    private let apiKey = "oMtXS0BQvNhVFMpIL726SJuVEAyax4cD34Us4VfPyW7eH8HsAqyFOkY0SzT3"
    private let baseURL = "https://www.nosyapi.com/apiv2/service/food-recipes"
    
    func searchRecipes(query: String = "") async throws -> [RecipeListItem] {
        var components = URLComponents(string: "\(baseURL)/list")
        components?.queryItems = [
            URLQueryItem(name: "id", value: "0"), // Tüm tarifleri getir
            URLQueryItem(name: "page", value: "1"),
            URLQueryItem(name: "limit", value: "20")
        ]
        
        guard let url = components?.url else {
            throw APIError.invalidURL
        }
        
        print("Request URL: \(url.absoluteString)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization") // Bearer token
        // request.setValue(apiKey, forHTTPHeaderField: "X-NSYP") // Alternatif header
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("API Response: \(jsonString)")
            }
            
            let decoder = JSONDecoder()
            let apiResponse = try decoder.decode(APIResponse.self, from: data)
            
            if apiResponse.status == "failure" {
                throw APIError.serverError(message: apiResponse.messageTR)
            }
            
            return apiResponse.data ?? []
            
        } catch let decodingError as DecodingError {
            print("Decoding Error: \(decodingError)")
            throw APIError.decodingError("Veri çözümleme hatası: \(decodingError.localizedDescription)")
        } catch {
            print("Network Error: \(error)")
            throw APIError.networkError("Ağ hatası: \(error.localizedDescription)")
        }
    }
    
    func getRecipeDetails(id: Int) async throws -> RecipeDetail {
        var components = URLComponents(string: "\(baseURL)/details")
        components?.queryItems = [
            URLQueryItem(name: "id", value: String(id))
        ]
        
        guard let url = components?.url else {
            throw APIError.invalidURL
        }
        
        print("Detail Request URL: \(url.absoluteString)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        // request.setValue(apiKey, forHTTPHeaderField: "X-NSYP")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        if let jsonString = String(data: data, encoding: .utf8) {
            print("Detail Response: \(jsonString)")
        }
        
        let decoder = JSONDecoder()
        let apiResponse = try decoder.decode(APIResponse.self, from: data)
        
        if apiResponse.status == "failure" {
            throw APIError.serverError(message: apiResponse.messageTR)
        }
        
        guard let recipes = apiResponse.data, let recipe = recipes.first else {
            throw APIError.decodingError("Tarif detayı bulunamadı")
        }
        
        return RecipeDetail(
            id: recipe.id,
            yemekAdi: recipe.yemekAdi,
            aciklama: "",
            gorsel: recipe.gorsel,
            hazirlamaSuresi: "0",
            pisirmeSuresi: recipe.sure,
            kisiSayisi: recipe.kisiSayisi,
            zorluk: "",
            malzemeler: [],
            yapilis: []
        )
    }
} 
