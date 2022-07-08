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
    var parametersEncoding: ParametersEncoding { get }
    var httpMethod: HTTPMethod { get }
    var urlComponents: URLComponents? { get } // Temp
}

extension Request {
    var urlComponents: URLComponents? {
        guard let url = URL(string: host.value + path), var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return nil }
        urlComponents.queryItems = ParametersEncoding.createQueryItems(parameters: parameters)
        return urlComponents
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
}

enum ParametersEncoding {
    case url, json
    
    static func createQueryItems(parameters: Parameters) -> [URLQueryItem] {
        guard case .queryKeyValues(let keyValues) = parameters else { assertionFailure("Wrong parameters type!"); return [] }
        let queryItems: [URLQueryItem] = keyValues.map { (key, value) in
            return URLQueryItem(name: key, value: value)
        }.compactMap { $0 }
        
        return queryItems
    }
}
