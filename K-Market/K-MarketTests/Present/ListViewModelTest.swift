//
//  ListViewModelTest.swift
//  K-MarketTests
//
//  Created by parkhyo on 2023/03/25.
//

import XCTest
@testable import K_Market

final class ListViewModelTest: XCTestCase {
    private var listViewModel: ListViewModel!
    private var mockFetchUseCase: FetchProductListUseCase!
    private var mockLoadImageUseCase: LoadImageUseCase!
    private var mockFetchLocationUseCase: FetchLocationUseCase!
    private var mockCheckWrapperUseCase: CheckWrapperDataUseCase!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockFetchUseCase = MockFetchUseCase()
        mockLoadImageUseCase = MockLoadImageUseCase()
        mockCheckWrapperUseCase = MockCheckWrapperDataUseCase()
        mockFetchLocationUseCase = MockFetchLocationUseCase()
        
        listViewModel = DefaultListViewModel(
            fetchUseCase: mockFetchUseCase,
            loadImageUseCase: mockLoadImageUseCase,
            fetchLocationUseCase: mockFetchLocationUseCase,
            checkWrapperDataUseCase: mockCheckWrapperUseCase
        )
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        listViewModel = nil
        mockFetchUseCase = nil
        mockLoadImageUseCase = nil
        mockCheckWrapperUseCase = nil
        mockFetchLocationUseCase = nil
    }
    
    func test_setUserLocation() {
        // Given, When
        let testLocale = "TestLocale"
        let subLocale = "TestSubLocale"
        listViewModel.setUserLocation(locale: testLocale, subLocale: subLocale)
        
        // Then
        XCTAssertEqual(listViewModel.userLocale, testLocale)
        XCTAssertEqual(listViewModel.userSubLocale.value, subLocale)
    }
    
    func test_setLayoutType() {
        // When
        listViewModel.setLayoutType(layoutIndex: 0)

        // Then
        XCTAssertEqual(listViewModel.layoutStatus.value, .list)
    }
    
    func test_fetchData() {
        // When
        listViewModel.fetchProductList()
        
        let expectation = XCTestExpectation(description: "ProductList Fetch")
        DispatchQueue.main.async {
            // Then
            XCTAssertEqual(self.listViewModel.recentProductList.value.count, 5)
            XCTAssertEqual(self.listViewModel.productList.value.count, 15)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    func test_clearData() {
        // Given
        listViewModel.fetchProductList()
        
        let expectation = XCTestExpectation(description: "Clear Data")
        
        DispatchQueue.main.async {
            XCTAssertEqual(self.listViewModel.recentProductList.value.count, 5)
            XCTAssertEqual(self.listViewModel.productList.value.count, 15)
            
            // When
            self.listViewModel.clear()
            // Then
            XCTAssertEqual(self.listViewModel.recentProductList.value.count, .zero)
            XCTAssertEqual(self.listViewModel.productList.value.count, .zero)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}
