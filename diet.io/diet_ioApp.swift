//
//  diet_ioApp.swift
//  diet.io
//
//  Created by Ferhan Bayır on 8.12.2024.
//

import SwiftUI
import Firebase
@main
struct diet_ioApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
        }
    }
}
