//
//  AppDIContainer.swift
//  VideoConverter
//
//  Created by 오킹 on 2021/12/08.
//

import Foundation
import UIKit

final class AppDIContainer: AppFlowCoordinatorDependencies {

    func makeMainTabBarCoordinator(navigation: UINavigationController) -> MainTabBarCoordinator {
        return MainTabBarCoordinator(navigationController: navigation, dependencies: self)
    }
}

extension AppDIContainer: MainTabBarCoordinatorDependencies {
    
    func makeMainTabBarController() -> MainTabBarController {
        return MainTabBarController.create()
    }
    
    func makeWillConvertCoordinator() -> WillConvertCoordinator {
        return WillConvertCoordinator(dependencies: self)
    }
    
    func makeDidConvertedCoordinator() -> DidConvertedCoordinator {
        return DidConvertedCoordinator(dependencies: self)
    }
}

extension AppDIContainer: WillConvertCoordinatorDependencies {
    
    func makePlayerViewControll(url: URL) -> PlayerViewController {
        return PlayerViewController.create(with: url)
    }
    
    
    func makeWillConvertViewController() -> WillConvertViewController {
        let assetManager = AssetManager(directoryPath: .willConvert)
        return WillConvertViewController.create(with: assetManager)
    }
    
    func makeVideoListViewController() -> VideoListViewController {
        return VideoListViewController.create()
    }
    
    func makeShareViewController(activityItems: [Any], applicationActivities: [UIActivity]?) -> UIActivityViewController {
        return UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
    }
}

extension AppDIContainer: DidConvertedCoordinatorDependencies {
    
    func makeDidConvertedViewController() -> DidConvertedViewController {
        let assetManager = AssetManager(directoryPath: .didConverted)
        return DidConvertedViewController.create(with: assetManager)
    }
}
