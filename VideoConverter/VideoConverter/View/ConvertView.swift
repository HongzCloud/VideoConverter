//
//  ConvertView.swift
//  VideoConverter
//
//  Created by 오킹 on 2021/11/15.
//

import UIKit

class ConvertView: UIView {

    private let currentExtensionNameLabel: UILabel = {
        let label = UILabel()
        label.text = "TEST.mp3"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let convertButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.backgroundColor = .darkGray
        button.tintColor = .black
        button.setImage(UIImage(systemName: "gobackward"), for: .normal)
        let symbolSize = UIImage.SymbolConfiguration.init(pointSize: 20)
        button.setPreferredSymbolConfiguration(symbolSize, forImageIn: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private(set) var didConvertedExtensionNamePickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUIObject()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUIObject()
    }
    
    private func setUIObject() {
        setConvertButton()
        setCurrentExtensionNameLabelConstraints()
        setDidConvertedExtensionNamePickerViewConstraints()
    }
    
    private func setCurrentExtensionNameLabelConstraints() {
        self.addSubview(currentExtensionNameLabel)
        NSLayoutConstraint.activate([
            self.currentExtensionNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.currentExtensionNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.currentExtensionNameLabel.trailingAnchor.constraint(equalTo: self.convertButton.leadingAnchor)
        ])
    }
    
    private func setConvertButton() {
        self.addSubview(convertButton)
        NSLayoutConstraint.activate([
            self.convertButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.convertButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.convertButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            self.convertButton.widthAnchor.constraint(equalTo: self.convertButton.heightAnchor, multiplier: 1)
        ])
    }
    
    private func setDidConvertedExtensionNamePickerViewConstraints() {
        self.didConvertedExtensionNamePickerView.backgroundColor = .lightGray
        
        self.addSubview(didConvertedExtensionNamePickerView)
        NSLayoutConstraint.activate([
            self.didConvertedExtensionNamePickerView.leadingAnchor.constraint(equalTo: self.convertButton.trailingAnchor),
            self.didConvertedExtensionNamePickerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.didConvertedExtensionNamePickerView.topAnchor.constraint(equalTo: self.topAnchor),
            self.didConvertedExtensionNamePickerView.bottomAnchor.constraint(equalTo: self.bottomAnchor)

        
        ])
    }
    
    func configure(currentFormat: String) {
        self.currentExtensionNameLabel.text = currentFormat
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
