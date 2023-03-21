//
//  WrapperDataRepository.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/21.
//

import Foundation

protocol WrapperDataRepository {
    func fetch(thumbnail: String) -> WrapperData?
    func save(thumbnail: String, wrapperData: WrapperData)
}
