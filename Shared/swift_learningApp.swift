//
//  swift_learningApp.swift
//  Shared
//
//  Created by Filip Cybuch on 07/07/2022.
//

import SwiftUI

@main
struct swift_learningApp: App {

    init() {
        #if os(iOS)
        UITableView.appearance().backgroundColor = .clear
        #endif
        // Change to use mock data insetad of a real one
        DIManager.shared.appEnvironment = .realData
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                MainSectionList()
            }
            #if os(macOS)
            .navigationViewStyle(.columns)
            #else
            .navigationViewStyle(.stack)
            #endif
        }
    }
}
