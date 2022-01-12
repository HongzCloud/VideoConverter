//
//  AppFlowCoordinator.swift
//  VideoConverter
//
//  Created by 오킹 on 2021/12/08.
//
import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get }
}

protocol AppFlowCoordinatorDependencies {
    func makeMainTabBarCoordinator(navigation: UINavigationController) -> MainTabBarCoordinator
}

final class AppFlowCoordinator: Coordinator {

    var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    
    init(navigationController: UINavigationController,
         appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }

    func start() {
        let flow = appDIContainer.makeMainTabBarCoordinator(navigation: navigationController)
        flow.start()
    }
}
