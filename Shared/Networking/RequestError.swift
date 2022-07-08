//
//  RequestError.swift
//  swift-learning
//
//  Created by Filip Cybuch on 08/07/2022.
//

import Foundation

enum RequestError: Error {
    case badURL, parsingFailure, badRequest
}
