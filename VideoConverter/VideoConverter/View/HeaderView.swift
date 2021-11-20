//
//  WillConvertTableHeaderView.swift
//  VideoConverter
//
//  Created by 오킹 on 2021/11/16.
//

import UIKit

protocol CustomHeaderViewDelegate: AnyObject {
    func didTappedPhotoLibraryButton()
    func didTappedExitButton()
    func didTappedSaveButton()
}

class HeaderView: UIView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let photoLibraryButton: UIButton = {
        let button = UIButton()
        button.tintColor = .blue
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        let symbolSize = UIImage.SymbolConfiguration.init(pointSize: 20)
        button.setPreferredSymbolConfiguration(symbolSize, forImageIn: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTappedPhotoLibraryButton(_:)), for: .touchUpInside)
        return button
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("저장", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTappedSaveButton(_:)), for: .touchUpInside)
        return button
    }()
    
    private let exitButton: UIButton = {
        let button = UIButton()
        button.tintColor = .blue
        button.setImage(UIImage(systemName: "multiply"), for: .normal)
        let symbolSize = UIImage.SymbolConfiguration.init(pointSize: 20)
        button.setPreferredSymbolConfiguration(symbolSize, forImageIn: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTappedExitButton(_:)), for: .touchUpInside)
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
        setTitleLabelConstraints()
        setPhotoLibraryButtonConstraints()
        setExitButton()
        setSaveButtonConstraints()
    }
    
    private func setTitleLabelConstraints() {
        self.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            self.titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    private func setPhotoLibraryButtonConstraints() {
        self.addSubview(photoLibraryButton)
        
        NSLayoutConstraint.activate([
            self.photoLibraryButton.topAnchor.constraint(equalTo: self.topAnchor),
            self.photoLibraryButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.photoLibraryButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
        ])
    }
    
    private func setSaveButtonConstraints() {
        self.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            self.saveButton.topAnchor.constraint(equalTo: self.topAnchor),
            self.saveButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.saveButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
        ])
    }
    
    private func setExitButton() {
        self.addSubview(exitButton)
        
        NSLayoutConstraint.activate([
            self.exitButton.topAnchor.constraint(equalTo: self.topAnchor),
            self.exitButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.exitButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15)
        ])
    }
    
    @objc func didTappedPhotoLibraryButton(_ sender: UIButton!) {
        delegate?.didTappedPhotoLibraryButton()
    }
    
    @objc func didTappedExitButton(_ sender: UIButton!) {
        delegate?.didTappedExitButton()
    }
    
    @objc func didTappedSaveButton(_ sender: UIButton!) {
        delegate?.didTappedSaveButton()
    }
    
    func configure(title: String, photoLibraryButtonIsHidden: Bool = true, exitButtonIsHidden: Bool = true, saveButtonIsHidden: Bool = true) {
        self.titleLabel.text = title
        self.photoLibraryButton.isHidden = photoLibraryButtonIsHidden
        self.exitButton.isHidden = exitButtonIsHidden
        self.saveButton.isHidden = saveButtonIsHidden
    }
}

extension CustomHeaderViewDelegate {
    func didTappedPhotoLibraryButton(){}
    func didTappedExitButton(){}
    func didTappedSaveButton(){}
}
