//
//  StubProvider.swift
//  K-MarketTests
//
//  Created by parkhyo on 2023/03/27.
//

import Foundation
@testable import K_Market

struct StubProvider {
    lazy var productList: [Product] = [
        stub(id: 1, name: "test01", price: 100),
        stub(id: 2, name: "test02", price: 200),
        stub(id: 3, name: "test03", price: 300),
        stub(id: 4, name: "test04", price: 400),
        stub(id: 5, name: "test05", price: 500),
        stub(id: 6, name: "test06", price: 600),
        stub(id: 7, name: "test07", price: 700),
        stub(id: 8, name: "test08", price: 800),
        stub(id: 9, name: "test09", price: 900),
        stub(id: 10, name: "test10", price: 1000),
        stub(id: 11, name: "test11", price: 1100),
        stub(id: 12, name: "test12", price: 1200),
        stub(id: 13, name: "test13", price: 1300),
        stub(id: 14, name: "test14", price: 1400),
        stub(id: 15, name: "test15", price: 1500),
    ]
    
    private func stub(id: Int, name: String, price: Double) -> Product {
        return Product(
            id: id,
            vendorId: .zero,
            name: name,
            description: nil,
            thumbnail: name,
            currency: .KRW,
            price: price,
            bargainPrice: .zero,
            discountedPrice: .zero,
            stock: 1000,
            createdAt: Date(),
            issuedAt: Date(),
            images: nil,
            vendors: nil
        )
    }
}
