//
//  MainTabBarController.swift
//  VideoConverter
//
//  Created by 오킹 on 2021/11/27.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.unselectedItemTintColor = .gray
        self.tabBar.tintColor = .mint
    }
    
    static func create() -> MainTabBarController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as? MainTabBarController else {
            return MainTabBarController()
        }
        return vc
    }
}
