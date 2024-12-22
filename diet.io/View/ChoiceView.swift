//
//  ContentView.swift
//  diet.io
//
//  Created by Ferhan Bayır on 15.12.2024.
//


import SwiftUI

struct ChoiceView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("Aklında ne gibi bir\nhedef var?")
                .font(.system(size: 32, weight: .bold))
                .multilineTextAlignment(.center)
                .padding(.top, 20)
                .padding(.bottom, 40)
            
            // Kilo Verme Button
            Button(action: {
                viewModel.setTheme(for: "Kilo verme")
                viewModel.nextStep()
            }) {
                HStack {
                    Text("Kilo verme")
                        .font(.custom("DynaPuff", size: 20))
                        .foregroundColor(.white)
                        .padding(.leading, 20)
                    Spacer()
                    Image("brokoli")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 250)
                        .offset(x: 20)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 80)
                .background(Color("BrokoliKoyu"))
                .cornerRadius(25)
                .clipped()
            }
            .padding(.horizontal, 20)
            
            // Kilo Alma Button
            Button(action: {
                viewModel.setTheme(for: "Kilo alma")
                viewModel.nextStep()
            }) {
                HStack {
                    Text("Kilo alma")
                        .font(.custom("DynaPuff", size: 20))
                        .foregroundColor(.white)
                        .padding(.leading, 20)
                    Spacer()
                    Image("mango")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 250)
                        .offset(x: 20)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 80)
                .background(Color("MangoKoyu"))
                .cornerRadius(25)
                .clipped()
            }
            .padding(.horizontal, 20)
            
            // Sağlıklı Yaşam Button
            Button(action: {
                viewModel.setTheme(for: "Sağlıklı yaşam")
                viewModel.nextStep()
            }) {
                HStack {
                    Text("Sağlıklı yaşam")
                        .font(.custom("DynaPuff", size: 20))
                        .foregroundColor(.white)
                        .padding(.leading, 20)
                    Spacer()
                    Image("elma")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 250)
                        .offset(x: 20)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 80)
                .background(Color("ElmaKoyu"))
                .cornerRadius(25)
                .clipped()
            }
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .background(.white)
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    ChoiceView(viewModel: OnboardingViewModel())
}
