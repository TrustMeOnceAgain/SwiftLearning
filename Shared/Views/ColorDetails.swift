//
//  ColorDetails.swift
//  swift-learning
//
//  Created by Filip Cybuch on 11/07/2022.
//

import SwiftUI

struct ColorDetails: View {
    
    @State var viewModel: ColorModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Rectangle()
                .fill()
                .foregroundColor(viewModel.color)
                .frame(height: 200.0, alignment: .center)
            Spacer()
                .frame(height: 20)
            VStack {
                HStack {
                    HStack {
                        Text("Color name:")
                            .foregroundColor(.black)
                        Text(viewModel.title)
                            .foregroundColor(.black)
                    }
                }
                HStack {
                    HStack {
                        Text("User name:")
                            .foregroundColor(.black)
                        Text(viewModel.userName)
                            .foregroundColor(.black)
                    }
                }
            }
            Spacer()
        }
    }
}

struct ColorDetails_Previews: PreviewProvider {
    static var previews: some View {
        ColorDetails(viewModel: ColorModel(id: 123,
                                           title: "Colorek",
                                           userName: "TrustMe",
                                           rgb: ColorModel.RGB(red: 200, green: 40, blue: 50)))
    }
}
