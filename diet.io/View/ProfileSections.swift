import SwiftUI

// MARK: - Profil Başlığı
struct ProfileHeader: View {
    let profile: UserProfile?
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 20) {
            // Profil Avatarı ve Bilgileri
            HStack(spacing: 20) {
                // Avatar
                ZStack {
                    Circle()
                        .fill(LinearGradient(
                            colors: [
                                Color(profile?.dietGoal.themeColor ?? "BrokoliAcik"),
                                Color(profile?.dietGoal.themeDarkColor ?? "BrokoliKoyu")
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(width: 80, height: 80)
                        .shadow(color: Color(profile?.dietGoal.themeDarkColor ?? "BrokoliKoyu").opacity(0.3), radius: 10)
                    
                    Text(profile?.name.prefix(1).uppercased() ?? "U")
                        .font(.custom("DynaPuff", size: 32))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Ferhan Bayır")
                        .font(.custom("DynaPuff", size: 24))
                        .foregroundColor(Color(profile?.dietGoal.themeDarkColor ?? "BrokoliKoyu"))
                    
                    Text(profile?.email ?? "")
                        .font(.custom("DynaPuff", size: 14))
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            
            // Çıkış Butonu
            Button(action: {
                withAnimation {
                    authViewModel.signOut()
                }
            }) {
                HStack {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                    Text("Çıkış Yap")
                        .font(.custom("DynaPuff", size: 14))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color.red.opacity(0.8))
                .cornerRadius(20)
                .shadow(color: .red.opacity(0.2), radius: 5)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 15, x: 0, y: 5)
        )
        .padding(.horizontal)
    }
}

// MARK: - İstatistikler Bölümü
struct StatsSection: View {
    let profile: UserProfile?
    
    var body: some View {
        VStack(spacing: 20) {
            // Başlık
            HStack {
                Text("Genel Durum")
                    .font(.custom("DynaPuff", size: 22))
                    .foregroundColor(Color(profile?.dietGoal.themeDarkColor ?? "BrokoliKoyu"))
                
                Spacer()
                
                Image(systemName: "chart.bar.fill")
                    .font(.title2)
                    .foregroundColor(Color(profile?.dietGoal.themeDarkColor ?? "BrokoliKoyu"))
            }
            .padding(.horizontal)
            
            // İstatistik Kartları
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 15),
                GridItem(.flexible(), spacing: 15)
            ], spacing: 15) {
                StatCard(
                    title: "Vücut Kitle İndeksi",
                    value: String(format: "%.1f", profile?.bmi ?? 0),
                    icon: "scalemass.fill",
                    description: getBMIDescription(bmi: profile?.bmi ?? 0),
                    color: getBMIColor(bmi: profile?.bmi ?? 0)
                )
                
                StatCard(
                    title: "Günlük Kalori",
                    value: String(format: "%.0f", profile?.dailyCalorieGoal ?? 0),
                    icon: "flame.fill",
                    description: "Hedef",
                    color: Color(profile?.dietGoal.themeDarkColor ?? "BrokoliKoyu")
                )
                
                StatCard(
                    title: "Hedef Kilo",
                    value: String(format: "%.1f kg", profile?.targetWeight ?? 0),
                    icon: "arrow.up.forward",
                    description: "Hedef",
                    color: .orange
                )
                
                StatCard(
                    title: "İlerleme",
                    value: calculateProgress(),
                    icon: "chart.line.uptrend.xyaxis",
                    description: "Kilo Farkı",
                    color: .blue
                )
            }
            .padding(.horizontal)
        }
    }
    
    private func calculateProgress() -> String {
        guard let profile = profile else { return "0 kg" }
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
    @State private var isEditing = false
    @State private var tempHeight: String = ""
    @State private var tempWeight: String = ""
    @State private var tempTargetWeight: String = ""
    @State private var tempAge: String = ""
    @State private var selectedGender: Gender = .male
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Kişisel Bilgiler")
                    .font(.custom("DynaPuff", size: 20))
                    .foregroundColor(Color(profile?.dietGoal.themeDarkColor ?? "BrokoliKoyu"))
                
                Spacer()
                
                Button(action: {
                    if isEditing {
                        saveChanges()
                    }
                    isEditing.toggle()
                }) {
                    Image(systemName: isEditing ? "checkmark.circle.fill" : "pencil.circle.fill")
                        .font(.title2)
                        .foregroundColor(Color(profile?.dietGoal.themeDarkColor ?? "BrokoliKoyu"))
                }
            }
            
            VStack(spacing: 15) {
                if isEditing {
                    EditableInfoField(title: "Boy", value: $tempHeight, unit: "cm", keyboardType: .numberPad)
                    EditableInfoField(title: "Kilo", value: $tempWeight, unit: "kg", keyboardType: .decimalPad)
                    EditableInfoField(title: "Hedef Kilo", value: $tempTargetWeight, unit: "kg", keyboardType: .decimalPad)
                    EditableInfoField(title: "Yaş", value: $tempAge, unit: "yaş", keyboardType: .numberPad)
                    
                    // Cinsiyet Seçimi
                    HStack {
                        Text("Cinsiyet")
                            .font(.custom("DynaPuff", size: 16))
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Picker("Cinsiyet", selection: $selectedGender) {
                            Text("Erkek").tag(Gender.male)
                            Text("Kadın").tag(Gender.female)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(width: 200)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color.gray.opacity(0.1), radius: 5)
                    
                } else {
                    InfoField(title: "Boy", value: "\(Int(profile?.height ?? 0)) cm")
                    InfoField(title: "Kilo", value: "\(Int(profile?.weight ?? 0)) kg")
                    InfoField(title: "Hedef Kilo", value: "\(Int(profile?.targetWeight ?? 0)) kg")
                    InfoField(title: "Yaş", value: "\(profile?.age ?? 0)")
                    InfoField(title: "Cinsiyet", value: profile?.gender.rawValue ?? "")
                    InfoField(title: "BMI", value: String(format: "%.1f (%@)", profile?.bmi ?? 0, getBMIDescription(bmi: profile?.bmi ?? 0)))
                }
            }
        }
        .padding()
        .onAppear {
            initializeFields()
        }
    }
    
    private func initializeFields() {
        tempHeight = "\(Int(profile?.height ?? 0))"
        tempWeight = "\(profile?.weight ?? 0)"
        tempTargetWeight = "\(profile?.targetWeight ?? 0)"
        tempAge = "\(profile?.age ?? 0)"
        selectedGender = profile?.gender ?? .male
    }
    
    private func saveChanges() {
        guard var updatedProfile = profile else { return }
        
        // Değerleri güncelle
        if let height = Double(tempHeight) {
            updatedProfile.height = height
        }
        if let weight = Double(tempWeight) {
            updatedProfile.weight = weight
        }
        if let targetWeight = Double(tempTargetWeight) {
            updatedProfile.targetWeight = targetWeight
        }
        if let age = Int(tempAge) {
            updatedProfile.age = age
        }
        updatedProfile.gender = selectedGender
        
        // BMI'ı otomatik hesapla
        let heightInMeters = updatedProfile.height / 100
        updatedProfile.bmiValue = updatedProfile.weight / (heightInMeters * heightInMeters)
        
        // Profili güncelle
        profile = updatedProfile
        
        // Değişiklikleri kaydet
        withAnimation {
            isEditing = false
        }
    }
    
    private func getBMIDescription(bmi: Double) -> String {
        switch bmi {
        case ..<18.5: return "Düşük Kilo"
        case 18.5..<24.9: return "Normal"
        case 24.9..<29.9: return "Fazla Kilo"
        default: return "Obez"
        }
    }
}

