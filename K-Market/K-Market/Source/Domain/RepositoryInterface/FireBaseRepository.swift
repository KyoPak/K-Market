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
