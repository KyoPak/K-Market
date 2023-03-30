//
//  NetworkServiceTest.swift
//  K-MarketTests
//
//  Created by parkhyo on 2023/03/29.
//

import XCTest
@testable import K_Market

final class NetworkServiceTest: XCTestCase {
    
    private var networkService: NetworkSevice!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        networkService = DefaultNetworkSevice(session: MockURLSession())
    }

    override func tearDownWithError() throws {
       try super.tearDownWithError()
        networkService = nil
    }
    
    func test_Success() {
        // Given
        let testURLRequest = FetchListRequest(pageNo: 1, itemsPerPage: 10).createRequest()
        let testData = "ServerData".data(using: .utf8)
        
        // When
        networkService.request(testURLRequest) { result in
            switch result {
            case .success(let data):
                // Then
                XCTAssertEqual(testData, data)
            case .failure(_):
                XCTFail("Test Fail")
            }
        }
    }
    
    func test_Fail() {
        // Given
        networkService = DefaultNetworkSevice(session: MockURLSession(requestSuccess: false))
        let testURLRequest = FetchListRequest(pageNo: 1, itemsPerPage: 10).createRequest()
        let testData = "ServerData".data(using: .utf8)
        
        // When
        networkService.request(testURLRequest) { result in
            switch result {
            case .success(_):
                XCTFail("Test Fail")
            case .failure(let error):
                // Then
                XCTAssertEqual(error, NetworkError.networking)
            }
        }
    }
}
