//
//  BirthdayInputView.swift
//  diet.io
//
//  Created by Ferhan Bayır on 18.12.2024.
//


import SwiftUI

struct BirthdayInputView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    var body: some View {
        VStack(spacing: 30) {
            ProgressBarView(progress: viewModel.progressValue, color: viewModel.selectedTheme.primary)
                .frame(height: 10)
                .padding(.horizontal)
            
            Image(viewModel.selectedTheme.image)
                .resizable()
                .frame(width: 200, height: 350)
            
            Text("Doğum tarihiniz ne?")
                .font(.custom("DynaPuff", size: 25))
                .multilineTextAlignment(.center)
            
            HStack(spacing: 0) {
                DateInputField(text: $viewModel.birthDay, placeholder: "Gün")
                DateInputField(text: $viewModel.birthMonth, placeholder: "Ay")
                DateInputField(text: $viewModel.birthYear, placeholder: "Yıl")
            }
            
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(viewModel.selectedTheme.primary)
            )
            .padding(.horizontal)
            
            Spacer()
            
            Button(action: {
                viewModel.nextStep()
            }) {
                Image(systemName: "arrow.right")
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(viewModel.selectedTheme.primary)
                    .clipShape(Circle())
            }
            .padding(.bottom, 30)
        }
        .padding()
    }
}

struct DateInputField: View {
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        TextField("", text: $text)
            .font(.custom("DynaPuff", size: 20))
            .foregroundColor(.black)
            .tint(.black)
            .multilineTextAlignment(.center)
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .keyboardType(.numberPad)
            .background(
                ZStack(alignment: .center) {
                    Color.white.opacity(0.9)
                    if text.isEmpty {
                        Text(placeholder)
                            .foregroundColor(.black.opacity(0.4))
                            .font(.custom("DynaPuff", size: 20))
                    }
                }
            )
            .cornerRadius(15)
            .padding(5)
            .accentColor(.black)
    }
}

struct BirthdayInputView_Previews: PreviewProvider {
    static var previews: some View {
        BirthdayInputView(viewModel: OnboardingViewModel())
    }
}

