//
//  LoadImageUseCase.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/11.
//

import Foundation

protocol LoadImageUseCase {
    func loadImage(thumbnail: String, completion: @escaping (Result<Data, NetworkError>) -> Void)
}

final class DefaultLoadImageUseCase: LoadImageUseCase {
    private let productRepository: ProductRepository
    
    init(productRepository: ProductRepository) {
        self.productRepository = productRepository
    }
    
    func loadImage(thumbnail: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        let request = ImageLoadRequest(thumbnail: thumbnail)
        
        productRepository.request(customRequest: request) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
