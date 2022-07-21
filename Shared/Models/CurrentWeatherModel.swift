//
//  CurrentWeatherModel.swift
//  swift-learning
//
//  Created by Filip Cybuch on 21/07/2022.
//

import Foundation

struct CurrentWeatherModel: Codable {
    
    let updateTimestamp: TimeInterval
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
        case updateTimeStamp = "last_updated_epoch"
        case temperatureCelsius = "temp_c"
        case temperatureFahrenheit = "temp_f"
    }
    
    init(updateTimestamp: TimeInterval, temperatureCelsius: Double, temperatureFahrenheit: Double, location: Location) {
        self.updateTimestamp = updateTimestamp
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
        updateTimestamp = try currentContainer.decode(TimeInterval.self, forKey: .updateTimeStamp)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(location, forKey: .location)

        var currentContainer = container.nestedContainer(keyedBy: CurrentCodingKeys.self, forKey: .current)
        try currentContainer.encode(temperatureCelsius, forKey: .temperatureCelsius)
        try currentContainer.encode(temperatureFahrenheit, forKey: .temperatureFahrenheit)
        try currentContainer.encode(updateTimestamp, forKey: .updateTimeStamp)
    }
}
