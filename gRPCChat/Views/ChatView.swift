import SwiftUI

struct ChatView: View {
    @AppStorage("userId") var userId: Int?

    @State var textMessage = ""

    @Environment(\.colorScheme) var scheme

    @StateObject var viewModel = ChatViewModel()

    @FocusState private var isTextFieldFocused: Bool

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

                HStack(spacing: 10) {
                    TextField("Message", text: $textMessage)
                        .modifier(ShadowModifier())
                        .focused($isTextFieldFocused)
                        .onChange(of: isTextFieldFocused) { _ in
                            reader.scrollTo("MSG_VIEW", anchor: .bottom)
                        }

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
        }
        .navigationTitle("Chat")
        .onAppear(perform: {
            viewModel.viewAppeared()
        })
    }


    func sendMessage() {
        viewModel.sendMessage(text: textMessage)
        textMessage = ""
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
