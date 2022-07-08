//
//  AppEnvironment.swift
//  swift-learning
//
//  Created by Filip Cybuch on 07/07/2022.
//

import Combine

//struct AppEnvironment {
//    let container: DIContainer
//}
//
//extension AppEnvironment {
//    
//    static func bootstrap() -> AppEnvironment {
//        let session = configuredURLSession()
//        let webRepositories = configuredWebRepositories(session: session)
//        let interactors = configuredInteractors(appState: appState,
//                                                webRepositories: webRepositories)
//        let diContainer = DIContainer(interactors: interactors)
//        return AppEnvironment(container: diContainer)
//    }
//    
//    private static func configuredURLSession() -> URLSession {
//        let configuration = URLSessionConfiguration.default
//        configuration.timeoutIntervalForRequest = 60
//        configuration.timeoutIntervalForResource = 120
//        configuration.waitsForConnectivity = true
//        configuration.httpMaximumConnectionsPerHost = 5
//        configuration.requestCachePolicy = .returnCacheDataElseLoad
//        configuration.urlCache = .shared
//        return URLSession(configuration: configuration)
//    }
//    
//    private static func configuredWebRepositories(session: URLSession) -> DIContainer.WebRepositories {
//        let colorRepository = RealColourLoversRepository(
//            session: session,
//            baseURL: "http://www.colourlovers.com")
//        return .init(colorRepository: colorRepository)
//    }
//    
//    private static func configuredInteractors(webRepositories: DIContainer.WebRepositories) -> DIContainer.Interactors {
//        
//        let colorInteractor = RealColourLoversInteractor(webRepository: webRepositories.colorRepository)
//        
//        return .init(colorInteractor: colorInteractor)
//    }
//}
//
//extension DIContainer {
//    struct WebRepositories {
//        let colorRepository: ColourLoverRepository
//    }
//}
