//
//  DetailViewModel.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/17.
//

import Foundation

protocol DetailViewModelInput {
    
}

protocol DetailViewModelOutput {
    var product: Observable<Product> { get }
    var productLocale:  Observable<String> { get }
    
    func customDate() -> String
}

protocol DetailViewModel: DetailViewModelInput, DetailViewModelOutput { }

final class DefaultDetailViewModel: DetailViewModel {
    var product: Observable<Product>
    var productLocale: Observable<String> = Observable("")
    
    private let fetchLocationDataUseCase: FetchLocationDataUseCase
    
    init(product: Product,
         fetchLocationDataUseCase: FetchLocationDataUseCase
    ) {
        self.product = Observable(product)
        self.fetchLocationDataUseCase = fetchLocationDataUseCase
        fetchLocation()
    }
    
    func customDate() -> String {
        let currentDate = Date()
        let date = product.value.createdAt
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
    
    private func fetchLocation() {
        fetchLocationDataUseCase.fetch(id: product.value.id) { location in
            self.productLocale.value = location?.subLocality ?? "미등록"
        }
    }
}
