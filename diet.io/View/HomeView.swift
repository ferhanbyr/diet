import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var waterAmount: Double = 1500
    @State private var isTakingMedicine = false
    @State private var isTakingVitaminB12 = false
    @State private var showChatbot = false
    @State private var showBubble = true
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Ana sayfa içeriği
            mainContent
                .tag(0)
            
            // Yemekler sayfası
            Text("Yemekler")
                .tag(1)
            
            // Aktivite sayfası
            Text("Aktivite")
                .tag(2)
            
            // İstatistik sayfası
            Text("İstatistik")
                .tag(3)
            
            // Diyetisyenler sayfası
            DietitianView()
                .tag(4)
        }
        .overlay(
            TabBarView(selectedTab: $selectedTab)
                .ignoresSafeArea(.keyboard), 
            alignment: .bottom
        )
    }
    
    // Ana sayfa içeriği
    private var mainContent: some View {
        ZStack(alignment: .bottom) {
            Color("BrokoliAcik").opacity(0.3).ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 15) {
                    // Kullanıcı Profili
                    HStack {
                        Button(action: {
                            // Profil sayfasına git
                        }) {
                            HStack(spacing: 10) {
                                Image(systemName: "person.circle.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(Color("BrokoliKoyu"))
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Hoş geldin,")
                                        .font(.custom("DynaPuff", size: 14))
                                        .foregroundColor(.gray)
                                    Text("Kullanıcı Adı")
                                        .font(.custom("DynaPuff", size: 16))
                                        .foregroundColor(.black)
                                }
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    // Brokoli Karakter ve Konuşma Balonu
                    ZStack(alignment: .topTrailing) {
                        CalorieCard(
                            burnedCalories: viewModel.burnedCalories,
                            consumedCalories: viewModel.consumedCalories,
                            dailyGoal: viewModel.dailyGoal
                        )
                        
                        if showBubble {
                            SpeechBubble(message: getBrokoliMessage())
                                .offset(x: 10, y: -50)
                                .zIndex(1)
                        }
                        
                        Button(action: {
                            showChatbot = true
                        }) {
                            Image("brokoli")
                                .resizable()
                                .frame(width: 120, height: 250)
                                .offset(x: 10, y: -50)
                        }
                    }
                    
                    // Besin Değerleri
                    NutrientSection(viewModel: viewModel)
                    
                    // Öğün Butonları
                    MealSection(viewModel: viewModel)
                    
                    // Menü Zenginleştirme
                    MenuSection()
                    
                    // Su Takibi
                    WaterTrackingSection(waterAmount: $waterAmount)
                    
                    // İlaç ve Vitamin
                    MedicineSection(
                        isTakingMedicine: $isTakingMedicine,
                        isTakingVitaminB12: $isTakingVitaminB12
                    )
                    
                    Spacer(minLength: 90)
                }
                .padding(.top)
            }
            
            // Tab Bar - En altta sabit
            TabBarView(selectedTab: $selectedTab)
        }
        .ignoresSafeArea(.all, edges: .bottom)
        .sheet(isPresented: $showChatbot) {
            ChatbotView(viewModel: viewModel)
        }
        .onAppear {
            viewModel.fetchTodayCalories()
            NotificationManager.shared.requestAuthorization()
        }
    }
    
    private func getBrokoliMessage() -> String {
        let progress = viewModel.consumedCalories / viewModel.dailyGoal
        
        if progress > 0.9 {
            return "Bugün çok yedin! Biraz dikkat edelim 😅"
        } else if progress > 0.7 {
            return "Günlük hedefine yaklaşıyorsun! 🎯"
        } else if progress > 0.5 {
            return "İyi gidiyorsun! Dengeli beslenmeye devam 👍"
        } else if progress > 0.3 {
            return "Daha fazla protein almayı unutma! 💪"
        } else {
            return "Merhaba! Bugün ne yemek istersin? 😊"
        }
    }
}

