import Foundation

class FoodViewModel: ObservableObject {
    @Published var foods: [Food] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let apiKey = "53YhoJpmr7u1ekqdHdce3u:3hWbccRbGJaiVLMyYPulkc"
    private let baseURL = "https://api.collectapi.com/food/calories"
    
    func searchFood(query: String) {
        isLoading = true
        errorMessage = nil
        
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)?query=\(encodedQuery)") else {
            errorMessage = "Geçersiz arama"
            isLoading = false
            return
        }
        
        print("URL: \(url)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Header'ları API'nin beklediği formatta ayarlayalım
        let headers = [
            "content-type": "application/json",
            "authorization": "apikey \(apiKey)"
        ]
        request.allHTTPHeaderFields = headers
        
        print("Request Headers:", request.allHTTPHeaderFields ?? [:])
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    print("Network Error:", error)
                    self?.errorMessage = error.localizedDescription
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("Status Code:", httpResponse.statusCode)
                    print("Response Headers:", httpResponse.allHeaderFields)
                }
                
                guard let data = data else {
                    self?.errorMessage = "Veri alınamadı"
                    return
                }
                
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Raw JSON Response:", jsonString)
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        print("Parsed JSON:", json)
                    }
                    
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(FoodResponse.self, from: data)
                    print("Successfully decoded response with \(response.result.count) items")
                    self?.foods = response.result
                } catch {
                    print("Decode Error:", error)
                    print("Detailed Error:", (error as NSError).userInfo)
                    self?.errorMessage = "Veri çözümlenemedi: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
} 
