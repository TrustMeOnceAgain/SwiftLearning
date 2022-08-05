//
//  ColourLoversListView.swift
//  SwiftLearning
//
//  Created by Filip Cybuch on 19/07/2022.
//

import SwiftUI
import Combine

struct ColourLoversListView<ModelType: Identifiable & ColourLoversModel>: View {
    
    @EnvironmentObject private var viewModel: ColourLoversListViewModel<ModelType>
    #if os(macOS)
    @State private var selectedItem: ModelType?
    #endif
    
    var body: some View {
        createView()
        #if os(macOS)
            .frame(minWidth: 300)
        #endif
            .background(Color(.backgroundColor))
            .navigationTitle(viewModel.navigationTitle)
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button("Refresh") {
                        viewModel.onRefreshButtonTap()
                    }
                }
            }
        #if os(iOS)
            .searchable(text: $viewModel.search, placement: .navigationBarDrawer(displayMode: .always))
            .disableAutocorrection(true)
        #elseif os(macOS)
            .searchable(text: $viewModel.search, placement: .toolbar)
        #endif
            
    }
}

// MARK: View builders
extension ColourLoversListView {
    @ViewBuilder
    private func createView() -> some View {
        VStack {
            switch viewModel.dataStatus {
            case .loaded(let model):
                loadedView(model: model)
            case .loading:
                ProgressView()
                    .progressViewStyle(.circular)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            case .notLoaded:
                InfoView(text: "There is no data to show!",
                         onAppearAction: viewModel.onAppear)
            case .error(_):
                InfoView(text: "Error during loading data!",
                         onAppearAction: nil)
            }
        }
        #if os(macOS)
        .sheet(
            item: $selectedItem,
            onDismiss: { selectedItem = nil },
            content: { model in
                detailsView(basedOn: model)
                    .frame(minWidth: 480, minHeight: 480, alignment: .center)
            })
        #endif
    }
    
    private func loadedView(model: [ModelType]) -> some View {
        #if os(iOS)
        List(model, id: \.id) { model in
            NavigationLink(destination: { detailsView(basedOn: model) }) {
                cell(basedOn: model)
            }
        }
        #elseif os(macOS)
        List(model, id: \.id) { model in
            cell(basedOn: model)
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedItem = model
                }
        }
        #endif
    }
    
    private func cell(basedOn model: ColourLoversModel) -> Cell {
        let viewModel = CellViewModel(title: model.title,
                                      subtitle: model.userName,
                                      rightColors: model.colors)
        return Cell(viewModel: viewModel)
    }
    
    private func detailsView(basedOn model: ColourLoversModel) -> ColourLoversDetails {
        let viewModel = ColourLoversDetailsViewModel(title: model.title,
                                                     userName: model.userName,
                                                     colors: model.colors,
                                                     url: model.webUrl,
                                                     numberOfViews: model.numberOfViews)
        return ColourLoversDetails(viewModel: viewModel)
    }
}

struct ColourLoversListView_Previews: PreviewProvider {
    
    private static let viewModel = ColourLoversListViewModel<ColorModel>(repository: RealColourLoversRepository(networkController: MockedNetworkController()))
    
    static var previews: some View {
        Group {
            ForEach(ColorScheme.allCases, id: \.hashValue) { colorScheme in
                #if os(iOS)
                NavigationView {
                    ColourLoversListView<ColorModel>()
                        .environmentObject(viewModel)
                        
                }
                .preferredColorScheme(colorScheme)
                
                #elseif os(macOS)
                ColourLoversListView<ColorModel>()
                    .environmentObject(viewModel)
                    .preferredColorScheme(colorScheme)
                #endif
            }
        }
        .previewLayout(.device)
    }
}
