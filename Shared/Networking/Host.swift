//
//  Host.swift
//  swift-learning
//
//  Created by Filip Cybuch on 08/07/2022.
//

import Foundation

enum Host {
    case colourLovers
    
    var value: String {
        switch self {
        case .colourLovers: return "https://www.colourlovers.com"
        }
    }
}
