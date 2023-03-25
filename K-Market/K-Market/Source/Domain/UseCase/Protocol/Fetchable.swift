//
//  Fetchable.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/25.
//

import Foundation

// Use DefaultFetchProductListUseCase, DefaultFetchProductDetailUseCase, DefaultPostProductUseCase

protocol Fetchable {
    associatedtype T
    
    func convert<T: Decodable>(data: Data) throws -> T
}

extension Fetchable {
    func convert<T: Decodable>(data: Data) throws -> T {
        let decodeManager = DecodeManager<T>()
        let decodedData = decodeManager.decode(data)
        
        switch decodedData {
        case .success(let decodedResult):
            return decodedResult
        case .failure(let error):
            throw error
        }
    }
}
