import SwiftUI
import GRPC
import CGRPCZlib

struct ChatView: View {
    @AppStorage("userId") var userId: Int = 0

    @State var textMessage = ""

    @Environment(\.colorScheme) var scheme

    @StateObject var viewModel = ChatViewModel()

    let chatClient: ChatClientProtocol

    init() {
        let eventGroup = PlatformSupport.makeEventLoopGroup(loopCount: 1)
        let channel = ClientConnection.insecure(group: eventGroup).connect(host: "localhost", port: 24957)
        chatClient = ChatClient(channel: channel)
    }


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
                TextField("Message", text: $textMessage)
                    .modifier(ShadowModifier())

                Button(action: sendMessage, label: {
                    Image(systemName: "paperplane.fill")
                        .padding(10)
                        .background(Color.red)
                        .foregroundColor(scheme == .dark ? .black : .white)
                        .clipShape(Circle())
                })
                .disabled(textMessage == "")
                .opacity(textMessage == "" ? 0.5 : 1)
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
        .navigationTitle("Chat")
        .onAppear(perform: {
            // TODO: finish listen
//            chatClient.listen
        })
    }


    func sendMessage() {
        var message = Message()
        message.userID = Int32(userId)
        message.dateTime = Int64(Date().timeIntervalSince1970)
        message.message = textMessage

        chatClient.write(message, callOptions: nil)
        textMessage = ""
    }
}



struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
