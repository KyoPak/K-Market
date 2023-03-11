//
//  ProductListCellViewModel.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/11.
//

import Foundation

protocol ProductListCellViewModel {
    func bindData(completion: @escaping (Product) -> Void)
    func loadImage(completion: @escaping (Data?) -> Void)
    func customStockText(_ stock: Int) -> String
    func customPriceText(_ price: Double) -> String
}

final class DefaultProductListCellViewModel {
    private let product: Product
    private let locationData: LocationData?
    private let loadImageUseCase: LoadImageUseCase
    
    init(
        product: Product,
        locationData: LocationData,
        useCase: LoadImageUseCase
    ) {
        self.product = product
        self.locationData = locationData
        self.loadImageUseCase = useCase
    }
    
    func bindData(completion: @escaping (Product) -> Void) {
        completion(product)
    }
    
    func loadImage(completion: @escaping (Data?) -> Void) {
        loadImageUseCase.loadImage(thumbnail: product.thumbnail) { result in
            switch result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print("Error : " ,error)
                completion(nil)
            }
        }
    }
    
    func customStockText(_ stock: Int) -> String {
        if product.stock == Int.zero {
            return String(format: "품절")
        } else {
            if product.stock > 1000 {
                return String(format: "수량 : %@", String(product.stock / 1000))
            }
            return String(format: "수량 : %@", String(product.stock))
        }
    }
    
    func customPriceText(_ price: Double) -> String {
        if price > 1000 {
            return String(format: "%@ %@K", product.currency.rawValue, String(price / 1000))
        }
        return String(format: "%@ %@", product.currency.rawValue, String(price))
    }
}
