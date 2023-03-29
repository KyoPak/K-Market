//
//  NetworkService.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/09.
//

import Foundation

protocol NetworkSevice {
    func request(_ request: URLRequest?, completion: @escaping (Result<Data, NetworkError>) -> Void)
}

final class DefaultNetworkSevice: NetworkSevice {
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func request(_ request: URLRequest?, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        let sesseion = URLSession(configuration: .default)
        
        guard let request = request else { return }
        
        sesseion.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(.networking))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200..<300).contains(response.statusCode) else {
                completion(.failure(.networking))
                return
            }
            
            guard let data = data else {
                completion(.failure(.data))
                return
            }
            
            completion(.success(data))

        }.resume()
    }
}
