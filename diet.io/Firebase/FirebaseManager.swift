//
//  FirebaseManager.swift
//  diet.io
//
//  Created by Ferhan Bayır on 14.12.2024.
//


import Firebase
import FirebaseAuth
import FirebaseFirestore

class FirebaseManager {
    static let shared = FirebaseManager()
    private init() {}

    let auth = Auth.auth() // 'private' yerine 'internal' oldu
    let db = Firestore.firestore()


    // Kullanıcı Girişi
    func signInUser(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let userId = result?.user.uid else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID not found"])))
                return
            }
            
            // Kullanıcı ID'sini UserDefaults'a kaydet
            UserDefaults.standard.set(userId, forKey: "userId")
            
            // Kullanıcı verilerini Firestore'dan çek
            self?.fetchUserData(userId: userId) { result in
                switch result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func fetchUserData(userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument { document, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let document = document, document.exists else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User data not found"])))
                return
            }
            
            // Burada kullanıcı verilerini UserDefaults veya başka bir yere kaydedebilirsiniz
            // Örnek:
            // UserDefaults.standard.set(document.data(), forKey: "userData")
            
            completion(.success(()))
        }
    }
    
    // Kullanıcı Kaydı
    func registerUser(email: String, password: String, userName: String, completion: @escaping (Result<Void, Error>) -> Void) {
        auth.createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let userId = result?.user.uid else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID not found"])))
                return
            }
            
            // Kullanıcı Firestore'a kaydediliyor
            let userData: [String: Any] = [
                "email": email,
                "userName": userName,  // userName'i kaydet
                "name": userName,      // name olarak da kaydet (uyumluluk için)
                "createdAt": Timestamp()
            ]
            
            self.db.collection("users").document(userId).setData(userData) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    // Kullanıcı verilerini UserDefaults'a kaydet
                    UserDefaults.standard.set(userName, forKey: "userName")
                    completion(.success(()))
                }
            }
        }
    }
}
