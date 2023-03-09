//
//  RequestByUseCase.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/09.
//

import Foundation

struct ProductListFetchRequest: NetworkRequest {
    var path: String = "/api/products"
    var query: [URLQueryItem]
    var httpMethod: HttpMethod = .GET
    
    private var pageNo: Int
    private var itemsPerPage: Int
    private var url: URL?
    
    init(pageNo: Int, itemsPerPage: Int) {
        self.pageNo = pageNo
        self.itemsPerPage = itemsPerPage
        query = [
            URLQueryItem(name: "page_no", value: String(pageNo)),
            URLQueryItem(name: "items_per_page", value: String(itemsPerPage))
        ]
        
        url = createURL()
    }
}
