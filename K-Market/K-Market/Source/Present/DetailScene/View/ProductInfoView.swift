//
//  ProductInfoView.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/17.
//

import UIKit

// MARK: - Product Info View (Name, Price, Location,Stock, Date, Description)

final class ProductInfoView: UIView {
    private let viewModel: DetailViewModel
    
    private let nameLabel = UILabel(font: .preferredFont(forTextStyle: .title1))
    private let stockLabel = UILabel(textColor: .systemGray, font: .systemFont(ofSize: 15))
    private let dateLabel = UILabel(textColor: .systemGray, font: .systemFont(ofSize: 12))
    
    private let locationLabel = UILabel(textColor: .systemGray, font: .systemFont(ofSize: 12))
    private let priceLabel = UILabel(font: .preferredFont(forTextStyle: .title3))
    private let salePriceLabel = UILabel(font: .preferredFont(forTextStyle: .title3))
    
    private let descriptionView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let topSeparatorLine: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .systemGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let bottomSeparatorLine: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .systemGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let priceStackView = UIStackView(
        axis: .horizontal,
        spacing: 5,
        alignment: .leading,
        distribution: .fill
    )
    
    private let mainInfoStackView = UIStackView(
        axis: .vertical,
        spacing: 5,
        alignment: .leading,
        distribution: .fill
    )
    
    private let subInfoStackView = UIStackView(
        axis: .horizontal,
        spacing: 5,
        alignment: .leading,
        distribution: .fill
    )
    
    private let infoStackView = UIStackView(
        axis: .horizontal,
        spacing: 1,
        alignment: .center,
        distribution: .fill
    )
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupView()
        setupConstraint()
        bindData()
        clearPriceLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Bind
extension ProductInfoView {
    private func bindData() {
        viewModel.product.bind { [weak self] data in
            self?.clearPriceLabel()
            
            self?.nameLabel.text = data?.name
            self?.dateLabel.text = self?.viewModel.customDate()
            self?.descriptionView.text = data?.description ?? ""
            self?.stockLabel.text = self?.viewModel.customStockText()
            self?.priceLabel.text = self?.viewModel.customPriceText(data?.price)
            self?.salePriceLabel.text = self?.viewModel.customPriceText(data?.bargainPrice)
            
            data?.discountedPrice == .zero ? self?.salePriceLabel.isHidden = true : self?.changePriceLabel()
        }
        
        viewModel.productLocale.bind { [weak self] locale in
            self?.locationLabel.text = locale
        }
    }
}

// MARK: - UIConstraint
extension ProductInfoView {
    private func setupView() {
        backgroundColor = .systemBackground
        [priceLabel, salePriceLabel].forEach(priceStackView.addArrangedSubview(_:))
        [locationLabel, dateLabel].forEach(subInfoStackView.addArrangedSubview(_:))
        [nameLabel, subInfoStackView, priceStackView].forEach(mainInfoStackView.addArrangedSubview(_:))
        [mainInfoStackView, stockLabel].forEach(infoStackView.addArrangedSubview(_:))
                
        [infoStackView, topSeparatorLine, descriptionView, bottomSeparatorLine].forEach(addSubview(_:))
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func changePriceLabel() {
        priceLabel.textColor = .systemRed
        priceLabel.applyStrikeThroughStyle()
    }
    
    private func clearPriceLabel() {
        salePriceLabel.isHidden = false
        priceLabel.textColor = .black
        priceLabel.attributedText = .none
    }
    
    private func setupConstraint() {
        let safeArea = safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            infoStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            infoStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            infoStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            infoStackView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.2),
            
            topSeparatorLine.topAnchor.constraint(equalTo: infoStackView.bottomAnchor, constant: 5),
            topSeparatorLine.heightAnchor.constraint(equalToConstant: 1),
            topSeparatorLine.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.9),
            topSeparatorLine.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            
            descriptionView.topAnchor.constraint(equalTo: topSeparatorLine.bottomAnchor, constant: 10),
            descriptionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            descriptionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
            descriptionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20),
            
            bottomSeparatorLine.topAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: 5),
            bottomSeparatorLine.heightAnchor.constraint(equalToConstant: 1),
            bottomSeparatorLine.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.9),
            bottomSeparatorLine.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
        ])
    }
}
