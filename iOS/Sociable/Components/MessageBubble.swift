//
//  MessageBubble.swift
//  Sociable
//
//  Created by Abas Hersi on 4/27/22.
//

import SwiftUI

struct MessageBubble: View {
    var msg: Msg
    @State private var displayTime = false
    var body: some View {
        VStack (alignment: msg.recieved ? .leading : .trailing) {
            HStack {
                Text(msg.text)
                    .padding(15)
                    .background(msg.recieved ? Color("gray") : Color("msgblue"))
                    .foregroundColor(msg.recieved ? .black : .white)
                    .cornerRadius(30)
            }
            .frame(maxWidth: 300, alignment: msg.recieved ? .leading : .trailing)
            .onTapGesture {
                displayTime.toggle()
            }
            
            if displayTime {
                Text("\(msg.time.formattedToDate())")
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .padding(msg.recieved ? .leading : .trailing, 25)
            }
        }
        .frame(maxWidth: .infinity, alignment: msg.recieved ? .leading : .trailing)
        .padding(msg.recieved ? .leading : .trailing)
    }
}

struct MessageBubble_Previews: PreviewProvider {
    static var previews: some View {
        MessageBubble(msg: Msg(id: "100", text: "Hey what's up. I'm excited to work on sociable. I love building apps.", recieved: false, time: Timestamp()))
    }
}

