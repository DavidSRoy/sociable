//
//  ContactTitleRow.swift
//  Sociable
//
//

import SwiftUI

struct ContactTitleRow: View {
    var profile_insets = EdgeInsets(top: 0, leading: 115, bottom: 0, trailing: 0)
    var body: some View {
        HStack (spacing: 20) {
            VStack (alignment: .leading) {
                Text("Contacts").font(.title)
                    .bold()
                    .padding(profile_insets)
                    .foregroundColor(.white)
            }
            
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
    }
}

struct ContactTitleRow_Previews: PreviewProvider {
    static var previews: some View {
        ContactTitleRow()
            .background(Color("msgblue"))
    }
}
