//
//  WeatherRepository.swift
//  swift-learning
//
//  Created by Filip Cybuch on 21/07/2022.
//

import Foundation
import Combine

class WeatherRepository {
    
    let networkController: NetworkController
    let dateFormatter: DateFormatter
    
    init(networkController: NetworkController) {
        self.networkController = networkController
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
        self.dateFormatter = dateFormatter
    }
    
    func getCurrentWeather(for location: String) async throws -> CurrentWeatherModel {
        let request = GetCurrentWeatherRequest(location: location)
        return try await networkController.sendRequest(request, dateFormatter: dateFormatter)
    }
    
    func getCurrentWeather(for location: String) -> AnyPublisher<CurrentWeatherModel, RequestError> {
        networkController.asyncRequestToCombine({ try await self.getCurrentWeather(for: location) }, queue: DispatchQueue.main)
    }
}