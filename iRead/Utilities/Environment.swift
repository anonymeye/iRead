//
//  Environment.swift
//  iRead
//
//  Created by Abdel on 11/5/20.
//

import Foundation

class Environment: ObservableObject {
    var authorizator: Authorizator
    var apiService: ApiService
    
    init(authorizator: Authorizator = Authorizator(),
         apiService: ApiService = ApiService()) {
        self.authorizator = authorizator
        self.apiService = apiService
    }
}

extension Environment {
    static let mock = Environment(
        authorizator: Authorizator.mock,
        apiService: ApiService.mock
    )
}
