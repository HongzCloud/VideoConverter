//
//  AppDIContainer.swift
//  VideoConverter
//
//  Created by 오킹 on 2021/12/08.
//

import Foundation
import UIKit

// MARK: - 앱 진입시 흐름 DIContainer

final class AppDIContainer: AppFlowCoordinatorDependencies {
    
    func makeMainTabBarCoordinator(navigation: UINavigationController) -> MainTabBarCoordinator {
        return MainTabBarCoordinator(navigationController: navigation, dependencies: self)
    }
}

// MARK: - 메인 탭바 흐름 DIContainer

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

// MARK: - 변환 전 관련 DIContainer

extension AppDIContainer: WillConvertCoordinatorDependencies {
    
    func makePlayerViewController(assetManager: AssetManager, tappedIndex: Int) -> PlayerViewController {
        return PlayerViewController.create(with: assetManager, tappedInex: tappedIndex)
    }
    
    func makeWillConvertViewController() -> WillConvertViewController {
        let viewModel = makeWillConvertViewModel()
        return WillConvertViewController.create(with: viewModel)
    }
    
    func makeVideoListViewController() -> VideoListViewController {
        return VideoListViewController.create()
    }
    
    func makeShareViewController(activityItems: [Any], applicationActivities: [UIActivity]?) -> UIActivityViewController {
        return UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
    }

    func makeWillConvertViewModel() -> WillConvertViewModel {
        let useCase = makeFetchMediaUseCase()
        return DefaultWillConvertViewModel(fetchMediaUseCase: useCase)
    }
}

// MARK: - 변환 후 관련 DIContainer

extension AppDIContainer: DidConvertedCoordinatorDependencies {

    func makeDidConvertedViewController() -> DidConvertedViewController {
        let usecase = makeFetchMediaUseCase()
        let viewModel = DefaultDidConvertViewModel(fetchMediaUseCase: usecase)
        return DidConvertedViewController.create(with: viewModel)
    }
}

// MARK: - Use Cases

extension AppDIContainer {

    func makeFetchMediaUseCase() -> FetchMediaUseCase {
        let repository = DefaultMediaRepository()
        return DefaultFetchMediaUseCase(mediaRepository: repository)
    }
}

// MARK: - Repository

extension AppDIContainer {

    func makeMediaRepository() -> MediaRepository {
        return DefaultMediaRepository()
    }
}
