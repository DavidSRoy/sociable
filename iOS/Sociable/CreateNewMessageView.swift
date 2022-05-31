//
//  CreateNewMessageView.swift
//  Sociable
//

import SwiftUI
import SDWebImageSwiftUI

class CreateNewMessageViewModel: ObservableObject {
    
    @Published var users = [ChatUser]()
    @Published var errorMessage = ""
    
    init() {
//        fetchAllUsers()
    }
    
    private func fetchAllUsers() {
        // currently fetches ALL users on app
        let url = URL(string: "https://us-central1-sociable-messenger.cloudfunctions.net/users_api/getUsers")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("7f5c4e71e19bdd8c793f1677867ef4db007988f6", forHTTPHeaderField: "auth")
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                fatalError("Failed to fetch users: \(error.localizedDescription)")
            }
            
            guard let data = data else {
                return
            }
            DispatchQueue.main.async {
                let decoder = JSONDecoder()
                do {
                    let parsed = try decoder.decode([ChatUser].self, from: data)
                    // print(parsed.first!.name)
                }
                catch {
                  print(error)
                }
            }
        }.resume()
    }
}

struct CreateNewMessageView: View {
    
    let didSelectNewUser: (ChatUser) -> ()
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var vm = CreateNewMessageViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                // TODO
                // ForEach(vm.users, id: \.self) { user in
                ForEach(0..<10) { num in
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        HStack(spacing: 16) {
                            // TODO
                            // WebImage(url: URL(string: user.profileImageUrl))
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
                            // TOOD
                            // Text(user.firstName + " " + user.lastName)
                            Text("Hello World")
                                .foregroundColor(Color(.label))
                            Spacer()
                        }.padding(.horizontal)
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
