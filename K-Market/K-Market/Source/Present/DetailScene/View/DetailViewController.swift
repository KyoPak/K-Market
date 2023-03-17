//
//  DetailViewController.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/17.
//

import UIKit

final class DetailViewController: UIViewController {
    private let viewModel: DetailViewModel
    
    private let separatorLine: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .systemGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraint()
    }
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    private func setupConstraint() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.widthAnchor.constraint(equalTo: safeArea.widthAnchor),
            collectionView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.4),
            collectionView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
                
            infoStackView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10),
            infoStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            infoStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            
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
