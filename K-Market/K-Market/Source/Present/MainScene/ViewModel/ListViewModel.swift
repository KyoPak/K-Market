//
//  ListViewModel.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/11.
//

import Foundation

protocol ListViewModel {
    func bindDataList(completion: @escaping ([Product]) -> Void)
    func bindSubLocale(completion: @escaping ((String)) -> Void)
    func fetchProductList(pageNo: Int, itemsPerPage: Int)
    func setUserLocation(locale: String, subLocale: String)
}

final class DefaultListViewModel {
    private var productList: [Product] = [] {
        didSet {
            dataListHandler?(productList)
        }
    }
    
    private var userLocale = ""
    private var userSubLocale = "" {
        didSet {
            subLocaleHandler?(userSubLocale)
        }
    }
    
    private var dataListHandler: (([Product]) -> Void)?
    private var subLocaleHandler: ((String) -> Void)?
    
    private let fetchUseCase: FetchProductDataUseCase
    
    init(fetchUseCase: FetchProductDataUseCase) {
        self.fetchUseCase = fetchUseCase
    }
}

extension DefaultListViewModel: ListViewModel {
    func bindDataList(completion: @escaping ([Product]) -> Void) {
        dataListHandler = completion
    }
    
    func bindSubLocale(completion: @escaping ((String)) -> Void) {
        subLocaleHandler = completion
    }
    
    func fetchProductList(pageNo: Int, itemsPerPage: Int) {
        fetchUseCase.fetchData(pageNo: pageNo, itemsPerPage: itemsPerPage) { [weak self] result in
            switch result {
            case .success(let datas):
                self?.productList += datas
            case .failure(let error):
                //TODO: Delegate Alert
                print(error)
            }
        }
    }
    
    func setUserLocation(locale: String, subLocale: String) {
        userLocale = locale
        userSubLocale = subLocale
    }
}
