//
//  GetPalettesRequest.swift
//  swift-learning
//
//  Created by Filip Cybuch on 18/07/2022.
//

import Foundation

struct GetPalettesRequest: Request {
    
    var path: String { "/api/palettes" }
    var host: Host { .colourLovers }
    var parameters: Parameters { .queryKeyValues([(key: "format", value: "json")]) }
    var httpMethod: HTTPMethod { .GET }
}
