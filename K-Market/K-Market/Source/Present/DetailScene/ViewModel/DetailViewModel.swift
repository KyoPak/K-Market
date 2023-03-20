//
//  DetailViewModel.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/17.
//

import Foundation

protocol DetailViewModelInput {
    func setup()
    func clear()
    func fetchImageData(index: Int, completion: @escaping (Data) -> Void)
    func delete(completion: @escaping (NetworkError?) -> Void)
}

protocol DetailViewModelOutput {
    var product: Observable<Product?> { get }
    var productLocale:  Observable<String> { get }
    var productImages: Observable<[ProductImage]?> { get }
    var imageDatas: [Data] { get }
    
    func fetchProductImageCount() -> Int
    func customDate() -> String
    func customStockText() -> String
    func customPriceText(_ price: Double?) -> String
}

protocol DetailViewModel: DetailViewModelInput, DetailViewModelOutput { }

final class DefaultDetailViewModel: DetailViewModel {
    var product: Observable<Product?> = Observable(nil)
    var productImages: Observable<[ProductImage]?> = Observable([])
    var productLocale: Observable<String> = Observable("")
    private(set) var imageDatas: [Data] = []
    private var id: Int
    
    private let fetchProductDetailUseCase: FetchProductDetailUseCase
    private let fetchLocationUseCase: FetchLocationUseCase
    private let loadImageUseCase: LoadImageUseCase
    private let deleteProductUseCase: DeleteProductUseCase
    private let deleteLocationUseCase: DeleteLocationUseCase
    
    
    init(id: Int,
         fetchLocationUseCase: FetchLocationUseCase,
         fetchProductDetailUseCase: FetchProductDetailUseCase,
         loadImageUseCase: LoadImageUseCase,
         deleteProductUseCase: DeleteProductUseCase,
         deleteLocationUseCase: DeleteLocationUseCase
    ) {
        self.id = id
        self.fetchLocationUseCase = fetchLocationUseCase
        self.fetchProductDetailUseCase = fetchProductDetailUseCase
        self.loadImageUseCase = loadImageUseCase
        self.deleteProductUseCase = deleteProductUseCase
        self.deleteLocationUseCase = deleteLocationUseCase
    }
    
    private func fetchProductDetailInfo(id: Int) {
        fetchProductDetailUseCase.fetchData(id: id) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let product):
                    self.product.value = product
                    self.productImages.value = product.images
                case .failure(let error):
                    //TODO: - Alert
                    print(error)
                }
            }
        }
    }
    
    private func fetchLocation(id: Int) {
        fetchLocationUseCase.fetch(id: id) { location in
            self.productLocale.value = location?.subLocality ?? "위치 미등록"
        }
    }
    
    func setup() {
        fetchLocation(id: id)
        fetchProductDetailInfo(id: id)
    }
    
    func clear() {
        imageDatas.removeAll()
    }
    
    func delete(completion: @escaping (NetworkError?) -> Void) {
        guard let id = product.value?.id else { return }
        deleteLocationUseCase.delete(id: id)
        deleteProductUseCase.deleteData(id: id) { result in
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
    
    func fetchProductImageCount() -> Int {
        return productImages.value?.count ?? .zero
    }
    
    func fetchImageData(index: Int, completion: @escaping (Data) -> Void) {
        guard let url = productImages.value?[index].url else { return }
        loadImageUseCase.loadImage(thumbnail: url) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.imageDatas.append(data)
                    completion(data)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func customDate() -> String {
        let currentDate = Date()
        guard let date = product.value?.createdAt else { return "" }
        let calendar = Calendar.current
        
        let month = calendar.dateComponents([.month], from: date, to: currentDate).month
        let day = calendar.dateComponents([.day], from: date, to: currentDate).day
        let hour = calendar.dateComponents([.hour], from: date, to: currentDate).hour
        let minute = calendar.dateComponents([.minute], from: date, to: currentDate).minute
        let second = calendar.dateComponents([.second], from: date, to: currentDate).second
        
        if let month = month, abs(month) > .zero {
            return String(abs(month)) + "달 전"
        } else if let day = day, abs(day) > .zero {
            return String(abs(day)) + "일 전"
        } else if let hour = hour, abs(hour) > .zero {
            return String(abs(hour)) + "시간 전"
        } else if let minute = minute, abs(minute) > .zero {
            return String(abs(minute)) + "분 전"
        } else if let second = second, abs(second) > .zero {
            return String(abs(second)) + "초 전"
        } else {
            return ""
        }
    }
    
    func customStockText() -> String {
        guard let stock = product.value?.stock else { return "" }
        
        if stock == Int.zero {
            return String(format: "품절")
        } else {
            if stock > 1000 {
                return String(format: "수량 : %@K", String(stock / 1000))
            }
            return String(format: "수량 : %@", String(stock))
        }
    }
    
    func customPriceText(_ price: Double?) -> String {
        guard let currency = product.value?.currency, let price = price else { return "" }
        
        if price > 1000 {
            return String(format: "%@ %@K", currency.rawValue, String(price / 1000))
        }
        return String(format: "%@ %@", currency.rawValue, String(price))
    }
}
