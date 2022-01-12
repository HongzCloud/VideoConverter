//
//  String+Localization.swift
//  VideoConverter
//
//  Created by 오킹 on 2021/12/26.
//

import Foundation

extension String {
    
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String
    {
        return NSLocalizedString(self, tableName: tableName, value: "\(self)", comment: "")
    }
}


