//
//  ProductListCellViewModel.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/11.
//

import Foundation

protocol ProductListCellViewModel {
    
}

final class DefaultProductListCellViewModel {
    private let product: Product
    private let locationData: LocationData?
    
    init(
        product: Product,
        locationData: LocationData,
    ) {
        self.product = product
        self.locationData = locationData
    }
    
    func bindData(completion: @escaping (Product) -> Void) {
        completion(product)
    }
}
