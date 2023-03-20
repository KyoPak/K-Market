//
//  EditCoordinator.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/20.
//

import UIKit

protocol EditCoordinator: Coordinator {
    func didFinish()
}

final class DefaultEditCoordinator: EditCoordinator {
    var parentCoordinator: DetailCoordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    private let product: Product
    private let imageDatas: [Data]
    
    private let viewModelDIContainer: ViewModelDIManageable
    
    init(
        product: Product,
        imageDatas: [Data],
        navigationController: UINavigationController,
        viewModelDIContainer: ViewModelDIManageable
    ) {
        self.product = product
        self.imageDatas = imageDatas
        self.navigationController = navigationController
        self.viewModelDIContainer = viewModelDIContainer
    }
    
    func start() {
        let viewController = EditViewController(
            viewModel: viewModelDIContainer.makeEditViewModel(product: product, imagesData: imageDatas)
        )
        
        viewController.coordinator = self
        
        navigationController.pushViewController(viewController, animated: true)
    }

    func didFinish() {
        parentCoordinator?.childDidFinish(self)
    }
}
