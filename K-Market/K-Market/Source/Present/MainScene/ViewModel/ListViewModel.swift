//
//  ListViewModel.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/11.
//

import Foundation

protocol ListViewModelInput {
    func clear()
    func fetchProductList()
    func setUserLocation(locale: String, subLocale: String)
    func setLayoutType(layoutIndex: Int)
    func loadImage(index: Int, completion: @escaping (Data) -> Void)
}

protocol ListViewModelOutput {
    var userLocale: String { get }
    var userSubLocale: Observable<String> { get }
    var productList: Observable<[Product]> { get }
    var layoutStatus: Observable<CollectionType> { get }
    var error: Observable<String?> { get }
    var loadImageUseCase: LoadImageUseCase { get }
    var fetchLocationUseCase: FetchLocationUseCase { get }
}

protocol ListViewModel: ListViewModelInput, ListViewModelOutput  { }

final class DefaultListViewModel: ListViewModel {
    // MARK: - OUTPUT
    var productList = Observable<[Product]>([])
    var userSubLocale = Observable<String>(Constant.reject)
    var layoutStatus = Observable<CollectionType>(.list)
    var error = Observable<String?>(nil)
    
    private(set) var userLocale = ""
    private(set) var loadImageUseCase: LoadImageUseCase
    private(set) var fetchLocationUseCase: FetchLocationUseCase
    
    private let fetchUseCase: FetchProductListUseCase
    private var pageNo = Constant.pageUnit
    
    // MARK: - Init
    init(
        fetchUseCase: FetchProductListUseCase,
        loadImageUseCase: LoadImageUseCase,
        fetchLocationUseCase: FetchLocationUseCase
    ) {
        self.fetchUseCase = fetchUseCase
        self.loadImageUseCase = loadImageUseCase
        self.fetchLocationUseCase = fetchLocationUseCase
    }
    
    // MARK: - INPUT
    func clear() {
        pageNo = Constant.pageUnit
        productList.value.removeAll()
    }
    
    func fetchProductList() {
        defer {
            pageNo += Constant.pageUnit
        }
        
        fetchUseCase.fetchData(pageNo: pageNo, itemsPerPage: Constant.itemsPerPage) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let datas):
                    self?.productList.value += datas
                case .failure(let error):
                    self?.error.value = error.description
                }
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
    
    func loadImage(index: Int, completion: @escaping (Data) -> Void) {
        loadImageUseCase.loadImage(thumbnail: productList.value[index].thumbnail) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    completion(data)
                case .failure(let error):
                    print("Error : " ,error)
                }
            }
        }
    }
}

extension DefaultListViewModel {
    private enum Constant {
        static let reject = "위치 미등록"
        static let itemsPerPage = 15
        static let pageUnit = 1
    }
}
