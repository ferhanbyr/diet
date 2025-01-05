import SwiftUI

struct MacroNutrientBar: View {
    let title: String
    let value: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.custom("DynaPuff", size: 14))
                    .foregroundColor(.black)
                
                Spacer()
                
                Text("\(Int(value * 100))%")
                    .font(.custom("DynaPuff", size: 12))
                    .foregroundColor(Color("BrokoliKoyu"))
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Arka plan
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color("BrokoliKoyu").opacity(0.2))
                        .frame(height: 8)
                    
                    // İlerleme çubuğu
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color("BrokoliKoyu"))
                        .frame(width: geometry.size.width * value, height: 8)
                        .animation(.spring(), value: value)
                }
            }
            .frame(height: 8)
        }
    }
}

#Preview {
    VStack {
        MacroNutrientBar(title: "Protein", value: 0.7)
        MacroNutrientBar(title: "Karbonhidrat", value: 0.5)
        MacroNutrientBar(title: "Yağ", value: 0.3)
    }
    .padding()
} 