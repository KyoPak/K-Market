//
//  Formatter+Extension.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/11.
//

import Foundation

extension Formatter {
    static let customDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        return formatter
    }()
}
