//
//  PostProduct.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/18.
//

import Foundation

struct PostProduct: Encodable {
    private enum Constant {
        static let identifier = "dk9r294wvfwkgvhn"
    }
    
    let name: String
    let productID: Int?
    let description: String
    let currency: CurrencyUnit
    let price: Double
    var discountedPrice: Double? = .zero
    var stock: Int? = 0
    let secret: String = Constant.identifier

    enum CurrencyUnit: String, Encodable {
        case KRW
        case USD
    }

    enum CodingKeys: String, CodingKey {
        case name, productID, description, currency, price, stock, secret
        case discountedPrice = "discounted_price"
    }
}