// Düzenlenebilir alan bileşeni
struct EditableInfoField: View {
    let title: String
    @Binding var value: String
    let unit: String
    let keyboardType: UIKeyboardType
    
    var body: some View {
        HStack {
            Text(title)
                .font(.custom("DynaPuff", size: 16))
                .foregroundColor(.gray)
            
            Spacer()
            
            TextField("", text: $value)
                .keyboardType(keyboardType)
                .multilineTextAlignment(.trailing)
                .font(.custom("DynaPuff", size: 16))
                .frame(width: 80)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Text(unit)
                .font(.custom("DynaPuff", size: 14))
                .foregroundColor(.gray)
                .frame(width: 40, alignment: .leading)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
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
    let description: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // İkon ve Değer
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Spacer()
                
                Text(value)
                    .font(.custom("DynaPuff", size: 20))
                    .foregroundColor(.primary)
            }
            
            // Başlık ve Açıklama
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.custom("DynaPuff", size: 14))
                    .foregroundColor(.gray)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                
                Text(description)
                    .font(.custom("DynaPuff", size: 12))
                    .foregroundColor(color)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(color.opacity(0.1))
                    .cornerRadius(8)
            }
        }
        .padding(15)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: color.opacity(0.1), radius: 10, x: 0, y: 5)
        )
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

// MARK: - Goal Selection View
struct GoalSelectionView: View {
    @Binding var profile: UserProfile?
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(DietGoal.allCases, id: \.self) { goal in
                GoalButton(
                    goal: goal,
                    isSelected: profile?.dietGoal == goal,
                    action: { profile?.dietGoal = goal }
                )
            }
        }
    }
}

struct GoalButton: View {
    let goal: DietGoal
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: goal.icon)
                    .font(.title3)
                
                Text(goal.rawValue)
                    .font(.custom("DynaPuff", size: 16))
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                }
            }
            .foregroundColor(isSelected ? Color(goal.themeDarkColor) : .gray)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .shadow(color: isSelected ? Color(goal.themeDarkColor).opacity(0.2) : .gray.opacity(0.1), radius: 5)
            )
        }
    }
}

