import Foundation

class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = [Message(id: UUID(),
                                                  text: "Hola chicos que tal el finde?",
                                                  isSentByCurrentUser: false,
                                                  createdAt: Date(timeIntervalSinceNow: -100),
                                                  author: ChatUser(id: "demo",
                                                                   name: "Jesus",
                                                                   isOnline: false,
                                                                   lastActiveAt: Date(timeIntervalSinceNow: -100)))]
}
