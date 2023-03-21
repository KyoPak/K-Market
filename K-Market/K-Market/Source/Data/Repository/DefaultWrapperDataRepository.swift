//
//  DefaultWrapperDataRepository.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/21.
//

import Foundation

final class DefaultWrapperDataRepository: WrapperDataRepository {
    private let cacheService: CacheService
    
    init(cacheService: CacheService) {
        self.cacheService = cacheService
    }
    
    func fetch(thumbnail: String) -> WrapperData? {
        let cacheKey = NSString(string: thumbnail)
        return cacheService.fetch(key: cacheKey)
    }
    
    func save(thumbnail: String, wrapperData: WrapperData) {
        let cacheKey = NSString(string: thumbnail)
        cacheService.save(key: cacheKey, wrapperData: wrapperData)
    }
}
