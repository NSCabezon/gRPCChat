import SwiftUI

struct MessageView: View {
    var messsage: Message
    
    var body: some View {
        HStack {
            if messsage.isSentByCurrentUser {
                Spacer()
            }
            
            HStack(alignment: .bottom,spacing: 10) {
                if !messsage.isSentByCurrentUser {
                    UserView(message: messsage)
                        .offset(y: 10.0)
                }

                VStack(alignment: messsage.isSentByCurrentUser ? .trailing : .leading, spacing: 6, content: {
                    Text(messsage.text)
                    Text(messsage.createdAt,style: .time)
                        .font(.caption)
                })
                .padding([.horizontal,.top])
                .padding(.bottom,8)
                // Current User color is blue and opposite user color is gray...
                .background(messsage.isSentByCurrentUser ? Color.blue : Color.gray.opacity(0.4))
                .clipShape(ChatBubble(corners: messsage.isSentByCurrentUser ? .allButBottomRight : .allButBottomLeft))
                .foregroundColor(messsage.isSentByCurrentUser ? .white : .primary)
                .frame(width: UIScreen.main.bounds.width - 150,alignment: messsage.isSentByCurrentUser ? .trailing : .leading)
                

                if messsage.isSentByCurrentUser {
                    UserView(message: messsage)
                        .offset(y: 10.0)
                }
            }
            
            if !messsage.isSentByCurrentUser {
                Spacer()
            }
        }
    }
}

struct UserView: View {
    var message: Message

    var body: some View{
        Circle()
            .fill(message.isSentByCurrentUser ? Color.blue : Color.gray.opacity(0.4))
            .frame(width: 40, height: 40)
            .overlay(Text("\(String(message.author.id.first!))")
                .fontWeight(.semibold)
                .foregroundColor(message.isSentByCurrentUser ? .white : .primary))
            .contextMenu(menuItems: {
                Text("\(message.author.id)")

                if message.author.isOnline {
                    Text("Status: Online")
                } else {
                    Text(message.author.lastActiveAt ?? Date(),style: .time)
                }
            })
    }
}


extension UIRectCorner {
    static var allButBottomRight: UIRectCorner { return [.topLeft,.topRight,.bottomLeft] }
    static var allButBottomLeft: UIRectCorner { return [.topLeft,.topRight,.bottomRight] }
}
