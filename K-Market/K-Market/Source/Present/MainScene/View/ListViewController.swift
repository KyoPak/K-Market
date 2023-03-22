//
//  ListViewController.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/09.
//

import UIKit
import CoreLocation

enum CollectionType: Int {
    case list
    case grid
}

final class ListViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, UniqueProduct>
    typealias SnapShot = NSDiffableDataSourceSnapshot<Section, UniqueProduct>
    
    enum Section: Int {
        case banner
        case main
    }
    
    weak var coordinator: ListCoordinator?
    
    private lazy var dataSource = configureDataSource()
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: collectionViewLayoutChange(type: .list)
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    private let headerView: HeaderView
    private let viewModel: ListViewModel
    private var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        setupNavigation()
        setupView()
        registerCell()
        setupConstraint()
        setupCoreLocationAuthority()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applySectionSnapshot()
        viewModel.clear()
        viewModel.fetchProductList()
    }
    
    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
        headerView = HeaderView(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
        collectionView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = viewModel.productList.value[indexPath.item].product.id
        coordinator?.makeDetailCoordinator(id: id)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let collectionViewContentSizeY = scrollView.contentSize.height
        let contentOffsetY = scrollView.contentOffset.y
        let heightRemainBottomHeight = collectionViewContentSizeY - contentOffsetY
        let frameHeight = scrollView.frame.size.height
        
        if heightRemainBottomHeight < frameHeight {
            viewModel.fetchProductList()
        }
    }
}

// MARK: - Action
extension ListViewController {
    @objc private func addButtonTapped() {
        coordinator?.makeAddCoordinator(locale: viewModel.userLocale, subLocale: viewModel.userSubLocale.value)
    }
}

// MARK: - Bind
extension ListViewController: AlertPresentable {
    func bindData() {
        viewModel.productList.bind { [weak self] datas in
            DispatchQueue.main.async {
                self?.applyMainSnapshot(data: datas)
            }
        }
        
        viewModel.recentProductList.bind { [weak self] datas in
            DispatchQueue.main.async {
                self?.applyBannerSnapshot(data: datas)
            }
        }
        
        viewModel.layoutStatus.bind { [weak self] collectionType in
            guard let self = self else { return }
            self.collectionView.collectionViewLayout = self.createLayout()
            self.collectionView.reloadData()
        }
        
        viewModel.error.bind { [weak self] error in
            guard let error else { return }
            self?.presentAlert(title: error)
        }
    }
}

// MARK: - DataSource and SnapShot
extension ListViewController {
    private func createLayout() -> UICollectionViewLayout {
        
        let sectionProvider = { [weak self] (
            sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment
        ) -> NSCollectionLayoutSection? in
            
            guard let layoutStatus = self?.viewModel.layoutStatus.value else{ return  nil }
            guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }
            
            var applySection: NSCollectionLayoutSection
                                                                                    
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            if sectionKind == .banner {
                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(0.4)
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                applySection = NSCollectionLayoutSection(group: group)
                applySection.interGroupSpacing = .zero
                
                applySection.orthogonalScrollingBehavior = .groupPagingCentered
                
                return applySection
                
            } else if sectionKind == .main {
                switch layoutStatus {
                case .list:
                    let groupSize = NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .fractionalHeight(1 / 8)
                    )
                    
                    let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                    let section = NSCollectionLayoutSection(group: group)
                    
                    applySection = section
                case .grid:
                    let groupSize = NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .fractionalHeight(1 / 2.5)
                    )
                    let group = NSCollectionLayoutGroup.horizontal(
                        layoutSize: groupSize, subitem: item, count: 2
                    )
                    let spacing = CGFloat(10)
                    group.interItemSpacing = .fixed(spacing)
                    
                    let section = NSCollectionLayoutSection(group: group)
                    section.interGroupSpacing = 10
                    
                    applySection = section
                }
                return applySection
            }
            return nil
        }
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
    
    
    private func configureDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, data in
            
            guard let section = Section(rawValue: indexPath.section) else { return UICollectionViewCell() }
            
            if section == .banner {
                guard let bannerCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: BannerCollectionViewCell.identifier,
                    for: indexPath
                ) as? BannerCollectionViewCell
                else {
                    let errorCell = UICollectionViewCell()
                    return errorCell
                }
                
                self.viewModel.loadImage(index: indexPath.item) { data in
                    if indexPath == collectionView.indexPath(for: bannerCell) {
                        bannerCell.uploadImage(data)
                    }
                }
                
                return bannerCell
                
            } else {
                var cell: CollectionCell
                
                switch self.viewModel.layoutStatus.value {
                case .list:
                    guard let listCell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: ListCollectionViewCell.identifier,
                        for: indexPath
                    ) as? ListCollectionViewCell
                    else {
                        let errorCell = UICollectionViewCell()
                        return errorCell
                    }
                    cell = listCell
                case .grid:
                    guard let gridCell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: GridCollectionViewCell.identifier,
                        for: indexPath
                    ) as? GridCollectionViewCell
                    else {
                        let errorCell = UICollectionViewCell()
                        return errorCell
                    }
                    cell = gridCell
                }
                
                let cellViewModel = DefaultProductCellViewModel(
                    product: data.product,
                    fetchLocationUseCase: self.viewModel.fetchLocationUseCase
                )
                
                cell.indicatorView.startAnimating()
                cell.setupViewModel(cellViewModel)
                cell.setupBind()
                
                self.viewModel.loadImage(index: indexPath.item) { data in
                    if indexPath == collectionView.indexPath(for: cell) {
                        cell.setupImage(data: data)
                    }
                }
                
                return cell
            }
        }
        
        return dataSource
    }
    
    private func applySectionSnapshot() {
        var snapshot = SnapShot()
        snapshot.appendSections([.banner, .main])
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func applyMainSnapshot(data: [UniqueProduct], animatingDifferences: Bool = true) {
        var mainSnapshot = NSDiffableDataSourceSectionSnapshot<UniqueProduct>()
        mainSnapshot.append(data)
        dataSource.apply(mainSnapshot, to: .main, animatingDifferences: false)
    }
    
    private func applyBannerSnapshot(data: [UniqueProduct], animatingDifferences: Bool = true) {
        var bannerSnapshot = NSDiffableDataSourceSectionSnapshot<UniqueProduct>()
        bannerSnapshot.append(data)
        dataSource.apply(bannerSnapshot, to: .banner, animatingDifferences: false)
    }
}

