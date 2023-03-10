//
//  ProductPage.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/09.
//

import Foundation

struct ProductPage: Decodable {
    let pageNo: Int
    let itemsPerPage: Int
    let totalCount: Int
    let offset: Int
    let limit: Int
    let pages: [Product]
    let lastPage: Int
    let hasNext: Bool
    let hasPrev: Bool
}
