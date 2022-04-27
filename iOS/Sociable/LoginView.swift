//
//  ContentView.swift
//  Sociable
//
//  Created by 0xMango on 4/19/22.
//

import SwiftUI
import Combine

let USERNAME_CHAR_LIMIT = 32

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var isSecureField = true
    @State private var isLoading = false
    @State private var loginFail = false
    @State var selection: Int? = nil
    
    var body: some View {
        NavigationView {
            ZStack {
                GradientBackground()
                VStack(spacing: 16) {
                    UsernamePasswordView(username: $username, password: $password, isSecureField: $isSecureField)
                    NavigationLink(destination: Text("[insert main screen here]"), tag: 1, selection: $selection) {
                        Button() {
                            if spoofNetworkCall() {
                                // go to main screen / chat interface
                                self.selection = 1
                            }
                        } label: {
                            HStack {
                                Spacer()
                                Text(isLoading ? "" : "Login")
                                    .foregroundColor(username == "" || password == "" ? .gray : .black)
                                    .padding(.vertical, isLoading ? 13 : 10)
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                                }
                                Spacer()
                            }
                        }.border(username == "" || password == "" ? Color.gray : Color.black)
                    }.disabled(username == "" || password == "")
                    
                    if loginFail {
                        // dependent on firebase error
                        // e.g. incorrect user/pass
                        Text("Login Failed")
                            .foregroundColor(.red)
                    }
                    
                    NavigationLink(destination: RegisterView(
                        username: $username,
                        password: $password,
                        isSecureField: $isSecureField
                    ), label: { Text("Create Account")
                    })
                }
                .padding()
            }
        }
    }
    
    func spoofNetworkCall() -> Bool {
        isLoading = true
        loginFail = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            isLoading = false
            loginFail = true
        }
        return false
    }
}

struct RegisterView: View {
    @Binding var username: String
    @Binding var password: String
    @Binding var isSecureField: Bool
    @State private var isLoading = false
    @State private var registerFail = false
    @State var selection: Int? = nil
    
    var body: some View {
        ZStack {
            GradientBackground()
            VStack(spacing: 16) {
                UsernamePasswordView(username: $username, password: $password, isSecureField: $isSecureField)
                DatePickerView()
                NavigationLink(destination: EditProfileView(), tag: 1, selection: $selection) {
                    Button() {
                        if !spoofNetworkCall() {
                            // go to main screen / chat interface (remove !)
                            self.selection = 1
                        }
                    } label: {
                        HStack {
                            Spacer()
                            Text(isLoading ? "" : "Create Account")
                                .foregroundColor(username == "" || password == "" ? .gray : .black)
                                .padding(.vertical, isLoading ? 13 : 10)
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                            }
                            Spacer()
                        }
                    }.border(username == "" || password == "" ? Color.gray : Color.black)
                }.disabled(username == "" || password == "")
                
                if registerFail {
                    // dependent on firebase error
                    // e.g. account exists already
                    Text("Account Creation Failed")
                        .foregroundColor(.red)
                }
            }
            .padding()
        }
    }
    
    func spoofNetworkCall() -> Bool {
        isLoading = true
        registerFail = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLoading = false
            registerFail = true
        }
        return false
    }
}

struct EditProfileView: View {
    @State private var profileName = ""
    @State private var isShowingPhotoPicker = false
    // you may need to download SF Symbols if error
    @State private var avatarImage = UIImage(systemName: "person.fill")!
    let PROFILE_NAME_CHAR_LIMIT = 25
    
    var body: some View {
        NavigationView {
            ZStack {
                GradientBackground()
                GeometryReader { _ in   // for removing keyboard lifting view
                    VStack() {
                        Spacer()
                            HStack {
                                if avatarImage == UIImage(systemName: "person.fill")! {
                                    Text("add\n photo")
                                        .foregroundColor(.blue)
                                        .overlay(
                                            Circle()
                                                .strokeBorder(style: StrokeStyle(lineWidth: 0.5, dash: [2]))
                                                .frame(width: 160, height: 80))
                                        .frame(width: 160, height: 80)
                                        .multilineTextAlignment(.center)
                                        .onTapGesture { isShowingPhotoPicker = true }
                                } else {
                                    Image(uiImage: avatarImage)
                                        .resizable()
                                        .frame(width: 160, height: 80)
                                        .clipShape(Circle())
                                        .onTapGesture { isShowingPhotoPicker = true }
                                }
                                
                                Text("Enter your name and add an optional profile picture")
                                    .foregroundColor(.gray)
                                    .font(Font.system(size: 16, design: .default))
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .padding(.top, -80)
                            .padding(.leading, -30)
                        Divider()
                            .padding(.top, 15)
                        HStack {
                            Group {
                                TextField("Your Name (for notifications)", text: $profileName)
                                Text(String(25 - profileName.count))
                                    .onReceive(Just(profileName), perform: { _ in
                                        limitText(text: &profileName, PROFILE_NAME_CHAR_LIMIT)
                                    })
                            }
                            .foregroundColor(.gray)
                            .font(Font.system(size: 18, design: .default))
                        }
                        Divider()
                            .padding(.top, -5)
                        Spacer()
                    }
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                    .padding()
                    .padding(.bottom, 600)
                }
            }
        }
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $isShowingPhotoPicker, content: {
            PhotoPicker(avatarImage: $avatarImage).ignoresSafeArea()
        })
        .toolbar {
            // Go to main screen / chat interface
            NavigationLink(destination: Text("[insert main screen]"), label: { Text("Done") })
                .disabled(profileName.count == 0)
        }
    }
}

func limitText(text: inout String, _ upper: Int) {
    if text.count > upper {
        text = String(text.prefix(upper))
    }
}

struct GradientBackground: View {
    var body: some View {
        LinearGradient(colors: [Color.orange,Color.green],
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
        .opacity(0.25)
        .ignoresSafeArea()
    }
}

struct UsernamePasswordView: View {
    @Binding var username: String
    @Binding var password: String
    @Binding var isSecureField: Bool
    
    var body: some View {
        Group {
            TextField("Username", text: $username)
                .keyboardType(.asciiCapable)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .onReceive(Just(username), perform: { _ in
                    limitText(text: &username, USERNAME_CHAR_LIMIT)
                })
            HStack {
                if isSecureField {
                    SecureField("Password", text: $password)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                } else {
                    TextField(password, text: $password)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
            }.overlay(alignment: .trailing) {
                Image(systemName: isSecureField ? "eye.slash" : "eye")
                    .foregroundColor(.gray)
                    .onTapGesture {
                        isSecureField.toggle()
                    }
            }
        }
        .padding(12)
    }
}
struct DatePickerView: View {
    @State private var birthDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())!
    
    var body: some View {
        VStack {
            DatePicker(selection: $birthDate, in: ...Date(), displayedComponents: .date) {
                Text("Birthday")
                    .foregroundColor(.gray)
            }
        }.padding(12)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .previewInterfaceOrientation(.portrait)
    }
}