// MARK: - Location Alert
extension ListViewController {
    private func presentLocationAlert() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let allowAction = UIAlertAction(title: Constant.allow, style: .default) { _ in
            guard let settingURL = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(settingURL)
        }
        
        let cancelAction = UIAlertAction(title: Constant.reject, style: .cancel)
        [allowAction, cancelAction].forEach(alert.addAction(_:))
        
        present(alert, animated: true)
    }
}

// MARK: - CoreLocation
extension ListViewController: CLLocationManagerDelegate {
    private func setupCoreLocationAuthority() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        
        switch locationManager?.authorizationStatus {
        case .denied:
            presentLocationAlert()
        case .notDetermined, .restricted:
            locationManager?.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            break
        default:
            break
        }
        
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            let geocoder = CLGeocoder()
            let locale = Locale(identifier: "Ko-kr")
            let userLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            
            geocoder.reverseGeocodeLocation(
                userLocation,
                preferredLocale: locale
            ) { [weak self] placeMarks, error in
                
                if let address: [CLPlacemark] = placeMarks,
                   let locale = address.last?.locality,
                   let subLocale: String = address.last?.subLocality {
                    
                    self?.viewModel.setUserLocation(locale: locale, subLocale: subLocale)
                }
            }
        }
        
        locationManager?.stopUpdatingLocation()
    }
}

// MARK: - CollectionView SetUp
extension ListViewController {
    private func registerCell() {
        collectionView.register(
            ListCollectionViewCell.self,
            forCellWithReuseIdentifier: ListCollectionViewCell.identifier
        )
        
        collectionView.register(
            GridCollectionViewCell.self,
            forCellWithReuseIdentifier: GridCollectionViewCell.identifier
        )
        
        collectionView.register(
            BannerCollectionViewCell.self,
            forCellWithReuseIdentifier: BannerCollectionViewCell.identifier
        )
    }
    
    private func collectionViewLayoutChange(type: CollectionType) -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        switch type {
        case .list:
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1 / 8)
            )
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            let layout = UICollectionViewCompositionalLayout(section: section)
            
            return layout
        case .grid:
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1 / 2.5)
            )
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
            let spacing = CGFloat(10)
            group.interItemSpacing = .fixed(spacing)
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 10
            
            let layout = UICollectionViewCompositionalLayout(section: section)
            
            return layout
        }
    }
}

// MARK: - UI SetUp
extension ListViewController {
    private func setupNavigation() {
        title = Constant.title
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemBackground
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        let addBarButtonItem = UIBarButtonItem(
            title: Constant.add,
            style: .plain,
            target: self,
            action: #selector(addButtonTapped)
        )
        
        addBarButtonItem.tintColor = .label
        navigationItem.rightBarButtonItem = addBarButtonItem
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        [headerView, collectionView].forEach(view.addSubview(_:))
    }
    
    private func setupConstraint() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            
            headerView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            headerView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.1),
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: 10)
        ])
    }
}

extension ListViewController {
    private enum Constant {
        static let title = "K-Market"
        static let add = "+"
        static let allow = "허용"
        static let reject = "거부"
    }
}
