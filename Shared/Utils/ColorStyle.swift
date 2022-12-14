//
//  ColorStyle.swift
//  SwiftLearning
//
//  Created by Filip Cybuch on 12/07/2022.
//

import SwiftUI

enum ColorStyle {
    case mainLabel, secondaryLabel, accentColor, borderColor, backgroundColor, tileColor
}

extension Color {
    init(_ colorStyle: ColorStyle) {
        switch colorStyle {
        case .mainLabel:
            self = Color("MainLabel")
        case .secondaryLabel:
            self = Color("SecondaryLabel")
        case .accentColor:
            self = Color("AccentColor")
        case .borderColor:
            self = Color("BorderColor")
        case .backgroundColor:
            self = Color("BackgroundColor")
        case .tileColor:
            self = Color("TileColor")
        }
    }
}
