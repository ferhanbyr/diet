//
//  ContentView.swift
//  diet.io
//
//  Created by Ferhan Bayır on 8.12.2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image("asd")
                .imageScale(.large)
                .foregroundStyle(Color("BrokoliKoyu"))
            Text("Hello, world!")
                .font(.custom("DynaPuff", size: 20))
                .fontWeight(.bold)
        }
    }
}

#Preview {
    ContentView()
}
