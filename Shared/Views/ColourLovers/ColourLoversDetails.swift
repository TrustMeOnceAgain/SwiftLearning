//
//  ColourLoversDetails.swift
//  swift-learning
//
//  Created by Filip Cybuch on 11/07/2022.
//

import SwiftUI

struct ColourLoversDetails: View {
    
    @State var viewModel: ColourLoversDetailsViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        contentView
    }
}

// MARK: ViewBuilders
extension ColourLoversDetails {
    private var contentView: some View {
        VStack(alignment: .center, spacing: 0) {
            #if os(macOS)
            headerView
            #endif
            detailsView
            Spacer()
        }
        .navigationTitle(viewModel.title)
        .background(Color(.backgroundColor))
    }
    
    private var detailsView: some View {
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
    }
}

#if os(macOS)
extension ColourLoversDetails {
    private var headerView: some View {
        ZStack {
            Text(viewModel.title)
            HStack {
                Spacer()
                CustomButtonView(text: nil,
                                 imageString: "xmark",
                                 action: { presentationMode.wrappedValue.dismiss() })
                .padding(5)
            }
        }
    }
}
#endif

struct ColourLoversDetails_Previews: PreviewProvider {
    static var previews: some View {
        ColourLoversDetails(viewModel: ColourLoversDetailsViewModel(title: "Colorek", userName: "TrustMe", colors: [.blue], url: nil, numberOfViews: 10))
        
        ColourLoversDetails(viewModel: ColourLoversDetailsViewModel(title: "Paletka", userName: "TrustMe", colors: [.blue, .black], url: URL(string: "google.com")!, numberOfViews: 2000))
            .preferredColorScheme(.dark)
        
        ColourLoversDetails(viewModel: ColourLoversDetailsViewModel(title: "Paletka2", userName: "TrustMe", colors: [.blue, .black, .red], url: nil, numberOfViews: 10000))
    }
}
