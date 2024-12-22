import SwiftUI

struct ActivityView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    let activities = ["Aktif", "Az aktif", "Aktif değil"]
    
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
            
            Text("Aktivite seviyeniz nedir?")
                .font(.custom("DynaPuff", size: 25))
                .padding(.bottom, 10)
            
            VStack(spacing: 15) {
                ForEach(activities, id: \.self) { activity in
                    ActivityCard(
                        text: activity,
                        isSelected: viewModel.activityLevel == activity,
                        theme: viewModel.selectedTheme
                    )
                    .onTapGesture {
                        viewModel.activityLevel = activity
                    }
                }
            }
            
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
            .opacity(viewModel.activityLevel.isEmpty ? 0.5 : 1)
            .disabled(viewModel.activityLevel.isEmpty)
            .padding(.bottom, 30)
        }
        .padding()
    }
}

struct ActivityCard: View {
    let text: String
    let isSelected: Bool
    let theme: OnboardingViewModel.ThemeColor
    
    var body: some View {
        HStack {
            Text(text)
                .font(.custom("DynaPuff", size: 20))
                .foregroundColor(.black)
                .padding(.leading, 20)
            
            Spacer()
            
            // Seçim göstergesi
            ZStack {
                Circle()
                    .stroke(theme.primary, lineWidth: 2)
                    .frame(width: 24, height: 24)
                
                if isSelected {
                    Circle()
                        .fill(theme.secondary)
                        .frame(width: 24, height: 24)
                }
            }
            .padding(.trailing, 20)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(isSelected ? theme.primary : theme.secondary)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(theme.primary, lineWidth: 2)
                )
        )
    }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView(viewModel: OnboardingViewModel())
    }
} 
