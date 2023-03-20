//
//  ListViewModel.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/11.
//

import Foundation

protocol ListViewModelInput {
    func clear()
    func fetchProductList(pageNo: Int, itemsPerPage: Int)
    func setUserLocation(locale: String, subLocale: String)
    func setLayoutType(layoutIndex: Int)
}

protocol ListViewModelOutput {
    var productList: Observable<[Product]> { get }
    var userSubLocale: Observable<String> { get }
    var userLocale: String { get }
    var loadImageUseCase: LoadImageUseCase { get }
    var fetchLocationUseCase: FetchLocationUseCase { get }
    var layoutStatus: Observable<CollectionType> { get }
    
    func fetchLayoutStatus() -> CollectionType
}

protocol ListViewModel: ListViewModelInput, ListViewModelOutput  { }

final class DefaultListViewModel: ListViewModel {
    private(set) var userLocale = ""
    private let fetchUseCase: FetchProductListUseCase
    private(set) var loadImageUseCase: LoadImageUseCase
    private(set) var fetchLocationUseCase: FetchLocationUseCase
    
    var productList = Observable<[Product]>([])
    var userSubLocale = Observable<String>(Constant.reject)
    var layoutStatus = Observable<CollectionType>(.list)
    
    init(
        fetchUseCase: FetchProductListUseCase,
        loadImageUseCase: LoadImageUseCase,
        fetchLocationUseCase: FetchLocationUseCase
    ) {
        self.fetchUseCase = fetchUseCase
        self.loadImageUseCase = loadImageUseCase
        self.fetchLocationUseCase = fetchLocationUseCase
    }
    
    func clear() {
        productList.value.removeAll()
    }
    
    func fetchProductList(pageNo: Int, itemsPerPage: Int) {
        fetchUseCase.fetchData(pageNo: pageNo, itemsPerPage: itemsPerPage) { [weak self] result in
            switch result {
            case .success(let datas):
                self?.productList.value += datas
            case .failure(let error):
                //TODO: Delegate Alert
                print(error)
            }
        }
    }
    
    func setUserLocation(locale: String, subLocale: String) {
        userLocale = locale
        userSubLocale.value = subLocale
    }
    
    func setLayoutType(layoutIndex: Int) {
        layoutStatus.value = CollectionType(rawValue: layoutIndex) ?? .list
    }
    
    func fetchLayoutStatus() -> CollectionType {
        return layoutStatus.value
    }
}

extension DefaultListViewModel {
    private enum Constant {
        static let reject = "위치 미등록"
    }
}
