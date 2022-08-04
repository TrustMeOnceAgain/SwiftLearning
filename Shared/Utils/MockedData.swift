//
//  MockedData.swift
//  swift-learning
//
//  Created by Filip Cybuch on 03/08/2022.
//

import Foundation

struct MockedData {
    
    static let basicRequests: [MockedRequest] = [MockedData.colorsRequest, MockedData.palettesRequest] + MockedData.currentWeathersRequests
    
    private static let colorsRequest: MockedRequest = MockedRequest(request: GetColorsRequest(), response: .success(JsonLoader.loadData("GetColors")))
    private static let palettesRequest: MockedRequest = MockedRequest(request: GetPalettesRequest(), response: .success(JsonLoader.loadData("GetPalettes")))
    private static let currentWeathersRequests: [MockedRequest] = [
        MockedRequest(request: GetCurrentWeatherRequest(location: "Wroclaw"), response: .success(JsonLoader.loadData("GetCurrentWeather_wroclaw"))),
        MockedRequest(request: GetCurrentWeatherRequest(location: "London"), response: .success(JsonLoader.loadData("GetCurrentWeather_london"))),
        MockedRequest(request: GetCurrentWeatherRequest(location: "Sydney"), response: .success(JsonLoader.loadData("GetCurrentWeather_sydney"))),
        MockedRequest(request: GetCurrentWeatherRequest(location: "Tokyo"), response: .success(JsonLoader.loadData("GetCurrentWeather_tokyo")))
    ]
}
