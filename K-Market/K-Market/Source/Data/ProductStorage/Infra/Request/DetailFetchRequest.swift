//
//  DetailFetchRequest.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/18.
//

import Foundation

struct DetailFetchRequest: CustomRequest {
    var path: String?
    var query: [URLQueryItem]?
    var httpMethod: HTTPMethod = .GET
    
    init(id: Int) {
        self.path = "/api/products/\(id)"
    }
}
