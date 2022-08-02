//
//  DIManager.swift
//  swift-learning
//
//  Created by Filip Cybuch on 07/07/2022.
//

import Foundation

class DIManager {
    static var shared: DIManager = DIManager()
    
    var appEnvironment: AppEnvironment = .realData
    
    lazy var networkController: NetworkController = RealNetworkController()
    
    var colourLoversRepository: ColourLoversRepository {
        switch appEnvironment {
        case .realData:
            return RealColourLoversRepository(networkController: networkController)
        case .mocked:
            return MockedColourLoversRepository()
        }
    }
    
    var weatherRepository: WeatherRepository {
        switch appEnvironment {
        case .realData:
            return RealWeatherRepository(networkController: networkController)
        case .mocked:
            return MockedWeatherRepository()
        }
    }
}

enum AppEnvironment {
    case realData, mocked
}
