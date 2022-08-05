//
//  Numeric+temperatureSymbol.swift
//  SwiftLearning
//
//  Created by Filip Cybuch on 21/07/2022.
//

import Foundation

extension Numeric {
    var withCelsiusSymbol: String { String("\(self)°C") }
    var withFahrenheitSymbol: String { String("\(self)°F") }
}
