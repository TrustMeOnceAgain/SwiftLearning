//
//  ColorListViewModel.swift
//  swift-learning
//
//  Created by Filip Cybuch on 15/07/2022.
//

import Combine

class ColorListViewModel: ObservableObject {
    
    @Published var colors: [ListColor] = []
    @Published var search: String = ""
    
    @Published private var model: [ListColor]?
    private var cancellable: Set<AnyCancellable> = []
    private let repository: ColourLoversRepository
    
    init(repository: ColourLoversRepository = DIManager.shared.colourLoversRepository) {
        self.repository = repository
        setupSearch()
    }
    
    func onAppear() {
        fetchData()
    }
    
    func onRefreshButtonTap() {
        fetchData()
    }
    
    private func setupSearch() {
        Publishers
            .CombineLatest($search, $model)
            .map { (search, model) in
                guard !search.isEmpty else { return model }
                return model?.filter { $0.title.range(of: search, options: .caseInsensitive) != nil }
            }
            .sink(receiveValue: { [weak self] in
                self?.colors = $0 ?? []
            })
            .store(in: &cancellable)
    }
    
    private func fetchData() {
        repository
            .getColors()
            .map { models in
                models.map { ListColor(id: $0.id, title: $0.title, userName: $0.userName, rgb: $0.rgb) }
            }
            .sink(receiveCompletion: { completion in
                print("\(#function): \(completion)")
            }, receiveValue: { [weak self] model in
                self?.model = model
            })
            .store(in: &cancellable)
    }
}
