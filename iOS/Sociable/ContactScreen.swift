//
//  ContactScreen.swift
//  Sociable
//
//  Created by Abas Hersi on 4/28/22.
//

import SwiftUI

struct ContactScreen: View {
    var profiles = ["https://ca.slack-edge.com/T039K0BN264-U038Y2U704A-0da3c7494a42-512" , "https://ca.slack-edge.com/T039K0BN264-U038Y2U704A-0da3c7494a42-512", "https://ca.slack-edge.com/T039K0BN264-U038Y2U704A-0da3c7494a42-512"];
    var names = ["David", "Sarah", "Marty"]
    var body: some View {
        VStack {
            VStack {
                ContactTitleRow()
                ScrollView {
                    ForEach (names.indices, id: \.self) { value in
                        Contact(imgURL: URL(string: profiles[value])!, name: names[value])
                    }
                }
                .padding(.top, 10)
                .background(.white)
            }
            .background(Color("msgblue"))
        }
    }
}

struct ContactScreen_Previews: PreviewProvider {
    static var previews: some View {
        ContactScreen()
    }
}
