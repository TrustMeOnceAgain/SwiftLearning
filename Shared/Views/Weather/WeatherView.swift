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
            .padding()
            .background(Color(.backgroundColor))
            .navigationTitle(viewModel.navigationTitle)
            .toolbar { // TODO: fix for macOS
                ToolbarItem(placement: .primaryAction) {
                    CustomButtonView(text: nil, imageString: "arrow.clockwise.circle", imageSize: 25, action: { viewModel.onRefreshButtonTap() })
                }
            }
    }
    
    @ViewBuilder
    var contentView: some View {
        VStack {
            switch viewModel.dataStatus {
            case .loaded(let weathers):
                loadedView(model: weathers)
            case .loading:
                ProgressView()
                    .progressViewStyle(.circular)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            case .notLoaded:
                InfoView(text: "There is no data to show!",
                         onAppearAction: viewModel.onAppear,
                         onRefreshButtonTapAction: viewModel.onRefreshButtonTap)
            case .error(_):
                InfoView(text: "Error during loading data!",
                         onAppearAction: nil,
                         onRefreshButtonTapAction: viewModel.onRefreshButtonTap)
            }
        }
    }
    
    func loadedView(model: [CurrentWeatherModel]) -> some View {
        VStack {
            LazyVGrid(columns: [Constants.defaultGridItem], alignment: .center, spacing: Constants.defaultTileSpacing) {
                ForEach(model, id: \.location.name) { model in
                    WeatherTile(viewModel: model)
                }
            }
            Spacer(minLength: 0)
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    
    private static let locations = ["Sydney", "London", "Wroclaw", "Tokyo"]
    private static let viewModel = CurrentWeatherViewModel(locationNames: WeatherView_Previews.locations, repository: RealWeatherRepository(networkController: MockedNetworkController()))
    
    static var previews: some View {
        Group {
            ForEach(ColorScheme.allCases, id: \.hashValue) { colorScheme in
                #if os(iOS)
                NavigationView {
                    WeatherView(viewModel: viewModel)
                }
                .preferredColorScheme(colorScheme)
                
                #elseif os(macOS)
                WeatherView(viewModel: viewModel)
                    .preferredColorScheme(colorScheme)
                #endif
            }
        }
        .previewLayout(.device)
    }
}
