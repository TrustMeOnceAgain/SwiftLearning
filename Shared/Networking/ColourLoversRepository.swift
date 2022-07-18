//
//  ColourLoversController.swift
//  swift-learning
//
//  Created by Filip Cybuch on 11/07/2022.
//

import Combine
import Foundation

class ColourLoversRepository {
    let networkController: NetworkController
    
    init(networkController: NetworkController) {
        self.networkController = networkController
    }
    
    func getColors() async throws -> [ColorModel] {
        let request = GetColorsRequest()
        return try await networkController.sendRequest(request)
    }
    
    func getPalettes() async throws -> [Palette] {
        let request = GetPalettesRequest()
        return try await networkController.sendRequest(request)
    }
    
    func getColors() -> AnyPublisher<[ColorModel], RequestError> {
        Deferred {
            Future { promise in
                Task { [weak self] in
                    do {
                        promise(.success(try await self?.getColors() ?? []))
                    } catch (let error as RequestError){
                        promise(.failure(error))
                    } catch {
                        promise(.failure(.badRequest))
                    }
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func getPalettes() -> AnyPublisher<[Palette], RequestError>{
        Deferred {
            Future { promise in
                Task { [weak self] in
                    do {
                        promise(.success(try await self?.getPalettes() ?? []))
                    } catch (let error as RequestError){
                        promise(.failure(error))
                    } catch {
                        promise(.failure(.badRequest))
                    }
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
