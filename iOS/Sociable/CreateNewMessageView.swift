//
//  CreateNewMessageView.swift
//  Sociable
//

import SwiftUI
import SDWebImageSwiftUI

class CreateNewMessageViewModel: ObservableObject {
    
    @ObservedObject var vm = MainMessagesViewModel()
    @Published var users = [ChatUser]()
    
    init() {
        vm.getUsers() { ret in
            self.users = ret
        }
    }
}


struct CreateNewMessageView: View {
    
     let didSelectNewUser: (ChatUser) -> ()
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var thisvm = CreateNewMessageViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(thisvm.users, id: \.self) { user in
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        didSelectNewUser(user)
                    } label: {
                        HStack(spacing: 16) {
                            if (user.profilePic != nil && user.profilePic!.url != nil) {
                                WebImage(url: URL(string: (user.profilePic!.url)!))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .clipped()
                                    .cornerRadius(50)
                                    .overlay(RoundedRectangle(cornerRadius: 50)
                                        .stroke(Color(.label),
                                                lineWidth: 2)
                                    )
                            } else {
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .clipped()
                                    .cornerRadius(50)
                                    .overlay(RoundedRectangle(cornerRadius: 50)
                                        .stroke(Color(.label),
                                                lineWidth: 2)
                                    )
                            }
                            Text(user.displayName ?? "")
                                .foregroundColor(Color(.label))
                            Spacer()
                        }.padding(.horizontal)
                            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                    }
                    Divider()
                        .padding(.vertical, 8)
                }
            }.navigationTitle("New Message")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button {
                            presentationMode.wrappedValue
                                .dismiss()
                        } label: {
                            Text("Cancel")
                        }
                    }
                }
        }
    }
}

struct CreateNewMessageView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
//        CreateNewMessageView()
    }
}
