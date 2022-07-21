//
//  WeatherTile.swift
//  swift-learning
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
        VStack {
            HStack {
                Text(viewModel.location.name)
                    .foregroundColor(Color(.mainLabel))
            }
            if let temperature = Int(exactly: viewModel.temperatureCelsius.rounded()) {
                HStack {
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
            WeatherTile(viewModel: CurrentWeatherModel(date: Date(), temperatureCelsius: 30.4, temperatureFahrenheit: 70.0, location: .init(name: "Wroclaw", country: "Poland")))
                .preferredColorScheme(.light)
                
            WeatherTile(viewModel: CurrentWeatherModel(date: Date(), temperatureCelsius: 31.6, temperatureFahrenheit: 70.0, location: .init(name: "Wroclaw", country: "Poland")))
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
}