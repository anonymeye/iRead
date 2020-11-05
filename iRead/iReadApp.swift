//
//  iReadApp.swift
//  iRead
//
//  Created by Abdel on 10/22/20.
//

import SwiftUI

@main
struct iReadApp: App {
    
    let env = Environment()
    
    var body: some Scene {
        WindowGroup {
            // LoginView().environmentObject(Environment.mock)
            LoginView().environmentObject(env)
        }
    }
}