// MARK: - Alt Bileşenler
struct CalorieCard: View {
    let burnedCalories: Double
    let consumedCalories: Double
    let dailyGoal: Double
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color("BrokoliKoyu"))
                .frame(height: 250)
            
            VStack(spacing: 15) {
                // Kalori göstergesi
                ZStack {
                    // Arka plan yarım daire
                    Circle()
                        .trim(from: 0, to: 0.5)
                        .stroke(Color.white.opacity(0.3), lineWidth: 15)
                        .frame(width: 0150, height: 150)
                        .rotationEffect(.degrees(180))
                    
                    // Yakılan kalori göstergesi
                    Circle()
                        .trim(from: 0, to: 0.5 * (burnedCalories / dailyGoal))
                        .stroke(Color.red.opacity(0.7), lineWidth: 15)
                        .frame(width: 150, height: 150)
                        .rotationEffect(.degrees(180))
                    
                    // Alınan kalori göstergesi
                    Circle()
                        .trim(from: 0, to: 0.5 * (consumedCalories / dailyGoal))
                        .stroke(Color.green.opacity(0.7), lineWidth: 15)
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(180))
                    
                    // Kalori değerleri
                    VStack {
                        Spacer()
                        HStack(spacing: 5) {
                            Text("\(Int(consumedCalories))")
                                .font(.custom("DynaPuff", size: 40))
                                .foregroundColor(.white)
                            Text("kal")
                                .font(.custom("DynaPuff", size: 25))
                                .foregroundColor(.white)
                        }
                        .offset(y: -30)
                    }
                }
                
                // Yakılan/Alınan göstergeleri
                HStack(spacing: 30) {
                    HStack(spacing: 8) {
                        Circle()
                            .fill(Color.red.opacity(0.7))
                            .frame(width: 10, height: 10)
                        Text("Yakılan")
                            .font(.custom("DynaPuff", size: 16))
                            .foregroundColor(.white)
                    }
                    
                    HStack(spacing: 8) {
                        Circle()
                            .fill(Color.green.opacity(0.7))
                            .frame(width: 10, height: 10)
                        Text("Alınan")
                            .font(.custom("DynaPuff", size: 16))
                            .foregroundColor(.white)
                    }
                }
            }
            .padding()
        }
        .padding(.horizontal)
    }
}

struct NutrientSection: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack(spacing: 15) {
            NutrientBar(title: "Yağ", value: viewModel.fatProgress)
            NutrientBar(title: "Protein", value: viewModel.proteinProgress)
            NutrientBar(title: "Karbonhidrat", value: viewModel.carbsProgress)
        }
        .padding(.horizontal)
    }
}

struct MealSection: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack(spacing: 15) {
            HStack(spacing: 15) {
                MealButton(title: "Kahvaltı", viewModel: viewModel, mealType: .breakfast)
                MealButton(title: "Öğle yemeği", viewModel: viewModel, mealType: .lunch)
            }
            
            HStack(spacing: 15) {
                MealButton(title: "Akşam yemeği", viewModel: viewModel, mealType: .dinner)
                MealButton(title: "Atıştırma", viewModel: viewModel, mealType: .snack)
            }
        }
        .padding(.horizontal)
    }
}

struct MenuSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Menülerini zenginleştir")
                .font(.custom("DynaPuff", size: 18))
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(1...3, id: \.self) { _ in
                        Image("food")
                            .resizable()
                            .frame(width: 120, height: 150)
                            .cornerRadius(15)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct WaterTrackingSection: View {
    @Binding var waterAmount: Double
    @State private var showAddWater = false
    let dailyWaterGoal: Double = 2000 // ml cinsinden günlük hedef
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Su içimini takip et")
                    .font(.custom("DynaPuff", size: 18))
                
                Spacer()
                
                Button(action: {
                    showAddWater = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(Color("BrokoliKoyu"))
                }
            }
            .padding(.horizontal)
            
            VStack(spacing: 8) {
                ZStack(alignment: .leading) {
                    // Arka plan
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.blue.opacity(0.1))
                        .frame(height: 60)
                    
                    // Su miktarı göstergesi
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.blue)
                        .frame(width: min(UIScreen.main.bounds.width * CGFloat(waterAmount / dailyWaterGoal), UIScreen.main.bounds.width - 40), height: 60)
                        .animation(.spring(), value: waterAmount)
                }
                
                HStack {
                    Text("\(Int(waterAmount))ml / \(Int(dailyWaterGoal))ml")
                        .font(.custom("DynaPuff", size: 14))
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    // Su bardağı ölçüleri
                    HStack(spacing: 15) {
                        WaterButton(amount: 200, waterAmount: $waterAmount)
                        WaterButton(amount: 300, waterAmount: $waterAmount)
                        WaterButton(amount: 500, waterAmount: $waterAmount)
                    }
                }
            }
            .padding(.horizontal)
        }
        .sheet(isPresented: $showAddWater) {
            AddWaterView(waterAmount: $waterAmount)
        }
    }
}

struct WaterButton: View {
    let amount: Int
    @Binding var waterAmount: Double
    
    var body: some View {
        Button(action: {
            waterAmount += Double(amount)
            WaterReminderManager.shared.scheduleNextReminder()
        }) {
            VStack(spacing: 2) {
                Image(systemName: "drop.fill")
                    .foregroundColor(.blue)
                Text("\(amount)ml")
                    .font(.custom("DynaPuff", size: 12))
                    .foregroundColor(.blue)
            }
            .padding(8)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(10)
        }
    }
}

