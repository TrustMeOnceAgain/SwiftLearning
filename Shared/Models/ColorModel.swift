//
//  ColorModel.swift
//  swift-learning
//
//  Created by Filip Cybuch on 07/07/2022.
//

import SwiftUI

struct ColorModel: ColourLoversModel, Identifiable {
    
    struct RGB: Codable {
        let red, green, blue: Int
    }
    
    let id: Int
    let title, userName: String
    let rgb: RGB
    let numberOfViews: Int
    let urlString: String
    
    var color: Color { Color(.sRGB, red: Double(rgb.red)/255, green: Double(rgb.green)/255, blue: Double(rgb.blue)/255, opacity: 1.0) }
    var colors: [Color] { [color] }
    
    init(id: Int, title: String, userName: String, rgb: RGB, numberOfViews: Int, url: String) {
        self.id = id
        self.title = title
        self.userName = userName
        self.rgb = rgb
        self.numberOfViews = numberOfViews
        self.urlString = url
    }
}

extension ColorModel: Decodable {
    enum CodingKeys: String, CodingKey {
        case id, title, userName, rgb
        case urlString = "url"
        case numberOfViews = "numViews"
    }
}

extension ColorModel: Equatable {
    static func == (lhs: ColorModel, rhs: ColorModel) -> Bool {
        lhs.id == rhs.id
    }
}
