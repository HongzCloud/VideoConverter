//
//  ConvertView.swift
//  VideoConverter
//
//  Created by 오킹 on 2021/11/15.
//

import UIKit
import Lottie

protocol ConvertViewDelegate: AnyObject {
    func didTappedConvertButton(_ convertView: ConvertView)
}

class ConvertView: UIView {

    weak var delegate: ConvertViewDelegate?
    private(set) var index: Int!
    
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
        button.tintColor = .greenAndMint
        button.setImage(UIImage(systemName: "arrow.right.circle.fill"), for: .normal)
        let symbolSize = UIImage.SymbolConfiguration.init(pointSize: 50)
        button.setPreferredSymbolConfiguration(symbolSize, forImageIn: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTappedConvertButton(_:)), for: .touchUpInside)
        return button
    }()
    
    private let convertAnimationView = AnimationView(name: "92631-lunarcrushsippner")
    
    private(set) var didConvertedExtensionNamePickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()

    private let topLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUIObject()
        self.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUIObject()
    }
    
    private func setUIObject() {
        setConvertButton()
        setCurrentExtensionNameLabelConstraints()
        setDidConvertedExtensionNamePickerViewConstraints()
        setUnderLineView()
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
        self.addSubview(didConvertedExtensionNamePickerView)
        
        NSLayoutConstraint.activate([
            self.didConvertedExtensionNamePickerView.leadingAnchor.constraint(equalTo: self.convertButton.trailingAnchor),
            self.didConvertedExtensionNamePickerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.didConvertedExtensionNamePickerView.topAnchor.constraint(equalTo: self.topAnchor),
            self.didConvertedExtensionNamePickerView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func setUnderLineView() {
        self.addSubview(topLineView)
        
        NSLayoutConstraint.activate([
            self.topLineView.heightAnchor.constraint(equalToConstant: 1),
            self.topLineView.topAnchor.constraint(equalTo: self.topAnchor),
            self.topLineView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.topLineView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    func startConvertAnimation() {
        convertButton.addSubview(convertAnimationView)
        convertAnimationView.frame = convertAnimationView.superview!.bounds
        convertAnimationView.contentMode = .scaleAspectFit
        convertAnimationView.play(fromProgress: .leastNormalMagnitude,
                                  toProgress: .greatestFiniteMagnitude,
                                  loopMode: .loop,
                                  completion: { _ in
            self.activateConvertButton()
        })
        convertAnimationView.loopMode = .loop
    }
    
    func endConvertAnimation() {
        convertAnimationView.pause()
        convertAnimationView.removeFromSuperview()
    }
    
    @objc
    func didTappedConvertButton(_ sender: UIButton!) {
        self.delegate?.didTappedConvertButton(self)
        self.deactivateConvertButton()
    }
    
    func configure(currentFormat: String, index: Int) {
        self.currentExtensionNameLabel.text = currentFormat
        self.index = index
    }
    
    func activateConvertButton() {
        self.convertButton.isEnabled = true
    }
    
    func deactivateConvertButton() {
        self.convertButton.isEnabled = false
    }
}
