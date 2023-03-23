//
//  SectionHeaderView.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/23.
//

import UIKit

final class SectionHeaderView: UICollectionReusableView {
    private let titleLabel = UILabel(font: .preferredFont(forTextStyle: .headline))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }
    
    func apply(_ section: Int) {
        if section == .zero {
            titleLabel.text = Constant.bannerTitle
        } else {
            titleLabel.text = Constant.mainTitle
        }
    }
}

extension SectionHeaderView {
    private func setupView() {
        addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        let safeArea = safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor),
            titleLabel.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.5),
            titleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -5)
        ])
    }
}

extension SectionHeaderView {
    private enum Constant {
        static let bannerTitle = "최신 상품🔥"
        static let mainTitle = "전체 상품🍀"
    }
}
