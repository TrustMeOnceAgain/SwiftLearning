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
    
    func getColor(withId id: Int) async throws -> ColorModel?
    func getColor(withId id: Int) -> AnyPublisher<ColorModel?, RequestError>
    
    func getPalettes() async throws -> [Palette]
    func getPalettes() -> AnyPublisher<[Palette], RequestError>
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
    
    // TODO: check if this returns error or optional value
    func getColor(withId id: Int) async throws -> ColorModel? {
        try await networkController.sendRequest(GetColorRequest(colorId: id))
    }
    
    func getColor(withId id: Int) -> AnyPublisher<ColorModel?, RequestError> {
        networkController.asyncRequestToCombine({ try await self.getColor(withId: id) }, queue: DispatchQueue.main)
    }
    
    func getPalettes() async throws -> [Palette] {
        let request = GetPalettesRequest()
        return try await networkController.sendRequest(request)
    }
    
    func getPalettes() -> AnyPublisher<[Palette], RequestError> {
        networkController.asyncRequestToCombine(getPalettes, queue: DispatchQueue.main)
    }
}

class MockedColourLoversRepository: ColourLoversRepository {
    
    func getColors() async throws -> [ColorModel] {
        colorModels
    }
    
    func getColors() -> AnyPublisher<[ColorModel], RequestError> {
        Future { promise in
            promise(.success(self.colorModels))
        }
        .eraseToAnyPublisher()
    }
    
    func getColor(withId id: Int) async throws -> ColorModel? {
        colorModels.first(where: { $0.id == id })
    }
    
    func getColor(withId id: Int) -> AnyPublisher<ColorModel?, RequestError> {
        Future { promise in
            promise(.success(self.colorModels.first(where: { $0.id == id })))
        }
        .eraseToAnyPublisher()
    }
    
    func getPalettes() async throws -> [Palette] {
        paletteModels
    }
    
    func getPalettes() -> AnyPublisher<[Palette], RequestError> {
        Future { promise in
            promise(.success(self.paletteModels))
        }
        .eraseToAnyPublisher()
    }
    
    // TODO: get model from init maybe?
    private let colorModels: [ColorModel] = [ColorModel(id: 1, title: "Colorek", userName: "TrustMe", rgb: .init(red: 30, green: 45, blue: 10), numberOfViews: 1000, url: "https://google.com"),
                                             ColorModel(id: 2, title: "SecondColorek", userName: "ColorCreator", rgb: .init(red: 80, green: 150, blue: 200), numberOfViews: 10500, url: "https://google.com")]
    private let paletteModels: [Palette] = [Palette(id: 1, title: "Palette", userName: "TrustMe", colorValues: ["DFDFDF", "454545", "904010"], numberOfViews: 890, url: "http://google.com")]
}
