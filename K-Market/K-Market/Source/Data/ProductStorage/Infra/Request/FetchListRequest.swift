//
//  FetchListRequest.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/18.
//

import Foundation

struct FetchListRequest: CustomRequest {
    var path: String? = "/api/products"
    var query: [URLQueryItem]?
    var httpMethod: HTTPMethod = .GET
    
    init(pageNo: Int, itemsPerPage: Int) {
        query = [
            URLQueryItem(name: "page_no", value: String(pageNo)),
            URLQueryItem(name: "items_per_page", value: String(itemsPerPage))
        ]
    }
}
