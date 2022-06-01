//
//  MainMessagesView.swift
//  Sociable
//
//

import SwiftUI
import SDWebImageSwiftUI

// testing purposes
public var user_uid : String {
    get {
        return UserDefaults.standard.string(forKey: "savedUid") ?? ""
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "savedUid")
    }
}

class MainMessagesViewModel: ObservableObject {
    
    @Published var chatUser: ChatUser?
    // * used namely for name + uid
    // (ChatUser*, most recent message in conversation)
    @Published var chatListData: Array<(ChatUser, Msg?)> = []
    // K: recipient, V: entire convo between user and recipient
    @Published var allMessages: Dictionary<String, Array<Msg>> = [:]
    @Published var friendsList: Array<String> = []
    @Published var allUsers = [ChatUser]()
    
    init() {
        if user_uid == "" { return }
        getUserInfo(uid: user_uid)
        fetchCurrentUserFriends()
        fetchUserConversations(user: user_uid) { done in
            if done {
                self.extractChatListData()
            }
        }
    }
    
    func fetchMessages(user: String, completion: (([Msg]) -> Void)? = nil ) {
        if user == "" { return }
        var messages = [Msg]()
        let url = URL(string: "https://us-central1-sociable-messenger.cloudfunctions.net/messaging_api/getMessages?uid=" + user)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("7f5c4e71e19bdd8c793f1677867ef4db007988f6", forHTTPHeaderField: "auth")
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
                print("JSON Parse Error at fetchMessages()\nError: \(context.debugDescription)")
            } catch let context {
                // print("Error at fetchMessages(): \(context.localizedDescription)")
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
    
    private func fetchCurrentUserFriends() {
        let url = URL(string: "https://us-central1-sociable-messenger.cloudfunctions.net/users_api/getFriends?uid=" + user_uid)
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
        let dispatch = DispatchGroup()
        for (uid, _) in allMessages {
            dispatch.enter()
            getUserInfo(uid: uid) { ret in
                // since api doesn't give back UID
                self.chatListData.append((ChatUser(uid: uid, email: ret.email, displayName: ret.displayName, dob: ret.dob, profilePic: ret.profilePic, bio: ret.bio, friends: ret.friends, msgs: ret.msgs), self.allMessages[uid]?.last))
            }
        }
        dispatch.leave()
        // most recent messages first
        chatListData.sort(by: { $0.1! < $1.1! })
    }
    
    func getUsers(completion: (([ChatUser]) -> Void)? = nil) {
        // currently fetches ALL users on app
        let url = URL(string: "https://us-central1-sociable-messenger.cloudfunctions.net/users_api/getUsers")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("7f5c4e71e19bdd8c793f1677867ef4db007988f6", forHTTPHeaderField: "auth")
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                fatalError("Failed to fetch users: \(error.localizedDescription)")
            }
            
            guard let data = data else {
                return
            }
            DispatchQueue.main.async {
                let decoder = JSONDecoder()
                do {
                    let parsed = try decoder.decode([ChatUser].self, from: data)
                    completion?(parsed)
                }
                catch {
                  print(error)
                }
            }
        }.resume()
    }
    
    func getUserInfo(uid: String, completion: ((ChatUser) -> Void)? = nil) {
        let url = URL(string: "https://us-central1-sociable-messenger.cloudfunctions.net/users_api/getUserInfo?uid=" + uid)
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
    
    // uid = autogenerated string
    func setDisplayName(uid: String, displayName: String) {
        let url = URL(string: "https://us-central1-sociable-messenger.cloudfunctions.net/users_api/setDisplayName?uid=" + uid + "&displayName=" + displayName)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("7f5c4e71e19bdd8c793f1677867ef4db007988f6", forHTTPHeaderField: "auth")
        URLSession.shared.dataTask(with: request) { _, response, _ in
            // Show no error message for setting display name
            
            let response1 = response as! HTTPURLResponse
            if (response1.statusCode == 200) {
                self.getUserInfo(uid: uid) { updatedUser in
                    self.updateLocalUser(updatedUser)
                }
            } else {
                print("Failed to set display name \(displayName)")
            }
        }.resume()
    }
    
    func setProfilePhoto(uid: String, filePath: String, completion: ((Bool) -> Void)? = nil) {
        let url = URL(string: "https://us-central1-sociable-messenger.cloudfunctions.net/users_api/setProfilePhoto?uid=" + uid + "&filePath=" + filePath)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("7f5c4e71e19bdd8c793f1677867ef4db007988f6", forHTTPHeaderField: "auth")
        URLSession.shared.dataTask(with: request) { _, response, error in
            
            if let error = error {
                fatalError("ERROR - setProfilePhoto: \(error.localizedDescription)")
            }
            
            let response1 = response as! HTTPURLResponse
            if (response1.statusCode == 200) {
                completion?(true)
                self.getUserInfo(uid: uid) { updatedUser in
                    self.updateLocalUser(updatedUser)
                }
            } else {
                print("Failed to set profile photo - path: \(filePath)")
                completion?(false)
            }
        }.resume()
    }
    
    func getProfilePhoto(filename: String, completion: ((String) -> Void)? = nil) {
        let url = URL(string: "https://us-central1-sociable-messenger.cloudfunctions.net/messaging_api/getImage?filename=" + filename)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("7f5c4e71e19bdd8c793f1677867ef4db007988f6", forHTTPHeaderField: "auth")
        URLSession.shared.dataTask(with: request) { data, response, _ in
            
            let response1 = response as! HTTPURLResponse
            if (response1.statusCode == 200) {
                let outputStr = String(data: data!, encoding: String.Encoding.utf8)
                completion?(outputStr!)
            } else {
                print("Failed to get profile photo - filename: \(filename)")
            }
        }.resume()
    }
    
    // ideally would store as variable but not sure how to call only once (such as with init())
    func isFriend(_ recipient: ChatUser?) -> Bool {
        return self.friendsList.contains(recipient?.uid ?? "")
    }
    
    func updateLocalUser(_ updatedUser: ChatUser) {
        if self.chatUser == nil {
            self.chatUser = updatedUser
        } else {
            self.chatUser!.update(&chatUser!, updatedUser)
        }
    }
}

