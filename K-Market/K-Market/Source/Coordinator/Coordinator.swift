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
    
    private let viewModelDIContainer: ViewModelDIManageable
    
    init(navigationController: UINavigationController,
         viewModelDIContainer: ViewModelDIManageable
    ) {
        self.navigationController = navigationController
        self.viewModelDIContainer = viewModelDIContainer
    }
    
    func start() {
        let listCoordinator = DefaultListCoordinator(
            navigationController: navigationController,
            viewModelDIContainer: viewModelDIContainer
        )
        
        listCoordinator.parentCoordinator = self
        childCoordinators.append(listCoordinator)
        
        listCoordinator.start()
    }
}
