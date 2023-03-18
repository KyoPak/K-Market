//
//  DetailViewModel.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/17.
//

import Foundation

protocol DetailViewModelInput {
    func fetchImageData(index: Int, completion: @escaping (Data) -> Void)
}

protocol DetailViewModelOutput {
    var product: Observable<Product?> { get }
    var productLocale:  Observable<String> { get }
    var imageDatas: Observable<[ProductImage]?> { get }
    
    func fetchProductImageCount() -> Int
    func customDate() -> String
    func customStockText() -> String
    func customPriceText(_ price: Double?) -> String
}

protocol DetailViewModel: DetailViewModelInput, DetailViewModelOutput { }

final class DefaultDetailViewModel: DetailViewModel {
    var product: Observable<Product?> = Observable(nil)
    var imageDatas: Observable<[ProductImage]?> = Observable([])
    var productLocale: Observable<String> = Observable("")
    
    private let fetchLocationUseCase: FetchLocationUseCase
    private let fetchProductDetailUseCase: FetchProductDetailUseCase
    private let loadImageUseCase: LoadImageUseCase
    
    init(id: Int,
         fetchLocationUseCase: FetchLocationUseCase,
         fetchProductDetailUseCase: FetchProductDetailUseCase,
         loadImageUseCase: LoadImageUseCase
    ) {
        self.fetchLocationUseCase = fetchLocationUseCase
        self.fetchProductDetailUseCase = fetchProductDetailUseCase
        self.loadImageUseCase = loadImageUseCase
        
        fetchLocation(id: id)
        fetchProductDetailInfo(id: id)
    }
    
    private func fetchProductDetailInfo(id: Int) {
        fetchProductDetailUseCase.fetchData(id: id) { result in
            switch result {
            case .success(let product):
                DispatchQueue.main.async {
                    self.product.value = product
                    self.imageDatas.value = product.images
                }
            case .failure(let error):
                //TODO: - Alert
                print(error)
            }
        }
    }
    
    private func fetchLocation(id: Int) {
        fetchLocationUseCase.fetch(id: id) { location in
            self.productLocale.value = location?.subLocality ?? "위치 미등록"
        }
    }
    
    func fetchProductImageCount() -> Int {
        return imageDatas.value?.count ?? .zero
    }
    
    func fetchImageData(index: Int, completion: @escaping (Data) -> Void) {
        guard let url = imageDatas.value?[index].url else { return }
        
        loadImageUseCase.loadImage(thumbnail: url) { result in
            switch result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print(error)
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
