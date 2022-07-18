//
//  PaletteListViewModel.swift
//  swift-learning
//
//  Created by Filip Cybuch on 18/07/2022.
//

import Combine

class PaletteListViewModel: ObservableObject { // TODO: merge with ColorLostViewModel
    @Published var palettes: [Palette] = []
    @Published var search: String = ""
    
    @Published private var model: [Palette]?
    private let repository: ColourLoversRepository
    private var cancellable: Set<AnyCancellable> = []
    
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
            .map { (search, palettes) in
                guard !search.isEmpty else { return palettes }
                return palettes?.filter { $0.title.range(of: search, options: .caseInsensitive) != nil }
            }
            .sink(receiveValue: { [weak self] in self?.palettes = $0 ?? [] })
            .store(in: &cancellable)
    }
    
    private func fetchData() {
        repository
            .getPalettes()
            .sink(receiveCompletion: { completion in
                print("\(#function): \(completion)")
            }, receiveValue: { [weak self] palletes in
                self?.model = palletes
            })
            .store(in: &cancellable)
    }
}
