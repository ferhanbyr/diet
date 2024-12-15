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
    
    init() {
         FirebaseApp.configure()
     }
    
    var body: some Scene {
        WindowGroup {
            IntroView()
        }
    }
}
