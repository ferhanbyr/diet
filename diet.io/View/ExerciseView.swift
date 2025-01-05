import SwiftUI

struct ExerciseView: View {
    @StateObject private var viewModel = ExerciseViewModel()
    @State private var selectedMuscle: String?
    
    let muscles = ["biceps", "triceps", "chest", "abs", "legs", "shoulders", "back"]
    
    var body: some View {
        VStack(spacing: 0) {
            // Kas Grubu Seçici
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(muscles, id: \.self) { muscle in
                        Button(action: {
                            selectedMuscle = muscle
                            viewModel.fetchExercises(for: muscle)
                        }) {
                            Text(muscle.capitalized)
                                .font(.custom("DynaPuff", size: 14))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    selectedMuscle == muscle ?
                                    Color("BrokoliKoyu") :
                                    Color("BrokoliKoyu").opacity(0.1)
                                )
                                .foregroundColor(
                                    selectedMuscle == muscle ? .white : Color("BrokoliKoyu")
                                )
                                .cornerRadius(20)
                        }
                    }
                }
                .padding()
            }
            
            // Egzersiz Listesi
            if viewModel.isLoading {
                Spacer()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color("BrokoliKoyu")))
                Spacer()
            } else {
                ScrollView {
                    LazyVStack(spacing: 15) {
                        ForEach(viewModel.exercises) { exercise in
                            ExerciseCard(exercise: exercise)
                                .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
            }
        }
        .background(Color("BrokoliAcik").opacity(0.3))
        .onAppear {
            if selectedMuscle == nil {
                viewModel.fetchExercises()
            }
        }
    }
}

struct ExerciseCard: View {
    let exercise: Exercise
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Başlık ve Tip
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(exercise.name)
                        .font(.custom("DynaPuff", size: 16))
                        .foregroundColor(.black)
                    
                    Text(exercise.type.capitalized)
                        .font(.custom("DynaPuff", size: 12))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }) {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(Color("BrokoliKoyu"))
                }
            }
            
            // Detaylar
            if isExpanded {
                VStack(alignment: .leading, spacing: 8) {
                    DetailRow(title: "Ekipman:", text: exercise.equipment)
                    DetailRow(title: "Zorluk:", text: exercise.difficulty)
                    DetailRow(title: "Talimatlar:", text: exercise.instructions)
                }
                .transition(.opacity)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.2), radius: 5)
    }
}

struct DetailRow: View {
    let title: String
    let text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.custom("DynaPuff", size: 14))
                .foregroundColor(Color("BrokoliKoyu"))
            
            Text(text)
                .font(.custom("DynaPuff", size: 12))
                .foregroundColor(.black)
        }
    }
} 