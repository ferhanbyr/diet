import SwiftUI

// MARK: - Profil Başlığı
struct ProfileHeader: View {
    let profile: UserProfile?
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("Hoş geldin,")
                    .font(.custom("DynaPuff", size: 16))
                    .foregroundColor(.gray)
                Text(profile?.name ?? "Kullanıcı")
                    .font(.custom("DynaPuff", size: 24))
                    .foregroundColor(Color(profile?.dietGoal.themeDarkColor ?? "BrokoliKoyu"))
            }
            
            Spacer()
            
            Button(action: {
                authViewModel.signOut()
            }) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.title2)
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.1), radius: 5)
    }
}

// MARK: - İstatistikler Bölümü
struct StatsSection: View {
    let profile: UserProfile?
    
    var body: some View {
        VStack(spacing: 15) {
            Text("İstatistikler")
                .font(.custom("DynaPuff", size: 20))
                .foregroundColor(Color(profile?.dietGoal.themeDarkColor ?? "BrokoliKoyu"))
            
            HStack(spacing: 15) {
                StatCard(
                    title: "BMI",
                    value: String(format: "%.1f", profile?.bmi ?? 0),
                    icon: "scalemass.fill"
                )
                
                StatCard(
                    title: "Hedef",
                    value: String(format: "%.0f kcal", profile?.dailyCalorieGoal ?? 0),
                    icon: "target"
                )
            }
        }
        .padding()
    }
}

// MARK: - Hedef Seçimi Bölümü
struct GoalSection: View {
    @Binding var profile: UserProfile?
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Hedefin")
                .font(.custom("DynaPuff", size: 20))
                .foregroundColor(Color(profile?.dietGoal.themeDarkColor ?? "BrokoliKoyu"))
            
            ForEach(DietGoal.allCases, id: \.self) { goal in
                Button(action: {
                    profile?.dietGoal = goal
                }) {
                    HStack {
                        Image(systemName: goal.icon)
                            .foregroundColor(Color(goal.themeDarkColor))
                        
                        Text(goal.rawValue)
                            .font(.custom("DynaPuff", size: 16))
                        
                        Spacer()
                        
                        if profile?.dietGoal == goal {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(Color(goal.themeDarkColor))
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color.gray.opacity(0.1), radius: 5)
                }
            }
        }
        .padding()
    }
}

// MARK: - Kişisel Bilgiler Bölümü
struct PersonalInfoSection: View {
    @Binding var profile: UserProfile?
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Kişisel Bilgiler")
                .font(.custom("DynaPuff", size: 20))
                .foregroundColor(Color(profile?.dietGoal.themeDarkColor ?? "BrokoliKoyu"))
            
            VStack(spacing: 15) {
                InfoField(title: "Boy", value: "\(Int(profile?.height ?? 0)) cm")
                InfoField(title: "Kilo", value: "\(Int(profile?.weight ?? 0)) kg")
                InfoField(title: "Hedef Kilo", value: "\(Int(profile?.targetWeight ?? 0)) kg")
                InfoField(title: "Yaş", value: "\(profile?.age ?? 0)")
                InfoField(title: "Cinsiyet", value: profile?.gender.rawValue ?? "")
            }
        }
        .padding()
    }
}

// MARK: - Aktivite Seviyesi Bölümü
struct ActivitySection: View {
    @Binding var profile: UserProfile?
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Aktivite Seviyesi")
                .font(.custom("DynaPuff", size: 20))
                .foregroundColor(Color(profile?.dietGoal.themeDarkColor ?? "BrokoliKoyu"))
            
            ForEach(ActivityLevel.allCases, id: \.self) { level in
                Button(action: {
                    profile?.activityLevel = level
                }) {
                    HStack {
                        Text(level.rawValue)
                            .font(.custom("DynaPuff", size: 16))
                        
                        Spacer()
                        
                        if profile?.activityLevel == level {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(Color(profile?.dietGoal.themeDarkColor ?? "BrokoliKoyu"))
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color.gray.opacity(0.1), radius: 5)
                }
            }
        }
        .padding()
    }
}

// MARK: - Yardımcı Görünümler
struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.gray)
            
            Text(title)
                .font(.custom("DynaPuff", size: 14))
                .foregroundColor(.gray)
            
            Text(value)
                .font(.custom("DynaPuff", size: 18))
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.1), radius: 5)
    }
}

struct InfoField: View {
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