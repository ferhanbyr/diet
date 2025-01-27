import SwiftUI

struct UserProfileHeader: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Hoş geldin,")
                    .font(.custom("DynaPuff", size: 14))
                    .foregroundColor(.gray)
                Text("Ferhan Bayır")
                    .font(.custom("DynaPuff", size: 20))
                    .foregroundColor(.black)
            }
            Spacer()
            
            Image(systemName: "bell.fill")
                .font(.title2)
                .foregroundColor(Color("BrokoliKoyu"))
        }
        .padding(.horizontal)
    }
} 
