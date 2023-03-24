//
//  MockLocationRepository.swift
//  K-MarketTests
//
//  Created by parkhyo on 2023/03/24.
//

import Foundation

final class MockLocationRepository: LocationRepository {
    private var locationDatas: [LocationData] = [
        LocationData(id: 1, locality: "test1", subLocality: "test1"),
        LocationData(id: 2, locality: "test2", subLocality: "test2"),
        LocationData(id: 3, locality: "test3", subLocality: "test3"),
        LocationData(id: 4, locality: "test4", subLocality: "test4"),
        LocationData(id: 5, locality: "test5", subLocality: "test5")
    ]
    
    func load(_ id: Int, completion: @escaping (LocationData?) -> Void) {
        let loadData = locationDatas.filter { data in
            if data.id == id {
                return true
            } else {
                return false
            }
        }
        
        completion(loadData.first)
    }
    
    func add(data: LocationData) {
        locationDatas.append(data)
    }
    
    func update(data: LocationData) {
        delete(data.id)
        locationDatas.append(data)
    }
    
    func delete(_ id: Int) {
        var deleteIndex = 0
        for index in 0..<locationDatas.count {
            if locationDatas[index].id == id {
                deleteIndex = index
            }
        }
        
        locationDatas.remove(at: deleteIndex)
    }
}
