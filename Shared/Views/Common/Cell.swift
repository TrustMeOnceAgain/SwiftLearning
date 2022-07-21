//
//  Cell.swift
//  swift-learning
//
//  Created by Filip Cybuch on 12/07/2022.
//

import SwiftUI

struct Cell: View {
    
    var viewModel: CellViewModel
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text(viewModel.title)
                        .foregroundColor(viewModel.titleColor)
                    Spacer()
                }
                .padding([.leading, .trailing, .top], 8)
                .padding([.bottom], shuldSubtitleBeVisible ? 4 : 8)
                
                if let subtitle = viewModel.subtitle {
                    HStack {
                        Text(subtitle)
                            .foregroundColor(viewModel.subtitleColor)
                        Spacer()
                    }
                    .padding([.leading, .trailing, .bottom], 8)
                }
            }
            if let rightColors = viewModel.rightColors {
                Spacer()
                HStack(alignment: .center, spacing: 0) {
                    ForEach(rightColors, id: \.hashValue) { color in // TODO: There is a possibility of same colors in array
                        Rectangle()
                            .foregroundColor(color)
                    }
                }
                .frame(width: 50, height: 50)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.borderColor), lineWidth: 1.5)
                )
                .padding(8)
            }
        }
        .background(viewModel.backgroundColor)
        .cornerRadius(10)
    }
    
    var shuldSubtitleBeVisible: Bool { viewModel.subtitle != nil }
}

struct CellViewModel {
    let title: String
    let titleColor: Color
    let subtitle: String?
    let subtitleColor: Color
    let backgroundColor: Color
    let rightColors: [Color]?
    
    init(title: String, titleColor: Color = Color(.mainLabel), subtitle: String? = nil, subtitleColor: Color = Color(.secondaryLabel), backgroundColor: Color = .clear, rightColors: [Color]?) {
        self.title = title
        self.titleColor = titleColor
        self.subtitle = subtitle
        self.subtitleColor = subtitleColor
        self.backgroundColor = backgroundColor
        self.rightColors = rightColors
    }
}

struct Cell_Previews: PreviewProvider {
    static var previews: some View {
        Cell(viewModel: CellViewModel(title: "Preview color", subtitle: "User name", backgroundColor: .white, rightColors: [.blue]))
    }
}
