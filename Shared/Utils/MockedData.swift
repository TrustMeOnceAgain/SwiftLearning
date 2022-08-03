//
//  MockedData.swift
//  swift-learning
//
//  Created by Filip Cybuch on 03/08/2022.
//

import Foundation

struct MockedData {
    static let getColorsRequest: MockedRequest = MockedRequest(request: GetColorsRequest(), response: .success(JsonLoader.loadData("GetColors")))
    static let getPalettesRequest: MockedRequest = MockedRequest(request: GetPalettesRequest(), response: .success(JsonLoader.loadData("GetPalettes")))
    static let getCurrentWeathersRequests: [MockedRequest] = [
        MockedRequest(request: GetCurrentWeatherRequest(location: "Wroclaw"), response: .success(JsonLoader.loadData("GetCurrentWeather_wroclaw"))),
        MockedRequest(request: GetCurrentWeatherRequest(location: "London"), response: .success(JsonLoader.loadData("GetCurrentWeather_london"))),
        MockedRequest(request: GetCurrentWeatherRequest(location: "Sydney"), response: .success(JsonLoader.loadData("GetCurrentWeather_sydney"))),
        MockedRequest(request: GetCurrentWeatherRequest(location: "Tokyo"), response: .success(JsonLoader.loadData("GetCurrentWeather_tokyo")))
    ]
    
    static let allRequests: [MockedRequest] = [
        MockedData.getColorsRequest,
        MockedData.getPalettesRequest,
    ] + MockedData.getCurrentWeathersRequests
}
