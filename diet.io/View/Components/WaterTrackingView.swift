import SwiftUI

struct WaterTrackingView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Su Takibi")
                .font(.custom("DynaPuff", size: 18))
                .foregroundColor(.black)
            
            HStack(spacing: 20) {
                // Su dalgası animasyonu
                WaterWaveView(progress: min(viewModel.waterAmount / viewModel.dailyWaterGoal, 1.0))
                    .frame(width: 150, height: 150)
                
                VStack(spacing: 15) {
                    // Su ekleme butonları
                    HStack(spacing: 10) {
                        WaterButton(amount: 200, viewModel: viewModel)
                        WaterButton(amount: 300, viewModel: viewModel)
                    }
                    
                    HStack(spacing: 10) {
                        WaterButton(amount: 400, viewModel: viewModel)
                        WaterButton(amount: 500, viewModel: viewModel)
                    }
                }
            }
            
            // Toplam su miktarı
            HStack {
                Text("\(Int(viewModel.waterAmount)) / \(Int(viewModel.dailyWaterGoal)) ml")
                    .font(.custom("DynaPuff", size: 14))
                    .foregroundColor(.black)
                
                Spacer()
                
                // Reset butonu
                Button(action: {
                    withAnimation {
                        viewModel.updateWaterAmount(0)
                    }
                }) {
                    Image(systemName: "arrow.counterclockwise")
                        .foregroundColor(Color("BrokoliKoyu"))
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
    }
}

struct WaterButton: View {
    let amount: Int
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        Button(action: {
            withAnimation(.spring()) {
                viewModel.addWater(Double(amount))
            }
        }) {
            VStack(spacing: 5) {
                Image(systemName: "drop.fill")
                    .foregroundColor(Color("BrokoliKoyu"))
                Text("\(amount)ml")
                    .font(.custom("DynaPuff", size: 12))
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(Color("BrokoliKoyu").opacity(0.1))
            .cornerRadius(10)
        }
    }
}

struct WaterWaveView: View {
    let progress: Double
    @State private var waveOffset = Angle(degrees: 0)
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Arka plan
                Circle()
                    .fill(Color("BrokoliKoyu").opacity(0.1))
                
                // Su dalgası
                WaterWave(progress: progress, waveHeight: 0.015, offset: waveOffset)
                    .fill(Color("BrokoliKoyu").opacity(0.3))
                    .clipShape(Circle())
                
                // İkinci dalga (efekt için)
                WaterWave(progress: progress, waveHeight: 0.02, offset: waveOffset)
                    .fill(Color("BrokoliKoyu").opacity(0.5))
                    .clipShape(Circle())
                
                // Miktar göstergesi
                VStack(spacing: 5) {
                    Text("\(Int(progress * 100))%")
                        .font(.custom("DynaPuff", size: 24))
                        .foregroundColor(.black)
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .onAppear {
            withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                waveOffset = Angle(degrees: 360)
            }
        }
    }
}

struct WaterWave: Shape {
    var progress: Double
    var waveHeight: Double
    var offset: Angle
    
    var animatableData: Double {
        get { offset.degrees }
        set { offset = Angle(degrees: newValue) }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let progressHeight: CGFloat = (1 - CGFloat(progress)) * rect.height
        let height = waveHeight * rect.height
        
        path.move(to: CGPoint(x: 0, y: rect.height))
        
        for x in stride(from: 0, through: rect.width, by: 1) {
            let relativeX = x / rect.width
            let sine = sin(relativeX * .pi * 4 + offset.radians)
            let y = progressHeight + sine * height
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.closeSubpath()
        
        return path
    }
}

#Preview {
    WaterTrackingView(viewModel: HomeViewModel())
        .padding()
}