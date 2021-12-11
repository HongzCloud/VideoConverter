//
//  WillConvertTabBarCoordinator.swift
//  VideoConverter
//
//  Created by 오킹 on 2021/12/08.
//

import UIKit
import Toast_Swift

protocol WillConvertCoordinatorDependencies {
    func makeWillConvertViewController() -> WillConvertViewController
    func makeVideoListViewController() -> VideoListViewController
    func makeShareViewController(activityItems: [Any], applicationActivities: [UIActivity]?) -> UIActivityViewController
    func makePlayerViewControll(url: URL) -> PlayerViewController
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
    
    func presentPlayerViewController(url: URL) {
        let svc = dependencies.makePlayerViewControll(url: url)
        
        svc.setPlayer(url: url)
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
            
            if completed {
                self.navigationController.view.makeToast("공유 성공")
            } else {
                if error != nil {
                    self.navigationController.view.makeToast("공유 실패")
                }
            }
            if let shareError = error { print(shareError)} }
    }
}

extension WillConvertCoordinator: VideoSavingDelegate {
    
    func showVideoSavingToast() {
        var style = ToastStyle()
        style.messageColor = .mint!
        
        let toast = try? self.navigationController.view.toastViewForMessage("비디오 가져오는 중", title: nil, image: nil, style: style)
        
        if let toast = toast {
            self.navigationController.view.showToast(toast, point: CGPoint(x: self.navigationController.view.center.x, y: self.navigationController.view.center.y/3))
        }
    }
    
    func hideVideoSavingToast() {
        self.navigationController.view.hideToast()
        self.defaultViewController.refresh()
    }
}
