//
//  DefaultProductRepository.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/10.
//

import Foundation

final class DefaultProductRepository: ProductRepository {
    private let networkService: NetworkSevice

    init(networkService: NetworkSevice) {
        self.networkService = networkService
    }
    
    func request(customRequest: CustomRequest, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        let urlRequest = customRequest.createRequest()
        
        networkService.request(urlRequest) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
