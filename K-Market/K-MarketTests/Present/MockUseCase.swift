//
//  MockUseCase.swift
//  K-MarketTests
//
//  Created by parkhyo on 2023/03/25.
//

import Foundation
@testable import K_Market

final class MockFetchUseCase: FetchProductListUseCase {
    private lazy var productList: [Product] = [
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
            thumbnail: "",
            currency: .KRW,
            price: price,
            bargainPrice: .zero,
            discountedPrice: .zero,
            stock: .zero,
            createdAt: Date(),
            issuedAt: Date(),
            images: nil,
            vendors: nil
        )
    }
    
    func fetchData(
        pageNo: Int,
        itemsPerPage: Int,
        completion: @escaping (Result<[Product], NetworkError>) -> Void
    ) {
        completion(.success(productList))
    }
}


final class MockLoadImageUseCase: LoadImageUseCase {
    func loadImage(thumbnail: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        completion(.success(thumbnail.data(using: .utf8)!))
    }
}


final class MockCheckWrapperDataUseCase: CheckWrapperDataUseCase {
    private var datas: [String : Data] = [
        "test01" : "test01".data(using: .utf8)!,
        "test02" : "test02".data(using: .utf8)!,
        "test03" : "test03".data(using: .utf8)!,
    ]
    
    func check(thumbnail: String) -> Data? {
        return datas[thumbnail]
    }
    
    func save(thumbnail: String, data: Data) {
        datas[thumbnail] = data
    }
}


final class MockFetchLocationUseCase: FetchLocationUseCase {
    private lazy var datas: [LocationData] = [
        stub(id: 1, locality: "test01"),
        stub(id: 2, locality: "test02"),
        stub(id: 3, locality: "test03"),
        stub(id: 4, locality: "test04"),
    ]
    
    private func stub(id: Int, locality: String) -> LocationData {
        return LocationData(id: id, locality: locality, subLocality: "")
    }
    
    func fetch(id: Int, completion: @escaping (LocationData?) -> Void) {
        var data = datas.filter { findData in
            if findData.id == id {
                return true
            } else {
                return false
            }
        }
        
        completion(data.first)
    }
}


