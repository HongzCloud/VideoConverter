//
//  WillConvertTableHeaderView.swift
//  VideoConverter
//
//  Created by 오킹 on 2021/11/16.
//

import UIKit

protocol CustomHeaderViewDelegate: AnyObject {
    func buttonTouched()
}

class WillConvertTableHeaderView: UIView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private(set) var photoLibraryButton: UIButton = {
        let button = UIButton()
        button.tintColor = .blue
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        let symbolSize = UIImage.SymbolConfiguration.init(pointSize: 20)
        button.setPreferredSymbolConfiguration(symbolSize, forImageIn: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTabButton(_:)), for: .touchUpInside)
        return button
    }()

    weak var delegate: CustomHeaderViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUIObject()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUIObject()
    }
    
    private func setUIObject() {
        setTitleLabelContraints()
        setPhotoLibraryButton()
    }
    
    private func setTitleLabelContraints() {
        self.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            self.titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    private func setPhotoLibraryButton() {
        self.addSubview(photoLibraryButton)
        
        NSLayoutConstraint.activate([
            self.photoLibraryButton.topAnchor.constraint(equalTo: self.topAnchor),
            self.photoLibraryButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.photoLibraryButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
        ])
    }
    
    @objc func didTabButton(_ sender: UIButton!) {
        delegate?.buttonTouched()
    }
    
    func configure(title: String, photoLibraryIsHidden: Bool) {
        self.titleLabel.text = title
        self.photoLibraryButton.isHidden = photoLibraryIsHidden
    }
}
