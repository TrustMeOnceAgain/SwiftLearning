//
//  GetCurrentWeatherRequest.swift
//  SwiftLearning
//
//  Created by Filip Cybuch on 21/07/2022.
//

import Foundation

struct GetCurrentWeatherRequest: Request {
    
    let location: String
    
    var path: String { "/v1/current.json" }
    var host: Host { .weatherAPI }
    var parameters: Parameters? { [("key", "2a54b379abaa48aaa1070253222107"),
                                   ("q", location),
                                   ("aqi", "no")] }
    var httpMethod: HTTPMethod { .GET }
}
