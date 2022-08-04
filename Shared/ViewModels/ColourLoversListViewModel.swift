//
//  ListViewModel.swift
//  swift-learning
//
//  Created by Filip Cybuch on 19/07/2022.
//

import Combine

class ColourLoversListViewModel<ModelType: ColourLoversModel>: ObservableObject {
    
    @Published var search: String = ""
    @Published var dataStatus: ViewDataStatus<[ModelType]> = .notLoaded
    
    @Published private var filteredData: [ModelType]?
    @Published private var data: [ModelType]?
    private var cancellable: Set<AnyCancellable> = []
    private let repository: ColourLoversRepository
    
    var navigationTitle: String {
        switch ModelType.self {
        case is ColorModel.Type: return "Colors"
        case is PaletteModel.Type: return "Palettes"
        default: return ""
        }
    }
    
    init(repository: ColourLoversRepository) {
        self.repository = repository
        setupModelAndSearch()
        setupDataStatus()
    }
    
    func onAppear() {
        fetchData()
    }
    
    func onRefreshButtonTap() {
        fetchData()
    }
    
    private func fetchData() {
        dataStatus = .loading
        
        switch ModelType.self {
        case is ColorModel.Type:
            repository
                .getColors()
                .sink(
                    receiveCompletion: { [weak self] in
                        guard case .failure(let error) = $0 else { return }
                        self?.dataStatus = .error(error)
                    },
                    receiveValue: { [weak self] in
                        guard let data = $0 as? [ModelType] else { return }
                        self?.data = data
                        self?.dataStatus = .loaded(data: data)
                    })
                .store(in: &cancellable)
            
        case is PaletteModel.Type:
            repository
                .getPalettes()
                .sink(
                    receiveCompletion:{ [weak self] in
                        guard case .failure(let error) = $0 else { return }
                        self?.dataStatus = .error(error)
                    },
                    receiveValue: { [weak self] in
                        guard let data = $0 as? [ModelType] else { return }
                        self?.data = data
                        self?.dataStatus = .loaded(data: data)
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
                return data?.filter { $0.title.range(of: search, options: .caseInsensitive) != nil || $0.userName.range(of: search, options: .caseInsensitive) != nil }
            }
            .sink(receiveValue: { [weak self] model in
                self?.filteredData = model
            })
            .store(in: &cancellable)
    }
    
    private func setupDataStatus() {
        $filteredData
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] result in
                    guard let newData = result, case .loaded(_) = self?.dataStatus else { return }
                    self?.dataStatus = .loaded(data: newData)
                })
            .store(in: &cancellable)
    }
}
