//
//  DetailViewController.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/17.
//

import UIKit

final class DetailViewController: UIViewController {
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: imageLayout
        )
        collectionView.isPagingEnabled = false
        collectionView.decelerationRate = .fast
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let imageLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
        let collectionCellWidth = UIScreen.main.bounds.width
        let collectionCellHeight = UIScreen.main.bounds.height * 0.4
        layout.itemSize = CGSize(width: collectionCellWidth, height: collectionCellHeight)
        return layout
    }()
    
    private let nameLabel = UILabel(font: .preferredFont(forTextStyle: .title2))
    private let stockLabel = UILabel(textColor: .systemGray, font: .systemFont(ofSize: 12))
    private let dateLabel = UILabel(textColor: .systemGray, font: .systemFont(ofSize: 12))
    
    private let locationLabel = UILabel(textColor: .systemGray, font: .systemFont(ofSize: 12))
    private let priceLabel = UILabel(font: .systemFont(ofSize: 15))
    private let salePriceLabel = UILabel(font: .systemFont(ofSize: 15))
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 10
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.layer.borderColor = UIColor.systemGray4.cgColor
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

// MARK: - UIConstraint
extension DetailViewController {
    private func setupView() {
        [priceLabel, salePriceLabel].forEach(priceStackView.addArrangedSubview(_:))
        [nameLabel,stockLabel, priceStackView].forEach(mainInfoStackView.addArrangedSubview(_:))
        [locationLabel, dateLabel].forEach(subInfoStackView.addArrangedSubview(_:))
        [mainInfoStackView, subInfoStackView].forEach(infoStackView.addArrangedSubview(_:))
        view.addSubview(infoStackView)
    }
}
