//
//  LocationRepository.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/10.
//

import Foundation

protocol LocationRepository {
    func load(_ id: Int, completion: @escaping (LocationData?) -> Void)
    func add(data: LocationData)
    func update(data: LocationData)
    func delete(_ id: Int)
}
