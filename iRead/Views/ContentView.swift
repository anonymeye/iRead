//
//  ContentView.swift
//  iRead
//
//  Created by Abdel on 10/22/20.
//

import SwiftUI

struct ContentView: View {
    
    let books = [Book(id: 0, title: "The Alchemist", authors: "Paulo Coelho", edition: "1nd", read: false, inProgress: true), Book(id: 1, title: "The Alchemist", authors: "Paulo Coelho", edition: "2nd", read: false), Book(id: 2, title: "The Alchemist", authors: "Paulo Coelho", edition: "3nd", read: true)]
    
    @State private var bookResources: [Book] = []
    
    var body: some View {
        NavigationView {
            List {
                ForEach(books) { book in ItemRow(book: book)}
            }
            .navigationBarTitle("My Library")
            .listStyle(GroupedListStyle())
            .onAppear(perform: loadData)
        }
    }
    
     func loadData() {
        let booksRequest = ResourceRequest<Book>(resourcePath: "books")
        booksRequest.getAll { bookResult in
            DispatchQueue.main.async {
                // @todo: endRefreshing
            }
            switch bookResult {
            case .failure:
                print("error getting the boook")
            case .success(let books):
                    self.bookResources = books
                    print("books: ", books)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
