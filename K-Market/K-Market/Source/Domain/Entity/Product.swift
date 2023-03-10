//
//  Product.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/09.
//

import Foundation

struct Product: Decodable {
    let id: Int
    let vendorId: Int
    let name: String
    let description: String?
    let thumbnail: String
    let currency: CurrencyUnit
    let price: Double
    let bargainPrice: Double
    let discountedPrice: Double
    let stock: Int
    let createdAt: Date
    let issuedAt: Date
    let images: [ProductImage]?
    let vendors: Venders?
    
    enum CurrencyUnit: String, Decodable, Hashable {
        case KRW
        case USD
        case JPY
        case HKD
        case dollar = "$"
    }
}

struct ProductImage: Decodable, Hashable {
    let id: Int
    let url: String
    let thumbnailUrl: String
    let issuedAt: Date
}

struct Venders: Decodable, Hashable {
    let id: Int
    let name: String
}
