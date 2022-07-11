//
//  Request.swift
//  swift-learning
//
//  Created by Filip Cybuch on 08/07/2022.
//

import Foundation

protocol Request {
    var path: String { get }
    var host: Host { get }
    var parameters: Parameters { get }
    var httpMethod: HTTPMethod { get }
    var urlRequest: URLRequest? { get }
}

extension Request {
    var urlRequest: URLRequest? {
        guard var url = URL(string: host.value + path),
              var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        else { return nil }
        
        let bodyData: Data?
        let headers: [String: String]?
        
        switch parameters {
        case .queryKeyValues:
            urlComponents.queryItems = parameters.createQueryItems()
            if let urlWithParameters = urlComponents.url {
                url = urlWithParameters
            }
            bodyData = nil
            headers = nil
        case .jsonDictionary:
            bodyData = parameters.createJsonBodyData()
            headers = ["Accept": "application/json"]
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.httpBody = bodyData
        urlRequest.allHTTPHeaderFields = headers
        return urlRequest
    }
}

enum HTTPMethod: String {
    case GET, POST, PUT, DELETE, PATCH
}

enum Parameters {
    case queryKeyValues([KeyValues])
    case jsonDictionary(JsonDictionary)
    
    typealias JsonDictionary = [String: Any]
    typealias KeyValues = (key: String, value: String?)
    
    func createJsonBodyData() -> Data? {
        guard case .jsonDictionary(let jsonDictionary) = self else { assertionFailure("Wrong parameters type!"); return nil }
        return try? JSONSerialization.data(withJSONObject: jsonDictionary)
    }
    
    func createQueryItems() -> [URLQueryItem] {
        guard case .queryKeyValues(let keyValues) = self else { assertionFailure("Wrong parameters type!"); return [] }
        let queryItems: [URLQueryItem] = keyValues.map { (key, value) in
            return URLQueryItem(name: key, value: value)
        }.compactMap { $0 }
        
        return queryItems
    }
}
