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
    // MARK: - OUTPUT
    private(set) var userLocale: String
    private(set) var userSubLocale: String
    private(set) var imageDatas: Observable<[Data]> = Observable([])
    
    private var product: PostProduct?
    
    private let postProductUseCase: PostProductUseCase
    private let postLocationUseCase: PostLocationUseCase
    private let loadImageUseCase: LoadImageUseCase
    
    // MARK: - Init
    init(
        locale: String,
        subLocale: String,
        postProductUseCase: PostProductUseCase,
        postLocationUseCase: PostLocationUseCase,
        loadImageUseCase: LoadImageUseCase
    ) {
        self.userLocale = locale
        self.userSubLocale = subLocale
        self.postProductUseCase = postProductUseCase
        self.postLocationUseCase = postLocationUseCase
        self.loadImageUseCase = loadImageUseCase
    }
    
    // MARK: - INPUT
    func addImageData(_ data: Data?) {
        guard let data = data else { return }
        imageDatas.value.append(data)
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
        
        postProductUseCase.postData(product, imageDatas: imageDatas.value) { result in
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
    
    // MARK: - OUTPUT Method
    func fetchImageData(index: Int) -> Data {
        return imageDatas.value[index]
    }
    
    private func postLocation(id: Int) {
        postLocationUseCase.add(id: id, locale: userLocale, subLocale: userSubLocale)
    }
}
