//
//  ColourLoversInteractor.swift
//  swift-learning
//
//  Created by Filip Cybuch on 07/07/2022.
//

import Combine
import Foundation
import SwiftUI

//protocol CountriesInteractor {
//    func refreshCountriesList() -> AnyPublisher<Void, Error>
//    func load(colors: Subject<List<ColorModel>>)
//}
//
//struct RealCountriesInteractor: CountriesInteractor {
//    
//    let webRepository: ColourLoverRepository
//    
//    init(webRepository: ColourLoverRepository) {
//        self.webRepository = webRepository
//    }
//
//    func load(colors: Subject<List<ColorModel>>) {
//        
//        let cancelBag = CancelBag()
//        countries.wrappedValue.setIsLoading(cancelBag: cancelBag)
//        
//        Just<Void>
//            .withErrorType(Error.self)
//            .flatMap { [dbRepository] _ -> AnyPublisher<Bool, Error> in
//                dbRepository.hasLoadedCountries()
//            }
//            .flatMap { hasLoaded -> AnyPublisher<Void, Error> in
//                if hasLoaded {
//                    return Just<Void>.withErrorType(Error.self)
//                } else {
//                    return self.refreshCountriesList()
//                }
//            }
//            .flatMap { [dbRepository] in
//                dbRepository.countries(search: search, locale: locale)
//            }
//            .sinkToLoadable { countries.wrappedValue = $0 }
//            .store(in: cancelBag)
//    }
//    
//    func refreshCountriesList() -> AnyPublisher<Void, Error> {
//        return webRepository
//            .loadCountries()
//            .ensureTimeSpan(requestHoldBackTimeInterval)
//            .flatMap { [dbRepository] in
//                dbRepository.store(countries: $0)
//            }
//            .eraseToAnyPublisher()
//    }
//}
