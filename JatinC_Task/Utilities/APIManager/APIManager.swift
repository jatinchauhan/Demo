//
//  APIManager.swift
//  JatinC_Task
//
//  Created by Jatin Chauhan on 27/04/24.
//

import Foundation

enum APIError: Error {
    case invalidData
    case invalidResponse
    case message(_ error: Error?)
}

enum Endpoint {
    case list
    case detail(String)
    
    var path: String {
        switch self {
        case .list:
            return "/posts"
        case .detail(let postId):
            return "/posts/\(postId)"
        }
    }
}

enum HTTPMethod: String {
    case GET
    case POST
}

struct Configurations {
    static var baseURL = "jsonplaceholder.typicode.com"
}

class APIManager {
    static let shared = APIManager()
    private init() { }
    
    func sendRequest<T: Codable>(endPoint: Endpoint, method: HTTPMethod, parameters: [String: String]?, completionHandler: @escaping (Result<T?, Error>) -> Void) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = Configurations.baseURL
        components.path = endPoint.path
                
        if parameters != nil {
            if method == .GET {
                var queryItems = [URLQueryItem]()
                parameters?.keys.forEach({ key in
                    queryItems.append(URLQueryItem(name: key, value: parameters?[key]))
                })
                components.queryItems = queryItems
            }
        }
        
        let url = URL(string: components.string!)!
        print("URL : ", url.absoluteString)
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completionHandler(.failure(error))
            } else if let data = data {
                let jsonCodable = try? JSONDecoder().decode(T.self, from: data)
                completionHandler(.success(jsonCodable))
            }
        }

        task.resume()
    }
}

