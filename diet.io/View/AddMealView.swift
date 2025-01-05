import SwiftUI
import Foundation

struct AddMealView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: HomeViewModel
    let mealType: DietMeal.MealType
    
    @State private var name = ""
    @State private var calories = ""
    @State private var protein = ""
    @State private var fat = ""
    @State private var carbs = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Yemek Bilgileri")) {
                    TextField("Yemek Adı", text: $name)
                        .font(.custom("DynaPuff", size: 16))
                    
                    TextField("Kalori", text: $calories)
                        .keyboardType(.decimalPad)
                        .font(.custom("DynaPuff", size: 16))
                    
                    TextField("Protein (g)", text: $protein)
                        .keyboardType(.decimalPad)
                        .font(.custom("DynaPuff", size: 16))
                    
                    TextField("Yağ (g)", text: $fat)
                        .keyboardType(.decimalPad)
                        .font(.custom("DynaPuff", size: 16))
                    
                    TextField("Karbonhidrat (g)", text: $carbs)
                        .keyboardType(.decimalPad)
                        .font(.custom("DynaPuff", size: 16))
                }
            }
            .navigationTitle("\(mealType.rawValue) Ekle")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("İptal") {
                    dismiss()
                },
                trailing: Button("Kaydet") {
                    saveMeal()
                }
                .disabled(name.isEmpty || calories.isEmpty)
            )
        }
    }
    
    private func saveMeal() {
        guard let caloriesDouble = Double(calories),
              let proteinDouble = Double(protein),
              let fatDouble = Double(fat),
              let carbsDouble = Double(carbs) else {
            print("Error converting values to Double")
            return
        }
        
        let meal = DietMeal(
            id: UUID().uuidString,
            name: name,
            calories: caloriesDouble,
            protein: proteinDouble,
            fat: fatDouble,
            carbs: carbsDouble,
            mealType: mealType,
            date: Date()
        )
        
        viewModel.addMeal(meal)
        dismiss()
    }
}

// Preview Provider
struct AddMealView_Previews: PreviewProvider {
    static var previews: some View {
        AddMealView(viewModel: HomeViewModel(), mealType: .breakfast)
    }
} 
