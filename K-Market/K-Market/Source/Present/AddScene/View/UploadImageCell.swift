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

    private let stackView = UIStackView(
        axis: .horizontal,
        spacing: 10,
        alignment: .fill,
        distribution: .fillEqually
    )
    
    func createButton() -> UIButton {
        let button = UIButton()
        button.tintColor = .label
        button.backgroundColor = .systemGray5
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.addTarget(self, action: #selector(addImageButtonTapped), for: .touchUpInside)
        return button
    }
    
    func createImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }

    override func prepareForReuse() {
        self.stackView.arrangedSubviews.forEach { view in
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

// MARK: - Action
extension UploadImageCell {
    @objc func addImageButtonTapped() {
        buttonDelegate?.uploadImageCell(true)
    }
}

// MARK: - Constraints
extension UploadImageCell {
    private func setupView() {
        contentView.addSubview(stackView)
    }
    
    private func setupStackViewConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}

extension UploadImageCell: UseIdentifiable { }
