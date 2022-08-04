//
//  InfoView.swift
//  swift-learning
//
//  Created by Filip Cybuch on 20/07/2022.
//

import SwiftUI

struct InfoView: View {
    
    let text: String
    let backgroundColor: Color
    let onAppearAction: (() -> ())?
    
    init(text: String, backgroundColor: Color = Color(.backgroundColor), onAppearAction: (() -> ())?) {
        self.text = text
        self.backgroundColor = backgroundColor
        self.onAppearAction = onAppearAction
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Text(text)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(backgroundColor)
        .onAppear {
            onAppearAction?()
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(ColorScheme.allCases, id: \.hashValue) { colorScheme in
                InfoView(text: "Info view text",
                         backgroundColor: Color(.backgroundColor),
                         onAppearAction: nil)
                    .preferredColorScheme(colorScheme)
            }
        }
        .previewLayout(.sizeThatFits)
    }
}
