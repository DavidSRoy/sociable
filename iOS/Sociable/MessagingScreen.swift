//
//  ContentView.swift
//  Sociable
//
//  Created by Abas Hersi & Sulaiman Mahmood on 4/27/22.
//

import SwiftUI

public var loggedin = "john1"
public var target = "jane1"

struct Usr2Msg: Hashable, Codable {
    let name: String
    let msgs: [Msg2Comp]
}

struct Msg2Comp: Hashable, Codable {
    let sender: String
    let msg: String
    let timestamp: Timestamp
}

private func sendMessage(msg: String, recipient: String, _ allMessages: inout Dictionary<String, Array<Msg>>) {
    let sendBaseUrl = "https://us-central1-sociable-messenger.cloudfunctions.net/messaging_api/sendMessage?"
    let urlstring = sendBaseUrl + "uid=" + recipient + "&msg=" + msg + "&sender=" + loggedin
    let url = URL(string: urlstring)
    var request = URLRequest(url: url!)
    request.httpMethod = "POST"
    request.setValue("16d72d0de3fae399fe58d0ee0747cb7f5898f12c", forHTTPHeaderField: "auth")
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            fatalError("Unable to send message: \(error.localizedDescription)")
        }
    }.resume()
    let message = Msg(id: loggedin, text: msg, recieved: false, time: Timestamp())
    allMessages[recipient, default: []].append(message)
}

struct MessageContentView: View {
    @State private var message = ""
    @Binding var recipient: ChatUser?
    
    // Connects to MainMessagesView data
    @ObservedObject private var vm = MainMessagesViewModel()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            VStack {
                // TODO
                // basically needs getUsers endpoint
                // Title Row
                // let imgURL = URL(string: recipient.profileImageUrl)
                let imgURL = URL(string: "https://ca.slack-edge.com/T039K0BN264-U038Y2U704A-0da3c7494a42-512")
                let status = recipient?.status ?? "online"
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
                    
                    if (imgURL != nil) {
                        AsyncImage(url: imgURL) { image in
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
                            .font(.system(size: 44, weight: .heavy))
                    }
                    
                    VStack (alignment: .leading) {
                        Text((recipient?.name ?? recipient?.uid) ?? "").font(.title)
                            .bold()
                            .foregroundColor(.white)
                        HStack {
                            Circle()
                                .foregroundColor(.green)
                                .frame(width: 14, height: 14)
                            Text(status).font(.caption)
                                .foregroundColor(.white)
                        }.padding(.top, -15)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
            
            ScrollViewReader { scrollView in
                ScrollView(.vertical) {
                    ForEach(vm.allMessages[target] ?? [], id: \.self) { msg in
                        MessageBubble(msg: msg)
                            .padding(.top, -5)
                    }
                }
                // TODO refactor
                .onAppear {
                    if !((vm.allMessages[target]) ?? []).isEmpty {
                        scrollView.scrollTo((vm.allMessages[target]?.last)!)
                    }
                }
                .onChange(of: vm.allMessages[target]?.last) { _ in
                    withAnimation {
                        scrollView.scrollTo((vm.allMessages[target]?.last)!)
                    }
                }
                .background(.white)
                .cornerRadius(30, corners: [.topLeft, .topRight])
            }
        }
        .background(Color("msgblue"))
        .navigationBarHidden(true)
        
        HStack {
            SendForm(tmp: Text("Type your message here"), text: $message)
            Button {
                sendMessage(msg: message, recipient: target, &vm.allMessages)
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
        .background(Color("gray"))
        .cornerRadius(50)
        .frame(width: 380)
    }
}

//struct MessagingView_Previews: PreviewProvider {
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
