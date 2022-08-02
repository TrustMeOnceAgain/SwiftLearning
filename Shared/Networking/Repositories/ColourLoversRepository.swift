//
//  ColourLoversController.swift
//  swift-learning
//
//  Created by Filip Cybuch on 11/07/2022.
//

import Combine
import Foundation

protocol ColourLoversRepository {
    func getColors() async throws -> [ColorModel]
    func getColors() -> AnyPublisher<[ColorModel], RequestError>
    
    func getPalettes() async throws -> [PaletteModel]
    func getPalettes() -> AnyPublisher<[PaletteModel], RequestError>
}

class RealColourLoversRepository: ColourLoversRepository {
    
    let networkController: NetworkController
    
    init(networkController: NetworkController) {
        self.networkController = networkController
    }
    
    func getColors() async throws -> [ColorModel] {
        let request = GetColorsRequest()
        return try await networkController.sendRequest(request)
    }
    
    func getColors() -> AnyPublisher<[ColorModel], RequestError> {
        networkController.asyncRequestToCombine(getColors, queue: DispatchQueue.main)
    }
    
    func getPalettes() async throws -> [PaletteModel] {
        let request = GetPalettesRequest()
        return try await networkController.sendRequest(request)
    }
    
    func getPalettes() -> AnyPublisher<[PaletteModel], RequestError> {
        networkController.asyncRequestToCombine(getPalettes, queue: DispatchQueue.main)
    }
}

class MockedColourLoversRepository: ColourLoversRepository {
    
    private let colorsResponse: Result<[ColorModel], RequestError>
    private let palettesResponse: Result<[PaletteModel], RequestError>
    
    init(colorsResponse: Result<[ColorModel], RequestError> = .success(MockedColourLoversRepository.mockedColorModels),
         palettesResponse: Result<[PaletteModel], RequestError> = .success(MockedColourLoversRepository.mockedPaletteModels)) { // TODO: change
        self.colorsResponse = colorsResponse
        self.palettesResponse = palettesResponse
    }
    
    func getColors() async throws -> [ColorModel] {
        switch colorsResponse {
        case .success(let model):
            return model
        case .failure(let error):
            throw error
        }
    }
    
    func getColors() -> AnyPublisher<[ColorModel], RequestError> {
        asyncRequestToCombine(getColors, queue: .main)
    }
    
    func getPalettes() async throws -> [PaletteModel] {
        switch palettesResponse {
        case .success(let model):
            return model
        case .failure(let error):
            throw error
        }
    }
    
    func getPalettes() -> AnyPublisher<[PaletteModel], RequestError> {
        asyncRequestToCombine(getPalettes, queue: .main)
    }
    
    static let mockedColorModels: [ColorModel] = [ColorModel(id: 1, title: "Colorek", userName: "TrustMe", rgb: .init(red: 30, green: 45, blue: 10), numberOfViews: 1000, url: "https://google.com"),
                                             ColorModel(id: 2, title: "SecondColorek", userName: "ColorCreator", rgb: .init(red: 80, green: 150, blue: 200), numberOfViews: 10500, url: "https://google.com")]
    static let mockedPaletteModels: [PaletteModel] = [PaletteModel(id: 1, title: "Palette", userName: "TrustMe", colorValues: ["DFDFDF", "454545", "904010"], numberOfViews: 890, url: "http://google.com")]
    
    private func asyncRequestToCombine<T>(_ asyncRequest: @escaping () async throws -> T, queue: DispatchQueue) -> AnyPublisher<T, RequestError> {
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
}
