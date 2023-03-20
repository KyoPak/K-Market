//
//  Coordinator.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/20.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}

final class DefaultCoordinator: Coordinator {
    var parentCoordinator: Coordinator? = nil
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    private let serviceDIContainer: ServiceDiContainer
    
    init(navigationController: UINavigationController,
         serviceDIContainer: ServiceDiContainer
    ) {
        self.navigationController = navigationController
        self.serviceDIContainer = serviceDIContainer
    }
    
    func start() {
        let listCoordinator = DefaultListCoordinator(
            navigationController: navigationController,
            sceneDIContainer: serviceDIContainer.makeSceneDIContainer()
        )
        
        listCoordinator.parentCoordinator = self
        childCoordinators.append(listCoordinator)
        
        listCoordinator.start()
    }
}
