//
//  WrapperDataRepositoryTest.swift
//  K-MarketTests
//
//  Created by parkhyo on 2023/03/25.
//

import XCTest
@testable import K_Market

final class MockCacheService: CacheService {
    private var datas: [NSString : WrapperData] = [
        "testID" : WrapperData(data:  "TestData".data(using: .utf8)!)
    ]
    
    func fetch(key: NSString) -> K_Market.WrapperData? {
        return datas[key]
    }
    
    func save(key: NSString, wrapperData: K_Market.WrapperData) {
        datas[key] = wrapperData
    }
}

final class WrapperDataRepositoryTest: XCTestCase {
    
    private var mockCacheService: CacheService!
    private var wrapperDataRepository: WrapperDataRepository!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockCacheService = MockCacheService()
        wrapperDataRepository = DefaultWrapperDataRepository(cacheService: mockCacheService)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        wrapperDataRepository = nil
        mockCacheService = nil
    }
    
    func test_fetchData() {
        // Given
        let testID = "testID"
        let testData = WrapperData(data:  "TestData".data(using: .utf8)!)
        
        // When
        let data = wrapperDataRepository.fetch(thumbnail: testID)
        guard let data = data else {
            XCTFail("Test Fail")
            return
        }
        
        // Then
        XCTAssertEqual(testData.data, data.data)
    }
    
    
    func test_saveData() {
        // Given
        let testID = "testSaveID"
        let testData = WrapperData(data: "SaveTestData".data(using: .utf8)!)
        
        // When
        wrapperDataRepository.save(thumbnail: testID, wrapperData: testData)
        
        
        // Then
        let data = wrapperDataRepository.fetch(thumbnail: testID)
        guard let data = data else {
            XCTFail("Test Fail")
            return
        }
        
        XCTAssertEqual(data.data, testData.data)
    }
    
}
