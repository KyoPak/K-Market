//
//  ListViewModel.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/11.
//

import Foundation

protocol ListViewModel {
    var layoutStatus: CollectionType { get }
    var userLocale: String { get }
    var userSubLocale: String { get }
    func bindDataList(completion: @escaping ([Product]) -> Void)
    func bindSubLocale(completion: @escaping ((String)) -> Void)
    func fetchProductList(pageNo: Int, itemsPerPage: Int)
    func setUserLocation(locale: String, subLocale: String)
    func setLayoutType(layoutIndex: Int)
    func bindLayoutStatus(completion: @escaping ((CollectionType)) -> Void)
}

final class DefaultListViewModel: ListViewModel {
    private var productList: [Product] = [] {
        didSet {
            dataListHandler?(productList)
        }
    }
    
    private(set) var userLocale = ""
    private(set) var userSubLocale = "" {
        didSet {
            subLocaleHandler?(userSubLocale)
        }
    }
    
    private(set) var layoutStatus: CollectionType = .list {
        didSet {
            layoutHandler?(layoutStatus)
        }
    }
    
    private var dataListHandler: (([Product]) -> Void)?
    private var subLocaleHandler: ((String) -> Void)?
    private var layoutHandler: ((CollectionType) -> Void)?
    
    private let fetchUseCase: FetchProductUseCase
    
    init(fetchUseCase: FetchProductUseCase) {
        self.fetchUseCase = fetchUseCase
        fetchProductList(pageNo: 1, itemsPerPage: 15)
    }
    
    func bindDataList(completion: @escaping ([Product]) -> Void) {
        dataListHandler = completion
    }
    
    func bindSubLocale(completion: @escaping ((String)) -> Void) {
        subLocaleHandler = completion
    }
    
    func bindLayoutStatus(completion: @escaping ((CollectionType)) -> Void) {
        layoutHandler = completion
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
    
    func setLayoutType(layoutIndex: Int) {
        layoutStatus = CollectionType(rawValue: layoutIndex) ?? .list
    }
}
