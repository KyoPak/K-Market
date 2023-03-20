//
//  ListCoordinator.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/20.
//

import UIKit

protocol ListCoordinator: Coordinator {
    func makeDetailCoordinator(id: Int)
    func makeAddCoordinator(locale: String, subLocale: String)
    func childDidFinish(_ child: Coordinator?)
}

final class DefaultListCoordinator: ListCoordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    private let viewModelDIContainer: ViewModelDIManageable
    
    init(
        navigationController: UINavigationController,
        viewModelDIContainer: ViewModelDIManageable
    ) {
        self.navigationController = navigationController
        self.viewModelDIContainer = viewModelDIContainer
    }
    
    func start() {
        let viewController = ListViewController(viewModel: viewModelDIContainer.makeListViewModel())
        viewController.coordinator = self
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func makeDetailCoordinator(id: Int) {
        let coordinator = DefaultDetailCoordinator(
            id: id,
            navigationController: navigationController,
            viewModelDIContainer: viewModelDIContainer
        )
        
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        
        coordinator.start()
    }
    
    func makeAddCoordinator(locale: String, subLocale: String) {
        let coordinator = DefaultAddCoordinator(
            locale: locale,
            subLocale: subLocale,
            navigationController: navigationController,
            viewModelDIContainer: viewModelDIContainer
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
}
