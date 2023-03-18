//
//  UploadImageCell.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/18.
//

import UIKit

protocol UploadImageCellDelegate: AnyObject {
    func uploadImageCell(_ isShowPicker: Bool)
}

final class UploadImageCell: UICollectionViewCell {
    weak var buttonDelegate: UploadImageCellDelegate?

    private let imageStackView = UIStackView(
        axis: .horizontal,
        spacing: 10,
        alignment: .fill,
        distribution: .fillEqually
    )
    
    override func prepareForReuse() {
        self.imageStackView.arrangedSubviews.forEach { view in
            view.removeFromSuperview()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupStackViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Create View
extension UploadImageCell {
    func createButton() {
        let button = UIButton()
        button.tintColor = .label
        button.backgroundColor = .systemGray5
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        imageStackView.addArrangedSubview(button)
    }
    
    func createImageView(data: Data) {
        let imageView = UIImageView(image: UIImage(data: data))
        imageView.contentMode = .scaleToFill
    
        imageStackView.addArrangedSubview(imageView)
    }
}

// MARK: - Action
extension UploadImageCell {
    @objc func addButtonTapped() {
        buttonDelegate?.uploadImageCell(true)
    }
}

// MARK: - Constraints
extension UploadImageCell {
    private func setupView() {
        contentView.addSubview(imageStackView)
    }
    
    private func setupStackViewConstraints() {
        NSLayoutConstraint.activate([
            imageStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}

extension UploadImageCell: UseIdentifiable { }
