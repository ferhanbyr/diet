import Foundation

class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessages] = []
    @Published var inputMessage = ""
    @Published var isLoading = false
    
    private let apiKey = "AIzaSyCNEm_Q0pEJ1xm2zcvrD3q1YetHitusI4Q"
    private let baseURL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent"
    
    init() {
        // Hoş geldin mesajını ekle
        let welcomeMessage = ChatMessages(
            content: "Merhaba! Ben Brokoli, sağlıklı beslenme asistanınız. Size nasıl yardımcı olabilirim?",
            isUser: false,
            timestamp: Date()
        )
        messages.append(welcomeMessage)
    }
    
    func sendMessage() {
        guard !inputMessage.isEmpty else { return }
        
        // Kullanıcı mesajını ekle
        let userMessage = ChatMessages(content: inputMessage, isUser: true, timestamp: Date())
        messages.append(userMessage)
        
        // API isteği için mesajı sakla ve input'u temizle
        let messageToSend = inputMessage
        inputMessage = ""
        
        isLoading = true
        
        // API isteği yap
        let urlString = "\(baseURL)?key=\(apiKey)"
        guard let url = URL(string: urlString) else { return }
        
        let requestBody: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        ["text": messageToSend]
                    ]
                ]
            ]
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            print("JSON serialization error: \(error)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    print("Network error: \(error)")
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let candidates = json["candidates"] as? [[String: Any]],
                       let firstCandidate = candidates.first,
                       let content = firstCandidate["content"] as? [String: Any],
                       let parts = content["parts"] as? [[String: Any]],
                       let firstPart = parts.first,
                       let text = firstPart["text"] as? String {
                        
                        let botMessage = ChatMessages(content: text, isUser: false, timestamp: Date())
                        self?.messages.append(botMessage)
                    }
                } catch {
                    print("JSON parsing error: \(error)")
                }
            }
        }.resume()
    }
} 
