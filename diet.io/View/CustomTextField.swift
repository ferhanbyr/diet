//
//  CustomTextField.swift
//  diet.io
//
//  Created by Ferhan Bayır on 14.12.2024.
//

import SwiftUI

struct CustomTextField: View {
    @Binding var text: String
    let placeholder: String
    var isSecure: Bool = false
    var backgroundColor: Color = .white
    
    var body: some View {
        Group {
            if isSecure {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
            }
        }
        .textFieldStyle(.plain)
        .padding()
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(backgroundColor)
                .shadow(color: .gray.opacity(0.2), radius: 5)
        )
        .textInputAutocapitalization(.never)
    }
}
#Preview {
    LoginView()
}