struct AddWaterView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var waterAmount: Double
    @State private var customAmount: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Özel miktar girin")) {
                    TextField("ml cinsinden miktar", text: $customAmount)
                        .keyboardType(.numberPad)
                        .font(.custom("DynaPuff", size: 16))
                }
            }
            .navigationTitle("Su Ekle")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("İptal") {
                    dismiss()
                },
                trailing: Button("Ekle") {
                    if let amount = Double(customAmount) {
                        waterAmount += amount
                        WaterReminderManager.shared.scheduleNextReminder()
                    }
                    dismiss()
                }
                .disabled(Double(customAmount) == nil)
            )
        }
    }
}

struct MedicineSection: View {
    @Binding var isTakingMedicine: Bool
    @Binding var isTakingVitaminB12: Bool
    @State private var showMedicineTimePicker = false
    @State private var showVitaminTimePicker = false
    @State private var medicineTime = Date()
    @State private var vitaminTime = Date()
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Toggle("A ilacı", isOn: $isTakingMedicine)
                    .toggleStyle(SwitchToggleStyle(tint: Color("BrokoliKoyu")))
                    .onChange(of: isTakingMedicine) { newValue in
                        if newValue {
                            showMedicineTimePicker = true
                        } else {
                            NotificationManager.shared.removeNotification(for: .medicine)
                        }
                    }
                
                if isTakingMedicine {
                    Button(action: {
                        showMedicineTimePicker = true
                    }) {
                        Text(timeString(from: medicineTime))
                            .font(.custom("DynaPuff", size: 14))
                            .foregroundColor(Color("BrokoliKoyu"))
                    }
                }
            }
            
            HStack {
                Toggle("B12 vitamini", isOn: $isTakingVitaminB12)
                    .toggleStyle(SwitchToggleStyle(tint: Color("BrokoliKoyu")))
                    .onChange(of: isTakingVitaminB12) { newValue in
                        if newValue {
                            showVitaminTimePicker = true
                        } else {
                            NotificationManager.shared.removeNotification(for: .vitaminB12)
                        }
                    }
                
                if isTakingVitaminB12 {
                    Button(action: {
                        showVitaminTimePicker = true
                    }) {
                        Text(timeString(from: vitaminTime))
                            .font(.custom("DynaPuff", size: 14))
                            .foregroundColor(Color("BrokoliKoyu"))
                    }
                }
            }
        }
        .padding(.horizontal)
        .font(.custom("DynaPuff", size: 16))
        .sheet(isPresented: $showMedicineTimePicker) {
            TimePickerView(selectedTime: $medicineTime, title: "İlaç Saati") {
                NotificationManager.shared.scheduleNotification(
                    for: .medicine,
                    at: medicineTime
                )
            }
        }
        .sheet(isPresented: $showVitaminTimePicker) {
            TimePickerView(selectedTime: $vitaminTime, title: "B12 Vitamini Saati") {
                NotificationManager.shared.scheduleNotification(
                    for: .vitaminB12,
                    at: vitaminTime
                )
            }
        }
    }
    
    private func timeString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct TimePickerView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedTime: Date
    let title: String
    let onSave: () -> Void
    
    var body: some View {
        NavigationView {
            VStack {
                DatePicker(
                    title,
                    selection: $selectedTime,
                    displayedComponents: .hourAndMinute
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
            }
            .padding()
            .navigationBarItems(
                leading: Button("İptal") {
                    dismiss()
                },
                trailing: Button("Kaydet") {
                    onSave()
                    dismiss()
                }
            )
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct TabBarView: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack(spacing: 0) {
            TabBarButton(
                image: "house.fill",
                title: "Ana Sayfa",
                isSelected: selectedTab == 0
            ) {
                selectedTab = 0
            }
            
            TabBarButton(
                image: "fork.knife",
                title: "Yemekler",
                isSelected: selectedTab == 1
            ) {
                selectedTab = 1
            }
            
            TabBarButton(
                image: "figure.run",
                title: "Aktivite",
                isSelected: selectedTab == 2
            ) {
                selectedTab = 2
            }
            
            TabBarButton(
                image: "chart.bar.fill",
                title: "İstatistik",
                isSelected: selectedTab == 3
            ) {
                selectedTab = 3
            }
            
            TabBarButton(
                image: "stethoscope",
                title: "Diyetisyen",
                isSelected: selectedTab == 4
            ) {
                selectedTab = 4
            }
        }
        .padding(.vertical, 15)
        .background(Color.white)
        .cornerRadius(25, corners: [.topLeft, .topRight])
        .shadow(color: .gray.opacity(0.2), radius: 5, y: -5)
    }
}

struct TabBarButton: View {
    let image: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: image)
                    .font(.system(size: 24))
                Text(title)
                    .font(.custom("DynaPuff", size: 12))
            }
            .foregroundColor(isSelected ? Color("BrokoliKoyu") : .gray)
            .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - Yardımcı View'lar
