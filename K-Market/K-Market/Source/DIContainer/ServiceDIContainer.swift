//
//  ServiceDIContainer.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/20.
//

import Foundation

final class ServiceDiContainer {
    private let apiDataService: NetworkSevice = DefaultNetworkSevice()
    private let locationDataService: FireBaseService = DefaultFireBaseService()
    
    // MARK: - DIContainers of Scenes
    func makeSceneDIContainer() -> SceneDIContainer {
        let dependencies = SceneDIContainer.ServiceDependencies(
            apiDataService: apiDataService,
            locationDataService: locationDataService
        )
        
        return SceneDIContainer(serviceDependencies: dependencies)
    }
}
