//
//  DetailViewController.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/17.
//

import UIKit

final class DetailViewController: UIViewController {
    private let viewModel: DetailViewModel
    private let productInfoView: ProductInfoView
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraint()
        registerCell()
    }
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        self.productInfoView = ProductInfoView(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UIConstraint
extension DetailViewController {
    private func setupView() {
        view.backgroundColor = .systemBackground
        [collectionView, productInfoView].forEach(view.addSubview(_:))
    }
    
    private func registerCell() {
        collectionView.register(
            ImageCollectionViewCell.self,
            forCellWithReuseIdentifier: ImageCollectionViewCell.identifier
        )
    }
    
    private func setupConstraint() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.widthAnchor.constraint(equalTo: safeArea.widthAnchor),
            collectionView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.4),
            collectionView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
                
            productInfoView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            productInfoView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            productInfoView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            productInfoView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: 10)
        ])
    }
}
