//
//  MockNetwork.swift
//  K-MarketTests
//
//  Created by parkhyo on 2023/03/29.
//

import Foundation
@testable import K_Market

// MARK: - SessionDataTask Mocking
final class MockSessionDataTask: URLSessionDataTask {
    private var resumeHandler: () -> Void
    
    init(resumeHandler: @escaping () -> Void) {
        self.resumeHandler = resumeHandler
    }
    
    override func resume() {
        resumeHandler()
    }
}

// MARK: - URLSession Mocking
final class MockURLSession: URLSessionProtocol {
    private var requestSuccess: Bool
    
    init(requestSuccess: Bool = true) {
        self.requestSuccess = requestSuccess
    }
    
    // Service's request method use thid Method
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask {
        
        // Data
        let data = "ServerData".data(using: .utf8)
        
        // URLRespose
        var urlResponse: URLResponse?
        if requestSuccess {
            urlResponse = makeResponse(url: request.url!, status: 200)
        } else {
            urlResponse = makeResponse(url: request.url!, status: 400)
        }
        
        // Error
        let error = NetworkError.networking
        
        // Return
        if requestSuccess {
            return MockSessionDataTask {
                completionHandler(data, urlResponse, nil)
            }
        } else {
            return MockSessionDataTask {
                completionHandler(nil, urlResponse, nil)
            }
        }
    }
    
    private func makeResponse(url: URL, status: Int) -> URLResponse? {
        let urlResponse = HTTPURLResponse(url: url, statusCode: status, httpVersion: "1.1", headerFields: nil)
        
        return urlResponse
    }
}
