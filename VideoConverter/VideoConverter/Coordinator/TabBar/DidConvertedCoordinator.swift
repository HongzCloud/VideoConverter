//
//  DidConvertedCoordinator.swift
//  VideoConverter
//
//  Created by 오킹 on 2021/12/10.
//

import UIKit
import Toast_Swift

protocol DidConvertedCoordinatorDependencies {
    func makeDidConvertedViewController() -> DidConvertedViewController
    func makeShareViewController(activityItems: [Any], applicationActivities: [UIActivity]?) -> UIActivityViewController
    func makePlayerViewController(assetManager: AssetManager, tappedIndex: Int) -> PlayerViewController
}

final class DidConvertedCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    private let dependencies: DidConvertedCoordinatorDependencies
    
    init(dependencies: DidConvertedCoordinatorDependencies) {
        self.navigationController = UINavigationController()
        self.dependencies = dependencies
    }
    
    func start() {
        navigationController.isNavigationBarHidden = true
        
        let vc = dependencies.makeDidConvertedViewController()
        vc.tabBarItem = UITabBarItem(title: "After", image: UIImage(systemName: "music.note.list"), tag: 1)
        vc.coordinate(to: self)
        
        self.navigationController.pushViewController(vc, animated: true)
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
