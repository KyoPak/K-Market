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
    
    private let separatorLine: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .systemGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nameLabel = UILabel(font: .preferredFont(forTextStyle: .title2))
    private let stockLabel = UILabel(textColor: .systemGray, font: .systemFont(ofSize: 12))
    private let dateLabel = UILabel(textColor: .systemGray, font: .systemFont(ofSize: 12))
    
    private let locationLabel = UILabel(textColor: .systemGray, font: .systemFont(ofSize: 12))
    private let priceLabel = UILabel(font: .systemFont(ofSize: 15))
    private let salePriceLabel = UILabel(font: .systemFont(ofSize: 15))
    
    private let descriptionView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
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
        axis: .vertical,
        spacing: 5,
        alignment: .leading,
        distribution: .fill
    )
    
    private let infoStackView = UIStackView(
        axis: .horizontal,
        spacing: 1,
        alignment: .leading,
        distribution: .fill
    )
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupView()
        setupConstraint()
        bindData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Bind
extension ProductInfoView {
    private func bindData() {
        viewModel.product.bind { [weak self] data in
            self?.nameLabel.text = data?.name
            self?.descriptionView.text = data?.description ?? ""
            
            self?.dateLabel.text = self?.viewModel.customDate()
            self?.stockLabel.text = self?.viewModel.customStockText()
            self?.priceLabel.text = self?.viewModel.customPriceText(data?.price)
            self?.salePriceLabel.text = self?.viewModel.customPriceText(data?.bargainPrice)
        }
        
        viewModel.productLocale.bind { [weak self] locale  in
            self?.locationLabel.text = locale
        }
    }
}

// MARK: - UIConstraint
extension ProductInfoView {
    private func setupView() {
        backgroundColor = .systemBackground
        
        [priceLabel, salePriceLabel].forEach(priceStackView.addArrangedSubview(_:))
        [nameLabel,stockLabel, priceStackView].forEach(mainInfoStackView.addArrangedSubview(_:))
        [locationLabel, dateLabel].forEach(subInfoStackView.addArrangedSubview(_:))
        [mainInfoStackView, subInfoStackView].forEach(infoStackView.addArrangedSubview(_:))
        
        [infoStackView, separatorLine, descriptionView].forEach(addSubview(_:))
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraint() {
        let safeArea = safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            infoStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            infoStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            infoStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            infoStackView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.3),
            
            separatorLine.topAnchor.constraint(equalTo: infoStackView.bottomAnchor, constant: 3),
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            separatorLine.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.8),
            separatorLine.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            
            descriptionView.topAnchor.constraint(equalTo: separatorLine.bottomAnchor, constant: 10),
            descriptionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            descriptionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
            descriptionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -10),
        ])
    }
}
