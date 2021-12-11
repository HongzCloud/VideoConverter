//
//  MainTabBarCoordinator.swift
//  VideoConverter
//
//  Created by 오킹 on 2021/12/08.
//

import UIKit

protocol MainTabBarCoordinatorDependencies {
    func makeWillConvertCoordinator() -> WillConvertCoordinator
    func makeDidConvertedCoordinator() -> DidConvertedCoordinator
}

final class MainTabBarCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    private let dependencies: MainTabBarCoordinatorDependencies
    
    init(navigationController: UINavigationController, dependencies: MainTabBarCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
         let tabBarController = UITabBarController()
        let willConvertFlow = dependencies.makeWillConvertCoordinator()
        let didConvertedFlow = dependencies.makeDidConvertedCoordinator()
        willConvertFlow.start()
        didConvertedFlow.start()
        
        tabBarController.viewControllers = [willConvertFlow.navigationController,
                                            didConvertedFlow.navigationController]
 
        navigationController.setViewControllers([tabBarController], animated: false)
     }
}
