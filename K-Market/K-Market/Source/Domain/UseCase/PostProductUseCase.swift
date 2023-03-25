//
//  PostProductUseCase.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/18.
//

import Foundation

protocol PostProductUseCase {
    func postData(
        _ data: PostProduct,
        imageDatas: [Data],
        completion: @escaping (Result<PostResponse, NetworkError>) -> Void
    )
}

final class DefaultPostProductUseCase {
    private let productRepository: ProductRepository
    
    init(productRepository: ProductRepository) {
        self.productRepository = productRepository
    }
}

extension DefaultPostProductUseCase: PostProductUseCase, Fetchable {
    typealias T = PostResponse
    
    func postData(
        _ data: PostProduct,
        imageDatas: [Data],
        completion: @escaping (Result<PostResponse, NetworkError>) -> Void
    ) {
        let request = PostDataRequest(postData: data, imagesDatas: imageDatas)
        
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
