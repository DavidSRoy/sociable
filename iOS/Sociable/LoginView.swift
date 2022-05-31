//
//  ContentView.swift
//  Sociable
//
//

import SwiftUI
import Combine

let EMAIL_CHAR_LIMIT = 64
public var loggedin: String = ""

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isSecureField = true
    @State private var isLoading = false
    @State private var validPassword = true
    @State private var loginErrorMessage = ""
    @State var selection: Int? = nil
    @State var isLogin = true
    
    var body: some View {
        NavigationView {
            ZStack {
                GradientBackground()
                VStack(spacing: 16) {
                    EmailPasswordView(email: $email, password: $password, isSecureField: $isSecureField, isLoading: $isLoading, isLogin: $isLogin)
                    NavigationLink(destination: MainMessagesView(), tag: 1, selection: $selection) {
                        Button() {
                            validPassword = password.count >= 6
                            if validPassword {
                                loginUser(email: email, password: password) { status in
                                    loginErrorMessage = status
                                    if loginErrorMessage == "" {
                                        // go to main screen / chat interface
                                        loggedin = email
                                        self.selection = 1
                                    }
                                }
                            }
                        } label: {
                                HStack {
                                    Spacer()
                                    if isLoading {
                                        ButtonLoadingView(email: $email, password: $password, isLoading: $isLoading)
                                    } else {
                                        ButtonLoadingTextView(email: $email, password: $password, isLoading: $isLoading, text: "Login")
                                    }
                                    Spacer()
                                }
                            }
                        }.disabled(email.isEmpty || password.isEmpty)
                    
                    if !validPassword {
                        Text("Password must be at least 6 characters.")
                            .foregroundColor(.red)
                            .font(Font.system(size: 12, design: .default))
                            .padding(.top, -10)
                    } else if loginErrorMessage != "" {
                        // dependent on firebase error
                        // e.g. incorrect user/pass
                        Text(loginErrorMessage)
                            .foregroundColor(.red)
                            .font(Font.system(size: 12, design: .default))
                            .padding(.top, -10)
                    }
                    
                    NavigationLink(destination: RegisterView(
                        email: $email,
                        password: $password,
                        isSecureField: $isSecureField,
                        validPassword: $validPassword
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
    
    func loginUser(email: String, password: String, completion: ((String) -> Void)? = nil) {
        isLoading = true
        loginErrorMessage = ""
        
        let urlstring = "https://us-central1-sociable-messenger.cloudfunctions.net/users_api/login?email=" + email + "&password=" + password
        
        let url = URL(string: urlstring)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("7f5c4e71e19bdd8c793f1677867ef4db007988f6", forHTTPHeaderField: "auth")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                isLoading = false
                completion?("Login failed")
                fatalError("There was an error with your network request: \(error.localizedDescription)")
            }
            
            let response1 = response as! HTTPURLResponse
            if response1.statusCode == 200 {
                completion?("")
            } else {
                completion?("Incorrect email or password")
            }
            isLoading = false
        }.resume()
    }
}

struct RegisterView: View {
    @Binding var email: String
    @Binding var password: String
    @Binding var isSecureField: Bool
    @Binding var validPassword: Bool
    @State var birthDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())!
    @State var isLogin = false
    @State private var isLoading = false
    @State private var registerErrorMessage = ""
    @State var selection: Int? = nil
    
    var body: some View {
        ZStack {
            GradientBackground()
            VStack(spacing: 16) {
                EmailPasswordView(email: $email, password: $password, isSecureField: $isSecureField, isLoading: $isLoading, isLogin: $isLogin)
                DatePickerView(birthDate: $birthDate)
                NavigationLink(destination: EditProfileView(), tag: 1, selection: $selection) {
                    Button() {
                        validPassword = password.count >= 6
                        if validPassword {
                            registerUser(email: email, password: password, birthDate: birthDate) { status in
                                registerErrorMessage = status
                                if registerErrorMessage == "" {
                                    // go to main screen / chat interface
                                    loggedin = email
                                    self.selection = 1
                                }
                            }
                        }
                    } label: {
                        HStack {
                            Spacer()
                            if isLoading {
                                ButtonLoadingView(email: $email, password: $password, isLoading: $isLoading)
                            } else {
                                ButtonLoadingTextView(email: $email, password: $password, isLoading: $isLoading, text: "Register")
                            }
                            Spacer()
                        }
                    }
                }.disabled(email.isEmpty || password.isEmpty)
                
                if !validPassword {
                    Text("Password must be at least 6 characters.")
                        .foregroundColor(.red)
                        .font(Font.system(size: 12, design: .default))
                        .padding(.top, -10)
                } else if registerErrorMessage != "" {
                    // dependent on firebase error
                    // e.g. account exists already
                    Text(registerErrorMessage)
                        .foregroundColor(.red)
                }
            }
            .padding(12)
        }
    }

    func registerUser(email: String, password: String, birthDate: Date, completion: ((String) -> Void)? = nil) {
        isLoading = true
        registerErrorMessage = ""
        
        let createUserBaseUrl = "https://us-central1-sociable-messenger.cloudfunctions.net/users_api/createUser?"
        let urlstring = createUserBaseUrl + "displayName=" + email + "&password=" + password + "&email=" + email + "&dob=" + DateFormatter().string(from: birthDate)
        
        let url = URL(string: urlstring)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("7f5c4e71e19bdd8c793f1677867ef4db007988f6", forHTTPHeaderField: "auth")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                isLoading = false
                completion?("Account creation failed")
                fatalError("There was an error with your network request: \(error.localizedDescription)")
            }
            
            let response1 = response as! HTTPURLResponse
            if response1.statusCode == 200 {
                completion?("")
            } else {
                completion?("Account already exists")
            }
            isLoading = false
        }.resume()
    }
}

