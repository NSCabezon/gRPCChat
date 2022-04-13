import Foundation

extension Message {
    func isSentByCurrentUser(userId: Int32) -> Bool {
        userId == userID
    }

    var date: Date {
        Date(timeIntervalSince1970: TimeInterval(dateTime))
    }
}
