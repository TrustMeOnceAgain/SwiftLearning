//
//  ColorList.swift
//  swift-learning
//
//  Created by Filip Cybuch on 07/07/2022.
//

import SwiftUI
import Combine

struct ColorList: View {
    
    @ObservedObject private var viewModel: ColorListViewModel
    
    init(viewModel: ColorListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        createView()
        #if os(macOS)
            .frame(minWidth: 300)
        #endif
            .background(Color(.backgroundColor))
            .navigationTitle("Colors")
    }
}


// MARK: View builders
extension ColorList {
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
            
            if viewModel.colors.isEmpty {
                InfoView(onAppearAction: { if viewModel.search == "" { viewModel.onAppear() } },
                         onButtonTapAction: { viewModel.onRefreshButtonTap() })
            } else {
                List(viewModel.colors, id: \.id) { colorModel in
                    NavigationLink(destination: { ColorDetails(viewModel: ListDetailsViewModel(title: colorModel.title, userName: colorModel.userName, colors: [colorModel.color]))}) {
                        Cell(viewModel: CellViewModel(title: colorModel.title, subtitle: colorModel.userName, rightColors: [colorModel.color]))
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
