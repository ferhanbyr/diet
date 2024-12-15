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
                CustomTextField(text: $UserName,
                               placeholder: "UserName",
                               backgroundColor: .white)
                    .textInputAutocapitalization(.never)
                CustomTextField(text: $email,
                               placeholder: "Email",
                               backgroundColor: .white)
                    .textInputAutocapitalization(.never)
                // Password TextField
                CustomTextField(text: $password,
                               placeholder: "Password",
                               isSecure: true,
                               backgroundColor: .white)
                CustomTextField(text: $confirmPassword,
                               placeholder: "Confirm Password",
                               isSecure: true,
                               backgroundColor: .white)
               
                
                Spacer()
                // Login Button
                CustomButton(title: "Register",
                             backgroundColor: Color("LoginGreen"),
                             textColor: .white) {
                    guard !email.isEmpty, !password.isEmpty, password == confirmPassword else {
                        print("Error: Check your inputs")
                        return
                    }
                    FirebaseManager.shared.registerUser(email: email, password: password, userName: UserName) { result in
                        switch result {
                        case .success:
                            print("User registered successfully!")
                        case .failure(let error):
                            print("Failed to register user: \(error.localizedDescription)")
                        }
                    }
                }

                
                HStack {
                    Text("Already have an account? ")
                    Text("Login")
                        .foregroundStyle(Color("LoginGreen"))
                }
                .padding(.top, 140)
                
            }
            .padding()

        }
    }
}

#Preview {
    RegisterView()
}
