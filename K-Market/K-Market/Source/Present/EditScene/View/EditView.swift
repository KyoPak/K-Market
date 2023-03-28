//
//  EditView.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/19.
//

import UIKit

final class EditView: UploadView {
    private let viewModel: EditViewModel
    
    init(viewModel: EditViewModel) {
        self.viewModel = viewModel
        super.init()
        setupLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Method
extension EditView {
    private func setupLabel() {
        nameTextField.text = viewModel.product.name
        descriptionTextView.text = viewModel.product.description
        stockTextField.text = String(viewModel.product.stock)
        priceTextField.text = String(viewModel.product.price)
        salePriceTextField.text = String(viewModel.product.discountedPrice)
        currencySegmentedControl.selectedSegmentIndex = viewModel.product.currency == .KRW ? .zero : 1
    }
    
    func packageData() {
        viewModel.setupProduct(
            name: nameTextField.text,
            price: priceTextField.text,
            salePrice: salePriceTextField.text,
            stock: stockTextField.text,
            description: descriptionTextView.text,
            currencyIndex: currencySegmentedControl.selectedSegmentIndex
        )
    }
}
