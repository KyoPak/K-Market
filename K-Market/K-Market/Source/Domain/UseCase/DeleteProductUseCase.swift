//
//  DeleteProductUseCase.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/20.
//

import Foundation

protocol DeleteProductUseCase {
    func deleteData(id: Int, completion: @escaping (Result<Bool, NetworkError>) -> Void)
}

final class DefaultDeleteProductUseCase {
    private let productRepository: ProductRepository
    
    init(productRepository: ProductRepository) {
        self.productRepository = productRepository
    }
    
    private func fetchDeleteURI(id: Int, completion: @escaping (Result<String, NetworkError>) -> Void) {
        let request = DeleteURIRequest(id: id)
        
        productRepository.request(customRequest: request) { result in
            switch result {
            case .success(let data):
                guard let deleteURI = String(data: data, encoding: .utf8) else {
                    completion(.failure(.networking))
                    return
                }
                completion(.success(deleteURI))
            case .failure(_):
                completion(.failure(.networking))
            }
        }
    }
}

extension DefaultDeleteProductUseCase: DeleteProductUseCase {
    func deleteData(id: Int, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        fetchDeleteURI(id: id) { result in
            let request: CustomRequest
            
            switch result {
            case .success(let uri):
                request = DeleteDataRequest(uri: uri)
            case .failure(let error):
                completion(.failure(error))
                return
            }
            
            self.productRepository.request(customRequest: request) { result in
                switch result {
                case .success(_):
                    completion(.success(true))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