struct MainMessagesView: View {
    
    @State var bio = "online"
    @State var showFullScreen = false
    @State var chatUser: ChatUser?
    @State var selectedRecipient: ChatUser?
    @State var friendStatus = ""
    @State var navigateToSelectedRecipientChat = false
    
    @ObservedObject private var vm = MainMessagesViewModel()
    
    private var customNavBar: some View {
        HStack(spacing: 16) {
            if (vm.chatUser?.profilePic != nil) {
                WebImage(url: URL(string: (vm.chatUser?.profilePic!.url)!))
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
                    // TODO need bio from endpoint
                    Text(vm.chatUser?.bio ?? bio)
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
                    self.selectedRecipient = user
                    target = (self.selectedRecipient?.uid)!
                    friendStatus = vm.isFriend(selectedRecipient) ? "person.crop.circle.badge.plus" : "person.crop.circle.badge.plus"
                    self.navigateToSelectedRecipientChat.toggle()
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
                    NavigationLink("", isActive: $navigateToSelectedRecipientChat) {
                        MessageContentView(recipient: $selectedRecipient, friendStatus: $friendStatus)
                    }
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
        // When user arrives to main screen
        .onAppear {
            vm.getUsers() { chatUsers in
                let dispatch = DispatchGroup()
                print(loggedin) // email
                for user in chatUsers {
                    dispatch.enter()
                    if user.email == loggedin {
                        user_uid = user.uid ?? ""
                        displayName = user.displayName ?? ""
                        break
                    }
                }
                dispatch.leave()
                vm.allUsers = chatUsers
                
                print("done", user_uid)
                
                // ** EXPENSIVE OPERATION **
                for user in vm.allUsers {
                    dispatch.enter()
                    vm.fetchMessages(user: (user.uid)!) { messages in
                        for msg in messages {
                            if msg.id == user_uid {
                                // should be uid
                                vm.allMessages[(user.uid)!, default: []].append(msg)
                            }
                        }
                        vm.extractChatListData()
                        dispatch.leave()
                    }
                }
                
                vm.getUserInfo(uid: user_uid) { chatUser in
                    self.chatUser = chatUser
                }
                
                if displayName != "" {
                    vm.setDisplayName(uid: user_uid, displayName: displayName)
                }
                if profileImageURLString != "" {
                    vm.setProfilePhoto(uid: user_uid, filePath: profileImageURLString)
                }
                if vm.chatUser?.profilePic != nil { 
                    vm.getProfilePhoto(filename: (vm.chatUser?.profilePic!.fileName)!) { url in
                        vm.chatUser?.profilePic?.url = url
                    }
                }
            }
        }
    }
    
    private var messagesView: some View {
        ScrollView {
            // (ChatUser, Msg)
            ForEach(vm.chatListData, id: \.0) { tuple in
                VStack {
                    // MessagingScreen
                    NavigationLink(destination: MessageContentView(recipient: $selectedRecipient, friendStatus: $friendStatus), label: {
                        HStack(spacing: 16) {
                            if (vm.chatUser?.profilePic != nil) {
                                WebImage(url: URL(string: (vm.chatUser?.profilePic!.fileName)!))
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
                        target = selectedRecipient?.uid ?? ""
                        friendStatus = vm.isFriend(selectedRecipient) ? "person.crop.circle.badge.plus" : "person.crop.circle.badge.plus"
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
