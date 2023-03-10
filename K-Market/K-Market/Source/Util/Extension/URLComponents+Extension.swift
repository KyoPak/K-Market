//
//  URLComponents+Extension.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/10.
//

import Foundation

extension URLComponents {
    static func createURL(path: String, queryItem: [URLQueryItem]?) -> URL? {
        var host = URLComponents(string: path)
        host?.path = path
        host?.queryItems = queryItem
        
        return host?.url
    }
}
