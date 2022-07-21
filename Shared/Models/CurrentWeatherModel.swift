//
//  CurrentWeatherModel.swift
//  swift-learning
//
//  Created by Filip Cybuch on 21/07/2022.
//

import Foundation

struct CurrentWeatherModel: Codable {
    
    let date: Date
    let temperatureCelsius: Double
    let temperatureFahrenheit: Double
    let location: Location
    
    struct Location: Codable {
        let name, country: String
    }
    
    enum CodingKeys: String, CodingKey {
        case location
        case current
    }
    
    enum CurrentCodingKeys: String, CodingKey {
        case date = "last_updated"
        case temperatureCelsius = "temp_c"
        case temperatureFahrenheit = "temp_f"
    }
    
    init(date: Date, temperatureCelsius: Double, temperatureFahrenheit: Double, location: Location) {
        self.date = date
        self.temperatureCelsius = temperatureCelsius
        self.temperatureFahrenheit = temperatureFahrenheit
        self.location = location
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        location = try container.decode(Location.self, forKey: .location)
        
        let currentContainer = try container.nestedContainer(keyedBy: CurrentCodingKeys.self, forKey: .current)
        temperatureCelsius = try currentContainer.decode(Double.self, forKey: .temperatureCelsius)
        temperatureFahrenheit = try currentContainer.decode(Double.self, forKey: .temperatureFahrenheit)
        date = try currentContainer.decode(Date.self, forKey: .date)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(location, forKey: .location)

        var currentContainer = container.nestedContainer(keyedBy: CurrentCodingKeys.self, forKey: .current)
        try currentContainer.encode(temperatureCelsius, forKey: .temperatureCelsius)
        try currentContainer.encode(temperatureFahrenheit, forKey: .temperatureFahrenheit)
        try currentContainer.encode(date, forKey: .date)
    }
}
