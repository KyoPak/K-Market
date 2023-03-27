//
//  FetchProductListUseCase.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/11.
//

import Foundation

protocol FetchProductListUseCase {
    func fetchData(
        pageNo: Int,
        itemsPerPage: Int,
        completion: @escaping (Result<[Product], NetworkError>) -> Void
    )
}

final class DefaultFetchProductUseCase {
    private let productRepository: ProductRepository
    
    init(productRepository: ProductRepository) {
        self.productRepository = productRepository
    }
}

extension DefaultFetchProductUseCase: FetchProductListUseCase, Fetchable {
    typealias T = ProductPage
    
    func fetchData(
        pageNo: Int,
        itemsPerPage: Int,
        completion: @escaping (Result<[Product], NetworkError>) -> Void
    ) {
        let request = FetchListRequest(pageNo: pageNo, itemsPerPage: itemsPerPage)
        
        productRepository.request(customRequest: request) { result in
            switch result {
            case .success(let data):
                do {
                    let product = try self.convert(data: data) as T
                    completion(.success(product.pages))
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
