//
//  ColourLoversController.swift
//  SwiftLearning
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
    
    private let networkController: NetworkController
    
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
