//
//  Constants.swift
//  SwiftLearning
//
//  Created by Filip Cybuch on 07/07/2022.
//

import SwiftUI

class Constants {
    static let defaultTileSize: CGFloat = 100
    static let defaultTileSpacing: CGFloat = 20
    static let defaultCornerRadius: CGFloat = 10
    static let smallIconSize: CGFloat = 32

    static let defaultGridItem = GridItem(.adaptive(minimum: Constants.defaultTileSize,
                                                     maximum: Constants.defaultTileSize),
                                           spacing: Constants.defaultTileSpacing,
                                           alignment: .center)
}
