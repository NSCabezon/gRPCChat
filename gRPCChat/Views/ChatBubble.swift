import SwiftUI

struct ChatBubble: Shape {
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        Path(UIBezierPath(roundedRect: rect,
                          byRoundingCorners: corners,
                          cornerRadii: CGSize(width: 13, height: 13)).cgPath)
    }
}


struct ChatBubble_Previews: PreviewProvider {
    static var previews: some View {
        ChatBubble(corners: UIRectCorner.allCorners)
    }
}
