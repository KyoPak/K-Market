//
//  URLSessionProtocol.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/29.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask
}
