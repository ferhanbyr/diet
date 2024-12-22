import SwiftUI
import FirebaseAuth
struct LoginView: View {
    
    @State private var email = ""
    @State private var password = ""
    @Environment(\.dismiss) private var dismiss
    @State private var showRegister = false
    @State private var isLoading = false
    @State private var navigateToHome = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Spacer(minLength: 50)
                
                // Lock Icon
                Image(systemName: "lock.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.black)
                
                Text("welcome")
                    .font(.custom("DynaPuff", size: 35))
                    .fontWeight(.medium)
                    
                
                // Email TextField
                CustomTextField(text: $email,
                               placeholder: "Email",
                               backgroundColor: .white)
                    .textInputAutocapitalization(.never)
                
                // Password TextField
                CustomTextField(text: $password,
                               placeholder: "Password",
                               isSecure: true,
                               backgroundColor: .white)
                
                // Forgot Password Link
                Button(action: {
                    // Handle forgot password
                }) {
                    Text("Forgot Password?")
                        .foregroundColor(.gray)
                        
                }
                
                // Login Button
                CustomButtonView(
                    title: "Login",
                    isLoading: isLoading,
                    disabled: email.isEmpty || password.isEmpty,
                    type: .primary
                ) {
                    isLoading = true
                    FirebaseManager.shared.signInUser(email: email, password: password) { result in
                        isLoading = false
                        switch result {
                        case .success:
                            print("Login successful!")
                            navigateToHome = true
                        case .failure(let error):
                            print("Failed to login: \(error.localizedDescription)")
                        }
                    }
                }
                
                // NavigationLink for HomeView
                NavigationLink(destination: HomeView(), isActive: $navigateToHome) {
                    EmptyView()
                }
                
                // Divider with text
                HStack {
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray.opacity(0.3))
                    Text("Or continue with")
                        .foregroundColor(.gray)
                        .font(.footnote)
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray.opacity(0.3))
                }
                
                // Social Login Buttons
                HStack(spacing: 20) {
                    Button(action: {
                        // Handle Google login
                    }) {
                        Image("google")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.white)
                                    .shadow(color: .gray.opacity(0.2), radius: 5)
                            )
                    }
                    
                    Button(action: {
                        // Handle Apple login
                    }) {
                        Image(systemName: "apple.logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.white)
                                    .shadow(color: .gray.opacity(0.2), radius: 5)
                            )
                    }
                }
                
                // Register Link
                HStack {
                    Text("Not a member?")
                        .foregroundColor(.gray)
                    NavigationLink("Register now", destination: RegisterView())
                        .foregroundColor(Color("LoginGreen"))
                }
                
                Spacer(minLength: 50)
            }
            .padding()
        }
        .background(Color.gray.opacity(0.1))
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.gray)
                }
            }
        }
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LoginView()
        }
    }
}

