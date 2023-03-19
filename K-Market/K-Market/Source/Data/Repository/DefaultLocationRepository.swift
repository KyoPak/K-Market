//
//  DefaultLocationRepository.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/11.
//

import Foundation

final class DefaultLocationRepository: LocationRepository {
    private let service: FireBaseService
    
    init(service: FireBaseService) {
        self.service = service
    }
    
    func load(_ id: Int, completion: @escaping (LocationData?) -> Void) {
        service.load(id) { datas in
            if datas.count == .zero {
                completion(nil)
            } else {
                completion(datas.first)
            }
        }
    }
    
    func add(data: LocationData) {
        service.add(data: data)
    }
    
    func update(data: LocationData) {
        service.update(data: data)
    }
    
    func delete(_ id: Int) {
        service.delete(id: id)
    }
}
