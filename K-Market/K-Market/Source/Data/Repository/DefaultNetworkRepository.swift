//
//  DefaultNetworkRepository.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/10.
//

import Foundation

final class DefaultNetworkRepository: NetworkRepository {
    enum RequestType {
        case fetch(pageNo: Int, itemsPerPage: Int)
        case fetchDetail(productID: Int)
        case loadImage(thumbnail: String)
    }
    
    private let networkService: NetworkSevice
    
    private var requestType: RequestType
    
    private var urlRequest: URLRequest? {
        switch requestType {
        case .fetch(let pageNo, let itemsPerPage):
            return ListFetchRequest(pageNo: pageNo, itemsPerPage: itemsPerPage).createRequest()
        case .fetchDetail(let productID):
            return DetailFetchRequest(id: productID).createRequest()
        case .loadImage(let thumbnail):
            return ImageLoadRequest(thumbnail: thumbnail).createRequest()
        }
    }
    
    init(requestType: RequestType, networkService: NetworkSevice) {
        self.requestType = requestType
        self.networkService = networkService
    }
    
    func request(completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let urlRequest = urlRequest else { return }
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
