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
            VStack {
                HStack {
                    HStack {
                        Text("Color name:")
                            .foregroundColor(Color(.mainLabel))
                        Text(viewModel.title)
                            .foregroundColor(Color(.secondaryLabel))
                    }
                }
                HStack {
                    HStack {
                        Text("User name:")
                            .foregroundColor(Color(.mainLabel))
                        Text(viewModel.userName)
                            .foregroundColor(Color(.secondaryLabel))
                    }
                }
            }
            Spacer()
        }
        .background(Color(.backgroundColor))
    }
}

struct ColorDetails_Previews: PreviewProvider {
    static var previews: some View {
        ColorDetails(viewModel: ListDetailsViewModel(title: "Colorek", userName: "TrustMe", colors: [.blue]))
        
        ColorDetails(viewModel: ListDetailsViewModel(title: "Paletka", userName: "TrustMe", colors: [.blue, .black]))
        
        ColorDetails(viewModel: ListDetailsViewModel(title: "Paletka2", userName: "TrustMe", colors: [.blue, .black, .red]))
    }
}
