//
//  Environment.swift
//  iRead
//
//  Created by Abdel on 11/5/20.
//

import Foundation

class Environment: ObservableObject {
    var authorizator: Authorizator
    
    init(authorizator: Authorizator = Authorizator()) {
        self.authorizator = authorizator
    }
}

extension Environment {
    static let mock = Environment(
        authorizator: Authorizator.mock
    )
}
