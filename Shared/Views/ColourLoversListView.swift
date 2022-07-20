//
//  ColourLoversListView.swift
//  swift-learning
//
//  Created by Filip Cybuch on 19/07/2022.
//

import SwiftUI
import Combine

struct ColourLoversListView<ModelType: ColourLoversModel>: View { // TODO: add links in details for colours and palettes
    
    @ObservedObject private var viewModel: ColourLoversListViewModel<ModelType>
    
    init(viewModel: ColourLoversListViewModel<ModelType>) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        createView()
        #if os(macOS)
            .frame(minWidth: 300)
        #endif
            .background(Color(.backgroundColor))
            .navigationTitle(viewModel.navigationTitle)
    }
}

// MARK: View builders
extension ColourLoversListView {
    @ViewBuilder
    private func createView() -> some View {
        VStack {
            SearchView(search: $viewModel.search)
            if let model = viewModel.model {
                if model.isEmpty {
                    InfoView(text: "There is data to show!", onAppearAction: nil, onRefreshButtonTapAction: nil)
                } else {
                    loadedView(model: model)
                }
            } else {
                InfoView(text: "There is data to show!",
                         onAppearAction: viewModel.onAppear,
                         onRefreshButtonTapAction: viewModel.onRefreshButtonTap)
            }
        }
    }
    
    private func loadedView(model: [ColourLoversModel]) -> some View {
        List(model, id: \.id) { model in
            NavigationLink(destination: { ColorDetails(viewModel: ListDetailsViewModel(title: model.title, userName: model.userName, colors: model.colors, url: model.webUrl))}) {
                Cell(viewModel: CellViewModel(title: model.title, subtitle: model.userName, rightColors: model.colors))
            }
        }
    }
}
