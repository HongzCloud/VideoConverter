//
//  DidConvertedCoordinator.swift
//  VideoConverter
//
//  Created by 오킹 on 2021/12/10.
//

import UIKit

protocol DidConvertedCoordinatorDependencies {
    func makeDidConvertedViewController() -> DidConvertedViewController
    func makeShareViewController(activityItems: [Any], applicationActivities: [UIActivity]?) -> UIActivityViewController
    func makePlayerViewControll(url: URL) -> PlayerViewController
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
        vc.tabBarItem = UITabBarItem(title: "After", image: UIImage(systemName: "list.and.film"), tag: 1)
        vc.coordinate(to: self)
        
        self.navigationController.pushViewController(vc, animated: true)
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
