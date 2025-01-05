import SwiftUI

struct CalorieAndWaterTrackingView: View {
    @ObservedObject var viewModel: HomeViewModel
    @Binding var showWaterReminderSettings: Bool
    
    var body: some View {
        HStack(spacing: 15) {
            // Kalori Kartı
            VStack {
                Text("Günlük Kalori")
                    .font(.custom("DynaPuff", size: 14))
                    .foregroundColor(.gray)
                
                Text("\(Int(viewModel.consumedCalories))/\(Int(viewModel.dailyGoal))")
                    .font(.custom("DynaPuff", size: 24))
                    .foregroundColor(Color("BrokoliKoyu"))
                
                let progress = viewModel.consumedCalories / viewModel.dailyGoal
                ProgressBarView(
                    progress: progress,
                    color: Color("BrokoliKoyu")
                )
                .frame(height: 10)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: Color.gray.opacity(0.1), radius: 5)
            
            // Su Takibi
            WaterTrackingView(viewModel: viewModel)
        }
        .padding(.horizontal)
    }
} 
