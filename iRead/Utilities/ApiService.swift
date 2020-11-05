//
//  ApiService.swift
//  iRead
//
//  Created by Abdel on 11/5/20.
//

import Foundation

private func loadBooks(completion: @escaping (GetResourceRequest<Book>) -> Void) {
    let booksRequest = ResourceRequest<Book>(resourcePath: "books")
    booksRequest.getAll { books in
        completion(books)
    }
}

struct ApiService {
    var loadBooks = loadBooks(completion:)
}

extension ApiService {
    static let sampleBooks = [Book(id: 0, title: "The Alchemist", authors: "Paulo Coelho", edition: "1nd", read: false, inProgress: true), Book(id: 1, title: "The Alchemist", authors: "Paulo Coelho", edition: "2nd", read: false), Book(id: 2, title: "The Alchemist", authors: "Paulo Coelho", edition: "3nd", read: true)]
    
    static let mock = ApiService(loadBooks: { callback in
        callback(.success(sampleBooks))
    })
}
