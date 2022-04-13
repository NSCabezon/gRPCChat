import Foundation

struct Message: Equatable, Identifiable {
    let id: UUID
    let text: String
    let isSentByCurrentUser: Bool
    let createdAt: Date
    let author: ChatUser
}

struct ChatUser: Identifiable, Equatable {
    let id: String
    let name: String?
    let isOnline: Bool
    let lastActiveAt: Date?
}
