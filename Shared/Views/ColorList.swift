//
//  ColorList.swift
//  swift-learning
//
//  Created by Filip Cybuch on 07/07/2022.
//

import SwiftUI
import Combine

struct ListColor {
    let id: Int
    let title, userName: String
    let rgb: ColorModel.RGB
}

class ColorListViewModel: ObservableObject {
    
    @Published var colors: [ListColor] = []
    @Published var search: String = ""
    @Published private var model: [ListColor]?
    private var cancellable: Set<AnyCancellable> = []
    private let networkController: ColourLoversRepository
    
    init(nController: ColourLoversRepository = DIManager.shared.colourLoversController) {
        self.networkController = nController
        setupSearch()
    }
    
    func onAppear() {
        fetchData()
    }
    
    func onRefreshButtonTap() {
        fetchData()
    }
    
    private func setupSearch() {
        $search
            .combineLatest($model)
            .map { (search, model) in
                guard !search.isEmpty else { return model }
                return model?.filter { $0.title.contains(search) }
            }
            .sink(receiveValue: { [weak self] in
                self?.colors = $0 ?? []
            })
            .store(in: &cancellable)
    }
    
    private func fetchData() {
        networkController.getColorsCombine()
            .map { models in
                models.map {
                    ListColor(id: $0.id, title: $0.title, userName: $0.userName, rgb: $0.rgb)
                }
            }
            .sink(receiveCompletion: { completion in
                print("\(#function): \(completion)")
            }, receiveValue: { [weak self] model in
                print("New Value!")
                self?.model = model
                
            })
            .store(in: &cancellable)
    }
}

struct ColorList: View {
    
    private let networkController = DIManager.shared.colourLoversController
    @ObservedObject private var viewModel: ColorListViewModel
    
    init(viewModel: ColorListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            createView(baseOn: viewModel.colors)
                .frame(minWidth: 300)
        }
        .navigationTitle("ColourLovers")
    }
}


// MARK: View builders
extension ColorList {
    @ViewBuilder
    private func createView(baseOn model: [ListColor]) -> some View {
        VStack {
            TextField("Search", text: $viewModel.search)
            if model.isEmpty {
                createInfoView()
            } else {
                List {
                    createColorCells(model: model)
                }
                .listStyle(.inset)
            }
        }
    }
    
    private func createColorCells(model: [ListColor]) -> some View {
        ForEach(model, id: \.id) { colorModel in
            NavigationLink(destination: { ColorDetails(viewModel: colorModel)}) {
                Cell(viewModel: CellViewModel(title: colorModel.title, subtitle: colorModel.userName, rightColor: colorModel.color))
            }
        }
    }
    
    private func createInfoView() -> some View {
        VStack(alignment: .center) {
            Spacer()
            Text("There are no colours to show!")
            Button("Refresh list") {
                viewModel.onRefreshButtonTap()
            }
            Spacer()
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
}

//struct ColorList_Previews: PreviewProvider {
//    static var previews: some View {
//        ColorList(presenter: )
//    }
//}
