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
        self.networkController = RealNetworkController() // TODO: add possibility to mock controller
        self.colourLoversRepository = ColourLoversRepository(networkController: networkController)
        self.weatherRepository = WeatherRepository(networkController: networkController)
    }
    
    let networkController: NetworkController
    let colourLoversRepository: ColourLoversRepository
    let weatherRepository: WeatherRepository
}
