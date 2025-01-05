import SwiftUI

struct FoodSearchView: View {
    @StateObject private var viewModel = FoodViewModel()
    @StateObject private var homeViewModel = HomeViewModel()
    @State private var searchText = ""
    
    var body: some View {
        VStack(spacing: 0) {
            // Arama çubuğu
            HStack {
                TextField("Yemek ara...", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.custom("DynaPuff", size: 14))
                    .onSubmit {
                        if !searchText.isEmpty {
                            viewModel.searchFood(query: searchText)
                        }
                    }
                
                Button(action: {
                    if !searchText.isEmpty {
                        viewModel.searchFood(query: searchText)
                    }
                }) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Color("BrokoliKoyu"))
                }
            }
            .padding()
            
            // Debug için hata mesajını gösterelim
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.custom("DynaPuff", size: 12))
                    .padding()
            }
            
            if viewModel.isLoading {
                Spacer()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color("BrokoliKoyu")))
                Spacer()
            } else {
                ScrollView {
                    LazyVStack(spacing: 15) {
                        ForEach(viewModel.foods) { food in
                            FoodCard(food: food, homeViewModel: homeViewModel)
                                .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
            }
        }
        .background(Color("BrokoliAcik").opacity(0.3))
        .onAppear {
            // Sayfa açıldığında örnek bir arama yapalım
            viewModel.searchFood(query: "omlet")
        }
    }
}

struct FoodCard: View {
    let food: Food
    @State private var isExpanded = false
    @ObservedObject var homeViewModel: HomeViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                // Yemek bilgileri
                VStack(alignment: .leading, spacing: 4) {
                    Text(food.name)
                        .font(.custom("DynaPuff", size: 16))
                        .foregroundColor(.black)
                    
                    HStack {
                        Text(food.kalori)
                            .font(.custom("DynaPuff", size: 14))
                            .foregroundColor(Color("BrokoliKoyu"))
                        
                        Text("•")
                            .foregroundColor(.gray)
                        
                        Text(food.weight)
                            .font(.custom("DynaPuff", size: 14))
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                Button(action: {
                    // Kalori string'ini sayıya çevir (örn: "47 kcal" -> 47)
                    let kaloriString = food.kalori.components(separatedBy: " ")[0]
                    if let kalori = Double(kaloriString) {
                        // Yeni bir öğün oluştur
                        let meal = DietMeal(
                            id: UUID().uuidString,
                            name: food.name,
                            calories: kalori,
                            protein: 0, // API'den protein bilgisi gelmiyor
                            fat: 0,     // API'den yağ bilgisi gelmiyor
                            carbs: 0,   // API'den karbonhidrat bilgisi gelmiyor
                            mealType: .snack,
                            date: Date()
                        )
                        // HomeViewModel'e öğünü ekle
                        homeViewModel.addMeal(meal)
                    }
                }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(Color("BrokoliKoyu"))
                        .font(.system(size: 24))
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.2), radius: 5)
    }
} 
