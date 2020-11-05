//
//  LoginView.swift
//  iRead
//
//  Created by Abdel on 10/27/20.
//

import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isActive: Bool = false
    
    func createSection(headerText: String, binding: Binding<String>) -> some View {
        Section(header: Text(headerText)) {
            TextField("", text: binding)
        }
    }
    
    @EnvironmentObject var env: Environment
    
    var body: some View {
        NavigationView {
            VStack(spacing: 50) {
                Form {
                    createSection(headerText: "user name", binding: $username)
                    createSection(headerText: "password", binding: $password)
                }.navigationTitle(Text("iRead"))
                .frame(height: 200)
                
                NavigationLink(destination: AppView(), isActive: $isActive) {
                    Button("Login") {
                        login()
                    }
                }
            }
        }
        
    }
    
    func login() {
        //1. validate
        //2. login and navigate
        env.authorizator.authorize(username: username, password: password) {
            result in
            switch result {
            case .success:
                print("login successful")
                isActive = true
            case .failure:
                print("could not login. Check your credentials and try again!.")
            }
            
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
//        LoginView(auth: Environment.mock.authorizator)
        LoginView().environmentObject(Environment.mock)
    }
}
