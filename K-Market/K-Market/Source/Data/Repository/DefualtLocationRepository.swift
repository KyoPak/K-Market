//
//  DefualtLocationRepository.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/11.
//

import Foundation

final class DefualtLocationRepository {
    private let service: FireBaseService
    
    init(service: FireBaseService) {
        self.service = service
    }
    
    func load(completion: @escaping ([LocationData]) -> Void) {
        service.load { datas in
            completion(datas)
        }
    }
    
    func add(data: LocationData) {
        service.add(data: data)
    }
    
    func update(data: LocationData) {
        service.update(data: data)
    }
    
    func delete(data: LocationData) {
        service.delete(id: data.id)
    }
}
