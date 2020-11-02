//
//  BookRequest.swift
//  iRead
//
//  Created by Abdel on 11/1/20.
//

import Foundation

enum BookUserRequestResult {
    case success(User)
    case failure
}

enum CategoryResult {
    case success
    case failure
}

struct BookRequest {
    let resource: URL
    init (bookID: Int) {
        let resourceString = "http://localhost:8080/books.\(bookID)"
        
        guard let resourceURL = URL(string: resourceString) else {
            fatalError()
        }
        self.resource = resourceURL
    }
    
    func getUser(completion: @escaping (BookUserRequestResult) -> Void) {
        let url = resource.appendingPathComponent("user")
        let dataTask = URLSession.shared.dataTask(with: url) {
            data, _, _ in
            guard let jsonData = data else {
                completion(.failure)
                return
            }
            
            do {
                let user = try JSONDecoder().decode(User.self, from: jsonData)
                completion(.success(user))
            } catch {
                completion(.failure)
            }
        }
        dataTask.resume()
    }
    
    
    func getCategories(completion: @escaping (GetResourceRequest<Category>) -> Void) {
        let url = resource.appendingPathComponent("categories")
        let dataTask = URLSession.shared.dataTask(with: url) {
            data, _, _ in
            
            guard let jsonData = data else {
                completion(.failure)
                return
            }
            do {
                let categories = try JSONDecoder().decode([Category].self, from: jsonData)
                completion(.success(categories))
            } catch {
                completion(.failure)
            }
        }
        dataTask.resume()
    }
    
    
    func update(with updateData: Book, completion: @escaping (SaveResult<Book>) -> Void) {
        
        do {
            guard let token = Auth().token else {
                Auth().logout()
                return
            }
            var urlRequest = URLRequest(url: resource)
            urlRequest.httpMethod = "PUT"
            urlRequest.httpBody = try JSONEncoder().encode(updateData)
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) {
                data, response, _ in
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure)
                    return
                }
                guard
                    httpResponse.statusCode == 200,
                    let jsonData = data else {
                        if httpResponse.statusCode == 401 {
                            Auth().logout()
                        }
                        completion(.failure)
                        return
                }
                
                do {
                    let book = try JSONDecoder().decode(Book.self, from: jsonData)
                    completion(.success(book))
                } catch {
                    completion(.failure)
                }
            }
            
            dataTask.resume()
        } catch {
            completion(.failure)
        }
    }
    
    
    func delete() {
        var urlRequest = URLRequest(url: resource)
        urlRequest.httpMethod = "DELETE"
        let dataTask = URLSession.shared.dataTask(with: urlRequest)
        dataTask.resume()
    }
    
    func add(category: Category, completion: @escaping (CategoryResult) -> Void) {
        
        guard let categoryID = category.id else {
            completion(.failure)
            return
        }
        
        let url = resource.appendingPathComponent("categories")
            .appendingPathComponent("\(categoryID)")
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { _, response, _ in
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 201 else {
                completion(.failure)
                return
            }
            
            completion(.success)
        }
        dataTask.resume()
    }
    
    func deleteCategory(category: Category, completion: ((CategoryResult) -> Void)? = { _ in }) {
        guard let categoryID = category.id else {
            return
        }
        
        guard let token = Auth().token else {
            Auth().logout()
            return
        }
        let url = resource.appendingPathComponent("categories").appendingPathComponent("\(categoryID)")
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (_, response, _) in
            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 204 else {
                    completion?(.failure)
                    return
            }
            
            completion?(.success)
        }
        dataTask.resume()
    }
}
