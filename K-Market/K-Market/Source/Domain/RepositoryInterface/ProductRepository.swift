//
//  ProductRepository.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/10.
//

import Foundation

protocol ProductRepository {
    func request(customRequest: CustomRequest, completion: @escaping (Result<Data, NetworkError>) -> Void)
}
