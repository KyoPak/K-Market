//
//  PostLocationUseCase.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/18.
//

import Foundation

protocol PostLocationUseCase {
    func add(id: Int, locale: String, subLocale: String)
}

final class DefaultPostLocationUseCase {
    private let locationRepository: LocationRepository
    
    init(locationRepository: LocationRepository) {
        self.locationRepository = locationRepository
    }
}

extension DefaultPostLocationUseCase: PostLocationUseCase {
    func add(id: Int, locale: String, subLocale: String) {
        let data = LocationData(id: id, locality: locale, subLocality: subLocale)
        locationRepository.add(data: data)
    }
}

