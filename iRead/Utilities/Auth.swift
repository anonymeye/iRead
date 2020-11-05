//
//  Auth.swift
//  iRead
//
//  Created by Abdel on 11/1/20.
//

import Foundation

enum AuthResult {
    case success
    case failure
}

// MARK: - Authorizator
class Authorizator {
    
    static let defaultsKey = "iRead-API-KEY"
    let defaults = UserDefaults.standard
    
    var token: String? {
        get {
            return defaults.string(forKey: Authorizator.defaultsKey)
        }
        set {
            defaults.setValue(newValue, forKey: Authorizator.defaultsKey)
        }
    }
    
    typealias AuthHandler = (String, String, @escaping (AuthenticationResult) -> Void) -> Void
    var _login: AuthHandler
    
    init(authenticating: @escaping AuthHandler =  Authenticator.login(username:password:completion:)  ) {
        self._login = authenticating
    }
    
    func authorize(username: String, password: String, completion: @escaping (AuthResult) -> Void) {
        _login(username, password) {
            result in
            switch result {
            case .success(let token):
                self.token = token
                completion(.success)
            case .failure:
                completion(.failure)
                
            }
        }
    }
    
    func logout() {
        self.token = nil
    }
    
}

extension Authorizator {
    static let mock = Authorizator { (_, _, callBack) in
        callBack(.success("dummy token"))
        // callBack(.failure)
    }
}



// MARK: - Authenticator

enum AuthenticationResult {
    case success(String)
    case failure
}

struct Authenticator {
   static func login(
        username: String,
        password: String,
        completion: @escaping (AuthenticationResult) -> Void
    ) {
        let path = "http://localhost:8080/users/login"
        guard let url = URL(string: path) else {
            fatalError()
        }
        
        guard let loginString = "\(username):\(password)"
                .data(using: .utf8)?.base64EncodedString() else {
            fatalError()
        }
        
        var loginRequest = URLRequest(url: url)
        loginRequest.addValue("Basic \(loginString)", forHTTPHeaderField: "Authorization")
        loginRequest.httpMethod = "POST"
        
        let dataTask = URLSession.shared.dataTask(with: loginRequest) { data, response, _ in
            
            guard
                let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200,
                let jsonData = data else {
                    completion(.failure)
                    return
            }
            
            do {
                let token = try JSONDecoder().decode(Token.self, from: jsonData)
                completion(.success(token.token))
            } catch {
                completion(.failure)
            }
        }
        
        dataTask.resume()
    }
}
