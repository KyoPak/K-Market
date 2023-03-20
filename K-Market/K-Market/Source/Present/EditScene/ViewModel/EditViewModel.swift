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
    var imageDatas: [Data] { get }
}

protocol EditViewModel: EditViewModelInput, EditViewModelOutput { }

class DefaultEditViewModel: EditViewModel {
    private(set) var product: Product
    private(set) var imageDatas: [Data] = []
    private var editProduct: PostProduct?
    
    private let patchProductUseCase: PatchProductUseCase
    
    init(
        product: Product,
        imagesData: [Data],
        patchProductUseCase: PatchProductUseCase
    ) {
        self.product = product
        self.imageDatas = imagesData
        self.patchProductUseCase = patchProductUseCase
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
        
        patchProductUseCase.patchData(id: product.id, editProduct) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    completion(nil)
                case .failure(let error):
                    completion(error)
                }
            }
        }
    }
}