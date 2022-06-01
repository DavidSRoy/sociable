//
//  MessageManager.swift
//  Sociable
//
//  Created by Abas Hersi on 5/16/22.
//

import Foundation


struct Usr2Msgg: Hashable, Codable {
    let name: String
    let msgs: [Msg2Compp]
}

struct Msg2Compp: Hashable, Codable {
    let sender: String
    let msg: String
    let timestamp: Timestampp
}

struct Timestampp: Hashable, Codable {
    let _seconds: Int
    let _nanoseconds: Int
}

class MessageManager: ObservableObject {
    @Published private(set) var msgs: [Msg] = []
    @Published private(set) var login: String = "john1"
    init() {
        getMessages(user1: "john1", user2: "jane1")
    }
    
    func getMessages(user1: String, user2: String) {
        retrieveMessages(user: "john1")
        retrieveMessages(user: "jane1")
        self.msgs.sort { $0.time < $1.time }
    }
    
    func retrieveMessages(user: String){
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
                  let httpResponse = response as?  HTTPURLResponse else {
                return
            }
            
            let decoder = JSONDecoder()
            let decodedData = try! decoder.decode(Usr2Msgg.self, from: data)
            for msg in decodedData.msgs {
                
                DispatchQueue.main.sync {
                    let rs = UUID().uuidString
                    let message = Msg(id: rs,  text: msg.msg, recieved: self.login.elementsEqual(msg.sender) ? false: true, time: Date())
                    var counter = 0
                    for mesg in self.msgs {
                        if(mesg.text.isEqual(msg.msg)) {
                            self.msgs.remove(at: counter)
                        }
                        counter = counter + 1
                    }
                    self.msgs.append(message)
                    self.msgs.sort { $0.time < $1.time }
                }
            }
        }.resume()
    }
    
    func sendMessage(msg: String, recipient: String) {
        let urlstring = "https://us-central1-sociable-messenger.cloudfunctions.net/messaging_api/sendMessage?uid=jane1&msg=" + msg + "&sender=john1"
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
            DispatchQueue.main.sync {
                let rs = UUID().uuidString
                let message = Msg(id: rs, text: msg, recieved: false, time: Date())
                var counter = 0
                for mesg in self.msgs {
                    if(mesg.text.isEqual(msg)) {
                        self.msgs.remove(at: counter)
                    }
                    counter = counter + 1
                }
                self.msgs.append(message)
                self.msgs.sort { $0.time < $1.time }
            }
        }.resume()
    }
}
