//
//  CustomTextField.swift
//  diet.io
//
//  Created by Ferhan Bayır on 14.12.2024.
//

import SwiftUI

struct CustomTextField: View {
    @Binding var text: String
    var placeholder: String
    var isSecure: Bool = false
    var backgroundColor: Color
    
    var body: some View {
        Group {
            if isSecure {
                SecureField(placeholder, text: $text)
                    .frame(width: .infinity, height: 30)
            } else {
                TextField(placeholder, text: $text)
                    .frame(width: .infinity, height: 30)


            }
            
        }
        .padding()
        .background(backgroundColor)
        .cornerRadius(10)
        .shadow(color: .gray.opacity(0.3), radius: 5)
    }
}
#Preview {
    LoginView()
}
