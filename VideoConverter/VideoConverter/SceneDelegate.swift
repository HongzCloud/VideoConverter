//
//  SceneDelegate.swift
//  VideoConverter
//
//  Created by 오킹 on 2021/10/20.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private let appDIContainer = AppDIContainer()
    private var appFlowCoordinator: AppFlowCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = true
        
        window?.rootViewController = navigationController
        appFlowCoordinator = AppFlowCoordinator(navigationController: navigationController, appDIContainer: appDIContainer)
     
        appFlowCoordinator?.start()
        window?.makeKeyAndVisible()
    }
}

