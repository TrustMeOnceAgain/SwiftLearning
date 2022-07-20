//
//  ListColor.swift
//  swift-learning
//
//  Created by Filip Cybuch on 15/07/2022.
//

import SwiftUI

struct ListColor { // TODO: remove?
    let id: Int
    let title, userName: String
    let rgb: ColorModel.RGB
}

struct ListDetailsViewModel { // TODO: change name
    let title, userName: String
    let colors: [Color]
    let url: URL?
}
