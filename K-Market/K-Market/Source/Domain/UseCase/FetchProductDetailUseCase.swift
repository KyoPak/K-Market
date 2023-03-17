//
//  FetchProductDetailUseCase.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/17.
//

import Foundation

protocol FetchProductDetailUseCase {
    func fetchData(id: Int, completion: @escaping (Result<Product, NetworkError>) -> Void)
}

final class DefaultFetchProductDetailUseCase {
    private let productRepository: ProductRepository
    
    init(productRepository: ProductRepository) {
        self.productRepository = productRepository
    }
    
    private func convert(data: Data) throws -> Product {
        let decodeManager = DecodeManager<Product>()
        let product = decodeManager.decode(data)
        
        switch product {
        case .success(let data):
            return data
        case .failure(let error):
            throw error
        }
    }
}

extension DefaultFetchProductDetailUseCase: FetchProductDetailUseCase {
    func fetchData(id: Int, completion: @escaping (Result<Product, NetworkError>) -> Void) {
        let request = DetailFetchRequest(id: id)
        productRepository.request(customRequest: request) { result in
            switch result {
            case .success(let data):
                do {
                    let products = try self.convert(data: data)
                    completion(.success(products))
                } catch {
                    guard let error = error as? NetworkError else { return }
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
