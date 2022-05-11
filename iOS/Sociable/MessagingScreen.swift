//
//  ContentView.swift
//  Sociable
//
//  Created by Abas Hersi on 4/27/22.
//

import SwiftUI

struct MessageContentView: View {
    var dexMsgs = ["Hey what's up. I'm excited to work on sociable. I love building apps.", "I'm glad that you've joined us! Excited for things to come! 🙂"]
    var mexMsgs = ["Nice to meet you David, I'm also excited about working on Sociable!", " and likewise! 👌"]

    var body: some View {
        VStack {
        VStack {
            TitleRow()
            ScrollView {
                ForEach (dexMsgs, id: \.self) { text in
                    MessageBubble(msg: Msg(id: 123, text: text, recieved: true, time: Date()))
                }
                ForEach (mexMsgs, id: \.self) { text in
                    MessageBubble(msg: Msg(id: 123, text: text, recieved: false, time: Date()))
                }
            }
            .padding(.top, 10)
            .background(.white)
            .cornerRadius(30)
        }
        .background(Color("msgblue"))
        MessageField()
        }

    }
}

struct MessagingView_Previews: PreviewProvider {
    static var previews: some View {
        MessageContentView()
    }
}
