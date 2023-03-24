//
//  DeleteLocationUseCaseTest.swift
//  K-MarketTests
//
//  Created by parkhyo on 2023/03/24.
//

import XCTest
@testable import K_Market

final class DeleteLocationUseCaseTest: XCTestCase {

    private var deleteLocationUseCase: DeleteLocationUseCase!
    private var mockLocationRepository: LocationRepository!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockLocationRepository = MockLocationRepository()
        
        deleteLocationUseCase = DefaultDeleteLocationUseCase(locationRepository: mockLocationRepository)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        deleteLocationUseCase = nil
        mockLocationRepository = nil
    }
    
    func test_deleteLocationData() {
        // Given
        let testID = 5
        
        let expectation = XCTestExpectation(description: "데이터 삭제 확인")
        deleteLocationUseCase.delete(id: testID)
        
        // When
        mockLocationRepository.load(testID, completion: { data in
            if data == nil {
                // Then
                expectation.fulfill()
            } else {
                XCTFail("Test Fail")
            }
        })
        
        wait(for: [expectation], timeout: 0.5)
    }
}
