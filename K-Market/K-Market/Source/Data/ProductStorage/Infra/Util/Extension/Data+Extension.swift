//
//  Data+Extension.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/19.
//

import Foundation

extension Data {
    mutating func appendStringData(_ string: String) {
        guard let data = string.data(using: .utf8) else { return }
        self.append(data)
    }
}
