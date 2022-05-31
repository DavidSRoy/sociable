//
//  MessageField.swift
//  Sociable
//
//  Created by Abas Hersi on 4/27/22.
//

import SwiftUI

struct MessageField: View {
    @State private var message = ""
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var mm: MessageManager
    var body: some View {
        HStack {
            SendFormm(tmp: Text("Type your message here"), text: $message)
        Button {
            mm.sendMessage(msg: message, recipient: "jane1")
            message = ""
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
        .background(colorScheme == .dark ? Color.black : Color("gray"))
        .cornerRadius(50)
        .padding()
    }
}

struct MessageField_Previews: PreviewProvider {
    static var previews: some View {
        MessageField().environmentObject(MessageManager())
    }
}

struct SendFormm: View {
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
