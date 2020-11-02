//
//  Book.swift
//  iRead
//
//  Created by Abdel on 10/22/20.
//

import Foundation

struct Book: Codable, Identifiable {
    //var id = UUID()
    var id: Int = Int.random(in: 1...200)
    let title: String
    let authors: String
    let edition: String
    
    // BookStatus
    var read: Bool = false
    var inProgress: Bool = false
    var page: Int = 0
  
    var summary: String = ""
    // page
    // quotes
    // side notes
    // reminder
    // cover image
    
    #if DEBUG
    static let example = Book(id: 0, title: "The Alchemist", authors: "Paulo Coelho", edition: "2nd", read: false, inProgress: true)
    #endif
    
}
