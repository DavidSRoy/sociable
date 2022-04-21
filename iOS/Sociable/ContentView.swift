//
//  ContentView.swift
//  Sociable
//
//  Created by stlp on 4/19/22.
//

import SwiftUI

struct ContentView: View {
    let gradient = LinearGradient(colors: [Color.orange,Color.green], startPoint: .top, endPoint: .bottom)
    @State var username = ""
    @State var password = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                gradient
                    .opacity(0.25)
                    .ignoresSafeArea()

                VStack(spacing: 16) {
                    Group {
                        TextField("Username", text: $username)
                            .keyboardType(.asciiCapable)
                            .autocapitalization(.none)
                        // give user option to see pw
                        SecureField("Password", text: $password)
                    }
                    .padding(12)
                    
                    Button() {
                        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
                    } label: {
                        HStack {
                            Spacer()
                            Text("Log In")
                                .foregroundColor(.gray)
                                .padding(.vertical, 10)
                            Spacer()
                        }
                    }.border(Color.black)
                    
                    Button() {
                    } label: {
                        HStack {
                            Spacer()
                            Text("Create Account")
                            Spacer()
                        }
                    }
                    
                }
                .padding()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
