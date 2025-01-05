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
        ZStack {
            switch viewModel.currentStep {
            case .choice:
                ChoiceView(viewModel: viewModel)
            case .gender:
                GenderSelectionView(viewModel: viewModel)
            case .birthday:
                BirthdayInputView(viewModel: viewModel)
            case .activity:
                ActivitySelection(viewModel: viewModel)
            case .completed:
                HomeView()
            }
        }
        .ignoresSafeArea(.all)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}