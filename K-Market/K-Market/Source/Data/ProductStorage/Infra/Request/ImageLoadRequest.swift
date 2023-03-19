//
//  ImageLoadRequest.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/18.
//

import Foundation

struct ImageLoadRequest: CustomRequest {
    var path: String?
    var query: [URLQueryItem]?
    var httpMethod: HTTPMethod = .GET
    var baseURL: String?
    
    init(thumbnail: String) {
        baseURL = thumbnail
    }
}
