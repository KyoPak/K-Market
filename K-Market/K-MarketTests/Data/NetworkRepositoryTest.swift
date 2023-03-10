//
//  K_MarketTests.swift
//  K-MarketTests
//
//  Created by parkhyo on 2023/03/10.
//

import XCTest
@testable import K_Market

class MockNetworkService: NetworkSevice {
    func request(
        _ request: URLRequest?,
        completion: @escaping (Result<Data, K_Market.NetworkError>) -> Void
    ) {
        // 요청한 request URL String값에 대한 Data를 전달
        guard let urlText = request?.url?.description, let data =  urlText.data(using: .utf8)
        else {
            completion(.failure(NetworkError.networking))
            return
        }
        completion(.success(data))
    }
}

final class NetworkRepositoryTest: XCTestCase {
    
    private var networkRepository: NetworkRepository!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        networkRepository = DefaultNetworkRepository(networkService: MockNetworkService())
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        networkRepository = nil
    }
    
    func test_request() {
        // Given
        let customRequest = ListFetchRequest(pageNo: 10, itemsPerPage: 10)
        guard let expectData = customRequest.url?.description.data(using: .utf8) else { return }
        
        // When
        let expectation = XCTestExpectation(description: "동일한 Request Data")
        
        networkRepository.request(customRequest: customRequest) { result in
            switch result {
            case .success(let data):
                if expectData == data {
                    // Then
                    expectation.fulfill()
                }
            case .failure(_):
                XCTFail("Fail Test")
            }
        }
        
        wait(for: [expectation], timeout: 0.5)
    }
}
