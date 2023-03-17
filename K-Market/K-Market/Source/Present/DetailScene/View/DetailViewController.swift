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
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = .zero
        layout.minimumInteritemSpacing = .zero
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        
        collectionView.isPagingEnabled = true
        collectionView.decelerationRate = .fast
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let pageLabel = UILabel(font: .preferredFont(forTextStyle: .caption1))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        bindData()
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

extension DetailViewController {
    private func bindData() {
        viewModel.imageDatas.bind { [weak self] datas in
            self?.collectionView.reloadData()
        }
    }
    
    private func changePageLabel(page: Int, totalPage: Int) {
        pageLabel.text = "\(page)/\(totalPage)"
    }
}

extension DetailViewController: UICollectionViewDelegateFlowLayout {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let productImagesCount = viewModel.fetchProductImageCount()
        
        for cell in collectionView.visibleCells {
            let indexPath = collectionView.indexPath(for: cell)
            guard let currentIndex = indexPath?.item else { return }

            changePageLabel(page: currentIndex + 1, totalPage: productImagesCount)
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return collectionView.frame.size
    }
}

// MARK: - Extension UICollectionView
extension DetailViewController: UICollectionViewDelegate {
    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        let estimatedIndex = scrollView.contentOffset.x / cellWidthIncludingSpacing
        
        let tempCG: CGFloat
        if velocity.x > .zero {
            tempCG = ceil(estimatedIndex)
        } else if velocity.x < .zero {
            tempCG = floor(estimatedIndex)
        } else {
            tempCG = round(estimatedIndex)
        }
        
        targetContentOffset.pointee = CGPoint(x: tempCG * cellWidthIncludingSpacing, y: .zero)
    }
}

extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let imageCount = viewModel.fetchProductImageCount()
        changePageLabel(page: 1, totalPage: imageCount)
        return imageCount
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ImageCollectionViewCell.identifier,
            for: indexPath
        ) as? ImageCollectionViewCell else {
            let errorCell = UICollectionViewCell()
            return errorCell
        }

        viewModel.fetchImageData(index: indexPath.item) { data in
            DispatchQueue.main.async {
                cell.uploadImage(data)
            }
        }

        return cell
    }
}

// MARK: - UIConstraint
extension DetailViewController {
    private func setupNavigation() {
        navigationController?.navigationBar.tintColor = .label
    }
    
    private func setupView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        view.backgroundColor = .systemBackground
        [collectionView, pageLabel, productInfoView].forEach(view.addSubview(_:))
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
            collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            collectionView.widthAnchor.constraint(equalTo: safeArea.widthAnchor),
            collectionView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.4),
            collectionView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
                
            pageLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 2),
            pageLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            
            productInfoView.topAnchor.constraint(equalTo: pageLabel.bottomAnchor),
            productInfoView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            productInfoView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            productInfoView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: 10)
        ])
    }
}
