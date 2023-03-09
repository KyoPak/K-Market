//
//  NetworkRequest.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/09.
//

import Foundation

protocol NetworkRequest {
    var baseURL: String { get }
    
    var path: String { get }
    var query: [URLQueryItem] { get }
    var httpMethod: HttpMethod { get }
}

extension NetworkRequest {
    var baseURL: String {
        return "https://openmarket.yagom-academy.kr"
    }
    
    func createURL() -> URL? {
        var host = URLComponents(string: baseURL)
        
        host?.path = path
        host?.queryItems = query
        
        return host?.url
    }
    
    func createRequest(url: URL) -> URLRequest? {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        return request
    }
}
