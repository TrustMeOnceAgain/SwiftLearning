//
//  ViewDataStatus.swift
//  swift-learning
//
//  Created by Filip Cybuch on 29/07/2022.
//

import Foundation

enum ViewDataStatus<T> {
    case notLoaded, loading, loaded(data: T), error(_ error: RequestError)
}
