//
//  PlayerView.swift
//  VideoConverter
//
//  Created by 오킹 on 2021/11/21.
//

import UIKit

class PlayerView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = .black
    }
}
