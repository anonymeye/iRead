//
//  CreateBookView.swift
//  iRead
//
//  Created by Abdel on 10/31/20.
//

import SwiftUI

struct CreateBookView: View {
    @State private var title: String = ""
    @State private var authors: String = ""
    @State private var edition: String = ""
    
    func createSection(headerText: String, binding: Binding<String>) -> some View {
        Section(header: Text(headerText)) {
            TextField("", text: binding)
        }
    }
    var body: some View {
        NavigationView {
            Form {
                createSection(headerText: "Title", binding: $title)
                createSection(headerText: "Authors", binding: $authors)
                createSection(headerText: "Edition", binding: $edition)
            }.navigationBarTitle(Text("Add Book"))
            .navigationBarItems(trailing:
                                    Button("Add", action: {
                                        addBook()
                                    })
            )
        }
    }
    
    func addBook() {
        // 1. validate
        // 2. post data
        guard !title.isEmpty && !authors.isEmpty && !edition.isEmpty else {
            // show an error message
            // need a validator
            return
        }
    
        let book = Book(title: title, authors: authors, edition: edition)
        ResourceRequest<Book>(resourcePath: "books")
            .save(book, completion: {result in
                switch result {
                case .failure:
                    print("error saving your book")
                case .success(_):
                  print("success saving your book")
                    // a success banner/alert .. empty inputs
                }
            })
    }
}

struct CreateBookView_Previews: PreviewProvider {
    static var previews: some View {
        CreateBookView()
    }
}
