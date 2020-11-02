//
//  Token.swift
//  iRead
//
//  Created by Abdel on 11/1/20.
//

import Foundation

final class Token: Codable {
  var id: UUID?
  var token: String
  var userID: UUID

  init(token: String, userID: UUID) {
    self.token = token
    self.userID = userID
  }
}
