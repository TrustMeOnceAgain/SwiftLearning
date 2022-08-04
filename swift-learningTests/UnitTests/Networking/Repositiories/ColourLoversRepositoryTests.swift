//
//  ColourLoversRepositoryTests.swift
//  swift-learningTests
//
//  Created by Filip Cybuch on 04/08/2022.
//

import XCTest
import Combine
@testable import swift_learning

class ColourLoversRepositoryTests: XCTestCase {
    
    private let expectationTimeout: Double  = 2
    private var cancellable = Set<AnyCancellable>()
    
    // MARK: tests
    
    func testGetColors() async {
        let repositoryType: RepositoryType = .color
        let repository = setupRepository(for: repositoryType)
        let expectedResult = expectedResult(for: repositoryType) as! [ColorModel]
        
        do {
            let data: [ColorModel] = try await repository.getColors()
            XCTAssertEqual(data, expectedResult)
        } catch let error as RequestError {
            XCTFail(error.localizedDescription)
        } catch {
            XCTFail("There should not be any error thrown")
        }
    }
    
    func testGetPalettes() async {
        let repositoryType: RepositoryType = .palette
        let repository = setupRepository(for: repositoryType)
        let expectedResult = expectedResult(for: repositoryType) as! [PaletteModel]
        
        do {
            let data: [PaletteModel] = try await repository.getPalettes()
            XCTAssertEqual(data, expectedResult)
        } catch let error as RequestError {
            XCTFail(error.localizedDescription)
        } catch {
            XCTFail("There should not be any error thrown")
        }
    }
    
    func testCombineAndAsync_GetColors() async {
        let repositoryType: RepositoryType = .color
        let repository = setupRepository(for: repositoryType)
        let expectedResult = expectedResult(for: repositoryType) as! [ColorModel]
        
        let combineExpectation = XCTestExpectation(description: "Waather Combine Completion")
        let asyncExpectation = XCTestExpectation(description: "Weather Async Completion")
        
        var combineResultData: [ColorModel]? = nil
        var asyncResultData: [ColorModel]? = nil
        
        repository
            .getColors()
            .sinkToResult( { result in
                if case .success(let data) = result {
                    combineResultData = data
                    combineExpectation.fulfill()
                }
            })
            .store(in: &cancellable)
        
        do {
            let data: [ColorModel] = try await repository.getColors()
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
    
    func testCombineAndAsync_GetPalettes() async {
        let repositoryType: RepositoryType = .palette
        let repository = setupRepository(for: repositoryType)
        let expectedResult = expectedResult(for: repositoryType) as! [PaletteModel]
        
        let combineExpectation = XCTestExpectation(description: "Waather Combine Completion")
        let asyncExpectation = XCTestExpectation(description: "Weather Async Completion")
        
        var combineResultData: [PaletteModel]? = nil
        var asyncResultData: [PaletteModel]? = nil
        
        repository
            .getPalettes()
            .sinkToResult( { result in
                if case .success(let data) = result {
                    combineResultData = data
                    combineExpectation.fulfill()
                }
            })
            .store(in: &cancellable)
        
        do {
            let data: [PaletteModel] = try await repository.getPalettes()
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
    
    private func setupRepository(for type: RepositoryType) -> ColourLoversRepository {
        let request = type.request
        let mockedRequests: [MockedRequest] = [MockedRequest(request: request, response: .success(JsonLoader.loadData(type.fileName)))]
        let networkController = MockedNetworkController(mockedRequests: mockedRequests)
        return RealColourLoversRepository(networkController: networkController)
    }
    
    private func expectedResult(for type: RepositoryType) -> [ColourLoversModel] {
        switch type {
        case .color:
            return [
                ColorModel(id: 1, title: "SuchColor", userName: "TrustMe", rgb: .init(red: 10, green: 30, blue: 150), numberOfViews: 154384, url: "http://www.colourlovers.com/color/000000/SuchColor"),
                ColorModel(id: 2, title: "SuchSecondColor", userName: "TrustedOnce", rgb: .init(red: 50, green: 4, blue: 14), numberOfViews: 450, url: "http://www.colourlovers.com/color/000000/SuchSecondColor")
            ]
        case .palette:
            return [
                PaletteModel(id: 92094, title: "My Rose", userName: "fazai38", colorValues: ["C9F2CA", "88AE63", "688F40", "A3925A", "992E1C"], numberOfViews: 352, url: "http://www.colourlovers.com/palette/92094/My_Rose"),
                PaletteModel(id: 92095, title: "Giant Goldfish", userName: "manekineko", colorValues: ["69D2E7", "A7DBD8", "E0E4CC", "F38630", "FA6900"], numberOfViews: 1112727, url: "http://www.colourlovers.com/palette/92095/Giant_Goldfish")
            ]
        }
    }
    
    private enum RepositoryType {
        case color, palette
        
        var request: Request {
            switch self {
            case .color:
                return GetColorsRequest()
            case .palette:
                return GetPalettesRequest()
            }
        }
        
        var fileName: String {
            switch self {
            case .color:
                return "GetColors"
            case .palette:
                return "GetPalettes"
            }
        }
    }
}
