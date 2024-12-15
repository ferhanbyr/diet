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
    private let db = Firestore.firestore()


    // Kullanıcı Girişi
    func signInUser(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        auth.signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
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
            self.db.collection("users").document(userId).setData([
                "email": email,
                "userName": userName,
                "createdAt": Timestamp()
            ]) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }
}
