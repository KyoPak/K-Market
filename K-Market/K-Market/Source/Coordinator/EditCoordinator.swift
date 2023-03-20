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
    
    private let sceneDIContainer: SceneViewModelDependencies
    
    init(
        product: Product,
        imageDatas: [Data],
        navigationController: UINavigationController,
        sceneDIContainer: SceneViewModelDependencies
    ) {
        self.product = product
        self.imageDatas = imageDatas
        self.navigationController = navigationController
        self.sceneDIContainer = sceneDIContainer
    }
    
    func start() {
        let viewController = EditViewController(
            viewModel: sceneDIContainer.makeEditViewModel(product: product, imagesData: imageDatas)
        )
        
        viewController.coordinator = self
        
        navigationController.pushViewController(viewController, animated: true)
    }

    func didFinish() {
        parentCoordinator?.childDidFinish(self)
    }
}
