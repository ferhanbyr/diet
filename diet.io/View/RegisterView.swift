//
//  RegisterView.swift
//  diet.io
//
//  Created by Ferhan Bayır on 14.12.2024.
//

import SwiftUI

struct RegisterView: View {
    @State private var UserName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var navigateToOnboarding = false
    @State private var isLoading = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Spacer(minLength: 50)
                
                // Lock Icon
                Image("intro")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                
                Text("welcome")
                    .font(.custom("DynaPuff", size: 35))
                    .fontWeight(.medium)
                
                // TextFields
                CustomTextField(text: $UserName,
                              placeholder: "UserName",
                              backgroundColor: .white)
                    .textInputAutocapitalization(.never)
                
                CustomTextField(text: $email,
                              placeholder: "Email",
                              backgroundColor: .white)
                    .textInputAutocapitalization(.never)
                
                CustomTextField(text: $password,
                              placeholder: "Password",
                              isSecure: true,
                              backgroundColor: .white)
                
                CustomTextField(text: $confirmPassword,
                              placeholder: "Confirm Password",
                              isSecure: true,
                              backgroundColor: .white)
                
                Spacer()
                
                CustomButtonView(
                    title: "Register",
                    isLoading: isLoading,
                    disabled: email.isEmpty || password.isEmpty || confirmPassword.isEmpty || UserName.isEmpty,
                    type: .primary
                ) {
                    guard password == confirmPassword else {
                        print("Error: Passwords don't match")
                        return
                    }
                    
                    isLoading = true
                    FirebaseManager.shared.registerUser(email: email, password: password, userName: UserName) { result in
                        isLoading = false
                        switch result {
                        case .success:
                            print("User registered successfully!")
                            navigateToOnboarding = true
                        case .failure(let error):
                            print("Failed to register user: \(error.localizedDescription)")
                        }
                    }
                }
                
            
                NavigationStack {
                    EmptyView()
                        .navigationDestination(isPresented: $navigateToOnboarding) {
                            OnboardingView()
                        }
                }
                Spacer()
                HStack {
                    Text("Already have an account? ")
                        .foregroundColor(.gray)
                    Button("Login") {
                        dismiss()
                    }
                    .foregroundColor(Color("LoginGreen"))
                }
                .padding(.top, 20)
                
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

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RegisterView()
        }
    }
}
