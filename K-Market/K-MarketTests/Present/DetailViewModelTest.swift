//
//  DetailViewModelTest.swift
//  K-MarketTests
//
//  Created by parkhyo on 2023/03/27.
//

import XCTest
@testable import K_Market

final class DetailViewModelTest: XCTestCase {

    private var detailViewModel: DetailViewModel!
    private var mockFetchProductDetailUseCase: FetchProductDetailUseCase!
    private var mockFetchLocationUseCase: FetchLocationUseCase!
    private var mockLoadImageUseCase: LoadImageUseCase!
    private var mockDeleteProductUseCase: DeleteProductUseCase!
    private var mockDeleteLocationUseCase: DeleteLocationUseCase!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockFetchProductDetailUseCase = MockFetchProductDetailUseCase()
        mockFetchLocationUseCase = MockFetchLocationUseCase()
        mockLoadImageUseCase = MockLoadImageUseCase()
        mockDeleteProductUseCase = MockDeleteProductUserCase()
        mockDeleteLocationUseCase = MockDeleteLocationUseCase()
        
        detailViewModel = DefaultDetailViewModel(
            id: 10,
            fetchLocationUseCase: mockFetchLocationUseCase,
            fetchProductDetailUseCase: mockFetchProductDetailUseCase,
            loadImageUseCase: mockLoadImageUseCase,
            deleteProductUseCase: mockDeleteProductUseCase,
            deleteLocationUseCase: mockDeleteLocationUseCase
        )
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        detailViewModel = nil
        mockFetchProductDetailUseCase = nil
        mockFetchLocationUseCase = nil
        mockLoadImageUseCase = nil
        mockDeleteProductUseCase = nil
        mockDeleteLocationUseCase = nil
    }
    
    func test_StockText() {
        // Given
        detailViewModel.setup()
        
        let expectation = XCTestExpectation(description: "정상적인 변경")
        
        // When
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let text = self.detailViewModel.customStockText()
            if "수량 : 1K" ==  text {
                // Then
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    func test_PriceText() {
        // Given
        detailViewModel.setup()
        
        let expectation = XCTestExpectation(description: "정상적인 변경")
        
        // When
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let text = self.detailViewModel.customPriceText(self.detailViewModel.product.value?.price)
            if "KRW 1.0K" ==  text {
                // Then
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
}