struct EditProfileView: View {
    @State private var profileName = ""
    @State private var isShowingPhotoPicker = false
    @State private var showingAlert = false
    @State private var userSelection = 0
    // you may need to download SF Symbols if error
    @State private var avatarImage = UIImage(systemName: "person.fill")!
    let PROFILE_NAME_CHAR_LIMIT = 25
    
    @ObservedObject private var vm = MainMessagesViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                GradientBackground()
                GeometryReader { _ in   // for removing keyboard lifting view
                    VStack() {
                        Spacer()
                        HStack {
                            if avatarImage == UIImage(systemName: "person.fill")! {
                                VStack {
                                    Text("add\n photo")
                                        .foregroundColor(.blue)
                                        .multilineTextAlignment(.center)
                                        .overlay(
                                            Circle()
                                                .strokeBorder(style: StrokeStyle(lineWidth: 0.5, dash: [2]))
                                                .frame(width: 160, height: 80))
                                        .frame(width: 160, height: 160)
                                        .alert("Add Profile Picture", isPresented: $showingAlert) {
                                            Button("Take Photo") {
                                                isShowingPhotoPicker = true
                                                userSelection = 1 }
                                            Button("Select Photo") {
                                                isShowingPhotoPicker = true
                                                userSelection = 2 }
                                            Button("Cancel") { }
                                        }
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    showingAlert = true
                                }
                            } else {
                                VStack {
                                    Image(uiImage: avatarImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 160, height: 80)
                                        .clipShape(Circle())
                                        .alert("Add Profile Picture", isPresented: $showingAlert) {
                                            Button("Take Photo") {
                                                isShowingPhotoPicker = true
                                                userSelection = 1 }
                                            Button("Select Photo") {
                                                isShowingPhotoPicker = true
                                                userSelection = 2 }
                                            Button("Cancel") { }
                                        }
                                }
                                .contentShape(Rectangle())
                                .frame(width: 160, height: 160)
                                .onTapGesture {
                                    showingAlert = true
                                }
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
            PhotoPicker(avatarImage: $avatarImage, sourceType: userSelection == 1 ? .camera : .savedPhotosAlbum).ignoresSafeArea()
        })
        .toolbar {
            NavigationButton(action: { vm.setDisplayName(email: loggedin, displayName: profileName) },
                             destination: { MainMessagesView() },
                             label: { Text("Done") })
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
                    .frame(width: .infinity, alignment: .center)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 20)
                Text("Email")
                    .font(Font.system(size: 14, design: .default))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, -5)
                TextField(email, text: $email)
                    .font(Font.system(size: 18, design: .default))
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(height: 35)
                    .onTapGesture { self.didTap = true }
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
            .ignoresSafeArea(.keyboard, edges: .bottom)
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
    @Binding var email: String
    @Binding var password: String
    @Binding var isLoading: Bool
    
    var body: some View {
        ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .gray))
            .foregroundColor(email.isEmpty || password.isEmpty ? .gray : .black)
            .padding(.vertical, isLoading ? 13 : 10)
            .frame(width: 180, height: 50)
            .background(
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(email.isEmpty || password.isEmpty ? Color.gray.opacity(0.3) : Color.green.opacity(0.3))
            )
    }
}

struct ButtonLoadingTextView: View {
    @Binding var email: String
    @Binding var password: String
    @Binding var isLoading: Bool
    var text: String
    
    var body: some View {
        Text(text)
            .foregroundColor(email.isEmpty || password.isEmpty ? .gray : .black)
            .padding(.vertical, isLoading ? 13 : 10)
            .frame(width: 180, height: 50)
            .background(
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(email.isEmpty || password.isEmpty ? Color.gray.opacity(0.3) : Color.green.opacity(0.3))
            )
    }
}

struct EmailPasswordView: View {
    enum Field: Hashable {
        case email
        case password
    }
    @Binding var email: String
    @Binding var password: String
    @Binding var isSecureField: Bool
    @Binding var isLoading: Bool
    @Binding var isLogin: Bool
    @FocusState var focusedField: Field?
    
    var body: some View {
        Group {
            TextField("email", text: $email)
                .keyboardType(.asciiCapable)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .onReceive(Just(email), perform: { _ in
                    limitText(text: &email, EMAIL_CHAR_LIMIT)
                })
                .submitLabel(.next)
                .onSubmit {
                    focusedField = .password
                }
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
            .focused($focusedField, equals: .password)
        }
        .padding(12)
    }
}

struct DatePickerView: View {
    @Binding var birthDate: Date
    
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
