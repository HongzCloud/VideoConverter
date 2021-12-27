//
//  UIApplication+getMostTopViewController.swift
//  VideoConverter
//
//  Created by 오킹 on 2021/12/27.
//

import UIKit

extension UIApplication {

    class func getTopMostViewController() -> UIViewController? {
        
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        } else {
            return nil
        }
    }
}


