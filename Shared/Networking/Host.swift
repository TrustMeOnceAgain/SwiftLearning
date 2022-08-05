//
//  Host.swift
//  SwiftLearning
//
//  Created by Filip Cybuch on 08/07/2022.
//

import Foundation

enum Host {
    case colourLovers, weatherAPI
    
    var value: String {
        switch self {
        case .colourLovers: return "https://www.colourlovers.com"
        case .weatherAPI: return "https://api.weatherapi.com"
        }
    }
}
