//
//  DIManager.swift
//  swift-learning
//
//  Created by Filip Cybuch on 07/07/2022.
//

import Foundation

class DIManager {
    static var shared: DIManager = DIManager()
    private init() {}
    
    lazy private(set) var colourLoversController = ColourLoversController(networkController: RealNetworkController())
}
