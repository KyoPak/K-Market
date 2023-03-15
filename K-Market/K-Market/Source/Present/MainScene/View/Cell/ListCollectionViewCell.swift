//
//  ListCollectionViewCell.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/11.
//

import UIKit

final class ListCollectionViewCell: CollectionCell {
    private let detailButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.init(systemName: "chevron.right"), for: .normal)
        button.tintColor = .gray
        return button
    }()
    
    private var priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var stockButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var topLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Constraints
extension ListCollectionViewCell {
    private func setupView() {
        [priceLabel, salePriceLabel].forEach(priceStackView.addArrangedSubview(_:))
        [stockLabel, detailButton].forEach(stockButtonStackView.addArrangedSubview(_:))
        [nameLabel, stockButtonStackView].forEach(topLabelStackView.addArrangedSubview(_:))
        
        [indicatorView, imageView, topLabelStackView, locationLabel, priceStackView].forEach(
            contentView.addSubview(_:)
        )
        
        setupIndicatorConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.2),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            topLabelStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -10),
            topLabelStackView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            topLabelStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            locationLabel.topAnchor.constraint(equalTo: topLabelStackView.bottomAnchor, constant: 2),
            locationLabel.leadingAnchor.constraint(equalTo: topLabelStackView.leadingAnchor),
            
            priceStackView.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 2),
            priceStackView.leadingAnchor.constraint(equalTo: locationLabel.leadingAnchor)
        ])
    }
    
    private func setupIndicatorConstraints() {
        NSLayoutConstraint.activate([
            indicatorView.topAnchor.constraint(equalTo: imageView.topAnchor),
            indicatorView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            indicatorView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            indicatorView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor)
        ])
    }
}

extension ListCollectionViewCell: UseIdentifiable { }
