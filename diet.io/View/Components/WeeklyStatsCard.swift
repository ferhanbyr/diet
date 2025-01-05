import SwiftUI

struct WeeklyStatsCard: View {
    let stats: WeeklyStats?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Haftalık Özet")
                .font(.custom("DynaPuff", size: 18))
                .foregroundColor(.black)
            
            if let stats = stats {
                VStack(spacing: 15) {
                    // Haftalık Kalori Grafiği
                    HStack {
                        ForEach(stats.dailyStats) { daily in
                            VStack {
                                Spacer()
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color("BrokoliKoyu"))
                                    .frame(width: 30, height: CGFloat(min(daily.totalCalories / stats.dailyStats.first!.calorieGoal, 1.0)) * 100)
                                
                                Text(formatDate(daily.date))
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .frame(height: 120)
                    
                    // Haftalık Özet Bilgileri
                    HStack(spacing: 20) {
                        StatisticView(
                            title: "Ort. Kalori",
                            value: "\(Int(stats.averageCalories))",
                            icon: "flame.fill"
                        )
                        
                        StatisticView(
                            title: "Ort. Su",
                            value: "\(Int(stats.averageWater)) ml",
                            icon: "drop.fill"
                        )
                    }
                }
            } else {
                Text("Henüz veri yok")
                    .font(.custom("DynaPuff", size: 14))
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter.string(from: date)
    }
}

struct StatisticView: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: icon)
                .foregroundColor(Color("BrokoliKoyu"))
            
            Text(value)
                .font(.custom("DynaPuff", size: 16))
                .foregroundColor(.black)
            
            Text(title)
                .font(.custom("DynaPuff", size: 12))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(Color("BrokoliAcik").opacity(0.2))
        .cornerRadius(10)
    }
} 