//
//  ColourLoversDetails.swift
//  swift-learning
//
//  Created by Filip Cybuch on 11/07/2022.
//

import SwiftUI

struct ColourLoversDetails: View {
    
    @State var viewModel: ColourLoversDetailsViewModel
    
    var body: some View {
            VStack(alignment: .center, spacing: 0) {
                List {
                    Section {
                        HStack(alignment: .center, spacing: 0) {
                            ForEach(viewModel.colors, id: \.hashValue) { color in
                                Rectangle()
                                    .fill()
                                    .foregroundColor(color)
                                    .frame(height: 150.0, alignment: .center)
                            }
                        }
                        .cornerRadius(Constants.defaultCornerRadius)
                        .listRowInsets(EdgeInsets())
                    } header: {
                        Text("Preview")
                    }
                    Section {
                        Cell(viewModel: CellViewModel(title: "User name", subtitle: viewModel.userName, rightColors: nil))
                        Cell(viewModel: CellViewModel(title: "Number of views", subtitle: String(viewModel.numberOfViews), rightColors: nil))
                        if let url = viewModel.url {
                            HStack {
                                Spacer()
                                Link(destination: url, label: { Text("Check on website") })
                                    .padding(8)
                                Spacer()
                            }
                        }
                    } header: {
                        Text("Info")
                    }
                }
                Spacer()
            }
            .navigationTitle(viewModel.title)
            .background(Color(.backgroundColor))
    }
}

struct ColourLoversDetails_Previews: PreviewProvider {
    static var previews: some View {
        ColourLoversDetails(viewModel: ColourLoversDetailsViewModel(title: "Colorek", userName: "TrustMe", colors: [.blue], url: nil, numberOfViews: 10))
        
        ColourLoversDetails(viewModel: ColourLoversDetailsViewModel(title: "Paletka", userName: "TrustMe", colors: [.blue, .black], url: URL(string: "google.com")!, numberOfViews: 2000))
            .preferredColorScheme(.dark)
        
        ColourLoversDetails(viewModel: ColourLoversDetailsViewModel(title: "Paletka2", userName: "TrustMe", colors: [.blue, .black, .red], url: nil, numberOfViews: 10000))
    }
}
