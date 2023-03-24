//
//  FetchLocationUseCaseTest.swift
//  K-MarketTests
//
//  Created by parkhyo on 2023/03/24.
//

import XCTest
@testable import K_Market

final class FetchLocationUseCaseTest: XCTestCase {

    private var fetchLocationUseCase: FetchLocationUseCase!
    private var mockLocationRepository: LocationRepository!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockLocationRepository = MockLocationRepository()
        
        fetchLocationUseCase = DefaultFetchLocationDataUseCase(locationRepository: mockLocationRepository)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        fetchLocationUseCase = nil
        mockLocationRepository = nil
    }
    
    func test_fetchLocationData() {
        // Given
        let testID = 1
        
        let expectation = XCTestExpectation(description: "동일한 ID")
        // When
        fetchLocationUseCase.fetch(id: testID) { datas in
            if datas?.id == 1 {
                // Then
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 0.5)
    }
}
