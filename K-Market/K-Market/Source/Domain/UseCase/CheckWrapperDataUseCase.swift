//
//  CheckWrapperDataUseCase.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/21.
//

import Foundation

protocol CheckWrapperDataUseCase {
    func check(thumbnail: String) -> Data?
    func save(thumbnail: String, data: Data)
}

final class DefaultCheckWrapperDataUseCase: CheckWrapperDataUseCase {
    private let wrapperDataRepository: WrapperDataRepository
    
    init(wrapperDataRepository: WrapperDataRepository) {
        self.wrapperDataRepository = wrapperDataRepository
    }
    
    func check(thumbnail: String) -> Data? {
        guard let wrapperData = wrapperDataRepository.fetch(thumbnail: thumbnail) else {
            return nil
        }
        return wrapperData.data
    }
    
    func save(thumbnail: String, data: Data) {
        wrapperDataRepository.save(thumbnail: thumbnail, wrapperData: WrapperData(data: data))
    }
}
