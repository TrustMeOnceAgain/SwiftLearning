//
//  ColourLoversList.swift
//  swift-learning
//
//  Created by Filip Cybuch on 18/07/2022.
//

import SwiftUI
import Combine

struct ColourLoversList: View {
    
    private var viewModel: [ColoursLoversListPosition] = ColoursLoversListPosition.allCases
    
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
extension ColourLoversList {
    @ViewBuilder
    private func createView() -> some View {
        VStack {
            List(viewModel, id: \.rawValue) { position in
                NavigationLink(destination: { destination(position: position)}) {
                    Cell(viewModel: CellViewModel(title: position.rawValue, subtitle: nil, rightColor: nil))
                    }
                }
        }
    }
    
    @ViewBuilder
    private func destination(position: ColoursLoversListPosition) -> some View {
        switch position {
        case .colors:
            ColorList(viewModel: ColorListViewModel())
        case .palettes:
            PaletteList()
        }
    }
}

struct ColourLoversList_Previews: PreviewProvider {
    static var previews: some View {
        ColourLoversList()
    }
}
