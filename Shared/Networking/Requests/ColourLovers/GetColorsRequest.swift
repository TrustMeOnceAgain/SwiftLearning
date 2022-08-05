//
//  GetColorsRequest.swift
//  SwiftLearning
//
//  Created by Filip Cybuch on 08/07/2022.
//

import Foundation

struct GetColorsRequest: Request {
    
    var path: String { "/api/colors" }
    var host: Host { .colourLovers }
    var parameters: Parameters? { [("format", "json")] }
    var httpMethod: HTTPMethod { .GET }
}
