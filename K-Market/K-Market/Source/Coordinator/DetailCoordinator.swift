//
//  DetailCoordinator.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/20.
//

import UIKit

protocol DetailCoordinator: Coordinator {
    func makeEditCoordinator(product: Product, imageDatas: [Data])
    func childDidFinish(_ child: Coordinator?)
    func didFinish()
}

final class DefaultDetailCoordinator: DetailCoordinator {
    var parentCoordinator: ListCoordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    private let id: Int
    
    private let sceneDIContainer: SceneViewModelDependencies
    
    init(
        id: Int,
        navigationController: UINavigationController,
        sceneDIContainer: SceneViewModelDependencies
    ) {
        self.id = id
        self.navigationController = navigationController
        self.sceneDIContainer = sceneDIContainer
    }
    
    func start() {
        let viewController = DetailViewController(viewModel: sceneDIContainer.makeDetailViewModel(id: id))
        
        viewController.coordinator = self
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func makeEditCoordinator(product: Product, imageDatas: [Data]) {
        let coordinator = DefaultEditCoordinator(
            product: product,
            imageDatas: imageDatas,
            navigationController: navigationController,
            sceneDIContainer: sceneDIContainer
        )
        
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        
        coordinator.start()
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
    func didFinish() {
        parentCoordinator?.childDidFinish(self)
    }
}
