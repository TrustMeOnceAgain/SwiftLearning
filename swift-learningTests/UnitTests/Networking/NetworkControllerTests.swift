//
//  NetworkControllerTests.swift
//  swift-learningTests
//
//  Created by Filip Cybuch on 03/08/2022.
//

import XCTest
@testable import swift_learning

class NetworkControllerTests: XCTestCase {
    
    func testGetColors() async {
        
        let request = GetColorsRequest()
        let mockedRequests: [MockedRequest] = [MockedRequest(request: request, response: .success(JsonLoader.loadData("GetColors")))]
        let networkController = MockedNetworkController(mockedRequests: mockedRequests)
        let expectedResult: [ColorModel] = [
            ColorModel(id: 1, title: "SuchColor", userName: "TrustMe", rgb: .init(red: 10, green: 30, blue: 150), numberOfViews: 154384, url: "http://www.colourlovers.com/color/000000/SuchColor"),
            ColorModel(id: 2, title: "SuchSecondColor", userName: "TrustedOnce", rgb: .init(red: 50, green: 4, blue: 14), numberOfViews: 450, url: "http://www.colourlovers.com/color/000000/SuchSecondColor")
        ]
        
        do {
            let data: [ColorModel] = try await networkController.sendRequest(request)
            XCTAssertEqual(data, expectedResult)
        } catch let error as RequestError {
            XCTFail(error.localizedDescription)
        } catch {
            XCTFail("There should not be any error thrown")
        }
    }
    
    func testGetPalettes() async {
        
        let request = GetPalettesRequest()
        let mockedRequests: [MockedRequest] = [MockedRequest(request: request, response: .success(JsonLoader.loadData("GetPalettes")))]
        let networkController = MockedNetworkController(mockedRequests: mockedRequests)
        let expectedResult: [PaletteModel] = [
            PaletteModel(id: 92094, title: "My Rose", userName: "fazai38", colorValues: ["C9F2CA", "88AE63", "688F40", "A3925A", "992E1C"], numberOfViews: 352, url: "http://www.colourlovers.com/palette/92094/My_Rose"),
            PaletteModel(id: 92095, title: "Giant Goldfish", userName: "manekineko", colorValues: ["69D2E7", "A7DBD8", "E0E4CC", "F38630", "FA6900"], numberOfViews: 1112727, url: "http://www.colourlovers.com/palette/92095/Giant_Goldfish")
        ]
        
        do {
            let data: [PaletteModel] = try await networkController.sendRequest(request)
            XCTAssertEqual(data, expectedResult)
        } catch let error as RequestError {
            XCTFail(error.localizedDescription)
        } catch {
            XCTFail("There should not be any error thrown")
        }
    }
    
    func testGetCurrentWeather_withoutCondition() async {
        
        let request = GetCurrentWeatherRequest(location: "Tokyo")
        let mockedRequests: [MockedRequest] = [MockedRequest(request: request, response: .success(JsonLoader.loadData("GetCurrentWeather_tokyo")))]
        let networkController = MockedNetworkController(mockedRequests: mockedRequests)
        let expectedResult: CurrentWeatherModel = CurrentWeatherModel(updateTimestamp: 1659528000, temperatureCelsius: 32.0, temperatureFahrenheit: 89.6, location: .init(name: "Tokyo", country: "Japan"), condition: nil)
        
        do {
            let data: CurrentWeatherModel = try await networkController.sendRequest(request)
            XCTAssertEqual(data, expectedResult)
        } catch let error as RequestError {
            XCTFail(error.localizedDescription)
        } catch {
            XCTFail("There should not be any error thrown")
        }
    }
    
    func testGetCurrentWeather_withCondition() async {
        
        let request = GetCurrentWeatherRequest(location: "Sydney")
        let mockedRequests: [MockedRequest] = [MockedRequest(request: request, response: .success(JsonLoader.loadData("GetCurrentWeather_sydney")))]
        let networkController = MockedNetworkController(mockedRequests: mockedRequests)
        let expectedResult: CurrentWeatherModel = CurrentWeatherModel(updateTimestamp: 1659527100, temperatureCelsius: 20.0, temperatureFahrenheit: 68.0, location: .init(name: "Sydney", country: "Australia"), condition: .init(text: "Clear", imageUrlString: "//cdn.weatherapi.com/weather/64x64/night/113.png", code: 1000))
        
        do {
            let data: CurrentWeatherModel = try await networkController.sendRequest(request)
            XCTAssertEqual(data, expectedResult)
        } catch let error as RequestError {
            XCTFail(error.localizedDescription)
        } catch {
            XCTFail("There should not be any error thrown")
        }
    }
    
    func testErrors() async {
        
        let request = GetColorsRequest()
        let secondRequest = GetPalettesRequest()
        let thirdRequest = GetCurrentWeatherRequest(location: "Does not matter")
        
        let mockedRequests: [MockedRequest] = [MockedRequest(request: request, response: .failure(.badURL)),
                                               MockedRequest(request: secondRequest, response: .failure(.parsingFailure)),
                                               MockedRequest(request: thirdRequest, response: .failure(.badRequest))]
        let networkController = MockedNetworkController(mockedRequests: mockedRequests)
        
        do {
            let _: [ColorModel] = try await networkController.sendRequest(request)
        } catch let error as RequestError {
            XCTAssertEqual(error, .badURL)
        } catch {
            XCTFail("Wrong error type thrown!")
        }
        
        do {
            let _: [PaletteModel] = try await networkController.sendRequest(secondRequest)
        } catch let error as RequestError {
            XCTAssertEqual(error, .parsingFailure)
        } catch {
            XCTFail("Wrong error type thrown!")
        }
        
        do {
            let _: CurrentWeatherModel = try await networkController.sendRequest(thirdRequest)
        } catch let error as RequestError {
            XCTAssertEqual(error, .badRequest)
        } catch {
            XCTFail("Wrong error type thrown!")
        }
    }
}


