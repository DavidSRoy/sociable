//
//  ContentView.swift
//  Sociable
//
//  Created by Abas Hersi & Sulaiman Mahmood on 4/27/22.
//

import SwiftUI

public var loggedin = "john1"
// TODO will need to get value from MainMessagesView
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

class MessagingScreenViewModel: ObservableObject {
    
    public func sendMessages(msg: String, recipient: String) {
        let urlstring = "https://us-central1-sociable-messenger.cloudfunctions.net/messaging_api/sendMessage?uid=jane1&msg=Sup&sender=john1"
        let url = URL(string: urlstring)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("16d72d0de3fae399fe58d0ee0747cb7f5898f12c", forHTTPHeaderField: "auth")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                fatalError("There was an error with your network request: \(error.localizedDescription)")
            }
            
            guard let data = data else {
                return
            }
            
            let message = Msg(id: loggedin, text: msg, recieved: false, time: Timestamp())
            //            messages.append(message) TODO fix
        }.resume()
    }
}

struct MessageContentView: View {
    @State private var message = ""
    @State var ref: Bool = false
    
    // Connects to MainMessagesView data
    @ObservedObject private var vm = MainMessagesViewModel()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var dexMsgs = ["Hey what's up. I'm excited to work on sociable. I love building apps.", "I'm glad that you've joined us! Excited for things to come! 🙂"]
    var mexMsgs = ["Nice to meet you David, I'm also excited about working on Sociable!", " and likewise! 👌"]
    
    var body: some View {
        VStack {
            VStack {
                // Title Row
                var imgURL = URL(string: "https://ca.slack-edge.com/T039K0BN264-U038Y2U704A-0da3c7494a42-512")
                var name = "David"
                var status = "online"
                var profile_insets = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
                var backbtn_insets = EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
                
                HStack (spacing: 20) {
                    
                    Image(systemName: "arrow.backward.circle")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 32.0, height: 32.0)
                        .padding(backbtn_insets)
                        .onTapGesture {
                            presentationMode.wrappedValue.dismiss()
                        }
                    
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
                    VStack (alignment: .leading) {
                        Text(name).font(.title)
                            .bold()
                            .foregroundColor(.white)
                        Text(status).font(.caption)
                            .foregroundColor(.white)
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
                .onAppear {
                    if !((vm.allMessages[target]) ?? []).isEmpty {
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
                // sendMessages(msg: message, recipient: "jane1")
                ref.toggle()
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

struct MessagingView_Previews: PreviewProvider {
    static var previews: some View {
        MessageContentView()
    }
}

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
