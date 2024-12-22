//
//  OnboardingView.swift
//  diet.io
//
//  Created by Ferhan Bayır on 19.12.2024.
//


import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    
    var body: some View {
        VStack {
            switch viewModel.currentStep {
            case .choice:
                ChoiceView(viewModel: viewModel)
            case .gender:
                GenderSelectionView(viewModel: viewModel)
            case .weightGoal:
                WeightGoalView(viewModel: viewModel)
            case .birthday:
                BirthdayInputView(viewModel: viewModel)
            case .activity:
                ActivityView(viewModel: viewModel)
            }
        }
        .transition(.slide)
        .animation(.easeInOut, value: viewModel.currentStep)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}