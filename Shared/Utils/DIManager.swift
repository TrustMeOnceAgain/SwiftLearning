//
//  DIManager.swift
//  SwiftLearning
//
//  Created by Filip Cybuch on 07/07/2022.
//

import Foundation

class DIManager {
    static var shared: DIManager = DIManager()
    
    var appEnvironment: AppEnvironment = .realData
    
    var networkController: NetworkController {
        switch appEnvironment {
        case .realData:
            return RealNetworkController()
        case .mocked:
            return MockedNetworkController()
        }
    }
    
    var colourLoversRepository: ColourLoversRepository { RealColourLoversRepository(networkController: networkController) }
    var weatherRepository: WeatherRepository { RealWeatherRepository(networkController: networkController) }
}

enum AppEnvironment {
    case realData, mocked
}
