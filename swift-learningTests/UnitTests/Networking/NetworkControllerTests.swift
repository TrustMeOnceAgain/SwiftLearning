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
        
        let mockedRequests: [MockedRequest] = [MockedRequest(request: GetColorsRequest(), response: .success(JsonLoader.loadData("GetColors")))]
        
        let networkController = MockedNetworkController(mockedRequests: mockedRequests)
        
        let getColorsRequest = GetColorsRequest()
        do {
            let data: [ColorModel] = try await networkController.sendRequest(getColorsRequest)
            let expectedResult: [ColorModel] = [
                ColorModel(id: 1, title: "SuchColor", userName: "TrustMe", rgb: .init(red: 10, green: 30, blue: 150), numberOfViews: 154384, url: "http://www.colourlovers.com/color/000000/SuchColor"),
                ColorModel(id: 2, title: "SuchSecondColor", userName: "TrustedOnce", rgb: .init(red: 50, green: 4, blue: 14), numberOfViews: 450, url: "http://www.colourlovers.com/color/000000/SuchSecondColor")
            ]
            XCTAssertEqual(data, expectedResult)
        } catch let error as RequestError {
            XCTFail(error.localizedDescription)
        } catch {
            XCTFail("There should not be any error thrown")
        }
    }
}


