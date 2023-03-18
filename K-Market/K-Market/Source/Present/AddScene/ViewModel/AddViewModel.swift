//
//  AddViewModel.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/17.
//

import Foundation

protocol AddViewModelInput {
    func addImageData(_ data: Data?)
    func postProduct(completion: @escaping (Bool) -> Void)
    func setupProduct(
        name: String?,
        price: String?,
        salePrice: String?,
        stock: String?,
        description: String?,
        currencyIndex: Int
    )
}

protocol AddViewModelOutput {
    var userSubLocale: String { get }
    var imageDatas: Observable<[Data]> { get }
    
    func fetchImageData(index: Int) -> Data
}

protocol AddViewModel: AddViewModelInput, AddViewModelOutput { }

final class DefaultAddViewModel: AddViewModel {
    private var product: PostProduct?
    private(set) var imageDatas: Observable<[Data]> = Observable([])
    private(set) var userSubLocale: String
    
    private let fetchProductDetailUseCase: FetchProductDetailUseCase
    private let postProductUseCase: PostProductUseCase
    private let loadImageUseCase: LoadImageUseCase
    
    init(
        userSubLocale: String,
        fetchProductDetailUseCase: FetchProductDetailUseCase,
        postProductUseCase: PostProductUseCase,
        loadImageUseCase: LoadImageUseCase
    ) {
        self.userSubLocale = userSubLocale
        self.fetchProductDetailUseCase = fetchProductDetailUseCase
        self.postProductUseCase = postProductUseCase
        self.loadImageUseCase = loadImageUseCase
    }
    
    func addImageData(_ data: Data?) {
        guard let data = data else { return }
        imageDatas.value.append(data)
    }
    
    func fetchImageData(index: Int) -> Data {
        return imageDatas.value[index]
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
        
        product = PostProduct(
            name: name,
            productID: nil,
            description: description,
            currency: currencyIndex == .zero ? .KRW : .USD,
            price: Double(price) ?? .zero,
            discountedPrice: Double(salePrice ?? ""),
            stock: Int(stock ?? "")
        )
    }
    
    func postProduct(completion: @escaping (Bool) -> Void) {
        guard let product = product else { return }
        
        postProductUseCase.postData(postData: product, imageDatas: imageDatas.value) { result in
            switch result {
            case .success(let check):
                if !check {
                    print(NetworkError.data)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
