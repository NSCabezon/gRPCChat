import SwiftUI
import GRPC
import CGRPCZlib

struct ChatView: View {
    @AppStorage("userId") var userId: Int = 0

    @State var textMessage = ""

    @Environment(\.colorScheme) var scheme

    @StateObject var viewModel = ChatViewModel()

    let chatClient: Com_Santiihoyos_Grpcchat_Data_Grpc_Model_Grpcchat_ChatClientProtocol

    init() {
        let eventGroup = PlatformSupport.makeEventLoopGroup(loopCount: 1)
        let channel = ClientConnection.insecure(group: eventGroup).connect(host: "localhost", port: 24957)
        chatClient = Com_Santiihoyos_Grpcchat_Data_Grpc_Model_Grpcchat_ChatClient(channel: channel)
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
            var hello = Com_Santiihoyos_Grpcchat_Data_Grpc_Model_Grpcchat_Hello()
            hello.nickName = "iOS"
            let result = chatClient.hello(hello, callOptions: nil)

            do {
                let response = try result.response.wait()
                debugPrint(response)
                self.userId = Int(response.id)
            } catch {
                debugPrint("something went wrong")
            }
        })
    }


    func sendMessage() {
        var message = Com_Santiihoyos_Grpcchat_Data_Grpc_Model_Grpcchat_WriteMessage()
        message.userID = Int32(userId)
        message.message = textMessage

        let result = chatClient.write(message, callOptions: nil)

        do {
            let response = try result.response.wait()
            debugPrint("Message sent: \(response.ack == .sent)")
        } catch {
            debugPrint("something went wrong")
        }
        textMessage = ""
    }
}



struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
