//
//  MainMessagesView.swift
//  Sociable
//
//

import SwiftUI
import SDWebImageSwiftUI

// testing purposes
//public var loggedin = "john1"

class MainMessagesViewModel: ObservableObject {
    
    @Published var chatUser: ChatUser?
    // * used namely for name + uid
    // (ChatUser*, most recent message in conversation)
    @Published var chatListData: Array<(ChatUser, Msg?)> = []
    // K: recipient, V: entire convo between user and recipient
    @Published var allMessages: Dictionary<String, Array<Msg>> = [:]
    @Published var friendsList: Array<String> = []
    
    init() {
        fetchCurrentUser()
        fetchCurrentUserFriends()
        fetchUserConversations(user: loggedin) { done in
            if done {
                self.extractChatListData()
            }
        }
    }
    
    private func fetchMessages(user: String, completion: (([Msg]) -> Void)? = nil ) {
        if user == "" { return }
        var messages = [Msg]()
        let url = URL(string: "https://us-central1-sociable-messenger.cloudfunctions.net/messaging_api/getMessages?uid=" + user)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("16d72d0de3fae399fe58d0ee0747cb7f5898f12c", forHTTPHeaderField: "auth")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                fatalError("There was an error with your network request: \(error.localizedDescription)")
            }
            
            let response1 = response as! HTTPURLResponse
            if (response1.statusCode != 200) {
                print("Unable to fetch messages for \(user): error " + String(response1.statusCode))
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(Usr2Msg.self, from: data)
                for msg in decodedData.msgs {
                    let message = Msg(id: msg.sender, text: msg.msg, recieved: loggedin.elementsEqual(msg.sender) ? false : true, time: msg.timestamp)
                    messages.append(message)
                }
                messages = messages.sorted()
                DispatchQueue.main.async {
                    completion?(messages)
                }
            } catch Swift.DecodingError.dataCorrupted(let context) {
                print("\nJSON Parse Error at fetchMessages()\nError: \(context.debugDescription)\n")
            } catch let context {
                print("\nError at fetchMessages(): \(context.localizedDescription)\n")
            }
        }.resume()
    }
    
    func fetchUserConversations(user: String, completion: ((Bool) -> Void)? = nil) {
        if user == "" { return }
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
    
    // email is username
    private func fetchCurrentUser() {
        if loggedin == "" { return }
        let url = URL(string: "https://us-central1-sociable-messenger.cloudfunctions.net/messaging_api/getMessages?uid=" + loggedin)
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
                }
                catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    private func fetchCurrentUserFriends() {
        let url = URL(string: "https://us-central1-sociable-messenger.cloudfunctions.net/users_api/getFriends?uid=" + loggedin)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("7f5c4e71e19bdd8c793f1677867ef4db007988f6", forHTTPHeaderField: "auth")
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                fatalError("Failed to get current user friends: \(error.localizedDescription)")
            }
            
            guard let data = data else {
                return
            }
            // Does not use JSON
            DispatchQueue.main.async {
                self.friendsList = (try? JSONSerialization.jsonObject(with: data, options: []) as? [String]) ?? []
            }
        }.resume()
    }
    
    // Assumes that messages are sorted in ascending timestamps
    func extractChatListData() {
        for (uid, _) in allMessages {
            // TODO uid is username for now, but should be database-generated uid
            chatListData.append((ChatUser(uid: uid), allMessages[uid]?.last))
        }
        // most recent messages first
        chatListData.sort(by: { $0.1! < $1.1! })
    }
    
    func getUserInfo(email: String, completion: ((ChatUser) -> Void)? = nil) {
        let url = URL(string: "https://us-central1-sociable-messenger.cloudfunctions.net/users_api/getUserInfo?uid=" + email)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("7f5c4e71e19bdd8c793f1677867ef4db007988f6", forHTTPHeaderField: "auth")
        URLSession.shared.dataTask(with: request) { data, _, _ in
            // Show no error message for setting display name
            
            guard let data = data else {
                return
            }
            DispatchQueue.main.async {
                let decoder = JSONDecoder()
                do {
                    let parsed = try decoder.decode(ChatUser.self, from: data)
                    completion?(parsed)
                }
                catch {
                    print(error)
                }
            }
            
        }.resume()
    }
    
    func setDisplayName(email: String, displayName: String) {
        let url = URL(string: "https://us-central1-sociable-messenger.cloudfunctions.net/users_api/setDisplayName?uid=" + email + "&displayName=" + displayName)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("7f5c4e71e19bdd8c793f1677867ef4db007988f6", forHTTPHeaderField: "auth")
        URLSession.shared.dataTask(with: request) { _, response, _ in
            // Show no error message for setting display name
            
            let response1 = response as! HTTPURLResponse
            if (response1.statusCode == 200) {
                self.getUserInfo(email: email) { updatedUser in
                    self.updateLocalUser(updatedUser)
                }
            }
        }.resume()
    }
    
    // ideally would store as variable but not sure how to call only once (such as with init())
    func isFriend(_ recipient: ChatUser?) -> Bool {
        return self.friendsList.contains(recipient?.uid ?? "")
    }
    
    func updateLocalUser(_ updatedUser: ChatUser) {
        self.chatUser!.update(&chatUser!, updatedUser)
    }
}

struct MainMessagesView: View {
    
    @State var status = "online"
    @State var showFullScreen = false
    @State var chatUser: ChatUser?
    @State var selectedRecipient: ChatUser?
    @State var friendStatus = ""
    
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
                let strip = "\(vm.chatUser?.displayName ?? "")"
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
                    self.chatUser = user
                })
            }
        }
        .padding()
    }
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor.systemBackground
    }
    
    // iOS 15 bug causes temporary view shift...apparently
    var body: some View {
        NavigationView {
            TabView {
                VStack {
                    customNavBar
                    messagesView
                }
                .accentColor(.none)
                .navigationBarHidden(true)
                .tabItem {
                    Text("Home")
                    Image(systemName: "house").renderingMode(.template)
                }.tag(1)
                
                VStack {
                    ContactScreen()
                }
                .accentColor(.none)
                .navigationBarHidden(true)
                .tabItem {
                    Text("Contacts")
                    Image(systemName: "person.crop.circle").renderingMode(.template)
                        
                }.tag(2)
            }.accentColor(.black)
        }
        .navigationBarHidden(true)
    }
    
    private var messagesView: some View {
        ScrollView {
            // (ChatUser, Msg)
            ForEach(vm.chatListData, id: \.0) { tuple in
                VStack {
                    // MessagingScreen
                    NavigationLink(destination: MessageContentView(recipient: $selectedRecipient, friendStatus: $friendStatus), label: {
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
                                Text((tuple.0.displayName ?? tuple.0.uid) ?? "")
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
                        // Tapping on a chat box
                    }).simultaneousGesture(TapGesture().onEnded {
                        selectedRecipient = tuple.0
                        friendStatus = vm.isFriend(selectedRecipient) ? "person.crop.circle.badge.plus" : "person.crop.circle.badge.plus"
//                        vm.fetchUserConversations(user: loggedin) { done in
//                            if done {
//                                vm.extractChatListData()
//                            }
//                        }
                    })
                    Divider()
                        .padding(.vertical, 8)
                }.padding(.horizontal)
                
            }.padding(.bottom, 50)
        }
    }
    
    private var statusView: some View {
        NavigationView {
            Text("My Status")
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
