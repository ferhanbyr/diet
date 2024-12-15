import SwiftUI

struct IntroView: View {
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 20) {
                Image("asd")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                
                CustomButton(title: "Yeni bir kullanıcıyım", backgroundColor: Color("LoginGreen"), textColor: Color("LoginGreen2")) {
                    path.append("RegisterView")
                }
                
                CustomButton(title: "Zaten bir hesabım var", backgroundColor: Color("LoginGreen2"), textColor: Color("LoginGreen")) {
                    path.append("LoginView")
                }
            }
            .padding()
            .background(Color.white)
            .navigationDestination(for: String.self) { route in
                if route == "LoginView" {
                    LoginView()
                }
                else if route == "RegisterView" {
                    RegisterView()
                }
            }
        }
    }
}



struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView()
    }
}
