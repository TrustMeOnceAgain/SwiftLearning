//
//  DIContainer.swift
//  swift-learning
//
//  Created by Filip Cybuch on 07/07/2022.
//

import SwiftUI
import Combine

// MARK: - DIContainer

//struct DIContainer: EnvironmentKey {
//    
//    let interactors: Interactors
//    
//    init(interactors: Interactors) {
//        self.interactors = interactors
//    }
//    
//    init(interactors: Interactors) {
//        self.init(interactors: interactors)
//    }
//    
//    static var defaultValue: Self { Self.default }
//    
//    private static let `default` = Self(interactors: .stub)
//}
//
//extension EnvironmentValues {
//    var injected: DIContainer {
//        get { self[DIContainer.self] }
//        set { self[DIContainer.self] = newValue }
//    }
//}
//
//#if DEBUG
//extension DIContainer {
//    static var preview: Self {
//        .init(interactors: .stub)
//    }
//}
//#endif
//
//// MARK: - Injection in the view hierarchy
//
//extension View {
//    
//    func inject(_ interactors: DIContainer.Interactors) -> some View {
//        let container = DIContainer(interactors: interactors)
//        return inject(container)
//    }
//    
//    func inject(_ container: DIContainer) -> some View {
//        return self
//            .modifier(RootViewAppearance())
//            .environment(\.injected, container)
//    }
//}
