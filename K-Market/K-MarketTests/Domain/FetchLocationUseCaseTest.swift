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
        
        // When
        fetchLocationUseCase.fetch(id: testID) { datas in
            // Then
            XCTAssertEqual(datas?.id, 1)
        }
    }
}
