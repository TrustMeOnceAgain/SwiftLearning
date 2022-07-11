//
//  ColourLoversController.swift
//  swift-learning
//
//  Created by Filip Cybuch on 11/07/2022.
//

import Foundation

class ColourLoversController {
    let networkController: NetworkController
    
    init(networkController: NetworkController) {
        self.networkController = networkController
    }
    
    func getColors() async throws -> [ColorModel] {
        let request = GetColorsRequest()
        return try await networkController.sendRequest(request)
    }
}
