//
//  ColorModel.swift
//  swift-learning
//
//  Created by Filip Cybuch on 07/07/2022.
//

import SwiftUI

struct ColorModel: Codable, ColourLoversModel {
    
    struct RGB: Codable {
        let red, green, blue: Int
    }
    
    let id: Int
    let title, userName: String
    let rgb: RGB
    let numViews: Int
    private let url: String
    
    var color: Color { Color(.sRGB, red: Double(rgb.red)/255, green: Double(rgb.green)/255, blue: Double(rgb.blue)/255, opacity: 1.0) }
    var colors: [Color] { [color] }
    var webUrl: URL? { URL(string: url.replacingOccurrences(of: "http", with: "https")) }
}
