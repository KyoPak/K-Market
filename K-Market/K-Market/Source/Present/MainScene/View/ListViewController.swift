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
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Product>
    typealias SnapShot = NSDiffableDataSourceSnapshot<Section, Product>
    
    enum Section {
        case main
    }
    
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
    
    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
        headerView = HeaderView(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Action
extension ListViewController {
    @objc private func addButtonTapped() {
        
    }
}

// MARK: - Bind
extension ListViewController {
    func bindData() {
        viewModel.bindDataList { [weak self] datas in
            DispatchQueue.main.async {
                self?.applySnapshot(data: datas)
            }
        }
        
        viewModel.bindLayoutStatus { [weak self] collectionType in
            guard let self = self else { return }
            self.collectionView.collectionViewLayout = self.collectionViewLayoutChange(type: collectionType)
            self.collectionView.reloadData()
        }
    }
}

// MARK: - DataSource and SnapShot
extension ListViewController {
    private func configureDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, data in

            var cell: CollectionCell
            
            switch self.viewModel.layoutStatus {
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
            
            let cellViewModel = DefaultProductListCellViewModel(
                product: data,
                locationData: LocationData(
                    id: data.id,
                    locality: self.viewModel.userLocale,
                    subLocality: self.viewModel.userSubLocale
                ),
                loadImageUseCase: DefaultLoadImageUseCase(
                    productRepository: DefaultProductRepository(
                        networkService: DefaultNetworkSevice()
                    )
                ),
                fetchLocationDataUseCase: DefaultFetchLocationDataUseCase(
                    locationRepository: DefualtLocationRepository(
                        service: DefaultFireBaseService()
                    )
                )
            )
            
            cell.setupViewModel(cellViewModel)
            cell.setupBind()
            
            return cell
        }
        
        return dataSource
    }
    
    private func applySnapshot(data: [Product], animatingDifferences: Bool = true) {
        var snapshot = SnapShot()
        snapshot.appendSections([.main])
        snapshot.appendItems(data)
        snapshot.reloadSections([.main])
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    private func reloadSnapshot(data: [Product]) {
        var snapshot = SnapShot()
        snapshot.appendSections([.main])
        snapshot.appendItems(data)
        snapshot.reloadSections([.main])
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - Location Alert
extension ListViewController {
    private func presentLocationAlert() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "허용", style: .default) { _ in
            guard let settingURL = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(settingURL)
        }
        
        let cancel = UIAlertAction(title: "거부", style: .cancel)
        
        alert.addAction(action)
        alert.addAction(cancel)
        
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
        title = "K-Market"
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemBackground
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        let addBarButtonItem = UIBarButtonItem(
            title: "+",
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
