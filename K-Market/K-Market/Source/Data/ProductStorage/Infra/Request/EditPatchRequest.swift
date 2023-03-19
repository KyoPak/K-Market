//
//  EditPatchRequest.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/19.
//

import Foundation

struct EditPatchRequest: CustomRequest {
    var path: String?
    var query: [URLQueryItem]?
    var httpMethod: HTTPMethod = .PATCH
    private let postData: PostProduct
    
    init(id: Int, postData: PostProduct) {
        self.path = "/api/products/\(id)"
        self.postData = postData
    }
    
    func createRequest() -> URLRequest? {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(postData), let url = url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request = .setupIdentifier(request: &request)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        
        return request
    }
}
