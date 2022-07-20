//
//  ColorTile.swift
//  swift-learning
//
//  Created by Filip Cybuch on 07/07/2022.
//

import SwiftUI

struct ColorTile: View {
    
    let viewModel: ListColor
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill()
            .foregroundColor(viewModel.color)
            .frame(width: Constants.defaultTileSize, height: Constants.defaultTileSize, alignment: .center)
            .overlay(getView(for: viewModel))
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(.black, lineWidth: 2)
            )
    }
    
    @ViewBuilder
    private func getView(for model: ListColor) -> some View {
        VStack {
            HStack {
                Text(model.userName)
                    .foregroundColor(Color(.mainLabel))
            }
            HStack {
                Text(model.title)
                    .foregroundColor(Color(.secondaryLabel))
            }
        }
    }
}

private extension ListColor { // TODO: move
    var color: Color {
        Color(.sRGB, red: Double(rgb.red)/255, green: Double(rgb.green)/255, blue: Double(rgb.blue)/255, opacity: 1.0)
    }
}
