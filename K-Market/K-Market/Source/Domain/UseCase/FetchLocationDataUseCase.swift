//
//  FetchLocationDataUseCase.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/11.
//

import Foundation

protocol FetchLocationDataUseCase {
    func fetch(id: Int, completion: @escaping (LocationData?) -> Void)
}

final class DefaultFetchLocationDataUseCase {
    private let locationRepository: LocationRepository
    
    init(locationRepository: LocationRepository) {
        self.locationRepository = locationRepository
    }
}

extension DefaultFetchLocationDataUseCase: FetchLocationDataUseCase {
    func fetch(id: Int, completion: @escaping (LocationData?) -> Void) {
        locationRepository.load(id) { data in
            completion(data)
        }
    }
}
