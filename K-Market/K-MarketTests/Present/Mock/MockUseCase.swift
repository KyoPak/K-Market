//
//  MockUseCase.swift
//  K-MarketTests
//
//  Created by parkhyo on 2023/03/25.
//

import Foundation
@testable import K_Market

final class MockFetchUseCase: FetchProductListUseCase {
    private var stubProvider = StubProvider()
    
    func fetchData(
        pageNo: Int,
        itemsPerPage: Int,
        completion: @escaping (Result<[Product], NetworkError>) -> Void
    ) {
        completion(.success(stubProvider.productList))
    }
}

final class MockFetchProductDetailUseCase: FetchProductDetailUseCase {
    private var stubProvider = StubProvider()
    
    func fetchData(id: Int, completion: @escaping (Result<Product, NetworkError>) -> Void) {
        let data = stubProvider.productList.filter { data in
            if data.id == id {
                return true
            } else { return false }
        }
        
        guard let data = data.first else { completion(.failure(.data))
            return
        }
        
        completion(.success(data))
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


final class MockDeleteProductUserCase: DeleteProductUseCase {
    func deleteData(id: Int, completion: @escaping (Result<Bool, K_Market.NetworkError>) -> Void) {
        completion(.success(true))
    }
}

final class MockDeleteLocationUseCase: DeleteLocationUseCase {
    func delete(id: Int) { }
}
