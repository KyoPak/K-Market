//
//  ListViewModel.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/11.
//

import Foundation

protocol ListViewModel {
    func bindDataList(completion: @escaping ([Product]) -> Void)
    func fetchProductList()
}

final class DefaultListViewModel {
    private var productList: [Product] = [] {
        didSet {
            dataListHandler?(productList)
        }
    }
    
    private var dataListHandler: (([Product]) -> Void)?
    
    private let fetchUseCase: FetchProductDataUseCase
    
    init(fetchUseCase: FetchProductDataUseCase) {
        self.fetchUseCase = fetchUseCase
    }
    
    func bindDataList(completion: @escaping ([Product]) -> Void) {
        dataListHandler = completion
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
}
