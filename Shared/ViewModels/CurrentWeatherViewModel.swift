//
//  CurrentWeatherViewModel.swift
//  swift-learning
//
//  Created by Filip Cybuch on 21/07/2022.
//

import Combine

class CurrentWeatherViewModel: ObservableObject {
    let navigationTitle: String = "Current Weather"
    @Published var dataStatus: ViewDataStatus<[CurrentWeatherModel]> = .notLoaded
    
    @Published private var weathers: [CurrentWeatherModel]?
    private let repository: WeatherRepository
    private let locationNames: [String]
    private var cancellable: Set<AnyCancellable> = []
    
    init(locationNames: [String], repository: WeatherRepository) {
        self.locationNames = locationNames
        self.repository = repository
    }
    
    func onAppear() {
        fetchData()
    }
    
    func onRefreshButtonTap() {
        fetchData()
    }
    
    private func fetchData() {
        dataStatus = .loading
        let publishers = locationNames.map { repository.getCurrentWeather(for: $0) }
        
        publishers
            .dropFirst()
            .reduce(into: AnyPublisher(publishers[0].map { [$0] })) {
                result, object in
                result = result.zip(object) {
                    $0 + [$1]
                }
                .eraseToAnyPublisher()
            }
            .sink(
                receiveCompletion: { [weak self] in
                    guard case .failure(let error) = $0 else { return }
                    self?.dataStatus = .error(error)
                },
                receiveValue: { [weak self] in
                    self?.weathers = $0
                    self?.dataStatus = .loaded(data: $0)
                })
            .store(in: &cancellable)
    }
}
