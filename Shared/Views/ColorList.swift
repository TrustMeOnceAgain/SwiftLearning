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
    
    init(model: [ColorModel] = []) {
        self.model = model
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [Constants.defaultGridItem], alignment: .center) {
                ForEach(model, id: \.id) { colorModel in
                    ColorTile(viewModel: colorModel)
                }
            }
            .frame(maxWidth: .infinity, minHeight: Constants.defaultTileSize,
                   alignment: .center)
            .onAppear {
                
                let baseURL = URL(string: "https://www.colourlovers.com/api/colors")!
                var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!
                let queryItems = [URLQueryItem(name: "format", value: "json")]
                urlComponents.queryItems = queryItems
                
                cancellable = URLSession.shared.dataTaskPublisher(for: urlComponents.url!)
                    .map { print($0.data); return $0.data }
                    .decode(type: [ColorModel].self, decoder: JSONDecoder())
                    .replaceError(with: [])
                    .eraseToAnyPublisher()
                    .sink(receiveValue: { colorModels in
                        self.model = colorModels
                    })
            }
        }
    }
}

struct ColorList_Previews: PreviewProvider {
    static var previews: some View {
        ColorList(model: [ColorModel(id: 123, title: "Colorek", userName: "TrustMe", rgb: ColorModel.RGB(red: 200, green: 40, blue: 50))])
    }
}
