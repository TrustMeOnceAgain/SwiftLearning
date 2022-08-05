//
//  SwiftLearningApp.swift
//  Shared
//
//  Created by Filip Cybuch on 07/07/2022.
//

import SwiftUI

@main
struct SwiftLearningApp: App {

    init() {
        #if os(iOS)
        UITableView.appearance().backgroundColor = .clear
        #endif
        // Change to use mock data instead of a real one
        DIManager.shared.appEnvironment = .realData
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                MainSectionList(coloursLoverRepository: DIManager.shared.colourLoversRepository,
                                weatherRepository: DIManager.shared.weatherRepository)
            }
            #if os(macOS)
            .navigationViewStyle(.columns)
            #else
            .navigationViewStyle(.stack)
            #endif
        }
    }
}
