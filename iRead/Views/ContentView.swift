//
//  ContentView.swift
//  iRead
//
//  Created by Abdel on 10/22/20.
//

import SwiftUI

struct ContentView: View {
    
//    let books = [Book(id: 0, title: "The Alchemist", authors: "Paulo Coelho", edition: "1nd", read: false, inProgress: true), Book(id: 1, title: "The Alchemist", authors: "Paulo Coelho", edition: "2nd", read: false), Book(id: 2, title: "The Alchemist", authors: "Paulo Coelho", edition: "3nd", read: true)]
    
    @State private var books: [Book] = []
    @EnvironmentObject var env: Environment
    
    var body: some View {
        NavigationView {
            List {
                ForEach(books) { book in ItemRow(book: book)}
            }
            .navigationBarTitle("My Library")
            .listStyle(GroupedListStyle())
            .onAppear {
                env.apiService.loadBooks { result in
                    switch result {
                    case .success(let books):
                        self.books = books
                    case .failure:
                        print("oops something is wrong")
                    }
                }
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Environment.mock)
    }
}
