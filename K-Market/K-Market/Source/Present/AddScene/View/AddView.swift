//
//  AddView.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/18.
//

import UIKit

final class AddView: UploadView {
    private let viewModel: AddViewModel
    
    init(viewModel: AddViewModel) {
        self.viewModel = viewModel
        super.init()
        setupLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Method
extension AddView {
    private func setupLabel() {
        locationLabel.text = viewModel.userSubLocale
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
