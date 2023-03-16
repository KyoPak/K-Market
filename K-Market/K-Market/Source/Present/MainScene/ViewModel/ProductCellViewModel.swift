//
//  ProductListCellViewModel.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/11.
//

import Foundation

protocol ProductCellViewModelInput { }

protocol ProductCellViewModelOutput {
    var product: Product { get }
    var productLocale: Observable<String> { get }
    var imageData: Observable<Data?> { get }
    
    func customStockText() -> String
    func customPriceText() -> String
}

protocol ProductCellViewModel: ProductCellViewModelInput, ProductCellViewModelOutput { }

final class DefaultProductCellViewModel: ProductCellViewModel {
    private(set) var product: Product
    var productLocale: Observable<String> = Observable("")
    var imageData: Observable<Data?> = Observable(nil)
    
    private let loadImageUseCase: LoadImageUseCase
    private let fetchLocationDataUseCase: FetchLocationDataUseCase
    
    init(
        product: Product,
        loadImageUseCase: LoadImageUseCase,
        fetchLocationDataUseCase: FetchLocationDataUseCase
    ) {
        self.product = product
        self.loadImageUseCase = loadImageUseCase
        self.fetchLocationDataUseCase = fetchLocationDataUseCase
        
        loadImage()
        fetchLocationData()
    }
    
    private func fetchLocationData() {
        fetchLocationDataUseCase.fetch(id: product.id) { [weak self] data in
            if let subLocale = data?.subLocality {
                self?.productLocale.value = subLocale
            } else {
                self?.productLocale.value = "미등록"
            }
        }
    }
    
    private func loadImage() {
        loadImageUseCase.loadImage(thumbnail: product.thumbnail) { result in
            switch result {
            case .success(let data):
                self.imageData.value = data
            case .failure(let error):
                print("Error : " ,error)
            }
        }
    }
    
    func customStockText() -> String {
        if product.stock == Int.zero {
            return String(format: "품절")
        } else {
            if product.stock > 1000 {
                return String(format: "수량 : %@K", String(product.stock / 1000))
            }
            return String(format: "수량 : %@", String(product.stock))
        }
    }
    
    func customPriceText() -> String {
        if product.price > 1000 {
            return String(format: "%@ %@K", product.currency.rawValue, String(product.price / 1000))
        }
        return String(format: "%@ %@", product.currency.rawValue, String(product.price))
    }
}
