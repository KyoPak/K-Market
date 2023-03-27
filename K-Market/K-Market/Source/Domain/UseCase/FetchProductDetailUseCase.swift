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
}

extension DefaultFetchProductDetailUseCase: FetchProductDetailUseCase, Fetchable {
    typealias T = Product
    
    func fetchData(id: Int, completion: @escaping (Result<Product, NetworkError>) -> Void) {
        let request = FetchDetailRequest(id: id)
        
        productRepository.request(customRequest: request) { result in
            switch result {
            case .success(let data):
                do {
                    let products = try self.convert(data: data) as T
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
