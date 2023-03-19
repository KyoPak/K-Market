//
//  DeleteDataRequest.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/20.
//

import Foundation

struct DeleteDataRequest: CustomRequest {
    var path: String?
    var query: [URLQueryItem]?
    var httpMethod: HTTPMethod = .DELETE
    
    init(uri: String) {
        path = uri
    }
    
    func createRequest() -> URLRequest? {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request = .setupIdentifier(request: &request)
        
        return request
    }
}
