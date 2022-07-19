//
//  ColourLoversListView.swift
//  swift-learning
//
//  Created by Filip Cybuch on 19/07/2022.
//

import SwiftUI
import Combine

struct ColourLoversListView<ModelType: ColourLoversModel>: View {
    
    @ObservedObject private var viewModel: ColourLoversListViewModel<ModelType>
    
    private var dataType: DataType {
        switch ModelType.self {
        case is ColorModel.Type: return .colors
        case is Palette.Type: return .palettes
        default: return .unknown
        }
    }
    
    init(viewModel: ColourLoversListViewModel<ModelType>) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        createView()
        #if os(macOS)
            .frame(minWidth: 300)
        #endif
            .background(Color(.backgroundColor))
            .navigationTitle(dataType.navigationTitle)
    }
    
    private enum DataType {
        case colors, palettes, unknown
        
        var navigationTitle: String {
            switch self {
            case .colors: return "Colors"
            case .palettes: return "Palettes"
            case .unknown: return "Unknown"
            }
        }
    }
}

// MARK: View builders
extension ColourLoversListView {
    @ViewBuilder
    private func createView() -> some View {
        VStack {
            TextField("Search", text: $viewModel.search)
                .disableAutocorrection(true)
            #if os(iOS)
                .textInputAutocapitalization(.never)
            #endif
                .padding([.leading, .trailing], 15)
                .padding([.top, .bottom], 5)
            
            if let model = viewModel.model, !model.isEmpty {
                
                List(model, id: \.id) { model in
                    let rightColors: [Color] = {
                        switch model {
                        case let colorModel as ColorModel:
                            return [colorModel.color]
                        case let paletteModel as Palette:
                            return paletteModel.colors
                        default:
                            return []
                        }
                    }()
                    NavigationLink(destination: { ColorDetails(viewModel: ListDetailsViewModel(title: model.title, userName: model.userName, colors: rightColors))}) {
                        Cell(viewModel: CellViewModel(title: model.title, subtitle: model.userName, rightColors: rightColors))
                    }
                }
            } else {
                InfoView(onAppearAction: { if viewModel.search == "" { viewModel.onAppear() } },
                         onButtonTapAction: { viewModel.onRefreshButtonTap() })
            }
        }
    }
}

private struct InfoView: View {
    
    let onAppearAction: (() -> ())?
    let onButtonTapAction: (() -> ())?
    
    init(onAppearAction: (() -> ())?, onButtonTapAction: (() -> ())?) {
        self.onAppearAction = onAppearAction
        self.onButtonTapAction = onButtonTapAction
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            Text("There is data to show!")
            Button("Refresh list") {
                onButtonTapAction?()
            }
            Spacer()
        }
        .onAppear {
            onAppearAction?()
        }
    }
}
