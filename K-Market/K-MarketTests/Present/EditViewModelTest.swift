//
//  EditViewModelTest.swift
//  K-MarketTests
//
//  Created by parkhyo on 2023/03/30.
//

import XCTest
@testable import K_Market

final class EditViewModelTest: XCTestCase {

    private var editViewModel: EditViewModel!
    private var patchProductUseCase: PatchProductUseCase!
    override func setUpWithError() throws {
        try super.setUpWithError()
        patchProductUseCase = MockPatchProductUseCase()
        
        editViewModel = DefaultEditViewModel(
            product: dummy(),
            imagesData: [
                "test01".data(using: .utf8)!,
                "test02".data(using: .utf8)!
            ],
            patchProductUseCase: patchProductUseCase
        )
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        editViewModel = nil
        patchProductUseCase = nil
    }
    
    func dummy() -> Product {
        return Product(
            id: 1,
            vendorId: 1,
            name: "Dummy Prduct",
            description: "This is Dummy Product.",
            thumbnail: "Dummy01",
            currency: .KRW,
            price: .zero,
            bargainPrice: .zero,
            discountedPrice: .zero,
            stock: .zero,
            createdAt: Date(),
            issuedAt: Date(),
            images: [ProductImage(id: 1, url: "Dummy01.com", thumbnailUrl: "Dummy01.com", issuedAt: Date())],
            vendors: nil
        )
    }

    func test_patchProduct() {
        // Given
        editViewModel.setupProduct(
            name: "Test Prduct",
            price: "1000",
            salePrice: nil,
            stock: nil,
            description: "This is Test Product.",
            currencyIndex: 1
        )
        
        // When
        editViewModel.patchProduct { result in
            // Then
            XCTAssertEqual(result, true)
        }
    }
}
