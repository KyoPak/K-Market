//
//  CustomRequest.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/09.
//

import Foundation

protocol CustomRequest {
    var baseURL: String? { get }
    var path: String? { get }
    var query: [URLQueryItem]? { get }
    var httpMethod: HTTPMethod { get }
    var url: URL? { get }
    
    func createRequest() -> URLRequest?
    func createRequest(data: PostProduct, imageDatas: [Data?]) -> URLRequest?
}

extension CustomRequest {
    var baseURL: String? {
        return "https://openmarket.yagom-academy.kr"
    }
    
    var url : URL? {
        return URLComponents.createURL(baseURL: baseURL, path: path, queryItem: query)
    }
    
    func createRequest() -> URLRequest? {
        guard let url = url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        return request
    }
    
    func createRequest(data: PostProduct, imageDatas: [Data?]) -> URLRequest? {
        guard let url = url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        return request
    }
}
