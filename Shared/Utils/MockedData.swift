//
//  MockedData.swift
//  swift-learning
//
//  Created by Filip Cybuch on 03/08/2022.
//

import Foundation

struct MockedData {
    static var getColorsRequest: MockedRequest = MockedRequest(request: GetColorsRequest(), response: .success(JsonLoader.loadData("GetColors")))
    static let getPalettesRequest: MockedRequest = MockedRequest(request: GetPalettesRequest(), response: .success(JsonLoader.loadData("GetPalettes")))
}
