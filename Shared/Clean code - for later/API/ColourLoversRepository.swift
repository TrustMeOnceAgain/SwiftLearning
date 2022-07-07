//
//  ColourLoversRepository.swift
//  swift-learning
//
//  Created by Filip Cybuch on 07/07/2022.
//

import Combine
import Foundation

protocol ColourLoverRepository: WebRepository {
    func getColors() -> AnyPublisher<[ColorModel], Error>
}

class RealColourLoversRepository: ColourLoverRepository {
    
    var session: URLSession
    var baseURL: String
    var bgQueue: DispatchQueue = DispatchQueue(label: "bg_parse_queue")
    
    init(session: URLSession, baseURL: String) {
        self.session = session
        self.baseURL = baseURL
    }
    
    func getColors() -> AnyPublisher<[ColorModel], Error> {
        call(endpoint: API.allColors)
    }
}
