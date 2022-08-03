//
//  GetColorRequest.swift
//  swift-learning
//
//  Created by Filip Cybuch on 19/07/2022.
//

import Foundation

struct GetColorRequest: Request { // TODO: delete
    
    let colorId: Int
    
    var path: String { "/api/color/\(colorId)" }
    var host: Host { .colourLovers }
    var parameters: Parameters? { ["format": "json"] }
    var httpMethod: HTTPMethod { .GET }
}
