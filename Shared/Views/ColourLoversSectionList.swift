//
//  ColourLoversList.swift
//  swift-learning
//
//  Created by Filip Cybuch on 18/07/2022.
//

import SwiftUI
import Combine

struct ColourLoversSectionList: View {
    
    let coloursLoverRepository: ColourLoversRepository
    private var viewModel: [ColoursLoversListPosition] = ColoursLoversListPosition.allCases
    
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
            List(viewModel, id: \.rawValue) { position in
                NavigationLink(destination: { destination(position: position)}) {
                    Cell(viewModel: CellViewModel(title: position.rawValue, subtitle: nil, rightColors: nil))
                }
            }
        }
    }
    
    @ViewBuilder
    private func destination(position: ColoursLoversListPosition) -> some View {
        switch position {
        case .colors:
            ColourLoversListView<ColorModel>(viewModel: ColourLoversListViewModel(repository: coloursLoverRepository))
        case .palettes:
            ColourLoversListView<Palette>(viewModel: ColourLoversListViewModel(repository: coloursLoverRepository))
        }
    }
}

//struct ColourLoversList_Previews: PreviewProvider {
//    static var previews: some View {
//        ColourLoversList()
//    }
//}
