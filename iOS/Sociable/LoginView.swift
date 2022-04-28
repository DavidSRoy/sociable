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
                                if isLoading {
                                    ButtonLoadingView(username: $username, password: $password, isLoading: $isLoading)
                                } else {
                                    ButtonLoadingTextView(username: $username, password: $password, isLoading: $isLoading, text: "Login")
                                }
                                Spacer()
                            }
                        }
                    }.disabled(username.isEmpty || password.isEmpty)
                    
                    if loginFail {
                        // dependent on firebase error
                        // e.g. incorrect user/pass
                        Text("Login Failed")
                            .foregroundColor(.red)
                            .font(Font.system(size: 12, design: .default))
                            .padding(.top, -10)
                    }
                    
                    NavigationLink(destination: RegisterView(
                        username: $username,
                        password: $password,
                        isSecureField: $isSecureField
                    ), label: { Text("Create Account")
                    })
                    
                    NavigationLink(destination: ForgotPasswordView(), label: { Text("Forgot Password?")
                        .font(Font.system(size: 11, design: .default))
                        .multilineTextAlignment(.trailing) })
                        .padding(.bottom, -300)
                }
                .padding(12)
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
                            if isLoading {
                                ButtonLoadingView(username: $username, password: $password, isLoading: $isLoading)
                            } else {
                                ButtonLoadingTextView(username: $username, password: $password, isLoading: $isLoading, text: "Register")
                            }
                            Spacer()
                        }
                    }
                }.disabled(username.isEmpty || password.isEmpty)
                
                if registerFail {
                    // dependent on firebase error
                    // e.g. account exists already
                    Text("Account Creation Failed")
                        .foregroundColor(.red)
                }
            }
            .padding(12)
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
            NavigationLink(destination: Text("[Insert main screen here]"), label: { Text("Done") })
                .disabled(profileName.isEmpty)
        }
    }
}

struct ForgotPasswordView: View {
    // add support for phone #?
    @State private var email = ""
    @State private var didTap = false
    
    var body: some View {
        ZStack {
            GradientBackground()
            VStack {
                Text("Reset Password")
                    .font(.largeTitle).fontWeight(.bold)
                    .padding(.bottom, 10)
                Text("If you do not know your current password, you may change it.")
                    .font(Font.system(size: 14, design: .default))
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 20)
                Text("Email")
                    .font(Font.system(size: 14, design: .default))
                    .padding(.trailing, 260)
                    .padding(.bottom, -5)
                TextField(email, text: $email)
                    .font(Font.system(size: 18, design: .default))
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(height: 35)
                    .onTapGesture { self.didTap = true}
                Button("Submit") {
                    print("Sent email link")
                }
                .disabled(email.isEmpty)
                .frame(width: 100, height: 25, alignment: .center)
                .padding(.vertical, 10)
                .foregroundColor(Color.black)
                .background(
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(email.isEmpty ? Color.gray.opacity(0.3) : Color.green.opacity(0.3))
                )
            }
            .padding(.bottom, 200)
            .padding(12)
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

struct ButtonLoadingView: View {
    @Binding var username: String
    @Binding var password: String
    @Binding var isLoading: Bool
    
    var body: some View {
        ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .gray))
            .foregroundColor(username.isEmpty || password.isEmpty ? .gray : .black)
            .padding(.vertical, isLoading ? 13 : 10)
            .frame(width: 180, height: 50)
            .background(
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(username.isEmpty || password.isEmpty ? Color.gray.opacity(0.3) : Color.green.opacity(0.3))
            )
    }
}

struct ButtonLoadingTextView: View {
    @Binding var username: String
    @Binding var password: String
    @Binding var isLoading: Bool
    var text: String
    
    var body: some View {
        Text(text)
            .foregroundColor(username.isEmpty || password.isEmpty ? .gray : .black)
            .padding(.vertical, isLoading ? 13 : 10)
            .frame(width: 180, height: 50)
            .background(
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(username.isEmpty || password.isEmpty ? Color.gray.opacity(0.3) : Color.green.opacity(0.3))
            )
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
