//
//  ColourLoversModel.swift
//  swift-learning
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
    var numberOfViews: Int { get }
}
