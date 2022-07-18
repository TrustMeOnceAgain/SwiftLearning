//
//  PaletteList.swift
//  swift-learning
//
//  Created by Filip Cybuch on 18/07/2022.
//

import SwiftUI

struct PaletteList: View { // TODO: merge with ColorList
    
    @ObservedObject private var viewModel: PaletteListViewModel
    
    init(viewModel: PaletteListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        createView()
        #if os(macOS)
            .frame(minWidth: 300)
        #endif
            .background(Color(.backgroundColor))
            .navigationTitle("Palettes")
    }
}

// MARK: View builders
extension PaletteList {
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
            
            if viewModel.palettes.isEmpty {
                InfoView(onAppearAction: { if viewModel.search == "" { viewModel.onAppear() } },
                         onButtonTapAction: { viewModel.onRefreshButtonTap() })
            } else {
                List(viewModel.palettes, id: \.id) { model in
                    NavigationLink(destination: { ColorDetails(viewModel: ListDetailsViewModel(title: model.title, userName: model.userName, colors: model.colors))}) {
                        Cell(viewModel: CellViewModel(title: model.title, subtitle: model.userName, rightColors: model.colors))
                    }
                }
            }
        }
    }
}

//struct PaletteList_Previews: PreviewProvider {
//    static var previews: some View {
//        PaletteList()
//    }
//}
