//
//  VideoListCollectionViewCell.swift
//  VideoConverter
//
//  Created by 오킹 on 2021/11/19.
//

import UIKit

class VideoListCollectionViewCell: UICollectionViewCell {
    
    private let thumbnail: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "music.note")
        imageView.backgroundColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let durationLabel: UILabel = {
        let duration = UILabel()
        duration.backgroundColor = .black
        duration.textColor = .white
        duration.text = "00:00"
        duration.translatesAutoresizingMaskIntoConstraints = false
        return duration
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
        setThumbnailConstraints()
        setDuraionLabel()
    }
    
    private func setThumbnailConstraints() {
        self.addSubview(thumbnail)
        
        let safeArea = self.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.thumbnail.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.thumbnail.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            self.thumbnail.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.thumbnail.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
    
    private func setDuraionLabel() {
        self.addSubview(durationLabel)
        
        let safeArea = self.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.durationLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -5),
            self.durationLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -5)
        ])
    }
    
    func configure(image: UIImage?, duration: String) {
        self.thumbnail.image = image
        self.durationLabel.text = duration
    }
}
extension VideoListCollectionViewCell {
    override var isSelected: Bool {
        didSet{
            if isSelected {
                self.alpha = 0.5
            }
            else {
                self.alpha = 1
            }
        }
    }

}
