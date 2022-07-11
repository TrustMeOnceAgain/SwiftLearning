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
        do {
            let (data, _) = try await baseRequest(request)
            guard let model = try? JSONDecoder().decode(T.self, from: data) else { throw RequestError.parsingFailure }
            return model
        } catch (let error as RequestError) {
            throw error
        } catch {
            throw RequestError.badRequest
        }
    }
    
    func sendRequest<T>(_ request: Request, interpreter: AnyInterpreter<T>) async throws -> T {
        do {
            let (data, response) = try await baseRequest(request)
            guard let model = interpreter.interpret(data: data, response: response) else { throw RequestError.parsingFailure }
            return model
        } catch (let error as RequestError) {
            throw error
        } catch {
            throw RequestError.badRequest
        }
    }
    
    private func baseRequest(_ request: Request) async throws -> (Data, URLResponse) {
        guard let urlRequest = request.urlRequest else { throw RequestError.badURL }
        guard let (data, response) = try? await URLSession.shared.data(for: urlRequest) else { throw RequestError.badRequest }
        return (data, response)
    }
}
