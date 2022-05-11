//
//  Contact.swift
//  Sociable
//
//  Created by Abas Hersi on 4/28/22.
//

import SwiftUI

struct Contact: View {
    var imgURL: URL
    var name: String
    var profile_insets = EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0)
    var backbtn_insets = EdgeInsets(top: 10, leading: 120, bottom: 10, trailing: 10)
    var body: some View {
        HStack (spacing: 20) {
            AsyncImage(url: imgURL) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .cornerRadius(50)
                    .padding(profile_insets)
            }
        placeholder: {
            ProgressView()
           }
            VStack (alignment: .leading) {
                Text(name).font(.title)
                    .bold()
                    .foregroundColor(.black)
            }
            Image(systemName: "arrow.forward.circle")
                .resizable()
                .foregroundColor(.gray)
                .frame(width: 32.0, height: 32.0)
                .padding(backbtn_insets)            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
    }
}

struct Contact_Previews: PreviewProvider {
    static var previews: some View {
        Contact(imgURL: URL(string: "https://ca.slack-edge.com/T039K0BN264-U038Y2U704A-0da3c7494a42-512")!, name: "David")
            .background(Color("white"))
    }
}
