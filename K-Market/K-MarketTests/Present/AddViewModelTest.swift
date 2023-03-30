//
//  AddViewModelTest.swift
//  K-MarketTests
//
//  Created by parkhyo on 2023/03/30.
//

import XCTest
@testable import K_Market

final class AddViewModelTest: XCTestCase {

    private var addViewModel: AddViewModel!
    private var postProductUseCase: PostProductUseCase!
    private var postLocationUseCase: PostLocationUseCase!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        postProductUseCase = MockPostProductUseCase()
        postLocationUseCase = MockPostLocationUseCase()
        
        addViewModel = DefaultAddViewModel(
            locale: "성남시",
            subLocale: "정자동",
            postProductUseCase: postProductUseCase,
            postLocationUseCase: postLocationUseCase
        )
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        addViewModel = nil
        postProductUseCase = nil
        postLocationUseCase = nil
    }
    
    func test_setupImageData() {
        // Given
        addViewModel.addImageData("testImage01".data(using: .utf8))
        addViewModel.addImageData("testImage02".data(using: .utf8))
        
        // When
        let imageCount = addViewModel.imageDatas.value.count
        
        // Then
        XCTAssertEqual(2, imageCount)
    }
    
    func test_fetchImageData() {
        // Given
        let testData1 = "testImage01".data(using: .utf8)
        let testData2 = "testImage02".data(using: .utf8)
                                          
        addViewModel.addImageData(testData1)
        addViewModel.addImageData(testData2)
        
        let imageCount = addViewModel.imageDatas.value.count
        
        XCTAssertEqual(2, imageCount)
        
        // When
        let firstImageData = addViewModel.fetchImageData(index: 0)
        let secondImageData = addViewModel.fetchImageData(index: 1)
        
        // Then
        XCTAssertEqual(testData1, firstImageData)
        XCTAssertEqual(testData2, secondImageData)
    }
    
    
    func test_Post_ProductData() {
        // Given
        addViewModel.setupProduct(
            name: "Test Product",
            price: "1000",
            salePrice: "0",
            stock: "0",
            description: "This Test Product.",
            currencyIndex: 1
        )
        
        addViewModel.addImageData("testImage01".data(using: .utf8))
        addViewModel.addImageData("testImage02".data(using: .utf8))
        
        // When
        addViewModel.postProduct { error in
            // Then
            XCTAssertEqual(error, nil)
        }
    }
}
