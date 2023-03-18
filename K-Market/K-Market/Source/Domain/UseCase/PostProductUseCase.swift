//
//  PostProductUseCase.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/18.
//

import Foundation

protocol PostProductUseCase {
    func postData(postData: PostProduct, imageDatas: [Data], completion: @escaping (Result<Bool, NetworkError>) -> Void)
}

final class DefaultPostProductUseCase {
    private let productRepository: ProductRepository
    
    init(productRepository: ProductRepository) {
        self.productRepository = productRepository
    }
    
    private func convert(data: Product) throws -> PostProduct {
        let postData = PostProduct(
            name: data.name,
            productID: nil,
            description: data.description ?? "",
            currency: data.currency == .KRW ? .KRW : .USD,
            price: Double(data.price)
        )
        
        return postData
    }
}

extension DefaultPostProductUseCase: PostProductUseCase {
    func postData(postData: PostProduct, imageDatas: [Data], completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        
        let request = PostDataRequest(postData: postData, imagesDatas: imageDatas)
        
        productRepository.request(customRequest: request) { result in
            switch result {
            case .success(_):
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
