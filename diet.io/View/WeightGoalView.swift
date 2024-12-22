import SwiftUI

struct WeightGoalView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    var body: some View {
        VStack(spacing: 25) {
            // Progress Bar
            ProgressBarView(progress: viewModel.progressValue, color: viewModel.selectedTheme.primary)
                .frame(height: 10)
                .padding(.horizontal)
            
            Image(viewModel.selectedTheme.image)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 300)
            
            VStack(spacing: 20) {
                WTextField(text: $viewModel.height, label: "Boy", onEditingChanged: viewModel.calculateBMI, theme: viewModel.selectedTheme)
                WTextField(text: $viewModel.weight, label: "Kilo", onEditingChanged: viewModel.calculateBMI, theme: viewModel.selectedTheme)
                WTextField(text: $viewModel.targetWeight, label: "Hedef kilo", theme: viewModel.selectedTheme)
            }
            
            if let bmi = viewModel.bmi {
                Text("Vücut Kitle İndeksi: \(bmi, specifier: "%.1f")")
                    .font(.custom("DynaPuff", size: 20))
                    .padding(.top, 10)
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
            .padding(.bottom, 40)
        }
        .padding(.horizontal, 20)
        .padding(.top, 40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}

struct WTextField: View {
    @Binding var text: String
    let label: String
    var onEditingChanged: (() -> Void)?
    let theme: OnboardingViewModel.ThemeColor
    
    var body: some View {
        ZStack(alignment: .trailing) {
            RoundedRectangle(cornerRadius: 15)
                .stroke(theme.primary, lineWidth: 3)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(theme.secondary)
                )
                .frame(height: 65)
            
            HStack {
                TextField("", text: $text)
                    .onChange(of: text) { _ in
                        onEditingChanged?()
                    }
                    .font(.custom("DynaPuff", size: 20))
                    .keyboardType(.numberPad)
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity)
                
                Text(label)
                    .font(.custom("DynaPuff", size: 20))
                    .foregroundColor(.black)
                    .padding(.trailing, 20)
                    .lineLimit(1)
            }
        }
    }
}

// Color Extension for Hex Colors

// Preview Provider
struct WeightGoalView_Previews: PreviewProvider {
    static var previews: some View {
        WeightGoalView(viewModel: OnboardingViewModel())
    }
}

