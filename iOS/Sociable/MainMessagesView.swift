//
//  MainMessagesView.swift
//  Sociable
//
//

import SwiftUI
import SDWebImageSwiftUI

class MainMessagesViewModel: ObservableObject {
    
    @Published var chatUser: ChatUser?
    // * used namely for name + uid
    // (ChatUser*, most recent message in conversation)
    @Published var chatListData: Array<(ChatUser, Msg?)> = []
    // K: recipient, V: entire convo between user and recipient
    @Published var allMessages: Dictionary<String, Array<Msg>> = [:]
    
    init() {
        fetchCurrentUser()
        fetchUserConversations(user: loggedin) { done in
            if done {
                self.extractChatListData()
            }
        }
    }
    
    private func fetchMessages(user: String, completion: (([Msg]) -> Void)? = nil ) {
        var messages = [Msg]()
        let url = URL(string: "https://us-central1-sociable-messenger.cloudfunctions.net/messaging_api/getMessages?uid=" + user)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("16d72d0de3fae399fe58d0ee0747cb7f5898f12c", forHTTPHeaderField: "auth")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                fatalError("There was an error with your network request: \(error.localizedDescription)")
            }
            
            guard let data = data else {
                return
            }
            
            let decoder = JSONDecoder()
            let decodedData = try! decoder.decode(Usr2Msg.self, from: data)
            for msg in decodedData.msgs {
                let message = Msg(id: msg.sender, text: msg.msg, recieved: loggedin.elementsEqual(msg.sender) ? false : true, time: msg.timestamp)
                messages.append(message)
            }
            messages = messages.sorted()
            DispatchQueue.main.async {
                completion?(messages)
            }
        }.resume()
    }
    
    private func fetchUserConversations(user: String, completion: ((Bool) -> Void)? = nil) {
        let dispatch = DispatchGroup()
        // user = uid
        fetchMessages(user: user) { MsgResponse in
            // Reduce all received messages to respective uid to messages
            for msg in MsgResponse {
                self.allMessages[msg.id, default: []].append(msg)
            }
            // Append all sent messages from user to respective uid
            for (uid, _) in self.allMessages {
                dispatch.enter()
                self.fetchMessages(user: uid) { userMsgs in
                    for msg in userMsgs where msg.id == user {
                        self.allMessages[uid]?.append(msg)
                    }
                    self.allMessages[uid]?.sort()
                    dispatch.leave()
                }
            }
            dispatch.notify(queue: .main) {
                completion?(true)
            }
        }
    }
    
    private func fetchCurrentUser() {
        // TODO
        // need to convert username/email->uid to use for other endpoints
        // as uid is not generated locally
        let url = URL(string: "https://us-central1-sociable-messenger.cloudfunctions.net/messaging_api/getMessages?uid=" + "john1") //username/email
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("16d72d0de3fae399fe58d0ee0747cb7f5898f12c", forHTTPHeaderField: "auth")
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                fatalError("Failed to get current user information: \(error.localizedDescription)")
            }
            
            guard let data = data else {
                return
            }
            DispatchQueue.main.async {
                let decoder = JSONDecoder()
                do {
                    let parsed = try decoder.decode(ChatUser.self, from: data)
                    // All the ChatUsers that user has DMed
                    self.chatUser = parsed
                    // print(parsed)
                }
                catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    // Assumes that messages are sorted in ascending timestamps
    private func extractChatListData() {
        for (uid, _) in allMessages {
            // TODO uid is username for now, but should be database-generated uid
            chatListData.append((ChatUser(uid: uid), allMessages[uid]?.last))
        }
        // most recent messages first
        chatListData.sort(by: { $0.1! < $1.1! })
    }
}

struct MainMessagesView: View {
    
    @State var status = "online"
    @State var showFullScreen = false
    @State var navigateToChatLogView = false
    @State var chatUser: ChatUser?
    @State var selectedRecipient: ChatUser?
    
    
    @ObservedObject private var vm = MainMessagesViewModel()
    
