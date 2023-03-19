//
//  EditViewModel.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/19.
//

import Foundation

protocol EditViewModelInput {
    func patchProduct(completion: @escaping (NetworkError?) -> Void)
    func setupProduct(
        name: String?,
        price: String?,
        salePrice: String?,
        stock: String?,
        description: String?,
        currencyIndex: Int
    )
}

protocol EditViewModelOutput {
    var product: Product { get }
}

protocol EditViewModel: EditViewModelInput, EditViewModelOutput { }

class DefaultEditViewModel: EditViewModel {
    private(set) var product: Product
    private var editProduct: PostProduct?
    
    private let loadImageUseCase: LoadImageUseCase
    private let patchProductUseCase: PatchProductUseCase
    private let fetchProductDetailUseCase: FetchProductDetailUseCase
    
    init(
        product: Product,
        patchProductUseCase: PatchProductUseCase,
        loadImageUseCase: LoadImageUseCase,
        fetchProductDetailUseCase: FetchProductDetailUseCase
    ) {
        self.product = product
        self.patchProductUseCase = patchProductUseCase
        self.fetchProductDetailUseCase = fetchProductDetailUseCase
        self.loadImageUseCase = loadImageUseCase
    }
    
    func setupProduct(
        name: String?,
        price: String?,
        salePrice: String?,
        stock: String?,
        description: String?,
        currencyIndex: Int
    ) {
        guard let name = name, let price = price, let description = description else { return }
        
        editProduct = PostProduct(
            name: name,
            productID: nil,
            description: description,
            currency: currencyIndex == .zero ? .KRW : .USD,
            price: Double(price) ?? .zero,
            discountedPrice: Double(salePrice ?? ""),
            stock: Int(stock ?? "")
        )
    }
    
    func patchProduct(completion: @escaping (NetworkError?) -> Void) {
        guard let editProduct = editProduct else { return }
        
       // editProduct 넘기기
    }
}
