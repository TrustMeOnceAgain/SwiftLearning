//
//  NetworkControllerTests.swift
//  SwiftLearningTests
//
//  Created by Filip Cybuch on 03/08/2022.
//

import XCTest
@testable import SwiftLearning

class NetworkControllerTests: XCTestCase {
    
    // MARK: tests
    
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


