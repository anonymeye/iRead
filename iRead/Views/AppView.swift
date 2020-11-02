//
//  AppView.swift
//  iRead
//
//  Created by Abdel on 10/27/20.
//

import SwiftUI

struct AppView: View {
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Image(systemName: "example")
                    Text("Library")
                }
            CreateBookView()
                .tabItem {
                    Image(systemName: "empty")
                    Text("Add Book")
                }
            }
        
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