// MARK: - Personal Info View
struct PersonalInfoView: View {
    @Binding var profile: UserProfile?
    @State private var isEditing = false
    @State private var tempHeight: String = ""
    @State private var tempWeight: String = ""
    @State private var tempTargetWeight: String = ""
    @State private var tempAge: String = ""
    @State private var selectedGender: Gender = .male
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Spacer()
                Button(action: {
                    if isEditing {
                        saveChanges()
                    }
                    withAnimation {
                        isEditing.toggle()
                    }
                }) {
                    Label(isEditing ? "Kaydet" : "Düzenle", 
                          systemImage: isEditing ? "checkmark.circle.fill" : "pencil.circle.fill")
                        .font(.custom("DynaPuff", size: 14))
                        .foregroundColor(Color(profile?.dietGoal.themeDarkColor ?? "BrokoliKoyu"))
                }
            }
            
            if isEditing {
                EditableInfoGroup
            } else {
                DisplayInfoGroup
            }
        }
        .onAppear { initializeFields() }
    }
    
    private var EditableInfoGroup: some View {
        VStack(spacing: 12) {
            EditableInfoField(title: "Boy", value: $tempHeight, unit: "cm", keyboardType: .numberPad)
            EditableInfoField(title: "Kilo", value: $tempWeight, unit: "kg", keyboardType: .decimalPad)
            EditableInfoField(title: "Hedef Kilo", value: $tempTargetWeight, unit: "kg", keyboardType: .decimalPad)
            EditableInfoField(title: "Yaş", value: $tempAge, unit: "yaş", keyboardType: .numberPad)
            
            GenderPicker(selectedGender: $selectedGender)
        }
    }
    
    private var DisplayInfoGroup: some View {
        VStack(spacing: 12) {
            InfoRow(title: "Boy", value: "\(Int(profile?.height ?? 0)) cm")
            InfoRow(title: "Kilo", value: "\(Int(profile?.weight ?? 0)) kg")
            InfoRow(title: "Hedef Kilo", value: "\(Int(profile?.targetWeight ?? 0)) kg")
            InfoRow(title: "Yaş", value: "\(profile?.age ?? 0)")
            InfoRow(title: "Cinsiyet", value: profile?.gender.rawValue ?? "")
        }
    }
    
    // MARK: - Helper Functions
    private func initializeFields() {
        tempHeight = "\(Int(profile?.height ?? 0))"
        tempWeight = "\(profile?.weight ?? 0)"
        tempTargetWeight = "\(profile?.targetWeight ?? 0)"
        tempAge = "\(profile?.age ?? 0)"
        selectedGender = profile?.gender ?? .male
    }
    
    private func saveChanges() {
        guard var updatedProfile = profile else { return }
        
        // Değerleri güncelle
        if let height = Double(tempHeight) {
            updatedProfile.height = height
        }
        if let weight = Double(tempWeight) {
            updatedProfile.weight = weight
        }
        if let targetWeight = Double(tempTargetWeight) {
            updatedProfile.targetWeight = targetWeight
        }
        if let age = Int(tempAge) {
            updatedProfile.age = age
        }
        updatedProfile.gender = selectedGender
        
        // BMI'ı otomatik hesapla
        let heightInMeters = updatedProfile.height / 100
        updatedProfile.bmiValue = updatedProfile.weight / (heightInMeters * heightInMeters)
        
        // Profili güncelle
        profile = updatedProfile
        
        // Düzenleme modunu kapat
        withAnimation {
            isEditing = false
        }
    }
}

// MARK: - Activity Level View
struct ActivityLevelView: View {
    @Binding var profile: UserProfile?
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(ActivityLevel.allCases, id: \.self) { level in
                ActivityButton(
                    level: level,
                    isSelected: profile?.activityLevel == level,
                    action: { profile?.activityLevel = level }
                )
            }
        }
    }
}

struct ActivityButton: View {
    let level: ActivityLevel
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(level.rawValue)
                        .font(.custom("DynaPuff", size: 16))
                    
                    Text("Çarpan: x\(String(format: "%.2f", level.multiplier))")
                        .font(.custom("DynaPuff", size: 12))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .shadow(color: isSelected ? .blue.opacity(0.2) : .gray.opacity(0.1), radius: 5)
            )
        }
        .foregroundColor(isSelected ? .blue : .gray)
    }
}

// MARK: - Helper Views
struct InfoRow: View {
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
        }
        .padding(.vertical, 8)
    }
}

struct GenderPicker: View {
    @Binding var selectedGender: Gender
    
    var body: some View {
        HStack {
            Text("Cinsiyet")
                .font(.custom("DynaPuff", size: 16))
                .foregroundColor(.gray)
            
            Spacer()
            
            Picker("Cinsiyet", selection: $selectedGender) {
                Text("Erkek").tag(Gender.male)
                Text("Kadın").tag(Gender.female)
            }
            .pickerStyle(SegmentedPickerStyle())
            .frame(width: 200)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
} 
