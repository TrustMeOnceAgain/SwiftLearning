//
//  WeatherRepositoryTests.swift
//  swift-learning
//
//  Created by Filip Cybuch on 02/08/2022.
//

import XCTest
import Combine
@testable import swift_learning

class WeatherRepositoryTests: XCTestCase {
    
    private let expectationTimeout: Double  = 2
    private var cancellable = Set<AnyCancellable>()
    
    // MARK: tests
    
    func testGetCurrentWeather_withoutCondition() async {
        
        let location: Location = .tokyo
        let repository = setupRepository(for: location)
        let expectedResult: CurrentWeatherModel = expectedResult(for: location)
        
        await checkCurrentWeatherRequestExection(repository: repository, location: location, expectedResult: expectedResult)
    }
    
    func testGetCurrentWeather_withCondition() async {
        
        let location: Location = .sydney
        let repository = setupRepository(for: location)
        let expectedResult: CurrentWeatherModel = expectedResult(for: location)
        
        await checkCurrentWeatherRequestExection(repository: repository, location: location, expectedResult: expectedResult)
    }
    
    func testCombineAndAsync() async {
        
        let location: Location = .tokyo
        let repository = setupRepository(for: location)
        let expectedResult: CurrentWeatherModel = expectedResult(for: location)
        
        let combineExpectation = XCTestExpectation(description: "Waather Combine Completion")
        let asyncExpectation = XCTestExpectation(description: "Weather Async Completion")
        
        var combineResultData: CurrentWeatherModel? = nil
        var asyncResultData: CurrentWeatherModel? = nil
        
        repository
            .getCurrentWeather(for: location.rawValue)
            .sinkToResult( { result in
                if case .success(let data) = result {
                    combineResultData = data
                    combineExpectation.fulfill()
                }
            })
            .store(in: &cancellable)
        
        do {
            let data: CurrentWeatherModel = try await repository.getCurrentWeather(for: location.rawValue)
            asyncResultData = data
            asyncExpectation.fulfill()
        } catch let error as RequestError {
            XCTFail(error.localizedDescription)
        } catch {
            XCTFail("There should not be any error thrown")
        }
        
        wait(for: [combineExpectation, asyncExpectation], timeout: expectationTimeout)
        
        XCTAssertEqual(combineResultData, asyncResultData, "Results from combine and async methods should be equal!")
        XCTAssertEqual(combineResultData, expectedResult, "Results should be equal to expected data!")
    }
    
    // MARK: private helpers
    
    private func setupRepository(for location: Location) -> WeatherRepository {
        let request = GetCurrentWeatherRequest(location: location.rawValue)
        let mockedRequests: [MockedRequest] = [MockedRequest(request: request, response: .success(JsonLoader.loadData(location.fileName)))]
        let networkController = MockedNetworkController(mockedRequests: mockedRequests)
        return RealWeatherRepository(networkController: networkController)
    }
    
    private func expectedResult(for location: Location) -> CurrentWeatherModel {
        switch location {
        case .tokyo:
            return CurrentWeatherModel(updateTimestamp: 1659528000, temperatureCelsius: 32.0, temperatureFahrenheit: 89.6, location: .init(name: "Tokyo", country: "Japan"), condition: nil)
        case .sydney:
            return CurrentWeatherModel(updateTimestamp: 1659527100, temperatureCelsius: 20.0, temperatureFahrenheit: 68.0, location: .init(name: "Sydney", country: "Australia"), condition: .init(text: "Clear", imageUrlString: "//cdn.weatherapi.com/weather/64x64/night/113.png", code: 1000))
        }
    }
    
    private func checkCurrentWeatherRequestExection(repository: WeatherRepository, location: Location, expectedResult: CurrentWeatherModel) async {
        do {
            let data: CurrentWeatherModel = try await repository.getCurrentWeather(for: location.rawValue)
            XCTAssertEqual(data, expectedResult)
        } catch let error as RequestError {
            XCTFail(error.localizedDescription)
        } catch {
            XCTFail("There should not be any error thrown")
        }
    }
    
    private enum Location: String {
        case tokyo = "Tokyo", sydney = "Sydney"
        
        var fileName: String {
            switch self {
            case .tokyo:
                return "GetCurrentWeather_tokyo"
            case .sydney:
                return "GetCurrentWeather_sydney"
            }
        }
    }
}
