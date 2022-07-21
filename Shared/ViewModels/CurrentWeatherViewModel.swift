//
//  CurrentWeatherViewModel.swift
//  swift-learning
//
//  Created by Filip Cybuch on 21/07/2022.
//

import Combine

class CurrentWeatherViewModel: ObservableObject {
    @Published var weathers: [CurrentWeatherModel]?
    let navigationTitle: String = "Current Weather"
    
    private let repository: WeatherRepository
    private let locationNames: [String]
    private var cancellable: Set<AnyCancellable> = []
    
    init(locationNames: [String], repository: WeatherRepository) {
        self.repository = repository
        self.locationNames = locationNames
    }
    
    func onAppear() {
        fetchData()
    }
    
    func onRefreshButton() {
        fetchData()
    }
    
    private func fetchData() {
        let publishers = locationNames.map { repository.getCurrentWeather(for: $0) }
        
        publishers
            .dropFirst()
            .reduce(into: AnyPublisher(publishers[0].map { [$0] })) {
                result, object in
                result = result.zip(object) {
                    $0 + [$1]
                }.eraseToAnyPublisher()
            }
            .sink(receiveCompletion: { print("\(#function): \($0)") },
                  receiveValue: { [weak self] in
                self?.weathers = $0
            })
            .store(in: &cancellable)
    }
}