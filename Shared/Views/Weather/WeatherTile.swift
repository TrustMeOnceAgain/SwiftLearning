//
//  WeatherTile.swift
//  SwiftLearning
//
//  Created by Filip Cybuch on 21/07/2022.
//

import SwiftUI

struct WeatherTile: View {
    
    let viewModel: CurrentWeatherModel
    
    var body: some View {
        RoundedRectangle(cornerRadius: Constants.defaultCornerRadius)
            .fill()
            .foregroundColor(Color(.tileColor))
            .frame(width: Constants.defaultTileSize,
                   height: Constants.defaultTileSize,
                   alignment: .center)
            .overlay(getView())
            .overlay(
                RoundedRectangle(cornerRadius: Constants.defaultCornerRadius)
                    .stroke(Color(.borderColor), lineWidth: 2)
            )
    }
    
    @ViewBuilder
    private func getView() -> some View {
        VStack(spacing: 0) {
            HStack {
                Text(viewModel.location.name)
                    .foregroundColor(Color(.mainLabel))
            }
            if let temperature = Int(exactly: viewModel.temperatureCelsius.rounded()) {
                HStack(spacing: 2) {
                    if let imageURL = viewModel.condition?.imageURL {
                            AsyncImage(url: imageURL,
                                       content: { $0.resizable() },
                                       placeholder: { Rectangle()
                                .fill(Color(.backgroundColor))
                                .frame(width: Constants.smallIconSize, height: Constants.smallIconSize) })
                            .frame(width: Constants.smallIconSize, height: Constants.smallIconSize)
                    }
                    Text(temperature.withCelsiusSymbol)
                        .foregroundColor(Color(.secondaryLabel))
                }
            }
        }
    }
}

struct WeatherTile_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(ColorScheme.allCases, id: \.hashValue) { colorScheme in
                Group {
                    WeatherTile(viewModel: CurrentWeatherModel(updateTimestamp: Date().timeIntervalSince1970, temperatureCelsius: 30.4, temperatureFahrenheit: 70.0, location: .init(name: "Wroclaw", country: "Poland"), condition: .init(text: "Sunny", imageUrlString: "Sunny", code: 1000)))
                        
                    WeatherTile(viewModel: CurrentWeatherModel(updateTimestamp: Date().timeIntervalSince1970, temperatureCelsius: 31.6, temperatureFahrenheit: 70.0, location: .init(name: "Wroclaw", country: "Poland")))
                }
                .preferredColorScheme(colorScheme)
            }
        }
        .previewLayout(.sizeThatFits)
    }
}
