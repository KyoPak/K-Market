//
//  CacheService.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/21.
//

import Foundation

protocol CacheService {
    func fetch(key: NSString) -> WrapperData?
    func save(key: NSString, wrapperData: WrapperData)
}

final class DefaultCacheService: CacheService {
    private let cache = NSCache<NSString, WrapperData>()
    
    func fetch(key: NSString) -> WrapperData? {
        if let cacheWrapperData = cache.object(forKey: key) {
            return cacheWrapperData
        } else {
            return nil
        }
    }
    
    func save(key: NSString, wrapperData: WrapperData) {
        cache.setObject(wrapperData, forKey: key)
    }
}
