//
//  Webservice.swift
//  HotCoffee
//
//  Created by İbrahim Bayram on 18.05.2023.
//

import Foundation
import UIKit

enum NetworkError : Error {
    
    case decodingError
    case domainError
    case urlError
    
}

enum HttpMethod : String {
    case get = "GET"
    case post = "POST"
}

struct Resource<T: Codable> {
    let url : URL
    var httpMethod : HttpMethod = .get
    var body : Data? = nil
}

extension Resource {
    init(url : URL) {
        self.url = url
    }
}

class Webservice {
    
    func load<T>(resource : Resource<T>, completion : @escaping (Result<T,NetworkError>)->Void) {
        
        var request = URLRequest(url: resource.url)
        request.httpMethod = resource.httpMethod.rawValue
        request.httpBody = resource.body
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data else {
                completion(.failure(.domainError))
                return
            }
            
            let results = try? JSONDecoder().decode(T.self, from: data)
            if let results = results {
                DispatchQueue.main.async {
                    completion(.success(results))
                }
            }else {
                completion(.failure(.decodingError))
            }
            
        }.resume()
    }
    
    
}
