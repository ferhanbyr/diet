import SwiftUI
import FirebaseAuth
struct LoginView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @Environment(\.dismiss) private var dismiss
    @State private var showRegister = false
    @State private var isLoading = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                VStack(spacing: 8) {
                    Image("intro")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 220, height: 220)
                    
                    Text("welcome")
                        .font(.custom("DynaPuff", size: 32))
                        .fontWeight(.medium)
                }
                .padding(.top, 20)
                
                VStack(spacing: 16) {
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
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .textContentType(.oneTimeCode)
                        .disableAutocorrection(true)
                    
                    // Forgot Password Link
                    HStack {
                        Spacer()
                        Button(action: {
                            // Handle forgot password
                        }) {
                            Text("Forgot Password?")
                                .foregroundColor(.gray)
                                .font(.footnote)
                        }
                    }
                }
                .padding(.top, 20)
                
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
                            DispatchQueue.main.async {
                                authViewModel.isLoggedIn = true
                            }
                        case .failure(let error):
                            print("Failed to login: \(error.localizedDescription)")
                        }
                    }
                }
                .padding(.top, 8)
                
                // Divider
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
                .padding(.vertical, 16)
                
                // Social Login Buttons
                HStack(spacing: 20) {
                    Button(action: {
                        // Handle Google login
                    }) {
                        Image("google")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
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
                            .frame(width: 30, height: 30)
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
                .padding(.top, 16)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
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

