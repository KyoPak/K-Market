//
//  DetailViewController.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/17.
//

import UIKit

final class DetailViewController: UIViewController {
    weak var coordinator: DetailCoordinator?
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.setup()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.clear()
        coordinator?.didFinish()
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

extension DetailViewController: AlertPresentable {
    private func bindData() {
        viewModel.productImages.bind { [weak self] _ in
            self?.collectionView.reloadData()
        }
        
        viewModel.error.bind { [weak self] error in
            guard let error else { return }
            self?.presentAlert(title: error)
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
            withReuseIdentifier: DetailImageCell.identifier,
            for: indexPath
        ) as? DetailImageCell else {
            let errorCell = UICollectionViewCell()
            return errorCell
        }

        viewModel.fetchImageData(index: indexPath.item) { data in
            cell.uploadImage(data)
        }

        return cell
    }
}

// MARK: - UIConstraint
extension DetailViewController {
    private func setupNavigation() {
        navigationController?.navigationBar.tintColor = .label
        
        let appearance = UINavigationBarAppearance()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        let optionBarButton = UIBarButtonItem(
            barButtonSystemItem: .edit,
            target: self,
            action: #selector(optionButtonTapped)
        )
        
        self.navigationItem.rightBarButtonItem = optionBarButton
    }
    
    @objc func optionButtonTapped() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let editAction = UIAlertAction(title: "수정", style: .default) { _ in
            guard let product = self.viewModel.product.value else { return }
            self.coordinator?.makeEditCoordinator(product: product, imageDatas: self.viewModel.imageDatas)
        }
        
        let deleteAction = UIAlertAction(title: "삭제", style: .default) { [weak self] _ in
            self?.viewModel.delete { result in
                if result {
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        [editAction, deleteAction, cancelAction].forEach(alert.addAction(_:))
        
        present(alert, animated: true)
    }
    
    private func setupView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        view.backgroundColor = .systemBackground
        [collectionView, pageLabel, productInfoView].forEach(view.addSubview(_:))
    }
    
    private func registerCell() {
        collectionView.register(DetailImageCell.self, forCellWithReuseIdentifier: DetailImageCell.identifier)
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
