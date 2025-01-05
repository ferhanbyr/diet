import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Profil Başlığı
                ProfileHeader(profile: viewModel.userProfile)
                
                // BMI ve Hedef Bilgileri
                StatsSection(profile: viewModel.userProfile)
                
                // Hedef Seçimi
                GoalSection(profile: $viewModel.userProfile)
                
                // Kişisel Bilgiler
                PersonalInfoSection(profile: $viewModel.userProfile)
                
                // Aktivite Seviyesi
                ActivitySection(profile: $viewModel.userProfile)
                
                // Kaydet Butonu
                if let profile = viewModel.userProfile {
                    Button(action: {
                        var updatedProfile = profile
                        updatedProfile.dailyCalorieGoal = viewModel.calculateDailyCalories(for: profile)
                        viewModel.updateProfile(updatedProfile)
                        dismiss()
                    }) {
                        Text("Kaydet")
                            .font(.custom("DynaPuff", size: 16))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(profile.dietGoal.themeDarkColor))
                            .cornerRadius(15)
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .background(Color(viewModel.userProfile?.dietGoal.themeColor ?? "BrokoliAcik").opacity(0.3))
        .navigationTitle("Profil")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetchProfile()
        }
    }
}

struct ProfileInfoCard: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.custom("DynaPuff", size: 16))
                .foregroundColor(.gray)
            
            Spacer()
            
            Text(value)
                .font(.custom("DynaPuff", size: 16))
                .foregroundColor(.black)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.1), radius: 5)
    }
} 
