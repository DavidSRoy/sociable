//
//  NewMessageButton.swift
//  Sociable
//
//

import SwiftUI

struct NewMessageButton: View {
    var body: some View {
        Button {
        
        } label: {
            HStack {
                Spacer()
                Text("+ New Message")
                    .font(.system(size: 16, weight: .bold))
                Spacer()
            }
            .foregroundColor(.white)
            .padding(.vertical)
                .background(Color.blue)
                .cornerRadius(24)
                .padding(.horizontal)
                .shadow(radius: 15)
        }
    }
}

struct NewMessageButton_Previews: PreviewProvider {
    static var previews: some View {
        NewMessageButton()
    }
}
