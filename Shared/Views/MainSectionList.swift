//
//  MainSectionList.swift
//  swift-learning
//
//  Created by Filip Cybuch on 18/07/2022.
//

import SwiftUI
import Combine

struct MainSectionList: View {
    
    enum MainSection: CaseIterable {
        case colourLovers, weather
        
        var name: String {
            switch self {
            case .colourLovers:
                return "Colour lovers"
            case .weather:
                return "Weather"
            }
        }
    }
    
    enum Position: CaseIterable {
        case colors, palettes, currentWeather
        
        var navigationTitle: String {
            switch self {
            case .colors:
                return "Colors"
            case .palettes:
                return "Palettes"
            case .currentWeather:
                return "Current weather"
            }
        }
        
        var section: MainSection {
            switch self {
            case .colors, .palettes:
                return .colourLovers
            case .currentWeather:
                return .weather
            }
        }
    }
    
    private let coloursLoverRepository: ColourLoversRepository
    private let weatherRepository: WeatherRepository
    private var viewModel: [Position] = Position.allCases
    
    init(coloursLoverRepository: ColourLoversRepository, weatherRepository: WeatherRepository) {
        self.coloursLoverRepository = coloursLoverRepository
        self.weatherRepository = weatherRepository
    }
    
    var body: some View {
            createView()
            #if os(macOS)
                .frame(minWidth: 200)
            #endif
                .background(Color(.backgroundColor))
                .navigationTitle("Main list")
    }
}

// MARK: View builders
extension MainSectionList {
    @ViewBuilder
    private func createView() -> some View {
        VStack {
            List {
                ForEach(MainSection.allCases, id: \.hashValue) { section in
                    Section {
                        ForEach(viewModel.filter({ $0.section == section }), id: \.navigationTitle) { position in
                            NavigationLink(destination: detinationView(for: position)) {
                                Cell(viewModel: CellViewModel(title: position.navigationTitle, subtitle: nil, rightColors: nil))
                            }
                        }
                    } header: {
                        Text(section.name)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func detinationView(for position: Position) -> some View {
        switch position {
        case .colors: ColourLoversListView<ColorModel>()
                .environmentObject(ColourLoversListViewModel<ColorModel>(repository: coloursLoverRepository))
        case .palettes: ColourLoversListView<PaletteModel>()
                .environmentObject(ColourLoversListViewModel<PaletteModel>(repository: coloursLoverRepository))
        case .currentWeather: WeatherView(viewModel: CurrentWeatherViewModel(locationNames: ["Wroclaw", "London", "Sydney", "Paris", "Tokyo"], repository: weatherRepository)) // TODO: Read from defaults and add possibility to change that
        }
    }
}

struct MainSectionList_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(ColorScheme.allCases, id: \.hashValue) { colorScheme in
                NavigationView {
                    MainSectionList(coloursLoverRepository: MockedColourLoversRepository(),
                                    weatherRepository: MockedWeatherRepository())
                }
                .preferredColorScheme(colorScheme)
            }
        }
        .previewLayout(.device)
    }
}
