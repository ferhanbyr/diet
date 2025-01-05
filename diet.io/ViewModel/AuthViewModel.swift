import SwiftUI
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var isLoggedIn = false
    private let userDefaults = UserDefaults.standard
    
    init() {
        // Önceki oturum durumunu kontrol et
        if let _ = userDefaults.string(forKey: "userId"),
           let _ = Auth.auth().currentUser {
            isLoggedIn = true
        }
        
        // Kullanıcının giriş durumunu dinle
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.isLoggedIn = user != nil
                if let userId = user?.uid {
                    // Kullanıcı ID'sini kaydet
                    self?.userDefaults.set(userId, forKey: "userId")
                }
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            isLoggedIn = false
            // Kullanıcı bilgilerini temizle
            userDefaults.removeObject(forKey: "userId")
            // Diğer kullanıcı verilerini temizle
            userDefaults.synchronize()
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
} 