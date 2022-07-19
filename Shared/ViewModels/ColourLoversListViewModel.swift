//
//  ListViewModel.swift
//  swift-learning
//
//  Created by Filip Cybuch on 19/07/2022.
//

import Combine

class ColourLoversListViewModel<ModelType: ColourLoversModel>: ObservableObject {
    @Published var model: [ModelType]?
    @Published var search: String = ""
    
    @Published private var data: [ModelType]?
    private var cancellable: Set<AnyCancellable> = []
    private let repository: ColourLoversRepository
    
    init(repository: ColourLoversRepository) {
        self.repository = repository
        setupModelAndSearch()
    }
    
    func onAppear() {
        fetchData()
    }
    
    func onRefreshButtonTap() {
        fetchData()
    }
    
    private func fetchData() {
        switch ModelType.self {
        case is ColorModel.Type:
            repository
                .getColors()
                .sink(receiveCompletion: { completion in
                    print("GetColors: \(completion)") },
                      receiveValue: { [weak self] in
                    guard let data = $0 as? [ModelType] else { return }
                    self?.data = data
                })
                .store(in: &cancellable)
        case is Palette.Type:
            repository
                .getPalettes()
                .sink(receiveCompletion: { completion in
                    print("GetPalettes: \(completion)") },
                      receiveValue: { [weak self] in
                    guard let data = $0 as? [ModelType] else { return }
                    self?.data = data
                })
                .store(in: &cancellable)
        default:
            fatalError("Not implemented or not supported!")
        }
    }
    
    private func setupModelAndSearch() {
        Publishers
            .CombineLatest($data, $search)
            .map { (data, search) in
                guard !search.isEmpty else { return data }
                return data?.filter { $0.title.range(of: search, options: .caseInsensitive) != nil }
            }
            .sink(receiveValue: { [weak self] model in
                self?.model = model
            })
            .store(in: &cancellable)
    }
}
