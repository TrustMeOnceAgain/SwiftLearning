//
//  WeatherView.swift
//  swift-learning
//
//  Created by Filip Cybuch on 21/07/2022.
//

import SwiftUI

struct WeatherView: View {
    
    @ObservedObject var viewModel: CurrentWeatherViewModel
    
    var body: some View {
        contentView
            .background(Color(.backgroundColor))
            .navigationTitle(viewModel.navigationTitle)
            .padding()
    }
    
    @ViewBuilder
    var contentView: some View {
        VStack {
            if let weathers = viewModel.weathers {
                LazyVGrid(columns: [Constants.defaultGridItem], alignment: .center, spacing: Constants.defaultTileSpacing) {
                    ForEach(weathers, id: \.location.name) { model in
                        WeatherTile(viewModel: model)
                    }
                }
                Spacer()
            } else {
                Spacer()
                InfoView(text: "No weather info",
                         onAppearAction: viewModel.onAppear,
                         onRefreshButtonTapAction: viewModel.onRefreshButton)
                Spacer()
            }
        }
    }
}

//struct WeatherView_Previews: PreviewProvider {
//    static var previews: some View {
//        WeatherView(viewModel: CurrentWeatherViewModel(locationNames: ["Wroclaw", "Paris"], repository: ))
//    }
//}
