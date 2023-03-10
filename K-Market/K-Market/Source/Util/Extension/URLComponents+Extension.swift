//
//  URLComponents+Extension.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/10.
//

import Foundation

extension URLComponents {
    static func createURL(baseURL:String?, path: String?, queryItem: [URLQueryItem]?) -> URL? {
        guard let base = baseURL, let path = path else { return nil }
        var host = URLComponents(string: base)
        
        host?.path = path
        host?.queryItems = queryItem
        
        return host?.url
    }
}
