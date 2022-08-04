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
    
    private var cancellable = Set<AnyCancellable>()
    
    func testRepository() {
        let mockedNetworkController = MockedNetworkController(mockedRequests: [MockedRequest(request: GetColorsRequest(), response: .failure(.badRequest)), MockedRequest(request: GetPalettesRequest(), response: .failure(.parsingFailure))])
        let colourRepository: ColourLoversRepository = RealColourLoversRepository(networkController: mockedNetworkController)
        let colorExpectation = XCTestExpectation(description: "Color Completion")
        let paletteExpectation = XCTestExpectation(description: "Palette Completion")
        
        colourRepository
            .getColors()
            .sinkToResult( { result in
                if case .failure(let error) = result {
                    XCTAssertEqual(error, .badRequest)
                    colorExpectation.fulfill()
                } else {
                    XCTFail()
                }
            })
            .store(in: &cancellable)
        
        colourRepository
            .getPalettes()
            .sinkToResult( { result in
                if case .failure(let error) = result {
                    XCTAssertEqual(error, .parsingFailure)
                    paletteExpectation.fulfill()
                } else {
                    XCTFail()
                }
            })
            .store(in: &cancellable)
        
        wait(for: [colorExpectation, paletteExpectation], timeout: 2)
    }
}
