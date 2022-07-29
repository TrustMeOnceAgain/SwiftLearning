//
//  ViewDataStatus.swift
//  swift-learning
//
//  Created by Filip Cybuch on 29/07/2022.
//

import Foundation

enum ViewDataStatus {
    case notLoaded, loading, loaded, error(_ error: RequestError)
}
