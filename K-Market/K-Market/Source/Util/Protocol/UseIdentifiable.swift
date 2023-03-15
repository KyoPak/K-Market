//
//  UseIdentifiable.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/11.
//

import Foundation

protocol UseIdentifiable: AnyObject { }

extension UseIdentifiable {
    static var identifier: String {
        return String.init(describing: self)
    }
}
