//
//  ColourLoversList.swift
//  swift-learning
//
//  Created by Filip Cybuch on 18/07/2022.
//

import SwiftUI
import Combine

struct ColourLoversSectionList: View {
    
    enum ColourLoversListType: CaseIterable {
        case colors, palettes
        
        var navigationTitle: String {
            switch self {
            case .colors:
                return "Colors"
            case .palettes:
                return "Palettes"
            }
        }
    }
    
    let coloursLoverRepository: ColourLoversRepository
    private var viewModel: [ColourLoversListType] = ColourLoversListType.allCases
    
    init(coloursLoverRepository: ColourLoversRepository = DIManager.shared.colourLoversRepository) {
        self.coloursLoverRepository = coloursLoverRepository
    }
    
    var body: some View {
            createView()
            #if os(macOS)
                .frame(minWidth: 300)
            #endif
                .background(Color(.backgroundColor))
                .navigationTitle("ColourLovers")
    }
}

// MARK: View builders
extension ColourLoversSectionList {
    @ViewBuilder
    private func createView() -> some View {
        VStack {
            List(viewModel, id: \.navigationTitle) { position in
                NavigationLink(destination: detinationView(for: position)) {
                    Cell(viewModel: CellViewModel(title: position.navigationTitle, subtitle: nil, rightColors: nil))
                }
            }
        }
    }
    
    @ViewBuilder
    private func detinationView(for listType: ColourLoversListType) -> some View {
        switch listType {
        case .colors: ColourLoversListView(viewModel: ColourLoversListViewModel<ColorModel>(repository: coloursLoverRepository))
        case .palettes: ColourLoversListView(viewModel: ColourLoversListViewModel<Palette>(repository: coloursLoverRepository))
        }
    }
}

//struct ColourLoversList_Previews: PreviewProvider {
//    static var previews: some View {
//        ColourLoversList()
//    }
//}
