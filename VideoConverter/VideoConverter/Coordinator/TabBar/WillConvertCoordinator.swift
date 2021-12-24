//
//  WillConvertTabBarCoordinator.swift
//  VideoConverter
//
//  Created by 오킹 on 2021/12/08.
//

import UIKit
import AVFoundation
import Toast_Swift

protocol WillConvertCoordinatorDependencies {
    func makeWillConvertViewController() -> WillConvertViewController
    func makeVideoListViewController() -> VideoListViewController
    func makeShareViewController(activityItems: [Any], applicationActivities: [UIActivity]?) -> UIActivityViewController
    func makePlayerViewController(assetManager: AssetManager, tappedIndex: Int) -> PlayerViewController
}

final class WillConvertCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    private let dependencies: WillConvertCoordinatorDependencies
    private var defaultViewController: WillConvertViewController
    
    init(dependencies: WillConvertCoordinatorDependencies) {
        self.navigationController = UINavigationController()
        self.dependencies = dependencies
        self.defaultViewController = dependencies.makeWillConvertViewController()
    }
    
    func start() {
        navigationController.isNavigationBarHidden = true
        
        let vc = defaultViewController
        vc.tabBarItem = UITabBarItem(title: "Before", image: UIImage(systemName: "list.and.film"), tag: 0)
     
        vc.coordinate(to: self)
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func presentVideoListViewController() {
        let videoListVC = dependencies.makeVideoListViewController()
        videoListVC.coordinator = self
        videoListVC.modalPresentationStyle = .fullScreen
        self.navigationController.present(videoListVC, animated: true, completion: nil)
    }
    
    func presentPlayerViewController(assetManager: AssetManager, tappedIndex: Int) {
        let svc = dependencies.makePlayerViewController(assetManager: assetManager, tappedIndex: tappedIndex)
        
        svc.setPlayer(assetManager: assetManager, tappedIndex: tappedIndex)
        svc.modalPresentationStyle = .fullScreen
        self.navigationController.present(svc, animated: true)
    }
    
    func presentShareViewController(url: URL) {
        self.navigationController.view.makeToastActivity(.center)

        var shareObject = [Any]()
        shareObject.append(url)
        
        let actVC = dependencies.makeShareViewController(activityItems: shareObject, applicationActivities: nil)
        actVC.popoverPresentationController?.sourceView = self.navigationController.view
        
        self.navigationController.view.hideToastActivity()
        self.navigationController.present(actVC, animated: true, completion: nil)
        
        actVC.completionWithItemsHandler = {
            (activityType: UIActivity.ActivityType?,
             completed: Bool,
             arrayReturnedItems: [Any]?,
             error: Error?) in
            
            var style = ToastStyle()
            style.messageColor = .greenAndMint!
            
            if completed {
                self.navigationController.view.makeToast("성공",
                                                         duration: 2,
                                                         point: CGPoint(x: self.navigationController.view.center.x, y: self.navigationController.view.center.y * 3/2),
                                                         title: nil,
                                                         image: nil,
                                                         style: style,
                                                         completion: nil)
            } else {
                if let shareError = error {
                    self.navigationController.view.makeToast("실패",
                                                             duration: 2,
                                                             point: CGPoint(x: self.navigationController.view.center.x, y: self.navigationController.view.center.y * 3/2),
                                                             title: nil,
                                                             image: nil,
                                                             style: style,
                                                             completion: nil)
                    Log.info("공유 실패:", shareError.localizedDescription)
                }
            }
        }
    }
}

extension WillConvertCoordinator: VideoSavingDelegate {

    func startVideoSaving() {
        var style = ToastStyle()
        style.messageColor = .greenAndMint!
        
        let toast = try? self.navigationController.view.toastViewForMessage("비디오 가져오는 중", title: nil, image: nil, style: style)
        
        if let toast = toast {
            self.navigationController.view.showToast(toast, point: CGPoint(x: self.navigationController.view.center.x, y: self.navigationController.view.center.y/3))
        }
    }
    
    func completeVideoSaving(asset: AVAsset) {
        self.navigationController.view.hideToast()
        self.defaultViewController.addVideo(asset)
    }
}
