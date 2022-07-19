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
    
    func getColor(withId id: Int) async throws -> ColorModel {
        try await networkController.sendRequest(GetColorRequest(colorId: id))
    }
    
    func getPalettes() async throws -> [Palette] {
        let request = GetPalettesRequest()
        return try await networkController.sendRequest(request)
    }
    
    func getColors() -> AnyPublisher<[ColorModel], RequestError> {
        networkController.asyncRequestToCombine(getColors, queue: DispatchQueue.main)
    }
    
    func getPalettes() -> AnyPublisher<[Palette], RequestError>{
        networkController.asyncRequestToCombine(getPalettes, queue: DispatchQueue.main)
    }
}
