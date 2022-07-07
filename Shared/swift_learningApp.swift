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

    var body: some Scene {
        WindowGroup {
            ColorList()
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
