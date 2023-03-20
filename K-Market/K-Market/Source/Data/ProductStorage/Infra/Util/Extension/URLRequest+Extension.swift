//
//  URLRequest+Extension.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/19.
//

import Foundation

extension URLRequest {
    static func setupIdentifier(request: inout URLRequest) -> URLRequest {
        request.setValue(
            "0574c520-6942-11ed-a917-43299f97bee6",
            forHTTPHeaderField: "identifier"
        )
        
        return request
    }
}
