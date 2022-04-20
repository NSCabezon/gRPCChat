import SwiftUI

struct MessageView: View {
    @AppStorage("userId") var userId: Int = 0
    var messsage: Message
    
    var body: some View {
        HStack {
            if messsage.isSentByCurrentUser(userId: Int32(userId)) {
                Spacer()
            }
            
            HStack(alignment: .bottom,spacing: 10) {
                if !messsage.isSentByCurrentUser(userId: Int32(userId)) {
                    UserView(message: messsage)
                        .offset(y: 10.0)
                }

                VStack(alignment: messsage.isSentByCurrentUser(userId: Int32(userId)) ? .trailing : .leading, spacing: 6, content: {
                    Text(messsage.message)
                    Text(messsage.date, style: .time)
                        .font(.caption)
                })
                .padding([.horizontal,.top])
                .padding(.bottom,8)
                // Current User color is blue and opposite user color is gray...
                .background(messsage.isSentByCurrentUser(userId: Int32(userId)) ? Color.blue : Color.gray.opacity(0.4))
                .clipShape(ChatBubble(corners: messsage.isSentByCurrentUser(userId: Int32(userId)) ? .allButBottomRight : .allButBottomLeft))
                .foregroundColor(messsage.isSentByCurrentUser(userId: Int32(userId)) ? .white : .primary)
                .frame(width: UIScreen.main.bounds.width - 150,alignment: messsage.isSentByCurrentUser(userId: Int32(userId)) ? .trailing : .leading)
                

                if messsage.isSentByCurrentUser(userId: Int32(userId)) {
                    UserView(message: messsage)
                        .offset(y: 10.0)
                }
            }
            
            if !messsage.isSentByCurrentUser(userId: Int32(userId)) {
                Spacer()
            }
        }
    }
}

struct UserView: View {
    @AppStorage("userId") var userId: Int = 0

    var message: Message

    var body: some View{
        Circle()
            .fill(message.isSentByCurrentUser(userId: Int32(userId)) ? Color.blue : Color.gray.opacity(0.4))
            .frame(width: 40, height: 40)
            .overlay(Text("\(String(message.user.nickName.first!))")
                .fontWeight(.semibold)
                .foregroundColor(message.isSentByCurrentUser(userId: Int32(userId)) ? .white : .primary))
            .contextMenu(menuItems: {
                Text("\(message.user.id)")
            })
    }
}


extension UIRectCorner {
    static var allButBottomRight: UIRectCorner { return [.topLeft,.topRight,.bottomLeft] }
    static var allButBottomLeft: UIRectCorner { return [.topLeft,.topRight,.bottomRight] }
}
