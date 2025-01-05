import SwiftUI

struct IntroView: View {
    @State private var showLogin = false
    @State private var showRegister = false
    @State private var navigateToHome = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image("asd")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                
                CustomButtonView(
                    title: "Yeni bir kullanıcıyım",
                    type: .primary
                ) {
                    showRegister = true
                }
                
                CustomButtonView(
                    title: "Zaten bir hesabım var",
                    type: .secondary
                ) {
                    showLogin = true
                }
                
                Button(action: {
                    completeRegistration()
                }) {
                    Text("Kayıt Ol")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                NavigationLink(destination: HomeView(), isActive: $navigateToHome) {
                    EmptyView()
                }
            }
            .padding()
            .background(Color.white)
            .navigationDestination(isPresented: $showRegister) {
                RegisterView()
            }
            .navigationDestination(isPresented: $showLogin) {
                LoginView()
            }
        }
    }
    
    private func completeRegistration() {
        navigateToHome = true
    }
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView()
    }
}
