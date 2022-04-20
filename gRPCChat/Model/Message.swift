import Foundation

extension Message {
    func isSentByCurrentUser(userId: Int32) -> Bool {
        user.id == userId
    }

    var date: Date {
        Date(timeIntervalSince1970: TimeInterval(epochTime))
    }
}

extension Message: Identifiable {
    var id: String {
        return String("\(message)\(user.id)")
    }
}
