//
//  RequestByUseCase.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/09.
//

import Foundation

struct ProductListFetchRequest: NetworkRequest {
    var path: String? = "/api/products"
    var query: [URLQueryItem]?
    var httpMethod: HttpMethod = .GET
    
    init(pageNo: Int, itemsPerPage: Int) {
        query = [
            URLQueryItem(name: "page_no", value: String(pageNo)),
            URLQueryItem(name: "items_per_page", value: String(itemsPerPage))
        ]
    }
}

struct ProductDetailFetchRequest: NetworkRequest {
    var path: String?
    var query: [URLQueryItem]?
    var httpMethod: HttpMethod = .GET
    
    init(id: Int) {
        self.path = "/api/products/\(id)"
    }
}

struct ProductImageLoadRequest: NetworkRequest {
    var path: String?
    var query: [URLQueryItem]?
    var httpMethod: HttpMethod = .GET
    var baseURL: String?
    
    init(thumbnail: String) {
        baseURL = thumbnail
    }
}
