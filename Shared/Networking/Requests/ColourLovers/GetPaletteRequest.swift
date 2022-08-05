//
//  GetPaletteRequest.swift
//  SwiftLearning
//
//  Created by Filip Cybuch on 19/07/2022.
//

import Foundation

struct GetPaletteRequest: Request {
    
    let paletteId: Int
    
    var path: String { "/api/palette/\(paletteId)" }
    var host: Host { .colourLovers }
    var parameters: Parameters? { [("format", "json")] }
    var httpMethod: HTTPMethod { .GET }
}
