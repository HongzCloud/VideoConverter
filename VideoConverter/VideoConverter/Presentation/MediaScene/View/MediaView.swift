//
//  MediaView.swift
//  VideoConverter
//
//  Created by 오킹 on 2021/11/13.
//

import UIKit

protocol MediaViewDelegate: AnyObject {
    func didTappedPlayButton(selectedIndex: Int)
    func didTappedMediaShareButton(selectedIndex: Int)
}

class MediaView: UIView {
    
    private var index: Int = 0
    private let mediaImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let mediaNameLabel: UILabel = {
        let mediaNameLabel = UILabel()
        mediaNameLabel.translatesAutoresizingMaskIntoConstraints = false
        return mediaNameLabel
    }()
    
    private let mediaDurationLabel: UILabel = {
        let mediaDurationLabel = UILabel()
        mediaDurationLabel.translatesAutoresizingMaskIntoConstraints = false
        return mediaDurationLabel
    }()
    
    private let mediaPlayButton: UIButton = {
        let mediaPlayButton = UIButton()
        mediaPlayButton.addTarget(self, action: #selector(didTappedMediaPlayButton(_:)), for: .touchUpInside)
        mediaPlayButton.translatesAutoresizingMaskIntoConstraints = false
        return mediaPlayButton
    }()
    
    private let mediaShareButton: UIButton = {
        let mediaShareButton = UIButton()
        mediaShareButton.addTarget(self, action: #selector(didTappedMediaShareButton(_:)), for: .touchUpInside)
        mediaShareButton.translatesAutoresizingMaskIntoConstraints = false
        return mediaShareButton
    }()
    
    weak var delegate: MediaViewDelegate?
    private var constant: CGFloat = 5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUIObject()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUIObject() 
    }
    
    private func setUIObject() {
        setMediaImageViewConstraints()
        setMediaShareButtonConstraints()
        setMediaPlayButtonConstraints()
        setMediaNameLabelConstraints()
        setMediaDurationLabelConstraints()
    }
    
    private func setMediaImageViewConstraints() {
        mediaImageView.backgroundColor = .darkGray
        mediaImageView.layer.cornerRadius = 8
        mediaImageView.clipsToBounds = true
        
        self.addSubview(mediaImageView)
        NSLayoutConstraint.activate([
            mediaImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: constant),
            mediaImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: constant),
            mediaImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -constant),
            mediaImageView.widthAnchor.constraint(equalTo: self.mediaImageView.heightAnchor, multiplier: 1),
            mediaImageView.widthAnchor.constraint(lessThanOrEqualTo: self.mediaImageView.heightAnchor)
        ])
    }
    
    private func setMediaNameLabelConstraints() {
        self.addSubview(mediaNameLabel)
        NSLayoutConstraint.activate([
            mediaNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            mediaNameLabel.leadingAnchor.constraint(equalTo: self.mediaImageView.trailingAnchor, constant: constant*2),
            mediaNameLabel.trailingAnchor.constraint(equalTo: mediaPlayButton.leadingAnchor, constant: -constant)
        ])
    }
    
    private func setMediaPlayButtonConstraints() {
        mediaPlayButton.tintColor = .greenAndMint
        mediaPlayButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        
        self.addSubview(mediaPlayButton)
        NSLayoutConstraint.activate([
            mediaPlayButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            mediaPlayButton.trailingAnchor.constraint(equalTo: self.mediaShareButton.leadingAnchor),
            mediaPlayButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5),
            mediaPlayButton.widthAnchor.constraint(equalTo: self.mediaPlayButton.heightAnchor)
        ])
    }
    
    private func setMediaShareButtonConstraints() {
        mediaShareButton.tintColor = .grayAndWhite
        mediaShareButton.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        
        self.addSubview(mediaShareButton)
        NSLayoutConstraint.activate([
            mediaShareButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            mediaShareButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -constant),
            mediaShareButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5),
            mediaShareButton.widthAnchor.constraint(equalTo: self.mediaShareButton.heightAnchor)
        ])
    }
    
    private func setMediaDurationLabelConstraints() {
        mediaDurationLabel.font = UIFont.systemFont(ofSize: 12)

        self.addSubview(mediaDurationLabel)
        NSLayoutConstraint.activate([
            mediaDurationLabel.bottomAnchor.constraint(equalTo: mediaImageView.bottomAnchor),
            mediaDurationLabel.topAnchor.constraint(equalTo: mediaNameLabel.bottomAnchor),
            mediaDurationLabel.leadingAnchor.constraint(equalTo: mediaImageView.trailingAnchor, constant: constant*2),
            mediaDurationLabel.trailingAnchor.constraint(equalTo: self.mediaPlayButton.leadingAnchor, constant: -5)
        ])
    }
    
    @objc
    func didTappedMediaPlayButton(_ sender: UIButton!) {
        self.delegate?.didTappedPlayButton(selectedIndex: index)
    }
    
    @objc
    func didTappedMediaShareButton(_ sender: UIButton!) {
        self.delegate?.didTappedMediaShareButton(selectedIndex: index)
    }
    
    func configure(image: UIImage?, name: String, duration: String) {
        if image != nil {
            mediaImageView.image = image
        } else {
            mediaImageView.image = UIImage(systemName: "music.note")
            mediaImageView.tintColor = .black
            mediaImageView.contentMode = .center
        }
        self.mediaNameLabel.text = name
        self.mediaDurationLabel.text = duration
    }
    
    func setIndex(_ index: Int) {
        self.index = index
    }
}
