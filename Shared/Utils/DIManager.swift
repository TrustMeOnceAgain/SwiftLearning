//
//  DIManager.swift
//  swift-learning
//
//  Created by Filip Cybuch on 07/07/2022.
//

import Foundation

class DIManager {
    static var shared: DIManager = DIManager()
    
    private init() {
        self.networkController = RealNetworkController()
        
        self.realColourRepository = RealColourLoversRepository(networkController: networkController)
        self.mockedColourRepository = MockedColourLoversRepository()
        
        self.realWeatherRepository = RealWeatherRepository(networkController: networkController)
        self.mockedWeatherRepository = MockedWeatherRepository()
    }
    
    var appEnvironment: AppEnvironment = .realData
    let networkController: NetworkController
    
    var colourLoversRepository: ColourLoversRepository {
        switch appEnvironment {
        case .realData:
            return realColourRepository
        case .mocked:
            return mockedColourRepository
        }
    }
    
    var weatherRepository: WeatherRepository {
        switch appEnvironment {
        case .realData:
            return realWeatherRepository
        case .mocked:
            return mockedWeatherRepository
        }
    }
    
    private let realColourRepository: RealColourLoversRepository
    private let mockedColourRepository: MockedColourLoversRepository
    private let realWeatherRepository: RealWeatherRepository
    private let mockedWeatherRepository: MockedWeatherRepository
}

enum AppEnvironment {
    case realData, mocked
}
