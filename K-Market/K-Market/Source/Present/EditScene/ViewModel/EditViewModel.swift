//
//  EditViewModel.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/19.
//

import Foundation

protocol EditViewModelInput {
    func patchProduct(completion: @escaping (Bool) -> Void)
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
    var error: Observable<String?> { get }
}

protocol EditViewModel: EditViewModelInput, EditViewModelOutput { }

class DefaultEditViewModel: EditViewModel {
    // MARK: - OUTPUT
    private(set) var product: Product
    private(set) var imageDatas: [Data] = []
    var error = Observable<String?>(nil)
    
    private var editProduct: PostProduct?
    private let patchProductUseCase: PatchProductUseCase
    
    // MARK: - Init
    init(
        product: Product,
        imagesData: [Data],
        patchProductUseCase: PatchProductUseCase
    ) {
        self.product = product
        self.imageDatas = imagesData
        self.patchProductUseCase = patchProductUseCase
    }
    
    // MARK: - INPUT
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
    
    func patchProduct(completion: @escaping (Bool) -> Void) {
        guard let editProduct = editProduct else { return }
        
        patchProductUseCase.patchData(id: product.id, editProduct) { result in
            switch result {
            case .success(_):
                completion(true)
            case .failure(let error):
                self.error.value = error.description
            }
        }
    }
}
