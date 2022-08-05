//
//  CurrentWeatherModel.swift
//  SwiftLearning
//
//  Created by Filip Cybuch on 21/07/2022.
//

import Foundation

struct CurrentWeatherModel: Equatable {
    
    struct Location: Decodable, Equatable {
        let name, country: String
    }
    
    struct Condition: Decodable, Equatable {
        let text: String
        let imageUrlString: String
        let code: Int
        
        var imageURL: URL? {
            let webURL = CurrentWeatherModel.getURL(from: imageUrlString)
            let localURL = URL.localURLForXCAssets(imageName: imageUrlString) // for mocked cases
            return localURL ?? webURL
        }
        
        enum CodingKeys: String, CodingKey {
            case imageUrlString = "icon"
            case text, code
        }
    }
    
    let updateTimestamp: TimeInterval
    let temperatureCelsius: Double
    let temperatureFahrenheit: Double
    let location: Location
    let condition: Condition?
    
    init(updateTimestamp: TimeInterval, temperatureCelsius: Double, temperatureFahrenheit: Double, location: Location, condition: Condition? = nil) {
        self.updateTimestamp = updateTimestamp
        self.temperatureCelsius = temperatureCelsius
        self.temperatureFahrenheit = temperatureFahrenheit
        self.location = location
        self.condition = condition
    }
    
    private static func getURL(from urlString: String?) -> URL? {
        guard let urlString = urlString else { return nil }
        return URL(string: urlString.replacingOccurrences(of: "//", with: "https://"))
    }
}

extension CurrentWeatherModel: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case location
        case current
    }
    
    enum CurrentCodingKeys: String, CodingKey {
        case updateTimeStamp = "last_updated_epoch"
        case temperatureCelsius = "temp_c"
        case temperatureFahrenheit = "temp_f"
        case condition
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        location = try container.decode(Location.self, forKey: .location)
        
        let currentContainer = try container.nestedContainer(keyedBy: CurrentCodingKeys.self, forKey: .current)
        temperatureCelsius = try currentContainer.decode(Double.self, forKey: .temperatureCelsius)
        temperatureFahrenheit = try currentContainer.decode(Double.self, forKey: .temperatureFahrenheit)
        updateTimestamp = try currentContainer.decode(TimeInterval.self, forKey: .updateTimeStamp)
        
        condition = try currentContainer.decodeIfPresent(Condition.self, forKey: .condition)
    }
}
