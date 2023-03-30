//
//  UseCaseDIContainer.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/20.
//

import Foundation

final class SceneDIContainer {
    struct ServiceDependencies {
        let apiDataService: NetworkSevice
        let locationDataService: FireBaseService
        let wrapperDataService: CacheService
    }
    
    private let serviceDependencies: ServiceDependencies
    
    private lazy var productRepository: ProductRepository = makeProductRepository()
    private lazy var locationRepository: LocationRepository = makeLocationRepository()
    private lazy var wrapperdataRepository: WrapperDataRepository = makeWrapperDataRepository()
    
    init(serviceDependencies: ServiceDependencies) {
        self.serviceDependencies = serviceDependencies
    }
    
    // MARK: - Make Repository
    func makeProductRepository() -> ProductRepository {
        return DefaultProductRepository(networkService: serviceDependencies.apiDataService)
    }
    
    func makeLocationRepository() -> LocationRepository {
        return DefaultLocationRepository(service: serviceDependencies.locationDataService)
    }
    
    func makeWrapperDataRepository() -> WrapperDataRepository {
        return DefaultWrapperDataRepository(cacheService: serviceDependencies.wrapperDataService)
    }
    
    // MARK: - Make UseCase
    func makeLoadImageUseCase() -> LoadImageUseCase {
        return DefaultLoadImageUseCase(productRepository: productRepository)
    }
    
    func makeFetchProductListUseCase() -> FetchProductListUseCase {
        return DefaultFetchProductUseCase(productRepository: productRepository)
    }
    
    func makeFetchLocationUseCase() -> FetchLocationUseCase {
        return DefaultFetchLocationDataUseCase(locationRepository: locationRepository)
    }
    
    func makeFetchProductDetailUseCase() -> FetchProductDetailUseCase {
        return DefaultFetchProductDetailUseCase(productRepository: productRepository)
    }
    
    func makePostProductUseCase() -> PostProductUseCase {
        return DefaultPostProductUseCase(productRepository: productRepository)
    }
    
    func makePostLocationUseCase() -> PostLocationUseCase {
        return DefaultPostLocationUseCase(locationRepository: locationRepository)
    }
    
    func makePatchProductUseCase() -> PatchProductUseCase {
        return DefaultPatchProductUseCase(productRepository: productRepository)
    }
    
    func makeDeleteProductUseCase() -> DeleteProductUseCase {
        return DefaultDeleteProductUseCase(productRepository: productRepository)
    }
    
    func makeDeleteLocationUseCase() -> DeleteLocationUseCase {
        return DefaultDeleteLocationUseCase(locationRepository: locationRepository)
    }
    
    func makeCheckWrapperDataUseCase() -> CheckWrapperDataUseCase {
        return DefaultCheckWrapperDataUseCase(wrapperDataRepository: wrapperdataRepository)
    }
}


// MARK: - Manage ViewModel DI
extension SceneDIContainer: ViewModelDIManageable {
    func makeListViewModel() -> ListViewModel {
        return DefaultListViewModel(
            fetchUseCase: makeFetchProductListUseCase(),
            loadImageUseCase: makeLoadImageUseCase(),
            fetchLocationUseCase: makeFetchLocationUseCase(),
            checkWrapperDataUseCase: makeCheckWrapperDataUseCase()
        )
    }
    
    func makeDetailViewModel(id: Int) -> DetailViewModel {
        return DefaultDetailViewModel(
            id: id,
            fetchLocationUseCase: makeFetchLocationUseCase(),
            fetchProductDetailUseCase: makeFetchProductDetailUseCase(),
            loadImageUseCase: makeLoadImageUseCase(),
            deleteProductUseCase: makeDeleteProductUseCase(),
            deleteLocationUseCase: makeDeleteLocationUseCase()
        )
    }
    
    func makeAddViewModel(locale: String, subLocale: String) -> AddViewModel {
        return DefaultAddViewModel(
            locale: locale,
            subLocale: subLocale,
            postProductUseCase: makePostProductUseCase(),
            postLocationUseCase: makePostLocationUseCase()
        )
    }
    
    func makeEditViewModel(product: Product, imagesData: [Data]) -> EditViewModel {
        return DefaultEditViewModel(
            product: product, imagesData: imagesData, patchProductUseCase: makePatchProductUseCase())
    }
}

// MARK: - ViewModel Inject Protocol
protocol ViewModelDIManageable {
    func makeListViewModel() -> ListViewModel
    func makeDetailViewModel(id: Int) -> DetailViewModel
    func makeAddViewModel(locale: String, subLocale: String) -> AddViewModel
    func makeEditViewModel(product: Product, imagesData: [Data]) -> EditViewModel
}
