//
//  AddViewModel.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/17.
//

import Foundation

protocol AddViewModelInput {
    func addImageData(_ data: Data?)
    func postProduct(completion: @escaping (NetworkError?) -> Void)
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
    var userLocale: String { get }
    var userSubLocale: String { get }
    var imageDatas: Observable<[Data]> { get }
    
    func fetchImageData(index: Int) -> Data
}

protocol AddViewModel: AddViewModelInput, AddViewModelOutput { }

final class DefaultAddViewModel: AddViewModel {
    private var product: PostProduct?
    private(set) var userLocale: String
    private(set) var userSubLocale: String
    private(set) var imageDatas: Observable<[Data]> = Observable([])
    
    private let fetchProductDetailUseCase: FetchProductDetailUseCase
    private let postProductUseCase: PostProductUseCase
    private let postLocationUseCase: PostLocationUseCase
    private let loadImageUseCase: LoadImageUseCase
    
    init(
        locale: String,
        subLocale: String,
        fetchProductDetailUseCase: FetchProductDetailUseCase,
        postProductUseCase: PostProductUseCase,
        postLocationUseCase: PostLocationUseCase,
        loadImageUseCase: LoadImageUseCase
    ) {
        self.userLocale = locale
        self.userSubLocale = subLocale
        self.fetchProductDetailUseCase = fetchProductDetailUseCase
        self.postProductUseCase = postProductUseCase
        self.postLocationUseCase = postLocationUseCase
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
    
    func postProduct(completion: @escaping (NetworkError?) -> Void) {
        guard let product = product else { return }
        
        postProductUseCase.postData(postData: product, imageDatas: imageDatas.value) { result in
            switch result {
            case .success(let data):
                self.postLocation(id: data.id)
                DispatchQueue.main.async {
                    completion(nil)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(error)
                }
                print(error)
            }
        }
    }
    
    private func postLocation(id: Int) {
        postLocationUseCase.add(id: id, locale: userLocale, subLocale: userSubLocale)
    }
}
