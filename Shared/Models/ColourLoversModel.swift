//
//  ColourLoversModel.swift
//  SwiftLearning
//
//  Created by Filip Cybuch on 19/07/2022.
//

import SwiftUI

protocol ColourLoversModel {
    var id: Int { get }
    var title: String { get }
    var userName: String { get }
    var colors: [Color] { get }
    var webUrl: URL? { get }
    var urlString: String { get }
    var numberOfViews: Int { get }
}

extension ColourLoversModel {
    var webUrl: URL? {
        let url: String = {
            if urlString.contains("https") {
                return urlString
            } else {
                return urlString.replacingOccurrences(of: "http", with: "https")
            }
        }()
        
        return URL(string: url)
    }
}
