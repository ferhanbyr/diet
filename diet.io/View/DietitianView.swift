import SwiftUI

struct DietitianView: View {
    @State private var searchText = ""
    @State private var showAddDietitian = false
    
    var body: some View {
        VStack(spacing: 15) {
            // Kendi Diyetisyenini Ekle Butonu
            Button(action: {
                showAddDietitian = true
            }) {
                HStack {
                    Text("Kendi Diyetisyenini Ekle")
                        .font(.custom("DynaPuff", size: 16))
                    Spacer()
                    Image(systemName: "plus")
                }
                .foregroundColor(.black)
                .padding()
                .background(Color("BrokoliAcik").opacity(0.5))
                .cornerRadius(15)
            }
            .padding(.horizontal)
            
            // Arama Çubuğu
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Arama", text: $searchText)
                    .font(.custom("DynaPuff", size: 14))
            }
            .padding()
            .background(Color("BrokoliAcik").opacity(0.3))
            .cornerRadius(15)
            .padding(.horizontal)
            
            // Diyetisyen Listesi
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(filteredDietitians) { dietitian in
                        DietitianCard(dietitian: dietitian)
                    }
                }
                .padding(.horizontal)
            }
        }
        .sheet(isPresented: $showAddDietitian) {
            AddDietitianView()
        }
    }
    
    private var filteredDietitians: [Dietitian] {
        if searchText.isEmpty {
            return mockDietitians
        }
        return mockDietitians.filter { $0.name.lowercased().contains(searchText.lowercased()) }
    }
}

struct DietitianCard: View {
    let dietitian: Dietitian
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 40))
                .foregroundColor(Color("BrokoliKoyu"))
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Diyetisyen \(dietitian.name)")
                    .font(.custom("DynaPuff", size: 16))
                    .foregroundColor(.black)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: .gray.opacity(0.2), radius: 5)
    }
}

struct AddDietitianView: View {
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var phone = ""
    @State private var email = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Diyetisyen Bilgileri")) {
                    TextField("Ad Soyad", text: $name)
                        .font(.custom("DynaPuff", size: 16))
                    TextField("Telefon", text: $phone)
                        .font(.custom("DynaPuff", size: 16))
                        .keyboardType(.phonePad)
                    TextField("E-posta", text: $email)
                        .font(.custom("DynaPuff", size: 16))
                        .keyboardType(.emailAddress)
                }
            }
            .navigationTitle("Diyetisyen Ekle")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("İptal") {
                    dismiss()
                },
                trailing: Button("Kaydet") {
                    // Kaydetme işlemi
                    dismiss()
                }
                .disabled(name.isEmpty)
            )
        }
    }
}

// Model
struct Dietitian: Identifiable {
    let id = UUID()
    let name: String
    let phone: String
    let email: String
}

// Örnek veri
let mockDietitians = [
    Dietitian(name: "Ahmet Kara", phone: "555-0001", email: "ahmet@example.com"),
    Dietitian(name: "Ayşegül Aydın", phone: "555-0002", email: "aysegul@example.com"),
    Dietitian(name: "Zehra Çağlar", phone: "555-0003", email: "zehra@example.com"),
    Dietitian(name: "Mert Gün", phone: "555-0004", email: "mert@example.com"),
    Dietitian(name: "Sahra Pek", phone: "555-0005", email: "sahra@example.com")
] 
struct Dietitian_Previews: PreviewProvider {
    static var previews: some View {
        DietitianView()
    }
}
