//
//  User.swift
//  iRead
//
//  Created by Abdel on 11/1/20.
//

import Foundation

struct User: Codable {
    let id: UUID?
    let name: String
    let username: String
    let password: String
}
