import Foundation

extension Com_Santiihoyos_Grpcchat_Data_Grpc_Model_Grpcchat_Message {
    func isSentByCurrentUser(userId: Int32) -> Bool {
        user.id == userId
    }

    var date: Date {
        Date(timeIntervalSince1970: TimeInterval(epochTime))
    }
}

extension Com_Santiihoyos_Grpcchat_Data_Grpc_Model_Grpcchat_Message: Identifiable {
    var id: String {
        return String("\(message)\(user.id)")
    }
}
