//
//  LocationRepository.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/10.
//

import Foundation

protocol LocationRepository {
    func load(completion: @escaping ([LocationData]) -> Void)
    func add(data: LocationData)
    func update(data: LocationData)
    func delete(data: LocationData)
}
