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
        
        DispatchQueue.main.async {
            // When
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
        
        DispatchQueue.main.async {
            // When
            let text = self.detailViewModel.customPriceText(self.detailViewModel.product.value?.price)
            if "KRW 1.0K" ==  text {
                // Then
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    func test_setup() {
        // Given
        let productID = 10
        let productName = "test10"
        let productThumbnail = "test10"
        let productPrice: Double = 1000
        
        let expectation = XCTestExpectation(description: "동일한 데이터")
        
        // When
        detailViewModel.setup()
        DispatchQueue.main.async {
            let data = self.detailViewModel.product.value
            // Then
            XCTAssertEqual(productID, data?.id)
            XCTAssertEqual(productName, data?.name)
            XCTAssertEqual(productThumbnail, data?.thumbnail)
            XCTAssertEqual(productPrice, data?.price)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_deleteProduct() {
        // Given
        detailViewModel.setup()
        
        let expectation = XCTestExpectation(description: "성공적인 삭제")
        
        DispatchQueue.main.async {
            // When
            self.detailViewModel.delete { result in
                // Then
                XCTAssertEqual(result, true)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func test_fetchImage() {
        // Given
        detailViewModel.setup()
        let testImageIndex = 1
        let testImageData = "testImage01".data(using: .utf8)!
        
        let expectation = XCTestExpectation(description: "이미지 데이터 일치 확인")
        
        DispatchQueue.main.async {
            // When
            self.detailViewModel.fetchImageData(index: testImageIndex) { data in
                // Then
                XCTAssertEqual(data, testImageData)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
}
