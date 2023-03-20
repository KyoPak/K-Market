//
//  DetailImageCell.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/17.
//

import UIKit

final class DetailImageCell: UICollectionViewCell {
    let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func uploadImage(_ data: Data?) {
        guard let data = data else { return }
        productImageView.image = UIImage(data: data)
    }
}

// MARK: - UIConstraints
extension DetailImageCell {
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

extension DetailImageCell: UseIdentifiable { }
