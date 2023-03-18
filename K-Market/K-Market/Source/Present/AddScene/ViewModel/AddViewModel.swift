//
//  AddViewModel.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/17.
//

import Foundation

protocol AddViewModelInput {
    func addImageData(_ data: Data)
    func setupProduct(_ product: Product)
    func postProduct(completion: @escaping (Bool) -> Void)
}

protocol AddViewModelOutput { }

protocol AddViewModel: AddViewModelInput, AddViewModelOutput { }

final class DefualtAddViewModel: AddViewModel {
    private var imageData: [Data] = []
    private var product: Product?
    
    private let fetchProductDetailUseCase: FetchProductDetailUseCase
    private let postProductUseCase: PostProductUseCase
    private let loadImageUseCase: LoadImageUseCase
    
    init(
        fetchProductDetailUseCase: FetchProductDetailUseCase,
        postProductUseCase: PostProductUseCase,
        loadImageUseCase: LoadImageUseCase
    ) {
        self.fetchProductDetailUseCase = fetchProductDetailUseCase
        self.postProductUseCase = postProductUseCase
        self.loadImageUseCase = loadImageUseCase
    }
    
    func addImageData(_ data: Data) {
        imageData.append(data)
    }
    
    func setupProduct(_ product: Product) {
        self.product = product
    }
    
    func postProduct(completion: @escaping (Bool) -> Void) {
        guard let product = product else { return }
        
        postProductUseCase.postData(productData: product, imageDatas: imageData) { result in
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
