//
//  ColorApiCalls.swift
//  swift-learning
//
//  Created by Filip Cybuch on 07/07/2022.
//

import Foundation

// MARK: - Endpoints
extension RealColourLoversRepository {
    enum API {
        case allColors
    }
}

extension RealColourLoversRepository.API: APICall {
    var path: String {
        switch self {
        case .allColors:
            return "/api/colors"
        }
    }
    
    var method: String {
        switch self {
        case .allColors:
            return "GET"
        }
    }
    
    var headers: [String: String]? {
        return ["Accept": "application/json"]
    }
    
    func body() throws -> Data? {
        return nil
    }
}
