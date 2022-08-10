//
//  SearchView.swift
//  SwiftLearning (iOS)
//
//  Created by Filip Cybuch on 20/07/2022.
//

import SwiftUI

struct SearchView: View {
    
    @Binding var search: String
    
    var body: some View {
        TextField("Search", text: $search)
            .disableAutocorrection(true)
        #if os(iOS)
            .textInputAutocapitalization(.never)
        #endif
            .padding([.leading, .trailing], 15)
            .padding([.top, .bottom], 5)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(ColorScheme.allCases, id: \.hashValue) { colorScheme in
                Group {
                    SearchView(search: .constant("entered text"))
                    SearchView(search: .constant(""))
                }
                .preferredColorScheme(colorScheme)
            }
        }
        .previewLayout(.sizeThatFits)
    }
}
