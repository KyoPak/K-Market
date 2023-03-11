//
//  GridCollectionViewCell.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/11.
//

import UIKit

final class GridCollectionViewCell: CollectionCell {
    private var labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var productStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private func setupUIComponent() {
        imageView.contentMode = .scaleAspectFill
        
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        
        priceLabel.font = UIFont.preferredFont(forTextStyle: .body)
        salePriceLabel.font = UIFont.preferredFont(forTextStyle: .body)
        stockLabel.font = UIFont.preferredFont(forTextStyle: .body)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupUIComponent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Constraints
extension GridCollectionViewCell {
    private func setupUI() {
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 10
        contentView.layer.borderColor = UIColor.gray.cgColor
        setupView()
    }
    
    private func setupView() {
        [priceLabel, salePriceLabel].forEach(labelStackView.addArrangedSubview(_:))
        [nameLabel, locationLabel, labelStackView, stockLabel].forEach(
            productStackView.addArrangedSubview(_:)
        )
        [imageView, productStackView, indicatorView].forEach(contentView.addSubview(_:))
        
        setupStackViewConstraints()
        setupIndicatorConstraints()
    }

    private func setupStackViewConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.4),
            
            nameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.bottomAnchor.constraint(equalTo: productStackView.topAnchor, constant: -10),
            
            productStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            productStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    private func setupIndicatorConstraints() {
        NSLayoutConstraint.activate([
            indicatorView.topAnchor.constraint(equalTo: imageView.topAnchor),
            indicatorView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            indicatorView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            indicatorView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor)
        ])
    }
}

extension GridCollectionViewCell: UseIdentifiable { }
