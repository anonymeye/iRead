//
//  ItemRow.swift
//  iRead
//
//  Created by Abdel on 10/22/20.
//

import SwiftUI

struct ItemRow: View {
    static let colors: [String: Color] = ["R": .green, "N": .purple, "P": .yellow] // R for read, N for not read, P for in progress
    
    let book: Book
    
    static let notation: (Book) -> String = { book in
        return book.read ? "R" : book.inProgress ? "P" : "N"
    }
    
    static let color: (Book) -> Color = { book in
        return Self.colors[Self.notation(book)] ?? .black
    }
    
    var body: some View {
        NavigationLink(
            destination: ItemDetail(book: book)) {
            HStack {
                VStack(alignment: .leading) {
                    Text(book.title).font(.headline)
                    Text(book.authors)
                }.layoutPriority(1)
                
                Spacer()
                
                Text("\(Self.notation(book))")
                    .font(.caption)
                    .fontWeight(.black)
                    .padding(5)
                    .background(Self.color(book))
                    .clipShape(Circle())
                    .foregroundColor(.white)
            }
        }
    }
    
}

struct ItemRow_Previews: PreviewProvider {
    static var previews: some View {
        ItemRow(book: Book.example)
    }
}
