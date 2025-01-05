import Foundation

class ExerciseViewModel: ObservableObject {
    @Published var exercises: [Exercise] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let apiKey = "lMae/92n1gaOzfdA17MwXw==0r3LRrXbVXZcrUR5"
    private let baseURL = "https://api.api-ninjas.com/v1/exercises"
    
    func fetchExercises(for muscle: String? = nil) {
        isLoading = true
        errorMessage = nil
        
        var urlString = baseURL
        if let muscle = muscle {
            urlString += "?muscle=\(muscle)"
        }
        
        guard let url = URL(string: urlString) else {
            errorMessage = "Geçersiz URL"
            isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    return
                }
                
                guard let data = data else {
                    self?.errorMessage = "Veri alınamadı"
                    return
                }
                
                do {
                    let exercises = try JSONDecoder().decode([Exercise].self, from: data)
                    self?.exercises = exercises
                } catch {
                    self?.errorMessage = error.localizedDescription
                }
            }
        }.resume()
    }
} 
