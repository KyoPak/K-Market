//
//  UploadView.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/19.
//

import UIKit

// AddView, EditView inherit this View
class UploadView: UIView {
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        let collectionCellWidth = UIScreen.main.bounds.width / 3 - 10
        
        layout.itemSize  = CGSize(width: collectionCellWidth, height: collectionCellWidth)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()

    let locationLabel = UILabel(font: .systemFont(ofSize: 15))
    
    let nameTextField = UITextField(
        placeholder: Constant.name,
        borderStyle: .roundedRect
    )
    
    let priceTextField = UITextField(
        placeholder: Constant.price,
        borderStyle: .roundedRect,
        keyboardType: .numberPad
    )

    let salePriceTextField = UITextField(
        placeholder: Constant.salePrice,
        borderStyle: .roundedRect,
        keyboardType: .numberPad
    )
    
    let stockTextField = UITextField(
        placeholder: Constant.stock,
        borderStyle: .roundedRect,
        keyboardType: .numberPad
    )
    
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.keyboardType = UIKeyboardType.default
        textView.returnKeyType = .done
        textView.font = .systemFont(ofSize: 15)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    let currencySegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["KRW", "USD"])
        segmentedControl.selectedSegmentIndex = .zero
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        return segmentedControl
    }()
    
    let priceLocationStackView = UIStackView(
        axis: .horizontal,
        spacing: 10,
        alignment: .fill,
        distribution: .fill
    )
    
    let salePriceSegmentStackView = UIStackView(
        axis: .horizontal,
        spacing: 10,
        alignment: .fill,
        distribution: .fillProportionally
    )
    
    let productStackView = UIStackView(
        axis: .vertical,
        spacing: 10,
        alignment: .fill,
        distribution: .fill
    )
    
    init() {
        super.init(frame: .zero)
        setupView()
        registerCell()
        setupConstraints()
        registerTextFieldDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UITextFieldDelegate & UITextViewDelegate
extension UploadView: UITextFieldDelegate, UITextViewDelegate {
    func registerTextFieldDelegate() {
        nameTextField.delegate = self
        priceTextField.delegate = self
        salePriceTextField.delegate = self
        stockTextField.delegate = self
        descriptionTextView.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if nameTextField.text != "" {
            priceTextField.becomeFirstResponder()
            return true
        }
        
        return false
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        descriptionTextView.resignFirstResponder()
        
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameTextField.resignFirstResponder()
        priceTextField.resignFirstResponder()
        salePriceTextField.resignFirstResponder()
        stockTextField.resignFirstResponder()
        descriptionTextView.resignFirstResponder()
    }
    
    func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange,
        replacementText text: String
    ) -> Bool {
        return descriptionTextView.text.count <= Constant.maxText
    }
}

// MARK: - UI Constraints
extension UploadView {
    func setupView() {
        backgroundColor = .systemBackground
        [priceTextField, locationLabel].forEach(priceLocationStackView.addArrangedSubview(_:))
        [salePriceTextField,currencySegmentedControl]
            .forEach(salePriceSegmentStackView.addArrangedSubview(_:))
        [nameTextField, priceLocationStackView, salePriceSegmentStackView, stockTextField]
            .forEach(productStackView.addArrangedSubview(_:))
        
        [collectionView, productStackView, descriptionTextView].forEach(addSubview(_:))
    }
    
    func registerCell() {
        collectionView.register(UploadImageCell.self, forCellWithReuseIdentifier: UploadImageCell.identifier)
    }
    
    func setupConstraints() {
        let safeArea = safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
            collectionView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.2),
            
            productStackView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 5),
            productStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            productStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
            
            descriptionTextView.topAnchor.constraint(equalTo: productStackView.bottomAnchor, constant: 10),
            descriptionTextView.leadingAnchor.constraint(equalTo: productStackView.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: productStackView.trailingAnchor),
            descriptionTextView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -10)
        ])
    }
}

extension UploadView {
    private enum Constant {
        static let name = "글 제목"
        static let price = "가격"
        static let salePrice = "할인 금액(선택 사항)"
        static let stock = "수량"
        static let maxText = 1000
    }
}
