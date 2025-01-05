import SwiftUI
import Charts

struct WeeklyStatsDetailView: View {
    let weeklyStats: WeeklyStats?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Kalori Grafiği
                VStack(alignment: .leading, spacing: 10) {
                    Text("Kalori Takibi")
                        .font(.custom("DynaPuff", size: 20))
                        .foregroundColor(Color("BrokoliKoyu"))
                    
                    if let stats = weeklyStats {
                        Chart {
                            ForEach(stats.dailyStats) { daily in
                                BarMark(
                                    x: .value("Gün", daily.date, unit: .day),
                                    y: .value("Kalori", daily.totalCalories)
                                )
                                .foregroundStyle(Color("BrokoliKoyu"))
                            }
                            
                            RuleMark(
                                y: .value("Hedef", stats.dailyStats.first?.calorieGoal ?? 0)
                            )
                            .lineStyle(StrokeStyle(lineWidth: 2, dash: [5, 5]))
                            .foregroundStyle(.red)
                        }
                        .frame(height: 200)
                        .chartXAxis {
                            AxisMarks(values: .stride(by: .day)) { value in
                                if let date = value.as(Date.self) {
                                    AxisValueLabel(formatDate(date))
                                }
                            }
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                
                // Makro Besinler
                VStack(alignment: .leading, spacing: 10) {
                    Text("Haftalık Makro Besinler")
                        .font(.custom("DynaPuff", size: 20))
                        .foregroundColor(Color("BrokoliKoyu"))
                    
                    if let stats = weeklyStats {
                        HStack(spacing: 15) {
                            MacroCard(
                                title: "Protein",
                                value: String(format: "%.1f g", stats.totalProtein),
                                icon: "p.circle.fill",
                                color: .blue
                            )
                            
                            MacroCard(
                                title: "Karbonhidrat",
                                value: String(format: "%.1f g", stats.totalCarbs),
                                icon: "c.circle.fill",
                                color: .green
                            )
                            
                            MacroCard(
                                title: "Yağ",
                                value: String(format: "%.1f g", stats.totalFat),
                                icon: "f.circle.fill",
                                color: .orange
                            )
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                
                // Su Takibi
                VStack(alignment: .leading, spacing: 10) {
                    Text("Su Takibi")
                        .font(.custom("DynaPuff", size: 20))
                        .foregroundColor(Color("BrokoliKoyu"))
                    
                    if let stats = weeklyStats {
                        Chart {
                            ForEach(stats.dailyStats) { daily in
                                BarMark(
                                    x: .value("Gün", daily.date, unit: .day),
                                    y: .value("Su (ml)", daily.waterIntake)
                                )
                                .foregroundStyle(.blue.gradient)
                            }
                            
                            RuleMark(
                                y: .value("Hedef", 2000)
                            )
                            .lineStyle(StrokeStyle(lineWidth: 2, dash: [5, 5]))
                            .foregroundStyle(.red)
                        }
                        .frame(height: 200)
                        .chartXAxis {
                            AxisMarks(values: .stride(by: .day)) { value in
                                if let date = value.as(Date.self) {
                                    AxisValueLabel(formatDate(date))
                                }
                            }
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                
                // Günlük Detaylar
                VStack(alignment: .leading, spacing: 10) {
                    Text("Günlük Detaylar")
                        .font(.custom("DynaPuff", size: 20))
                        .foregroundColor(Color("BrokoliKoyu"))
                    
                    if let stats = weeklyStats {
                        ForEach(stats.dailyStats) { daily in
                            DailyStatsRow(stats: daily)
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(15)
            }
            .padding()
        }
        .background(Color("BrokoliAcik").opacity(0.2))
        .navigationTitle("Haftalık Detaylar")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MacroCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(title)
                .font(.custom("DynaPuff", size: 14))
                .foregroundColor(.gray)
            
            Text(value)
                .font(.custom("DynaPuff", size: 16))
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(10)
    }
}

struct DailyStatsRow: View {
    let stats: DailyStats
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button(action: { isExpanded.toggle() }) {
                HStack {
                    Text(formatDate(stats.date))
                        .font(.custom("DynaPuff", size: 16))
                    
                    Spacer()
                    
                    Text("\(Int(stats.totalCalories)) kcal")
                        .font(.custom("DynaPuff", size: 16))
                        .foregroundColor(Color("BrokoliKoyu"))
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(Color("BrokoliKoyu"))
                }
            }
            .foregroundColor(.primary)
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Öğünler:")
                        .font(.custom("DynaPuff", size: 14))
                        .foregroundColor(.gray)
                    
                    ForEach(stats.meals) { meal in
                        HStack {
                            Text(meal.name)
                                .font(.custom("DynaPuff", size: 14))
                            Spacer()
                            Text("\(Int(meal.calories)) kcal")
                                .font(.custom("DynaPuff", size: 14))
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("Su:")
                            .font(.custom("DynaPuff", size: 14))
                            .foregroundColor(.gray)
                        Spacer()
                        Text("\(Int(stats.waterIntake)) ml")
                            .font(.custom("DynaPuff", size: 14))
                            .foregroundColor(.blue)
                    }
                }
                .padding(.leading)
            }
        }
        .padding()
        .background(Color("BrokoliAcik").opacity(0.1))
        .cornerRadius(10)
    }
}

private func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "E, d MMM"
    return formatter.string(from: date)
} 