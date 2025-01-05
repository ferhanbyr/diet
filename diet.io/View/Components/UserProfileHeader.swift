import SwiftUI

struct UserProfileHeader: View {
    let userName: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Hoş geldin,")
                    .font(.custom("DynaPuff", size: 14))
                    .foregroundColor(.gray)
                Text(userName)
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