//
//  WeatherRepository.swift
//  swift-learning
//
//  Created by Filip Cybuch on 21/07/2022.
//

import Foundation
import Combine

protocol WeatherRepository {
    func getCurrentWeather(for location: String) async throws -> CurrentWeatherModel
    func getCurrentWeather(for location: String) -> AnyPublisher<CurrentWeatherModel, RequestError>
}

class RealWeatherRepository: WeatherRepository {
    
    let networkController: NetworkController
    
    init(networkController: NetworkController) {
        self.networkController = networkController
    }
    
    func getCurrentWeather(for location: String) async throws -> CurrentWeatherModel {
        let request = GetCurrentWeatherRequest(location: location)
        return try await networkController.sendRequest(request)
    }
    
    func getCurrentWeather(for location: String) -> AnyPublisher<CurrentWeatherModel, RequestError> {
        networkController.asyncRequestToCombine({ try await self.getCurrentWeather(for: location) }, queue: DispatchQueue.main)
    }
}
