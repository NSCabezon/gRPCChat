import SwiftUI

struct ChatView: View {
    @State var message = ""

    @Environment(\.colorScheme) var scheme

    @StateObject var viewModel: ChatViewModel

    var body: some View {
        VStack {
            ScrollViewReader { reader in
                ScrollView(.vertical, showsIndicators: true, content: {
                    LazyVStack(alignment: .center, spacing: 15, content: {
                        ForEach(viewModel.messages) { message in
                            MessageView(messsage: message)
                        }
                    })
                    .padding()
                    .padding(.bottom, 10)
                    .id("MSG_VIEW")
                })
                .onChange(of: viewModel.messages, perform: { value in
                    withAnimation {
                        reader.scrollTo("MSG_VIEW", anchor: .bottom)
                    }
                })
                .onAppear(perform: {
                    reader.scrollTo("MSG_VIEW", anchor: .bottom)
                })
            }

            HStack(spacing: 10) {
                TextField("Message", text: $message)
                    .modifier(ShadowModifier())

                Button(action: sendMessage, label: {
                    Image(systemName: "paperplane.fill")
                        .padding(10)
                        .background(Color.red)
                        .foregroundColor(scheme == .dark ? .black : .white)
                        .clipShape(Circle())
                })
                .disabled(message == "")
                .opacity(message == "" ? 0.5 : 1)
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
        .navigationTitle("Chat")
    }


    func sendMessage() {
        viewModel.messages.append(Message(id: UUID(),
                                          text: message,
                                          isSentByCurrentUser: true,
                                          createdAt: Date(),
                                          author: ChatUser(id: "ios",
                                                           name: "Iván",
                                                           isOnline: true,
                                                           lastActiveAt: Date())))
        // Clearing Msg Field...
        message = ""
    }
}



struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(viewModel: ChatViewModel())
    }
}
