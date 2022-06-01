//
//  ContentView.swift
//  Sociable
//
//  Created by Abas Hersi & Sulaiman Mahmood on 4/27/22.
//

import SwiftUI
import SDWebImageSwiftUI

public var target: String = ""
public var msgSet : Set<Msg> = []

struct Usr2Msg: Hashable, Codable {
    let displayName: String
    let msgs: [Msg2Comp]
}

struct Msg2Comp: Hashable, Codable {
    let sender: String
    let msg: String
    let timestamp: Timestamp
}

private func sendMessage(msg: String, recipient: String, _ allMessages: inout Dictionary<String, Array<Msg>>) {
    let sendBaseUrl = "https://us-central1-sociable-messenger.cloudfunctions.net/messaging_api/sendMessage?"
    let urlstring = sendBaseUrl + "uid=" + recipient + "&msg=" + msg + "&sender=" + user_uid
    let url = URL(string: urlstring)
    var request = URLRequest(url: url!)
    request.httpMethod = "POST"
    request.setValue("7f5c4e71e19bdd8c793f1677867ef4db007988f6", forHTTPHeaderField: "auth")
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            fatalError("Unable to send message: \(error.localizedDescription)")
        }
    }.resume()
    let message = Msg(id: recipient, text: msg, recieved: false, time: Timestamp())
    allMessages[recipient, default: []].append(message)
    print(allMessages)
}

private func setFriend(recipient: String, add: Bool, completion: ((Bool) -> Void)? = nil) {
    let baseUrl = "https://us-central1-sociable-messenger.cloudfunctions.net/users_api/\(add ? "add" : "remove")Friend?"
    let urlstring = baseUrl + "uid=" + user_uid + "&friendUid=" + recipient
    let url = URL(string: urlstring)
    var request = URLRequest(url: url!)
    request.httpMethod = "POST"
    request.setValue("7f5c4e71e19bdd8c793f1677867ef4db007988f6", forHTTPHeaderField: "auth")
    URLSession.shared.dataTask(with: request) { data, response, error in

        let response1 = response as! HTTPURLResponse
        completion?(response1.statusCode == 200)

        if let error = error {
            fatalError("Unable to add friend: \(error.localizedDescription)")
        }
    }.resume()
}

struct MessageContentView: View {
    @State private var message = ""
    @State var showingAlert = false
    // @State var showingError = false
    @Binding var recipient: ChatUser?
    @Binding var friendStatus: String

    // Connects to MainMessagesView data
    @ObservedObject private var vm = MainMessagesViewModel()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack {
            VStack {
                let bio = recipient?.bio ?? "online"
                let profile_insets = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
                let backbtn_insets = EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)

                HStack (spacing: 20) {

                    Image(systemName: "arrow.backward.circle")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 32.0, height: 32.0)
                        .padding(backbtn_insets)
                        .onTapGesture {
                            presentationMode.wrappedValue.dismiss()
                        }
                    
                    if (recipient?.profilePic != nil && recipient?.profilePic!.url != nil) {
                        AsyncImage(url: URL(string: (recipient?.profilePic!.url)!)) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                                .cornerRadius(50)
                                .padding(profile_insets)
                        }
                    placeholder: {
                        ProgressView()
                    }
                    } else {
                        Image(systemName: "person.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                            .cornerRadius(50)
                            .padding(profile_insets)
                    }

                    VStack (alignment: .leading) {
                        Text((recipient?.displayName ?? recipient?.uid) ?? "")
                            .font(.title)
                            .bold()
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .fixedSize(horizontal: true, vertical: false)
                        HStack {
                            Circle()
                                .foregroundColor(.green)
                                .frame(width: 14, height: 14)
                            Text(bio).font(.caption)
                                .foregroundColor(.white)
                        }.padding(.top, -15)
                    }

                    Image(systemName: friendStatus)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 36, height: 36)
                        .padding(.leading, 100)
                        .foregroundColor(.white)
                        .onTapGesture {
                            self.showingAlert = true
                        }
                }.alert(isPresented: $showingAlert, content: {
                    Alert(title: Text("\((friendStatus == "person.crop.circle.badge.checkmark") ? "Remove" : "Add") Friend"),
                          message: Text("Would you like to \((friendStatus == "person.crop.circle.badge.checkmark") ? "remove" : "add") \(recipient?.displayName ?? recipient?.uid ?? "them") as a friend?"),
                          primaryButton: .default(
                            Text("Cancel")),
                          secondaryButton: .default(
                            Text("Yes"),
                            action: {
                                DispatchQueue.main.async {
                                    setFriend(recipient: (recipient?.uid)!, add: friendStatus != "person.crop.circle.badge.checkmark") { _ in
                                        friendStatus = (friendStatus == "person.crop.circle.badge.checkmark") ? "person.crop.circle.badge.plus" : "person.crop.circle.badge.checkmark"
                                    }
                                }
                            })
                    )
                })
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }


            ScrollViewReader { scrollView in
                ScrollView(.vertical) {
                    ForEach(Array((vm.allMessages[target] ?? []).enumerated()), id: \.element) { index, element in
                        if index == 0 {
                            MessageBubble(msg: element)
                                 .padding(.top, 5)
                        } else if index == vm.allMessages[target]!.count-1 {
                            MessageBubble(msg: element)
                                 .padding(.bottom, 5)
                        } else {
                            MessageBubble(msg: element)
                                .padding(.top, -5)
                        }
                    }
                }
                // TODO refactor
                .onAppear {
                    if !((vm.allMessages[target]) ?? []).isEmpty {
                        scrollView.scrollTo((vm.allMessages[target]?.last)!)
                    }
                }
                .onChange(of: (vm.allMessages[target] ?? []).last) { _ in
                    withAnimation {
                        scrollView.scrollTo((vm.allMessages[target]?.last)!)
                    }
                }
                .background(Color(UIColor.systemBackground))
                .cornerRadius(30, corners: [.topLeft, .topRight])
            }

        }

        .background(Color("msgblue"))
        .navigationBarHidden(true)

        HStack {
            SendForm(tmp: Text("Type your message here"), text: $message)
            Button {
                sendMessage(msg: message, recipient: target, &vm.allMessages)
                vm.fetchUserConversations(user: user_uid) { done in
                    if done {
                        vm.extractChatListData()
                    }
                }
                message = ""
            } label: {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color("msgblue"))
                    .cornerRadius(50)
                    .padding(.trailing, -10)
            }
        }
        .padding(.horizontal, 25)
        .background(colorScheme == .dark ? Color("darkgray") : Color("gray"))
        .cornerRadius(50)
        .frame(width: 380)
    }
}

//struct MessagingView_Previews: PreviewProvider {
//    @ObservedObject private var vm = MainMessagesViewModel()
//    static var previews: some View {
//        MessageContentView()
//    }
//}

struct SendForm: View {
    var tmp: Text
    @Binding var text: String
    var editingChanged: (Bool) -> () = {_ in}
    var coms: () -> () = {}

    var body: some View {
        ZStack (alignment: .leading) {
            if text.isEmpty {
                tmp.opacity(0.5)
            }

            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: coms)
        }
    }
}
