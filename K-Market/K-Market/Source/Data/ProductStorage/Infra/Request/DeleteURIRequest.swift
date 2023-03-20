//
//  DeleteURIRequest.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/20.
//

import Foundation

struct DeleteURIRequest: CustomRequest {
    var path: String?
    var query: [URLQueryItem]?
    var httpMethod: HTTPMethod = .POST
    
    init(id: Int) {
        path = "/api/products/\(id)/archived"
    }
    
    func createRequest() -> URLRequest? {
        guard let url = url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request = .setupIdentifier(request: &request)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let bodyData = try? JSONSerialization.data(withJSONObject: ["secret": "dk9r294wvfwkgvhn"])
        request.httpBody = bodyData
        
        return request
    }
}
