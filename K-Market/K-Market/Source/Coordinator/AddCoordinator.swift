//
//  AddCoordinator.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/20.
//

import UIKit

protocol AddCoordinator: Coordinator {
    func didFinish()
}

final class DefaultAddCoordinator: AddCoordinator {
    var parentCoordinator: ListCoordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    private let locale: String
    private let subLocale: String
    
    private let viewModelDIContainer: ViewModelDIManageable
    
    init(
        locale: String,
        subLocale: String,
        navigationController: UINavigationController,
        viewModelDIContainer: ViewModelDIManageable
    ) {
        self.locale = locale
        self.subLocale = subLocale
        self.navigationController = navigationController
        self.viewModelDIContainer = viewModelDIContainer
    }
    
    func start() {
        let viewController = AddViewController(
            viewModel: viewModelDIContainer.makeAddViewModel(locale: locale, subLocale: subLocale)
        )
        
        viewController.coordinator = self
        
        navigationController.pushViewController(viewController, animated: true)
    }

    func didFinish() {
        parentCoordinator?.childDidFinish(self)
    }
}
