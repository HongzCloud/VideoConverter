//
//  CustomTabBarController.swift
//  VideoConverter
//
//  Created by 오킹 on 2021/11/27.
//

import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.unselectedItemTintColor = .gray
        self.tabBar.tintColor = .mint
    }
}
