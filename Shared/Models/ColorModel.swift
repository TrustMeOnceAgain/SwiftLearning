//
//  ColorModel.swift
//  swift-learning
//
//  Created by Filip Cybuch on 07/07/2022.
//

import Foundation
import SwiftUI

struct ColorModel: Codable {
    struct RGB: Codable {
        let red, green, blue: Int
    }
    
    let id: Int
    let title, userName: String
    let rgb: RGB
}
