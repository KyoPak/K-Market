//
//  DeleteLocationUseCase.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/20.
//

import Foundation

protocol DeleteLocationUseCase {
    func delete(id: Int)
}

final class DefaultDeleteLocationUseCase {
    private let locationRepository: LocationRepository
    
    init(locationRepository: LocationRepository) {
        self.locationRepository = locationRepository
    }
}

extension DefaultDeleteLocationUseCase: DeleteLocationUseCase {
    func delete(id: Int) {
        locationRepository.delete(id)
    }
}
