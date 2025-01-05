import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()
    @State private var scrollProxy: ScrollViewProxy? = nil
    @State private var selectedSuggestion: String?
    
    let suggestions = [
        "5 dakikada hazırlanacak sağlıklı öğünler",
        "Sağlıklı atıştırmalıklar",
        "Protein kaynakları",
        "Düşük kalorili tarifler",
        "Detoks çayları"
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Sohbet geçmişi
            ScrollView {
                ScrollViewReader { proxy in
                    VStack {
                        if viewModel.messages.isEmpty {
                            VStack(spacing: 20) {
                                Image("brokoli")
                                    .resizable()
                                    .frame(width: 150, height: 300)
                                    .padding(.top, 50)
                                
                                VStack(spacing: 10) {
                                    Text("Merhaba! Ben Brokoli 👋")
                                        .font(.custom("DynaPuff", size: 24))
                                        .foregroundColor(Color("BrokoliKoyu"))
                                    
                                    Text("Sağlıklı beslenme ve diyet konusunda\nsorularını yanıtlamaya hazırım!")
                                        .font(.custom("DynaPuff", size: 16))
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.center)
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.white)
                                        .shadow(color: Color.gray.opacity(0.2), radius: 10)
                                )
                                .padding(.horizontal)
                            }
                        } else {
                            LazyVStack(spacing: 15) {
                                ForEach(viewModel.messages) { message in
                                    ChatBubble(message: message)
                                        .padding(.horizontal)
                                        .id(message.id)
                                }
                            }
                            .padding(.vertical)
                        }
                    }
                    .onChange(of: viewModel.messages) { _ in
                        if let lastMessage = viewModel.messages.last {
                            withAnimation {
                                proxy.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                    .onAppear {
                        scrollProxy = proxy
                    }
                }
            }
            
            VStack(spacing: 0) {
                Divider()
                
                // Örnek aramalar
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(suggestions, id: \.self) { suggestion in
                            Button(action: {
                                viewModel.inputMessage = suggestion
                                selectedSuggestion = suggestion
                                viewModel.sendMessage()
                            }) {
                                Text(suggestion)
                                    .font(.custom("DynaPuff", size: 14))
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(
                                        selectedSuggestion == suggestion ?
                                        Color("BrokoliKoyu") :
                                        Color("BrokoliKoyu").opacity(0.1)
                                    )
                                    .foregroundColor(
                                        selectedSuggestion == suggestion ? .white : Color("BrokoliKoyu")
                                    )
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                }
                
                Divider()
                
                // Mesaj yazma alanı
                HStack(spacing: 15) {
                    TextField("Mesajınız...", text: $viewModel.inputMessage)
                        .padding(12)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(20)
                        .font(.custom("DynaPuff", size: 14))
                        .disabled(viewModel.isLoading)
                    
                    Button(action: {
                        viewModel.sendMessage()
                    }) {
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: Color("BrokoliKoyu")))
                                .frame(width: 32, height: 32)
                        } else {
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.system(size: 32))
                                .foregroundColor(Color("BrokoliKoyu"))
                        }
                    }
                    .disabled(viewModel.inputMessage.isEmpty || viewModel.isLoading)
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(Color.white)
            }
        }
        .navigationTitle("Brokoli Chat")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color("BrokoliAcik").opacity(0.3))
    }
}

struct ChatBubble: View {
    let message: ChatMessages
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if message.isUser { 
                Spacer() 
            } else {
                // Brokoli avatarı
                Image("brokoli")
                    .resizable()
                    .frame(width: 30, height: 60)
                    .padding(.bottom, 4)
            }
            
            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(
                        message.isUser ? Color("BrokoliKoyu") : Color.white
                    )
                    .foregroundColor(message.isUser ? .white : .black)
                    .cornerRadius(20)
                    .font(.custom("DynaPuff", size: 14))
                
                Text(formatDate(message.timestamp))
                    .font(.custom("DynaPuff", size: 10))
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: UIScreen.main.bounds.width * 0.7, alignment: message.isUser ? .trailing : .leading)
            
            if message.isUser { 
                // Kullanıcı avatarı
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color("BrokoliKoyu"))
                    .padding(.bottom, 4)
            } else {
                Spacer()
            }
        }
        .padding(.horizontal)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatView()
        }
    }
} 
