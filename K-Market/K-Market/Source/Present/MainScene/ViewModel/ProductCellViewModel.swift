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
    
    func customStockText() -> String
    func customPriceText(_ price: Double) -> String
}

protocol ProductCellViewModel: ProductCellViewModelInput, ProductCellViewModelOutput { }

final class DefaultProductCellViewModel: ProductCellViewModel {
    // MARK: - OUTPUT
    private(set) var product: Product
    var productLocale: Observable<String> = Observable("")
    
    private let fetchLocationUseCase: FetchLocationUseCase
    
    // MARK: - Init
    init(
        product: Product,
        fetchLocationUseCase: FetchLocationUseCase
    ) {
        self.product = product
        self.fetchLocationUseCase = fetchLocationUseCase
        fetchLocationData()
    }
    
    private func fetchLocationData() {
        fetchLocationUseCase.fetch(id: product.id) { [weak self] data in
            if let subLocale = data?.subLocality {
                self?.productLocale.value = subLocale
            } else {
                self?.productLocale.value = Constant.reject
            }
        }
    }
    
    // MARK: - OUTPUT Method
    func customStockText() -> String {
        if product.stock == Int.zero {
            return String(format: Constant.soldOut)
        } else {
            if product.stock > 1000 {
                return String(format: "수량 : %@K", String(product.stock / 1000))
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

extension DefaultProductCellViewModel {
    private enum Constant {
        static let reject = "위치 미등록"
        static let soldOut = "품절"
    }
}
