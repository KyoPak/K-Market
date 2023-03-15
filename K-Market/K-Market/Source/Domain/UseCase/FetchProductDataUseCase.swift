//
//  FetchProductUseCase.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/11.
//

import Foundation

protocol FetchProductUseCase {
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
    
    private func convert(data: Data) throws -> [Product] {
        let decodeManager = DecodeManager<ProductPage>()
        let products = decodeManager.decode(data)
        
        switch products {
        case .success(let productList):
            return productList.pages
        case .failure(let error):
            throw error
        }
    }
}

extension DefaultFetchProductUseCase: FetchProductUseCase {
    func fetchData(
        pageNo: Int,
        itemsPerPage: Int,
        completion: @escaping (Result<[Product], NetworkError>) -> Void
    ) {
        let request = ListFetchRequest(pageNo: pageNo, itemsPerPage: itemsPerPage)
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
