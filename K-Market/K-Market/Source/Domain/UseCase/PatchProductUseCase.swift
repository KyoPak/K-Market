//
//  PatchProductUseCase.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/19.
//

import Foundation

protocol PatchProductUseCase {
    func patchData(
        id: Int,
        _ data: PostProduct,
        completion: @escaping (Result<Bool, NetworkError>) -> Void)
}

final class DefaultPatchProductUseCase {
    private let productRepository: ProductRepository
    
    init(productRepository: ProductRepository) {
        self.productRepository = productRepository
    }
}

extension DefaultPatchProductUseCase: PatchProductUseCase {
    func patchData(
        id: Int,
        _ data: PostProduct,
        completion: @escaping (Result<Bool, NetworkError>) -> Void
    ) {
        let request = EditPatchRequest(id: id, postData: data)
        
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
