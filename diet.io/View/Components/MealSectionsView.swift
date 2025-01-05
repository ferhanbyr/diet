import SwiftUI

struct MealSectionsView: View {
    @ObservedObject var viewModel: HomeViewModel
    @Binding var showAddMeal: Bool
    @Binding var selectedMealType: DietMeal.MealType?
    
    var body: some View {
        VStack(spacing: 20) {
            ForEach(DietMeal.MealType.allCases, id: \.self) { mealType in
                let filteredMeals = viewModel.meals.filter { $0.mealType == mealType }
                MealSection(
                    mealType: mealType,
                    meals: filteredMeals,
                    onAddTap: {
                        selectedMealType = mealType
                        showAddMeal = true
                    },
                    onDeleteMeal: { meal in
                        viewModel.deleteMeal(meal)
                    }
                )
            }
        }
        .padding(.horizontal)
    }
}

struct MealSection: View {
    let mealType: DietMeal.MealType
    let meals: [DietMeal]
    let onAddTap: () -> Void
    let onDeleteMeal: (DietMeal) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text(mealType.rawValue)
                    .font(.headline)
                    .foregroundColor(Color("BrokoliKoyu"))
                
                Spacer()
                
                Button(action: onAddTap) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(Color("BrokoliKoyu"))
                        .font(.title2)
                }
            }
            
            if meals.isEmpty {
                Text("Henüz öğün eklenmemiş")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.vertical, 8)
            } else {
                ForEach(meals) { meal in
                    MealRow(meal: meal)
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                onDeleteMeal(meal)
                            } label: {
                                Label("Sil", systemImage: "trash")
                            }
                        }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.2), radius: 5)
    }
}

struct MealRow: View {
    let meal: DietMeal
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(meal.name)
                    .font(.headline)
                
                Text("\(Int(meal.calories)) kcal")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(Int(meal.protein))g protein")
                Text("\(Int(meal.carbs))g karb")
                Text("\(Int(meal.fat))g yağ")
            }
            .font(.footnote)
            .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    MealSectionsView(
        viewModel: HomeViewModel(),
        showAddMeal: .constant(false),
        selectedMealType: .constant(nil)
    )
} 