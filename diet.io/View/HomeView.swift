import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var selectedTab = 0
    @State private var showAddMeal = false
    @State private var selectedMealType: DietMeal.MealType?
    
    init() {
        UITabBar.appearance().unselectedItemTintColor = UIColor.gray
    }
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                mainContent
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Ana Sayfa")
                    }
                    .tag(0)
                
                FoodSearchView()
                    .tabItem {
                        Image(systemName: "fork.knife.circle.fill")
                        Text("Tarifler")
                    }
                    .tag(1)
                
                ChatView()
                    .tabItem {
                        Image(systemName: "message.circle.fill")
                        Text("Chat")
                    }
                    .tag(2)
                
                ExerciseView()
                    .tabItem {
                        Image(systemName: "figure.run.circle.fill")
                        Text("Egzersizler")
                    }
                    .tag(3)
                
                ProfileView()
                    .tabItem {
                        Image(systemName: "person.circle.fill")
                        Text("Profil")
                    }
                    .tag(4)
            }
            .sheet(isPresented: $showAddMeal) {
                if let mealType = selectedMealType {
                    AddMealView(viewModel: viewModel, mealType: mealType)
                }
            }
        }
        .accentColor(.brokoliKoyu)
    }
    
    private var mainContent: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 25) {
                UserProfileHeader(userName: viewModel.userName)
                
                CalorieCard(
                    burnedCalories: viewModel.burnedCalories,
                    consumedCalories: viewModel.consumedCalories,
                    dailyGoal: viewModel.dailyGoal
                )
                .shadow(color: Color("BrokoliKoyu").opacity(0.2), radius: 10)
                
                DashboardGrid(viewModel: viewModel, selectedMealType: $selectedMealType, showAddMeal: $showAddMeal)
                
                WaterTrackingView(viewModel: viewModel)
                    .padding(.horizontal)
                
                NavigationLink(destination: WeeklyStatsDetailView(weeklyStats: viewModel.weeklyStats)) {
                    WeeklyStatsCard(stats: viewModel.weeklyStats)
                        .padding(.horizontal)
                }
            }
            .padding(.bottom, 90)
        }
        .background(Color("BrokoliAcik").opacity(0.3))
        .refreshable {
            await refreshData()
        }
        .onAppear {
            setupInitialData()
        }
        .onChange(of: selectedTab) { newValue in
            if newValue == 0 {
                refreshDataOnTabChange()
            }
        }
    }
    
    private func setupInitialData() {
        viewModel.checkAndResetDailyStats()
        viewModel.fetchProfile()
        viewModel.fetchWeeklyStats()
        viewModel.fetchTodayMeals()
        viewModel.fetchTodayWater()
    }
    
    private func refreshData() async {
        viewModel.checkAndResetDailyStats()
        viewModel.fetchProfile()
        viewModel.fetchWeeklyStats()
        viewModel.fetchTodayMeals()
        viewModel.fetchTodayWater()
    }
    
    private func refreshDataOnTabChange() {
        viewModel.fetchTodayWater()
        viewModel.fetchTodayMeals()
        viewModel.fetchWeeklyStats()
    }
}

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
                        .frame(width: 150, height: 150)
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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
