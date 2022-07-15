//
//  ColorList.swift
//  swift-learning
//
//  Created by Filip Cybuch on 07/07/2022.
//

import SwiftUI
import Combine

struct ColorList: View {
    
    private let networkController = DIManager.shared.colourLoversController
    @ObservedObject private var viewModel: ColorListViewModel
    
    init(viewModel: ColorListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            createView()
            #if os(macOS)
                .frame(minWidth: 300)
            #endif
                .background(Color(.backgroundColor))
                .navigationTitle("ColourLovers") // TODO: Causes layout errors - check
        }
    }
}


// MARK: View builders
extension ColorList {
    @ViewBuilder
    private func createView() -> some View {
        VStack {
            TextField("Search", text: $viewModel.search)
                .padding([.leading, .trailing], 15)
                .padding([.top, .bottom], 5)
            if viewModel.colors.isEmpty {
                InfoView(onAppearAction: { if viewModel.search == "" { viewModel.onAppear() } },
                         onButtonTapAction: { viewModel.onRefreshButtonTap() })
            } else {
                List(viewModel.colors, id: \.id) { colorModel in
                    NavigationLink(destination: { ColorDetails(viewModel: colorModel)}) {
                        Cell(viewModel: CellViewModel(title: colorModel.title, subtitle: colorModel.userName, rightColor: colorModel.color))
                    }
                }
            }
        }
    }
}

struct InfoView: View {
    
    let onAppearAction: (() -> ())?
    let onButtonTapAction: (() -> ())?
    
    init(onAppearAction: (() -> ())?, onButtonTapAction: (() -> ())?) {
        self.onAppearAction = onAppearAction
        self.onButtonTapAction = onButtonTapAction
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            Text("There are no colours to show!")
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

#if os(macOS)
extension NSTableView { // Workaround for tableView on macOS - maybe not needed at the moment
    open override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        backgroundColor = .clear
    }
}
#endif

//struct ColorList_Previews: PreviewProvider {
//    static var previews: some View {
//        ColorList(presenter: )
//    }
//}
