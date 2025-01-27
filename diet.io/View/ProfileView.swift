import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                // MARK: - Header Section
                ProfileHeader(profile: viewModel.userProfile)
                    .padding(.horizontal)
                
                // MARK: - Main Content
                if let profile = viewModel.userProfile {
                    VStack(spacing: 24) {
                        // Stats Grid
                        StatsGridView(profile: profile)
                        
                        // Main Sections
                        Group {
                            // Goal Selection
                            SectionCard(title: "Hedef", icon: "target") {
                                GoalSelectionView(profile: $viewModel.userProfile)
                            }
                            
                            // Personal Info
                            SectionCard(title: "Kişisel Bilgiler", icon: "person.fill") {
                                PersonalInfoView(profile: $viewModel.userProfile)
                            }
                            
                            // Activity Level
                            SectionCard(title: "Aktivite Seviyesi", icon: "figure.walk") {
                                ActivityLevelView(profile: $viewModel.userProfile)
                            }
                        }
                        .padding(.horizontal)
                        
                        // Save Button
                        SaveButton(profile: profile, viewModel: viewModel, dismiss: dismiss)
                            .padding(.horizontal)
                            .padding(.top, 10)
                    }
                }
            }
            .padding(.vertical)
        }
        .background(
            Color(viewModel.userProfile?.dietGoal.themeColor ?? "BrokoliAcik")
                .opacity(0.15)
                .ignoresSafeArea()
        )
        .navigationTitle("Profil")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            withAnimation {
                viewModel.fetchProfile()
            }
        }
    }
}

// MARK: - Section Card
struct SectionCard<Content: View>: View {
    let title: String
    let icon: String
    let content: Content
    
    init(title: String, icon: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Section Header
            HStack {
                Label(title, systemImage: icon)
                    .font(.custom("DynaPuff", size: 20))
                    .foregroundColor(.primary)
                Spacer()
            }
            
            // Section Content
            content
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 10)
        )
    }
}

// MARK: - Stats Grid View
struct StatsGridView: View {
    let profile: UserProfile
    
    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 15),
            GridItem(.flexible(), spacing: 15)
        ], spacing: 15) {
            StatCard(
                title: "Vücut Kitle İndeksi",
                value: String(format: "%.1f", profile.bmi),
                icon: "scalemass.fill",
                description: getBMIDescription(bmi: profile.bmi),
                color: getBMIColor(bmi: profile.bmi)
            )
            
            StatCard(
                title: "Günlük Kalori",
                value: String(format: "%.0f", profile.dailyCalorieGoal),
                icon: "flame.fill",
                description: "Hedef",
                color: Color(profile.dietGoal.themeDarkColor)
            )
            
            StatCard(
                title: "Hedef Kilo",
                value: String(format: "%.1f kg", profile.targetWeight),
                icon: "arrow.up.forward",
                description: "Hedef",
                color: .orange
            )
            
            StatCard(
                title: "İlerleme",
                value: calculateProgress(profile: profile),
                icon: "chart.line.uptrend.xyaxis",
                description: "Kilo Farkı",
                color: .blue
            )
        }
        .padding(.horizontal)
    }
    
    private func calculateProgress(profile: UserProfile) -> String {
        let difference = profile.targetWeight - profile.weight
        return String(format: "%.1f kg", abs(difference))
    }
    
    private func getBMIDescription(bmi: Double) -> String {
        switch bmi {
        case ..<18.5: return "Düşük Kilo"
        case 18.5..<24.9: return "Normal"
        case 24.9..<29.9: return "Fazla Kilo"
        default: return "Obez"
        }
    }
    
    private func getBMIColor(bmi: Double) -> Color {
        switch bmi {
        case ..<18.5: return .orange
        case 18.5..<24.9: return .green
        case 24.9..<29.9: return .orange
        default: return .red
        }
    }
}

// MARK: - Save Button
struct SaveButton: View {
    let profile: UserProfile
    let viewModel: ProfileViewModel
    let dismiss: DismissAction
    
    var body: some View {
        Button(action: {
            withAnimation {
                var updatedProfile = profile
                updatedProfile.dailyCalorieGoal = viewModel.calculateDailyCalories(for: profile)
                viewModel.updateProfile(updatedProfile)
                dismiss()
            }
        }) {
            HStack(spacing: 12) {
                Image(systemName: "checkmark.circle.fill")
                Text("Değişiklikleri Kaydet")
                    .fontWeight(.medium)
            }
            .font(.custom("DynaPuff", size: 16))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                Color(profile.dietGoal.themeDarkColor)
                    .shadow(radius: 5)
            )
            .cornerRadius(15)
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
