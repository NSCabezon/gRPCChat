import SwiftUI
import GRPC
import CGRPCZlib

class ChatViewModel: ObservableObject {
    @Published var messages: [Com_Santiihoyos_Grpcchat_Data_Grpc_Model_Grpcchat_Message] = []

    @AppStorage("userId") var userId: Int?

    private let chatClient: Com_Santiihoyos_Grpcchat_Data_Grpc_Model_Grpcchat_ChatClientProtocol

    init() {
        let eventGroup = PlatformSupport.makeEventLoopGroup(loopCount: 1)
        let channel = ClientConnection.insecure(group: eventGroup).connect(host: "localhost", port: 24957)
        chatClient = Com_Santiihoyos_Grpcchat_Data_Grpc_Model_Grpcchat_ChatClient(channel: channel)
    }

    func viewAppeared() {
        greetIfNeeded()
        getHistory()
        suscribeToNewMessages()
    }

    func greetIfNeeded() {
        if self.userId != nil {
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
        }
    }

    func getHistory() {
        guard let userId = userId else { return }
        var userReq = Com_Santiihoyos_Grpcchat_Data_Grpc_Model_Grpcchat_User()
        userReq.id = Int32(userId)
        let result = chatClient.getHistory(userReq, callOptions: nil)

        do {
            let response = try result.response.wait()
            debugPrint(response)
            self.messages = response.messages
        } catch {
            debugPrint("something went wrong")
        }
    }

    func suscribeToNewMessages() {
        guard let userId = userId else { return }
        var user = Com_Santiihoyos_Grpcchat_Data_Grpc_Model_Grpcchat_User()
        user.id = Int32(userId)
        let request = chatClient.listen(user, callOptions: nil) { [weak self] message in
            debugPrint("received message")
            self?.messages.append(message)
        }
        debugPrint(request)
    }

    func sendMessage(text: String) {
        guard let userId = userId else { return }
        var message = Com_Santiihoyos_Grpcchat_Data_Grpc_Model_Grpcchat_WriteMessage()
        message.userID = Int32(userId)
        message.message = text

        let result = chatClient.write(message, callOptions: nil)

        do {
            let response = try result.response.wait()
            debugPrint("Message sent: \(response.ack == .sent)")
        } catch {
            debugPrint("something went wrong")
        }
    }
}
