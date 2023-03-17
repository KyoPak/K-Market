//
//  ImageCollectionViewCell.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/17.
//

import UIKit

final class ImageCollectionViewCell: UICollectionViewCell {
    let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    func uploadImage(_ image: UIImage) {
        productImageView.image = image
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UIConstraints
extension ImageCollectionViewCell {
    private func setupView() {
        contentView.addSubview(productImageView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            productImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}

extension ImageCollectionViewCell: UseIdentifiable { }
