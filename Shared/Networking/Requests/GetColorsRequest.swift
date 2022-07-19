//
//  GetColorsRequest.swift
//  swift-learning
//
//  Created by Filip Cybuch on 08/07/2022.
//

import Foundation

struct GetColorsRequest: Request {
    
    var path: String { "/api/colors" }
    var host: Host { .colourLovers }
    var parameters: Parameters { .queryKeyValues([(key: "format", value: "json")]) }
    var httpMethod: HTTPMethod { .GET }
}
