import SwiftUI

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if authViewModel.isLoggedIn {
                    HomeView()
                        .navigationBarBackButtonHidden(true)
                        .navigationBarHidden(true)
                } else {
                    LoginView()
                }
            }
        }
    }
} 