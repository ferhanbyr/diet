import SwiftUI

struct DashboardGrid: View {
    @ObservedObject var viewModel: HomeViewModel
    @Binding var selectedMealType: DietMeal.MealType?
    @Binding var showAddMeal: Bool
    
    var body: some View {
        VStack(spacing: 15) {
            // Makro Besinler
            VStack(spacing: 10) {
                Text("Makro Besinler")
                    .font(.custom("DynaPuff", size: 18))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(spacing: 12) {
                    MacroNutrientBar(title: "Protein", value: viewModel.proteinProgress)
                    MacroNutrientBar(title: "Karbonhidrat", value: viewModel.carbsProgress)
                    MacroNutrientBar(title: "Yağ", value: viewModel.fatProgress)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(20)
            
            // Öğünler Grid
            VStack(spacing: 10) {
                Text("Öğünler")
                    .font(.custom("DynaPuff", size: 18))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(DietMeal.MealType.allCases, id: \.self) { mealType in
                        Button(action: {
                            selectedMealType = mealType
                            showAddMeal = true
                        }) {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: mealTypeIcon(mealType))
                                        .font(.system(size: 20))
                                    Spacer()
                                    Image(systemName: "plus.circle.fill")
                                        .font(.system(size: 20))
                                }
                                .foregroundColor(Color("BrokoliKoyu"))
                                
                                Text(mealType.rawValue)
                                    .font(.custom("DynaPuff", size: 14))
                                    .foregroundColor(.black)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.8)
                            }
                            .padding(12)
                            .background(Color("BrokoliKoyu").opacity(0.1))
                            .cornerRadius(15)
                        }
                    }
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(20)
        }
        .padding(.horizontal)
    }
    
    private func mealTypeIcon(_ type: DietMeal.MealType) -> String {
        switch type {
        case .breakfast: return "sun.and.horizon.fill"
        case .lunch: return "sun.max.fill"
        case .dinner: return "moon.fill"
        case .snack: return "leaf.fill"
        }
    }
} 