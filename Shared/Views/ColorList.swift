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
    private let networkController = RealNetworkController<[ColorModel]>()
    
    init(model: [ColorModel] = []) {
        self.model = model
    }
    
    var body: some View {
        ScrollView {
            createView(baseOn: model)
        }
    }
    
    private func refreshModel() { // TODO: request should be somewhere else
        let request = GetColorsRequest()
        Task {
            do {
                self.model = try await networkController.sendRequest(request)
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
        LazyVGrid(columns: [Constants.defaultGridItem], alignment: .center) {
            ForEach(model, id: \.id) { colorModel in
                ColorTile(viewModel: colorModel)
            }
        }
        .frame(maxWidth: .infinity, minHeight: Constants.defaultTileSize,
               alignment: .center)
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
