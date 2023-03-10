//
//  NetworkRequest.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/09.
//

import Foundation

protocol NetworkRequest {
    var baseURL: String? { get }
    var path: String? { get }
    var query: [URLQueryItem]? { get }
    var httpMethod: HttpMethod { get }
    var url: URL? { get }
}

extension NetworkRequest {
    var baseURL: String? {
        return "https://openmarket.yagom-academy.kr"
    }
    
    var url : URL? {
        return URLComponents.createURL(path: baseURL ?? "", queryItem: query)
    }
    
    func createRequest() -> URLRequest? {
        guard let url = url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        return request
    }
}
