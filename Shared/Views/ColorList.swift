//
//  ColorList.swift
//  swift-learning
//
//  Created by Filip Cybuch on 07/07/2022.
//

import SwiftUI
import Combine

struct ColorList: View {
    
    @State var model: [ColorModel]
    @State private var cancellable: AnyCancellable?
    private let networkController = DIManager.shared.colourLoversController
    
    init(model: [ColorModel] = []) {
        self.model = model
    }
    
    var body: some View {
        NavigationView {
            createView(baseOn: model)
        }
        .navigationTitle("ColourLovers")
    }
    
    private func refreshModel() {
        Task {
            do {
                self.model = try await networkController.getColors()
            } catch(let error) {
                print("Error: \(error)")
            }
        }
    }
}


// MARK: View builders
extension ColorList {
    @ViewBuilder
    private func createView(baseOn model: [ColorModel]) -> some View {
        if model.isEmpty {
            createInfoView()
        } else {
            createColorList(model: model)
        }
    }
    
    @ViewBuilder
    private func createColorList(model: [ColorModel]) -> some View {
    #if os(iOS)
        ScrollView {
            LazyVGrid(columns: [Constants.defaultGridItem], alignment: .center) {
                createColorTiles(model: model)
            }
            .frame(maxWidth: .infinity,
                   minHeight: Constants.defaultTileSize,
                   alignment: .center)
        }
    #else
        List {
            createColorTiles(model: model)
        }
    #endif
        
    }
    
    @ViewBuilder
    private func createColorTiles(model: [ColorModel]) -> some View {
        ForEach(model, id: \.id) { colorModel in
            NavigationLink(destination: { ColorDetails(viewModel: colorModel)}) {
                ColorTile(viewModel: colorModel)
            }
        }
    }
    
    @ViewBuilder
    private func createInfoView() -> some View {
        VStack(alignment: .center) {
            Spacer()
            Text("There are no colours to show!")
            Spacer()
        }
        .onAppear() {
            refreshModel()
        }
    }
}

struct ColorList_Previews: PreviewProvider {
    static var previews: some View {
        ColorList(model: [ColorModel(id: 123, title: "Colorek", userName: "TrustMe", rgb: ColorModel.RGB(red: 200, green: 40, blue: 50))])
    }
}
