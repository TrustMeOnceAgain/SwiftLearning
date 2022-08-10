//
//  DIManager.swift
//  SwiftLearning
//
//  Created by Filip Cybuch on 07/07/2022.
//

import Foundation

class DIManager {
    static var shared: DIManager = DIManager()
    
    let networkController: NetworkController
    let colourLoversRepository: ColourLoversRepository
    let weatherRepository: WeatherRepository
    
    private init() {
        self.networkController = DIManager.createNetworkController(using: .realData) // Change to use different environment TODO: extend this to use UserDefaults/compilation flags for configuration
        self.colourLoversRepository = RealColourLoversRepository(networkController: networkController)
        self.weatherRepository = RealWeatherRepository(networkController: networkController)
    }
    
    private static func createNetworkController(using appEnvironment: AppEnvironment) -> NetworkController {
        switch appEnvironment {
        case .realData:
            return RealNetworkController()
        case .mockedData:
            return MockedNetworkController()
        }
    }
}

enum AppEnvironment {
    case realData, mockedData
}
