//
//  swift_learningApp.swift
//  Shared
//
//  Created by Filip Cybuch on 07/07/2022.
//

import SwiftUI

@main
struct swift_learningApp: App {
    let persistenceController = PersistenceController.shared

    init() {
        #if os(iOS)
        UITableView.appearance().backgroundColor = .clear
        #endif
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ColourLoversSectionList()
            }
            #if os(macOS)
            .navigationViewStyle(.columns)
            #else
            .navigationViewStyle(.stack)
            #endif
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
