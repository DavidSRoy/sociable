//
//  ContactScreen.swift
//  Sociable
//
//  Created by Abas Hersi on 4/28/22.
//

import SwiftUI

struct ContactScreen: View {
    @StateObject
    private var cvm = ContactBubble()
    var profiles = ["https://ca.slack-edge.com/T039K0BN264-U038Y2U704A-0da3c7494a42-512" , "https://ca.slack-edge.com/T039K0BN264-U038Y2U704A-0da3c7494a42-512", "https://ca.slack-edge.com/T039K0BN264-U038Y2U704A-0da3c7494a42-512"];
    var names = ["David", "Sarah", "Marty"]
    var body: some View {
        ContactTitleRow()
        NavigationView {
                List {
                    ForEach(cvm.contacts) { contact in
                        VStack(alignment: .leading) {
                            HStack {
                                Label(contact.fname, systemImage: "person.crop.circle")
                                Text(contact.lname)
                            }
                            Divider()
                            Label(contact.phone ?? "Not Found", systemImage: "apps.iphone")
                        }
                        .padding()
                        .background(Color("msgblue"))
                        .clipShape(RoundedRectangle(cornerRadius: 15.0, style: .continuous))
                    }
                }
                .padding(.top, 10)
                .background(.white)
            }
        .alert(item: $cvm.perme) {  h in
            Alert(
                title: Text("Permission Denied"),
                message: Text(cvm.perme?.desc ?? "Unknown Error"),
                dismissButton:
                        .default(Text("OK"))

            )
        }
        }
    }

struct ContactScreen_Previews: PreviewProvider {
    static var previews: some View {
        ContactScreen()
    }
}
