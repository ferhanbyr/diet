import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @Environment(\.dismiss) private var dismiss
    
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
                    .font(.title)
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
                CustomButton(title: "Login",
                            backgroundColor: Color("LoginGreen"),
                            textColor: .white) {
                    // Handle login
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
                    Button("Register now") {
                        // Handle register navigation
                    }
                    .foregroundColor(Color("LoginGreen"))
                }
                
                Spacer(minLength: 50)
            }
            .padding()
        }
        .background(Color.gray.opacity(0.1))
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.gray)
        })
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LoginView()
        }
    }
}

