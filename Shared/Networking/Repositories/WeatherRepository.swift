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

class MockedWeatherRepository: WeatherRepository {
    func getCurrentWeather(for location: String) async throws -> CurrentWeatherModel {
        guard let model = currentWeatherModels.first(where: { $0.location.name == location || $0.location.country == location }) else { throw RequestError.parsingFailure }
        return model
    }
    
    func getCurrentWeather(for location: String) -> AnyPublisher<CurrentWeatherModel, RequestError> {
        Future { promise in
            Task {
                do {
                    promise(.success(try await self.getCurrentWeather(for: location)))
                } catch (let error as RequestError){
                    promise(.failure(error))
                } catch {
                    promise(.failure(.badRequest))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    private let currentWeatherModels: [CurrentWeatherModel] = [
        CurrentWeatherModel(updateTimestamp: Date().timeIntervalSince1970, temperatureCelsius: 25.8, temperatureFahrenheit: 89.1, location: .init(name: "Tokyo", country: "Japan"), condition: .init(text: "Sunny", imageUrlString: "Sunny", code: 1000)),
        CurrentWeatherModel(updateTimestamp: Date().timeIntervalSince1970, temperatureCelsius: 18.3, temperatureFahrenheit: 50.9, location: .init(name: "London", country: "England")),
        CurrentWeatherModel(updateTimestamp: Date().timeIntervalSince1970, temperatureCelsius: 23.1, temperatureFahrenheit: 60.9, location: .init(name: "Paris", country: "France")),
        CurrentWeatherModel(updateTimestamp: Date().timeIntervalSince1970, temperatureCelsius: -8.3, temperatureFahrenheit: 40.9, location: .init(name: "Sydney", country: "Australia")),
        CurrentWeatherModel(updateTimestamp: Date().timeIntervalSince1970, temperatureCelsius: 35.3, temperatureFahrenheit: 90.9, location: .init(name: "Wroclaw", country: "Poland"))
    ]
}
