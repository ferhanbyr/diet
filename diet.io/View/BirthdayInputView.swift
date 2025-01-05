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
        VStack(spacing: 20) {
            // Progress Bar
            ProgressBarView(progress: viewModel.progressValue, color: viewModel.selectedTheme.primary)
                .frame(height: 10)
                .padding(.horizontal)
            
            Image(viewModel.selectedTheme.image)
                .resizable()
                .frame(width: 150, height: 300)
                .padding(.bottom, 20)
            
            Text("Doğum tarihiniz nedir?")
                .font(.custom("DynaPuff", size: 25))
                .padding(.bottom, 10)
            
            DatePicker(
                "Doğum Tarihi",
                selection: $viewModel.birthDate,
                displayedComponents: .date
            )
            .datePickerStyle(.wheel)
            .labelsHidden()
            
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

struct BirthdayInputView_Previews: PreviewProvider {
    static var previews: some View {
        BirthdayInputView(viewModel: OnboardingViewModel())
    }
}

