//
//  CustomButtonView.swift
//  swift-learning
//
//  Created by Filip Cybuch on 26/07/2022.
//

import SwiftUI

struct CustomButtonView: View {
    
    let text: String?
    let textColor: Color
    let imageString: String?
    let imageSize: CGFloat
    let backgroundColor: Color
    let identifier: String
    let action: (() -> Void)?
    
    init(text: String?, textColor: Color = Color(.mainLabel), imageString: String? = nil, imageSize: CGFloat = 20.0, backgroundColor: Color = .clear, identifier: String = String(), action: (() -> Void)? = nil) {
        self.text = text
        self.textColor = textColor
        self.imageString = imageString
        self.imageSize = imageSize
        self.backgroundColor = backgroundColor
        self.identifier = identifier
        self.action = action
    }

    var body: some View {
        
        Button(
            action: { action?() },
            label: {
                HStack {
                    if let buttonText = text {
                        Text(buttonText)
                            .foregroundColor(textColor)
                            .padding(.leading, 20)
                            .padding(.trailing, imageString != nil ? 5 : 20)
                            .padding([.top, .bottom], 5)
                    }
                    if let imageName = imageString {
                        Image(systemName: imageName)
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: imageSize, height: imageSize)
                            .padding([.top, .bottom], 10)
                            .padding(.trailing, text != nil ? 20 : 10)
                            .padding([.leading], text != nil ? 0 : 10)
                            .accessibilityIdentifier(identifier)
                    }
                }
                .cornerRadius(Constants.defaultCornerRadius)
            }
        )
        .buttonStyle(CustomButtonStyle(backgroundColor: backgroundColor, justImage: justImage))
    }
    
    private var justImage: Bool { text == nil && imageString != nil }
}

struct CustomButtonStyle: ButtonStyle {

    let backgroundColor: Color
    let justImage: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        return configuration.label
            .background(backgroundColor.opacity(configuration.isPressed ? 0.8 : 1.0))
            .cornerRadius(5)
            .opacity(justImage ? (configuration.isPressed ? 0.8 : 1.0) : 1.0)
            .scaleEffect(justImage ? (configuration.isPressed ? 0.85 : 1.0) : 1.0)
    }
}

struct CustomButtonView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(ColorScheme.allCases, id: \.hashValue) { colorScheme in
                Group {
                    CustomButtonView(text: nil,
                                     imageString: "xmark")
                    CustomButtonView(text: "Test Text",
                                     imageString: nil)
                    CustomButtonView(text: "Test Text",
                                     imageString: "xmark",
                                     imageSize: 15,
                                     backgroundColor: .accentColor)
                }
                .preferredColorScheme(colorScheme)
            }
        }
        .previewLayout(.sizeThatFits)
    }
}
