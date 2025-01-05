import SwiftUI
import Charts

struct WeeklyStatsPreview: View {
    let weeklyStats: WeeklyStats?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Haftalık Özet")
                    .font(.custom("DynaPuff", size: 20))
                    .foregroundColor(Color("BrokoliKoyu"))
                
                Spacer()
                
                NavigationLink(destination: DetailedStatsView(weeklyStats: weeklyStats)) {
                    Text("Detaylar")
                        .font(.custom("DynaPuff", size: 14))
                        .foregroundColor(Color("BrokoliKoyu"))
                }
            }
            
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
                    .foregroundStyle(Color.red)
                }
                .frame(height: 200)
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day)) { value in
                        if let date = value.as(Date.self) {
                            AxisValueLabel(format: .dateTime.weekday())
                        }
                    }
                }
                
                HStack(spacing: 20) {
                    StatisticView(
                        title: "Ort. Kalori",
                        value: String(format: "%.0f", stats.averageCalories),
                        icon: "flame.fill"
                    )
                    
                    StatisticView(
                        title: "Ort. Su",
                        value: String(format: "%.0f ml", stats.averageWater),
                        icon: "drop.fill"
                    )
                }
            } else {
                Text("Henüz veri yok")
                    .font(.custom("DynaPuff", size: 16))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.1), radius: 5)
    }
}

struct DetailedStatsView: View {
    let weeklyStats: WeeklyStats?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Kalori Grafiği
                ChartSection(
                    title: "Kalori Takibi",
                    data: weeklyStats?.dailyStats ?? [],
                    getValue: { $0.totalCalories },
                    goalValue: weeklyStats?.dailyStats.first?.calorieGoal
                )
                
                // Makro Besinler
                MacroNutrientsSection(weeklyStats: weeklyStats)
                
                // Su Takibi
                ChartSection(
                    title: "Su Takibi",
                    data: weeklyStats?.dailyStats ?? [],
                    getValue: { $0.waterIntake },
                    goalValue: 2000 // Günlük su hedefi
                )
                
                // Haftalık Özet
                WeeklySummarySection(weeklyStats: weeklyStats)
            }
            .padding()
        }
        .navigationTitle("Haftalık Detaylar")
        .background(Color("BrokoliAcik").opacity(0.3))
    }
}

// MARK: - Grafik Bölümü
struct ChartSection: View {
    let title: String
    let data: [DailyStats]
    let getValue: (DailyStats) -> Double
    let goalValue: Double?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.custom("DynaPuff", size: 20))
                .foregroundColor(Color("BrokoliKoyu"))
            
            Chart {
                ForEach(data) { daily in
                    BarMark(
                        x: .value("Gün", daily.date, unit: .day),
                        y: .value("Değer", getValue(daily))
                    )
                    .foregroundStyle(Color("BrokoliKoyu"))
                }
                
                if let goal = goalValue {
                    RuleMark(y: .value("Hedef", goal))
                        .lineStyle(StrokeStyle(lineWidth: 2, dash: [5, 5]))
                        .foregroundStyle(Color.red)
                }
            }
            .frame(height: 200)
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) { value in
                    if let date = value.as(Date.self) {
                        AxisValueLabel(format: .dateTime.weekday())
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.1), radius: 5)
    }
}

// MARK: - Makro Besinler Bölümü
struct MacroNutrientsSection: View {
    let weeklyStats: WeeklyStats?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Makro Besinler")
                .font(.custom("DynaPuff", size: 20))
                .foregroundColor(Color("BrokoliKoyu"))
            
            if let stats = weeklyStats {
                HStack(spacing: 15) {
                    MacroNutrientCard(
                        title: "Protein",
                        value: String(format: "%.1f g", stats.totalProtein),
                        color: .blue
                    )
                    
                    MacroNutrientCard(
                        title: "Karbonhidrat",
                        value: String(format: "%.1f g", stats.totalCarbs),
                        color: .green
                    )
                    
                    MacroNutrientCard(
                        title: "Yağ",
                        value: String(format: "%.1f g", stats.totalFat),
                        color: .orange
                    )
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.1), radius: 5)
    }
}

// MARK: - Haftalık Özet Bölümü
struct WeeklySummarySection: View {
    let weeklyStats: WeeklyStats?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Haftalık Özet")
                .font(.custom("DynaPuff", size: 20))
                .foregroundColor(Color("BrokoliKoyu"))
            
            if let stats = weeklyStats {
                VStack(spacing: 15) {
                    SummaryRow(
                        title: "Ortalama Kalori",
                        value: String(format: "%.0f kcal", stats.averageCalories)
                    )
                    
                    SummaryRow(
                        title: "Ortalama Su",
                        value: String(format: "%.0f ml", stats.averageWater)
                    )
                    
                    SummaryRow(
                        title: "Kalori Hedefi",
                        value: String(format: "%.0f%%", stats.calorieProgress)
                    )
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.1), radius: 5)
    }
}

// MARK: - Yardımcı Görünümler
struct MacroNutrientCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 5) {
            Text(title)
                .font(.custom("DynaPuff", size: 12))
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

struct SummaryRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.custom("DynaPuff", size: 14))
                .foregroundColor(.gray)
            
            Spacer()
            
            Text(value)
                .font(.custom("DynaPuff", size: 16))
                .foregroundColor(.black)
        }
    }
}

