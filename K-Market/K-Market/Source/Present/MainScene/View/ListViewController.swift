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
    
    
    // MARK: - UI Properties
    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["LIST", "GRID"])
        control.selectedSegmentIndex = .zero
        control.layer.borderWidth = 1
        control.layer.borderColor = UIColor.systemBackground.cgColor
        control.setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: UIColor.label],
            for: UIControl.State.normal
        )
        control.setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: UIColor.systemBackground],
            for: UIControl.State.selected
        )
        control.selectedSegmentTintColor = .secondaryLabel
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: collectionViewLayoutChange(type: .list)
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - ETC
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
    
    @objc private func segmentedControlTapped(sender: UISegmentedControl) {
        viewModel.setLayoutType(layoutIndex: sender.selectedSegmentIndex)
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
        
        viewModel.bindSubLocale { [weak self] subLocale in
            self?.locationLabel.text = subLocale
        }
        
        viewModel.bindLayoutStatus { [weak self] collectionType in
            guard let self = self else { return }
            self.collectionView.collectionViewLayout = self.collectionViewLayoutChange(type: collectionType)
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
                    for: indexPath) as? ListCollectionViewCell
                else {
                    let errorCell = UICollectionViewCell()
                    return errorCell
                }
                cell = listCell
            case .grid:
                guard let gridCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: GridCollectionViewCell.identifier,
                    for: indexPath) as? GridCollectionViewCell
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
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
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
        [segmentedControl, locationLabel, collectionView].forEach(view.addSubview(_:))
        
        segmentedControl.addTarget(self, action: #selector(segmentedControlTapped), for: .valueChanged)
    }
    
    private func setupConstraint() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: safeArea.topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            
            locationLabel.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 5),
            locationLabel.leadingAnchor.constraint(equalTo: segmentedControl.leadingAnchor, constant: 5),
            
            collectionView.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: 10)
        ])
    }
}
