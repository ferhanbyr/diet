//
//  GenderSelectionView.swift
//  diet.io
//
//  Created by Ferhan Bayır on 16.12.2024.
//


import SwiftUI

struct GenderSelectionView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            ProgressBarView(progress: viewModel.progressValue, color: viewModel.selectedTheme.primary)
                .frame(height: 10)
                .padding(.horizontal)
            
            Image(viewModel.selectedTheme.image)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 300)
            
            Text("Cinsiyetiniz ne?")
                .font(.title2)
                .fontWeight(.medium)
            
            HStack(spacing: 20) {
                Button(action: {
                    viewModel.selectedGender = .male
                    viewModel.isGenderSelected = true
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(viewModel.selectedGender == .male ? 
                                  viewModel.selectedTheme.primary : 
                                  viewModel.selectedTheme.secondary)
                            .frame(width: 80, height: 80)
                        
                        Rectangle()
                            .fill(Color.black)
                            .frame(width: 30, height: 30)
                    }
                }
                
                Button(action: {
                    viewModel.selectedGender = .female
                    viewModel.isGenderSelected = true
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(viewModel.selectedGender == .female ? 
                                  viewModel.selectedTheme.primary : 
                                  viewModel.selectedTheme.secondary)
                            .frame(width: 80, height: 80)
                        
                        Triangle()
                            .fill(Color.black)
                            .frame(width: 30, height: 30)
                    }
                }
            }
            
            Spacer()
            
            Button(action: {
                viewModel.nextStep()
            }) {
                Image(systemName: "arrow.right")
                    .foregroundColor(.black)
                    .padding(20)
                    .background(
                        Circle()
                            .fill(viewModel.selectedTheme.primary)
                    )
            }
            .opacity(viewModel.isGenderSelected ? 1 : 0.5)
            .disabled(!viewModel.isGenderSelected)
            .padding(.bottom, 60)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}

// Custom Triangle Shape
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}


// Preview Provider
struct GenderSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        GenderSelectionView(viewModel: OnboardingViewModel())
    }
}

