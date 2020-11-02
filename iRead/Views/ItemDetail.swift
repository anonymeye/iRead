//
//  ItemDetail.swift
//  iRead
//
//  Created by Abdel on 10/22/20.
//

import SwiftUI

struct ItemDetail: View {
    
    let book: Book
    @State private var selectedDate = Date()
    @State private var notes = ""
    
    func Row(_ title: String,_ details: String) -> some View {
        return HStack {
            Text(title)
            Spacer()
            Text(details)
        }
    }
    
    var body: some View {
        
        NavigationView {
            Form {
                
                Section(header: Text("Info")) {
                    Row("Authors", "\(book.authors)")
                    Row("Edition", "\(book.edition)")
                }
                
                Section(header: Text("Status")) {
                    Row("Read", "\(book.read ? "Yes" : "No")")
                    Row("In Progress", "\(book.inProgress ? "Yes" : "No")")
                    Row("Page", "\(book.page)")
                }
                
                Section(header: Text("Description")) {
                    VStack {
                        Text("Summary:").padding()
                        Text("\(book.summary)")
                        TextField("Notes", text: $notes)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .multilineTextAlignment(.leading)
                            .autocapitalization(.none)
                            .padding()
                    }
                }
                
                // @todo
                Section(header: Text("Reminder")) {
                    DatePicker("Please enter a date", selection: $selectedDate, in: Date()...)
                }
            
            }.navigationBarTitle(Text(book.title), displayMode: .inline)
            .listStyle(GroupedListStyle())
            .navigationBarItems(trailing: EditButton())
        }
        
    }
}

struct ItemDetail_Previews: PreviewProvider {
    static var previews: some View {
        ItemDetail(book: Book.example)
    }
}
