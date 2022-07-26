//
//  ColourLoversListView.swift
//  swift-learning
//
//  Created by Filip Cybuch on 19/07/2022.
//

import SwiftUI
import Combine

struct ColourLoversListView<ModelType: Identifiable & ColourLoversModel>: View {
    
    @ObservedObject private var viewModel: ColourLoversListViewModel<ModelType>
    #if os(macOS)
    @State private var selectedItem: ModelType?
    #endif
    
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
        #if os(macOS)
        .sheet(item: $selectedItem, onDismiss: { selectedItem = nil }, content: { model in
            ColourLoversDetails(viewModel: ColourLoversDetailsViewModel(title: model.title, userName: model.userName, colors: model.colors, url: model.webUrl, numberOfViews: model.numberOfViews))
                .frame(minWidth: 720, minHeight: 480, alignment: .center)
        })
        #endif
    }
    
    private func loadedView(model: [ModelType]) -> some View {
        #if os(iOS)
        List(model, id: \.id) { model in
            NavigationLink(destination: { ColourLoversDetails(viewModel: ColourLoversDetailsViewModel(title: model.title, userName: model.userName, colors: model.colors, url: model.webUrl, numberOfViews: model.numberOfViews))}) {
                Cell(viewModel: CellViewModel(title: model.title, subtitle: model.userName, rightColors: model.colors))
            }
        }
        #elseif os(macOS)
        List(model, id: \.id) { model in
            Cell(viewModel: CellViewModel(title: model.title, subtitle: model.userName, rightColors: model.colors))
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedItem = model
                }
        }
        #endif
    }
}
