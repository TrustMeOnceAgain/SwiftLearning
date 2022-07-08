//
//  NetworkController.swift
//  swift-learning
//
//  Created by Filip Cybuch on 08/07/2022.
//

import Foundation
import Combine

protocol NetworkController {
    associatedtype T
//    func sendRequest(_ request: Request) -> Result<T, RequestError>
    func sendRequest(_ request: Request) async throws -> T
}

class RealNetworkController<T: Decodable>: NetworkController {
    func sendRequest(_ request: Request) async throws -> T {
        guard let url = request.urlComponents?.url else { throw RequestError.badURL }
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let model = try? JSONDecoder().decode(T.self, from: data) else { throw RequestError.parsingFailure }
        return model
    }
}
