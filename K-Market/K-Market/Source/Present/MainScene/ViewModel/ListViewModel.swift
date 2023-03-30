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
    var productList: Observable<[UniqueProduct]> { get }
    var recentProductList: Observable<[UniqueProduct]> { get }
    var layoutStatus: Observable<CollectionType> { get }
    var error: Observable<String?> { get }
    var loadImageUseCase: LoadImageUseCase { get }
    var fetchLocationUseCase: FetchLocationUseCase { get }
}

protocol ListViewModel: ListViewModelInput, ListViewModelOutput  { }

final class DefaultListViewModel: ListViewModel {
    // MARK: - OUTPUT
    var productList = Observable<[UniqueProduct]>([])
    var recentProductList = Observable<[UniqueProduct]>([])
    var userSubLocale = Observable<String>(Constant.reject)
    var layoutStatus = Observable<CollectionType>(.list)
    var error = Observable<String?>(nil)
    
    private(set) var userLocale = ""
    private(set) var loadImageUseCase: LoadImageUseCase
    private(set) var fetchLocationUseCase: FetchLocationUseCase
    private let checkWrapperDataUseCase: CheckWrapperDataUseCase
    
    private let fetchUseCase: FetchProductListUseCase
    private var pageNo = Constant.pageUnit
    
    // MARK: - Init
    init(
        fetchUseCase: FetchProductListUseCase,
        loadImageUseCase: LoadImageUseCase,
        fetchLocationUseCase: FetchLocationUseCase,
        checkWrapperDataUseCase: CheckWrapperDataUseCase
    ) {
        self.fetchUseCase = fetchUseCase
        self.loadImageUseCase = loadImageUseCase
        self.fetchLocationUseCase = fetchLocationUseCase
        self.checkWrapperDataUseCase = checkWrapperDataUseCase
    }
    
    // MARK: - INPUT
    func clear() {
        pageNo = Constant.pageUnit
        productList.value.removeAll()
        recentProductList.value.removeAll()
    }
    
    func fetchProductList() {
        fetchUseCase.fetchData(pageNo: pageNo, itemsPerPage: Constant.itemsPerPage) { [weak self] result in
            switch result {
            case .success(let datas):
                if self?.pageNo == Constant.pageUnit {
                    var temp: [UniqueProduct] = []
                    for index in 0..<5 {
                        let data = UniqueProduct(product: datas[index])
                        temp.append(data)
                    }
                    self?.recentProductList.value = temp
                }
                
                var temp: [UniqueProduct] = []
                for index in 0..<datas.count {
                    let data = UniqueProduct(product: datas[index])
                    temp.append(data)
                }
                
                self?.productList.value += temp
            case .failure(let error):
                self?.error.value = error.description
            }
            self?.pageNo += Constant.pageUnit
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
        if index >= productList.value.count { return }
        
        let thumbnail = productList.value[index].product.thumbnail
        
        if let data =  checkWrapperDataUseCase.check(thumbnail: thumbnail) {
            completion(data)
        } else {
            loadImageUseCase.loadImage(thumbnail: thumbnail) { result in
                switch result {
                case .success(let data):
                    self.checkWrapperDataUseCase.save(thumbnail: thumbnail, data: data)
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
