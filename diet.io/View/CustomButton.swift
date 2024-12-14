//
//  CustomButton.swift
//  diet.io
//
//  Created by Ferhan Bayır on 14.12.2024.
//


import SwiftUI

struct CustomButton: View {
    var title: String // Buton başlığı
    var backgroundColor: Color // Arka plan rengi
    var textColor: Color
    var action: () -> Void // Buton tıklandığında yapılacak işlem

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.custom("DynaPuff", size: 20))
                .foregroundColor(textColor) // Başlık rengi beyaz
                .padding() // İç boşluk
                .frame(width: 360, height: 65) // Butonun genişliğini tam ekran yapar
                .background(backgroundColor) // Arka plan rengi
                .cornerRadius(10) // Köşe yuvarlama
                .shadow(radius: 5) // Gölgeleme
        }
        .buttonStyle(PlainButtonStyle()) // Standart buton stili
    }
}
#Preview {
    IntroView()
}
