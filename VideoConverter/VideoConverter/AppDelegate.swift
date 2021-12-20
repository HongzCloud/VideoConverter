//
//  AppDelegate.swift
//  VideoConverter
//
//  Created by 오킹 on 2021/10/20.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FileHelper.shared.createInputOutputDirectory()
        return true
    }
}

