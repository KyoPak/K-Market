//
//  PostLocationUseCaseTest.swift
//  K-MarketTests
//
//  Created by parkhyo on 2023/03/24.
//

import XCTest
@testable import K_Market

final class PostLocationUseCaseTest: XCTestCase {
    
    private var postLocationUseCase: PostLocationUseCase!
    private var mockLocationRepository: LocationRepository!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockLocationRepository = MockLocationRepository()
        
        postLocationUseCase = DefaultPostLocationUseCase(locationRepository: mockLocationRepository)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        postLocationUseCase = nil
        mockLocationRepository = nil
    }
    
    func test_postLocationData() {
        // Given
        let testID = 6
        
        let expectation = XCTestExpectation(description: "동일한 ID")
        postLocationUseCase.add(id: testID, locale: "신규 Data", subLocale: "신규 Data")
        
        // When
        mockLocationRepository.load(testID, completion: { data in
            if data?.id == testID {
                // Then
                expectation.fulfill()
            } else {
                XCTFail("Test Fail")
            }
        })
        
        wait(for: [expectation], timeout: 0.5)
    }
}
