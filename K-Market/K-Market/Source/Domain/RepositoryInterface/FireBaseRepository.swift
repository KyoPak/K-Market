//
//  FireBaseRepository.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/10.
//

import Foundation

protocol FireBaseRepository {
    func load(completion: @escaping ([LocationData]) -> Void)
    func add(data: LocationData)
    func update()
    func delete(data: LocationData)
}

final class DefualtFireBaseRepository {
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
