//
//  ContentView.swift
//  Sociable
//
//  Created by Abas Hersi & Sulaiman Mahmood on 4/27/22.
//

import SwiftUI

public var messages = [Msg]()
public var loggedin = "john1"

struct Usr2Msg: Hashable, Codable {
    let name: String
    let msgs: [Msg2Comp]
}

struct Msg2Comp: Hashable, Codable {
    let sender: String
    let msg: String
    let timestamp: Timestamp
}

struct Timestamp: Hashable, Codable {
    let _seconds, _nanoseconds: Int
}

public func fetchMessages(user: String) {
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
        
        guard let response = response,
              let httpResponse = response as? HTTPURLResponse else {
            return
        }
        
        let decoder = JSONDecoder()
        let decodedData = try! decoder.decode(Usr2Msg.self, from: data)
        for msg in decodedData.msgs {
            
            let message = Msg(id: msg.sender,  text: msg.msg, recieved: loggedin.elementsEqual(msg.sender) ? false: true, time: Date())
            messages.append(message)
        }
    }.resume()
}

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
        
        guard let response = response,
              let httpResponse = response as?  HTTPURLResponse else {
            return
        }
        
            
        let message = Msg(id: "john1", text: msg, recieved: false, time: Date())
            messages.append(message)
    }.resume()
}

class MsgContainer: ObservableObject {
    
}

struct MessageContentView: View {
    @State private var message = ""
    @State var ref: Bool = false
    
    var dexMsgs = ["Hey what's up. I'm excited to work on sociable. I love building apps.", "I'm glad that you've joined us! Excited for things to come! 🙂"]
    var mexMsgs = ["Nice to meet you David, I'm also excited about working on Sociable!", " and likewise! 👌"]
    let john = fetchMessages(user: "john1")
    let jane = fetchMessages(user: "jane1")
    var body: some View {
        VStack {
        VStack {
            TitleRow()
            ScrollView {
                ForEach (messages, id: \.self) { msg in
                    MessageBubble(msg: msg)
                }
            }
            .padding(.top, 10)
            .background(.white)
            .cornerRadius(30)
        }
        .background(Color("msgblue"))
            HStack {
                SendForm(tmp: Text("Type your message here"), text: $message)
            Button {
            sendMessages(msg: message, recipient: "jane1")
            ref.toggle()
            }
        label: {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color("msgblue"))
                    .cornerRadius(50)
            }
          }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(Color("gray"))
            .cornerRadius(50)
            .padding()
        }

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