    private var customNavBar: some View {
        HStack(spacing: 16) {
            let imageUrl = vm.chatUser?.profileImageUrl
            if (imageUrl != nil) {
                WebImage(url: URL(string:
                                    imageUrl ?? ""))
                .resizable()
                .scaledToFill()
                .frame(width: 44, height: 44)
                .clipped()
                .cornerRadius(44)
                .overlay(RoundedRectangle(cornerRadius: 44)
                    .stroke(Color(.label), lineWidth: 1))
                .shadow(radius: 5)
            } else {
                Image(systemName: "person.fill")
                    .font(.system(size: 44, weight: .heavy))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                // logic for email addresses
                let strip = "\(vm.chatUser?.name ?? "")"
                    .split(separator: "@")
                let displayName = strip.count > 0 ? strip[0] : ""
                Text(displayName)
                    .font(.system(size: 24, weight: .bold))
                    .scaledToFit()
                    .minimumScaleFactor(0.01)
                
                HStack {
                    Circle()
                        .foregroundColor(.green)
                        .frame(width: 14, height: 14)
                    // TODO need status from endpoint
                    Text(vm.chatUser?.status ?? status)
                        .font(.system(size: 12))
                        .foregroundColor(Color(.lightGray))
                }
            }
            Spacer()
            Button {
                showFullScreen.toggle()
            } label: {
                Image(systemName: "square.and.pencil")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(.label))
            }
            .fullScreenCover(isPresented: $showFullScreen) {
                CreateNewMessageView(didSelectNewUser: { user in
                    self.navigateToChatLogView.toggle()
                    self.chatUser = user
                })
            }
        }
        .padding()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                customNavBar
                messagesView
                
                NavigationLink("", isActive: $navigateToChatLogView) {
                    Text("Chat Log View")
                }
            }
            .navigationBarHidden(true)
        }
        .navigationBarHidden(true)
    }
    
    private var messagesView: some View {
        ScrollView {
            // (ChatUser, Msg)
            ForEach(vm.chatListData, id: \.0) { tuple in
                VStack {
                    // MessagingScreen
                    NavigationLink(destination: MessageContentView(recipient: $selectedRecipient), label: {
                        HStack(spacing: 16) {
                            // TODO
                            // need uid->url. msg.sender.profileImageUrl
                            // technically possible with getMessages(uid)
                            let imageUrl = vm.chatUser?.profileImageUrl
                            if (imageUrl != nil) {
                                WebImage(url: URL(string:
                                                    imageUrl ?? ""))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 32, height: 32)
                                .clipped()
                                .cornerRadius(44)
                                .overlay(RoundedRectangle(cornerRadius: 44)
                                    .stroke(Color(.label), lineWidth: 1))
                                .shadow(radius: 5)
                            } else {
                                Image(systemName: "person.fill")
                                    .font(.system(size: 32))
                                    .padding(8)
                                    .overlay(RoundedRectangle(cornerRadius: 44)
                                        .stroke(Color(.label), lineWidth: 1))
                            }
                            
                            VStack(alignment: .leading) {
                                Text((tuple.0.name ?? tuple.0.uid) ?? "")
                                    .font(.system(size: 14,
                                                  weight: .bold))
                                
                                Text((tuple.1?.text)!)
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(
                                        .lightGray))
                            }
                            
                            Spacer()
                            
                            Text(timeFormatter((tuple.1?.time._seconds)!))
                                .font(.system(size: 14, weight:
                                        .semibold))
                        }
                        .padding(.top, 3)
                    }).simultaneousGesture(TapGesture().onEnded {
                        selectedRecipient = tuple.0
                    })
                    Divider()
                        .padding(.vertical, 8)
                }.padding(.horizontal)
                
            }.padding(.bottom, 50)
        }
    }
}

private func timeFormatter(_ ts: Int) -> String {
    let seconds = Int(NSDate().timeIntervalSince1970) - ts
    let days = seconds / 86400
    let hours = seconds / 3600
    let min = (seconds % 3600) / 60
    let sec = (seconds % 3600) % 60
    if days >= 1 {
        return String(days) + "d"
    } else if hours >= 1 {
        return String(hours) + "h"
    } else if min >= 1 {
        return String(min) + "m"
    } else {
        return String(sec) + "s"
    }
}

//struct MainMessagesView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainMessagesView()
//    }
//}
