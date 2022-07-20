//
//  InfoView.swift
//  swift-learning
//
//  Created by Filip Cybuch on 20/07/2022.
//

import SwiftUI

struct InfoView: View {
    
    let text: String
    let onAppearAction: (() -> ())?
    let onRefreshButtonTapAction: (() -> ())?
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            Text(text)
            if let tapAction = onRefreshButtonTapAction {
                Button("Refresh") {
                    tapAction()
                }
            }
            Spacer()
        }
        .onAppear {
            onAppearAction?()
        }
    }
}
