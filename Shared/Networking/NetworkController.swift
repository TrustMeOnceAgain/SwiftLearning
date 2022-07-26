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
    func asyncRequestToCombine<T>(_ asyncRequest: @escaping () async throws -> T, queue: DispatchQueue) -> AnyPublisher<T, RequestError>
}

class RealNetworkController: NetworkController {
    
    func sendRequest<T: Decodable>(_ request: Request) async throws -> T {
        do {
            let (data, _) = try await baseRequest(request)
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .millisecondsSince1970
            guard let model = try? jsonDecoder.decode(T.self, from: data) else { throw RequestError.parsingFailure }
            return model
        } catch (let error as RequestError) {
            throw error
        } catch {
            throw RequestError.badRequest
        }
    }
    
    func asyncRequestToCombine<T>(_ asyncRequest: @escaping () async throws -> T, queue: DispatchQueue) -> AnyPublisher<T, RequestError> {
        Future { promise in
            Task {
                do {
                    promise(.success(try await asyncRequest()))
                } catch (let error as RequestError){
                    promise(.failure(error))
                } catch {
                    promise(.failure(.badRequest))
                }
            }
        }
        .receive(on: queue)
        .eraseToAnyPublisher()
    }
    
    private func baseRequest(_ request: Request) async throws -> (Data, URLResponse) {
        guard let urlRequest = request.urlRequest else { throw RequestError.badURL }
        guard let (data, response) = try? await URLSession.shared.data(for: urlRequest) else { throw RequestError.badRequest }
        return (data, response)
    }
}
