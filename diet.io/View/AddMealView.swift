import SwiftUI
import Foundation

struct AddMealView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: HomeViewModel
    let mealType: Meal.MealType
    
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
            .navigationTitle("\(mealType.title) Ekle")
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
        let meal = Meal(
            id: UUID().uuidString,
            name: name,
            calories: Double(calories) ?? 0,
            protein: Double(protein) ?? 0,
            fat: Double(fat) ?? 0,
            carbs: Double(carbs) ?? 0,
            mealType: mealType,
            date: Date()
        )
        
        viewModel.addMeal(meal)
        dismiss()
    }
} 