struct NutrientBar: View {
    let title: String
    let value: CGFloat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.custom("DynaPuff", size: 16))
            
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 10)
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color("BrokoliKoyu"))
                    .frame(width: UIScreen.main.bounds.width * 0.8 * value, height: 10)
            }
        }
    }
}

struct MealButton: View {
    let title: String
    @ObservedObject var viewModel: HomeViewModel
    @State private var showAddMeal = false
    let mealType: Meal.MealType
    
    var body: some View {
        Button(action: {
            showAddMeal = true
        }) {
            HStack {
                Text(title)
                    .font(.custom("DynaPuff", size: 16))
                    .foregroundColor(.black)
                Spacer()
                Image(systemName: "plus")
                    .foregroundColor(.black)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: .gray.opacity(0.2), radius: 5)
        }
        .sheet(isPresented: $showAddMeal) {
            AddMealView(viewModel: viewModel, mealType: mealType)
        }
    }
}

// Özel köşe yuvarlama için extension
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

struct SpeechBubble: View {
    let message: String
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            VStack(alignment: .leading) {
                Text(message)
                    .font(.custom("DynaPuff", size: 16))
                    .foregroundColor(.black)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: .gray.opacity(0.2), radius: 5)
                    )
                    .frame(maxWidth: 250)
                
                // Üçgen şekil
                Path { path in
                    path.move(to: CGPoint(x: 200, y: 0))
                    path.addLine(to: CGPoint(x: 220, y: 15))
                    path.addLine(to: CGPoint(x: 180, y: 0))
                }
                .fill(Color.white)
                .frame(width: 220, height: 15)
                .offset(x: -20)
            }
        }
    }
}

struct ChatbotView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: HomeViewModel
    @State private var message = ""
    @State private var chatMessages: [ChatMessage] = []
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 15) {
                        ForEach(chatMessages) { message in
                            ChatBubble(message: message)
                        }
                    }
                    .padding()
                }
                
                HStack {
                    TextField("Mesajınız...", text: $message)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: sendMessage) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(Color("BrokoliKoyu"))
                    }
                }
                .padding()
            }
            .navigationTitle("Brokoli ile Sohbet")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Kapat") {
                dismiss()
            })
        }
    }
    
    private func sendMessage() {
        guard !message.isEmpty else { return }
        
        let userMessage = ChatMessage(text: message, isUser: true)
        chatMessages.append(userMessage)
        
        // Brokoli'nin cevabı
        let response = generateBrokoliResponse(to: message)
        let brokoliMessage = ChatMessage(text: response, isUser: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            chatMessages.append(brokoliMessage)
        }
        
        message = ""
    }
    
    private func generateBrokoliResponse(to message: String) -> String {
        // Basit bir chatbot mantığı
        let lowercasedMessage = message.lowercased()
        
        if lowercasedMessage.contains("kilo") {
            return "Kilo kontrolü için dengeli beslenme ve düzenli egzersiz çok önemli! Sana bu konuda yardımcı olabilirim 💪"
        } else if lowercasedMessage.contains("yemek") || lowercasedMessage.contains("yiyecek") {
            return "Sağlıklı yemek önerileri için buradayım! Ne tür yemekler seversin? 🥗"
        } else if lowercasedMessage.contains("protein") {
            return "Protein için en iyi kaynaklar: yumurta, tavuk, balık, baklagiller! Günlük protein hedefin: \(Int(viewModel.proteinGoal))g 🥚"
        } else {
            return "Sağlıklı beslenme konusunda sana yardımcı olmak için buradayım! Başka neler sormak istersin? 😊"
        }
    }
}

struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
}

struct ChatBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isUser { Spacer() }
            
            Text(message.text)
                .padding(10)
                .background(
                    message.isUser ? Color("BrokoliKoyu") : Color.gray.opacity(0.2)
                )
                .foregroundColor(message.isUser ? .white : .black)
                .cornerRadius(15)
                .frame(maxWidth: UIScreen.main.bounds.width * 0.7, alignment: message.isUser ? .trailing : .leading)
            
            if !message.isUser { Spacer() }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
} 
