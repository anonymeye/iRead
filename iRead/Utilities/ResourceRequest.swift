//
//  ResourceRequest.swift
//  iRead
//
//  Created by Abdel on 10/31/20.
//

import Foundation

enum GetResourceRequest<ResourceType> {
    case success([ResourceType])
    case failure
}

enum SaveResult<ResourceType> {
    case success(ResourceType)
    case failure
}

struct ResourceRequest<ResourceType> where ResourceType: Codable {
    
    let baseURL = "http://localhost:8080/"
    let resourceURL: URL
    init(resourcePath: String) {
        guard let resourceURL = URL(string: baseURL) else {
            fatalError()
        }
        self.resourceURL = resourceURL.appendingPathComponent(resourcePath)
    }
    
    func getAll(completion: @escaping (GetResourceRequest<ResourceType>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: resourceURL) {
            data, _, _ in
            guard let jsonData = data else {
                completion(.failure)
                return
            }
            
            do {
                let resources =  try JSONDecoder().decode([ResourceType].self, from: jsonData)
                completion(.success(resources))
            } catch {
                completion(.failure)
            }
        }
        
        dataTask.resume()
    }
    
    func save(_ resourceToSave:  ResourceType,
              completion: @escaping (SaveResult<ResourceType>) -> Void) {
        do {
            guard let token = Auth().token else {
                Auth().logout()
                return
            }
            var urlRequest = URLRequest(url: resourceURL)
            urlRequest.httpMethod = "Post"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            urlRequest.httpBody =  try JSONEncoder().encode(resourceToSave)
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, _ in
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure)
                    return
                }
                guard httpResponse.statusCode == 200,
                    let jsonData = data else {
                        if httpResponse.statusCode == 401 {
                            Auth().logout()
                        }
                        completion(.failure)
                        return
                }
                do {
                    let resource = try JSONDecoder().decode(ResourceType.self, from: jsonData)
                    completion(.success(resource))
                } catch {
                    completion(.failure)
                }
            }
            
            dataTask.resume()
        } catch {
            completion(.failure)
        }
    }
    
    
}







