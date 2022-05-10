///
//  TitleRow.swift
//  Sociable
//
//

import SwiftUI

struct TitleRow: View {
    var imgURL = URL(string: "https://ca.slack-edge.com/T039K0BN264-U038Y2U704A-0da3c7494a42-512")
    var name = "David"
    var status = "Online"
    var profile_insets = EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0)
    var backbtn_insets = EdgeInsets(top: 10, leading: 60, bottom: 10, trailing: 0)
    var body: some View {
        HStack (spacing: 20) {
            AsyncImage(url: imgURL) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .cornerRadius(50)
                    .padding(profile_insets)
            }
        placeholder: {
            ProgressView()
           }
            VStack (alignment: .leading) {
                Text(name).font(.title)
                    .bold()
                    .foregroundColor(.white)
                Text(status).font(.caption)
                    .foregroundColor(.white)
            }
            Image(systemName: "arrow.backward.circle")
                .resizable()
                .foregroundColor(.white)
                .frame(width: 32.0, height: 32.0)
                .padding(backbtn_insets)
            
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
    }
}

struct TitleRow_Previews: PreviewProvider {
    static var previews: some View {
        TitleRow()
            .background(Color("msgblue"))
    }
}
