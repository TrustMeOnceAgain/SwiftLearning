//
//  NetworkController.swift
//  swift-learning
//
//  Created by Filip Cybuch on 08/07/2022.
//

import Foundation
import Combine

protocol NetworkController {
    func sendRequest<T: Decodable>(_ request: Request) async throws -> T
    func sendRequest<T>(_ request: Request, interpreter: AnyInterpreter<T>) async throws -> T
}

class RealNetworkController: NetworkController {
    
    func sendRequest<T: Decodable>(_ request: Request) async throws -> T {
        guard let urlRequest = request.urlRequest else { throw RequestError.badURL }
        do {
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            guard let model = try? JSONDecoder().decode(T.self, from: data) else { throw RequestError.parsingFailure }
            return model
        } catch (_) {
            throw RequestError.badRequest
        }
    }
    
    func sendRequest<T>(_ request: Request, interpreter: AnyInterpreter<T>) async throws -> T {
        guard let urlRequest = request.urlRequest else { throw RequestError.badURL }
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            guard let model = interpreter.interpret(data: data, response: response) else { throw RequestError.parsingFailure }
            return model
        } catch (_) {
            throw RequestError.badRequest
        }
    }
}
