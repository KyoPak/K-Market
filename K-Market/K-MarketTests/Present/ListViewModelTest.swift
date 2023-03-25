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
}
