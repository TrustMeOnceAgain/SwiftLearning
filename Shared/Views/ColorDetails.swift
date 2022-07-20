//
//  ColorDetails.swift
//  swift-learning
//
//  Created by Filip Cybuch on 11/07/2022.
//

import SwiftUI

struct ColorDetails: View {
    
    @State var viewModel: ListDetailsViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 0) {
                HStack(alignment: .center, spacing: 0) {
                    ForEach(viewModel.colors, id: \.hashValue) { color in
                        Rectangle()
                            .fill()
                            .foregroundColor(color)
                            .frame(height: 200.0, alignment: .center)
                    }
                }
                Spacer()
                    .frame(height: 20)
                VStack(spacing: 10) {
                        VStack {
                            Text("User name")
                                .foregroundColor(Color(.mainLabel))
                            Text(viewModel.userName)
                                .foregroundColor(Color(.secondaryLabel))
                        }
                    if let url = viewModel.url {
                        HStack {
                            Link(destination: url, label: { Text("Check on website") })
                        }
                    }
                }
                Spacer()
            }
        }
        .navigationTitle(viewModel.title)
        .background(Color(.backgroundColor))
    }
}

struct ColorDetails_Previews: PreviewProvider {
    static var previews: some View {
        ColorDetails(viewModel: ListDetailsViewModel(title: "Colorek", userName: "TrustMe", colors: [.blue], url: nil))
        
        ColorDetails(viewModel: ListDetailsViewModel(title: "Paletka", userName: "TrustMe", colors: [.blue, .black], url: URL(string: "google.com")!))
        
        ColorDetails(viewModel: ListDetailsViewModel(title: "Paletka2", userName: "TrustMe", colors: [.blue, .black, .red], url: nil))
    }
}
