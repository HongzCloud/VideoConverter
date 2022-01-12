//
//  SelectMorePhotosButton.swift
//  VideoConverter
//
//  Created by 오킹 on 2021/12/23.
//

import UIKit

class SelectMorePhotosButton: UIButton {
    
    override func draw(_ rect: CGRect) {
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.size.height / 2
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }

    func setupButton() {
        self.layer.cornerRadius = 0.5 * self.bounds.size.width
        clipsToBounds = true
        let symbolSize = UIImage.SymbolConfiguration.init(pointSize: 25)
        self.setPreferredSymbolConfiguration(symbolSize, forImageIn: .normal)
        self.backgroundColor = .darkGray
        self.setImage(UIImage(systemName: "plus"), for: .normal)
        self.tintColor = .white
        self.alpha = 0.8
    }
}
