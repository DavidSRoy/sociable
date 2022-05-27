//
//  MainMessagesView.swift
//  Sociable
//
//

import SwiftUI
import SDWebImageSwiftUI

class MainMessagesViewModel: ObservableObject {
    
    @Published var errorMessage = ""
    @Published var chatUser: ChatUser?
    @Published var chatListData: Array<Msg2Comp> = []
    
    init() {
        fetchCurrentUser()
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
                fatalError("There was an error with your network request: \(error.localizedDescription)")
            }
            
            guard let data = data else {
                return
            }
            DispatchQueue.main.async {
                let decoder = JSONDecoder()
                do {
                    let parsed = try decoder.decode(ChatUser.self, from: data)
                    self.chatUser = parsed
                    self.extractChatListData()
                    print(parsed)
                }
                catch {
                  print(error)
                }
            }
        }.resume()
    }
    
    // Assumes that messages are sorted in ascending timestamps
    private func extractChatListData() {
        var seen: Set<String> = []
        // iterates from bottom-up
        if let reversedMsgs = chatUser?.msgs.reversed() {
            for msg in reversedMsgs {
                if seen.insert(msg.sender).inserted {
                    chatListData.append(msg)
                }
            }
        }
    }
}

struct MainMessagesView: View {
    
    @State var status = "online"
    
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
                
            } label: {
                Image(systemName: "square.and.pencil")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(.label))
            }
        }
        .padding()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                customNavBar
                messagesView
            }
            .navigationBarHidden(true)
        }
        .navigationBarHidden(true)
    }
        
    private var messagesView: some View {
        ScrollView {
            ForEach(vm.chatListData, id: \.self) { msg in
                VStack {
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
                            // TODO
                            // should be name
                            Text(msg.sender)
                                .font(.system(size: 14,
                                    weight: .bold))
                            Text(msg.msg)
                                .font(.system(size: 14))
                                .foregroundColor(Color(
                                    .lightGray))
                        }
                        Spacer()
                        
                        Text(timeFormatter(msg.timestamp._seconds))
                            .font(.system(size: 14, weight:
                                    .semibold))
                    }
                    Divider()
                        .padding(.vertical, 8)
                }.padding(.horizontal)
                
            }.padding(.bottom, 50)
        }
    }
}

private func timeFormatter(_ ts: Int) -> String {
    let seconds = Int(NSDate().timeIntervalSince1970) - ts
    let hours = seconds / 3600
    let min = (seconds % 3600) / 60
    let sec = (seconds % 3600) % 60
    if hours >= 1 {
        return String(hours) + "h"
    } else if min >= 1 {
        return String(min) + "m"
    } else {
        return String(sec) + "s"
    }
}

struct MainMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
    }
}
